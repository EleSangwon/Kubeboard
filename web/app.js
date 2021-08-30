//npm 패키지
const express = require("express");
const app = express();
const ejs = require("ejs");
const cors = require("cors");
const port = 3000;
const info = require("./routes/info");

app.set('view engine', 'ejs');
app.use(express.static("public"));
app.use(express.json());
app.use(express.urlencoded({extended : false}));
app.use(cors());


app.get("/", function (req, res) {
    res.redirect("/home");
});
app.get("/home", info.nodeInfo);

app.get("/pod", info.podInfo);

app.get("/service", info.serviceInfo);

app.get("/logging", function (req, res) {
    res.render('logging.ejs');
})

app.get("/infra", function (req, res) {
    res.render('infra.ejs');
})

app.get("/namespace", function (req, res) {
    res.render('namespace.ejs');
})

app.listen(port, function() {
    console.log("server start at port 3000");
})