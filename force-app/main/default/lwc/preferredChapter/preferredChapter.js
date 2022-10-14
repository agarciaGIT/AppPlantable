import { LightningElement, track } from 'lwc';
import getMembershipDetails from '@salesforce/apex/DashboardController.getMembershipDetails';

export default class PreferredChapter extends LightningElement {
    @track primaryChapter;
    @track secondaryChapter; 
    @track errorMessage;

    connectedCallback(){
        getMembershipDetails().then(result => {
            //alert('result'+JSON.stringify(result));
            this.primaryChapter = result.KPI_Primary_Chapter_Name__c;
            this.secondaryChapter = result.KPI_Secondary_Chapter_Name__c;
        })
        .catch(error => {
            alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
        })
    }
}