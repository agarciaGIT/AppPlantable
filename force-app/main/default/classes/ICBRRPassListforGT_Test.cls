@isTest
public class ICBRRPassListforGT_Test {
    
    static Opportunity opp; 
    static Exam_Attempt__c examattempt;
    static Site__c testsite;
    static Exam_Sites__c examSite;
    static Exam__c exam;
    static Portal_Account__c GTAccount;
    static user user1;
  // public Daily_Orders__c dailyoder;
    static Date today =  system.today();
    static Datetime  startDayOfMonthDate = today.toStartOfMonth();
    static Datetime middleOfMonthDate=  Date.newInstance(today.year(), today.month(), 15);
    static string FRRCertificates = RecordTypeHelper.GetRecordTypeId('Daily_Orders__c','Certificates');

      
    static testMethod void Unit_test(){
        
           
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Customer Community'];
        
        Account a2 = new Account(name = 'Test Account2');
        insert a2;
        
        Contact c1 = new contact(do_not_fire__c = true, GARP_Member_ID__c = '12345', lastname = 'Test Contact1', MailingCountry ='Cuba', AccountID = a2.ID, email = 'testcontact1@contact.com', KPI_Member__c = True);
        insert c1;
        system.debug('###: ' + c1);
                
        User user1 = new user(TimeZoneSidKey = 'America/Denver',LocaleSidKey = 'en_US', ProfileId = p.Id, ContactId = c1.Id, Username = 'testcontact@garp.com', CommunityNickname = 'GARP SYSTEM',Alias = 'GSystem',CurrencyIsoCode = 'USD', EmailEncodingKey = 'ISO-8859-1',LanguageLocaleKey = 'en_US',LastName = 'System', Email = 'testcontact@garp.com');
        insert user1;
        System.debug(user1);
        
        Account acc = new Account(name = 'Test Account');
        insert acc;
        
        GTAccount = new Portal_Account__c(Name = 'Test', Primary_Contact__c = c1.Id, Type__c = 'GT'); 
        Insert GTAccount;
        system.debug('###: ' + GTAccount);
        
        c1 = [select GT_Account__c, id from contact where Id = :c1.id];
        
        system.debug('###: ' + c1);
        
        opp = new Opportunity(amount = 123,Name = 'Test', company__c = 'Payment', accountId = acc.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15, LEGACY_Purchase_Date__c  = system.today());        
        insert opp;
        
       Daily_Orders__c dailyoder = new Daily_Orders__c(Name = 'Test',Start_Date__c= date.valueof(startDayOfMonthDate),end_date__c=date.valueof(middleOfMonthDate),recordtypeid=FRRCertificates);
         insert dailyoder;
        
        exam = new Exam__c(Name='ICBRR', Exam__c='ICBRR');
        exam.Exam_Date__c = system.today() + 13;
        insert exam;
        
        testsite = new Site__c(Name='USA, MA, BOSTON',Site_Code__c ='1800-11', Display_Address__c  ='Westborough, Boston , MA, USA');
        insert testsite;
        
        examSite = new Exam_Sites__c(Name='May 2015 ERP Exam USA, MA, Boston', CurrencyIsoCode = 'USD', Site__c=testsite.id, Exam__c=exam.id);
        examSite.Exam__c = exam.id;
        insert examSite;
        
        examattempt = new Exam_Attempt__c(Name='John Doe', Member__c = c1.id, Result__c = 'Pass', Icbrr_Exam_Date__c = Date.newInstance(2020, 2, 19));
        examattempt.Exam_Site__c = examSite.id;
        insert examattempt;
        
        examattempt = [select Section__c, Icbrr_Exam_Date__c, ICBRR_Original_Cert_Sent_Date__c, Result__c  
                       from exam_Attempt__c where id = :examattempt.id];
        
        system.debug('$$$$: ' + examattempt);
        
        examattempt = [select id, Section__c, Icbrr_Exam_Date__c from Exam_Attempt__c where Member__C = :c1.id and id = :examattempt.Id];
        
        system.runAs(user1)
        
        {
            system.debug('running user: ' + user1); 
            test.starttest();
                    
           ICBRRPassListforGT datapoint = new ICBRRPassListforGT();
         ID batchprocessid  = Database.executeBatch(datapoint);      
            
            test.stopTest();
        } 
               
    }
}