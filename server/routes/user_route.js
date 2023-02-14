const express = require("express");
const router = express.Router();

const { isAuthenticatedUser } = require("../middleware/authenticate");

const {
  myProfile,
  updateProfile,
  updatePassword,
} = require("../controllers/user_controller");

// Route: /api/user

router.route("/password").patch(isAuthenticatedUser, updatePassword);

router
  .route("/")
  .get(isAuthenticatedUser, myProfile)
  .patch(isAuthenticatedUser, updateProfile);

module.exports = router;
