const Product = require("../models/product_model");
const Restaurant = require("../models/restaurant_model");
const catchAsyncError = require("../middleware/catch_async_error");
const ErrorHandler = require("../utils/error_handler");

const cloudinary = require("cloudinary");

exports.getProducts = catchAsyncError(async (req, res, next) => {
  const products = await Product.find(); //.populate("restaurant"); //category

  res.status(200).json({
    success: true,
    products,
  });
});

exports.getProduct = catchAsyncError(async (req, res, next) => {
  const product = await Product.findById(req.params.id).populate(
    "restaurant category"
  );

  if (!category)
    return next(
      new ErrorHandler(`Product id: ${req.params.id} does not exist`, 400)
    );

  res.status(200).json({
    success: true,
    product,
  });
});

exports.createProduct = catchAsyncError(async (req, res, next) => {
  // Save image
  const result = await cloudinary.v2.uploader.upload(req.body.image, {
    folder: "Food Delivery App/products",
  });

  req.body.image = {
    public_id: result.public_id,
    url: result.secure_url,
  };

  // Error ==> Delete image
  const product = await Product.create(req.body).catch((e) => {
    cloudinary.v2.uploader.destroy(result.public_id);
    throw e;
  });

  // Save id - Restaurant model
  let restaurant = await Restaurant.findById(req.body.restaurant);
  if (!restaurant.products.includes(product._id)) {
    restaurant.products.push(product._id);
  }
  await restaurant.save({ validateBeforeSave: false });

  res.status(200).json({
    success: true,
    product,
  });
});

exports.updateProduct = catchAsyncError(async (req, res, next) => {
  let product = await Product.findById(req.params.id);

  if (!product) {
    return next(new ErrorHandler("Prodcut not exist", 400));
  }

  // Change image
  if (req.body.image !== undefined) {
    // Delete old image
    await cloudinary.v2.uploader.destroy(category.image.public_id);

    // Create new image
    const result = await cloudinary.v2.uploader.upload(req.body.image, {
      folder: "Food Delivery App/products",
    });

    req.body.image = {
      public_id: result.public_id,
      url: result.secure_url,
    };
  }

  product = await Product.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
    useFindAndModify: false,
  });

  res.status(200).json({
    success: true,
    product,
  });
});

exports.deleteProduct = catchAsyncError(async (req, res, next) => {
  let product = await Product.findById(req.params.id);

  if (!product) {
    return next(new ErrorHandler("Product not exist", 400));
  }

  // Delete image
  await cloudinary.v2.uploader.destroy(product.image.public_id);

  // Delete product in Restaurant
  let restaurant = await Restaurant.findById(product.restaurant);
  const index = restaurant.products.indexOf(product._id);
  restaurant.products.splice(index, 1);
  await restaurant.save({ validateBeforeSave: false });

  // Delete category
  await product.remove();

  res.status(200).json({
    success: true,
    message: "Successful delete",
  });
});

exports.updateFeatured = catchAsyncError(async (req, res, next) => {
  const { productID } = req.body;

  let product = await Product.findById(productID);

  if (!product) {
    return next(new ErrorHandler("Product not exist", 400));
  }

  product.isFeatured = !product.isFeatured;

  // Delete category
  await product.save({ validateBeforeSave: false });

  res.status(200).json({
    success: true,
    product: product,
  });
});
