exports.imgLog = function (req, res) {
  const fs = require("fs");
  const ndjsonParser = require("ndjson-parse");
  const article = fs.readFileSync("routes/imagescan.txt").toString();
  const parsedArticle = ndjsonParser(article);

//  const imgFile = fs.readFileSync("routes/imagescan.txt", "utf-8");
//  const img = JSON.parse(imgFile);

  res.render("image.ejs", {
    //img: img,
    img : parsedArticle
  });
};
