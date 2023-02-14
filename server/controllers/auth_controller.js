const jwt = require("jsonwebtoken");
const crypto = require("crypto");

const User = require("../models/user_model");
const catchAsyncError = require("../middleware/catch_async_error");
const ErrorHandler = require("../utils/error_handler");
const sendMail = require("../utils/send_mail");
const sendToken = require("../utils/send_token");

// Sign Up
exports.signUp = catchAsyncError(async (req, res, next) => {
  const { name, email, password } = req.body;

  // Check email
  let user = await User.findOne({ email });

  if (user) {
    return next(new ErrorHandler(`Email '${email}' already exists!`, 400));
  } else {
    user = new User({
      name: name,
      email: email,
      password: password,
    });
  }

  // Validate user
  await user.validate();

  // Generating OTP verification - 6 digits
  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  console.log(`OTP: ${otp}`);

  // Create activation token
  const activationToken = jwt.sign(
    { user: user, otp: otp },
    process.env.ACTIVATION_TOKEN_SECRET,
    { expiresIn: process.env.ACTIVATION_TOKEN_EXPIRE }
  );
  // console.log(`Activation Token: ${activationToken}`);

  // Send mail otp verification
  // await sendMail({
  //   email: email,
  //   subject: "Verify your account",
  //   name: name || email,
  //   otp: otp,
  //   title: "Welcome to Food Delivery App",
  //   content: `
  //     Thank you for choosing Food Delivery App.
  //     <br />
  //     Use the following OTP to complete your registration for email ${email}. This OTP generated at ${new Date(
  //     Date.now()
  //   ).toLocaleString()} and valid for ${process.env.ACTIVATION_TOKEN_EXPIRE.replace(
  //     /[^0-9]/g,
  //     ""
  //   )} minutes.
  //   `,
  // });

  res.status(200).json({
    success: true,
    message: "Register Success! Please check your email to verify account.",
    activationToken,
  });
});

// Active email
exports.activateEmail = catchAsyncError(async (req, res, next) => {
  const activationToken = req.params.token;
  const { otp } = req.body;

  // Verify activationToken
  const tokenData = jwt.verify(
    activationToken,
    process.env.ACTIVATION_TOKEN_SECRET
  );

  // Check OTP
  const isOTPVerification = otp === tokenData.otp;

  if (!isOTPVerification)
    return next(new ErrorHandler(`Invalid OTP! Please try again.`, 400));

  // Save user
  await new User(tokenData.user).save();

  res.status(200).json({
    success: true,
    message: "Account has been activated!",
  });
});

// Sign In
exports.signIn = catchAsyncError(async (req, res, next) => {
  const { email, password } = req.body;

  // Check email and password
  if (!email || !password)
    return next(new ErrorHandler("Please enter email or passworod!", 400));

  // Check email
  const user = await User.findOne({ email: email }).select("+password");
  if (!user)
    return next(
      new ErrorHandler("Email not exist! Please check your email again.", 400)
    );

  // Compare password
  const isPasswordMatched = await user.comparePassword(password);

  if (!isPasswordMatched)
    return next(new ErrorHandler("Password is incorrect!", 400));

  sendToken(user, 200, res);
});

// Sign Out
exports.signOut = catchAsyncError(async (req, res, next) => {
  res.clearCookie("token");

  res.status(200).json({
    success: true,
    message: "Logged Out.",
  });
});

// Forgot password
exports.forgotPassword = catchAsyncError(async (req, res, next) => {
  const user = await User.findOne({ email: req.body.email });

  // Check user
  if (!user)
    return next(
      new ErrorHandler("Email not exist! Please check your email again.", 400)
    );

  // Generating OTP verification - 6 digits
  const otp = Math.floor(100000 + Math.random() * 900000).toString();
  console.log(`OTP: ${otp}`);

  // Get reset password token
  const resetPasswordToken = user.getResetPasswordToken(otp);

  // Save user
  await user.save({ validateBeforeSave: false });

  // Send mail otp
  try {
    await sendMail({
      email: user.email,
      subject: "Reset your password",
      name: user.name || user.email,
      otp: otp,
      title: "Password Reset",
      content: `
        We've received a request to reset the password for the Food Delivery account associated with ${user.email}. No changes have been made to your account yet.
        <br />
        Use the following OTP to reset your password. OTP is valid for 15 minutes.
      `,
    });

    res.status(200).json({
      success: true,
      message: `Email sent to ${user.email} successfully, please check your email to reset password.`,
      resetPasswordToken,
    });
  } catch (error) {
    // Clear resetPassword
    user.resetPassword = undefined;
    await user.save({ validateBeforeSave: false });

    return next(new ErrorHandler(error.message, 500));
  }
});

// Reset password
exports.resetPassword = catchAsyncError(async (req, res, next) => {
  const { otp, newPassword } = req.body;

  // Check new password null
  if (!newPassword)
    return next(new ErrorHandler(`Please enter your new password.`, 400));

  // Get resetPasswordToken
  const resetPasswordToken = crypto
    .createHash("sha256")
    .update(req.params.token)
    .digest("hex");

  // Find user
  const user = await User.findOne({
    "resetPassword.resetPasswordToken": resetPasswordToken,
    "resetPassword.resetPasswordExpire": { $gt: Date.now() },
  });

  if (!user) {
    return next(
      new ErrorHandler(
        "Reset password token is invalid or has been expired",
        400
      )
    );
  }

  // Check OTP
  const isOTPResetPassword = otp === user.resetPassword.resetPasswordOTP;
  if (!isOTPResetPassword)
    return next(new ErrorHandler(`Invalid OTP! Please try again.`, 400));

  // Update password
  user.password = newPassword;
  user.resetPassword = undefined;

  // Save
  await user.save();

  res.status(200).json({
    success: true,
    message: "Password reset successful!",
  });
});

exports.verifyToken = catchAsyncError(async (req, res, next) => {
  const token = req.params.token;

  const tokenData = jwt.verify(token, process.env.TOKEN_SECRET);

  const user = await User.findById(tokenData.id);

  if (!user) return next(new ErrorHandler("Token invalid!", 400));

  res.status(200).json({
    success: true,
    user,
  });
});
