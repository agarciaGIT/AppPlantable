({ 
    gotoOn24URL : function (component, event, helper) {
    var urlEvent = $A.get("e.force:navigateToURL");
        console.log('urlEvent------>'+urlEvent);
    urlEvent.setParams({
      "url": "/apex/ON24EngagementHubEmployeeSSO"
    });
    urlEvent.fire();
}
})