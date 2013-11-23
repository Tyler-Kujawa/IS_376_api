var UserGraph = function(json, el, cStatus){
    var c = json.user.commitments;
    var monthArr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (var i=0; i<c.length; i++) {
        // IF: commitment was fulfilled
        if (c[i].status = cStatus) {
            var monthDue = c[i].deadline.getMonth();
            monthArr[monthDue]++;
        }
    }
    el.highcharts({
        chart: {
            type: 'line'
        },
        title: {
            text: 'Commitments by Month'
        },
        xAxis: {
            categories: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        },
        yAxis: {
            title: {
                text: 'Commitments'
            }
        },
        series: [{
            name: 'Completed',
            data: monthArr
        }]
    });
};