var GraphBodyHandler = function (json, el) {
    // Useful Vars
    var $graphDiv = el.find('.user-graph');
    var KEYS = {PENDING: 0, SENT: 1, ONGOING: 2, SUBMITTED: 3, FULFILLED: 4, APPROVED: 5, DECLINED: 6};
    // Event handlers
    el.find('.fulfilledCommit').click(function () {
        clearGraph();
        $('.fulfilledCommit').addClass('active');
        new UserGraph(json, $graphDiv, KEYS.FULFILLED, 'Fulfilled');
    });
    el.find('.approvedCommit').click(function () {
        clearGraph();
        $('.approvedCommit').addClass('active');
        new UserGraph(json, $graphDiv, KEYS.APPROVED, 'Approved');
    });
    el.find('.requestedCommit').click(function () {
        clearGraph();
        $('.requestedCommit').addClass('active');
        new UserGraph(json, $graphDiv, KEYS.APPROVED, 'Requested');
    });

    // Helper Functions
    var clearGraph = function () {
        $('#graph-body h4.highlight-header a').removeClass('active');
        $graphDiv.empty();
    };
};