({
    // When component loaded
	onInit: function(comp, event, helper) {
        console.log('Lightning Component Init');
        
        helper.loadUser(comp);
        helper.setApp(comp);
        helper.setProcess(comp);
        helper.setRequiredFields(comp);
        helper.setAppParameterDisplay(comp);
        
        helper.loadDatabase(comp);
	},
    
    // When user clicks section toggle button
    handleSectionToggle: function(comp, event, helper) {
        let sectionName = event.getSource().get("v.name");
        if(sectionName === 'paraSec') {
            comp.set('v.isParameterExpand', !comp.get('v.isParameterExpand'));  
        }else if(sectionName === 'addiParaSec') {
            comp.set('v.isAddiParameterExpand', !comp.get('v.isAddiParameterExpand'));  
        }
    },
    
    // When user changes Application dropdown
    handleAppChange: function(comp, event, helper) {
		helper.setProcess(comp);
        helper.setRequiredFields(comp);
        helper.setAppParameterDisplay(comp);
    },
    
    // When user changes Process dropdown
    handleProcessChange: function(comp, event, helper) {
        // Clear selected Study Participants as they're not available for certain Process
        comp.set('v.selectedStudyParticipants', []);
        
        helper.setRequiredFields(comp);
        helper.setAppParameterDisplay(comp);
    },
    
    // When user changes Database dropdown
    handleDatabaseChange: function(comp, event, helper) {
        helper.clearStudyParameters(comp);
        helper.loadStudyDetail(comp);
    },
    
    // When user changes Study Participant dual list values
    handleStudyParticipantsChange: function(comp, event, helper) {
        let selectedParticipants = event.getParam('value');
        comp.set('v.selectedStudyParticipants', selectedParticipants);
    },
    
    // When user changes Client Attribute Key dropdown
    handleClientAttrKeyChange: function(comp, event, helper) {
        let clientKey = event.getParam('value');
        comp.set('v.clientAttrValueOpts', comp.get('v.allClientAttrValueOpts')[clientKey]);
        
        comp.set('v.selectedClientAttrValue', null);
    },
    
    // When user click on Add Attribute button
    handleAddClientAttr: function(comp, event, helper) {
        helper.addClientAttribute(comp);
    },
    
    // When user click on Remove Attribute icon
    handleRemoveClientAttr: function(comp, event, helper) {
        let clientAttrIndex = event.getParam('name');
        
        let clientAttr = comp.get('v.clientAttr');
        clientAttr = clientAttr.filter(ele => ele.index !== clientAttrIndex);
        
        comp.set('v.clientAttr', clientAttr);
    },
    
    // When user changes Client Metadata KeyValue dropdown
    handleMetadataKeyValueChange: function(comp, event, helper) {
        let keyValue = event.getParam('value');
        comp.set('v.clientMetadataValueOpts', comp.get('v.allClientMetadataValueOpts')[keyValue]);
        
        comp.set('v.selectedClientMetadataValue', null);
    },
    
    // When user click on Add Metadata button
    handleAddClientMeta: function(comp, event, helper) {
        helper.addClientMetadata(comp);
    },
    
    // When user click on Remove Metadata icon
    handleRemoveClientMeta: function(comp, event, helper) {
        let clientMetaIndex = event.getParam('name');
        
        let clientMeta = comp.get('v.clientMeta');
        clientMeta = clientMeta.filter(ele => ele.index !== clientMetaIndex);
        
        comp.set('v.clientMeta', clientMeta);
    },
    
    // When user click on Submit Job button
    handleSubmitJob: function(comp, event, helper) {
        if(helper.checkRequiredParameters(comp)) {
            helper.enqueueJob(comp);
        }
    },
    
    // When user click on Clear Parameters button
    handleClearParameters: function(comp, event, helper) {
        if(window.confirm('This will clear all current parameters. Are you sure?')) {
            helper.clearStudyParameters(comp);
            helper.clearRatioParameters(comp);
        }
    },
    
    // When user click on Delete Jobs button
    handleDeleteJobs: function(comp, event, helper) {
        if(window.confirm('This will delete all jobs submitted by you. Are you sure?')) {
        	helper.enqueueDeleteJob(comp);
        }
    }
})