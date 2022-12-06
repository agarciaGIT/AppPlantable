// Common methods

const util_debug = true;

const util_console = (msg, data) => {

    if(util_debug) {

        if(util_isDefined(data)) {
            if(typeof data == 'object') {
                console.log(msg + ':');
                console.dir(data);
            } else {
                console.log(msg + ':' + data);
            }            
        } else {
            console.log(msg);
        }
    }

}


// Use these methods send Events back to AngularJS
// In Angular use util.dispatchLWCMesage() to send messages

const util_navigate = (context, route, params) => {
    context.dispatchEvent(
        new CustomEvent("lwcmessage", 
        {
            detail: {
                type: 'navigation',
                route: route,
                params: params
            }
        })
    );
}

const util_closeModal = (context, route, params) => {
    document.querySelector(context.componentSelector).dispatchEvent(
        new CustomEvent("lwcmessage", 
        {
            detail: {
                type: 'send-message',
                route: route,
                params: params
            }
        })
    );
}

const util_dispatchMessage = (context, route, params) => {

    var elem = document.querySelector(context.componentSelector);

    if(util_isDefined(elem)) {

        elem.dispatchEvent(
            new CustomEvent("lwcmessage", 
            {
                detail: {
                    type: 'send-message',
                    route: route,
                    params: params
                }
            })
        );
    
    }

}

// Use this method to Listen for Events from AngularJS
// In Angular use util.dispatchLWCMesage() to send messages

const util_subscribeToMessages = (context, channel, callback) => {
    window.addEventListener("message", callback.bind(context));
    //document.querySelector('c-member-profile-survey').addEventListener(channel, (e) => {
    //    console.log('LWCmessage:');
    //    console.dir(e.detail);
    //    callback(e.detail);
    //}); 
}

const util_convertStateCodeToName = (profileData) => {
    if(util_isDefined(profileData,"contact.MailingState") && util_isDefined(profileData,"contact.MailingCountry")) {
        var fndCountry = profileData.countries.find(x => x.Country__c === profileData.contact.MailingCountry);
        if(util_isDefined(fndCountry,"Provinces__r")) {

            // If find State by Code convert to Name
            var fndStateCode = fndCountry.Provinces__r.find(x => x.Code__c === profileData.contact.MailingState);
            if(util_isDefined(fndStateCode)) {
                profileData.contact.MailingState = fndStateCode.Name;
            }
        }
    }

    if(util_isDefined(profileData,"contact.Account.BillingState") && util_isDefined(profileData,"contact.Account.BillingCountry")) {
        var fndCountry = profileData.countries.find(x => x.Country__c === profileData.contact.Account.BillingCountry);
        if(util_isDefined(fndCountry,"Provinces__r")) {

            // If find State by Code convert to Name
            var fndStateCode = fndCountry.Provinces__r.find(x => x.Code__c === profileData.contact.Account.BillingState);
            if(util_isDefined(fndStateCode)) {
                profileData.contact.Account.BillingState = fndStateCode.Name;
            }
        }
    }
    return profileData.contact;
}

const util_mapSFRecordsToSelectOptions = (inSFRecordList, sfFieldName) => {

    var retArray = [];
    inSFRecordList.forEach(function (arrayItem) {
        retArray.push({
            label: arrayItem[sfFieldName],
            value: arrayItem[sfFieldName]
        });
    });

    return retArray;
}

const util_mapSFPickListToOptions = (isSFFieldName) => {
    var retArray = [];
    isSFFieldName.forEach(function (arrayItem) {
        retArray.push({
            label: arrayItem,
            value: arrayItem
        });
    });
    return retArray;
}

const util_mapSFFields = (inObj) => {
    var retObj = {};
    for (var prop in inObj) {
        var newProd = prop.replace("__c","");
        if(prop == 'Account') {
            for (var propA in inObj.Account) {
                var newProd = propA.replace("__c","");
                retObj[newProd] = inObj.Account[propA];
            }
        } else {
            retObj[newProd] = inObj[prop];
        }
        
    }
    return retObj;
}


const util_createYearsOptions = (startYear, numberOfYears) => {
    var retArray = [];

    var nowYear = new Date().getFullYear();
    var stYear = nowYear;
    if(util_isDefined(startYear)) {
        stYear = parseInt(startYear);
    }

    for(var i=stYear; i <=nowYear+numberOfYears; i++) {
        retArray.push({
            label: i.toString(),
            value: i.toString()
        });
    }

    return retArray;
}

const util_isDefined = (ref, strNames) => {
    var name;

      if (typeof ref === "undefined" || ref === null) {
        return false;
      }

      if (strNames !== null && typeof strNames !== "undefined") {
        var arrNames = strNames.split('.');
        while (name = arrNames.shift()) {
          if (ref[name] === null || typeof ref[name] === "undefined") return false;
          ref = ref[name];
        }
      }
      return true;
}

const util_customValidationCheck = (validationType, fieldValue)  => {

    if(!util_isDefined(fieldValue)) {
        return false;
    }

    switch(validationType) {
        case 'WesternOnly':
            var patt = new RegExp("[^\x00-\x7F]+");        
            return !patt.test(fieldValue);

        case 'Email':
            const emailRegex=/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
            return emailRegex.test(fieldValue);    

        case 'Phone':
            var patt = new RegExp("[^0-9]+");
            return !patt.test(fieldValue);

        case 'URL':
            var patt = new RegExp('#\b(([\w-]+://?|www[.])[^\s()<>]+(?:\([\w\d]+\)|([^[:punct:]\s]|/)))#iS'); 
            return patt.test(fieldValue);
    
    }
        
}

const util_validateForm = (template)  => {

    var isValid = true;
    template.querySelectorAll('lightning-input, lightning-combobox, lightning-textarea').forEach(function(inputCmp) {
        inputCmp.setCustomValidity("");
        inputCmp.reportValidity();

        var isCmpValid = inputCmp.checkValidity();

        if(!isCmpValid && inputCmp.validity.valueMissing && inputCmp.required) {
            var msg = 'This entry is required.';
            if(util_isDefined(inputCmp,"dataset.customrequiredmsg")) {
                msg = inputCmp.dataset.customrequiredmsg;
            }
            inputCmp.setCustomValidity(msg);
            inputCmp.reportValidity();
            isValid = false;
        } else if(isCmpValid && util_isDefined(inputCmp.dataset.customvalidation) && util_isDefined(inputCmp,"value.length") && inputCmp.value.length > 0) {
            isCmpValid = util_customValidationCheck(inputCmp.dataset.customvalidation, inputCmp.value);
            if(!isCmpValid) {
                var msg = 'There was an issue with your entry.';
                if(util_isDefined(inputCmp,"dataset.customvalidationmsg")) {
                    msg = inputCmp.dataset.customvalidationmsg;
                }
                inputCmp.setCustomValidity(msg);
                inputCmp.reportValidity();
                isValid = false;
            }
        }
    });

    return isValid;

}

export { util_isDefined, util_customValidationCheck, util_validateForm, 
        util_mapSFFields, util_mapSFRecordsToSelectOptions, util_convertStateCodeToName,
        util_mapSFPickListToOptions, util_createYearsOptions, util_navigate, util_closeModal,
        util_subscribeToMessages, util_dispatchMessage, util_console };