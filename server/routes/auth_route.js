const express = require("express");
const router = express.Router();

const {
  signUp,
  activateEmail,
  signIn,
  signOut,
  forgotPassword,
  resetPassword,
  verifyToken,
} = require("../controllers/auth_controller");

// Route: /api/auth
router.route("/activation/:token").post(activateEmail);

router.route("/verify/:token").post(verifyToken);

router.route("/signup").post(signUp);

router.route("/signin").post(signIn);

router.route("/signout").get(signOut);

router.route("/forgot").post(forgotPassword);

router.route("/reset/:token").post(resetPassword);

module.exports = router;
