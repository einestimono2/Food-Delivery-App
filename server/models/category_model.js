const mongoose = require("mongoose");

const categorySchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Please enter category name!"],
      trim: true,
    },
    description: {
      type: String,
      required: [true, "Please enter category description!"],
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

module.exports = mongoose.model("Category", categorySchema);
