const Discount = require("../models/discount_model");
const catchAsyncError = require("../middleware/catch_async_error");
const ErrorHandler = require("../utils/error_handler");

const cloudinary = require("cloudinary");

exports.getDiscount = catchAsyncError(async (req, res, next) => {
  const discount = await Discount.findById(req.params.id);

  if (!discount)
    return next(
      new ErrorHandler(`Discount id: ${req.params.id} does not exist`, 400)
    );

  res.status(200).json({
    success: true,
    discount,
  });
});

exports.getDiscounts = catchAsyncError(async (req, res, next) => {
  const discounts = await Discount.find();

  res.status(200).json({
    success: true,
    discounts,
  });
});

exports.createDiscount = catchAsyncError(async (req, res, next) => {
  // Image
  const result = await cloudinary.v2.uploader.upload(req.body.image, {
    folder: "Food Delivery App/discounts",
  });

  req.body.image = {
    public_id: result.public_id,
    url: result.secure_url,
  };

  // Error ==> Delete image
  const discount = await Discount.create(req.body).catch((e) => {
    cloudinary.v2.uploader.destroy(result.public_id);
    throw e;
  });

  res.status(200).json({
    success: true,
    discount,
  });
});

exports.updateDiscount = catchAsyncError(async (req, res, next) => {
  let discount = await Discount.findById(req.params.id);

  if (!discount) {
    return next(new ErrorHandler("Discount not exist", 400));
  }

  // Change image
  if (req.body.image !== undefined) {
    // Delete old image
    await cloudinary.v2.uploader.destroy(category.image.public_id);

    // Create new image
    const result = await cloudinary.v2.uploader.upload(req.body.image, {
      folder: "Food Delivery App/discounts",
    });

    req.body.image = {
      public_id: result.public_id,
      url: result.secure_url,
    };
  }

  discount = await Discount.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
    useFindAndModify: false,
  });

  res.status(200).json({
    success: true,
    discount,
  });
});

exports.deleteDiscount = catchAsyncError(async (req, res, next) => {
  let discount = await Discount.findById(req.params.id);

  if (!discount) {
    return next(new ErrorHandler("Discount not exist", 400));
  }

  // Delete image
  await cloudinary.v2.uploader.destroy(discount.image.public_id);

  // Delete category
  await discount.remove();

  res.status(200).json({
    success: true,
    message: "Successful delete",
  });
});
