import { LightningElement, track } from 'lwc';
import emptyImage from '@salesforce/resourceUrl/graApp';
import getUserContactData from '@salesforce/apex/DashboardController.getUserContactData';
import updateContactInfo from '@salesforce/apex/DashboardController.updateContactInfo';
import setUserPhoto from '@salesforce/apex/DashboardController.setUserPhoto';
import uploadAttachment from '@salesforce/apex/DashboardController.uploadAttachment';
import removeUserPhoto from '@salesforce/apex/DashboardController.removeUserPhoto';
import getImageFromAttachment from '@salesforce/apex/DashboardController.getImageFromAttachment';
import getAllActiveStudies from '@salesforce/apex/DashboardController.getAllActiveStudies';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GbiProfile extends LightningElement {
    @track imageUrl;
    @track photoSectionVisible = false;
    @track detailSectionVisible = false;
    @track editSectionVisible = false;
    @track contactName;
    @track firstName='';
    @track lastName='';
    @track phone='';
    @track title = '';
    @track email='';
    @track altPhone='';
    @track contactTitle;
    @track contactEmail;
    @track contactPhone;
    @track otherPhone;
    @track attachmentId=null;
    @track fileText;
    @track fileName;
    errorMessage;
    @track isLoading=false;
    @track studies = [];

    connectedCallback(){
        this.isLoading = true;
        getUserContactData().then(result => {
            this.contactName = result.FirstName+' '+result.LastName;
            this.firstName = result.FirstName;
            this.lastName = result.LastName;
            this.contactTitle = result.Title;
            this.title = result.Title;
            this.contactEmail = result.Email;
            this.email = result.Email;
            this.contactPhone = result.Phone;
            this.phone = result.Phone;
            this.otherPhone = result.OtherPhone;
            this.altPhone = result.OtherPhone;
        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
        })

        getImageFromAttachment().then(result => {
            if(result!=null){
                this.imageUrl =  result;
            }else{
                this.imageUrl = emptyImage+'/img/emptyhead.jpg';
            }
            this.isLoading = false;
        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.isLoading = false;
        })

        getAllActiveStudies().then(result => {
            this.studies = result;
            this.isLoading = false;
        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.isLoading = false;
        })
    }

    handleFormInputChange(event){
        if( event.target.name == 'firstName' ){
            this.firstName = event.target.value;
        }
        else if( event.target.name == 'lastName' ){
            this.lastName = event.target.value;
        }
        else if( event.target.name == 'title' ){
            this.title = event.target.value;
        }
        else if( event.target.name == 'phone' ){
            this.phone = event.target.value;
        }
        else if( event.target.name == 'secondaryphone' ){
            this.altPhone = event.target.value;
        }
        else if( event.target.name == 'email' ){
            this.email = event.target.value;
        }
    }

    uploadPhoto(){
        this.isLoading = true;
        uploadAttachment({attachmentId:this.attachmentId,fileText:this.fileText,fileName:this.fileName}).then(result => {
            this.attachmentId = result;
            var filename = this.fileName;
            let title = `${filename} uploaded successfully!!`
            this.toast(title);
        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.isLoading = false;
        })
    }

    onChangePhoto(event){
        const file = event.target.files[0];
        var reader = new FileReader();
        reader.onload = () => {
            var base64 = reader.result.split(',')[1];
            this.fileText = base64;
            this.fileName = file.name;
        }
        reader.readAsDataURL(file);
    }

    removePhoto(){
        this.isLoading = true;
        removeUserPhoto().then(result => {
            this.imageUrl = emptyImage+'/img/emptyhead.jpg';
            this.toast('Image has been removed.');
        })
        .catch(error => {
            this.errorMessage = error.body.message;
            this.isLoading = false;
        })
    }

    donePhoto(){
        this.isLoading = true;
        this.photoSectionVisible =  false;
        if(this.attachmentId!=null && this.attachmentId!=undefined){
            setUserPhoto({attachmentId:this.attachmentId}).then(result => {
                this.imageUrl = result;
                let title = `${filename} uploaded successfully in the system.!!`
                this.toast(title);
            })
            .catch(error => {
                console.log('error'+JSON.stringify(error));
                this.isLoading = false;
            })
        }else{
            this.isLoading = false;
        }
    }

    handlePhoto(){
        this.photoSectionVisible =  true;
        this.detailSectionVisible = true;
    }

    handleEditInfo(){
        this.editSectionVisible = true;
        this.photoSectionVisible = false;
    }

    handleSave(){
        this.editSectionVisible = false;
        this.isLoading = true;
        updateContactInfo({firstName:this.firstName,lastName:this.lastName,title:this.title,phone:this.phone,altphone:this.altPhone,email:this.email}).then(result => {
            if(result==''){
                this.contactName = this.firstName+' '+this.lastName;
                this.contactTitle = this.title;
                this.contactEmail = this.email;
                this.contactPhone = this.phone;
                this.otherPhone = this.altPhone;
                this.toast('Detail has been saved.');
            }else{
                this.toast(result);
            }
            this.isLoading = false;
        })
        .catch(error => {
            console.log('error'+JSON.stringify(error));
            this.errorMessage = error.body.message;
            this.isLoading = false;
        })
    }

    handleCancel(){
        this.editSectionVisible = false;
    }

    toast(title){
        this.isLoading = false;
        const toastEvent = new ShowToastEvent({
            title, 
            variant:"success"
        })
        this.dispatchEvent(toastEvent);
    }
}