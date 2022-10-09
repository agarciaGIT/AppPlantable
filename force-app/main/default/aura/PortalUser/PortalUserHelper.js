({

	getPortalUserData: function(component) {

		// show spinner
		this.showSpinner(component);

		var recordId = component.get("v.recordId");

		var action = component.get("c.getPortalUserData");
		action.setParams({
			"recordId": recordId
		});

		//Set up the callback
		action.setCallback(this, function(response){
			var state = response.getState();
			if (component.isValid() && state === "SUCCESS") {

				var portalUserData = response.getReturnValue();

				if (portalUserData.hasError) {
					component.set("v.hasError", true);
					component.set("v.errorMessage", portalUserData.errorMessage);
				}
				else {
					component.set("v.hasError", false);
					component.set("v.orgId", portalUserData.orgId);
					component.set("v.portalId", portalUserData.portalId);
					component.set("v.contactId", portalUserData.contactId);
					if (portalUserData.hasPortalUser) {
						component.set("v.hasPortalUser", true);
						component.set("v.userId", portalUserData.userId);
					}
					else {
						component.set("v.hasPortalUser", false);
					}
				}
			}
			else {
				component.set("v.hasError", true);
				var message = this.getErrorMessage(component, state, response);
				component.set("v.errorMessage", message);
			}
			// hide spinner
			this.hideSpinner(component);
		});
		$A.enqueueAction(action);
	},

	loginAsPortalUser: function(component) {

		// generate the following url:
		// https://my-company-domain.cs54.my.salesforce.com/servlet/servlet.su?oid=00DW000000XXXXXX&retURL=%2F003W000000XXXXX&suportalid=06080000000XXXXX&suportaluserid=005W000000XXXXX

		var portalId = component.get("v.portalId");
		var recordId = component.get("v.recordId");
		var userId = component.get("v.userId");
		var orgId = component.get("v.orgId");

		// generate the url to go to
		var url = "/servlet/servlet.su";
		url += "?oid=" + orgId;
		url += "&retURL=/" + recordId;
		url += "&sunetworkid=" + '0DB40000000GnHh';
		url += "&sunetworkuserid=" + userId;

		// navigate with document.location.href
		// TODO: e.force:navigateToURL did not work, so need to find workaround
		document.location.href = url;
	},



    showSpinner: function(component) {
        var spinner = component.find("uploadingSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    hideSpinner: function(component) {
        var spinner = component.find("uploadingSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },


    getErrorMessage : function(component, state, response) {

        var message = '';

        if (state === "INCOMPLETE") {
            return  "No Response From Server";
        }

        if (state === "ERROR") {
            var errors = response.getError();
            if (errors) {
                for(var i=0; i < errors.length; i++) {
                    for(var j=0; errors[i].pageErrors && j < errors[i].pageErrors.length; j++) {
                        message += (message.length > 0 ? '\n' : '') + errors[i].pageErrors[j];
                    }
                    if(errors[i].fieldErrors) {
                        for(var fieldError in errors[i].fieldErrors) {
                            var thisFieldError = errors[i].fieldErrors[fieldError];
                            for(var j=0; j < thisFieldError.length; j++) {
                                message += (message.length > 0 ? '\n' : '') + thisFieldError[j].message;
                            }
                        }
                    }
                    if(errors[i].message) {
                        message += (message.length > 0 ? '\n' : '') + errors[i].message;
                    }
                }
            }
            else {
                message = "Unknown Error";
            }
        }
        else {
            message = "Unknown Status Error: " + state;
        }

        return message;
    }

})