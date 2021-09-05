exports.nodeInfo = function (req, res) {
    const os = require("os");
    const fs = require('fs');

    const nodeFile = fs.readFileSync('routes/node_resource.json', 'utf-8').replace(/'/g, "");;
    const node = JSON.parse(nodeFile);

    const podFile = fs.readFileSync('routes/pod_resource.json', 'utf-8').replace(/'/g, "");
    const pod = JSON.parse(podFile).length;
    
    const serviceFile = fs.readFileSync('routes/service_resource.json', 'utf-8').replace(/'/g, "");;
    const service = JSON.parse(serviceFile).length;

    const nsFile = fs.readFileSync('routes/ns_resource.json', 'utf-8').replace(/'/g, "");;
    const ns = JSON.parse(nsFile).length;

    res.render('home.ejs', {
        osplatform: os.platform,
        ostype: os.type,
        osarch: os.arch,
        node: node, 
        pod: pod,   
        service: service, 
        ns: ns,   
    });
}


exports.podInfo = function (req, res) {

    const fs = require('fs');

    const podFile = fs.readFileSync('routes/pod_resource.json', 'utf-8').replace(/'/g, "");
    const pod = JSON.parse(podFile);


    res.render('pod.ejs', {
        pod : pod,
    });
}

exports.serviceInfo = function (req, res) {

    const fs = require('fs');

    const serviceFile = fs.readFileSync('routes/service_resource.json', 'utf-8').replace(/'/g, "");;
    const service = JSON.parse(serviceFile);


    res.render('service.ejs', {
        service : service,
    });
}

exports.nsInfo = function (req, res) {

    const fs = require('fs');

    const nsFile = fs.readFileSync('routes/ns_resource.json', 'utf-8').replace(/'/g, "");;
    const ns = JSON.parse(nsFile);


    res.render('namespace.ejs', {
        ns : ns,
    });
}

exports.ndInfo = function (req, res) {
    const fs = require('fs');

    const nodeFile = fs.readFileSync('routes/node_resource.json', 'utf-8').replace(/'/g, "");;
    const node = JSON.parse(nodeFile);

    res.render('node.ejs', {
        node: node, 
    });
}

