import { LightningElement, api } from 'lwc';
import getListStudies from '@salesforce/apex/GBI_MC_Studies.getListStudies';

export default class StudiesListByTypeTitle extends LightningElement {
  @api typeTitle;
  @api typeSubtitle;
  @api type;
  @api studies;
  @api listStudies;

  // connectedCallback() {
  //   getListStudies().then(result => {
  //     this.listStudies = result;
  //     console.log("getListStudies() => ", this.listStudies);
  //   })
  //     .catch(error => {
  //       this.errorMessage = error.body.message;
  //       console.log("getListStudies() => ERROR: ", this.allSerrorMessagetudies);
  //     })
  // }
}