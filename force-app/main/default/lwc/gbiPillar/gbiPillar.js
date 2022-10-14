import { LightningElement, track } from 'lwc';

export default class GbiPillar extends LightningElement {
    @track isReports = false;
    @track isPillar = true;

    handleSection(event){
        var sectionName = event.currentTarget.dataset.id;
        console.log('sectionName:'+sectionName);
        if(sectionName == 'reports'){
            this.isReports = true;
            this.isPillar = false;
        }
        if(sectionName == 'pillar'){
            this.isReports = false;
            this.isPillar = true;
        }
    }
}