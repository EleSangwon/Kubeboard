//npm 패키지
const express = require("express");
const app = express();
const ejs = require("ejs");
const cors = require("cors");
const port = 3000;


app.set('view engine', 'ejs');
app.use(express.static("public"));
app.use(express.json());
app.use(express.urlencoded({extended : false}));
app.use(cors());


app.get("/", function (req, res) {
    res.send("hello world!");
});


app.listen(port, function() {
    console.log("server start at port 3000");
})