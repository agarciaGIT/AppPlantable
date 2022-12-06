@isTest
private class ProductRefundsTriggerTest {
    
    Static List<Product_Refunds__c> ProductRefundsList = new List<Product_Refunds__c>();
    Static List<Opportunity> OppResults =new List<Opportunity>();
    Static List<Product2>  Product2List = new List<Product2>();
    Static ChargentSFA__Transaction__c payment =new ChargentSFA__Transaction__c();
    Static ProductRefundsTriggerHandler Prth = new ProductRefundsTriggerHandler();
    Static List<Exam_Attempt__c> examattemptresults = new List<Exam_Attempt__c>();
    Static List<Exam__c> examResults = new List<Exam__c>();
    Static List<Exam_Sites__c> examsite = new List<Exam_Sites__c>();
	Static Product_Refunds__c ProductRefunds = new Product_Refunds__c();
    Static List<MembershipRefundCodes__c> MembershipRefundList = new List<MembershipRefundCodes__c>();
    
    @TestSetup
    static void createTestData() {
        
        Integer totalCount = 2;
        Integer totalOppCount = 1;
        
        // insert product
        Product2 p1 = new Product2(Name = ' Test Product1',productCode = 'ENC1X',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '5',Weight__c=5,GL_Code__c='4030');
        Product2List.add(p1);
        Product2 p2 = new Product2(Name = ' Test Product2',productCode = 'ENC2X',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4030');
        Product2List.add(p2);
        Product2 p3 = new Product2(Name = ' Test Product3',productCode = 'SCRX',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4030');
        Product2List.add(p3);
        Product2 p4 = new Product2(Name = ' Test Product4',productCode = 'FRM1X',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4030');
        Product2List.add(p4);
        Product2 p5 = new Product2(Name = ' Test Product5',productCode = 'FRM2X',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4030');
        Product2List.add(p5);
        Product2 p6 = new Product2(Name = ' Test Product6',productCode = 'MISC',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4999');
        Product2List.add(p6);
        
        Product2 p7 = new Product2(Name = ' Test Product6',productCode = 'MEMC',isActive = true,Is_Shippable__c = true,
                                   Customs_Cost__c = '6',Weight__c=6,GL_Code__c='4999');
        Product2List.add(p7);
        insert Product2List;
        
        
        //Instantiate the Pricebook2 record with StandardPricebookId
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(),IsActive = true);
        Update standardPricebook;
        
        
        // insert pricebook entry for the product
        List<PricebookEntry> PricebookEntryList = new List<PricebookEntry>();
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[0].Id,UnitPrice = 250,IsActive = true);
        PricebookEntryList.add(standardPrice1);
        PricebookEntry standardPrice2 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[1].Id,UnitPrice = 250,IsActive = true);
        PricebookEntryList.add(standardPrice2);
        PricebookEntry standardPrice3 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[2].Id,UnitPrice = 250,IsActive = true);
        PricebookEntryList.add(standardPrice3);
        PricebookEntry standardPrice4 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[3].Id,UnitPrice = 250,IsActive = true);
        PricebookEntryList.add(standardPrice4);
        PricebookEntry standardPrice5 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[4].Id,UnitPrice = 250,IsActive = true);
        PricebookEntryList.add(standardPrice5);
        PricebookEntry standardPrice6 = new PricebookEntry(Pricebook2Id = standardPricebook.Id,Product2Id = Product2List[5].Id,UnitPrice = 250,IsActive = true);
        PricebookEntryList.add(standardPrice6);
        insert PricebookEntryList ;
        
        
        Exam_Registration_Modification__c erm = new Exam_Registration_Modification__c();
        insert erm;
        
        OppResults=TestDataFactory.createOpportunity(totalOppCount);
        for(Opportunity opp : OppResults){
            Opp.Pricebook2Id = standardPricebook.Id;
            Opp.stagename = 'New Lead';
            opp.Ups_Stage__c = 'Sent to GT';
            Opp.Frm1__c = True;
            Opp.Frm2__c = True;
            Opp.Erp1__c = True;
            Opp.Erp2__c = True;
            opp.Exam_Registration_Modification__c = erm.Id;
            opp.Auto_Renew__c = true;
            opp.ChargentSFA__Payment_Status__c='Recurring';
            opp.ChargentSFA__Payment_Frequency__c='Once';
        }
        insert OppResults;
        
        List<Contact> ContactResults=TestDataFactory.createContacts(totalCount);
        insert ContactResults;
        
        List<Contract> ContractResults=TestDataFactory.createContract(totalCount,OppResults,ContactResults);
        ContractResults[0].recordtypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','Membership');
        ContractResults[1].recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Risk.Net');
        insert ContractResults;
        ContractResults[0].Status = 'Completed';
        ContractResults[1].Status = 'Activated';
        update ContractResults;
        
        List<Contract> ContractResults1=TestDataFactory.createContract(totalCount,OppResults,ContactResults);
        ContractResults1[0].RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        ContractResults1[1].RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','SCR Program');     
        insert ContractResults1;
        ContractResults1[0].Status = 'Activated ( Auto-Renew )';
        ContractResults1[1].Status = 'Activated';
        update ContractResults1;
        
        Contact con = new Contact();
        con.Id= ContractResults[0].CustomerSignedId;
        con.AccountId = OppResults[0].AccountId;
        update con;
        
        Contact con1 = new Contact();
        con1.Id= ContractResults[1].CustomerSignedId;
        con1.AccountId = OppResults[0].AccountId;
        update con1;
        
        List<eBook_Key__c> EbookKey=TestDataFactory.createEbookKey(totalCount,OppResults);
        insert EbookKey;
        
        List<Event_Registration__c> EventReg=TestDataFactory.createEventRegistration(totalCount,OppResults);
        EventReg[0].Status__c  = 'Cancelled';
        insert EventReg;

        List<Exam_Group__c> ExamGroupResults = TestDataFactory.createExamGroup(totalCount);
        insert ExamGroupResults;
        Exam__c exam = new Exam__c();
        exam.Exam_Group__c = ExamGroupResults[0].id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1';
        exam.Name = 'FRM Part 1';
        insert exam;
        
        Exam__c exam1 = new Exam__c();
        exam1.Exam_Group__c = ExamGroupResults[1].id;
        exam1.Exam_Date__c = system.today() + 30;
        exam1.exam__c = 'FRM Part 2';
        exam1.Name = 'FRM Part 2';
        insert exam1;
        
        Exam__c exam2 = new Exam__c();
        exam2.Exam_Group__c = ExamGroupResults[1].id;
        exam2.Exam_Date__c = system.today() + 30;
        exam2.exam__c = 'SCR';
        exam2.Name = 'scr';
        insert exam2;
        
        
        examResults = new List<Exam__c>{exam,exam1,exam2};
            
        List<Exam_Part__c> ep = TestDataFactory.createExamPart(3,ExamResults);
        insert ep;
        examsite = TestDataFactory.createExamSite(3,ep,ExamResults);
        insert examsite;
        
        Exam_Attempt__c record = new Exam_Attempt__c();
        record.Exam_Site__c = examsite[0].id;
        record.Member__c = con.Id;//contact id
        record.cancelled__c = false;
        record.Exam_Administration__c = ep[0].Exam_Administration__c;
        record.Exam_Part__c = ep[0].id;
        record.Other_Exam_Registrations__c=NULL;
        record.Opportunity__c = OppResults[0].Id;
        insert record;
        
        Exam_Attempt__c record1 = new Exam_Attempt__c();
        record1.Exam_Site__c = examsite[1].id;
        record1.Member__c = con1.Id;//contact id
        record1.cancelled__c = false;
        record1.Exam_Administration__c = ep[1].Exam_Administration__c;
        record1.Exam_Part__c = ep[1].id;
        record1.Other_Exam_Registrations__c=NULL;
        record1.Opportunity__c = OppResults[0].Id;
        insert record1;
        
        Exam_Attempt__c record2 = new Exam_Attempt__c();
        record2.Exam_Site__c = examsite[2].id;
        record2.Member__c = con1.Id;//contact id
        record2.cancelled__c = false;
        record2.Exam_Administration__c = ep[2].Exam_Administration__c;
        record2.Exam_Part__c = ep[2].id;
        record2.Other_Exam_Registrations__c=NULL;
        record2.Opportunity__c = OppResults[0].Id;
        insert record2;
        
        Scholarship_Application__c sa = new Scholarship_Application__c(Applicant__c = ContractResults[0].CustomerSignedId,
                                                                       Exam_Type__c='FRM',Status__c='Submitted', Exam_Group__c= ExamGroupResults[0].Id);
        insert sa;
        Scholarship_Application__c sa1 = new Scholarship_Application__c(Applicant__c = ContractResults[1].CustomerSignedId,
                                                                        Exam_Type__c='ERP',Status__c='Submitted', Exam_Group__c= ExamGroupResults[1].Id);
        insert sa1;
        
        // Add product and Pricebook to the particular opportunity using OpportunityLineItem 
        List<OpportunityLineItem> OpportunityLineItemList = new List<OpportunityLineItem>();
        OpportunityLineItem oppLineItem1 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = PricebookEntryList[0].Id,UnitPrice = 7000,
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = record.Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem1);
        OpportunityLineItem oppLineItem2 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = PricebookEntryList[1].Id,UnitPrice = 250,
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = record.Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem2);
        OpportunityLineItem oppLineItem3 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = PricebookEntryList[2].Id,UnitPrice = 250,
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = record.Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem3);
        OpportunityLineItem oppLineItem4 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = PricebookEntryList[3].Id,UnitPrice = 250,
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = record1.Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem4);
        OpportunityLineItem oppLineItem5 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = PricebookEntryList[4].Id,UnitPrice = 250,
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = record1.Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem5);
        OpportunityLineItem oppLineItem6 = new OpportunityLineItem(OpportunityId = OppResults[0].Id,PricebookEntryId = PricebookEntryList[5].Id,UnitPrice = 250,
                                                                   Quantity = 5,Product_company__c='GRA Test',Exam_Registration__c = record1.Id,Scholarship_Application__c = sa.Id);
        OpportunityLineItemList.add(oppLineItem6);
        
        insert OpportunityLineItemList;
        
        
        for(Product2 p :Product2List)
        MembershipRefundList.add(new MembershipRefundCodes__c(Name='test'+p.productCode,Product_Code__c = p.productCode));
        insert(MembershipRefundList);
        
        payment = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c = OppResults[0].id,ChargentSFA__Type__c = 'Charge',
                                                  ChargentSFA__Response_Status__c= 'Approved');
        insert payment;
        
        
        Product_Refunds__c refund1 = new Product_Refunds__c (Status__c='Completed',Cancel_ERP_Enrollment__c = True,Cancel_ERP2__c = True,Cancel_ERP1__c = True,Cancel_E_book__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[0].id,Payment_Transaction__c = payment.id);
        
        ProductRefundsList.add(refund1);
        
        Product_Refunds__c refund2 = new Product_Refunds__c (Status__c='Completed',Cancel_ERP__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[1].id,Payment_Transaction__c = payment.id);
        
        ProductRefundsList.add(refund2);
        
        Product_Refunds__c refund3 = new Product_Refunds__c (Status__c='Completed',Charge_Back__c = True,Take_Membership__c = true,Cancel_Risk_Net__c = True,Refund_amount__c =123,Cancel_OTSA__c = True,Cancel_SCR__c = True,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[2].id,Payment_Transaction__c = payment.id);
        
        
        ProductRefundsList.add(refund3);
        Product_Refunds__c refund4 = new Product_Refunds__c (Status__c='Completed',Cancel_E_book__c = True,Cancel_FRM_Enrollment__c = True,Cancel_FRM1__c  = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[3].id,Payment_Transaction__c = payment.id);
        
        ProductRefundsList.add(refund4);
        Product_Refunds__c refund5 = new Product_Refunds__c (Status__c='Completed',Cancel_FRR__c = True,Cancel_FRM2__c = True,Take_Membership__c = true,Cancel_Practice_exam__c = True,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[4].id,Payment_Transaction__c = payment.id);
        
        ProductRefundsList.add(refund5);
        
        Product_Refunds__c refund6 = new Product_Refunds__c (Status__c='Completed', Cancel_Wiley__c =true,Wiley_Quantity__c =15.00,Re_stocking_fees__c = True,Cancel_Event__c = True,Cancel_FBRA__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[5].id,Payment_Transaction__c = payment.id);
        
        ProductRefundsList.add(refund6);
        
        Product_Refunds__c refund7 = new Product_Refunds__c (Status__c='Approved', Cancel_Wiley__c =true,Wiley_Quantity__c =15.00,Re_stocking_fees__c = True,Cancel_Event__c = True,Cancel_FBRA__c = True,Take_Membership__c = true,Refund_amount__c =123,
                                                             opportunity__c = OppResults[0].id,product__c = Product2List[6].id,Payment_Transaction__c = payment.id);
        
        ProductRefundsList.add(refund7);
        insert ProductRefundsList;
        
        ContractResults[1].recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        ContractResults[1].Status = 'Activated ( Auto-Renew )';
        ContractResults[0].recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
        ContractResults[0].Status = 'Activated ( Auto-Renew )';
        update ContractResults;
        
        ContractResults1[0].recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','OSTA Program');
        ContractResults1[0].Status = 'Activated ( Auto-Renew )';
        ContractResults1[1].recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FBRA Program');
        ContractResults1[1].Status = 'Activated ( Auto-Renew )';
        update ContractResults1;
        
        examResults[0].exam__c='ERP Exam Part I';
        examResults[1].exam__c='ERP Exam Part II';
        examResults[2].exam__c='ICBRR';
        update examResults;
        
		examattemptresults=[select id,Other_Exam_Registrations__c,Cancelled__c,Section__c,opportunity__C from Exam_Attempt__c];
		update examattemptresults;

    } 
    
    @isTest static void testProductRefundsV1(){
        test.startTest();
        
        ProductRefundsList = [Select Id,Status__c,Product_Code__c,Cancel_E_book__c ,Take_Membership__c ,Cancel_ERP_Enrollment__c,Cancel_FRM_Enrollment__c,
                              Cancel_FRM1__c,Cancel_FRM2__c ,Cancel_ERP__c ,Cancel_ERP1__c ,Cancel_ERP2__c ,Charge_Back__c ,Cancel_Wiley__c,
                              Cancel_Event__c,Cancel_FBRA__c ,Cancel_OTSA__c ,Cancel_SCR__c ,Cancel_FRR__c ,Cancel_Practice_exam__c,
                              Re_stocking_fees__c ,Cancel_Risk_Net__c,Wiley_Quantity__c,Opportunity__c,product__c,Payment_Transaction__c  from Product_Refunds__c];
        
        ProductRefunds = ProductRefundsList[0];
        Prth.afterUpdate(ProductRefunds,ProductRefundsList[0]);
        ProductRefundsList[0].Status__c='Approved';
        ProductRefundsList[0].Take_Membership__c = True;
        ProductRefundsList[0].Charge_Back__c = True;
        ProductRefundsList[5].Status__c='Submitted';
        update ProductRefundsList;     
        
        Prth.afterUpdate(ProductRefunds,ProductRefundsList[0]);
        Prth.afterInsert(ProductRefundsList[0]);
        Prth.afterInsert(ProductRefundsList[6]);
        
        test.stopTest();
    }
    
    @isTest static void testProductRefundsV2(){
        test.startTest();	

        ProductRefundsList = [Select Id,Status__c,Product_Code__c,Charge_Back__c,product__c  from Product_Refunds__c where Status__c='Approved' or Status__c='Submitted' LIMIT 1];
        ProductRefunds = ProductRefundsList[0];
        ProductRefundsList[0].Status__c='Completed';
        ProductRefundsList[0].Cancel_FBRA__c = True;
        ProductRefundsList[0].Cancel_Event__c = True;
        ProductRefundsList[0].Charge_Back__c = True;
        update ProductRefundsList;
        
        Prth.afterUpdate(ProductRefunds,ProductRefundsList[0]);
		Prth.beforeDelete(ProductRefundsList[0]);
        Prth.afterDelete(ProductRefundsList[0]);
        test.stopTest();
    }
    
}