const express = require("express");
const router = express.Router();

const {
  isAuthenticatedUser,
  authorizeRoles,
} = require("../middleware/authenticate");

const {
  getProducts,
  getProduct,
  createProduct,
  updateProduct,
  deleteProduct,
  updateFeatured,
} = require("../controllers/product_controller");

router
  .route("/product")
  // .post(isAuthenticatedUser, authorizeRoles("admin"), createCategory);
  .post(createProduct);

router
  .route("/products")
  // .get(isAuthenticatedUser, authorizeRoles("admin"), getCategories);
  .get(getProducts);

router.route("/product/featured").patch(updateFeatured);

router
  .route("/product/:id")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getProduct)
  .patch(updateProduct)
  .delete(deleteProduct);

module.exports = router;
