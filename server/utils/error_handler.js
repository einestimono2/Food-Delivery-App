class ErrorHandler extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;

    // Bắt stack-trace nơi xảy ra lỗi
    // Hiển thị chi tiết vị trí lỗi
    Error.captureStackTrace(this, this.constructor);
  }
}

module.exports = ErrorHandler;
