const mongoose = require("mongoose");

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Please enter product name!"],
      trim: true,
    },
    description: {
      type: String,
      required: [true, "Please enter product description!"],
      trim: true,
    },
    category: {
      type: mongoose.Schema.ObjectId,
      ref: "Category",
    },
    restaurant: {
      type: mongoose.Schema.ObjectId,
      ref: "Restaurant",
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
    price: {
      type: Number,
      required: [true, "Please enter product price!"],
    },
    isFeatured: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Product", productSchema);
