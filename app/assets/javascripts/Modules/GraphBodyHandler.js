var GraphBodyHandler = function (json, el) {
    // Useful Vars
    var $graphDiv = el.find('.user-graph');
    var KEYS = {PENDING: 0, SENT: 1, ONGOING: 2, SUBMITTED: 3, FULFILLED: 4, APPROVED: 5, DECLINED: 6};

    // Event handlers
    el.find('.fulfilledCommit').click(function () {
        clearGraph();
        new UserGraph(json, $graphDiv, KEYS.FULFILLED);
    });
    el.find('.approvedCommit').click(function () {
        clearGraph();
        new UserGraph(json, $graphDiv, KEYS.APPROVED);
    });
    el.find('.requestedCommit').click(function () {
        clearGraph();
        new UserGraph(json, $graphDiv, KEYS.APPROVED);
    });

    // Helper Functions
    var clearGraph = function () {
        $graphDiv.empty();
    };
};