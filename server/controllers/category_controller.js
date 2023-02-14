const Category = require("../models/category_model");
const catchAsyncError = require("../middleware/catch_async_error");
const ErrorHandler = require("../utils/error_handler");

const cloudinary = require("cloudinary");

exports.getCategory = catchAsyncError(async (req, res, next) => {
  const category = await Category.findById(req.params.id);

  if (!category)
    return next(
      new ErrorHandler(`Category id: ${req.params.id} does not exist`, 400)
    );

  res.status(200).json({
    success: true,
    category,
  });
});

exports.getCategories = catchAsyncError(async (req, res, next) => {
  const categories = await Category.find().sort("name");

  res.status(200).json({
    success: true,
    categories,
  });
});

exports.createCategory = catchAsyncError(async (req, res, next) => {
  // Image
  const result = await cloudinary.v2.uploader.upload(req.body.image, {
    folder: "Food Delivery App/categories",
  });

  req.body.image = {
    public_id: result.public_id,
    url: result.secure_url,
  };

  // Error ==> Delete image
  const category = await Category.create(req.body).catch((e) => {
    cloudinary.v2.uploader.destroy(result.public_id);
    throw e;
  });

  res.status(200).json({
    success: true,
    category,
  });
});

exports.updateCategory = catchAsyncError(async (req, res, next) => {
  let category = await Category.findById(req.params.id);

  if (!category) {
    return next(new ErrorHandler("Category not exist", 400));
  }

  // Change image
  if (req.body.image !== undefined) {
    // Delete old image
    await cloudinary.v2.uploader.destroy(category.image.public_id);

    // Create new image
    const result = await cloudinary.v2.uploader.upload(req.body.image, {
      folder: "Food Delivery App/categories",
    });

    req.body.image = {
      public_id: result.public_id,
      url: result.secure_url,
    };
  }

  category = await Category.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
    useFindAndModify: false,
  });

  res.status(200).json({
    success: true,
    category,
  });
});

exports.deleteCategory = catchAsyncError(async (req, res, next) => {
  let category = await Category.findById(req.params.id);

  if (!category) {
    return next(new ErrorHandler("Category not exist", 400));
  }

  // Delete image
  await cloudinary.v2.uploader.destroy(category.image.public_id);

  // Delete category
  await category.remove();

  res.status(200).json({
    success: true,
    message: "Successful delete",
  });
});
