// Imports from package
const express = require("express");
const cookieParser = require("cookie-parser");
const bodyParser = require("body-parser");
const fileUpload = require("express-fileupload");
const cloudinary = require("cloudinary");

// Imports from other Files
const errorMiddleware = require("./middleware/error_middleware");
const connectDB = require("./config/database");
const auth = require("./routes/auth_route");
const user = require("./routes/user_route");
const admin = require("./routes/admin_route");
const category = require("./routes/category_route");
const restaurant = require("./routes/restaurant_route");
const product = require("./routes/product_route");
const voucher = require("./routes/voucher_route");
const discount = require("./routes/discount_route");

// Handling Uncaught Exception
process.on("uncaughtException", (err) => {
  console.log(`Error: ${err.message}`);
  console.log(`Shutting down the server due to Uncaught Exception`);
  process.exit(1);
});

// Unhandled Promise Rejection
process.on("unhandledRejection", (err) => {
  console.log(`Error: ${err.message}`);
  console.log(`Shutting down the server due to Unhandled Promise Rejection`);

  server.close(() => {
    process.exit(1);
  });
});

// Config
const dotenv = require("dotenv");
dotenv.config({ path: "./config/config.env" });
cloudinary.config({
  cloud_name: process.env.CLOUDINARY_NAME,
  api_key: process.env.CLOUDINARY_API_KEY,
  api_secret: process.env.CLOUDINARY_API_SECRET,
});

// Initial
const app = express();
const PORT = process.env.PORT || 2222;

// Middleware
app.use(express.json({ limit: "20mb", extended: true, parameterLimit: 20000 }));
app.use(cookieParser());
app.use(
  bodyParser.urlencoded({
    limit: "20mb",
    extended: true,
    parameterLimit: 20000,
  })
);
app.use(
  fileUpload({
    useTempFiles: true,
  })
);

// Routes
app.use("/api/auth", auth);
app.use("/api/user", user);
app.use("/api/admin", admin);
app.use("/api", category);
app.use("/api", restaurant);
app.use("/api", product);
app.use("/api", voucher);
app.use("/api", discount);

// Middleware for errors: Must be called last, after other app.use() and routes
app.use(errorMiddleware);

// Connect to database
connectDB();

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
