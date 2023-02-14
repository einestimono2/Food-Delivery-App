const mongoose = require("mongoose");

const restaurantSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Please enter restaurant name!"],
      trim: true,
    },
    description: {
      type: String,
      trim: true,
    },
    address: {
      name: {
        type: String,
        required: [true, "Please enter restaurant address!"],
        trim: true,
      },
      lat: {
        type: Number,
        required: [true, "Please enter restaurant latitude!"],
        trim: true,
      },
      lon: {
        type: Number,
        required: [true, "Please enter restaurant longitude!"],
        trim: true,
      },
    },
    tags: [
      {
        type: String,
        required: [true, "Please enter restaurant tag!"],
        trim: true,
      },
    ],
    categories: [
      {
        type: mongoose.Schema.ObjectId,
        ref: "Category",
      },
    ],
    products: [
      {
        type: mongoose.Schema.ObjectId,
        ref: "Product",
      },
    ],
    images: [
      {
        public_id: {
          type: String,
          required: true,
        },
        url: {
          type: String,
          required: true,
        },
      },
    ],
    openingHours: [
      {
        day: {
          type: String,
          trim: true,
        },
        openAt: Number,
        closeAt: Number,
        isOpen: Boolean,
      },
    ],
    isPopular: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Restaurant", restaurantSchema);
