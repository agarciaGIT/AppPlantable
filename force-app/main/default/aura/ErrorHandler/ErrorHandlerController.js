({


    handleResponse: function(component, event, helper) {

        var params = event.getParam('arguments');
        var response = params.response;
        var successHandler = params.successHandler;
        var errorHandler = params.errorHandler;

        var state = response.getState();

        if(state == 'SUCCESS') {
            if (successHandler)
                successHandler(response);
        }
        else {
            var message = helper.getErrorMessage(component, state, response);

            helper.showToast('Error', 'error', message);

            if(errorHandler) {
                errorHandler(response);
            }
        }
    },
    showToast: function(component, event, helper) {
        var params = event.getParam('arguments');
        var title = params.title;
        // can be error, warning, success, or info.
        var type = params.type;
        var message = params.message;
        helper.showToast(title, type, message);
    },
    showToast_error: function(component, event, helper) {
        var params = event.getParam('arguments');
        var title = params.title;
        var type = 'error';
        var message = params.message;
        helper.showToast(title, type, message);
    },
    showToast_success: function(component, event, helper) {
        var params = event.getParam('arguments');
        var title = params.title;
        var type = 'success';
        var message = params.message;
        helper.showToast(title, type, message);
    }
})