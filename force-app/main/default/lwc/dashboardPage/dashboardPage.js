import { LightningElement, track } from 'lwc';
import getUserDetails from '@salesforce/apex/DashboardController.getUserDetails';
import getImageUrl from '@salesforce/apex/DashboardController.getImageUrl';

export default class DashboardPage extends LightningElement {
    @track imageUrl;
    @track firstName;
    @track lastName;
    @track garpMemberId;
    @track frmCertified;
    @track erpCertified;

    errorMessage;
    frmLink = 'https://devapr22-mygarp.cs213.force.com//DigitalBadgeFRM?id=00378000009IZySAAW';
    frmImageUrl = '/resource/1659519089000/sfdcApp/img/CertifiedFRM.png';
    erpLink = 'https://devapr22-mygarp.cs213.force.com//DigitalBadgeERP?id=00378000009IZySAAW';
    erpImageUrl='/resource/1659519089000/sfdcApp/img/CertifiedERP.png';

    connectedCallback(){
        getUserDetails().then(result => {
            //alert('result'+JSON.stringify(result));
            this.firstName = result.Contact.FirstName;
            this.lastName = result.Contact.LastName;
            this.garpMemberId = result.Contact.GARP_Member_ID__c;
            this.frmCertified = result.Contact.KPI_FRM_Certified__c;
            this.erpCertified = result.Contact.KPI_ERP_Certified__c;
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
        })

        getImageUrl().then(result => {
            //alert('result'+JSON.stringify(result));
            this.imageUrl = result;
        })
        .catch(error => {
            //alert('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
        })
    }

    get boolMakeBothCertVisible(){
        return this.frmCertified && this.erpCertified;
    }
}