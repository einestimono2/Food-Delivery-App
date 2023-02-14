const Restaurant = require("../models/restaurant_model");
const catchAsyncError = require("../middleware/catch_async_error");
const ErrorHandler = require("../utils/error_handler");

const cloudinary = require("cloudinary");

exports.getRestaurants = catchAsyncError(async (req, res, next) => {
  const restaurants = await Restaurant.find().populate("categories products");

  res.status(200).json({
    success: true,
    restaurants,
  });
});

exports.getRestaurant = catchAsyncError(async (req, res, next) => {
  const restaurant = await Restaurant.findById(req.params.id).populate(
    "categories products"
  );

  if (!restaurant)
    return next(
      new ErrorHandler(`Restaurant id: ${req.params.id} does not exist`, 400)
    );

  res.status(200).json({
    success: true,
    restaurant,
  });
});

exports.createRestaurant = catchAsyncError(async (req, res, next) => {
  let images = [];

  if (typeof req.body.images === "string") {
    images.push(req.body.images);
  } else {
    images = req.body.images;
  }

  const cloudinaryImages = [];
  for (let i = 0; i < images.length; i++) {
    const result = await cloudinary.v2.uploader.upload(images[i], {
      folder: "Food Delivery App/restaurants",
    });

    cloudinaryImages.push({
      public_id: result.public_id,
      url: result.secure_url,
    });
  }

  req.body.images = cloudinaryImages;

  let restaurant = await Restaurant.create(req.body);

  await restaurant.populate("categories products");

  res.status(200).json({
    success: true,
    restaurant,
  });
});

exports.updateRestaurant = catchAsyncError(async (req, res, next) => {
  let restaurant = await Restaurant.findById(req.params.id);

  if (!restaurant) {
    return next(new ErrorHandler("Restaurant not exist", 400));
  }

  let images = [];

  if (typeof req.body.images === "string") {
    images.push(req.body.images);
  } else {
    images = req.body.images;
  }

  if (images !== undefined) {
    // Remove old images
    for (let i = 0; i < room.images.length; i++) {
      await cloudinary.v2.uploader.destroy(room.images[i].public_id);
    }

    // Upload new images
    const cloudinaryImages = [];
    for (let i = 0; i < images.length; i++) {
      const result = await cloudinary.v2.uploader.upload(images[i], {
        folder: "Food Delivery App/restaurants",
      });

      cloudinaryImages.push({
        public_id: result.public_id,
        url: result.secure_url,
      });
    }

    req.body.images = cloudinaryImages;
  }

  // Update
  restaurant = await Restaurant.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
    useFindAndModify: false,
  });

  res.status(200).json({
    success: true,
    restaurant,
  });
});

exports.deleteRestaurant = catchAsyncError(async (req, res, next) => {
  const restaurant = await Restaurant.findById(req.params.id);

  if (!restaurant) {
    return next(new ErrorHandler("Restaurant not exist", 400));
  }

  for (let i = 0; i < restaurant.images.length; i++) {
    await cloudinary.v2.uploader.destroy(restaurant.images[i].public_id);
  }

  await restaurant.remove();

  res.status(200).json({
    success: true,
    message: "Successful delete",
  });
});

exports.addCategory = catchAsyncError(async (req, res, next) => {
  const { restaurantID, categoryID } = req.body;

  const restaurant = await Restaurant.findById(restaurantID);

  if (!restaurant) {
    return next(new ErrorHandler("Restaurant not exist", 400));
  }

  // Add category
  if (!restaurant.categories.includes(categoryID)) {
    restaurant.categories.push(categoryID);
  }

  await restaurant.save({ validateBeforeSave: false });

  await restaurant.populate("categories products");

  res.status(200).json({
    success: true,
    restaurant: restaurant,
  });
});

exports.deleteCategory = catchAsyncError(async (req, res, next) => {
  const { restaurantID, categoryID } = req.body;

  let restaurant = await Restaurant.findById(restaurantID);

  if (!restaurant) {
    return next(new ErrorHandler("Restaurant not exist", 400));
  }

  // Delete category
  restaurant.categories = restaurant.categories.filter(function (item) {
    return item.toString() !== categoryID;
  });

  await restaurant.save({ validateBeforeSave: false });

  await restaurant.populate("categories products");

  res.status(200).json({
    success: true,
    restaurant: restaurant,
  });
});

exports.updateOpeningHours = catchAsyncError(async (req, res, next) => {
  const { restaurantID, openingHours } = req.body;

  let restaurant = await Restaurant.findById(restaurantID);

  if (!restaurant) {
    return next(new ErrorHandler("Restaurant not exist", 400));
  }

  // Update hours
  restaurant.openingHours = openingHours;

  await restaurant.save({ validateBeforeSave: false });

  await restaurant.populate("categories products");

  res.status(200).json({
    success: true,
    restaurant: restaurant,
  });
});

exports.updatePopular = catchAsyncError(async (req, res, next) => {
  const { restaurantID } = req.body;

  let restaurant = await Restaurant.findById(restaurantID).populate(
    "categories products"
  );

  if (!restaurant) {
    return next(new ErrorHandler("Restaurant not exist", 400));
  }

  // Update hours
  restaurant.isPopular = !restaurant.isPopular;

  await restaurant.save({ validateBeforeSave: false });

  res.status(200).json({
    success: true,
    restaurant: restaurant,
  });
});
