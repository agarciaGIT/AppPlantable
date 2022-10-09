global class ICBRRPassListforGT implements Database.Batchable<sObject>,Database.Stateful{
    
    global Date today =  system.today(); 
    global Datetime  startDayOfMonthDate = today.toStartOfMonth();
    global Datetime middleOfMonthDate=  Date.newInstance(today.year(), today.month(), 15);
    global Integer numberOfDays = Date.daysInMonth(today.year(), today.month());
    global Date lastDayOfMonth = Date.newInstance(today.year(), today.month(), numberOfDays);
    global String startDayOfMonth=   string.valueof(date.valueof(startDayOfMonthDate));
    global string middleOfMonth=  string.valueof(date.valueof(middleOfMonthDate));
    global Daily_Orders__c  d ;
    global  List<wrapper> registrations;
    global static final String SHORT_TIME_FORMAT = 'MMMM d yyyy';
    global String stricbrrcsv = '';
    global string FRRCertificates = RecordTypeHelper.GetRecordTypeId('Daily_Orders__c','Certificates');

    global class wrapper{
        
        global string garpId {get; set;}
        global string certificateName {get; set;}
        global string examName {get; set;}
        global string fName{get; set;}
        global string lName{get; set;}
        global string memberCompany{get; set;}
        global string memberEmail {get;set;}
        global string companyName {get; set;}
        global string examGrade {get; set;} 
        global string memberPhone {get;set;}
        global string appointmentDate { get; set; }
        global integer slno {get;set;}
        global integer examScore {get;set;}
        global string mailingCity{get;set;} 
        global string mailingState{get;set;} 
        global string mailingPostalCode{get;set;} 
        global string mailingCountry{get;set;} 
        global string mailingStreet{get;set;}        
        
    }  
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        String query='Select id, Start_Date__c,end_date__c from Daily_Orders__c  ';
        
       
        
        system.debug('query == '+query);
        return Database.getQueryLocator(query);
    }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Daily_Orders__c> scope){
        
        List<Daily_Orders__c > orderlist= new  List<Daily_Orders__c >();
        Daily_Orders__c d = new Daily_Orders__c ();
        for(Daily_Orders__c obj : scope)   
        {
           
            orderlist.add(obj);
            if (orderlist.size()>0 && (string.valueof(obj.Start_Date__c) ==startDayOfMonth && string.valueof(obj.end_date__c) ==middleOfMonth)){
                
                d.name ='test2';
                d.Start_Date__c =date.valueof(middleOfMonthDate.adddays(1));
                d.end_date__c=lastDayOfMonth;
                d.recordtypeid =FRRCertificates;
                insert d;
            }
            else{
                
                d.name ='test1';
                d.Start_Date__c =date.valueof(startDayOfMonthDate);
                d.end_date__c=date.valueof(middleOfMonthDate);
                d.recordtypeid =FRRCertificates;
                insert d;
            }
            
            system.debug('%%%%%:'+d);
        }
        
         List<Exam_Attempt__c> lstExamAttempts = [
            SELECT id, Garp_Id__c, Result__c, Score__c, ICBRR_Original_Cert_Sent_Date__c, Member_Company__c, Member__r.MailingStreet, Member__r.MailingCity, Member__r.MailingState, Member__r.MailingPostalCode, Member__r.MailingCountry, ICBRR_Submission_Status__c, ICBRR_Authorization_Status__c, Member__r.Region__c, Member_Country__c, Member_Address__c, Member_Phone__c, Icbrr_Exam_Date__c, Section__c, Attending_Exam_Name__c, Member__c, Member_Email__c, Member__r.FirstName, Member__r.LastName
            FROM Exam_Attempt__c 
            WHERE Section__c = 'ICBRR' and Icbrr_Exam_Date__c != null and ICBRR_Original_Cert_Sent_Date__c= null and Result__c = 'Pass'
        ];
        
        
        if(lstExamAttempts.size() >0) 
        {
            
            system.debug('ICBRRList:' + lstExamAttempts);
            
            Integer totalCount  = 0;
            registrations = new List<wrapper>(); 
            
            for(Exam_Attempt__c e :lstExamAttempts){    
                
                wrapper w = new wrapper();
                
                w.slno = ++totalCount;
                w.garpId = e.Garp_Id__c;
                w.examName = e.Section__c;
                w.fName = e.Member__r.FirstName;
                w.lName = e.Member__r.LastName ;
                w.certificateName = e.Member__r.FirstName + ' ' + e.Member__r.LastName;
                w.memberCompany = e.Member_Company__c;
                w.memberPhone = e.Member_Phone__c;
                w.memberEmail = e.Member_Email__c;
                w.examGrade = e.Result__c;
                w.examScore = integer.ValueOf(e.Score__c);
                w.mailingCountry = e.Member_Country__c;
                w.appointmentDate = datetime.newInstance(e.Icbrr_Exam_Date__c.year(), e.Icbrr_Exam_Date__c.month(), e.Icbrr_Exam_Date__c.day()).format(SHORT_TIME_FORMAT );
                w.mailingStreet = e.Member__r.MailingStreet;
                w.MailingCity = e.Member__r.MailingCity;
                w.MailingState = e.Member__r.MailingState;
                w.MailingPostalCode = e.Member__r.MailingPostalCode;
                w.MailingCountry = e.Member__r.MailingCountry;
                
                registrations.add(w);
                
            }
            
        }
        
        if(registrations.size()>0){
    String strDateValue = String.valueOf(System.today().Month())+String.valueOf(System.today().Day())+String.valueOf(System.today().Year());
  List<Attachment> lstEmailAttachments = new List<Attachment>();
           stricbrrcsv += registrations;
           stricbrrcsv = stricbrrcsv.replace('null','');
           stricbrrcsv += '\r\n';
            Blob domesticBlob = Blob.valueof(stricbrrcsv);
            Attachment att = new Attachment();
            String strFieName = 'domestic'+'_'+strDateValue+'.csv';
            att.Name =strFieName;
            system.debug('domesticBlob == '+domesticBlob.toString());
            att.Body =domesticBlob;
            lstEmailAttachments.add(att); 
            
        
        if(lstEmailAttachments.size()>0){
        
     
         List<Attachment> listToInsert = new List<Attachment>() ;
      for(Attachment a: lstEmailAttachments)
        {
             system.debug('a.name == '+a.name);
            system.debug('a.body == '+a.body);
             system.debug('&&&&&&& == '+d);
            if(a.name != '' && a.name != '' && a.body != null)
                listToInsert.add(new Attachment(parentId = d.id, name = a.name, body = a.body)) ;
             system.debug('listToInsert =='+listToInsert);
        }


        if(listToInsert.size() > 0)
        {
           
            insert listToInsert ;
            
        } 
        }}
        
    }
    
    global void finish(Database.BatchableContext BC){
    
       
    }}