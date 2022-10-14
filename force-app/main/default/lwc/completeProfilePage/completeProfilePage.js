import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CompleteProfilePage extends NavigationMixin(LightningElement) {
    workStatusValue = '';
    hearValue;
    yearValue;
    lastCompany;
    professionalValue;
    jobValue;
    designationValue;
    lastSchool;
    degreeValue;
    graduationValue;
    @track hearOptions=[];
    @track yearOptions=[];
    @track professionalOptions=[];
    @track jobOptions=[];
    @track degreeOptions=[];

    get workOptions() {
        return [
            { label: 'Working', value: 'Working' },
            { label: 'Not Working', value: 'Not Working' },
        ];
    }

    get designationOptions() {
        return [
            { label: 'ACCA', value: 'ACCA' },
            { label: 'CA', value: 'CA' },
        ];
    }

    connectedCallback(){
        for(var i=0;i<1;i++){
            this.hearOptions = [...this.hearOptions,{value:'FRM Certified/Candidate',label:'FRM Certified/Candidate'}];
        }

        for(var i=0;i<1;i++){
            this.professionalOptions = [...this.professionalOptions,{value:'Beginner',label:'Beginner'}];
        }      

        for(var i=0;i<1;i++){
            this.yearOptions = [...this.yearOptions,{value:'2007',label:'2007'}];
        }

        for(var i=0;i<1;i++){
            this.jobOptions = [...this.jobOptions,{value:'IT',label:'IT'}];
        }

        for(var i=0;i<1;i++){
            this.degreeOptions = [...this.degreeOptions,{value:'BTECH',label:'BTECH'}];
        }
    }

    handleHearChange(event) {
        this.hearValue = event.detail.value;
    }

    handleYearChange(event) {
        this.yearValue = event.detail.value;
    }

    handleProfessionalChange(event) {
        this.yearValue = event.detail.value;
    }

    handleJobChange(event) {
        this.jobValue = event.detail.value;
    }

    handleDegreeChange(event) {
        this.degreeValue = event.detail.value;
    }

    handleGraduationChange(event) {
        this.graduationValue = event.detail.value;
    }

    handleFormInputChange(event){
        if( event.target.name == 'lastCompany' ){
            this.lastCompany = event.target.value;
        }

        if( event.target.name == 'lastSchool' ){
            this.lastSchool = event.target.value;
        }
    }

    //Navigate to visualforce page
    navigateToConfirmationPage() {
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__webPage',
            attributes: {
                url: 'https://devapr22-mygarp.cs213.force.com/GARPV1/s/garp-confirmation-page'
            }
        }).then(vfURL => {
            alert('vfURL:'+vfURL);
            window.open(vfURL);
        }); 
    }
}