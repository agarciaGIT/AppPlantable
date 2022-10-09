public class EPPListDownload{
    
    private static final String SHORT_TIME_FORMAT = 'MMMM d yyyy';
    public List<wrapper> registrations { get; set; }
    public list<String> EPPRegion { get; set; }
    public string FRM {get; set;}
    public string ERP {get; set;}
    public string SCR {get; set;}
    public id PrimaryEPPContactId { get; set; }
    transient public List<List<wrapper>> finalRegistrations { get; set; }

    public class wrapper{
        
        public string garpId {get; set;}
        public string examName {get; set;}
        public string fName{get; set;}
        public string lName{get; set;}
        public string email{get; set;}
        public string memberEmail {get;set;}
        public string region{get;set;}        
        public date dateRegistered{get;set;}
        public string mailingStreet{get;set;} 
        public string phone{get;set;}
        public string memberCountry{get;set;}
        public string examDate    { get; set; }
        public integer slno {get;set;}
         public string MailingCity{get;set;} 
          public string MailingState{get;set;} 
           public string MailingPostalCode{get;set;} 
            public string MailingCountry{get;set;} 

        
    }  
    
    Public EPPListDownload(){
    
     String userId = UserInfo.getUserId();   
      
  // String userId =   '0050v000001wayJ';
                 
        User User = [Select u.Id,u.ContactId,Email from User u where u.Id = :userId Limit 1];
        
        if( User != null ) {
            
          Contact Contact = [SELECT Id, Name, Email, EPP_Data_Manager__c
                    FROM Contact WHERE EPP_Data_Manager__c = true and 
                    Id = :User.ContactId];
           if( Contact != null ) {            
                PrimaryEPPContactId =  Contact.Id;
            }
        }   
        
          system.debug('PrimaryEPPContactId:' + PrimaryEPPContactId);
        
            
        if(PrimaryEPPContactId != null){
            
           List<EPP_Account__c> lstEPPAccount = [
                SELECT Id, Name, Primary_EPP_Contact__c, EPP_ERP__c, EPP_FRM__c,EPP_SCR__c, EPP_Location__c, EPP_Region_s__c, EPP_Registration_Status__c, EPP_List_Last_Download_Date__c, Account__c FROM EPP_Account__c
                WHERE Primary_EPP_Contact__c = :PrimaryEPPContactId and EPP_Registration_Status__c = 'Approved' 
            ]; 
            
             
           for(EPP_Account__c eppAccount: lstEPPAccount) 
          {
            if(EPPAccount != null)
            
            EPPRegion = (EPPAccount.EPP_Region_s__c.split(';'));
            
            If (EPPAccount.EPP_ERP__c == true){
                ERP = 'ERP';
                
            }
            if (EPPAccount.EPP_FRM__c == true ){
                FRM = 'FRM';
         
            }
            if (EPPAccount.EPP_SCR__c == true ){
                SCR = 'SCR';
         
            }
          }  
        }
        
    }
    
    public void getExamAttempts(){
        
      List<Exam_Attempt__c> lstExamAttempts = [
            SELECT id, Garp_Id__c, RPT_Administration__c, Exam_Part__c, EPP_Outreach__c,Member__r.MailingStreet,Member__r.MailingCity,Member__r.MailingState,Member__r.MailingPostalCode,Member__r.MailingCountry, Reg_Status__c, Site_Code__c, Section_Exam_Name__c, Member__r.Region__c,RPT_Exam_FRM_ERP__c, Member_Country__c, Member_Address__c, Registered_On__c, Member_Phone__c, Exam_Date__c, Section__c, Attending_Exam_Name__c, Member__c, Member_Email__c, Member__r.FirstName, Member__r.LastName
            FROM Exam_Attempt__c 
            WHERE EPP_Outreach__c = true and (Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true OR Exam_Site__r.Exam__r.Exam_Group__r.SCR_Active__c = true) and Reg_Status__c!='Cancelled' and Cancelled__c != True and Member__r.Region__c in :EPPRegion and (RPT_Exam_Program__c =:FRM or RPT_Exam_Program__c =:ERP or RPT_Exam_Program__c =:SCR)
        ];
        
      
       
        if(lstExamAttempts.size() >0) 
       {
       try {
        
        
        system.debug('EPPExams:' + lstExamAttempts);
        
        Integer totalCount  = 0;
        registrations = new List<wrapper>(); 
        finalRegistrations =  new List<List<wrapper>> ();
       
        for(Exam_Attempt__c e :lstExamAttempts){    
            
            wrapper w = new wrapper();
            
           w.slno = ++totalCount;
            w.garpId = e.Garp_Id__c;
            w.examName = e.Section_Exam_Name__c;
            w.fName = e.Member__r.FirstName;
            w.lName = e.Member__r.LastName ;
            w.phone = e.Member_Phone__c;
            w.email = e.Member_Email__c;
            w.membercountry = e.Member_Country__c;
            w.region = e.Member__r.Region__c;
            if(e.Exam_Part__c != null){
                w.examDate = e.RPT_Administration__c;
            }else{
            	w.examDate = datetime.newInstance(e.exam_Date__C.year(), e.exam_Date__C.month(), e.exam_Date__C.day()).format(SHORT_TIME_FORMAT );
            }
            w.dateRegistered = e.Registered_On__c;
            w.mailingStreet =e.Member__r.MailingStreet;
            w.MailingCity =e.Member__r.MailingCity;
            w.MailingState =e.Member__r.MailingState;
            w.MailingPostalCode =e.Member__r.MailingPostalCode;
            w.MailingCountry =e.Member__r.MailingCountry;
            
            registrations.add(w);
            
               if(registrations.size() > 999){
                       finalRegistrations.add(registrations.clone());        
              registrations.clear();
           }
           
        }   
        
        
            
      if(registrations.size() > 0) finalRegistrations.add(registrations);
        system.debug('finalRegistrations:' + finalRegistrations.size());
        system.debug('totalCount:' + totalcount);
       
                
       }catch (exception ex){
        
        }
        
       }
    
       
        if(PrimaryEPPContactId != null){
     
         
            List<EPP_Account__c> lstEPPAccount = [
                SELECT Id, Name, Primary_EPP_Contact__c, EPP_ERP__c, EPP_FRM__c,EPP_SCR__c, EPP_Location__c, EPP_Region_s__c, EPP_Registration_Status__c, EPP_List_Last_Download_Date__c, Account__c FROM EPP_Account__c
                WHERE Primary_EPP_Contact__c = :PrimaryEPPContactId and EPP_Registration_Status__c = 'Approved' 
            ]; 
            
             for(EPP_Account__c eppAccount: lstEPPAccount) 
          {
            
                EPPAccount.EPP_List_Last_Download_Date__c = Date.today();
                UPDATE EPPAccount;
         } 
    }
   } 
}