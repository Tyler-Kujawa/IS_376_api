var UserGraph = function(json, el, cStatus, title){
    var c = json.user.commitments;
    var monthArr = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (var i=0; i<c.length; i++) {
        // IF: commitment was fulfilled
        var deadline = new Date(c[i].deadline);
        if (c[i].status = cStatus) {
            var monthDue = deadline.getMonth();
            monthArr[monthDue]++;
        }
    }
    el.highcharts({
        chart: {
            type: 'line'
        },
        title: {
            text: title
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