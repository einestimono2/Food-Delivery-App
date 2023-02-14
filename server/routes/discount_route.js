const express = require("express");
const router = express.Router();

const {
  isAuthenticatedUser,
  authorizeRoles,
} = require("../middleware/authenticate");

const {
  getDiscount,
  getDiscounts,
  createDiscount,
  updateDiscount,
  deleteDiscount,
} = require("../controllers/discount_controller");

router
  .route("/discount")
  // .post(isAuthenticatedUser, authorizeRoles("admin"), createCategory);
  .post(createDiscount);

router
  .route("/discounts")
  // .get(isAuthenticatedUser, authorizeRoles("admin"), getCategories);
  .get(getDiscounts);

router
  .route("/discount/:id")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getDiscount)
  .patch(updateDiscount)
  .delete(deleteDiscount);

module.exports = router;
