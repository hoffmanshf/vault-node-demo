const express = require("express");
const path = require("path");
const logger = require("morgan");
const cookieParser = require("cookie-parser");
const bodyParser = require("body-parser");

// eslint-disable-next-line node/no-unpublished-require,import/no-extraneous-dependencies
const vault = require("./vault");
const index = require("./routes/index");
const users = require("./routes/users");

const roleId = process.env.VAULT_APPROLE_ROLE_ID;
const secretId = process.env.VAULT_APPROLE_SECRET_ID;

const app = express();
if (!vault.token) {
  throw new Error("Missing Vault token");
}

vault
  .read("kv-v1/eng/apikey")
  .then((result) => {
    console.log(result);
    app.set("apiKey", result.data.API_KEY);
  })
  .catch((err) => {
    console.error(err);
  });

// view engine setup
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

// uncomment after placing your favicon in /public
// app.use(favicon(path.join(__dirname, 'public', 'favicon.ico')));
app.use(logger("dev"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use("/", index);
app.use("/users", users);

// let apiKey = process.env.APIKEY;
// app.set('apiKey', apiKey);

// catch 404 and forward to error handler
app.use(function (req, res, next) {
  let err = new Error("Not Found");
  err.status = 404;
  next(err);
});

// error handler
app.use(function (err, req, res, next) {
  // set locals, only providing error in development
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  // render the error page
  res.status(err.status || 500);
  res.render("error");
});

module.exports = app;
