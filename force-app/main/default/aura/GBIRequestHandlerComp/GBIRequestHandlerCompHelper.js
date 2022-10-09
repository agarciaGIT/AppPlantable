({
    // Load Current User with Apex
    loadUser: function(comp) {
        comp.set('v.isLoading', true);
        
        let loadUserAction = comp.get('c.loadUser');
        
        loadUserAction.setCallback(this, function(resp) {
            let state = resp.getState();
            
            if('SUCCESS' === state) {
                let user = resp.getReturnValue();
				comp.set('v.currentUser', user);
            }else {
                console.error(resp);
            }
            
            comp.set('v.isLoading', false);
        });
        
        $A.enqueueAction(loadUserAction);
    },
    
    // Set Application Options and default to the first
	setApp: function(comp) {
        // Database Request currently not enabled: {label:'Database Request', value:'GBI_Database_Request'}
        let appOpts = [
            {label:'Study Loader', value:'GBI_Study_Loader'}, 
            {label:'Study File Listener', value:'GBI_Study_File_Listener'}
        ];
        
        comp.set('v.appOpts', appOpts);
        comp.set('v.selectedApp', appOpts[0].value);
	},
    
    // Set Process Options and default to the first
    setProcess: function(comp) {
        let selectedApp = comp.get('v.selectedApp');
        let processOpts;
        
        switch(selectedApp) {
            case 'GBI_Study_Loader':
                processOpts = [
                    {label:'Write-Database', value:'write-database'},
                    {label:'Load-Template', value:'load-template'},
                    {label:'Load-Ratios', value:'load-ratios'},
                    {label:'Load-Data', value:'load-data'},
                    {label:'Generate-Qualitative', value:'generate-qualitative'},
                    {label:'Load-Ratio-Exclusions', value:'load-ratio-exclusions'},
                    {label:'Run-Analysis', value:'run-analysis'}
                ];
        		break;
        	case 'GBI_Study_File_Listener':
        		processOpts = [{label:'Run-Listener', value:'run-listener'}];
               	break;
            case 'GBI_Database_Request':
                processOpts = [
                    {label:'Get-Study-Parts-By-Study', value:'get-study-parts-by-study'},
                    {label:'Get-Ratio-Set-Index-By-Study', value:'get-ratio-set-index-by-study'},
                    {label:'Get-Ratio-Number-By-Study', value:'get-ratio-number-by-study'}
                ];
                break;
        }
        
        comp.set('v.processOpts', processOpts);
        comp.set('v.selectedProcess', processOpts[0].value);
    },
    
    // Setup display conditions of Parameters for Application
    setAppParameterDisplay: function(comp) {
        let selectedProcess = comp.get('v.selectedProcess');
        let displayList;
        
        switch(selectedProcess) {
            case 'write-database':
				displayList = [true, true, true, false];
	            break;
            case 'load-template':
				displayList = [true, true, true, false];
	            break;
            case 'load-ratios':
				displayList = [true, true, false, false];
	            break;
            case 'load-data':
				displayList = [true, true, true, true];
	            break;
	        case 'generate-qualitative':
				displayList = [true, true, false, false];
	            break;
            case 'load-ratio-exclusions':
				displayList = [true, true, false, false];
	            break;
            case 'run-analysis':
				displayList = [true, true, false, true];
	            break;
	        case 'run-listener':
				displayList = [true, false, false, false];
	            break;
            case 'get-study-parts-by-study':
				displayList = [true, true, false, false];
	            break;
            case 'get-ratio-set-index-by-study':
				displayList = [true, true, false, false];
	            break;
            case 'get-ratio-number-by-study':
				displayList = [true, true, false, false];
	            break;
        }
        
        comp.set('v.appParameterDisplay', displayList);
        
        // Show Addional Parameters for Run Analysis only
        comp.set('v.showAdditionalParas', 'run-analysis' === selectedProcess);
    },
    
    // For certain Process, require Study Part
    setRequiredFields: function(comp) {
    	let selectedProcess = comp.get('v.selectedProcess');
        let requirePartSet = new Set(comp.get('v.studyPartRequiredProcess'));
        
		comp.set('v.studyPartRequired', requirePartSet.has(selectedProcess));
    },
    
    // Load "In Progress" Studies for Database Options
    loadDatabase: function(comp) {
        comp.set('v.isLoading', true);
        
        let loadStudiesAction = comp.get('c.loadStudies');
        
        loadStudiesAction.setCallback(this, function(resp) {
            let state = resp.getState();
            
            if('SUCCESS' === state) {
                let databaseOpts = [];
                
                for(let study of resp.getReturnValue()) {
                    databaseOpts.push({label: study.Name, value: study.Id});
                }

                comp.set('v.databaseOpts', databaseOpts);
            }else {
                console.error(resp);
            }
            
            comp.set('v.isLoading', false);
        });
        
        $A.enqueueAction(loadStudiesAction);
    },
    
    // Load Study Detail, Study Version and Study Metadata with given Study Id 
    loadStudyDetail: function(comp) {
        comp.set('v.isLoading', true);
        
        let loadStudyAction = comp.get('c.loadStudy');
        
        loadStudyAction.setParams({
            studyId: comp.get('v.selectedDatabase')
        });
        
        loadStudyAction.setCallback(this, function(resp) {
			let state = resp.getState();
            
            if('SUCCESS' === state) {
                this.setStudyDetailValues(comp, resp.getReturnValue());
                
				this.setDefaultClientAttributeOpts(comp);
                this.setDefaultClientMetadataOpts(comp);
            }else {
                console.error(resp);
            }
            
            comp.set('v.isLoading', false);
        });
        
        $A.enqueueAction(loadStudyAction);
    },
    
    
    // Set Study Part, Study Participants, Client Attribute and Client Metadata Options
    setStudyDetailValues: function(comp, studyDetail) {
        // Set Study Part
        let studyPartOpts = [];
        for(let studyRound of studyDetail.studyRounds) {
            let studyPart = studyRound.Study_Part__c;
            if(studyPart) {
                studyPartOpts.push({label: studyPart, value: studyPart});
            }
        }
        comp.set('v.studyPartOpts', studyPartOpts);
        
        // Set Study Participant and Client Attribute
        let studyParticipantsOpts = [];
        let regionSet = new Set(), countryCodeSet = new Set(), countrySet = new Set();
        for(let studyAccount of studyDetail.studyAccounts) {
            // Add Study Participants Options
            studyParticipantsOpts.push({label: studyAccount.Name, value: studyAccount.Account__c});
            
            // Add Client Attribute Value Options
            if(studyAccount.Account__r) {
                let gbiRegion = studyAccount.Account__r.GBI_Region__c;
                let countryCode = studyAccount.Account__r.GBI_Country_Code__c;
                let country = studyAccount.Account__r.BillingCountry;
                
                if(gbiRegion) {
                    for(let oneRegion of gbiRegion.split(';')) {
                        regionSet.add(oneRegion);
                    }
                }
                if(countryCode) countryCodeSet.add(countryCode);
                if(country) countrySet.add(country);
            }
        }
        comp.set('v.studyParticipantsOpts', studyParticipantsOpts);
        
        let regions = Array.from(regionSet).sort().map(ele => {return {label: ele, value: ele}}), 
            countryCodes = Array.from(countryCodeSet).sort().map(ele => { return {label: ele, value: ele}}), 
            countries = Array.from(countrySet).sort().map(ele => {return {label: ele, value: ele}});
        let allClientAttrValueOpts = {
            GBI_Region__c: regions,
            GBI_Country_Code__c: countryCodes,
            BillingCountry: countries
        };
        comp.set('v.allClientAttrValueOpts', allClientAttrValueOpts);
        
        // Set Client Metadata
        let gbiMetaYearTogSib = {};
        let yearSet = new Set();
        for(let gbiMeta of studyDetail.gbiMetadata) {
            let year = gbiMeta.Year__c;
            yearSet.add(year);
            
            let gSib = gbiMeta.G_SIB__c;
            if(gbiMetaYearTogSib[year]) {
                gbiMetaYearTogSib[year].add(gSib);
            }else {
                gbiMetaYearTogSib[year] = new Set([gSib]);
            }
        }
        let years = Array.from(yearSet).sort().map(ele => {return {label: ele, value: ele}});
        comp.set('v.clientMetadataKeyValueOpts', years);
        
        let allClientMetadataValueOpts = {};
        for(let year of yearSet) {
            let gSibSet = gbiMetaYearTogSib[year];
            allClientMetadataValueOpts[year] = Array.from(gSibSet).sort().map(ele => {return {label: '' + ele, value: '' + ele}});
        }
        comp.set('v.allClientMetadataValueOpts', allClientMetadataValueOpts);
    },
    
    // Set default Client Attribute Options and defaults
    setDefaultClientAttributeOpts : function(comp) {
        // Set Default values for Client Attribute Key & Value Opts
        let firstClientKey = comp.get('v.clientAttrKeyOpts')[0].value;
        let firstClientValueOpts = comp.get('v.allClientAttrValueOpts')[firstClientKey];
        comp.set('v.selectedClientAttrKey', firstClientKey);
        comp.set('v.clientAttrValueOpts', firstClientValueOpts);  
    },
    
    // Set default Client Metadata Options and defaults
    setDefaultClientMetadataOpts : function(comp) {
        // Set Default values for Client Metadata Attribute & Key
        let firstAttr = comp.get('v.clientMetadataAttrOpts')[0].value;
        let firstKey = comp.get('v.clientMetadataKeyOpts')[0].value;
        comp.set('v.selectedClientMetadataAttr', firstAttr);
        comp.set('v.selectedClientMetadataKey', firstKey);  
    },
    
    // Clear Study related parameters
    clearStudyParameters: function(comp) {
        comp.set('v.selectedStudyPart', null);
        comp.set('v.selectedStudyParticipants', []);
        
        comp.set('v.clientAttr', []);
        comp.set('v.selectedClientAttrValue', null);
        
        comp.set('v.clientMeta', []);
        comp.set('v.selectedClientMetadataKeyValue', null);
        comp.set('v.selectedClientMetadataValue', null);
    },
    
    // Clear Ratio related parameters
    clearRatioParameters: function(comp) {
    	comp.set('v.inputRatioSetComposition', null);
        comp.set('v.inputAssociatedRatioSetXID', null);
        comp.set('v.inputRatioSetDescription', null);
    },
    
    // Add new Client Attribute to list
    addClientAttribute: function(comp) {
        let key = comp.get('v.selectedClientAttrKey'), value = comp.get('v.selectedClientAttrValue');
        
        if(key && value) {
            let clientAttr = comp.get('v.clientAttr');
            let clientAttrIndex = comp.get('v.clientAttrIndex') + 1;
            clientAttr.push({
                index: clientAttrIndex,
                key: key,
                value: value
            });
            
            comp.set('v.clientAttr', clientAttr);
            comp.set('v.clientAttrIndex', clientAttrIndex);
        }else {
            alert('Please select Client Attribute Key and Value.');
        }
    },
    
    // Add new Client Metadata to list
    addClientMetadata: function(comp) {
        let attr = comp.get('v.selectedClientMetadataAttr'), key = comp.get('v.selectedClientMetadataKey'),
            keyValue = comp.get('v.selectedClientMetadataKeyValue'), value = comp.get('v.selectedClientMetadataValue');
        
        if(attr && key && keyValue && value) {
            let clientMeta = comp.get('v.clientMeta');
            let clientMetaIndex = comp.get('v.clientMetaIndex') + 1;
            clientMeta.push({
                index: clientMetaIndex,
                attr: attr,
                key: key,
                keyValue: keyValue,
                value: value
            });
            
            comp.set('v.clientMeta', clientMeta);
            comp.set('v.clientMetaIndex', clientMetaIndex);
        }else {
            alert('Please select Client Metadata Attribute, Key, KeyValue and Value.');
        }
    },
    
    // Validate Required Parameters
    checkRequiredParameters: function(comp) {
        let allValid = true;
        let requiredFields = [];
        
        let selectedProcess = comp.get('v.selectedProcess');
        if('run-listener' != selectedProcess) {
        	requiredFields.push('database_select');
        }
        
		let requirePartSet = new Set(comp.get('v.studyPartRequiredProcess'));
        if(requirePartSet.has(selectedProcess)) {
            requiredFields.push('studyPart_select');
        }
        
        requiredFields.forEach(fld => {
            let oneEle = comp.find(fld);
            let validState = oneEle.checkValidity();
            
            allValid = allValid && validState;
            if(!validState) oneEle.reportValidity();
        });
        
        return allValid;
    },
    
    // Submit GBI Request to GBI Server
    enqueueJob: function(comp) {
        comp.set('v.isLoading', true);
        
    	let submitAction = comp.get('c.enqueueGBIRequest');
        
        submitAction.setParams({
            reqBody: this.constructRequest(comp)
        });
        
        submitAction.setCallback(this, function(resp) {
            let state = resp.getState();
            
            if('SUCCESS' === state) {
                let result = resp.getReturnValue();
                
                // Set Display of submitted requests
                this.setEnqueuedRequest(comp, result);
            }else {
                console.error(resp);
            }
            
            comp.set('v.isLoading', false);
        });
        
        $A.enqueueAction(submitAction);
    },
    
    // Construct GBI Request body
    constructRequest: function(comp) {
        let selectedProcess = comp.get('v.selectedProcess');
		let reqObj = {
            AppName: comp.get('v.selectedApp'),
            AppRoute: comp.get('v.selectedProcess'),
            database: comp.get('v.selectedDatabase')
        };
        
        if('run-listener' !== selectedProcess) {
            reqObj.studyPart = comp.get('v.selectedStudyPart');
        }
        
        if('write-database' === selectedProcess || 'load-template' === selectedProcess || 'load-data' === selectedProcess) {
            reqObj.studyTables = comp.get('v.inputStudyTables');
        }
        
        if('load-data' === selectedProcess || 'run-analysis' === selectedProcess) {
            reqObj.studyParticipants = comp.get('v.selectedStudyParticipants').join(',');
        }
            
        if('run-analysis' === selectedProcess) {
            reqObj.ratioSetComposition = comp.get('v.inputRatioSetComposition');
            reqObj.associatedRatioSetXID = comp.get('v.inputAssociatedRatioSetXID');
            reqObj.ratioSetDescription = comp.get('v.inputRatioSetDescription');
                    
            reqObj.clientAttr = [];
            for(let oneClientAttr of comp.get('v.clientAttr')) {
                // GBI Server requires String instead of actual object
                reqObj.clientAttr.push(`{${oneClientAttr.key}:${oneClientAttr.value}}`);
            }
            // For first round, if only one attribute selected, skip array
            if(reqObj.clientAttr.length == 1) {
                reqObj.clientAttr = reqObj.clientAttr[0];
            }
            
            reqObj.clientMeta = [];
            for(let oneClientMeta of comp.get('v.clientMeta')) {
                reqObj.clientMeta.push(`${oneClientMeta.attr}:{${oneClientMeta.key}:${oneClientMeta.keyValue},value:${oneClientMeta.value}}`);
            }
            // For first round, if only one attribute selected, skip array
            if(reqObj.clientMeta.length == 1) {
                reqObj.clientMeta = reqObj.clientMeta[0];
            }
        }

        // Clear out nulls in JSON
        let reqStr = JSON.stringify(reqObj, (key, value) => {
            if(Array.isArray(value)) {
            	if(value.length > 0) {
            		return value;
        		}
        	}else if(value) {
            	return value;
        	}
        });
        
        return reqStr;
    },
 
 	setEnqueuedRequest: function(comp, result) {
    	let allReqs = comp.get('v.enqueuedRequests');
    
    	let enqueuedReq = {
            index: allReqs.length + 1,
            time: new Date(),
            status: `${result.statusCode} - ${result.status}`,
            app: comp.get('v.selectedApp'),
            process: comp.get('v.selectedProcess'),
            database: comp.get('v.selectedDatabase')
        };

    	allReqs.push(enqueuedReq);
    
    	comp.set('v.enqueuedRequests', allReqs);
    },
        
    enqueueDeleteJob: function(comp) {
        comp.set('v.loading', true);
        
    	let deleteJobAction = comp.get('c.enqueueDeleteGBIRequest');
        
        deleteJobAction.setCallback(this, (resp) => {
            let state = resp.getState();
            
            if('SUCCESS' === state) {
            	let result = resp.getReturnValue();
                if(200 === result.statusCode) {
                	comp.set('v.enqueuedRequests', []);
                }else {
                	console.error(resp);                    
                }
			}
            comp.set('v.loading', false);
        });
        
        $A.enqueueAction(deleteJobAction);
    }
})