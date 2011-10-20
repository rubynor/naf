Ext.application({
    name: 'NAF',
    controllers: [
        'Activities'
    ],

    autoCreateViewport: true,

    onLaunch: function() {
        Ext.QuickTip.init();
        Ext.Ajax.on('beforerequest', function(o) {
                var csrf = Ext.select("meta[name='csrf-token']").first();
                if (csrf) {
                        o.defaultHeaders = Ext.apply(o.defaultHeaders || {}, {'X-CSRF-Token': csrf.getAttribute('content')});
                }
        });
    }

});
