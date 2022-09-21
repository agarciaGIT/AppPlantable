import { api, LightningElement, track, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import accountId from '@salesforce/schema/Plant_Subscription__c.Plant_Account__c';
import getAuthorizationToken from "@salesforce/apex/Plant_Edit_SubscriptionController.getAuthorizationToken";
import subscriptionNameField from '@salesforce/schema/Plant_Subscription__c.Name';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getMeals from "@salesforce/apex/Plant_NewOrderCustomerController.getMeals";

export default class plant_Edit_Subscription extends LightningElement {

    @api recordId;
    @track selectedMealList = new Array();
    @track showUpdateCustomizeMealButton = true;
    @track selectedSubscription = {Id : '' , Name : ''};
    @track customerAccount = {"Id" : '', "Token" : '' , validToken : false}
    allMealsBackupList = new Array();
    @track showSpinner = false;

    @wire(getRecord, { recordId: "$recordId", fields:[accountId , subscriptionNameField]})
    subscriptionRecord({data,error}){
        if(data){
            //console.log('Record Data ::', data)
            this.selectedSubscription.Name = (getFieldValue(data, subscriptionNameField) ? getFieldValue(data, subscriptionNameField) : '');
            this.selectedSubscription.Id = (this.recordId);
            if(getFieldValue(data, accountId) && getFieldValue(data, accountId) != ''){
                this.customerAccount.Id = getFieldValue(data, accountId);
                if(this.customerAccount.Id && this.customerAccount.Id != ''){
                    getAuthorizationToken({accountId : this.customerAccount.Id }).then(response =>{
                        response = JSON.parse(response);
                        this.customerAccount.Token = (response.token && response.token != '' ?  response.token : '' );
                        this.customerAccount.validToken = ((response.validToken != null && response.validToken != undefined ?  response.validToken : false ))
                        if(!this.customerAccount.validToken){
                            this.showCustomErrorMessage((response.tokenMesssage && response.tokenMesssage != '' ? response.tokenMesssage : 'Token is not valid') , 'Error' , 'error' , 'sticky');
                        }
                    }).catch(error =>{
                        console.log('getAuthorizationToken Error::',error);
                    })
                }
                else{
                    this.showCustomErrorMessage('AccountId is null!' , 'Error' , 'error' , 'sticky');
                }
            }
        }
    }

    connectedCallback(){
		this.showSpinner = true;
		getMeals()
			.then(response => {
				response = JSON.parse(response);
				if (response.statusCode == 200) {
					this.allMealsBackupList = response.result.resultArr;
					//console.log('allMealsBackupList:::'+JSON.stringify(response.result.resultArr))
				}
				this.showSpinner = false;
			}).catch(error => {
				this.showSpinner = false;
				console.log('error::get meals::', error);
			})
	}

    handleButton(event){
        console.log('handleButton');
    }

    handleChange(event){
        console.log('handle Change')
    }

    handleRecordSelection(event){
        console.log('Selected Lookup ::',JSON.stringify(event.detail));
        if(event.detail.object == 'Plant_Subscription__c'){
            this.selectedSubscription.Id = (event.detail.selectedRecordId && event.detail.selectedRecordId != '' ? event.detail.selectedRecordId : '');
            this.selectedSubscription.Name = (event.detail.selectedValue && event.detail.selectedValue != '' ? event.detail.selectedValue : '');

            if(this.selectedSubscription.Id && this.selectedSubscription.Id != '' ){

            }
            else{
            }
        }
    }

    showCustomErrorMessage(message, title, variant, mode) {
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant,
			mode: mode
		});
		this.dispatchEvent(evt);
	}
}