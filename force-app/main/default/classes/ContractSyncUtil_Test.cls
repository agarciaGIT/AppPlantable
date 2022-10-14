@istest
public class ContractSyncUtil_Test {
    
    static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Contract mberContract1;
    
    static Contract mberContract2;
    static Contract mberContract3;
    static Contract mberContract4;
    static Contract mberContract5;
    
    
    static Account account ;
    static Opportunity opportunity; 
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Candidate_Requirement__c reqt;
    static Candidate_Requirement__c reqt1;
    static Candidate_Requirement__c reqt2;
    
    
    static void testData_1S(){ 
        

        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2012, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        Opportunity oppMEMI2 = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2011, 6, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI2;        
        
        Opportunity oppAFREE = new Opportunity(name = 'Test Opportunity AFREE', Amount = 195, CloseDate = Date.newInstance(2010, 5, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATM123A', LEGACY_PurchasesRefNo__c = 'ATM123A', AccountId = account.Id);
        insert oppAFREE;        
        
        Opportunity oppMEMI1 = new Opportunity(name = 'Test Opportunity MEMI1', Amount = 195, CloseDate = Date.newInstance(2009, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATM123B', LEGACY_PurchasesRefNo__c = 'ATM123B', AccountId = account.Id);
        insert oppMEMI1;
        
        Opportunity oppMEMI = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2008, 3, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATM123C', LEGACY_PurchasesRefNo__c = 'ATM123C', AccountId = account.Id);
        insert oppMEMI;
        
        Opportunity oppMEMF = new Opportunity(name = 'Test Opportunity MEMF', Amount = 195, CloseDate = Date.newInstance(2007, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATM123D', LEGACY_PurchasesRefNo__c = 'ATM123D', AccountId = account.Id);
        insert oppMEMF;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        
        for(integer i = 0;i<codes2.size();i++){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        
        ID idMEMI;
        ID idMEMF;
        ID idAFREE;
        
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
            
            if(prod.productCode == 'MEMI')
                idMEMI = prod.Id;
            
            if(prod.productCode == 'MEMF')
                idMEMF = prod.Id;
            
            if(prod.productCode == 'AFREE')
                idAFREE = prod.Id;
            
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI1 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI2 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMF = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListAFREE = new list<OpportunityLineItem>();        
        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
            
            if(entry.Product2Id == idMEMI) {
                OpportunityLineItem lineItemMEMI = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI.id,PricebookEntryId = entry.id);
                lineItemListMEMI.add(lineItemMEMI);
                
                OpportunityLineItem lineItemMEMI1 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI1.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI1);
                
                OpportunityLineItem lineItemMEMI2 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI2.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI2);
                
            }
            
            if(entry.Product2Id == idMEMF) {
                OpportunityLineItem lineItemMEMF = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMF.id,PricebookEntryId = entry.id);
                lineItemListMEMF.add(lineItemMEMF);
            }
            
            if(entry.Product2Id == idAFREE) {
                OpportunityLineItem lineItemAFREE = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppAFREE.id,PricebookEntryId = entry.id);
                lineItemListAFREE.add(lineItemAFREE);
            }
            
        }
        insert lineItemList;
        insert lineItemListMEMI;
        insert lineItemListMEMI1;
        insert lineItemListMEMI2;
        
        insert lineItemListMEMF;
        insert lineItemListAFREE;
        
        List<contract> lstContractCreate = new List<contract>(); 
        List<contract> lstContractUpdate = new List<contract>(); 
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        lstContractCreate.add(contract);
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 4,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        lstContractCreate.add(frmContract);
        
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        lstContractCreate.add(mberContract); 
        
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI1.id,accountId = opportunity.AccountId);
        lstContractCreate.add(mberContract1);
        
        
        mberContract2  = new Contract(ContractTerm =2,startDate = system.today()- 2,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMF.id,accountId = opportunity.AccountId);
        lstContractCreate.add(mberContract2); 
        
        
        mberContract3  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppAFREE.id,accountId = opportunity.AccountId);
        lstContractCreate.add(mberContract3);
        
        
        mberContract4  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI2.id,accountId = opportunity.AccountId);
        lstContractCreate.add(mberContract4);
        
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        lstContractCreate.add(con); 
        
        
        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        lstContractCreate.add(con1); 
        
        insert lstContractCreate;
        
        contract.Status = 'Activated';
        lstContractUpdate.add(contract);
        frmContract.Status = 'Activated';
        lstContractUpdate.add(frmContract); 
        mberContract.Status = 'Activated';
        lstContractUpdate.add(mberContract); 
        mberContract1.Status = 'Activated';
        lstContractUpdate.add(mberContract1); 
        mberContract2.Status = 'Activated';
        lstContractUpdate.add(mberContract2); 
        mberContract3.Status = 'Activated';
        lstContractUpdate.add(mberContract3); 
        con.Status = 'Activated';
        lstContractUpdate.add(con); 
        mberContract4.Status = 'Activated';
        lstContractUpdate.add(mberContract4); 
        con1.Status = 'Canceled';
        lstContractUpdate.add(con1); 
        
        Update lstContractUpdate;
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        reqtJ.Candidate_Commitment__c = contract.id;
        reqtJ.name = 'Job';
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ.Status__c = 'Initial';
        insert reqtJ;
        
        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        reqtJ1.Candidate_Commitment__c = contract.id;
        reqtJ1.name = 'Job1';
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ1.Status__c = 'Ready For Review';
        insert reqtJ1;
        
        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        reqtJ2.Candidate_Commitment__c = contract.id;
        reqtJ2.name = 'Job2';
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ2.Status__c = 'Failed Review';
        reqtJ2.Failed_Review_Reason__c = 'TEST';
        insert reqtJ2;
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = con1.id;
        reqt3.name = 'CPE';
        insert reqt3;
        
    }            
    
    
    static void testData_1Z(){
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);       
        insert opportunity;
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2012, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        Opportunity oppMEMI2 = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2011, 6, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI2;       
        Opportunity oppMEMI1 = new Opportunity(name = 'Test Opportunity MEMI1', Amount = 195, CloseDate = Date.newInstance(2010, 5, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI1;
        Opportunity oppMEMF = new Opportunity(name = 'Test Opportunity MEMF', Amount = 195, CloseDate = Date.newInstance(2009, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMF;
        Opportunity oppMEMI = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2008, 3, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATMW123123', AccountId = account.Id);
        insert oppMEMI;
        Opportunity oppAFREE = new Opportunity(name = 'Test Opportunity AFREE', Amount = 195, CloseDate = Date.newInstance(2007, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATM123', LEGACY_PurchasesRefNo__c = 'ATM123', AccountId = account.Id);
        insert oppAFREE;       
        
        
        
        list<Product2> prodList = new list<Product2>();
        
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                
                
                system.debug('glCodes>>>'+glCodes); 
        
        system.debug('codes2>>>'+codes2); 
        
        
        
        for(integer i = 0;i<codes2.size();i++){
            
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            
            prodList.add(prod);
            
        }
        
        insert prodList;       
        
        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        
        insert customPB;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        
        
        
        ID idMEMI;
        
        ID idMEMF;
        
        ID idAFREE;
        
        
        
        for(product2 prod : prodList){
            
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            
            //refundList.add(refund);
            
            mapRefund.put(refund.Id, refund);
            
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            
            pricebookEntries.add(standardPrice);
            
            standardpricebookEntries.add(standardPrice1);
            
            
            
            if(prod.productCode == 'MEMI')
                
                idMEMI = prod.Id;
            
            
            
            if(prod.productCode == 'MEMF')
                
                idMEMF = prod.Id;
            
            
            
            if(prod.productCode == 'AFREE')
                
                idAFREE = prod.Id;
            
            
            
        }      
        
        for(Product_Refunds__c pr :mapRefund.values()) {
            
            refundList.add(pr);
            
        }
        
        
        
        system.debug('refundList>>>'+refundList); 
        
        
        
        insert refundList;
        
        insert standardpricebookEntries;
        
        insert pricebookEntries;
        
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();       
        
        list<OpportunityLineItem> lineItemListMEMI = new list<OpportunityLineItem>();       
        
        list<OpportunityLineItem> lineItemListMEMI1 = new list<OpportunityLineItem>();       
        
        list<OpportunityLineItem> lineItemListMEMI2 = new list<OpportunityLineItem>();       
        
        list<OpportunityLineItem> lineItemListMEMF = new list<OpportunityLineItem>();       
        
        list<OpportunityLineItem> lineItemListAFREE = new list<OpportunityLineItem>();       
        
        
        
        for(PricebookEntry entry : PricebookEntries){
            
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            
            lineItemList.add(lineItem);
            
            
            
            if(entry.Product2Id == idMEMI) {
                
                OpportunityLineItem lineItemMEMI = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI.id,PricebookEntryId = entry.id);
                
                lineItemListMEMI.add(lineItemMEMI);
                
                
                
                OpportunityLineItem lineItemMEMI1 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI1.id,PricebookEntryId = entry.id);
                
                lineItemListMEMI1.add(lineItemMEMI1);
                
                
                
                OpportunityLineItem lineItemMEMI2 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI2.id,PricebookEntryId = entry.id);
                
                lineItemListMEMI1.add(lineItemMEMI2);
                
                
                
            }
            
            
            
            if(entry.Product2Id == idMEMF) {
                
                OpportunityLineItem lineItemMEMF = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMF.id,PricebookEntryId = entry.id);
                
                lineItemListMEMF.add(lineItemMEMF);
                
            }
            
            
            
            if(entry.Product2Id == idAFREE) {
                
                OpportunityLineItem lineItemAFREE = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppAFREE.id,PricebookEntryId = entry.id);
                
                lineItemListAFREE.add(lineItemAFREE);
                
            }
            
            
            
        }
        
        insert lineItemList;
        
        insert lineItemListMEMI;
        
        insert lineItemListMEMI1;
        
        insert lineItemListMEMI2;
        
        
        
        insert lineItemListMEMF;
        
        insert lineItemListAFREE;
        
        
        
        List<contract> lstContract = new List<contract>();
        
        
        
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        
        lstContract.add(contract);
        
        
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 4,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        
        lstContract.add(frmContract) ;
        
        
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        
        lstContract.add(mberContract) ;
        
        
        
        
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI1.id,accountId = opportunity.AccountId);
        
        lstContract.add(mberContract1) ;
        
        
        
        
        
        mberContract2  = new Contract(ContractTerm =2,startDate = system.today()- 2,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMF.id,accountId = opportunity.AccountId);
        
        lstContract.add(mberContract2) ;
        
        
        
        
        
        mberContract3  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppAFREE.id,accountId = opportunity.AccountId);
        
        lstContract.add(mberContract3) ;
        
        
        
        
        
        mberContract4  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI2.id,accountId = opportunity.AccountId);
        
        lstContract.add(mberContract4) ;
        
        
        
        
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        
        lstContract.add(con) ;
        
        
        
        
        
        
        
        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        
        lstContract.add(con1) ;
        
        
        
        insert lstContract;
        
        
        
        contract.Status = 'Activated';
        
        con1.Status = 'Canceled';
        
        con.Status = 'Activated';
        
        mberContract4.Status = 'Activated';
        
        mberContract3.Status = 'Activated';
        
        mberContract2.Status = 'Activated';
        
        mberContract1.Status = 'Activated';
        
        mberContract.Status = 'Activated';
        
        frmContract.Status = 'Activated';
        
        Update lstContract;
        
        
        
        reqt = new Candidate_Requirement__c();
        
        reqt.Candidate_Commitment__c = contract.id;
        
        reqt.name = 'FRM1 test';
        
        insert reqt;
        
        
        
        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        
        reqtJ.Candidate_Commitment__c = contract.id;
        
        reqtJ.name = 'Job';
        
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        reqtJ.Status__c = 'Initial';
        
        insert reqtJ;
        
        
        
        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        
        reqtJ1.Candidate_Commitment__c = contract.id;
        
        reqtJ1.name = 'Job1';
        
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        reqtJ1.Status__c = 'Ready For Review';
        
        insert reqtJ1;
        
        
        
        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        
        reqtJ2.Candidate_Commitment__c = contract.id;
        
        reqtJ2.name = 'Job2';
        
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        reqtJ2.Status__c = 'Failed Review';
        
        reqtJ2.Failed_Review_Reason__c = 'TEST';
        
        insert reqtJ2;
        
        
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        
        reqt3.Candidate_Commitment__c = con1.id;
        
        reqt3.name = 'CPE';
        
        insert reqt3;
        
        
        
        oppMEMI.Display_Invoice_Number__c = 'ATM123';
        
        update oppMEMI;
        
        
        
        
        
    } 
    
    static void testData_1Y(){ 
        
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2012, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        Opportunity oppMEMI2 = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2011, 6, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI2;        
        
        Opportunity oppMEMI1 = new Opportunity(name = 'Test Opportunity MEMI1', Amount = 195, CloseDate = Date.newInstance(2010, 5, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI1;
        
        Opportunity oppAFREE = new Opportunity(name = 'Test Opportunity AFREE', Amount = 195, CloseDate = Date.newInstance(2009, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppAFREE;        
        
        Opportunity oppMEMF = new Opportunity(name = 'Test Opportunity MEMF', Amount = 195, CloseDate = Date.newInstance(2008, 3, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMF;
        
        Opportunity oppMEMI = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2007, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATM123', LEGACY_PurchasesRefNo__c = 'ATM123', AccountId = account.Id);
        insert oppMEMI;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        
        for(integer i = 0;i<codes2.size();i++){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        
        ID idMEMI;
        ID idMEMF;
        ID idAFREE;
        
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
            
            if(prod.productCode == 'MEMI')
                idMEMI = prod.Id;
            
            if(prod.productCode == 'MEMF')
                idMEMF = prod.Id;
            
            if(prod.productCode == 'AFREE')
                idAFREE = prod.Id;
            
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI1 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI2 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMF = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListAFREE = new list<OpportunityLineItem>();        
        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
            
            if(entry.Product2Id == idMEMI) {
                OpportunityLineItem lineItemMEMI = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI.id,PricebookEntryId = entry.id);
                lineItemListMEMI.add(lineItemMEMI);
                
                OpportunityLineItem lineItemMEMI1 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI1.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI1);
                
                OpportunityLineItem lineItemMEMI2 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI2.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI2);
                
            }
            
            if(entry.Product2Id == idMEMF) {
                OpportunityLineItem lineItemMEMF = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMF.id,PricebookEntryId = entry.id);
                lineItemListMEMF.add(lineItemMEMF);
            }
            
            if(entry.Product2Id == idAFREE) {
                OpportunityLineItem lineItemAFREE = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppAFREE.id,PricebookEntryId = entry.id);
                lineItemListAFREE.add(lineItemAFREE);
            }
            
        }
        insert lineItemList;
        insert lineItemListMEMI;
        insert lineItemListMEMI1;
        insert lineItemListMEMI2;
        
        insert lineItemListMEMF;
        insert lineItemListAFREE;
        
        list<Contract> lstContract = new list<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        lstContract.add(contract);
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 4,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        lstContract.add(frmContract) ;
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        lstContract.add(mberContract) ;
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI1.id,accountId = opportunity.AccountId);
        lstContract.add(mberContract1) ;
        
        mberContract2  = new Contract(ContractTerm =2,startDate = system.today()- 2,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMF.id,accountId = opportunity.AccountId);
        lstContract.add(mberContract2) ;
        
        mberContract3  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppAFREE.id,accountId = opportunity.AccountId);
        lstContract.add(mberContract3) ;
        
        mberContract4  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI2.id,accountId = opportunity.AccountId);
        lstContract.add(mberContract4) ;
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        lstContract.add(con) ;
        
        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        lstContract.add(con1) ;
        insert lstContract;
        
        contract.Status = 'Activated';
        con1.Status = 'Canceled';
        con.Status = 'Activated';
        mberContract4.Status = 'Activated';
        mberContract3.Status = 'Activated';
        mberContract2.Status = 'Activated';
        mberContract1.Status = 'Activated';
        mberContract.Status = 'Activated';
        frmContract.Status = 'Activated';
        
        update lstContract;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        reqtJ.Candidate_Commitment__c = contract.id;
        reqtJ.name = 'Job';
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ.Status__c = 'Initial';
        insert reqtJ;
        
        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        reqtJ1.Candidate_Commitment__c = contract.id;
        reqtJ1.name = 'Job1';
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ1.Status__c = 'Ready For Review';
        insert reqtJ1;
        
        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        reqtJ2.Candidate_Commitment__c = contract.id;
        reqtJ2.name = 'Job2';
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ2.Status__c = 'Failed Review';
        reqtJ2.Failed_Review_Reason__c = 'TEST';
        insert reqtJ2;
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = con1.id;
        reqt3.name = 'CPE';
        insert reqt3;
        
        oppMEMI.Display_Invoice_Number__c = 'ATM123';
        update oppMEMI;
        
        
    }            
    
    static void testData_1X(){ 
        
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2012, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        Opportunity oppMEMI2 = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2011, 6, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI2;        
        
        Opportunity oppMEMI1 = new Opportunity(name = 'Test Opportunity MEMI1', Amount = 195, CloseDate = Date.newInstance(2010, 5, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI1;
        
        Opportunity oppMEMI = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2009, 3, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI;
        
        Opportunity oppAFREE = new Opportunity(name = 'Test Opportunity AFREE', Amount = 195, CloseDate = Date.newInstance(2008, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppAFREE;        
        
        Opportunity oppMEMF = new Opportunity(name = 'Test Opportunity MEMF', Amount = 195, CloseDate = Date.newInstance(2007, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'ATM123', LEGACY_PurchasesRefNo__c = 'ATM123', AccountId = account.Id);
        insert oppMEMF;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        
        for(integer i = 0;i<codes2.size();i++){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        
        ID idMEMI;
        ID idMEMF;
        ID idAFREE;
        
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
            
            if(prod.productCode == 'MEMI')
                idMEMI = prod.Id;
            
            if(prod.productCode == 'MEMF')
                idMEMF = prod.Id;
            
            if(prod.productCode == 'AFREE')
                idAFREE = prod.Id;
            
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI1 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI2 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMF = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListAFREE = new list<OpportunityLineItem>();        
        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
            
            if(entry.Product2Id == idMEMI) {
                OpportunityLineItem lineItemMEMI = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI.id,PricebookEntryId = entry.id);
                lineItemListMEMI.add(lineItemMEMI);
                
                OpportunityLineItem lineItemMEMI1 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI1.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI1);
                
                OpportunityLineItem lineItemMEMI2 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI2.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI2);
                
            }
            
            if(entry.Product2Id == idMEMF) {
                OpportunityLineItem lineItemMEMF = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMF.id,PricebookEntryId = entry.id);
                lineItemListMEMF.add(lineItemMEMF);
            }
            
            if(entry.Product2Id == idAFREE) {
                OpportunityLineItem lineItemAFREE = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppAFREE.id,PricebookEntryId = entry.id);
                lineItemListAFREE.add(lineItemAFREE);
            }
            
        }
        insert lineItemList;
        insert lineItemListMEMI;
        insert lineItemListMEMI1;
        insert lineItemListMEMI2;
        
        insert lineItemListMEMF;
        insert lineItemListAFREE;
        
        List<Contract> contractList = new List<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract);
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 4,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(frmContract);
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract);
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI1.id,accountId = opportunity.AccountId);
        contractList.add(mberContract1);
        
        mberContract2  = new Contract(ContractTerm =2,startDate = system.today()- 2,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMF.id,accountId = opportunity.AccountId);
        contractList.add(mberContract2);
        
        mberContract3  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppAFREE.id,accountId = opportunity.AccountId);
        contractList.add(mberContract3);
        
        mberContract4  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI2.id,accountId = opportunity.AccountId);
        contractList.add(mberContract4);
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con);
        
        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con1);
        insert contractList;
        
        contract.Status = 'Activated';
        frmContract.Status = 'Activated';
        mberContract.Status = 'Activated';
        mberContract1.Status = 'Activated';
        mberContract2.Status = 'Activated';
        mberContract3.Status = 'Activated';
        mberContract4.Status = 'Activated';
        con.Status = 'Activated';
        con1.Status = 'Canceled';
        update contractList;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        reqtJ.Candidate_Commitment__c = contract.id;
        reqtJ.name = 'Job';
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ.Status__c = 'Initial';
        insert reqtJ;
        
        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        reqtJ1.Candidate_Commitment__c = contract.id;
        reqtJ1.name = 'Job1';
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ1.Status__c = 'Ready For Review';
        insert reqtJ1;
        
        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        reqtJ2.Candidate_Commitment__c = contract.id;
        reqtJ2.name = 'Job2';
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ2.Status__c = 'Failed Review';
        reqtJ2.Failed_Review_Reason__c = 'TEST';
        insert reqtJ2;
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = con1.id;
        reqt3.name = 'CPE';
        insert reqt3;
        
        oppMEMF.Display_Invoice_Number__c = 'ATM123';
        update oppMEMF;
        
        
    }        
    
    static void testData_1(){ 
        
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2012, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        Opportunity oppMEMI2 = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2011, 6, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI2;        
        
        Opportunity oppMEMI1 = new Opportunity(name = 'Test Opportunity MEMI1', Amount = 195, CloseDate = Date.newInstance(2010, 5, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI1;
        
        Opportunity oppMEMF = new Opportunity(name = 'Test Opportunity MEMF', Amount = 195, CloseDate = Date.newInstance(2009, 4, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMF;
        
        Opportunity oppMEMI = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2008, 3, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI;
        
        Opportunity oppAFREE = new Opportunity(name = 'Test Opportunity AFREE', Amount = 195, CloseDate = Date.newInstance(2007, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppAFREE;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        
        for(integer i = 0;i<codes2.size();i++){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        
        ID idMEMI;
        ID idMEMF;
        ID idAFREE;
        
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
            
            if(prod.productCode == 'MEMI')
                idMEMI = prod.Id;
            
            if(prod.productCode == 'MEMF')
                idMEMF = prod.Id;
            
            if(prod.productCode == 'AFREE')
                idAFREE = prod.Id;
            
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI1 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI2 = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMF = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListAFREE = new list<OpportunityLineItem>();        
        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
            
            if(entry.Product2Id == idMEMI) {
                OpportunityLineItem lineItemMEMI = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI.id,PricebookEntryId = entry.id);
                lineItemListMEMI.add(lineItemMEMI);
                
                OpportunityLineItem lineItemMEMI1 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI1.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI1);
                
                OpportunityLineItem lineItemMEMI2 = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI2.id,PricebookEntryId = entry.id);
                lineItemListMEMI1.add(lineItemMEMI2);
                
            }
            
            if(entry.Product2Id == idMEMF) {
                OpportunityLineItem lineItemMEMF = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMF.id,PricebookEntryId = entry.id);
                lineItemListMEMF.add(lineItemMEMF);
            }
            
            if(entry.Product2Id == idAFREE) {
                OpportunityLineItem lineItemAFREE = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppAFREE.id,PricebookEntryId = entry.id);
                lineItemListAFREE.add(lineItemAFREE);
            }
            
        }
        insert lineItemList;
        insert lineItemListMEMI;
        insert lineItemListMEMI1;
        insert lineItemListMEMI2;
        
        insert lineItemListMEMF;
        insert lineItemListAFREE;
        
        List<Contract> contractList = new List<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract);
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 4,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(frmContract);
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract);
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI1.id,accountId = opportunity.AccountId);
        contractList.add(mberContract1);
        
        mberContract2  = new Contract(ContractTerm =2,startDate = system.today()- 2,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMF.id,accountId = opportunity.AccountId);
        contractList.add(mberContract2);
        
        mberContract3  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppAFREE.id,accountId = opportunity.AccountId);
        contractList.add(mberContract3);
        
        mberContract4  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI2.id,accountId = opportunity.AccountId);
        contractList.add(mberContract4);
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con);
        
        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con1);
        insert contractList;
        
        contract.Status = 'Activated';
        frmContract.Status = 'Activated';
        mberContract.Status = 'Activated';
        mberContract1.Status = 'Activated';
        mberContract2.Status = 'Activated';
        mberContract3.Status = 'Activated';
        mberContract4.Status = 'Activated';
        con.Status = 'Activated';
        con1.Status = 'Canceled';
        update contractList;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        reqtJ.Candidate_Commitment__c = contract.id;
        reqtJ.name = 'Job';
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ.Status__c = 'Initial';
        insert reqtJ;
        
        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        reqtJ1.Candidate_Commitment__c = contract.id;
        reqtJ1.name = 'Job1';
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ1.Status__c = 'Ready For Review';
        insert reqtJ1;
        
        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        reqtJ2.Candidate_Commitment__c = contract.id;
        reqtJ2.name = 'Job2';
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ2.Status__c = 'Failed Review';
        reqtJ2.Failed_Review_Reason__c = 'TEST';
        insert reqtJ2;
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = con1.id;
        reqt3.name = 'CPE';
        insert reqt3;
        
        
    }    
    
    
    static void testData_1A(){ 
        
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2009, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        Opportunity oppMEMI = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2008, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI;
        
        Opportunity oppMEMF = new Opportunity(name = 'Test Opportunity MEMF', Amount = 195, CloseDate = Date.newInstance(2007, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMF;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        
        for(integer i = 0;i<codes2.size();i++){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        
        ID idMEMI;
        ID idMEMF;
        
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
            
            if(prod.productCode == 'MEMI')
                idMEMI = prod.Id;
            
            if(prod.productCode == 'MEMF')
                idMEMF = prod.Id;
            
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMF = new list<OpportunityLineItem>();        
        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
            if(entry.Product2Id == idMEMI) {
                OpportunityLineItem lineItemMEMI = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI.id,PricebookEntryId = entry.id);
                lineItemListMEMI.add(lineItemMEMI);
            }
            
            if(entry.Product2Id == idMEMF) {
                OpportunityLineItem lineItemMEMF = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMF.id,PricebookEntryId = entry.id);
                lineItemListMEMF.add(lineItemMEMF);
            }
            
        }
        insert lineItemList;
        insert lineItemListMEMI;
        insert lineItemListMEMF;
        
        List<Contract> contractList = new List<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId); 
        contractList.add(contract);
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 4,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(frmContract);
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract);
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 2,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract1);
        
        mberContract2  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = '  Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract2);
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con);
        
        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con1);
        
        insert contractList;
        
        contract.Status = 'Activated';
        frmContract.Status = 'Activated';
        mberContract.Status = 'Activated';
        mberContract1.Status = 'Activated';
        mberContract2.Status = 'Activated';
        con.Status = 'Activated';
        con1.Status = 'Canceled';
        update contractList;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        reqtJ.Candidate_Commitment__c = contract.id;
        reqtJ.name = 'Job';
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ.Status__c = 'Initial';
        insert reqtJ;
        
        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        reqtJ1.Candidate_Commitment__c = contract.id;
        reqtJ1.name = 'Job1';
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ1.Status__c = 'Ready For Review';
        insert reqtJ1;
        
        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        reqtJ2.Candidate_Commitment__c = contract.id;
        reqtJ2.name = 'Job2';
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ2.Status__c = 'Failed Review';
        reqtJ2.Failed_Review_Reason__c = 'TEST';
        insert reqtJ2;
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = con1.id;
        reqt3.name = 'CPE';
        insert reqt3;
        
        
    }
    
    
    static void testData_1B(){ 
        
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2009, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        Opportunity oppMEMI = new Opportunity(name = 'Test Opportunity MEMI', Amount = 195, CloseDate = Date.newInstance(2007, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMI;
        
        Opportunity oppMEMF = new Opportunity(name = 'Test Opportunity MEMF', Amount = 195, CloseDate = Date.newInstance(2008, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert oppMEMF;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        
        for(integer i = 0;i<codes2.size();i++){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        
        ID idMEMI;
        ID idMEMF;
        
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
            
            if(prod.productCode == 'MEMI')
                idMEMI = prod.Id;
            
            if(prod.productCode == 'MEMF')
                idMEMF = prod.Id;
            
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMI = new list<OpportunityLineItem>();        
        list<OpportunityLineItem> lineItemListMEMF = new list<OpportunityLineItem>();        
        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
            if(entry.Product2Id == idMEMI) {
                OpportunityLineItem lineItemMEMI = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMI.id,PricebookEntryId = entry.id);
                lineItemListMEMI.add(lineItemMEMI);
            }
            
            if(entry.Product2Id == idMEMF) {
                OpportunityLineItem lineItemMEMF = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = oppMEMF.id,PricebookEntryId = entry.id);
                lineItemListMEMF.add(lineItemMEMF);
            }
            
        }
        insert lineItemList;
        insert lineItemListMEMI;
        insert lineItemListMEMF;
        
        
        
        
        
        List<Contract> contractList = new List<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 5,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId); 
        contractList.add(contract);
        
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 4,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(frmContract);
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 3,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract);
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 2,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract1);
        
        mberContract2  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = '  Affiliate',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = oppMEMI.id,accountId = opportunity.AccountId);
        contractList.add(mberContract2);
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con);
        
        Contract con1  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con1);
        insert contractList;
        
        contract.Status = 'Activated';
        frmContract.Status = 'Activated';
        mberContract1.Status = 'Activated';
        mberContract2.Status = 'Activated';
        mberContract.Status = 'Activated';
        con.Status = 'Activated';
        con1.Status = 'Canceled';
        update contractList;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        Candidate_Requirement__c reqtJ = new Candidate_Requirement__c();
        reqtJ.Candidate_Commitment__c = contract.id;
        reqtJ.name = 'Job';
        reqtJ.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ.Status__c = 'Initial';
        insert reqtJ;
        
        Candidate_Requirement__c reqtJ1 = new Candidate_Requirement__c();
        reqtJ1.Candidate_Commitment__c = contract.id;
        reqtJ1.name = 'Job1';
        reqtJ1.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ1.Status__c = 'Ready For Review';
        insert reqtJ1;
        
        Candidate_Requirement__c reqtJ2 = new Candidate_Requirement__c();
        reqtJ2.Candidate_Commitment__c = contract.id;
        reqtJ2.name = 'Job2';
        reqtJ2.RecordTypeID = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        reqtJ2.Status__c = 'Failed Review';
        reqtJ2.Failed_Review_Reason__c = 'TEST';
        insert reqtJ2;
        
        Candidate_Requirement__c reqt3 = new Candidate_Requirement__c();
        reqt3.Candidate_Commitment__c = con1.id;
        reqt3.name = 'CPE';
        insert reqt3;
        
        
    }    
    
    static void testData_2(){ 
        
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        List<Contract> contractList = new List<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract);
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(frmContract);
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(mberContract);
        
        Contract wberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(wberContract);
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(mberContract1);
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con);
        insert contractList;
        
        contract.Status = 'Canceled';
        frmContract.Status = 'Canceled';
        mberContract.Status = 'Expired';
        wberContract.Status = 'Activated';
        mberContract1.Status = 'Canceled';
        con.Status = 'Canceled';
        update contractList;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = con.id;
        reqt1.name = 'FRM1 test';
        insert reqt1;
    }
    
    static void testData_3(){ 
        
        TestClassUtil.isForOldTrigger();
        chrgGtway = new ChargentBase__Gateway__c(Name = 'Test',/*ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',*/ChargentBase__Active__c = true );
        insert chrgGtway;
        
        insert new UpdateIds__c(Name = 'GARP', Record_Id__c = chrgGtway.id);
        
        account = new Account(Name = 'test');
        insert account;
        
        contact = new Contact(lastname = 'Test',AccountId = account.id,email='test@test.com',KPI_ERP_Enrollment_Date__c = Date.newInstance(2009, 2, 17));
        insert contact;
        
        opportunity = new Opportunity(amount = 123,Name = 'Test',company__c = 'Payment', accountId = account.id,stageName = 'Closed Won',Eligible_for_Membership_Extension__c = true,Program__c = 'Print' ,closedate = system.today()+ 15);        
        insert opportunity; 
        
        Opportunity opp = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2009, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp;
        
        list<Product2> prodList = new list<Product2>();
        list<string> codes2 = new list<string> {'AFREE','FRM1','MEMI','MEMS','MEMW','MISC','PRFEE','SHIP','SLSTX','TCEM','WEBN','WEBN','IFC12','CMCNY','AFREE4','CBR','CBR2A','CBREL', 'CBRHB',  'CBRHI', 'CBRNM', 'CHMT1' , 'CMCNY', 'CNY13', 'CNY13', 'CRF', 'CRF', 'CRFA', 'CRFA','CRT', 'CRT','ENC', 'ENC', 'ENCBN', 'ENCCP','ENCE','ENCE','ENCL','ENCL','ENCS','ENCS','ENCSW','ENCSW','ERD','FBRHB','FBRNM','FCBR','FRM1','FRM1E','FRM1E','FRM1H','FRM1L','FRM1L','FRM1N','FRM1S','FRM1S','FRM2E','FRM2E','FRM2H','FRM2L','FRM2L','FRM2N','FRM2S','FRM2S','FRMCN','FRMCP','GRPW','GRPW','GRPW','GRPW','IND1','MEA','MEMC','MEMF'};
            list<string> glCodes = new list<string> {'4040','4010','4040','4040','2007','4999','6110','4999','2819','4080','4070','4060','4000','4070','4999', '4000','4000',  '4999',  '4030',   '4030',   '4000',  '4070','4060',   '4060',  '4070',  '4060','4070','4070','4060','4070','4060','4010','4020','4030','4030', '4002','4001','4001','4002','4001','4002','4001','4002','4110','4030',    '4000','4000','4020','4001','4002','4030',     '4001','4002','4030', '4002',   '4001',    '4002', '4001','4030','4002','4001','4030','4001','4002','4030','4030','4102','4092','4104','4091','4060','4000','4040','4040'};
                
                system.debug('glCodes>>>'+glCodes);  
        system.debug('codes2>>>'+codes2);  
        
        for(integer i = 0;i<codes2.size();i++){
            Product2 prod = new Product2(isActive = true,Name = 'Laptop X200',productCode = codes2[i],GL_Code__c = glCOdes[i],Family = 'Hardware');
            prodList.add(prod); 
        }
        insert prodList;        
        
        list<Product_Refunds__c> refundList = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        Id pricebookId = Test.getStandardPricebookId();
        list<pricebookEntry> pricebookEntries = new list<pricebookEntry>();
        list<pricebookEntry> standardpricebookEntries = new list<pricebookEntry>();
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund.put(refund.Id, refund);
            PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            pricebookEntries.add(standardPrice);
            standardpricebookEntries.add(standardPrice1);
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList;
        insert standardpricebookEntries;
        insert pricebookEntries;
        list<OpportunityLineItem> lineItemList = new list<OpportunityLineItem>();        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
        }
        insert lineItemList;
        
        Opportunity opp1 = new Opportunity(name = 'Test Opportunity1', Amount = 195, CloseDate = Date.newInstance(2010, 2, 17), StageName = 'Closed', Display_Invoice_Number__c = 'W123', AccountId = account.Id);
        insert opp1;
        
        list<Product_Refunds__c> refundList1 = new list<Product_Refunds__c>();
        Map<Id,Product_Refunds__c> mapRefund1 = new Map<Id,Product_Refunds__c>();
        Pricebook2 customPB1 = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB1;
        //Id pricebookId = Test.getStandardPricebookId();
        pricebookEntries = new list<pricebookEntry>();
        standardpricebookEntries = new list<pricebookEntry>();
        for(product2 prod : prodList){
            Product_Refunds__c refund = new Product_Refunds__c(Product__c  = prod.id,Opportunity__c  = opp1.id,status__c = 'Completed');
            //refundList.add(refund);
            mapRefund1.put(refund.Id, refund);
            //PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = customPB.id, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            //PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
            //pricebookEntries.add(standardPrice);
            //standardpricebookEntries.add(standardPrice1);
        }       
        for(Product_Refunds__c pr :mapRefund.values()) {
            refundList.add(pr);
        }
        
        system.debug('refundList>>>'+refundList);  
        
        insert refundList1;
        //insert standardpricebookEntries;
        //insert pricebookEntries;
        lineItemList = new list<OpportunityLineItem>();        
        for(PricebookEntry entry : PricebookEntries){
            OpportunityLineItem lineItem = new OpportunityLineItem(TotalPrice  = 12,Quantity = 1,OpportunityId = opp1.id,PricebookEntryId = entry.id);
            lineItemList.add(lineItem);
        }
        insert lineItemList;
        
        
        List<Contract> contractList = new List<Contract>();
        contract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId); 
        contractList.add(contract);
        
        
        frmContract  = new Contract(ContractTerm =2,Membership_Type__c = 'Individual',startDate = system.today()- 1,recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(frmContract);
        
        mberContract  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Individual',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(mberContract);
        
        mberContract1  = new Contract(ContractTerm =2,startDate = system.today()- 1,Membership_Type__c = 'Student',recordtypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership') ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(mberContract1);
        
        id CPEContractTypeId = RecordTypeHelper.GetRecordTypeId('Contract','CPE');
        Contract con  = new Contract(All_Requirements_Completed__c = true,ContractTerm =2,startDate = system.today()- 10,Membership_Type__c = 'Student',recordtypeId = CPEContractTypeId ,Opportunity__c = opportunity.id,accountId = opportunity.AccountId);
        contractList.add(con);
        insert contractList;
        
        contract.Status = 'Canceled';
        frmContract.Status = 'Canceled';
        mberContract.Status = 'Expired';
        mberContract1.Status = 'Canceled';
        con.Status = 'Canceled';
        update contractList;
        
        
        reqt = new Candidate_Requirement__c();
        reqt.Candidate_Commitment__c = contract.id;
        reqt.name = 'FRM1 test';
        insert reqt;
        
        reqt1 = new Candidate_Requirement__c();
        reqt1.Candidate_Commitment__c = con.id;
        reqt1.name = 'FRM1 test';
        insert reqt1;
    }
    
    static testMethod void unitTest_6(){
        
        testData_1();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);  
        mapAccountIds.put(account.id,mberContract2);    
        mapAccountIds.put(account.id,mberContract3);            
        mapAccountIds.put(account.id,mberContract4);            
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_4(){
        
        testData_1A();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);    
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_5(){
        
        testData_1B();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);    
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_7(){
        
        testData_1X();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);  
        mapAccountIds.put(account.id,mberContract2);    
        mapAccountIds.put(account.id,mberContract3);            
        mapAccountIds.put(account.id,mberContract4);            
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }
    
    
    static testMethod void unitTest_8(){
        
        testData_1Y();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);  
        mapAccountIds.put(account.id,mberContract2);    
        mapAccountIds.put(account.id,mberContract3);            
        mapAccountIds.put(account.id,mberContract4);            
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }
    
    static testMethod void unitTest_9(){
        
        testData_1Z();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);  
        mapAccountIds.put(account.id,mberContract2);    
        mapAccountIds.put(account.id,mberContract3);            
        mapAccountIds.put(account.id,mberContract4);            
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }    
    
    static testMethod void unitTest_1(){
        
        testData_1S();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);  
        mapAccountIds.put(account.id,mberContract2);    
        mapAccountIds.put(account.id,mberContract3);            
        mapAccountIds.put(account.id,mberContract4);          
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }    
    
    
    
    static testMethod void unitTest_2(){
        
        testData_2();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);    
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        
        test.stopTest();
        
    }
    static testMethod void unitTest_3(){
        
        testData_3();
        test.startTest();
        Map<Id,Contract> mapAccountIds = new Map<Id,Contract> ();
        mapAccountIds.put(account.id,contract);
        mapAccountIds.put(account.id,frmContract);
        mapAccountIds.put(account.id,mberContract);
        mapAccountIds.put(account.id,mberContract1);    
        
        List<id> lstIds = new List<id>();
        for(ID c :mapAccountIds.keySet()) {
            lstIds.add(c);
        }
        contractSyncUtil.updateContracts(lstIds);
        test.stopTest();
        
    }
    
}