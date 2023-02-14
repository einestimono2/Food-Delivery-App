const mongoose = require("mongoose");
const bcrypt = require("bcrypt");
const crypto = require("crypto");
const jwt = require("jsonwebtoken");

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Please enter your name!"],
      maxLength: [30, "Name can not exceed 30 characters!"],
      minLength: [2, "Name should have more than 2 characters!"],
      trim: true,
    },
    email: {
      type: String,
      required: [true, "Please enter your email address!"],
      trim: true,
      unique: true,
      lowercase: true,
      validate: {
        validator: (value) => {
          const regex =
            /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
          return value.match(regex);
        },
        message: "Please enter a valid email address!",
      },
    },
    password: {
      type: String,
      required: [
        function () {
          return !this.socialAuth;
        },
        "Please enter your password!",
      ],
      minLength: [6, "Password should be at least 6 characters!"],
      select: false,
    },
    socialAuth: {
      type: Boolean,
      default: false,
    },
    avatar: {
      type: String,
      default:
        "https://res.cloudinary.com/dtl1pdmw6/image/upload/v1663328190/constant/User_Image.png",
    },
    phoneNumber: String,
    role: {
      type: String,
      enum: {
        values: ["user", "admin"],
        message: `'{VALUE}' is not a valid role`,
      },
      default: "user",
    },
    resetPassword: {
      resetPasswordToken: String,
      resetPasswordExpire: Date,
      resetPasswordOTP: String,
    },
  },
  { timestamps: true }
);

// Password encryption: Mã hóa mật khẩu
userSchema.pre("save", async function (next) {
  if (!this.isModified("password") || this.password === undefined) {
    next();
  }

  this.password = await bcrypt.hash(this.password, 12);
});

// Token
userSchema.methods.getToken = function () {
  return jwt.sign({ id: this._id }, process.env.TOKEN_SECRET, {
    expiresIn: process.env.TOKEN_EXPIRE,
  });
};

// Compare password
userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};

// Generating password reset token
userSchema.methods.getResetPasswordToken = function (otp) {
  // Generating token
  const resetToken = crypto.randomBytes(20).toString("hex");

  // Hashing and adding resetPasswordToken to userSchema
  this.resetPassword.resetPasswordToken = crypto
    .createHash("sha256")
    .update(resetToken)
    .digest("hex");

  // Expire
  this.resetPassword.resetPasswordExpire = Date.now() + 15 * 60 * 1000; // 15 minutes

  // OTP verify
  this.resetPassword.resetPasswordOTP = otp;

  return resetToken;
};

module.exports = mongoose.model("User", userSchema);
