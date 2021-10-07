exports.errLog = function (req, res) {
  const https = require("https");
  const ndjson = require("ndjson");
  const fs = require("fs");

  const errorFile = fs.readFileSync("routes/error.json", "utf-8");

  const error = JSON.parse(errorFile);

  var result = [];

  const url =
    "https://hanium-test-error-log.s3.ap-northeast-2.amazonaws.com/error.json";

  let groupByNamespace = error.reduce(
    (acc, it) => ({ ...acc, [it.NAMESPACE]: (acc[it.NAMESPACE] || 0) + 1 }),
    {}
  );

  let groupByName = error.reduce(
    (acc, it) => ({ ...acc, [it.NAME]: (acc[it.NAME] || 0) + 1 }),
    {}
  );

  let groupByKind = error.reduce(
    (acc, it) => ({ ...acc, [it.KIND]: (acc[it.KIND] || 0) + 1 }),
    {}
  );

  let groupByTime = error.reduce(
    (acc, it) => ({
      ...acc,
      [it.TIME.slice(0, 10)]: (acc[it.TIME.slice(0, 10)] || 0) + 1,
    }),
    {}
  );

  let groupByHost = error.reduce(
    (acc, it) => ({ ...acc, [it.HOST]: (acc[it.HOST] || 0) + 1 }),
    {}
  );

  /* https.get(url, (stream) => {
          stream.pipe(ndjson.parse()).on("data", function (data) {
              result.push(data);
          }).on("end", () => {
              let groupByNamespace = result.reduce((acc, it) =>
                  ({ ...acc, [it.NAMESPACE]: (acc[it.NAMESPACE] || 0) + 1 }),
                  {});
              let groupByName = result.reduce((acc, it) =>
                  ({ ...acc, [it.NAME]: (acc[it.NAME] || 0) + 1 }),
                  {});
  
              let groupByKind = result.reduce((acc, it) =>
                  ({ ...acc, [it.KIND]: (acc[it.KIND] || 0) + 1 }),
                  {});
              res.render('logging.ejs', {
                  data: result,
                  namespace: groupByNamespace,
                  name: groupByName,
                  kind: groupByKind,
              })
          });
      }); */

  res.render("logging.ejs", {
    data: error,
    namespace: groupByNamespace,
    name: groupByName,
    kind: groupByKind,
    time: groupByTime,
    host: groupByHost,
  });
};
