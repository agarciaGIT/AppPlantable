import { LightningElement } from 'lwc';

export default class MemberProfileCompanySelect extends LightningElement {

    selectedInstitutionId;
    selectedInstitutionName;


    connectedCallback() {
        this.addEventListener("sampleresponse", (e) => {
            console.log('Message Sent: ' + e.detail);
        });
    }  

    selectInstitution (event) {
        console.log(event.detail.selectName);
        this.dispatchEvent(
            new CustomEvent("samplemessage", {
              detail: event.detail.selectName
            })
          );
    }

    searchInstitution (event) {
        console.log(event.detail.currentText);
        this.dispatchEvent(
            new CustomEvent("samplemessage", {
              detail: event.detail.currentText
            })
          );
    }

}