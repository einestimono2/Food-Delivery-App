// Generating Token and store in cookie
module.exports = function (user, statusCode, res) {
  const token = user.getToken();

  // Create options for cookie
  const options = {
    // Get unix milliseconds at current time plus number of days
    // 1000 is milliseconds in each second
    expires: new Date(
      Date.now() + process.env.COOKIE_EXPIRE * 24 * 60 * 60 * 1000
    ),
    httpOnly: true,
  };

  return res
    .status(statusCode)
    .cookie("token", token, options)
    .json({
      success: true,
      user,
      token,
    });
};
