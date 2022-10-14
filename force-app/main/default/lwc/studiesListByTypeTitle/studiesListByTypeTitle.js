import { LightningElement, api } from 'lwc';
import getStudies from '@salesforce/apex/GBI_MC_Studies.getStudies';

export default class StudiesListByTypeTitle extends LightningElement {
  @api typeTitle;
  @api typeSubtitle;
  @api type;
  @api studies;
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
  }
}