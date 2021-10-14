//npm 패키지
const express = require("express");
const app = express();
const ejs = require("ejs");
const cors = require("cors");
const port = 3001;
const info = require("./routes/info");

app.set("view engine", "ejs");
app.use(express.static("public"));
app.use(express.static("js"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cors());

app.get("/", info.errLog);

app.listen(port, function () {
  console.log("server start at port 3001");
});
