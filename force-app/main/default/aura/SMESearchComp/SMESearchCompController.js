({
    /*
        {"field":"Credit_Risk__c","label":"Credit Risk - Self Identify"},{"field":"Credit_Risk_GARP__c","label":"Credit Risk - GARP Identify"},{"field":"Credit_Risk_Sys__c","label":"Credit Risk - System Identify"},
        {"field":"Culture_Governance__c","label":"Culture Governance - Self Identify"},{"field":"Culture_Governance_GARP__c","label":"Culture Governance - GARP Identify"},{"field":"Culture_Governance_Sys__c","label":"Culture Governance - System Identify"},
        {"field":"Energy__c","label":"Energy - Self Identify"},{"field":"Energy_GARP__c","label":"Energy - GARP Identify"},{"field":"Energy_Sys__c","label":"Energy - System Identify"},
        {"field":"Expert_Participation__c","label":"Expert Participation - Self Identify"},{"field":"Expert_Participation_GARP__c","label":"Expert Participation - GARP Identify"},{"field":"Expert_Participation_Sys__c","label":"Expert Participation - System Identify"},
        {"field":"Market_Risk__c","label":"Market Risk - Self Identify"},{"field":"Market_Risk_GARP__c","label":"Market Risk - GARP Identify"},{"field":"Market_Risk_Sys__c","label":"Market Risk - System Identify"},
        {"field":"Operational__c","label":"Operational - Self Identify"},{"field":"Operational_GARP__c","label":"Operational - GARP Identify"},{"field":"Operational_Sys__c","label":"Operational - System Identify"},
        {"field":"Publishing_Experience__c","label":"Publishing Experience - Self Identify"},{"field":"Publishing_Experience_GARP__c","label":"Publishing Experience - GARP Identify"},{"field":"Publishing_Experience_Sys__c","label":"Publishing Experience - System Identify"},
        {"field":"Teaching_Experience__c","label":"Teaching Experience - Self Identify"},{"field":"Teaching_Experience_GARP__c","label":"Teaching Experience - GARP Identify"},{"field":"Teaching_Experience_Sys__c","label":"Teaching Experience - System Identify"},
        {"field":"Technology__c","label":"Technology - Self Identify"},{"field":"Technology_GARP__c","label":"Technology - GARP Identify"},{"field":"Technology_Sys__c","label":"Technology - System Identify"}
    */

    doInit : function(comp, event, helper) {
        // 'Credit Risk', 'Culture Governance', 'Energy', 'Expert Participation', 'Market Risk', 'Operational', 'Publishing Experience', 'Teaching Experience', 'Technology' 
        comp.set('v.searchFields', [
            {label: 'Credit Risk', field: 'Credit Risk'},
            {label: 'Culture Governance', field: 'Culture Governance'},
            {label: 'Energy', field: 'Energy'},
            {label: 'Expert Participation', field: 'Expert Participation'},
            {label: 'Market Risk', field: 'Market Risk'},
            {label: 'Operational', field: 'Operational'},
            {label: 'Publishing Experience', field: 'Publishing Experience'},
            {label: 'Teaching Experience', field: 'Teaching Experience'},
            {label: 'Technology', field: 'Technology'},
            {label: 'Regulation and Compliance', field: 'Regulation and Compliance'},
            {label: 'Liquidity and Treasury', field: 'Liquidity and Treasury'},
            {label: 'Non Financial Risk', field: 'Non Financial Risk'},
            {label: 'Sales and Trading', field: 'Sales and Trading'}
        ]);
        comp.find('categoryField').set('v.value', 'Credit Risk');
        
        helper.loadCountryValues(comp);
        helper.loadPickValues(comp);
        
        console.log('SMESearchComp component Loaded.');
    },

    handleSearchTypeChange : function(comp, event, helper) {
        comp.find('search').set('v.value', '');
    },
    
    handleKeyUp : function(comp, event, helper) {
        let isEnterKey = event.keyCode === 13;
        if(isEnterKey) {
            helper.searchSME(comp);
        }
    },
    
    handleKeywordSearch : function(comp, event, helper) {
        helper.searchSME(comp);
    },

    handleSearchFieldChange : function(comp, event, helper) {
        helper.loadPickValues(comp);
    },
    
    handleSubcateChange : function(comp, event, helper) {
        let items = event.getParam("values");
        comp.set('v.selectedSubcates', items);
    },

    handleAddFilter : function(comp, event, helper) {
        let index = comp.get('v.filterIndex');
        let filters = comp.get('v.filters');
        
        let field = comp.find('categoryField').get('v.value');
        let fldLabel = helper.findFieldLabel(comp, field);
        
        let filterOpt = comp.find('txtFilter').get('v.value');
        
        let values = comp.get('v.selectedSubcates');
        let valDisp = values.length > 0 ? (' "' + values.join('" and "') + '"') : ' Any';
        
        filters.push({
            index: 'srchFilter_' + index,
            field: field,
            fieldLabel: fldLabel,
            filter: filterOpt,
            value: values,
            valueDisplay: valDisp
        });
        index++;
        
        comp.set('v.filters', filters);
        comp.set('v.filterIndex', index);
    },
    
    handleFilterRemove : function(comp, event, helper) {
        let index = event.getSource().get('v.name');
        
        let updtFilters = [];
        for(let oneFilter of comp.get('v.filters')) {
            if(oneFilter.index != index) {
                updtFilters.push(oneFilter);
            }
        }
        
        comp.set('v.filters', updtFilters);
    },
    
    handleFilterSearch : function(comp, event, helper) {
        let filters = comp.get('v.filters');
        let conName = comp.find('contactName').get('v.value');
        
        if(filters.length > 0 || conName) {
            $A.util.addClass(comp.find('filterErrDiv'), 'slds-hide');
            helper.filterSearchSME(comp);
        }else {
            $A.util.removeClass(comp.find('filterErrDiv'), 'slds-hide');
        }
    },
    
    handleRowAction : function(comp, event, helper) {
        let action = event.getParam('action');
        let row = event.getParam('row');
        
        switch (action.name) {
            case 'viewSME':
                helper.showSMEDetail(comp, row);
                break;
            case 'goToSME':
                window.open('/' + row.Id, '_blank');
                break;
            case 'goToContact':
                window.open('/' + row.Contact__c, '_blank');
                break;
        }
    },
    
    handleModalClose : function(comp, event, helper) {
        $A.util.removeClass(comp.find('smeModal'), 'slds-fade-in-open');
        $A.util.removeClass(comp.find('smeBack'), 'slds-backdrop_open');
    },
    
    handleIdentifyTypeChange : function(comp, event, helper) {
        let identifyVals = comp.get('v.identifyValue');
        if(identifyVals === undefined || identifyVals.length == 0) {
            comp.set('v.identifyValue', ['garp','system','self']); 
        }
        helper.loadPickValues(comp);
    }

    // No longer needed - Pre filter replaced post filter
    /* handleIdentifyFilter : function(comp, event, helper) {
        helper.filterByIdentify(comp);
    }, */
})