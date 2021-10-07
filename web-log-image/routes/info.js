exports.imgLog = function (req, res) {
  const fs = require("fs");

  const imgFile = fs.readFileSync("routes/image_log.json", "utf-8");
  const img = JSON.parse(imgFile);

  res.render("image.ejs", {
    img: img,
  });
};
