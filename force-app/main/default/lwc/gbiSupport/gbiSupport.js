import { LightningElement, track } from 'lwc';
import sendSupportEmail from '@salesforce/apex/DashboardController.sendSupportEmail';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GbiSupport extends LightningElement {
    @track searchValue='';
    @track subjectValue = '';
    @track descriptionValue = '';
    @track isPillar = true;
    errorMessage;

    handleFormInputChange(event){
        if( event.target.name == 'search' ){
            this.searchValue = event.target.value;
        }
        else if( event.target.name == 'subject' ){
            this.subjectValue = event.target.value;
        }
        else if( event.target.name == 'description' ){
            this.descriptionValue = event.target.value;
        }
    }

    handleSubmit(){
        alert(this.subjectValue+'Subject and description:'+this.descriptionValue);
        if(this.subjectValue=='' || this.descriptionValue==''){
            this.showNotification('Error','Please enter case information.','error');
            return false;
        }
        sendSupportEmail({subject :this.subjectValue ,description : this.descriptionValue,isPillar3 : this.isPillar}).then(result => {
            //alert('result'+JSON.stringify(result));
            this.showNotification('Success','Email has been sent to support team.','success');
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.showNotification('Error',this.errorMessage,'error');
        })
    }

    showNotification(title,message,variant) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(evt);
    }

}