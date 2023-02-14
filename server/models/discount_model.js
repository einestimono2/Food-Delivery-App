const mongoose = require("mongoose");

const discountSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, "Please enter discount name!"],
      trim: true,
    },
    description: {
      type: String,
      required: [true, "Please enter discount description!"],
      trim: true,
    },
    image: {
      public_id: {
        type: String,
        required: true,
      },
      url: {
        type: String,
        required: true,
      },
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Discount", discountSchema);
