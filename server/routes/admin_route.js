const express = require("express");
const router = express.Router();

const {
  isAuthenticatedUser,
  authorizeRoles,
} = require("../middleware/authenticate");

const {
  getUser,
  getUsers,
  updateRole,
  deleteUser,
} = require("../controllers/admin_controller");

// Route: /api/admin

router
  .route("/user/:id")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getUser)
  .patch(isAuthenticatedUser, authorizeRoles("admin"), updateRole)
  .delete(isAuthenticatedUser, authorizeRoles("admin"), deleteUser);

router
  .route("/users")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getUsers);

module.exports = router;
