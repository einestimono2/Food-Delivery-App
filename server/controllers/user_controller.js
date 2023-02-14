const ErrorHandler = require("../utils/error_handler");
const catchAsyncError = require("../middleware/catch_async_error");
const User = require("../models/user_model");

// My profile
exports.myProfile = catchAsyncError(async (req, res, next) => {
  const user = await User.findById(req.user.id);

  res.status(200).json({
    success: true,
    user,
  });
});

// Update password
exports.updatePassword = catchAsyncError(async (req, res, next) => {
  const user = await User.findById(req.user.id).select("+password");

  const { oldPassword, newPassword } = req.body;

  if (!oldPassword || !newPassword)
    return next(new ErrorHandler("Please complete all information!", 400));

  // Compare password
  const isPasswordMatched = await user.comparePassword(oldPassword);
  if (!isPasswordMatched)
    return next(new ErrorHandler("Old password is incorrect!", 400));

  if (newPassword === oldPassword)
    return next(
      new ErrorHandler("New password must be different from old password!", 400)
    );

  // Update password
  user.password = newPassword;

  // Save password
  await user.save();

  res.status(200).json({
    success: true,
    message: "Change password successfully!",
  });
});

// Update profile
exports.updateProfile = catchAsyncError(async (req, res, next) => {
  const newProfile = {
    email: req.body.email,
  };

  if (req.body.name) newProfile.name = req.body.name;
  if (req.body.phoneNumber) newProfile.phoneNumber = req.body.phoneNumber;

  // if (req.body.avatar !== "") {
  //   const user = await User.findById(req.user.id);

  //   const imgID = user.avatar.public_id;
  //   if (imgID) await cloudinary.v2.uploader.destroy(imgID);

  //   const myCloud = await cloudinary.v2.uploader.upload(req.body.avatar, {
  //     folder: "avatars",
  //     width: 150,
  //     crop: "scale",
  //   });

  //   newProfile.avatar = {
  //     public_id: myCloud.public_id,
  //     url: myCloud.url,
  //   };
  // }

  await User.findByIdAndUpdate(req.user.id, newProfile, {
    new: true,
    runValidators: true,
    useFindAndModify: false,
  });

  res.status(200).json({
    success: true,
    message: "Update successful!",
  });
});
