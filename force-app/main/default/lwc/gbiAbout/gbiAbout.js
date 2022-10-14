import { LightningElement, track, wire } from 'lwc';
import getParticipantInformation from '@salesforce/apex/DashboardController.getParticipantInformation';

const columns = [
    { label: 'Firm Type', fieldName:'firmType',type:'text',sortable: true},
    { label: 'Name',fieldName: 'accountNameUrl',type: 'url',typeAttributes: {label: { fieldName: 'accountName' },target: '_blank'},sortable: true },
    { label: 'Country', fieldName:'region',type:'text',sortable: true},
    { label: 'Region', fieldName:'country',type:'text',sortable: true},
    { label: 'Studies', fieldName:'studies',type:'decimal',sortable: true},
];

export default class GbiAbout extends LightningElement {
    @track participantList = [];
    columns = columns;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    sortedBy;
    @track isNoParticiptant = false;

    @track error;
    @wire(getParticipantInformation)
    wiredAccounts({error,data}) {
        if (data) {
            this.participantList = data;
            console.log('this.participantList:'+this.participantList.length);
            if(this.participantList.length==0){
                this.isNoParticiptant = true;
            }
        } else if (error) {
            console.log('error:'+JSON.stringify(error));
            this.error = error;
        }
    }

    // Used to sort the 'Age' column
    sortBy(field, reverse, primer) {
        const key = primer
            ? function (x) {
                  return primer(x[field]);
              }
            : function (x) {
                  return x[field];
              };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    }

    onHandleSort(event) {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.participantList];

        cloneData.sort(this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1));
        this.participantList = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;
    }
}