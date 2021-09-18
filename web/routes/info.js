exports.nodeInfo = function (req, res) {
    const os = require("os");
    const fs = require('fs');

    const nodeFile = fs.readFileSync('routes/node_resource.json', 'utf-8').replace(/'/g, "");
    const node = JSON.parse(nodeFile);

    const podFile = fs.readFileSync('routes/pod_resource.json', 'utf-8').replace(/'/g, "");
    const pod = JSON.parse(podFile).length;
    
    
    const serviceFile = fs.readFileSync('routes/service_resource.json', 'utf-8').replace(/'/g, "");
    const service = JSON.parse(serviceFile).length;

    const nsFile = fs.readFileSync('routes/ns_resource.json', 'utf-8').replace(/'/g, "");
    const ns = JSON.parse(nsFile).length;

    res.render('home.ejs', {
        osplatform: os.platform,
        ostype: os.type,
        osarch: os.arch,
        node: node,
        pod: JSON.parse(podFile).length,
        service: JSON.parse(serviceFile).length,
        ns: JSON.parse(nsFile).length,
    });
}


exports.podInfo = function (req, res) {

    const fs = require('fs');
    const sortJsonArray = require('sort-json-array');

    const podFile = fs.readFileSync('routes/pod_resource.json', 'utf-8').replace(/'/g, "");
    var pod = JSON.parse(podFile);

    pod = sortJsonArray(pod, 'NAMESPACE');

    let listOfPodGroups = [...new Set(pod.map(it => it.NAMESPACE))];

    res.render('pod.ejs', {
        pod: pod,
        list: listOfPodGroups,
        listLength: listOfPodGroups.length,
    });
}

exports.serviceInfo = function (req, res) {

    const fs = require('fs');

    const serviceFile = fs.readFileSync('routes/service_resource.json', 'utf-8').replace(/'/g, "");
    const service = JSON.parse(serviceFile);


    res.render('service.ejs', {
        service: service,
    });
}

exports.nsInfo = function (req, res) {

    const fs = require('fs');

    const nsFile = fs.readFileSync('routes/ns_resource.json', 'utf-8').replace(/'/g, "");

    const ns = JSON.parse(nsFile);


    res.render('namespace.ejs', {
        ns: ns,
    });
}

exports.ndInfo = function (req, res) {
    const fs = require('fs');

    const nodeFile = fs.readFileSync('routes/node_resource.json', 'utf-8').replace(/'/g, "");
    /*const nodeFile = fs.readFileSync('/client-resource/node_resource.json', 'utf-8').replace(/'/g, ""); */
    const node = JSON.parse(nodeFile);

    res.render('node.ejs', {
        node: node,
    });
}

exports.errLog = function (req, res) {
    const fetch = require('node-fetch');

    const response = fetch('https://hanium-test-error-log.s3.ap-northeast-2.amazonaws.com/error.json');
    const body = response.json();
    res.render('logging.ejs', {
        test : console.log(body),
    })
}