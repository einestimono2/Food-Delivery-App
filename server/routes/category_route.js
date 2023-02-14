const express = require("express");
const router = express.Router();

const {
  isAuthenticatedUser,
  authorizeRoles,
} = require("../middleware/authenticate");

const {
  getCategory,
  getCategories,
  createCategory,
  updateCategory,
  deleteCategory,
} = require("../controllers/category_controller");

router
  .route("/category")
  // .post(isAuthenticatedUser, authorizeRoles("admin"), createCategory);
  .post(createCategory);

router
  .route("/categories")
  // .get(isAuthenticatedUser, authorizeRoles("admin"), getCategories);
  .get(getCategories);

router
  .route("/category/:id")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getCategory)
  .patch(updateCategory)
  .delete(deleteCategory);

module.exports = router;
