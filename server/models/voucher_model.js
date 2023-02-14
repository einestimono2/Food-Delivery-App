const mongoose = require("mongoose");

const vouchertSchema = new mongoose.Schema(
  {
    code: {
      type: String,
      required: [true, "Please enter code!"],
      trim: true,
    },
    value: {
      type: Number,
      required: [true, "Please enter value!"],
    },
    
  },
  { timestamps: true }
);

module.exports = mongoose.model("Voucher", vouchertSchema);
