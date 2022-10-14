@istest
public class opportunityTriggerUtils_test {

    static Contract contract;
    static Contract contract1;
    static Contract contract2;
    static Contract contract3;
    static Contract frmContract;
    static Contract mberContract;
    static Contract mberContract1;
    static Contract wileyontract;
    static Contract wileyontract1;
    static Contract cotractt;
    static Account account ; 
    static Account account1 ;
    static Opportunity opportunity; 
    static Opportunity opportunity1; 
    static Opportunity shipOpportunity;
    static Exam_Attempt__c attempt;
    static Exam_Group__c objExamGrp;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static Contact contact1;
    static ChargentBase__Gateway__c chrgGtway;
    static Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    static OpportunityLineItem lineItem;
    static OpportunityLineItem lineItem11;
    static eBook_Key__c ekey;
    static API_Transaction__c apiTrans;
    static ChargentSFA__Transaction__c chTrans;
    
    static void testData(){ 

        TestClassUtil.isForOldTrigger();
        Product2 prod = new Product2(Name = 'Laptop X200',productCode = 'FRM1',GL_Code__c = '4999',Family = 'Hardware');
        insert prod;
        
        Product2 prod1 = new Product2(Name = 'Laptop X200',productCode = 'ENC',GL_Code__c = '4999',Family = 'Hardware');
        insert prod1;
        
        Product2 shipProduct = new Product2(Name = 'SHIP',productCode = 'SHIP',GL_Code__c = '4999',Family = 'Hardware',Product_ID__c='1111',Weight__c=2);
        insert shipProduct;

        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 250, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 250, IsActive = true);
        insert standardPrice1;
        
        PricebookEntry shipPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = shipProduct.Id,UnitPrice = 10000, IsActive = true);
        insert shipPrice;
       
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id,UnitPrice = 250, IsActive = true);
        insert customPrice;
        
        PricebookEntry customPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 250, IsActive = true);
        insert customPrice1;
        
        PricebookEntry shipPrice1 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = shipProduct.Id, UnitPrice = 12000, IsActive = true);
        insert shipPrice1;
        
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
                
        account = new Account(Name = 'test');
        insert account;

        account1 = new Account(Name = 'test1');
        insert account1;

        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17), GARP_Member_ID__c = '2342342');
        insert contact;

        contact1 = new Contact(lastname = 'Test',AccountId = account1.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact1;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,
                                      company__c = 'Payment', ChargentSFA__Billing_Email__c = 'test@test.com',
                                      accountId = account.id,stageName = 'closed',Program__c = 'Print' ,
                                      closedate = system.today()+ 15,Pricebook2Id = customPB.Id, 
                                      ChargentSFA__Billing_First__c='test', ChargentSFA__Billing_Last__c = 'Name');        
        insert opportunity; 

        opportunity1 = new Opportunity(amount = 123,Name = 'Test1',Eligible_for_Membership_Extension__c = true,
                                       company__c = 'Payment', ChargentSFA__Billing_Email__c = 'test@test.com',
                                       accountId = account1.id,stageName = 'New Lead',Program__c = 'Print' ,
                                       closedate = system.today()+ 15,Pricebook2Id = customPB.Id);        
        insert opportunity1; 
        
        lineItem11 = new OpportunityLineItem(OpportunityId = opportunity1.id,PricebookEntryId = customPrice1.id,Quantity=1,UnitPrice=250);
        insert lineItem11;

        shipOpportunity = new Opportunity(amount = 123,Name = 'Test',Inst_Sale_Opp__c = opportunity.Id, Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'New Lead',Program__c = 'Print' ,closedate = system.today()+ 15,Pricebook2Id = customPB.Id,Shipping_Street__c='test/ntest1/ntest2',Shipping_Country__c='US');        
        insert shipOpportunity; 
        
        insert new CountryCodes__c(name='US',Country_Code__c='USA');

        lineItem = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice1.id,Quantity=1,UnitPrice=250);
        OpportunityLineItem lineItem1 = new OpportunityLineItem(OpportunityId = opportunity.id,PricebookEntryId = customPrice1.id,Quantity=1,UnitPrice=234);
        OpportunityLineItem shipLine = new OpportunityLineItem(OpportunityId = shipOpportunity.id,PricebookEntryId = shipPrice1.id,Quantity=1,UnitPrice=234);
        insert lineItem;
        insert lineItem1;
        insert shipLine;
        OpportunityLineItem shipLine1 = new OpportunityLineItem(OpportunityId = shipOpportunity.id,PricebookEntryId = shipPrice1.id,Quantity=1,UnitPrice=234);
        insert shipLine1;
        List<Contract> contractList = new List<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract);
        
        contract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract1);
        
        contract3  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract3);
        
        contract2  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Risk.Net') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract2);

        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(frmContract);
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(mberContract);
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(mberContract1);
        
        wileyontract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(wileyontract);

        wileyontract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(wileyontract1);
        
        cotractt  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(cotractt);
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con);
        
        insert contractList;
        contract.Status = 'Activated';
        contract1.Status = 'Draft';
        contract3.Status = 'Draft';
        contract2.Status = 'Draft';
        frmContract.Status = 'Activated';
        mberContract.Status = 'Activated';
        mberContract1.Status = 'Activated';
        wileyontract1.Status = 'Activated';
        con.Status = 'Activated';
        update contractList;

        site = new Site__c(name = 'test',Display_Address__c = 'test',active__c = true,Non_selectable__c = false, Site_code__c = 'SCR');
        insert site; 
        
        objExamGrp = new Exam_Group__c();
        objExamGrp.Active__c = true; 
        Date dt1 = system.today();
        objExamGrp.Registration_Start_Date__c = dt1.addDays(4);
        objExamGrp.Last_Date_For_Early_Registration__c = system.today()+1;
        objExamGrp.Last_Date_For_Standard_Registration__c = system.today() +9 ;
        objExamGrp.Last_Date_For_Late_Registration__c = system.today() +10 ;    
        insert objExamGrp;
        
        exam = new Exam__c();
        exam.Exam_Group__c = objExamGrp.id;
        exam.Exam_Date__c = system.today() + 30;
        exam.exam__c = 'FRM Part 1'; 
        insert exam;
        
        exmSite = new Exam_Sites__c(Site__c = site.id,exam__c = exam.id);
        insert exmSite; 
        
        attempt = new Exam_Attempt__c(Opportunity__c = opportunity.id, Exam_Site__c = exmSite.id,Member__c = contact.id,cancelled__c = false
                                        );
        insert attempt;
        
        ekey = new eBook_Key__c(Name='Test Key', Key__c='23424refef1', Type__c = 'ERP Exam Part I',Access_Duration_in_Months__c=36);
        insert ekey;
        eBook_Key__c ekey1 = new eBook_Key__c(Name='Test Key', Key__c='23424refef2', Type__c = 'ERP Exam Part II',Access_Duration_in_Months__c=36);
        insert ekey1;
        eBook_Key__c ekey2 = new eBook_Key__c(Name='Test Key', Key__c='23424refef3', Type__c = 'FRR',Access_Duration_in_Months__c=36);
        insert ekey2;
        eBook_Key__c ekey3 = new eBook_Key__c(Name='Test Key', Key__c='23424refef4', Type__c = 'FFR',Access_Duration_in_Months__c=36);
        insert ekey3;
        
        apiTrans = New API_Transaction__c(Request__c='RecordPurchase', Opportunity__c=opportunity.id, Ignore_for_Retry__c=false);
        insert apiTrans;
        
        List<Mobius_Products__c> lstMP = new List<Mobius_Products__c>();
        Mobius_Products__c mp = new Mobius_Products__c();
        mp.name = 'FRM Current Year';
        mp.Year__c = '2020';
        lstMP.add(mp);
        mp = new Mobius_Products__c();
        mp.name = '2020 FRM Exam Part I Book 1';
        mp.Year__c = '2020';
        mp.Exam__c = 'FRM';
        mp.Part__c = 'I';
        mp.Product_Id__c = 52;
        mp.Salesforce_Product_Code__c = 'FRM1X';
        mp.Access_Duration_in_Months__c = 36;
        lstMP.add(mp);
        insert lstMP;  

        Event__c eve = new Event__c();
        
        eve.Name = 'TEST event';
        eve.Last_Date_For_Registration__c = Date.today().addDays(30);
        insert eve;
        
        Event_Registration__c er = new Event_Registration__c(Name = 'Event', Opportunity__c = opportunity.id,event__C = eve.id);
        insert er;
        
        Chapter_Meeting__c cm = new Chapter_Meeting__c(Name='CM');
        insert cm;
        
        Chapter_Meeting_Registration__c cr = new Chapter_Meeting_Registration__c(Name = 'Event', Opportunity__c = opportunity.id, Chapter_Meeting__c = cm.id);
        insert cr;
        
    }

    static testMethod void unitTest_9(){
        
        testData();
        test.startTest();
        
        
        opportunityTriggerUtils.CreateDuplicateShipping(account.id,'2342342','FRM');
        
        set<Opportunity> opps = new set<Opportunity>();
        opps.add(Opportunity);
        //opportunityTriggerUtils.createProducts(oppids);
        opportunityTriggerUtils.createContract(opportunity,system.today(),memberRecordTypeID,'Activated','Individual',12);
        
        map<ID, Opportunity> wileyOpps = new map<ID, Opportunity>();
        wileyOpps.put(opportunity.Id, opportunity);
        wileyOpps.put(opportunity1.Id, opportunity1);
        
        Map < Id, OpportunityLineItem > wileyOppItems = new Map < Id, OpportunityLineItem >();
        wileyOppItems.put(opportunity.Id, lineItem);
        wileyOppItems.put(opportunity1.Id, lineItem11);
        opportunityTriggerUtils.extendWiley(wileyOpps, wileyOppItems);
        Test.setMock(HttpCalloutMock.class, new RiskDotNetMockHttpCallout(200));
        opportunityTriggerUtils.extendRiskNet(wileyOpps, wileyOppItems);
        
        opportunityTriggerUtils.provisionMobiuseBook(wileyOpps, 'FRM', 'I');
        
        map<ID, String> eBookOpps = new map<ID, String>();
        eBookOpps.put(opportunity.Id, '1232');
        opportunityTriggerUtils.unprovisionMobiuseBook(eBookOpps, 'FRM', 'I');   
        
       // map<ID, Opportunity> YardstickOpps = new map<ID, Opportunity>();
       // YardstickOpps.put(opportunity.Id, opportunity);
       // opportunityTriggerUtils.provisionYardstick(YardstickOpps);
        
        //provisionEBookWithKeys(map<ID, Opportunity> eBookOpps
        opportunityTriggerUtils.provisionEBookWithKeys(wileyOpps, 'ERP Exam Part I'); 
        opportunityTriggerUtils.provisionEBookWithKeys(wileyOpps, 'ERP Exam Part II'); 
        opportunityTriggerUtils.provisionEBookWithKeys(wileyOpps, 'FRR'); 
        opportunityTriggerUtils.provisionEBookWithKeys(wileyOpps, 'FFR'); 
        
        Set < ID > setRegisterExamAttempts = new Set < ID >();
        setRegisterExamAttempts.add(attempt.ID);
        opportunityTriggerUtils.updateRegisterExamAttempts(setRegisterExamAttempts);
        
        opportunityTriggerUtils.provisionFFRA(wileyOpps); 
        Set < ID > OppIDs = new Set < ID >();
        OppIDs.add(opportunity.Id);
        opportunityTriggerUtils.cancelFFRA(OppIDs);
        
        
        Set < Id > setOpportunities = new Set < Id >();
        setOpportunities.add(opportunity.id);
        opportunityTriggerUtils.provisionEvents(setOpportunities); 
        
        Map < Id, Opportunity > oppMap = new Map < Id, Opportunity >();
        oppMap.put(opportunity.id, opportunity);
        opportunityTriggerUtils.provisionChapterMeetingRegistrations(oppMap); 

        opportunityTriggerUtils.closeBulkOrders(oppMap);

        test.stopTest();
    
    }
    
     static testMethod void createContractTest(){
        
        testData();
        test.startTest();
        //opportunityTriggerUtils.createContract(opportunity,System.today(),memberRecordTypeID,'New','Test',1);
        test.stopTest();
    
    }
     static testMethod void updateExamAttemptsTest(){
        
        testData();
        test.startTest();
        opportunityTriggerUtils.updateExamAttempts(new Set<Id>{attempt.Id},new Set<Id>{attempt.Id},new Set<Id>{attempt.Id},new Set<Id>{attempt.Id});
        test.stopTest();
        
    }
    
    static testMethod void getExamSitedata(){
        testData();
        test.startTest();
        opportunityTriggerUtils.getExamSitedata(new Set<String>{exmSite.Site_code__c},new Set<String>{contact.id} );
        test.stopTest();
    }
    
    static testMethod void unitTest_10(){
        
        testData();
        test.startTest();
        set<id> setAccountIds = new set<id>();
        setAccountIds.add(account.id);
        
        set<id> setOpps = new set<id>();
        setOpps.add(opportunity.id);
        
        Set<String> setProdCodes = new set<string>();
        setProdCodes.add('AFREE');
        Map<Id,Set<String>> mapProdCodesWithAccount = new Map<Id,Set<String>> ();
        mapProdCodesWithAccount.put(account.id,setProdCodes);
        Test.setMock(HttpCalloutMock.class, new RiskDotNetMockHttpCallout(200));
        opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
        
        setProdCodes.clear();
        setProdCodes.add('MEMI');
        mapProdCodesWithAccount.clear();
        mapProdCodesWithAccount.put(account.id,setProdCodes);
        opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);

        setProdCodes.clear();
        setProdCodes.add('MEMS');
        mapProdCodesWithAccount.clear();
        mapProdCodesWithAccount.put(account.id,setProdCodes);
        opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);

        setProdCodes.clear();
        setProdCodes.add('MEMF');
        mapProdCodesWithAccount.clear();
        mapProdCodesWithAccount.put(account.id,setProdCodes);
        opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
        
        setProdCodes.clear();
        setProdCodes.add('MEMC');
        mapProdCodesWithAccount.clear();
        mapProdCodesWithAccount.put(account.id,setProdCodes);
        opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
        
        
        /*opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
        opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);
        opportunityTriggerUtils.updateRenewContracts( setOpps,setAccountIds,mapProdCodesWithAccount,opportunity);*/

        test.stopTest();  
    
    }
    
    static testMethod void unitTest_11(){
        
        testData();
        test.startTest();
        Map<Id,Opportunity> oppmap = new Map<Id,Opportunity>  ();
        oppmap.put(shipOpportunity.id,shipOpportunity);
        opportunityTriggerUtils.updateShipService( oppMap);
        test.stopTest();
    
    }
    
    static testMethod void unitTest_12(){
        
        testData();
        test.startTest();
        opportunityTriggerUtils.getUPSCode('UPS 2nd Day Air A.M.');
        opportunityTriggerUtils.getUPSCode('UPS 2nd Day Air');
        opportunityTriggerUtils.getUPSCode('UPS 3 Day Select');
        opportunityTriggerUtils.getUPSCode('UPS Ground');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air Early A.M.');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air Saver');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air');
        opportunityTriggerUtils.getUPSCode('UPS Saver');
        opportunityTriggerUtils.getUPSCode('UPS Standard');
        opportunityTriggerUtils.getUPSCode('UPS Worldwide Expedited');
        opportunityTriggerUtils.getUPSCode('UPS Worldwide Express Plus');
        opportunityTriggerUtils.getUPSCode('UPS Worldwide Express');
        opportunityTriggerUtils.getUPSCode('UPS Next Day Air');
        opportunityTriggerUtils.getUPSCode('Error');
        test.stopTest();
    }
    
    static testMethod void unitTest_13(){
        
        testData();
        test.startTest();
        list<Opportunity> opps = new List<Opportunity>  ();
        opps.add(opportunity);
        opportunityTriggerUtils.updateShippingInfo( opps);
        test.stopTest();
    
    }
    
    static testMethod void unitTest_14(){
        
        testData();
        test.startTest();
        set<id> accIds = new set<id>();
        accIds.add(account.id);
        opportunityTriggerUtils.updateautorenew(accIds);
        test.stopTest();
    
    }
    
    static testMethod void unitTest_15(){
        testData();
        test.startTest();
        opportunityTriggerUtils.createContract(Opportunity, System.today(), memberRecordTypeID, 'Draft', 'Individual', 5);
    }

    @IsTest
    private static void UnDeferExm(){
        testData();
        test.startTest();
        opportunityTriggerUtils.UnDeferExm(new List<Exam_Attempt__c>{attempt}, null, Opportunity.Id);
        test.stopTest();
    }

    @IsTest
    private static void updateExm(){
        testData();
        test.startTest();
        opportunityTriggerUtils.updateExm(new List<Exam_Attempt__c>{attempt}, null, Opportunity.Id);
        test.stopTest();
    }
    
    static testMethod void createProductRefunds(){
        testData();
        test.startTest();
        opportunityTriggerUtils.createProductRefunds(new Set<String>{opportunity.id});
        test.stopTest();
    }
    
}