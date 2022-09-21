({
	afterRender : function(cmp, helper) {
        //debugger;
        var afterRend = this.superAfterRender();

        console.log('after render args', arguments);
        return afterRend;
    }
})