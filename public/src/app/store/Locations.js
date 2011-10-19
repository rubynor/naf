Ext.define('NAF.store.Locations', {
    extend: 'Ext.data.Store',
    model: 'NAF.model.Location',
    storeId: 'locationStore',
    autoLoad: true,

    proxy: {
        type: 'rest',
        url: '/rest/locations',
        api: {
            read: 'rest/locations'
        },
        reader: {
            type: 'json',
            root: 'locations',
            successProperty: 'success'
        }
    }

});