@isTest
public class batchProductClassChinaFeeUpdateSage_Test {

    
    
    static Account acc ;
    static Opportunity opp; 
	static Contact contact = new Contact();
    static Exam__c frmPart1 = new Exam__c();
    static Exam__c frmPart2 = new Exam__c();
    
    static void testData(){ 
        
       
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'CHLF',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        Product2 prod2 = new Product2(Name = 'Laptop X200',productCode = 'CHNDF',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
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
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        insert new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX');
        
        Acc = new Account(Name = 'test');
        insert acc;
        
        contact.Email = 'TEST@TEST.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.AccountId = acc.Id;
        INSERT contact;
        
        Id manualRecId = RecordTypeHelper.GetRecordTypeId('Opportunity','Manual'); 
        opp = new Opportunity(amount = 123,Name = 'Test',RecordTypeID = manualRecId,Inst_Sale_Service_End_Date__c=system.today()+ 15,
                              Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = acc.id,stageName = 'Closed',
                              Program__c ='Print',Inst_Sale_Code__c = 'Promocode',Institutional_Sale__c = FALSE,ChargentSFA__Card_Type__c='AMEX',
                              ChargentSFA__Billing_Country__c = 'US',ChargentSFA__Billing_State__c='TX',
                              Institutional_Sale_Stage__c = 'Approved',closedate = system.today()+ 15);        
        insert opp;
        
        PricebookEntry customPrice2 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod2.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice2;
        
        
        List<Exam_Group__c> examGroupList = new List<Exam_Group__c>();
        
        Exam_Group__c examGroup = new Exam_Group__c();
        examGroup.Name = '21-SCR';
        examGroup.Exam_Date__c = Date.newInstance(2022, 11, 1).addDays(28);
        examGroup.Active__c = True;
        examGroupList.add(examGroup);
        
        
        Exam_Group__c examGroup1 = new Exam_Group__c();
        examGroup1.Name = '21-SCR';
        examGroup1.Exam_Date__c = Date.newInstance(2022, 11, 1);
        examGroup1.Active__c = false;
        examGroupList.add(examGroup1);
        
        insert examGroupList;
        
        
        frmPart1.Name = 'May 2018 FRM Exam Part I';
        frmPart1.Exam_Group__c = examGroupList[0].Id;
        frmPart1.Exam__c = 'FRM Part 1';
        frmPart1.Exam_Date__c = system.today().adddays(Integer.valueof((Math.random() * 365)));
        INSERT frmPart1; 
        
        
        frmPart2.Name = 'May 2018 FRM Exam Part II';
        frmPart2.Exam_Group__c = examGroupList[1].Id;
        frmPart2.Exam__c = 'FRM Part 2';
        frmPart2.Exam_Date__c = system.today().adddays(Integer.valueof((Math.random() * 365)));
        INSERT frmPart2;
        
        Site__c testSite = new Site__c();
        testSite.Active__c = true;
        testSite.Is_OSTA_Information_Required__c = true;
        INSERT testSite;
        
        List<Exam_Administration__c> examAdminList = new List<Exam_Administration__c>();
        for(Integer i=0; i<2; i++){
            Exam_Administration__c examAdmin = new Exam_Administration__c();
            examAdmin.Exam_Group__c = examGroupList[i].id;
            examAdminList.add(examAdmin);
        }
            insert examAdminList;
            
            
            Exam_Part__c exampart = new Exam_Part__c();
            exampart.Exam__c = frmPart1.Id;
            exampart.Exam_Administration__c = examAdminList[0].Id ;
            exampart.Delivery_Method__c = 'CBT';
            exampart.Exam_Start_Date__c = Date.newInstance(2022, 1, 10);
            exampart.Exam_Date__c = Date.newInstance(2022, 2, 10).adddays(Integer.valueof((Math.random() * 365)));
            exampart.Exam_End_Date__c = Date.newInstance(2022, 1, 10)+60;
            
            insert exampart;
            
            Exam_Part__c examPart2 = new Exam_Part__c();
            examPart2.Exam__c = frmPart2.id;
            examPart2.Exam_Administration__c = examAdminList[1].id;
            exampart.Exam_Start_Date__c = Date.newInstance(2022, 2, 10);
            exampart.Exam_Date__c = Date.newInstance(2022, 3, 10).adddays(Integer.valueof((Math.random() * 365)));
            exampart.Exam_End_Date__c = Date.newInstance(2022, 2, 10)+60;
            examPart2.Delivery_Method__c = 'CBT';
            
            insert examPart2;
            
            Exam_Sites__c examSitePart1 = new Exam_Sites__c();
            examSitePart1.Name = 'China';
            examSitePart1.Site__c = testSite.Id;
            examSitePart1.Exam__c = frmPart1.Id;
            examSitePart1.Exam_Part__c = exampart.Id;
            INSERT examSitePart1;
            
            Exam_Sites__c examSitePart2 = new Exam_Sites__c();
            examSitePart2.Name = 'China';
            examSitePart2.Site__c = testSite.Id;
            examSitePart2.Exam__c = frmPart2.Id;
            examSitePart2.Exam_Part__c = exampart2.Id;
            INSERT examSitePart2;
            
            
            Exam_Attempt__c examRegistration2 = new Exam_Attempt__c();
            examRegistration2.Member__c = contact.Id;
            examRegistration2.Exam_Part__c = exampart.Id;
            examRegistration2.Opportunity__c = opp.Id;
            examRegistration2.Exam_Site__c = examSitePart2.Id;
            examRegistration2.Defered__c = 'Pending';
            INSERT examRegistration2;
        
            Exam_Attempt__c examRegistration1 = new Exam_Attempt__c();
            examRegistration1.Member__c = contact.Id;
            examRegistration1.Opportunity__c = opp.Id;
            examRegistration1.Defered__c = 'Pending';
            examRegistration1.Cancelled__c=True;
            examRegistration1.Exam_Site__c=examSitePart1.id;
        	//examRegistration1.Cloned_From__c = examRegistration2.id;
        	//examRegistration1.Cloned_From__c = null;
            insert examRegistration1;
        
        
        OpportunityLineItem oppli = new OpportunityLineItem();
        oppli.Quantity=2;
        oppli.OpportunityId=opp.Id; 
        oppli.TotalPrice=10;
        oppli.PriceBookEntryId = customPrice.Id;
        oppli.ia_crm__Class__c = null;
        oppli.Exam_Registration__c = examRegistration1.id;
        insert oppli;
        
        OpportunityLineItem oppli3 = new OpportunityLineItem();
        oppli3.Quantity=2;
        oppli3.OpportunityId=opp.Id; 
        oppli3.TotalPrice=10;
        oppli3.PriceBookEntryId = customPrice.Id;
        oppli3.Batches_Updated__c = 'Class Batch';
        oppli3.ia_crm__Class__c = null;
        oppli3.Exam_Registration__c = examRegistration1.id;
        insert oppli3;
        
        OpportunityLineItem oppli33 = new OpportunityLineItem();
        oppli33.Quantity=2;
        oppli33.OpportunityId=opp.Id; 
        oppli33.TotalPrice=10;
        oppli33.PriceBookEntryId = customPrice2.Id;
        oppli33.ia_crm__Class__c = null;
        oppli33.Exam_Registration__c = examRegistration1.id;
        insert oppli33;
        
         ia_crm__Class__c cls = new ia_crm__Class__c(
            ia_crm__Class_ID__c = 'TEstclass',
            ia_crm__Status__c= True,
            Name = 'Test');
        insert cls; 
        
        Test.setCreatedDate(oppli.Id,datetime.now()-4); 
        Test.setCreatedDate(oppli3.Id,datetime.now()-4); 
        Test.setCreatedDate(oppli33.Id,datetime.now()-4); 

        }
        
        
        @isTest
        Static void unitTest1(){
            testData();
            Test.startTest();
            Database.executeBatch(new batchProductClassChinaFeeUpdateSage(),5);
            Test.stopTest();
        }
}