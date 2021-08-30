exports.nodeInfo = function (req, res) {
    const os = require("os");
    const fs = require('fs');

    /*const nodeFile = fs.readFileSync('routes/node_resource.json', 'utf-8');
    const node = JSON.parse(nodeFile);*/
    const nodeFile = fs.readFileSync('routes/node_resource.json', 'utf-8');
    const node = JSON.parse(nodeFile);

    res.render('home.ejs', {
        osplatform: os.platform,
        ostype: os.type,
        osarch: os.arch,
        node: node,        
    });
}


exports.podInfo = function (req, res) {

    const fs = require('fs');

    const podFile = fs.readFileSync('routes/pod_resource.json', 'utf-8');
    const pod = JSON.parse(podFile);


    res.render('pod.ejs', {
        pod : pod,
    });
}

exports.serviceInfo = function (req, res) {

    const fs = require('fs');

    const serviceFile = fs.readFileSync('routes/service_resource.json', 'utf-8');
    const service = JSON.parse(serviceFile);


    res.render('service.ejs', {
        service : service,
    });
}