import { LightningElement,wire,api,track } from 'lwc';
import searchInstitutions from '@salesforce/apex/GARP_MC_PublicForms.searchInstitutions';
import { util_console, util_validateForm, util_isDefined } from 'c/common';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

export default class lwcCustomLookup extends LightningElement {
    @api institutionType = 'Organization';
    @api selectRecordId = '';
    @api selectRecordName;
    @api Label;
    @api searchRecords = [];
    @api required = false;
    @api iconName = 'action:new_account'
    @api LoadingText = false;
    @api fieldError = 'This is a required field';
    
    @track txtclassname = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
    @track messageFlag = false;
    @track iconFlag =  true;
    @track clearIconFlag = false;
    @track inputReadOnly = false;

    get isOrganization(){
        return this.institutionType == "Organization";
    }

    get isAcademic(){
        return this.institutionType == "Academic";
    }
    
   
    @track pageRef = {name: 'GARP-USER-PORTAL', source: 'common'};

    connectedCallback() {
        registerListener('validateCompanyNotification', this.validateInput, this);

        if(this.selectRecordName != null) {
            this.iconFlag = false;
            this.clearIconFlag = true;
        }
    }

    searchField(event) {
        var currentText = event.target.value;

        if(currentText.length < 3) {
            this.messageFlag = false;
            return;
        }
        this.LoadingText = true;
        this.iconFlag = true;
        
        console.log('search:' + currentText);

        searchInstitutions({ searchTerm: currentText, institutionType: this.institutionType  })
        .then(result => {

            console.log('result:');
            console.dir(result);

            this.searchRecords= result;
            this.LoadingText = false;
            
            this.txtclassname =  result.length > 0 ? 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click slds-is-open' : 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
            if(currentText.length > 0 && result.length == 0) {
                this.messageFlag = true;
            }
            else {
                this.messageFlag = false;
            }

            if(this.selectRecordId != null && this.selectRecordId.length > 0) {
                this.iconFlag = false;
                this.clearIconFlag = true;
            }
            else {
                this.iconFlag = true;
                this.clearIconFlag = false;
            }

            const searchEvent = new CustomEvent('search', { detail: {currentText}, });
            this.dispatchEvent(searchEvent);
        })
        .catch(error => {
            this.LoadingText = false;
            console.log('-------error-------------'+error);
            console.log(error);
        });
        
    }
    
    acceptSelection(event) {
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.inputReadOnly = true;
        this.LoadingText = false;
        this.messageFlag = false;
        var selVal = '';
        this.template.querySelectorAll('lightning-input, lightning-combobox').forEach(function(inputCmp) {
            selVal = inputCmp.value;
        });
        this.selectRecordName = selVal;

        console.log('selectRecordName',selVal);

        // Dispatches the event.
        var selectName = selVal;
        var currentRecId = selVal;
        const selectedEvent = new CustomEvent('selected', { detail: {selectName, currentRecId}, });
        this.dispatchEvent(selectedEvent);
    }

   setSelectedRecord(event) {
        var currentRecId = event.currentTarget.dataset.id;
        var selectName = event.currentTarget.dataset.name;
        this.txtclassname =  'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click';
        this.iconFlag = false;
        this.clearIconFlag = true;
        this.inputReadOnly = true;
        this.selectRecordName = event.currentTarget.dataset.name;
        this.selectRecordId = currentRecId;
        const selectedEvent = new CustomEvent('selected', { detail: {selectName, currentRecId}, });
        this.validateInput();
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }
    
    resetData(event) {
        this.selectRecordName = "";
        this.selectRecordId = "";
        this.inputReadOnly = false;
        this.iconFlag = true;
        this.clearIconFlag = false;

        var selectName = "";
        var currentRecId = "";
        const selectedEvent = new CustomEvent('selected', { detail: {selectName, currentRecId}, });
        this.dispatchEvent(selectedEvent);
    }


    validateInput() {
        if(!util_isDefined(this,"selectRecordName") || this.selectRecordName.length == 0) {
            this.template.querySelectorAll('lightning-input, lightning-combobox').forEach(function(inputCmp) {
                inputCmp.value = '';
            });
        }
        util_validateForm(this.template);
    }

}