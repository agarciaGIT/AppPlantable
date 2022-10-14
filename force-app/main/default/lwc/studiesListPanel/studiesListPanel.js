import { LightningElement, track, wire, api } from 'lwc';
import getStudies from '@salesforce/apex/GBI_MC_Studies.getStudies';
import getUserContactData from '@salesforce/apex/GBI_MC_Studies.getUserContactData';

export default class StudiesListPanel extends LightningElement {
  @api allStudies;
  
  connectedCallback() {
    getStudies().then(result => {
      this.allStudies = result;
      console.log("allStudies", this.allStudies);
    })
      .catch(error => {
        this.errorMessage = error.body.message;
        console.log(this.allSerrorMessagetudies);
      })

    getUserContactData().then(result => {
      this.userContactData = result;
      console.log("userContactData", this.userContactData);
    })
      .catch(error => {
        this.errorMessage = error.body.message;
        console.log(this.allSerrorMessagetudies);
      })
  }
}