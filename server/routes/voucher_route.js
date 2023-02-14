const express = require("express");
const router = express.Router();

const {
  isAuthenticatedUser,
  authorizeRoles,
} = require("../middleware/authenticate");

const {
  getVoucher,
  getVouchers,
  createVoucher,
  updateVoucher,
  deleteVoucher,
} = require("../controllers/voucher_controller");

router
  .route("/voucher")
  // .post(isAuthenticatedUser, authorizeRoles("admin"), createCategory);
  .post(createVoucher);

router
  .route("/vouchers")
  // .get(isAuthenticatedUser, authorizeRoles("admin"), getCategories);
  .get(getVouchers);

router
  .route("/voucher/:id")
  .get(isAuthenticatedUser, authorizeRoles("admin"), getVoucher)
  .patch(updateVoucher)
  .delete(deleteVoucher);

module.exports = router;
