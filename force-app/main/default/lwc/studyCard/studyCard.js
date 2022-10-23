import { LightningElement } from 'lwc';

export default class StudyCard extends LightningElement {
  isInProgress = true;
  isCompleted = false;
  isAccessAllowed = false;

  checkStatus() {
    // TODO: Add data instead of PSEUDOCODE
    if(study.status == "In Progress") {
      this.isInProgress = true;
    } else if(study.status == "Completed") {
      this.isCompleted = true;
    }
    // TESTING
    user.access = true;
    this.isAccessAllowed = user.access;
    this.isInProgress = true;
  }
}