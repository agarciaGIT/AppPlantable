import { LightningElement, api, track, wire } from 'lwc';
import getMemberProfileForEdit from '@salesforce/apex/GARP_MC_MemberProfile.getMemberProfileForEdit';
import setMemberProfile from '@salesforce/apex/GARP_MC_MemberProfile.setMemberProfile';
import { fireEvent } from 'c/pubsub';
import { util_isDefined, util_validateForm, util_mapSFFields, util_mapSFPickListToOptions, 
        util_createYearsOptions, util_closeModal, util_console, util_navigate, util_subscribeToMessages,
        util_dispatchMessage } from 'c/common';

export default class MemberProfileSurvey extends LightningElement {

    @api buttonText = 'Edit';
    @api contactId;
    @api surveyType='popup'; // Can be 'popup', 'registration' (inside reg page), or 'registrationinfo' (page 2)
    @api registrationType;
    @api profilePart;
    @api eventId;

    componentSelector = 'c-member-profile-survey';
    showProfileParts = {
        NameEmail: false,
        MailingAddress: false,
        BillingAddress: false,
        PhoneNumbers: false,
        AcademicInformation: false,
        EmploymentInformation: false,
        Survey: false,
        CompanyTitle: false
    }

    orgContact = "";

    profileData = {};
    contact = {};

    industryOptions = [];
    professionalLevelOptions = [];
    jobFunctionOptions = [];
    riskSpecialtyOptions = [];
    workingYearOptions = [];
    professionalDesignationOptions = [];
    professionalDesignationSelections = [];

    graduationYearOptions = [];
    graduationMonthOptions = [];

    howDidYouHearAboutUsOptions = [];
    degreeOptions = [];

    isSaving = false;
    isDataLoaded = false;
    hasSubmitted = false;

    isCompanySelected = false;
    isSchoolSelected = false;

    isJobFunctionRisk = false;

    isExam = false;

    get workingOptions() {
        return [
            { label: 'Working', value: 'Working' },
            { label: 'Not Working', value: 'Not Working' },
        ];
    }

    get isNotPopup(){
        return this.surveyType != "popup";
    }

    get isPopup(){
        return this.surveyType == "popup";
    }

    get isRegistration(){
        return this.surveyType == "registration";
    }

    get isNotRegistration(){
        return this.surveyType != "registration";
    }
    
    get isRegistrationInfo(){
        return this.surveyType == "registrationinfo";
    }    

    get isNotEventRegistration() {
        return this.registrationType != "event";
    }

    get isEventRegistration() {
        return this.surveyType == "registration" && this.registrationType == "event";
    }

    get isWebcastRegistration() {
        return this.surveyType == "registration" && this.registrationType == "webcast";
    }

    get showButtons() {
        return this.surveyType == "registrationinfo";
    }

    get isNotEventOrWebcastRegistration() {
        return this.surveyType == "registrationinfo";
    }

    get isDesignationOther() {
        return util_isDefined( this.professionalDesignationSelections.find(obj => { return obj == 'Other' })  )
    }

    get registrationTypeClass() {
        if(this.registrationType == 'scr' || this.registrationType == 'frm') {
            return "garp-card " + this.registrationType;
        } else {
            return "garp-card corp";
        }
        
    }

    @track pageRef = {name: 'GARP-USER-PORTAL', source: 'common'};

    initComponent () {
        util_console('contactId',this.contactId);
        util_console('profilePart',this.profilePart);
        util_console('surveyType',this.surveyType);
        util_console('eventId',this.eventId);

        if(util_isDefined(this.registrationType)) {
            this.registrationType = this.registrationType.toLowerCase();
            this.isExam = (this.registrationType == 'frm' || this.registrationType == 'scr' || this.registrationType == 'fbr' || this.registrationType == 'icbrr');
        }
        util_console('registrationType',this.registrationType);         
        util_console('isExam',this.isExam); 

        this.showProfileParts[this.profilePart] = true;

        util_subscribeToMessages(this,'event-reg-submit',this.handleMessage);

        debugger;

        getMemberProfileForEdit({contactId: this.contactId})
        .then(result =>{
            this.profileData = result;

            util_console('profileData',result);

            if(!util_isDefined(this.contactId) && util_isDefined(this,"profileData.contact.Id")) {
                this.contactId = this.profileData.contact.Id;
            }

            if(!util_isDefined(this,"profileData.contact")) {
                this.profileData.contact = {};
            }
            this.contact = this.profileData.contact;
            
            this.orgContact = JSON.stringify(this.profileData.contact);

            // Format picklists
            this.industryOptions = util_mapSFPickListToOptions(this.profileData.industries);
            this.professionalLevelOptions = util_mapSFPickListToOptions(this.profileData.professionalLevels);
            this.jobFunctionOptions = util_mapSFPickListToOptions(this.profileData.jobFunctions);
            this.riskSpecialtyOptions = util_mapSFPickListToOptions(this.profileData.riskSpecialties);
            this.workingYearOptions = util_createYearsOptions(1990, 0);

            this.professionalDesignationOptions = this.createProfessionalDesignationOptions(this.profileData);
            this.professionalDesignationSelections = this.updateProfessionalDesignationsArray(this.profileData);

            this.graduationMonthOptions = util_mapSFPickListToOptions(this.profileData.graduationMonths);

            this.howDidYouHearAboutUsOptions = util_mapSFPickListToOptions(this.profileData.howDidYouHearOptions);
            this.degreeOptions = util_mapSFPickListToOptions(this.profileData.degrees);

            this.graduationYearOptions = util_createYearsOptions(1970, 10);

            this.isJobFunctionRisk = (util_isDefined(this,"profileData.contact.Job_Function__c") && this.profileData.contact.Job_Function__c == 'Risk Management');

            if(util_isDefined(this,"profileData.contact.Company__c")) {
                this.isCompanySelected = true;
            }
            if(util_isDefined(this,"profileData.contact.School_Name__c")) {
                this.isSchoolSelected = true;
            }

            this.isDataLoaded = true;
            util_dispatchMessage(this, 'member-profile-survey-data-loaded-return', {isValid: null, registrationType: this.registrationType, surveyType: this.surveyType, contactData: this.profileData.contact});
        })
        .catch(error =>{
            util_console('error',error);
            this.errorMsg = error;
        })
    }

    handleMessage(message){

        if (util_isDefined(message,"data.channel") && message.data.channel == 'member-profile-survey-submit') {
            
            util_console('receivedMessage', message.data.channel);

            if(util_isDefined(message,"data.payload")) {

                util_console('payload', message.data.payload);

                if(message.data.payload.surveyType == this.surveyType) {
                    // validate form
                    var isValid = this.validateForm();

                    // send data back
                    util_dispatchMessage(this, 'member-profile-survey-submit-return', {isValid: isValid, registrationType: this.registrationType, surveyType: this.surveyType, contactData: this.profileData.contact});
                    this.hasSubmitted = true;
                }
            }
        } else if (util_isDefined(message,"data.channel") && message.data.channel == 'member-profile-survey-commit') {

            util_console('receivedMessage', message.data.channel);

            if(util_isDefined(message,"data.payload")) {
                util_console('payload', message.data.payload);

                if(message.data.payload.surveyType == this.surveyType) {
                    util_console('commitData', message.data.payload);
                    this.commitData(true);
                }
            }
            
        }
    }


    connectedCallback() {
        this.initComponent();
    }

    onSaveOrContinue() {
        if(this.surveyType == 'popup') {
            util_closeModal(this, 'profile-survey-modal-done', {});
        } else if(this.surveyType == 'registrationinfo') {
            if(this.registrationType == 'webcast') {
                util_navigate(this,'webcast/registration/completed',{webcastId: this.eventId})
            } else if(this.registrationType == 'event') {
                //util_navigate(this,'event/registration/completed',{eventId: this.eventId})

                // send data back
                util_dispatchMessage(this, 'member-profile-survey-commit-return', {isValid: true, registrationType: this.registrationType, surveyType: this.surveyType, contactData: this.profileData.contact});

            } else if(this.registrationType == 'chaptermeeting') {

                util_navigate(this,'chaptermeeting/registration/completed',{chaptermeetingId: this.eventId})

            } else if(this.isExam) {
                util_navigate(this,'exam/registration/completed',{EXAM_TYPE: this.registrationType})
            } else {
                util_navigate(this,'exam/registration/completed',{EXAM_TYPE: this.registrationType})
            }         
        }
    }

    validateForm() {
        var isValid = util_validateForm(this.template);
        util_console('is form valid',isValid);

        fireEvent(this.pageRef, 'validateCompanyNotification', {});
        if(isValid) {

            util_console('Company Required?',this.showProfileParts);

            // Is Company Required
            if(this.showProfileParts.EmploymentInformation || this.showProfileParts.Survey || this.showProfileParts.CompanyTitle) {

                util_console('Company Required',this.profileData.contact);

                util_console('Company Selected',this.isCompanySelected);

                // Clear data is never selected
                if(util_isDefined(this,"profileData.contact.Company__c") && !this.isCompanySelected) {
                    this.profileData.contact.Company__c = '';
                    util_console('Company Required Clear',this.profileData.contact.Company__c);
                }
                if(!util_isDefined(this,"profileData.contact.Company__c") || this.profileData.contact.Company__c == '') {
                    isValid = false;
                }

                
            }

            // Is School Required
            if(this.showProfileParts.EmploymentInformation || this.showProfileParts.Survey) {

                if(util_isDefined(this,"profileData.contact.School_Name__c") && !this.isSchoolSelected) {
                    this.profileData.contact.School_Name__c = '';
                }
                
                if(!util_isDefined(this,"profileData.contact.School_Name__c") || this.profileData.contact.School_Name__c == '') {
                    isValid = false;
                }
            }
        }
        return isValid;
    }

    handleContinueClick(event) {
        this.commitData(true);
    }

    handleUpdateClick(event){
        this.hasSubmitted = true;
        var isValid = this.validateForm();
        this.commitData(isValid);
        
    }

    commitData(navitgate) {        
        this.isSaving = true;

        // Clear Other Designations
        if(!util_isDefined( this.professionalDesignationSelections.find(obj => { return obj == 'Other' })  )) {
            this.profileData.contact.Other_Qualifications__c = '';
        }

        // Clear Other Risk Specialty
        if(!util_isDefined(this,"contact.Job_Function__c") || this.contact.Job_Function__c != 'Risk Management') {
            this.profileData.contact.Risk_Specialty__c = '';
        }

        // Clean Custom Fields
        var updateObj = util_mapSFFields(this.profileData.contact);
        updateObj.profileParts = this.showProfileParts;
        updateObj.ContactId = this.contactId;
        
        // Save Updates
        setMemberProfile({profileUpdate: updateObj})
        .then(result =>{
            this.readOnly = true;
            this.isSaving = false;
            if(navitgate) {
                this.onSaveOrContinue();
            }
        })
        .catch(error =>{
            this.errorMsg = error;
            this.readOnly = true;
            this.isSaving = false;
        })

    }

    handleFormInputChange(event){
            if(event.target.dataset.id == 'ProfessionalDesignations') {
                this.profileData.contact = this.convertProfessionalDesignationOptionsToContact(this.profileData, event.target.value);
                this.professionalDesignationSelections = this.updateProfessionalDesignationsArray(this.profileData);
            } else {
                this.profileData.contact[event.target.dataset.id] = event.target.value;    

                util_console('contact',this.profileData.contact);

                this.isJobFunctionRisk = (util_isDefined(this,"profileData.contact.Job_Function__c") && this.profileData.contact.Job_Function__c == 'Risk Management');

                util_console('isJobFunctionRisk',this.isJobFunctionRisk);
            }
            util_console('hasSubmitted',this.hasSubmitted);

            if(this.hasSubmitted) {
                this.validateForm(this.template);
            }
    }

    selectInstitution (event) {
        util_console(event.target.dataset.id,event.detail.selectName);
        if(event.target.dataset.id == 'Company__c') {
            this.profileData.contact.Company__c = event.detail.selectName;
            if(event.detail.selectName != '') {
                this.isCompanySelected = true;
            } else {
                this.isCompanySelected = false;
            }       
            console.log('isCompanySelected',this.isCompanySelected);
        } else {
            this.profileData.contact.School_Name__c = event.detail.selectName;
            if(event.detail.selectName != '') {
                this.isSchoolSelected = true;
            } else {
                this.isSchoolSelected = false;
            }            
        }
        if(this.hasSubmitted) {
            this.validateForm(this.template);
        }
    }

    searchInstitution (event) {
        console.log(event.detail.currentText);
        if(event.target.dataset.id == 'Company__c') {
            this.profileData.contact.Company__c = event.detail.currentText;
        } else {
            this.profileData.contact.School_Name__c = event.detail.currentText;
        }        
    }

    updateProfessionalDesignationsArray(profileData) {
        var designationArray = [];
        if(util_isDefined(profileData,"designations")) {

            profileData.designations.forEach(function (arrayItem) {
                if(profileData.contact[arrayItem] == true) {
                    var removeC = arrayItem.substring(0, arrayItem.lastIndexOf('__c'));
                    var val = removeC.substring(removeC.lastIndexOf('_')+1);
                    designationArray.push(val);    
                }
            });
        }
        return designationArray;
    }

    createProfessionalDesignationOptions(profileData) {
        var retArray = [];

        if(util_isDefined(profileData,"designations")) {

            profileData.designations.forEach(function (arrayItem) {
                var removeC = arrayItem.substring(0, arrayItem.lastIndexOf('__c'));
                var val = removeC.substring(removeC.lastIndexOf('_')+1);
                retArray.push({
                    label: val,
                    value: val
                });
            });
        }
        return retArray;
    }


    convertProfessionalDesignationOptionsToContact(profileData, values) {
        
        if(util_isDefined(profileData,"contact")) {

            profileData.designations.forEach(function (arrayItem) {
                var removeC = arrayItem.substring(0, arrayItem.lastIndexOf('__c'));
                var val = removeC.substring(removeC.lastIndexOf('_')+1);
                profileData.contact['Professional_Designation_'+val+'__c']=false;
            });

            values.forEach(function (arrayItem) {
                profileData.contact['Professional_Designation_'+arrayItem+'__c']=true;
            });

            return profileData.contact;
                
        }

        return null;

        
    }

    showCompanyOptions(profileData, value) {
        var retArray = [];
        profileData.institutions.forEach(function (arrayItem) {
            if(arrayItem.indexOf(value) > -1) {
                retArray.push({
                    label: arrayItem,
                    value: arrayItem
                });
            }

        });
        return retArray;
    }
    
}