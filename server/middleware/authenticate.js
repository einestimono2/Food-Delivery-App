const jwt = require("jsonwebtoken");

const User = require("../models/user_model");
const ErrorHander = require("../utils/error_handler");
const catchAsyncErrors = require("./catch_async_error");

exports.isAuthenticatedUser = catchAsyncErrors(async (req, res, next) => {
  const { token } = req.cookies;

  if (!token) {
    return next(
      new ErrorHander("Your session has expired, please login again", 400)
    );
  }

  const decodedData = jwt.verify(token, process.env.TOKEN_SECRET);

  req.user = await User.findById(decodedData.id);

  next();
});

// Check role
exports.authorizeRoles = (...roles) => {
  return (req, res, next) => {
    if (!roles.includes(req.user.role)) {
      // Role: ${req.user.role} insufficient access rights
      return next(new ErrorHander("Insufficient access rights", 400));
    }

    next();
  };
};
