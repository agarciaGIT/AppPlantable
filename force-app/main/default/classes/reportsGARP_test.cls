@isTest
private class reportsGARP_test{
    
    static Product2 prod;
    static Product2 prod1;
    static Product2 prod2;
    static Product2 prod3;

    static testMethod void myUnitTest_3() {
        insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU'); 
        // a1lf000000045VS a0A4000000uA1fU 
        Account acc = new Account(name='Test Account');
        insert acc;
        
        Team_Registration__c tr = new Team_Registration__c(Name='Team');
        insert tr;
        
        Opportunity opp = new Opportunity(accountId = acc.id,Team_Registration__c =tr.Id, Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring Intent',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='Closed',CloseDate=system.today(),ChargentSFA__Charge_Amount__c=95);
        insert opp;
        
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;
        
        Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com');
        insert ct;
        
        Product_Refunds__c pr = new Product_Refunds__c(Opportunity__c=opp.Id,Payment_Transaction__c=obj.Id);
        insert pr;
        
        
        prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        prod3 = new Product2(Name = 'For Testing RestoreAMPFree',productCode = 'PRFEE',GL_Code__c = '6110',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry Entry1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert Entry1;
        
        PricebookEntry Entry2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert Entry2;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice; 
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice.id, Quantity=1, TotalPrice =50);
        insert lineItem;
        
        Date start1Date = System.today(); //.addDays(-5);
        Date end1Date = System.today(); //addDays(2);
        
        datetime start1DateTime = datetime.newInstance(start1Date.year(), start1Date.month(),start1Date.day());
        datetime end1DateTime = datetime.newInstance(end1Date.year(), end1Date.month(),end1Date.day());
        
        Long startDateLong = start1DateTime.getTime() /1000;
        Long endDateLong = end1DateTime.getTime() /1000;
        
        String startDate = String.valueOf(startDateLong);
        String endDate = String.valueOf(endDateLong);
        
        Deployment__c lstDply = new Deployment__c(Name='Dply', Target_Deployment_Date__c=start1Date, Target_Deployment_Time__c=null, Type__c='Email');
        insert lstDply;
        
        
        List<String> productIds = new List<String>();
        String prodId = String.valueOf(prod1.Id);
        productIds.add(prodId);
        
        
        test.startTest();
        
        
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, True, False, False,productIds,true);        
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, False, True, productIds,true);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, True, True, productIds,true);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, True, False, productIds,true);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, True, False, True, productIds,true);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, False, False, productIds,true);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, True, True, True, productIds,true);
        
        reportsGARP.getReportDataOppFilters(startDate,endDate, True, False, False,productIds,true);        
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, False, True, productIds,true);
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, True, True, productIds,true);
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, True, False, productIds,true);
        reportsGARP.getReportDataOppFilters(startDate,endDate, True, False, True, productIds,true);
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, False, False, productIds,true);
        
        reportsGARP.getReportDataTransFilters(startDate,endDate, True, False, False,productIds,true);        
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, False, True, productIds,true);
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, True, True, productIds,true);
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, True, False, productIds,true);
        reportsGARP.getReportDataTransFilters(startDate,endDate, True, False, True, productIds,true);
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, False, False, productIds,true);
        
        test.stopTest();
        
    }

    
    static testMethod void myUnitTest_2() {
        insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU'); 
        // a1lf000000045VS a0A4000000uA1fU 
        Account acc = new Account(name='Test Account');
        insert acc;
        
        Team_Registration__c tr = new Team_Registration__c(Name='Team');
        insert tr;
        
        Opportunity opp = new Opportunity(accountId = acc.id,Team_Registration__c =tr.Id, Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring Intent',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='Closed',CloseDate=system.today(),ChargentSFA__Charge_Amount__c=95);
        insert opp;
        
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;
        
        Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com');
        insert ct;
        
        Product_Refunds__c pr = new Product_Refunds__c(Opportunity__c=opp.Id,Payment_Transaction__c=obj.Id);
        insert pr;
        
        
        prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        prod3 = new Product2(Name = 'For Testing RestoreAMPFree',productCode = 'PRFEE',GL_Code__c = '6110',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry Entry1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert Entry1;
        
        PricebookEntry Entry2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert Entry2;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice; 
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice.id, Quantity=1, TotalPrice =50);
        insert lineItem;
        
        Date start1Date = System.today(); //.addDays(-5);
        Date end1Date = System.today(); //addDays(2);
        
        datetime start1DateTime = datetime.newInstance(start1Date.year(), start1Date.month(),start1Date.day());
        datetime end1DateTime = datetime.newInstance(end1Date.year(), end1Date.month(),end1Date.day());
        
        Long startDateLong = start1DateTime.getTime() /1000;
        Long endDateLong = end1DateTime.getTime() /1000;
        
        String startDate = String.valueOf(startDateLong);
        String endDate = String.valueOf(endDateLong);
        
        Deployment__c lstDply = new Deployment__c(Name='Dply', Target_Deployment_Date__c=start1Date, Target_Deployment_Time__c=null, Type__c='Email');
        insert lstDply;
        
        
        List<String> productIds = new List<String>();
        String prodId = String.valueOf(prod1.Id);
        productIds.add(prodId);
        
        
        test.startTest();
        
        reportsGARP.getReportData(startDate,endDate, True, True, False);
        reportsGARP.getReportDataTrans(startDate,endDate, True, True, False);
        reportsGARP.getReportDataOpp(startDate,endDate, True, True, False);
        reportsGARP.getReportDataRefunds(startDate,endDate, True, True, False);
        
        reportsGARP.getReportDataOpp(startDate,endDate, False, False, False);
        reportsGARP.getReportDataOpp(startDate,endDate, False, True, False);
        reportsGARP.getReportDataOpp(startDate,endDate, False, False, True);
        reportsGARP.getReportDataOpp(startDate,endDate, False, True, True);
        
        reportsGARP.getReportDataTrans(startDate,endDate, False, False, False);
        reportsGARP.getReportDataTrans(startDate,endDate, False, True, False);
        reportsGARP.getReportDataTrans(startDate,endDate, False, False, True);
        reportsGARP.getReportDataTrans(startDate,endDate, False, True, True);
        
        
        reportsGARP.getReportData(startDate,endDate, True, False, True);
        reportsGARP.getReportDataTrans(startDate,endDate, True, False, True);
        reportsGARP.getReportDataOpp(startDate,endDate, True, False, True);
        reportsGARP.getReportDataRefunds(startDate,endDate, True, False, True);
        
        reportsGARP.getReportData(startDate,endDate, False, False, False);
        reportsGARP.getReportData(startDate,endDate, False, True, False);
        reportsGARP.getReportData(startDate,endDate, False, False, True);
        reportsGARP.getReportData(startDate,endDate, False, True, True);
        
        reportsGARP.getReportData(startDate,endDate, True, True, False);
        reportsGARP.getReportDataTrans(startDate,endDate, True, True, False);
        reportsGARP.getReportDataOpp(startDate,endDate, True, True, False);
        reportsGARP.getReportDataRefunds(startDate,endDate, True, True, False);
        
        reportsGARP.getRefunds(startDate,endDate);
        reportsGARP.getProducts('01sf00000008rTn');
        
        
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, True, False, False,productIds,false);        
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, False, True, productIds,false);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, True, True, productIds,false);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, True, False, productIds,false);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, True, False, True, productIds,false);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, False, False, False, productIds,false);
        reportsGARP.getReportDataRefundsFilters(startDate,endDate, True, True, True, productIds,false);
        
        reportsGARP.getReportDataOppFilters(startDate,endDate, True, False, False,productIds,false);        
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, False, True, productIds,false);
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, True, True, productIds,false);
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, True, False, productIds,false);
        reportsGARP.getReportDataOppFilters(startDate,endDate, True, False, True, productIds,false);
        reportsGARP.getReportDataOppFilters(startDate,endDate, False, False, False, productIds,false);
        reportsGARP.getReportDataOppFilters(startDate,endDate, True, True, True, productIds,false);
        
        reportsGARP.getReportDataTransFilters(startDate,endDate, True, False, False,productIds,false);        
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, False, True, productIds,false);
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, True, True, productIds,false);
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, True, False, productIds,false);
        reportsGARP.getReportDataTransFilters(startDate,endDate, True, False, True, productIds,false);
        reportsGARP.getReportDataTransFilters(startDate,endDate, False, False, False, productIds,false);
        reportsGARP.getReportDataTransFilters(startDate,endDate, True, True, True, productIds,false);
        
        
        reportsGARP.getDeploymentData(start1Date.month(), start1Date.year());
        reportsGARP.getDeploymentData(-1, start1Date.year());
        reportsGARP.getDeploymentData(start1Date.month(), -1);
        //reportsGARP.getDeploymentData(-1, -1);        
        
        test.stopTest();
        
    }
    
    static testMethod void myUnitTest_1() {
        
        //RecordType rt = [select id from RecordType where SobjectType='Opportunity' and IsActive=true limit 1];
        //insert rt;
        insert new Updateids__c(Name='GARP',Record_id__c = 'a0A4000000uA1fU'); 
        // a1lf000000045VS a0A4000000uA1fU 
        Account acc = new Account(name='Test Account');
        insert acc;
        
        Opportunity opp = new Opportunity(accountId = acc.id,Auto_Renew__c = true,ChargentSFA__Payment_Status__c='Recurring Intent',Company__c = 'GARP',ChargentSFA__Payment_Frequency__c='Once',name='Test Name',StageName='Closed',CloseDate=system.today(),ChargentSFA__Charge_Amount__c=95);
        insert opp;
        
        ChargentSFA__Transaction__c obj = new ChargentSFA__Transaction__c(ChargentSFA__Opportunity__c=opp.Id,ChargentSFA__Type__c='Charge',ChargentSFA__Response_Status__c='Approved');
        insert obj;
        
        Contact ct = new Contact(firstName='Fname',LastName='LName',KPI_FRM_Certified__c=true,accountId = acc.Id,Email='Test@Test.com');
        insert ct;
        
        Product_Refunds__c pr = new Product_Refunds__c(Opportunity__c=opp.Id,Payment_Transaction__c=obj.Id);
        insert pr;
        
        
        prod = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod;
        
        prod1 = new Product2(Name = 'Laptop X200',productCode = 'AFREE',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod1;
        
        prod2 = new Product2(Name = 'Laptop X200',productCode = 'FRM1S',GL_Code__c = '4999',Family = 'Hardware',isActive = true);
        insert prod2; 
        
        prod3 = new Product2(Name = 'For Testing RestoreAMPFree',productCode = 'PRFEE',GL_Code__c = '6110',Family = 'Hardware',isActive = true);
        insert prod3;
        
        Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice;
        PricebookEntry standardPrice1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod1.Id,UnitPrice = 10000, IsActive = true);
        insert standardPrice1;
        
        Pricebook2 customPB = new Pricebook2(Name='Custom Pricebook', isActive=true);
        insert customPB;
        
        PricebookEntry Entry1 = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert Entry1;
        
        PricebookEntry Entry2 = new PricebookEntry(Pricebook2Id = customPB.Id, Product2Id = prod3.Id,UnitPrice = 10000, IsActive = true);
        insert Entry2;
        
        PricebookEntry customPrice = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice; 
        
        PricebookEntry customPrice1 = new PricebookEntry( Pricebook2Id = customPB.Id, Product2Id = prod1.Id, UnitPrice = 12000, IsActive = true);
        insert customPrice1;
        
        OpportunityLineItem lineItem = new OpportunityLineItem(OpportunityId = opp.id,PricebookEntryId = customPrice.id, Quantity=1, TotalPrice =50);
        insert lineItem;
        
        Date start1Date = System.today(); //.addDays(-5);
        Date end1Date = System.today(); //addDays(2);
        
        datetime start1DateTime = datetime.newInstance(start1Date.year(), start1Date.month(),start1Date.day());
        datetime end1DateTime = datetime.newInstance(end1Date.year(), end1Date.month(),end1Date.day());
        
        Long startDateLong = start1DateTime.getTime() /1000;
        Long endDateLong = end1DateTime.getTime() /1000;
        
        String startDate = String.valueOf(startDateLong);
        String endDate = String.valueOf(endDateLong);
        
        Deployment__c lstDply = new Deployment__c(Name='Dply', Target_Deployment_Date__c=start1Date, Target_Deployment_Time__c=null, Type__c='Email');
        insert lstDply;
        
        
        List<String> productIds = new List<String>();
        String prodId = String.valueOf(prod1.Id);
        productIds.add(prodId);
        
        //Exam_Report_Settings__c settings = new Exam_Report_Settings__c(Name='Set', User__c=null, ReportID__c=Null, Display_Options_JSON__c='', Color_Options_JSON__c='', Chart_Options_JSON__c='');
        
        Initiative__c Init = new Initiative__c(Name='Proj1', Type__c = 'Ops', Target_Start_Date__c = 'Q1', Target_End_Date__c = 'Q1', Rank_In_End_Quarter__c=0);
        insert Init;
        
        test.startTest();
        
        reportsGARP rt = new reportsGARP();         
        
        reportsGARP.getReportData(startDate,endDate, True, False, False);
        
        reportsGARP.getReportDataTrans(startDate,endDate, True, False, False);
        reportsGARP.getReportDataOpp(startDate,endDate, True, False, False);
        reportsGARP.getReportDataRefunds(startDate,endDate, True, False, False);
        
        reportsGARP.getReportDataRefunds(startDate,endDate, False, False, False);
        reportsGARP.getReportDataRefunds(startDate,endDate, False, True, False);
        reportsGARP.getReportDataRefunds(startDate,endDate, False, False, True);
        reportsGARP.getReportDataRefunds(startDate,endDate, False, True, True);
        
        // New Things for Exam Reports
        reportsGARP.returnSettingsInfo rs = new reportsGARP.returnSettingsInfo();
        
        //reportsGARP.updateStats();
        reportsGARP.getSettings();
        
        reportsGARP.setSettings(NULL, NULL, 'Set1', '11111', '', '', '');
        //reportsGARP.setSettings(NULL, settings.Id, 'Set1', '11111', '', '', '');                                
        //reportsGARP.deleteSettings(settings.Id);
        
        reportsGARP.getInitiatives();
        reportsGARP.setInitiatives(Init.Id, 'Q2');
        reportsGARP.setInitiativesRank(Init.Id+'~1');
        
        reportsGARP.getExamSites();
        
        test.stopTest();        
    }
    
}