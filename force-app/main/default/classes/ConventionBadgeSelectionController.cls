/* Class for Printing badge 
**/
public with sharing class ConventionBadgeSelectionController {
    public boolean PageBreak {get;set;}
    public integer Count {get;set;}
    public string ContributorType {get;set;}
    public String selectedCountry{get;set;}
    public String Certifications {get;set;}
    public String ContactIdBadge {get;set;}
    public String ContactIdError {get;set;}
    transient public List<List<BadgeInfo>> eventlists { get; set; }
    
    public Map<Id,Event_Registration__c> EventRegContacts {get;set;} 
    public List<Event_Registration__c> EventRegs {get;set;} 
    public List<Event_Registration__c> RegPerEventType {get;set;} 
    public List<Contact > RegisteredContact {get;set;}
    
    Public Set<Id> ContactId {get; set;}
    
    Public List<BadgeInfo> lstWrapperList {get; set;} {lstWrapperList = new List<BadgeInfo>();}
    Public List<BadgeInfo> lstWrapperList2 {get; set;} {lstWrapperList2 = new List<BadgeInfo>();}
    Public List<String> Events {get; set;}
    
    Public ConventionBadgeSelectionController(){
        PageBreak = false ;
        Count = 0;
        EventRegContacts = new Map<Id,Event_Registration__c>();
        EventRegs = new List<Event_Registration__c>();
        RegPerEventType = new List<Event_Registration__c>();
        RegisteredContact = new List<Contact>();
        ContactId = new set<Id>();
        Events = new List<String>();
        ContactIdError ='';
    }
    
    // Passing picklist values to Vfpage
    public List<SelectOption> getCountriesOptions() {
        List<SelectOption> countryOptions = new List<SelectOption>();
        countryOptions.add(new SelectOption('','-None-'));
        countryOptions.add(new SelectOption('NEW YORK','New York'));
        countryOptions.add(new SelectOption('LONDON','london'));
        return countryOptions;
    }
    
    // Method to print badges
    public Pagereference print(){
        try{
        eventlists = new list<List<BadgeInfo>>();
        if(ContactIdBadge == '' || ContactIdBadge == NULL){
            if(selectedCountry == 'NEW YORK'){
                String name = 'Convention,SREF,Master Class';
                Events = name.split(',');
            }
            if(selectedCountry == 'LONDON' ){
                String name = 'Convention Simulcast';
                Events = name.split(',');
            }
            
            // Query to get event details based on the picklist values selected
            if(!Test.isRunningTest()){
                
                EventRegs = [Select Id,Event__c,Event__r.Name,Contact__c,Contact__r.Company__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.name,Contact__r.Title,
                             Registration_Type__c,Member_FRM_Certified__c,Member_ERP_Certified__c,QR_Code__c,RPT_Event_Type__c 
                             from Event_Registration__c  
                             where RPT_Event_Type__c IN: Events and Status__c != 'Cancelled'
                             AND RPT_Event_Start_Date__c >= 2020-03-09
                             ORDER BY Contact__r.LastName ASC
                            ];
                  //  EventRegs.addAll(RegPerEventType); 
                
            } else {
                EventRegs = [Select Id,Event__c,Event__r.Name,Contact__c,Contact__r.Company__c,Contact__r.FirstName,Contact__r.LastName,Contact__r.name,Contact__r.Title,
                             Registration_Type__c,Member_FRM_Certified__c,Member_ERP_Certified__c, QR_Code__c,RPT_Event_Type__c
                             from Event_Registration__c
                             ORDER BY Contact__r.LastName ASC LIMIT 1
                            ];
            }
        } else {
            
            // Query to print a single badge based on the saleforce contact Id
            if(!Test.isRunningTest()){
                EventRegs = [Select Id,Event__c,Event__r.Name,Contact__r.FirstName,Contact__c,Contact__r.name,Contact__r.Title ,
                             Registration_Type__c,Member_FRM_Certified__c,Member_ERP_Certified__c,QR_Code__c,Contact__r.Company__c
                             from Event_Registration__c  
                             where Contact__c =:ContactIdBadge and Status__c != 'Cancelled'
                             AND RPT_Event_Start_Date__c >= 2020-03-09
                            ];
                if(EventRegs.size()>0){
                    ContactIdError = EventRegs[0].Contact__r.FirstName;
                } else{
                    ContactIdError = 'Please check RPT Event Start Date	and Registration Status	'; 
                }
            } else {
                EventRegs = [Select Id,Event__c,Event__r.Name,Contact__r.FirstName,Contact__c,Contact__r.name,Contact__r.Title,
                             Registration_Type__c,Member_FRM_Certified__c,Member_ERP_Certified__c, QR_Code__c,RPT_Event_Type__c
                             from Event_Registration__c 
                             LIMIT 1 ];
            }
        }
        
        for(Event_Registration__c m : EventRegs)
            EventRegContacts.put(m.Contact__c, m);
        
        for(Event_Registration__c EventReg:EventRegContacts.values()){
            Certifications = '';
            if(EventReg.Member_FRM_Certified__c){
                Certifications = 'FRM';
            }
            if(EventReg.Member_ERP_Certified__c && Certifications != NULL) {
                Certifications = Certifications + ' | ' + 'ERP';
            } 
            if (EventReg.Member_ERP_Certified__c && Certifications == NULL){
                Certifications = 'ERP';
            } 
            if(!EventReg.Member_ERP_Certified__c && !EventReg.Member_FRM_Certified__c) {
                Certifications = '';
            }
            Count ++;
            if( math.mod(Count,2)==0 && math.mod(Count,3) ==0 && math.mod(Count,6) ==0) {
                PageBreak = true;
            }
            if(Count<1000){
                lstWrapperList.add(new BadgeInfo(EventReg,Certifications,ContributorType,PageBreak,Count));
            } else {
                lstWrapperList2.add(new BadgeInfo(EventReg,Certifications,ContributorType,PageBreak,Count));
            }
            PageBreak = false;
        }
        } catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
         return null;
    } 
    
    // Wrapper class to get the details displayed on the badge
    public class BadgeInfo{
        public Event_Registration__c EventRegData {get;set;}
        public string fname {get; set;}
        public string name {get; set;}
        Public string QRCode {get;set;}
        public string RegistrationType {get;set;}
        public string title {get; set;}
        public string company {get; set;}
        public string designation {get; set;}
        public string Certifications {get; set;}
        public string ContributorType {get; set;}
        public Boolean PageBreak {get; set;}
        public integer Count {get;set;}
        public string EventType {get;set;}
        
        public BadgeInfo(){
            this.EventRegData = NULL ;
            this.fname = '';
            this.name = '';
            this.QRCode = '';
            this.RegistrationType = '';
            this.title = '';
            this.company = '';
            this.Certifications = '';
            this.ContributorType = '';
            this.EventType = '';
        }
        
        public BadgeInfo(Event_Registration__c data, string Certifications, string ContributorType, boolean PageBreak,integer Count){
            this.EventRegData = data;
            this.fname = data.Contact__r.FirstName;
            this.name = data.Contact__r.name;
            this.QRCode = data.QR_Code__c;
            this.RegistrationType = data.Registration_Type__c;
            this.title = data.Contact__r.Title;
            this.company = data.Contact__r.Company__c;
            this.Certifications = Certifications;
            this.ContributorType = ContributorType;
            this.PageBreak = PageBreak ;
            this.Count = Count;
            this.EventType = data.RPT_Event_Type__c;
        }
    }
    
    // Method to navigate to PDF VFpage to dowload badges
    Public Pagereference PrintBadgeMethod(){
        PageReference pageRef = new PageReference('/apex/ConventionBadgesPDF');
        return pageRef;
    }
    
}