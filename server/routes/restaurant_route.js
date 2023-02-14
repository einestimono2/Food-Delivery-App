const express = require("express");
const router = express.Router();

const {
  isAuthenticatedUser,
  authorizeRoles,
} = require("../middleware/authenticate");

const {
  createRestaurant,
  getRestaurants,
  getRestaurant,
  updateRestaurant,
  deleteRestaurant,
  addCategory,
  deleteCategory,
  updateOpeningHours,
  updatePopular,
} = require("../controllers/restaurant_controller");

router
  .route("/restaurant")
  // .post(isAuthenticatedUser, authorizeRoles("admin"), createCategory);
  .post(createRestaurant);

router
  .route("/restaurants")
  // .get(isAuthenticatedUser, authorizeRoles("admin"), getCategories);
  .get(getRestaurants);

router.route("/restaurant/category").post(addCategory).delete(deleteCategory);
router.route("/restaurant/hours").patch(updateOpeningHours);
router.route("/restaurant/popular").patch(updatePopular);

router
  .route("/restaurant/:id")
  .get(getRestaurant)
  .patch(updateRestaurant)
  .delete(deleteRestaurant);

module.exports = router;
