exports.errLog = function (req, res) {
  const https = require("https");
  const fs = require("fs");
  const ndjsonParser = require("ndjson-parse");

  const article = fs.readFileSync("routes/log-test.txt").toString();
  const parsedArticle = ndjsonParser(article);

  let groupByNamespace = parsedArticle.reduce(
    (acc, it) => ({ ...acc, [it.NAMESPACE]: (acc[it.NAMESPACE] || 0) + 1 }),
    {}
  );

  let groupByName = parsedArticle.reduce(
    (acc, it) => ({ ...acc, [it.NAME]: (acc[it.NAME] || 0) + 1 }),
    {}
  );

  let groupByKind = parsedArticle.reduce(
    (acc, it) => ({ ...acc, [it.KIND]: (acc[it.KIND] || 0) + 1 }),
    {}
  );

  let groupByTime = parsedArticle.reduce(
    (acc, it) => ({
      ...acc,
      [it.TIME.slice(0, 10)]: (acc[it.TIME.slice(0, 10)] || 0) + 1,
    }),
    {}
  );

  let groupByHost = parsedArticle.reduce(
    (acc, it) => ({ ...acc, [it.HOST]: (acc[it.HOST] || 0) + 1 }),
    {}
  );

  res.render("logging.ejs", {
    data: parsedArticle,
    namespace: groupByNamespace,
    name: groupByName,
    kind: groupByKind,
    time: groupByTime,
    host: groupByHost,
  });
};
