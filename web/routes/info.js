exports.nodeInfo = function (req, res) {
    const os = require("os");

    res.render('home.ejs', {
        osplatform: os.platform,
        ostype: os.type,
        osarch: os.arch,

    /*nodeName: node[0].NAME,
    nodeStatus: node[0].STATUS,
    nodeVersion: node[0].VERSION,
    nodeOs: node[0].OSImage,
    */
    });
}

exports.podInfo = function (req, res) {

    res.render('home.ejs', {

    /*namespace: pod[0].NAMESPACE,
        podName: pod[0].POD_NAME,
        podImage: pod[0].POD_IMAGE,
        podIp: pod[0].POD_IP,
        nodeIp: pod[0].NODE_IP,*/
    });
}

exports.nsInfo = function (req, res) {

    res.render('home.ejs', {
        /*nsKind: ns[0].KIND,
        nsName: ns[0].NAME,
        status: ns[0].STATUS,
        podNumber: ns[0].POD_NUMBER,*/
    });
}

exports.serviceInfo = function (req, res) {

    res.render('home.ejs', {
        /*serNameSpace: node[0].NAMESPACE,
        serName: service[0].NAME,
        serHostName: service[0].HOSTNAME,
        protocol: service[0].PROTOCOL,
        nodeport: service[0].NODEPORT,
        targetport: service[0].TARGETPORT, */
    });
}