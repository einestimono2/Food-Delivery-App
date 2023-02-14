const ErrorHandler = require("../utils/error_handler");
const catchAsyncError = require("../middleware/catch_async_error");
const User = require("../models/user_model");

// Get user by id
exports.getUser = catchAsyncError(async (req, res, next) => {
  const user = await User.findById(req.params.id);

  if (!user) {
    return next(new ErrorHandler(`User id: ${req.params.id} does not exist`, 400));
  }

  res.status(200).json({
    success: true,
    user,
  });
});

// Get all users
exports.getUsers = catchAsyncError(async (req, res, next) => {
  // const apiFeature = new ApiFeatures(User.find(), req.query).search().filter();
  // let users = await apiFeature.query;

  const users = await User.find();

  res.status(200).json({
    success: true,
    users,
  });
});

// Update role
exports.updateRole = catchAsyncError(async (req, res, next) => {
  const newRole = {
    role: req.body.role,
  };

  await User.findByIdAndUpdate(req.params.id, newRole, {
    new: true,
    runValidators: true,
    useFindAndModify: false,
  });

  res.status(200).json({
    success: true,
    message: "Update successful!",
  });
});

// Delete user
exports.deleteUser = catchAsyncError(async (req, res, next) => {
  const user = await User.findById(req.params.id);

  if (!user) {
    return next(
      new ErrorHandler(`User id: ${req.params.id} does not exist with`, 400)
    );
  }

  //   if (user.avatar.public_id) {
  //     const imageId = user.avatar.public_id;
  //     await cloudinary.v2.uploader.destroy(imageId);
  //   }

  await user.remove();

  res.status(200).json({
    success: true,
    message: "Delete successfully!",
  });
});
