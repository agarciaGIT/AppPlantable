import { LightningElement, track, wire, api } from 'lwc';
import getListStudies from '@salesforce/apex/GBI_MC_Studies.getListStudies';
import getStudies from '@salesforce/apex/GBI_MC_Studies.getStudies';
import getUserContactData from '@salesforce/apex/GBI_MC_Studies.getUserContactData';

export default class StudiesListPanel extends LightningElement {
  @api allStudies;
  @api listStudies;

  connectedCallback() {
  getListStudies("My Studies").then(result => {
    this.listStudies = result;
    console.log("getListStudies() => ", this.listStudies);
  })
  .catch(error => {
    this.errorMessage = error.body.message;
    console.log("getListStudies() => ERROR: ", this.allErrorMsgs);
  }),
  getStudies().then(result => {
    this.allStudies = result;
    console.log("allStudies", this.allStudies);
  })
  .catch(error => {
    this.errorMessage = error.body.message;
    console.log(this.allErrorMsgs);
  }),
  getUserContactData().then(result => {
    this.userContactData = result;
    console.log("userContactData", this.userContactData);
  })
  .catch(error => {
    this.errorMessage = error.body.message;
    console.log(this.allErrorMsgs);
  })
}
}