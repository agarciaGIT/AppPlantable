import { LightningElement, api, track, wire } from 'lwc';
import getMemberProfileForEdit from '@salesforce/apex/GARP_MC_MemberProfile.getMemberProfileForEdit';
import setMemberProfile from '@salesforce/apex/GARP_MC_MemberProfile.setMemberProfile';
import setMemberEmail from '@salesforce/apex/GARP_MC_MemberProfile.setMemberEmail';
import { fireEvent } from 'c/pubsub';
import { util_isDefined, util_customValidationCheck, util_validateForm, 
        util_mapSFFields, util_mapSFRecordsToSelectOptions, util_convertStateCodeToName,
        util_mapSFPickListToOptions, util_createYearsOptions } from 'c/common';

export default class MemberProfileManagePropertiesCard extends LightningElement {

    @api profilePart = 'MailingAddress';
    @api buttonText = 'Edit';
    componentSelector = 'c-member-profile-card';

    orgContact = "";

    profileData = {};
    contact = {};
    countryOptions = [];
    provinceOptions = [];
    professionalDesignations;

    industryOptions = [];
    professionalLevelOptions = [];
    jobFunctionOptions = [];
    riskSpecialtyOptions = [];
    workingYearOptions = [];
    professionalDesignationOptions = [];
    professionalDesignationSelections = [];

    graduationYearOptions = [];
    graduationMonthOptions = [];
    degreeOptions = [];

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
    readOnly = true;
    isSaving = false;

    isJobFunctionRisk = false;

    get workingOptions() {
        return [
            { label: 'Working', value: 'Working' },
            { label: 'Not Working', value: 'Not Working' },
        ];
    }

    get isDesignationOther() {
        return util_isDefined( this.professionalDesignationSelections.find(obj => { return obj == 'Other' })  )
    }


    initComponent () {
        getMemberProfileForEdit({})
        .then(result =>{
            this.profileData = result;

            this.orgContact = JSON.stringify(this.profileData.contact);
            this.orgEmail =  this.profileData.contact.Email;
debugger;
            // Fix US States
            this.contact = util_convertStateCodeToName(this.profileData);
            this.countryOptions = util_mapSFRecordsToSelectOptions(this.profileData.countries, 'Country__c');

            this.industryOptions = util_mapSFPickListToOptions(this.profileData.industries);
            this.professionalLevelOptions = util_mapSFPickListToOptions(this.profileData.professionalLevels);
            this.jobFunctionOptions = util_mapSFPickListToOptions(this.profileData.jobFunctions);
            this.riskSpecialtyOptions = util_mapSFPickListToOptions(this.profileData.riskSpecialties);
            this.workingYearOptions = util_createYearsOptions(1990, 0);

            this.professionalDesignations = this.convertProfessionalDesignationsToString(this.profileData);
            this.professionalDesignationOptions = this.createProfessionalDesignationOptions(this.profileData);
            this.professionalDesignationSelections = this.updateProfessionalDesignationsArray(this.profileData);

            this.graduationMonthOptions = util_mapSFPickListToOptions(this.profileData.graduationMonths);
            this.graduationYearOptions = util_createYearsOptions(1970, 10);
            this.degreeOptions = util_mapSFPickListToOptions(this.profileData.degrees);

            this.isJobFunctionRisk = (util_isDefined(this,"profileData.contact.Job_Function__c") && this.profileData.contact.Job_Function__c == 'Risk Management');
        })
        .catch(error =>{
            this.errorMsg = error;
        })            
    }

    connectedCallback() {

        this.showProfileParts[this.profilePart] = true;
        this.initComponent();
    }

    validateForm() {
        var isValid = util_validateForm(this.template);
        fireEvent(this.pageRef, 'validateCompanyNotification', {});
        if(isValid) {
            if(this.showProfileParts.EmploymentInformation == true && (!util_isDefined(this,"profileData.contact.Company__c") || this.profileData.contact.Company__c == '')) {
                isValid = false;
            }
            if(this.showProfileParts.AcademicInformation == true && (!util_isDefined(this,"profileData.contact.School_Name__c") || this.profileData.contact.School_Name__c == '')) {
                isValid = false;
            }
        }
        return isValid;
    }

    handleUpdateClick(event){

        // Clear Other Designations
        if(!util_isDefined( this.professionalDesignationSelections.find(obj => { return obj == 'Other' })  )) {
            this.profileData.contact.Other_Qualifications__c = '';
        }        

        // Clear Other Risk Specialty
        if(!util_isDefined(this,"contact.Job_Function__c") || this.contact.Job_Function__c != 'Risk Management') {
            this.profileData.contact.Risk_Specialty__c = '';
        }

        var isValid = this.validateForm(this.template);
        if(isValid) {
            this.isSaving = true;

            // Clean Custom Fields
            var updateObj = util_mapSFFields(this.profileData.contact);
            updateObj.profileParts = this.showProfileParts;

            if(util_isDefined(this,"profileData.contact.Id")) {
                updateObj.ContactId = this.profileData.contact.Id;
            }
            if(util_isDefined(this,"profileData.contact.AccountId")) {
                updateObj.AccountId = this.profileData.contact.AccountId;
            }
            this.contact = this.profileData.contact;

            // Save Updates
            setMemberProfile({profileUpdate: updateObj})
            .then(result =>{
                
                if(updateObj.profileParts.NameEmail && this.orgEmail != updateObj.Email) {
                    // Save Updates
                    setMemberEmail({profileUpdate: updateObj})
                    .then(result =>{
                        this.readOnly = true;
                        this.isSaving = false;
                        this.initComponent();
                    })
                    .catch(error =>{
                        this.errorMsg = error;
                        this.readOnly = true;
                        this.isSaving = false;
                    })

                } else {
                    this.readOnly = true;
                    this.isSaving = false;
                    this.initComponent();
                }
            })
            .catch(error =>{
                this.errorMsg = error;
                this.readOnly = true;
                this.isSaving = false;
            })
        }
    }

    handleEditClick(event){
        this.readOnly = false;

        // Set Provence Select List
        var fndObj;
        if(this.showProfileParts.MailingAddress && util_isDefined(this,"contact.MailingCountry")) {
            fndObj = this.profileData.countries.find(x => x.Country__c === this.contact.MailingCountry);
        } else if(this.showProfileParts.BillingAddress && util_isDefined(this,"contact.Account.BillingCountry")) {
            fndObj = this.profileData.countries.find(x => x.Country__c === this.contact.Account.BillingCountry);
        }
        
        if(util_isDefined(fndObj,"Provinces__r")) {
            this.provinceOptions = util_mapSFRecordsToSelectOptions(fndObj.Provinces__r, 'Name');
        }
    }

    handleCancelClick(event){
        this.profileData.contact = JSON.parse(this.orgContact);
        this.readOnly = true;
    }

    handleFormInputChange(event){
        if(this.showProfileParts.BillingAddress) {
            this.profileData.contact.Account[event.target.dataset.id] = event.target.value;
        } else {

            if(event.target.dataset.id == 'ProfessionalDesignations') {
                this.profileData.contact = this.convertProfessionalDesignationOptionsToContact(this.profileData, event.target.value);
                this.professionalDesignationSelections = this.updateProfessionalDesignationsArray(this.profileData);
                this.professionalDesignations = this.convertProfessionalDesignationsToString(this.profileData);
            } else {
                this.profileData.contact[event.target.dataset.id] = event.target.value;    
            }
        }
    
        this.isJobFunctionRisk = (util_isDefined(this,"profileData.contact.Job_Function__c") && this.profileData.contact.Job_Function__c == 'Risk Management');

        // Set Provence Select List
        var fndObj = this.profileData.countries.find(x => x.Country__c === event.target.value);
        if(util_isDefined(fndObj,"Provinces__r")) {
            this.provinceOptions = util_mapSFRecordsToSelectOptions(fndObj.Provinces__r, 'Name');
        } else {
            this.provinceOptions = [];
        }

        this.validateForm(this.template);
    }

    selectInstitution (event) {
        console.log(event.detail.selectName);
        if(this.showProfileParts.EmploymentInformation) {
            this.profileData.contact.Company__c = event.detail.selectName;
        } else {
            this.profileData.contact.School_Name__c = event.detail.selectName;
        }
    }

    searchInstitution (event) {
        console.log(event.detail.currentText);
        if(this.showProfileParts.EmploymentInformation) {
            this.profileData.contact.Company__c = event.detail.currentText;
        } else {
            this.profileData.contact.School_Name__c = event.detail.currentText;
        }

        
    }

    convertProfessionalDesignationsToString(profileData) {
        var sProf = "";
        if(util_isDefined(profileData,"contact")) {
            for (var prop in profileData.contact) {
                if(prop.indexOf('Professional_Designation') > -1 && profileData.contact[prop] == true) {
                    var removeC = prop.substring(0, prop.lastIndexOf('__c'));
                    var val = removeC.substring(removeC.lastIndexOf('_')+1);
                    if(val != 'Other') {
                        if(sProf != "") {
                            sProf += ", ";
                        }    
                        sProf += val;
                    }
                }
            }

            if(util_isDefined(profileData.contact.Other_Qualifications__c)) {
                if(sProf != "") {
                    sProf += ", ";
                }
                sProf += profileData.contact.Other_Qualifications__c;
            }
        }
        return sProf;
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