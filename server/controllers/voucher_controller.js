const Voucher = require("../models/voucher_model");
const catchAsyncError = require("../middleware/catch_async_error");
const ErrorHandler = require("../utils/error_handler");

exports.getVoucher = catchAsyncError(async (req, res, next) => {
  const voucher = await Voucher.findById(req.params.id);

  if (!voucher)
    return next(
      new ErrorHandler(`Voucher id: ${req.params.id} does not exist`, 400)
    );

  res.status(200).json({
    success: true,
    voucher,
  });
});

exports.getVouchers = catchAsyncError(async (req, res, next) => {
  const vouchers = await Voucher.find().sort('code');

  res.status(200).json({
    success: true,
    vouchers,
  });
});

exports.createVoucher = catchAsyncError(async (req, res, next) => {
  const voucher = await Voucher.create(req.body);

  res.status(200).json({
    success: true,
    voucher,
  });
});

exports.updateVoucher = catchAsyncError(async (req, res, next) => {
  let voucher = await Voucher.findById(req.params.id);

  if (!voucher) {
    return next(new ErrorHandler("Voucher not exist", 400));
  }

  voucher = await Voucher.findByIdAndUpdate(req.params.id, req.body, {
    new: true,
    runValidators: true,
    useFindAndModify: false,
  });

  res.status(200).json({
    success: true,
    voucher,
  });
});

exports.deleteVoucher = catchAsyncError(async (req, res, next) => {
  let voucher = await Voucher.findById(req.params.id);

  if (!voucher) {
    return next(new ErrorHandler("Voucher not exist", 400));
  }

  // Delete
  await voucher.remove();

  res.status(200).json({
    success: true,
    message: "Successful delete",
  });
});
