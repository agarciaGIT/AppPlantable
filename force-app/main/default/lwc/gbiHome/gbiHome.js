import { LightningElement, track } from 'lwc';
import getContactDetails from '@salesforce/apex/DashboardController.getMembershipDetails';

export default class GbiHome extends LightningElement {
    @track GBIAnalyticsParticipant= false;
    errorMessage ='';
    @track isStudySectionVisible = true;
    @track isAboutSectionVisible = false;
    @track isPillarSectionVisible = false;
    @track isDocumentSectionVisible = false;
    @track isProfileSectionVisible = false;
    @track isSupportSectionVisible = false;

    connectedCallback(){
        getContactDetails().then(result => {
            //alert('result'+JSON.stringify(result));
            this.GBIAnalyticsParticipant = result.GBI_Analytics_Participant__c;
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
        })
    }

    signOut(){
        window.location.href='https://devapr22-mygarp.cs213.force.com/gbi/secur/logout.jsp?start=GBI';
    }

    handleChangeSection(event){
        var sectionName = event.currentTarget.dataset.id;
        console.log('sectionName:'+sectionName);
        if(sectionName == 'study'){
            this.isStudySectionVisible = true;
            this.isPillarSectionVisible = false;
            this.isDocumentSectionVisible = false;
            this.isProfileSectionVisible = false;
            this.isSupportSectionVisible = false;
            this.isAboutSectionVisible = false;
        }
        if(sectionName == 'pillar'){
            this.isStudySectionVisible = false;
            this.isPillarSectionVisible = true;
            this.isDocumentSectionVisible = false;
            this.isProfileSectionVisible = false;
            this.isSupportSectionVisible = false;
            this.isAboutSectionVisible = false;
        }
        if(sectionName == 'document'){
            this.isStudySectionVisible = false;
            this.isPillarSectionVisible = false;
            this.isDocumentSectionVisible = true;
            this.isProfileSectionVisible = false;
            this.isSupportSectionVisible = false;
            this.isAboutSectionVisible = false;
        }
        if(sectionName == 'profile'){
            this.isStudySectionVisible = false;
            this.isPillarSectionVisible = false;
            this.isDocumentSectionVisible = false;
            this.isProfileSectionVisible = true;
            this.isSupportSectionVisible = false;
            this.isAboutSectionVisible = false;
        }
        if(sectionName == 'support'){
            this.isStudySectionVisible = false;
            this.isPillarSectionVisible = false;
            this.isDocumentSectionVisible = false;
            this.isProfileSectionVisible = false;
            this.isSupportSectionVisible = true;
            this.isAboutSectionVisible = false;
        }
        if(sectionName == 'about'){
            this.isStudySectionVisible = false;
            this.isPillarSectionVisible = false;
            this.isDocumentSectionVisible = false;
            this.isProfileSectionVisible = false;
            this.isSupportSectionVisible = false;
            this.isAboutSectionVisible = true;
        }
    }
}