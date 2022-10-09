@isTest
public class MemberManagementScreenTestClass {
    static Account account;
    static Contact contact;
    static Opportunity opportunity;
    static Site__c site;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c examSite;
    static Contract contract;

    Public static void testData(){
        account = new Account(Name = 'test',BillingStreet = 'xxx',BillingCountry='USA',
                              BillingState='xxx',BillingPostalCode='00123',BillingCity='Newport');
        insert account;
        
        RecordType rt = [SELECT Id,name FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Member'];
       // RecordType rt = [SELECT Id,name FROM RecordType WHERE sObjectType = 'Contact' AND Name = 'Member'];
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',RecordTypeId = rt.Id);  
        insert contact; 
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,
                                      company__c = 'Payment', accountId = account.id,stageName = 'closed',
                                      Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        ChargentSFA__Transaction__c tran1 = new ChargentSFA__Transaction__c();
        tran1.ChargentSFA__Opportunity__c =opportunity.id;
        tran1.ChargentSFA__Response__c ='0';
        tran1.ChargentSFA__Response_Status__c ='Approved';
        tran1.ChargentSFA__Response_Message__c='Approved';
        tran1.ChargentSFA__Type__c  ='charge';
        insert tran1;
        
        site = new Site__c(Site_Code__c = '123',name = 'test',Display_Address__c = 'test',active__c = true,
                           Non_selectable__c = false, Is_OSTA_Information_Required__c= true,Exam_Date__c = system.today());
        insert site; 
        
        Exam_Group__c objExamGrp1 = new Exam_Group__c();
        objExamGrp1.Name = 'test';
        objExamGrp1.Active__c = true; 
        objExamGrp1.Last_Date_For_Late_Registration__c = system.today() - 500 ;    
        insert objExamGrp1;
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Name = 'test';
        objExamGrp.Active__c = false; 
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() - 500 ;    
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        examSite = new Exam_Sites__c(Name = 'test',Site__c = site.id,exam__c = exam.id,Exam_Date__c = system.today() + 30);
        insert examSite;
        
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4020',Family = 'Hardware');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4020',Family = 'Hardware' );
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'CHLF',GL_Code__c = '2008',Family = 'Hardware',IsActive = true);
        insert prod2;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod2.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice2;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        PricebookEntry customPrice2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice2;
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice2.id,Unitprice = 12000,Quantity = 1 );
        insert lineItem;
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice.id,Unitprice = 12000,Quantity = 1);
        insert lineItem1;
    }
    
    Public testMethod static void getnavigateToURL() {
        test.startTest();
        MemberManagementScreenClass.getnavigateToURL('Ups Edit', '');
        testData();
        Exam_Attempt__c attempt = new Exam_Attempt__c(Defered__c ='Approved',Result__c = 'Pass',
                                                      Opportunity__c = opportunity.id, Exam_Site__c = examSite.id,
                                                      Member__c = contact.id,cancelled__c = false );
        insert attempt;
        ChargentSFA__Transaction__c trans = [Select id from ChargentSFA__Transaction__c LIMIT 1];
        Opportunity opp =  [select id, ChargentSFA__Invoice_Number__c from Opportunity LIMIT 1];
        system.debug('ChargentSFA__Invoice_Number__c======>'+opp.ChargentSFA__Invoice_Number__c);
        MemberManagementScreenClass.getnavigateToURL('Ups Edit', opp.ChargentSFA__Invoice_Number__c);
        MemberManagementScreenClass.getnavigateToURL('Switch Exam', opp.ChargentSFA__Invoice_Number__c);
        MemberManagementScreenClass.getnavigateToURL('Create Switch Exam Fee', opp.ChargentSFA__Invoice_Number__c);
        MemberManagementScreenClass.getnavigateToURL('Scholarship refund', opp.ChargentSFA__Invoice_Number__c);
        MemberManagementScreenClass.getnavigateToURL('Update Opportunity Billing Info', opp.ChargentSFA__Invoice_Number__c);
        MemberManagementScreenClass.getnavigateToURL('Update Opportunity Price', opp.ChargentSFA__Invoice_Number__c);
        MemberManagementScreenClass.getnavigateToURL('xxxx', opp.ChargentSFA__Invoice_Number__c);
        test.stopTest();
    }
    
    public testMethod static void GARPIdValidation(){
        testData();
        test.startTest();
        Contact con = [Select id, GARP_Member_ID__c  from Contact];
        MemberManagementScreenClass.GARPIdValidation(con.GARP_Member_ID__c);
        MemberManagementScreenClass.GARPIdValidation(null);
        test.stopTest();
    }
    
    Public testMethod static void getExamTypeList() {
        testData();
        test.startTest();
        MemberManagementScreenClass.getExamTypeList();  
        test.stopTest();
    }
    
    Public testMethod static void getActiveSiteList() {
        testData();
        test.startTest();
        Exam_Group__c exmGrpId = [select id,Exam_Date__c from Exam_Group__c LIMIT 1]; 
        MemberManagementScreenClass.getActiveSiteList(exmGrpId.id,'test');  
        test.stopTest();
    }
    
    Public testMethod static void ExamRegistration() {
        testData();
        test.startTest();
        Exam_Group__c exmGrpId = [select id from Exam_Group__c LIMIT 1]; 
        Account acc = [Select id from Account LIMIT 1];
        Opportunity opportunity = [select id,AccountId from opportunity where AccountId =:acc.id];
        Contract contract1  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',
                                           recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,
                                           Opportunity__c = opportunity.id,accountId = opportunity.AccountId,
                                           Status = 'Draft');
        insert contract1;
        contract1.status = 'Activated';
        update contract1;
        MemberManagementScreenClass.ExamRegistration(contact.id,exmGrpId.id,'test');
        delete contract1;
        MemberManagementScreenClass.ExamRegistration(contact.id,exmGrpId.id,'test');
        test.stopTest();
    }
    
    Public testMethod static void CreateExamRegistrations() {
        testData();
        test.startTest();
        Site__c site = [select id from Site__c LIMIT 1];
        Exam_Group__c exmGrpId = [select id from Exam_Group__c LIMIT 1];
        Account acc = [select id from Account LIMIT 1];
        Contact con = [select id from Contact LIMIT 1];
        Contract contract1  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',
                                 recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','OSTA Program') ,
                                 Opportunity__c = opportunity.id,accountId = acc.Id,
                                 Status = 'Draft');
       	insert contract1;
        contract1.Status = 'Activated';
        update contract1;
        Exam_Attempt__c attempt = new Exam_Attempt__c(Defered__c ='Approved',Result__c = null,
                                                      Opportunity__c = opportunity.id, Exam_Site__c = examSite.id,
                                                      Member__c = con.id,cancelled__c = false,
                                                      Candidate_Commitment__c = contract1.Id);
        insert attempt;
        Site__c site1 = new Site__c(Site_Code__c = '123',name = 'test',Display_Address__c = 'test',
                                    active__c = true,Non_selectable__c = false, Is_OSTA_Information_Required__c= false,
                                    Exam_Date__c = system.today());
        insert site1; 
		 
       
        Map<String,List<String>> examRegistredMap = new Map<String,List<String>>();
        Map<String,List<String>> examRegistredMap1 = new Map<String,List<String>>();
        List<String> data = new List<String>();
        for(Exam_Attempt__c ex:[Select id,Section__c  from Exam_Attempt__c]){
            data.add(ex.Section__c);
        }
        examRegistredMap.put('Not Registred FRM Program',data);
        examRegistredMap1.put('Registred FRM Program',data);
        
        MemberManagementScreenClass.CreateExamRegistrations(con.id,exmGrpId.id, site.Id,'Early','FRM Part 1',examRegistredMap);
        MemberManagementScreenClass.CreateExamRegistrations(con.id,exmGrpId.id, site.Id,'Early','FRM Part 2',examRegistredMap1);
        MemberManagementScreenClass.CreateExamRegistrations(con.id,exmGrpId.id, site1.Id,'Early','FRM Part 2',examRegistredMap1);
        test.stopTest();
    }
    
    Public testMethod static void getFRMExams(){
        testData();
        test.startTest();
        Account acc = [select id from Account LIMIT 1];
        Contact con = [select id from Contact LIMIT 1];
        Contract contract1  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',
                                 recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,
                                 Opportunity__c = opportunity.id,accountId = acc.Id,
                                 Status = 'Draft');
       	insert contract1;
        contract1.Status = 'Completed';
        update contract1;
        Contract contract2  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',
                                 recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,
                                 Opportunity__c = opportunity.id,accountId = acc.Id,
                                 Status = 'Draft');
       	insert contract2;
        contract2.Status = 'Activated';
        update contract2;
        Exam_Attempt__c attempt1 = new Exam_Attempt__c(Defered__c ='Approved',Result__c = null,
                                                      Opportunity__c = opportunity.id, Exam_Site__c = examSite.id,
                                                      Member__c = con.id,cancelled__c = false,
                                                      Candidate_Commitment__c = contract2.Id);
        insert attempt1;
        Exam_Attempt__c attempt2 = new Exam_Attempt__c(Defered__c ='pending',Result__c = null,
                                                      Opportunity__c = opportunity.id, Exam_Site__c = examSite.id,
                                                      Member__c = con.id,cancelled__c = false,
                                                      Candidate_Commitment__c = contract1.Id);
        insert attempt2;
        MemberManagementScreenClass.getFRMExams(con.id, system.today());
        test.stopTest();
    }
    
    Public testMethod static void createproductList(){
        testData();
        test.startTest();
        Contact conn = [Select id from Contact];
        Account acc = [Select id from Account];
        Exam_Attempt__c attempt = new Exam_Attempt__c(Defered__c ='Approved',Result__c = 'Pass',
                                                      Opportunity__c = opportunity.id, Exam_Site__c = examSite.id,
                                                      Member__c = contact.id,cancelled__c = false );
        insert attempt;
		MemberManagementScreenClass.dataWrapper wrapper = new  MemberManagementScreenClass.dataWrapper();
        wrapper.enrollment = true;
        wrapper.OSTA = true;
        wrapper.ChinaLocation = true;
        wrapper.payType = 'Early';
        wrapper.examPartOne = 'FRM Part 1';
        wrapper.examPartTwo = 'FRM Part 2';
        wrapper.ExamMonth = 'May'; 
        wrapper.conid = conn.id ;
        wrapper.accid = acc.id ;
        MemberManagementScreenClass.createproductList(wrapper);
		wrapper.payType = 'Standard';     
        MemberManagementScreenClass.createproductList(wrapper);
        wrapper.ExamMonth = 'Nov';
        wrapper.payType = 'Late';  
        MemberManagementScreenClass.createproductList(wrapper);
        test.stopTest();
    }
}