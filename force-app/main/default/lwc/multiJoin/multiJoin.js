// Platform imports
import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

// Apex controller imports
import loadRecentQuery from '@salesforce/apex/MultiJoinCtrl.loadRecentQuery';
import loadObjectList from '@salesforce/apex/MultiJoinCtrl.loadObjectList';
import saveAllQueries from '@salesforce/apex/MultiJoinCtrl.saveAllQueries';
import loadSubQueries from '@salesforce/apex/MultiJoinCtrl.loadSubQueries';
import loadUseSaveFeature from '@salesforce/apex/MultiJoinCtrl.loadUseSaveFeature';
//import loadObjectNames from '@salesforce/apex/MultiJoinCtrl.loadObjectNames';

export default class MultiJoin extends LightningElement {
    @track error;
    @track loading = true;
	@track useSaveFeature;
    @track toggleIcon = 'utility:chevronup';
    @track isExpand = true;
    colors = ['honeydew', 'aliceblue', 'antiquewhite', 'beige', 'bisque', 'cadetblue'];
    
    // For recent query selection
    @track selectedQuery;
    @track recentQueries;
    recentQueryDetail = {};
    
    // For query inputs
    @track mainQry;
    @track mainObject;
    mainObjectBkup;

    @track subQryList = [
        {index: 'subQry_1', selRelFilter: 'all', filterGrpName: 'filterGrp_1', disabled: true}, 
        {index: 'subQry_2', selRelFilter: 'all', filterGrpName: 'filterGrp_2', disabled: true}
    ];
    // Holding raw sub query result
    @track subObjectList;
    subQryCnt = 2;

    relFilterOpts = [{label: 'All', value:'all'}, {label: 'Have Related', value: 'have'}, {label: 'No Related', value: 'no'}];
    
    // For sObject Combobox
    //@track mainObj;
    //@track objOptions;

    // On component init
    connectedCallback() {
		loadUseSaveFeature().then(useSave => {
            this.error = null;
            this.useSaveFeature = useSave;
            
            if(this.useSaveFeature) {
                this.loadRecentQueries(false);
            }else {
                this.loading = false;
            }
        }).catch(err => {
            this.error = err;
        });

        /* loadObjectNames().then(objNames => {
            this.error = null;
            let opts = [{label: 'Select One', value: 'select_one'}];

            for(let onePair of objNames) {
                opts.push({label: onePair.key, value: onePair.value});
            }

            this.mainObj = 'select_one';
            this.objOptions = opts;
        }).catch(err => {
            this.error = err;
        }); */
    }

    // If setRecent, select first option for recent query 
    loadRecentQueries(setRecent) {
        loadRecentQuery().then(rqList => {
            this.error = null;
            let opts = [{label: 'Select One', value: 'select_one'}];
            
            if(rqList && rqList.length > 0) {
                for(let rq of rqList) {
                    this.recentQueryDetail[rq.Name] = rq;
                    opts.push({label: rq.Name + ' - ' + rq.Query__c, value: rq.Name});
                }

                if(setRecent) {
                    this.selectedQuery = opts[1].value;
                }else {
                    this.selectedQuery = 'select_one';
                }
            }

            this.recentQueries = opts;
            this.loading = false;
        }).catch(err => {
            this.error = err;
            this.loading = false;
        });
    }

    handleToggle() {
        this.isExpand = !this.isExpand;
        this.toggleIcon =  this.isExpand ? 'utility:chevronup' : 'utility:chevrondown';
    }

    handleQueryChange(event) {
        // Set main query value from selected recent query
        this.selectedQuery = event.detail.value;
        let recentQryObj = this.recentQueryDetail[this.selectedQuery];
        this.mainQry = recentQryObj.Query__c;

        // Load Sub Query value only. Records loaded by user action
        if(recentQryObj.Sub_Queries__r && recentQryObj.Sub_Queries__r.length > 0) {
            this.subQryList = [];
            let i = 1;
            
            for(let recentSubQry of recentQryObj.Sub_Queries__r) {
                this.subQryList.push(
                    {index: 'subQry_' + i, selRelFilter: 'all', filterGrpName: 'filterGrp_' + i, disabled: true, qry: recentSubQry.Query__c, lookup: recentSubQry.Sub_Query_Lookup__c});
                i++;
            }

            this.subQryCnt = this.subQryList.length;
        }

        this.loadQueryList(this.mainQry, true);
    }

    handleKeyUp(evt) {
        const isEnterKey = evt.keyCode === 13;

        // Set main query value from query text input
        if(isEnterKey) {
            this.mainQry = evt.target.value;

            if(this.mainQry) {
                this.loadQueryList(this.mainQry, true);
            }
        }
    }

    // For loading main object
    loadQueryList(inptQry, saveMainQry) {
        this.loading = true;
        let save = saveMainQry && this.useSaveFeature;

        loadObjectList({inptQry: inptQry, saveQry: save}).then(queryResult => {
            this.error = null;
            this.mainObject = queryResult;
            this.mainObjectBkup = this.getNewObject(this.mainObject);

            if(save) {
                this.loadRecentQueries(true);
            }else {
                this.loading = false;
            }
        }).catch(err => {
            this.error = err;
            this.loading = false;
        });
    }

    // For sub query inputs
    setSubQuery(event) {
        let index = event.target.dataset.index;

        this.subQryList.forEach(ele => {
            if(ele.index === index) {
                ele.qry = event.target.value;
            }
        });
    }

    setLookup(event) {
        let index = event.target.dataset.index;

        this.subQryList.forEach(ele => {
            if(ele.index === index) {
                ele.lookup = event.target.value;
            }
        });
    }

    removeSubQuery(event) {
        let index = event.target.dataset.index;

        this.subQryList = this.subQryList.filter(ele => ele.index !== index);
    }

    addRelateObject() {
        this.subQryCnt += 1;

        this.subQryList.push({index: 'subQry_' + this.subQryCnt, selRelFilter: 'all', filterGrpName: 'filterGrp_' + this.subQryCnt, disabled: true});
    }

    saveAllQueries() {
        if(this.useSaveFeature) {
            let validSq = this.getValidSubQry();

            saveAllQueries({mainQry: this.mainQry, subQryList: validSq}).then(result => {
                if(!result) {
                    this.err = {msg: 'Queries failed to save. Please check debug logs for detailed reasons.'};
                }else {
                    this.err = null;
                    let evt = new ShowToastEvent({
                        title: 'Queries Saved',
                        message: 'Queries saved successfully.',
                        variant: 'success',
                    });
                    this.dispatchEvent(evt);
                }
            });
        }
    }

    loadRelateObjects() {
        this.loading = true;

        let qryList = this.getValidSubQry();
        let mainIds = [];

        // Reset main object from back up since main object may be filtered
        this.mainObject = this.getNewObject(this.mainObjectBkup);
        for(let oneRow of this.mainObject.records) {
            mainIds.push(oneRow.Id);
        }

        if(qryList.length > 0 && mainIds.length > 0) {
            loadSubQueries({subQryList: qryList, mainIds: mainIds}).then(subQryResults => {
                this.error = null;
                this.subObjectList = subQryResults;
                
                // Prepare highlight colors
                let colorList = [...this.colors];
                let colorObj = {};
                for(let oneQR of subQryResults) {
                    if(!colorObj[oneQR.objectName]) {
                        colorObj[oneQR.objectName] = colorList.shift();

                        if(colorList.length === 0) {
                            colorList = [...this.colors];
                        }
                    }
                }

                // Map sub query records to main records
                this.mainObject.records.forEach(mainRec => {
                    let mainId = mainRec.Id;
                    mainRec.child = [];

                    for(let oneQR of subQryResults) {
                        let childRecs = oneQR.records.filter(rec => rec[oneQR.lookupField] === mainId);
                        if(childRecs.length > 0) {
                            // Assign color to child records
                            mainRec.child.push({object: oneQR.objectName, fields: oneQR.fieldNames, records: childRecs, color: colorObj[oneQR.objectName]});
                        }
                    }
                });
                
                // Set cloned object to trigger native grid setter
                this.mainObject = this.getNewObject(this.mainObject);
                this.mainObjectBkup = this.getNewObject(this.mainObject);

                // Enable all valid filters and defaults to all
                this.subQryList.forEach(ele => {
                    if(ele.qry && ele.lookup) {
                        ele.selRelFilter = 'all';
                        ele.disabled = false;
                    }
                });

                this.loading = false;
            }).catch(err => {
                this.error = err;
                this.loading = false;
            });
        }
    }
    
    handleDownloadClick() {
        let fileName = new Date().toLocaleDateString('en-US') + '_QueryExport.csv';

        let nlc = '\n';
        let fieldNames = this.mainObject.fieldNames;
        let fileText = fieldNames + nlc;

        this.mainObject.records.forEach(rec => {
            let fldValArr = [];

            for(let oneFld of fieldNames) {
                fldValArr.push(this.getFieldValue(oneFld, rec));
            }

            fileText += '"' + fldValArr.join('","') + '"' + nlc;

            if(rec.child) {
                rec.child.forEach(oneChild => {
                    let records = oneChild.records;
                    records.forEach(oneChildRec => {
                        fileText += '"' + oneChild.object + '","' + JSON.stringify(oneChildRec).replace(/"/g, "'") + '"' + nlc;
                    });
                });
            }
        });

        this.downloadFile(fileName, fileText);
    }
    // End sub query inputs

    // Filter handler
    handleFilterGroupChange(event) {
        let selFilter = event.detail.value;
        let filterGrp = event.target.name;

        // Set value to changed filter
        this.subQryList.forEach(ele => {
            if(ele.filterGrpName === filterGrp) {
                ele.selRelFilter = selFilter;
            }
        });

        // Get all original records
        let tmpMain = this.getNewObject(this.mainObjectBkup);

        // Refresh all filters
        this.subQryList.forEach(ele => {
            if(ele.qry && ele.lookup) {
                let objName = this.getObjectFromQuery(ele.qry);
    
                if('all' !== ele.selRelFilter) {
                    if('have' === ele.selRelFilter) {
                        tmpMain.records = tmpMain.records.filter(mainRec => {
                            if(mainRec.child.length > 0) {
                                let childList = mainRec.child.filter(oneChild => oneChild.object === objName);
                                return childList.length > 0;
                            }
    
                            return false;
                        });
                    }else if('no' === ele.selRelFilter) {
                        tmpMain.records = tmpMain.records.filter(mainRec => {
                            if(mainRec.child.length > 0) {
                                let childList = mainRec.child.filter(oneChild => oneChild.object === objName);
                                return childList.length === 0;
                            }
    
                            return true;
                        });
                    }
                }

                //console.log(`${ele.filterGrpName} - ${objName}: ${ele.selRelFilter} - ${tmpMain.records.length}`);
            }
        });

        this.mainObject = tmpMain;
    }

    // Util function, String parse to get sObject name
    getObjectFromQuery(query) {
        let queryLow = query.toLowerCase();
        let indexSt = queryLow.indexOf('from') + 4, indexEd;

        if(queryLow.includes('where')) {
            indexEd = queryLow.indexOf('where');
        }else if(queryLow.includes('limit')) {
            indexEd = queryLow.indexOf('limit');
        }else {
            indexEd = queryLow.length;
        }

        let objName = query.substring(indexSt, indexEd).trim();
        return objName;
    }

    // Util function for getting valid sub queries
    getValidSubQry() {
        let qryList = [];

        for(let oneRow of this.subQryList) {
            if(oneRow.qry && oneRow.lookup) {
                qryList.push(oneRow);
            }
        }

        return qryList;
    }

    // Util function for getting a cloned object
    getNewObject(inptObj) {
        let retObj = JSON.parse(JSON.stringify(inptObj));
        return retObj;
    }

    // Util function for download current main object
    downloadFile(fileName, fileText) {
        var element = document.createElement('a');

        element.setAttribute('href', 'data:text/csv;charset=utf-8,' + encodeURIComponent(fileText));
        element.setAttribute('download', fileName);
        element.style.display = 'none';

        document.body.appendChild(element);
        element.click();
        document.body.removeChild(element);
    }

    // Util function for getting field value (including reference)
    getFieldValue(oneFld, rec) {
        let fldVal;

        if(oneFld.includes('.')) {
            let objRef = rec;
            for(let objName of oneFld.split('.')) {
                objRef = objRef[objName];
            }
            fldVal = objRef;
        }else {
            fldVal = rec[oneFld];
        }

        return fldVal;
    }

    /* handleMainObjChange(event) {
        this.mainObj = event.detail.value;
    } */
}