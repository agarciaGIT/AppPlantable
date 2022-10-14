import { LightningElement, track, wire, api } from 'lwc';
import getCountries from '@salesforce/apex/LwcLoginPageController.getCountries';
import getIndustries from '@salesforce/apex/LwcLoginPageController.getIndustries';
import getjobFunction from '@salesforce/apex/LwcLoginPageController.getjobFunction';
import register from '@salesforce/apex/LwcLoginPageController.register';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { util_validateForm,util_isDefined } from 'c/common';
import { fireEvent } from 'c/pubsub';

export default class LwcLoginPage extends NavigationMixin(LightningElement) {
    @api firstName;
    @api lastName;
    @api countryValue;
    @api industryValue;
    @api jobValue;
    @api email;
    @api company ='';
    @track countryOptions = []; //this will hold key, value pair
    @track industryOptions = []; //this will hold key, value pair
    @track jobOptions = []; //this will hold key, value pair
    @track url;
    @track errorMessage;
    @track boolVisible = true;
    @api contactId;
    currentText;
    @track isLoading = false;

    @track pageRef = {name: 'GARP-USER-PORTAL', source: 'common'};


    get countries(){
        return this.countryOptions;
    }

    get industries(){
        return this.industryOptions;
    }

    get jobs(){
        return this.jobOptions;
    }

    connectedCallback(){
        getCountries().then(result => {
            //alert('result'+JSON.stringify(result));
            for(var i=0;i<result.length;i++){
                this.countryOptions = [...this.countryOptions,{value:result[i],label:result[i]}];
            }
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.showNotification(this.errorMessage);
        })

        getIndustries().then(result => {
            //alert('industry result'+JSON.stringify(result));
            for(var i=0;i<result.length;i++){
                this.industryOptions = [...this.industryOptions,{value:result[i],label:result[i]}];
            }
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.showNotification(this.errorMessage);
        })

        getjobFunction().then(result => {
            //alert('job result'+JSON.stringify(result));
            for(var i=0;i<result.length;i++){
                this.jobOptions = [...this.jobOptions,{value:result[i],label:result[i]}];
            }
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.showNotification(this.errorMessage);
        })
    }

    handleCountryChange(event) {
        this.countryValue = event.detail.value;
    }

    handleIndustryChange(event) {
        this.industryValue = event.detail.value;
    }

    handleJobChange(event) {
        this.jobValue = event.detail.value;
    }

    handleFormInputChange(event){
        if( event.target.name == 'email' ){
            this.email = event.target.value;
        }
        else if( event.target.name == 'firstName' ){
            this.firstName = event.target.value;
        }
        else if( event.target.name == 'lastName' ){
            this.lastName = event.target.value;
        }
    }

    submitData(){
        //alert('email'+this.email);
       this.isLoading = true;
        if(this.isInputValid()) {
            register({email:this.email,
                firstName:this.firstName,
                lastName:this.lastName,
                country:this.countryValue,
                industry:this.industryValue,
                company:this.company,
                job:this.jobValue}).then(result => {
                this.contactId = result;
                alert('result:'+this.contactId);
                this.boolVisible = false;
                this.isLoading = false;
            })
            .catch(error => {
                //alert('error'+JSON.stringify(error));
                this.errorMessage = error.body.message;
                this.isLoading = false;
                console.log('error:'+JSON.stringify(error));
                this.showNotification(this.errorMessage);
            })
        }else{
            window.setTimeout(() => { this.isLoading = false;}, 2000);
        }
    }

    isInputValid() {
        let isValid = true;
        isValid = util_validateForm(this.template);
        fireEvent(this.pageRef, 'validateCompanyNotification', {});
        if(this.company==undefined || this.company==''){
            isValid = false;
        }
        return isValid && this.handleEmailValidation();
    }

    handleEmailValidation() {
        var flag = true;
        const emailRegex =/^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        let email = this.template.querySelector('.emailAddress');
        console.log('email'+email.value);
        let emailVal = email.value;
        if (!emailVal.match(emailRegex) && emailVal!=null && emailVal!='') {
            flag = false;
            email.setCustomValidity("Please enter valid email");
        } else {
            email.setCustomValidity("");
        }
        email.reportValidity();
        return flag; 
    }

    showNotification(message) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error',
        });
        this.dispatchEvent(evt);
    }

    selectInstitution (event) {
        console.log(event.target.selectName);
        this.company = event.detail.selectName;
    }

    searchInstitution (event) {
        console.log(event.detail.currentText);
        this.currentText = event.detail.currentText;       
    }
}