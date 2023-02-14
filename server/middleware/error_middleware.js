const ErrorHandler = require("../utils/error_handler");

module.exports = (err, req, res, next) => {
  err.statusCode = err.statusCode || 500;
  err.message = err.message || "Internal Server Error";

  // Error: ValidationError -- mongoose
  if (err.name == "ValidationError") {
    // Get first error
    const firstError = err.errors[Object.keys(err.errors)[0]].message;
    err = new ErrorHandler(firstError, 400);
  }

  // Error: Wrong id in mongoDB
  if (err.name == "CastError") {
    const message = `Resource not found. Invalid ${err.path}`;
    err = new ErrorHandler(message, 400);
  }

  // Error: Duplicate key in mongoDB
  // "E11000 duplicate key error collection:
  // Ex: xxx.users index: email_1 dup key: { email: \"x@gmail.com\" }"
  if (err.code == 11000) {
    const message = `${Object.keys(err.keyValue)} already exists`;
    err = new ErrorHandler(message, 400);
  }

  // Wrong JWT error
  if (err.name === "JsonWebTokenError") {
    const message = `Token is invalid, Try again!`;
    err = new ErrorHandler(message, 400);
  }

  // JWT EXPIRE error
  if (err.name === "TokenExpiredError") {
    const message = `Token is expired. Try again!`;
    err = new ErrorHandler(message, 400);
  }

  res.status(err.statusCode).json({
    success: false,
    message: err.message,
  });
};
