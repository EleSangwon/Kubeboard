exports.nodeInfo = function (req, res) {
    const os = require("os");
    const fs = require('fs');

    const nodeFile = fs.readFileSync('/client-resource/node_resource.json', 'utf-8').replace(/'/g, "");;
    const node = JSON.parse(nodeFile);

    const podFile = fs.readFileSync('/client-resource/pod_resource.json', 'utf-8').replace(/'/g, "");
    const pod = JSON.parse(podFile).length;
    
    const serviceFile = fs.readFileSync('/client-resource/service_resource.json', 'utf-8').replace(/'/g, "");;
    const service = JSON.parse(serviceFile).length;

    const nsFile = fs.readFileSync('/client-resource/ns_resource.json', 'utf-8').replace(/'/g, "");;
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

    /*const podFile = fs.readFileSync('routes/pod_resource.json', 'utf-8').replace(/'/g, "");*/
    const podFile = fs.readFileSync('/client-resource/pod_resource.json', 'utf-8').replace(/'/g, "");
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

    /*const serviceFile = fs.readFileSync('routes/service_resource.json', 'utf-8').replace(/'/g, "");*/
    const serviceFile = fs.readFileSync('/client-resource/service_resource.json', 'utf-8').replace(/'/g, "");
    const service = JSON.parse(serviceFile);


    res.render('service.ejs', {
        service: service,
    });
}

exports.nsInfo = function (req, res) {

    const fs = require('fs');

    /*const nsFile = fs.readFileSync('routes/ns_resource.json', 'utf-8').replace(/'/g, "");*/
   const nsFile = fs.readFileSync('/client-resource/ns_resource.json', 'utf-8').replace(/'/g, "");

    const ns = JSON.parse(nsFile);


    res.render('namespace.ejs', {
        ns: ns,
    });
}

exports.ndInfo = function (req, res) {
    const fs = require('fs');

    /*const nodeFile = fs.readFileSync('routes/node_resource.json', 'utf-8').replace(/'/g, "");*/
    const nodeFile = fs.readFileSync('/client-resource/node_resource.json', 'utf-8').replace(/'/g, ""); 
    const node = JSON.parse(nodeFile);

    res.render('node.ejs', {
        node: node,
    });
}

exports.errLog = function (req, res) {
    const fs = require('fs');
    const Chart = require('chart.js');

    const errFile = fs.readFileSync('routes/error.json', 'utf-8');
    const err = JSON.parse(errFile);

    var _html = `<script>ctx = document.getElementById('myChart');
        var myChart = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: [...new Set(err.map(it => it.NAMESPACE))],
            datasets: [{
                label: '# of Votes',
                data: [Object.keys(err).length],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.2)',
                    'rgba(54, 162, 235, 0.2)',
                    'rgba(255, 206, 86, 0.2)',
                    'rgba(75, 192, 192, 0.2)',
                    'rgba(153, 102, 255, 0.2)',
                    'rgba(255, 159, 64, 0.2)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)'
                ],
                borderWidth: 1
            }],
        },
    }); </script>`

    res.render('logging.ejs', {
        errLength: JSON.parse(errFile).length,
        error: err,
        html: _html,
    })
}