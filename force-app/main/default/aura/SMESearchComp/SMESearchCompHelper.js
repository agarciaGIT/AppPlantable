({
    searchSME : function(comp) {
        let queryInpt = comp.find('search');
        
        if(queryInpt.get('v.validity').valid) {
            comp.set('v.showSpinner', true);
            
            if(!$A.util.hasClass(comp.find('resultCard'), 'slds-hidden')) {
                $A.util.addClass(comp.find('resultCard'), 'slds-hidden');
            }
            
            let searchType = comp.get('v.searchType');
            let queryTerm = queryInpt.get('v.value');
            let country = comp.get('v.selectedCountry');
            let identifyType = comp.get('v.identifyValue');
            
            console.log(`Searched ${searchType} for ${queryTerm} in country ${country}`);
            
            comp.set('v.searchWord', 'keyword "' + queryTerm + '"');
            
            var searchAct = comp.get('c.searchSMEProfile');
            searchAct.setParams({
                searchWord: queryTerm,
                searchType: searchType,
                country: country,
                identifyType: identifyType
            });
            searchAct.setCallback(this, function(resp) {
                let state = resp.getState();
                
                if('SUCCESS' === state) {
                    comp.set('v.allSMEProfiles', resp.getReturnValue());
                    
                    $A.util.removeClass(comp.find('identifyTypeDiv'), 'slds-hide');
                    this.showResultTable(comp);
                }else {
                    comp.set('v.showSpinner', false);
                }
            });
            
            $A.enqueueAction(searchAct);
        }else {
            queryInpt.showHelpMessageIfInvalid();
        }
    },

    filterSearchSME : function(comp) {
        comp.set('v.showSpinner', true);
        
        if(!$A.util.hasClass(comp.find('resultCard'), 'slds-hidden')) {
            $A.util.addClass(comp.find('resultCard'), 'slds-hidden');
        }
        
        let filters = comp.get('v.filters');
        let filterSearchAct = comp.get('c.filterSearchSME');
        
        filterSearchAct.setParams({
            filterList: filters,
            contactName: comp.find('contactName').get('v.value'),
            country: comp.get('v.selectedCountry'),
            identifyTypes: comp.get('v.identifyValue')
        });
        
        filterSearchAct.setCallback(this, function(resp) {
            let state = resp.getState();
            
            if('SUCCESS' === state) {
                comp.set('v.allSMEProfiles', resp.getReturnValue());
                comp.set('v.searchWord', 'given criteria');
                
                this.showResultTable(comp);
            }else {
                comp.set('v.showSpinner', false);
            }
        });
        
        $A.enqueueAction(filterSearchAct);
    },

    setSearchCols : function(comp) {
        let actions = [
            {label: 'View SME Profile', name: 'viewSME'},
            {label: 'Go To SME Profile', name: 'goToSME'},
            {label: 'Go to Contact', name: 'goToContact'}
        ];
        
        let cols = [
            {label: 'Contact Name', fieldName: 'contactUrl', type: 'url', typeAttributes: {target: '_balnk', label: {fieldName: 'contactName'}}},
            {label: 'Email', fieldName: 'Contact_Email__c', type: 'email'},
            {label: 'GARP ID', fieldName: 'GARP_Member_ID__c', type: 'text'},
            {label: 'Country', fieldName: 'contactCountry', type: 'text'},
            {label: 'Article Author Count', fieldName: 'Article_Author_Count__c', type: 'number'},
            {label: 'Chapter Speaker Count', fieldName: 'Chapter_Speaker_Count__c', type: 'number'},
            {label: 'Event Speaker Count', fieldName: 'Event_Speaker_Count__c', type: 'number'},
            {label: 'Podcast Presenter Count', fieldName: 'Podcast_Presenter_Count__c', type: 'number'},
            {label: 'Webcast Presenter Count', fieldName: 'Webcast_Presenter_Count__c', type: 'number'},
            {type: 'action', typeAttributes: {rowActions: actions}}
        ];
        
        if(comp.get('v.searchType') == 'category') {
            cols.splice(4, 0, {label: 'Matching Field', fieldName: 'matchingField', type: 'text'});
        }
        
        comp.set('v.columns', cols);
    },
    
    showResultTable : function(comp) {
        this.setSearchCols(comp);
        
        let smeProfs = comp.get('v.allSMEProfiles');
        
        for(let oneProf of smeProfs) {
            if(oneProf.Contact__r) {
                oneProf.contactUrl = '/' + oneProf.Contact__c;
                oneProf.contactName = oneProf.Contact__r.Name;
                oneProf.contactCountry = oneProf.Contact__r.MailingCountry;
            }
            
            if(comp.get('v.searchType') == 'category') {
                let srchKey = comp.find('search').get('v.value');
                let srchKeyLower = srchKey.toLowerCase();
        
                let srchFlds = 'Credit_Risk__c, Credit_Risk_Sys__c, Credit_Risk_GARP__c, Culture_Governance__c, Culture_Governance_Sys__c, Culture_Governance_GARP__c, Energy__c, Energy_Sys__c, Energy_GARP__c, Expert_Participation__c, Expert_Participation_Sys__c, Expert_Participation_GARP__c, Market_Risk__c, Market_Risk_Sys__c, Market_Risk_GARP__c, Operational__c, Operational_Sys__c, Operational_GARP__c, Publishing_Experience__c, Publishing_Experience_Sys__c, Publishing_Experience_GARP__c, Teaching_Experience__c, Teaching_Experience_Sys__c, Teaching_Experience_GARP__c, Technology__c, Technology_Sys__c, Technology_GARP__c';
                let matchStr = [];
                
                for(let oneFld of srchFlds.split(', ')) {
                    if(oneProf[oneFld]) {
                        let fldValue = oneProf[oneFld].toLowerCase();
                        
                        if(srchKeyLower.includes(',')) {
                            let orVals = srchKeyLower.split(',');
                            let hasOne = false;
                            
                            for(let aVal of orVals) {
                                let andVals = aVal.split(';');
                                let hasAll = true;
                                
                                for(let oneAndVal of andVals) {
                                    if(!fldValue.includes(oneAndVal)) {
                                        hasAll = false;
                                        break;
                                    }
                                }
                                
                                if(hasAll) {
                                    hasOne = hasAll;
                                    break;
                                }
                            }
                            
                            if(hasOne) {
                                matchStr.push(this.getFieldDetail(comp, oneFld, oneProf));
                            }
                        }else if(srchKeyLower.includes(';')) {
                            let andVals = srchKeyLower.split(';');
                            let hasAll = true;
                            for(let aVal of andVals) {
                                if(!fldValue.includes(aVal)) {
                                    hasAll = false;
                                    break;
                                }
                            }
                            if(hasAll) {
                                matchStr.push(this.getFieldDetail(comp, oneFld, oneProf));
                            }
                        }else {
                            if(fldValue.includes(srchKeyLower)) {
                                matchStr.push(this.getFieldDetail(comp, oneFld, oneProf));
                            } 
                        }
                    }
                }
                
                if(matchStr.length > 0) {
                    oneProf.matchingField = matchStr.join(', ');
                }
            }
        }
        
        // Initial search result will always be full set of data
        comp.set('v.profilesInTable', smeProfs);
        comp.set('v.allSMEProfiles', smeProfs);
        
        if(smeProfs.length < 10) {
			$A.util.addClass(comp.find('tableDiv'), 'shortTable');
        }else {
            $A.util.removeClass(comp.find('tableDiv'), 'shortTable');
        }
        
        $A.util.removeClass(comp.find('resultCard'), 'slds-hidden');
        $A.util.removeClass(comp.find('tableDiv'), 'slds-hide');
        
        comp.set('v.showSpinner', false);
    },

    showSMEDetail : function(comp, row) {
        let recordId = row.Id;
        
        let fetchAct = comp.get('c.fetchSMEDetail');
        fetchAct.setParams({
            rowId: row.Id
        });
        
        fetchAct.setCallback(this, function(resp) {
            let state = resp.getState();
            
            if('SUCCESS' === state) {
                let smeDetail = resp.getReturnValue();
                comp.set('v.smeDetail', smeDetail);
                
                $A.util.addClass(comp.find('smeModal'), 'slds-fade-in-open');
                $A.util.addClass(comp.find('smeBack'), 'slds-backdrop_open');
            }
        });
        
        $A.enqueueAction(fetchAct);
    },
    
    getFieldDetail : function(comp, fld, profile) {
        let resStr;
        
        if(fld.endsWith('_Sys__c')) {
            resStr = 'System Identify: ' + fld.replace('_Sys__c', '').replace(/_/g, ' ');
            profile.isSysIdentify = true;
        }else if(fld.endsWith('_GARP__c')) {
            resStr = 'GARP Identify: ' + fld.replace('_GARP__c', '').replace(/_/g, ' ');
            profile.isGarpIdentify = true;
        }else {
            resStr = 'Self Identify: '+ fld.replace('__c', '').replace(/_/g, ' ');
            profile.isSelfIdentify = true;
        }
        
        return resStr;
    },

    findFieldLabel : function(comp, fieldAPI) {
        let fldLabel;
        
        comp.get('v.searchFields').forEach((oneFld) => {
            if(oneFld.field == fieldAPI) {
                fldLabel = oneFld.label;
            }
        });
        
        return fldLabel;
    },

    loadCountryValues : function(comp) {
        let fetchCountryAct = comp.get('c.fetchCountries');
        
        fetchCountryAct.setCallback(this, function(resp) {
            let state = resp.getState();
            
            if('SUCCESS' === state) {
                comp.set('v.countries', resp.getReturnValue());

                // Set selected value. Still need 'selected' condition in aura iteration to set display
                //comp.set('v.selectedCountry', 'Worldwide');
            }
        });
        
        $A.enqueueAction(fetchCountryAct);
    },
    
    loadPickValues : function(comp) {
      	let loadPickAct = comp.get('c.fetchPicklistValues');
        loadPickAct.setParams({
            fieldLabel: comp.find('categoryField').get('v.value'),
            identifyTypes: comp.get('v.identifyValue')
        });
        
        loadPickAct.setCallback(this, function(resp) {
            let state = resp.getState();
            if('SUCCESS' === state) {
                let allFldVals = [];

                for(let oneOpt of resp.getReturnValue()) {
                    allFldVals.push({label:oneOpt, value:oneOpt});
                }
                comp.set('v.searchFieldValues', allFldVals);
                
                // Reinit Subcategory multi-select list
                let multiSelComp = comp.find('categoryValue');
                multiSelComp.reInit();
                // Replace placeholder text
                multiSelComp.set('v.infoText', 'Select a Subcategory (Optional)');
                multiSelComp.set('v.infoTextOri', 'Select a Subcategory (Optional)');
                // Init selected values
                comp.set('v.selectedSubcates', []);
            }
        });
        
        $A.enqueueAction(loadPickAct);
    }
    
    // No longer needed - Pre filter replaced post filter
    /* filterByIdentify : function(comp) {
        let newVals = comp.get('v.identifyValue');
        let smeProfs = comp.get('v.allSMEProfiles');
        let filteredProfs = [];
        
        for(let oneProf of smeProfs) {
            if((oneProf.isSysIdentify && newVals.includes('system')) || 
               (oneProf.isGarpIdentify && newVals.includes('garp')) || 
               (oneProf.isSelfIdentify && newVals.includes('self'))) {
                filteredProfs.push(oneProf);
            }
        }
        
        comp.set('v.profilesInTable', filteredProfs);
    }, */
})