@isTest

public class CreateFreeOppEbookFRM2_test{


    static Account account ;
    static Opportunity opportunity; 
    static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Exam_Attempt__c attempt;
    
    static Exam_Group__c objExamGrp;
    static Exam_Group__c objExamGrp1;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Contract mberContract1;
    
    static void testData(){ 
            
        
        Product2 prod = new Product2(Name = 'FRM2X',productCode = 'FRM2X',GL_Code__c = '4030',Family = 'Hardware');
        insert prod;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
       
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);

        insert new Exam_Date__c(name = 'test',date__c=Date.newInstance(2015, 5, 16),date_string__c='2015-05-16');
        
        account = new Account(Name = 'test');
        insert account;
         
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'Closed',Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = standardPrice.id);
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice.id);
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        insert contract;
        contract.Status = 'Activated';
        update contract;
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert frmContract;
        frmContract.Status = 'Activated';
        update frmContract;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        insert mberContract;
        mberContract.Status = 'Activated';
        update mberContract;
        
       
        
        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false,No_of_Members_Enrolled_for_ERP__c = '12',No_of_Members_Enrolled_for_FRM1_2__c = '12',No_of_Members_Enrolled_for_FRM1_Only__c = '12',No_of_Members_Enrolled_for_FRM_2_Only__c= '12');
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ; 
           
        insert objExamGrp;
        
        objExamGrp1 = new Exam_Group__c();
        objExamGrp1.Active__c = false; 
        Date dt2 = system.today();
        objExamGrp1.Registration_Start_Date__c = dt2.addDays(4);
        objExamGrp1.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp1.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp1.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp1;
        update objExamGrp1;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c =Date.newInstance(2015, 5, 16);
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite; 
        
        attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Candidate_ID__c=11, Exam_Site__c = exmSite.id,Member__c = contact.id,Cancelled__c= false,Candidate_Commitment__c= frmContract.id,Other_Exam_Registrations__c = NULL, Defered__c='Approved');
        insert attempt;

        
        insert new ExamSiteids__c(Name = site.id);
        
        Venue__c venue = new Venue__c(Site__c = site.id );
        insert venue;
        
        Room__c room = new Room__c(Venue__c  = venue.id,Active__c = true,Capacity__c =12,Priority__c = 2);
        insert room;

    }


    static testMethod void unitTest_1(){
        testData();
        test.starttest();
        CreateFreeOppEbookFRM2 batch = new CreateFreeOppEbookFRM2();
        database.executebatch(batch,1);
        test.stopTest();
        
    
    }
}