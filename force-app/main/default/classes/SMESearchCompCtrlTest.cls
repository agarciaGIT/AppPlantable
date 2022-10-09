@isTest
private class SMESearchCompCtrlTest {
    
    @isTest
    private static void testSearch() {
        SME_Registration__c smeProf = new SME_Registration__c(First_Name__c = 'Apex', Last_Name__c = 'Test', Email__c = 'apexTest@sample.com');
        insert smeProf;
        
        Test.startTest();
        SMESearchCompCtrl.searchSMEProfile('Oil;Regulation', 'category', 'United States', new List<String>{'garp', 'system', 'self'});
        SMESearchCompCtrl.searchSMEProfile('Oil,Regulation', 'category', 'United States', new List<String>{'garp', 'system', 'self'});
        SMESearchCompCtrl.searchSMEProfile('Apex', 'name', 'United States', new List<String>{'garp', 'system', 'self'});
        
        List<SMESearchCompCtrl.SearchFilter> filters = new List<SMESearchCompCtrl.SearchFilter>();
        SMESearchCompCtrl.SearchFilter filter1 = new SMESearchCompCtrl.SearchFilter();
        filter1.field = 'Credit Risk';
        filter1.filter = 'INCLUDES';
        filter1.value = new List<String>{'Capital'};
        SMESearchCompCtrl.SearchFilter filter2 = new SMESearchCompCtrl.SearchFilter();
        filter2.field = 'Energy';
        filter2.filter = 'EXCLUDES';
        filter2.value = new List<String>{'Oil'};
        filters.add(filter1);
        filters.add(filter2);
        
        SMESearchCompCtrl.filterSearchSME(filters, 'Test', 'United States', new List<String>{'garp', 'system', 'self'});
        
        SMESearchCompCtrl.fetchSMEDetail(smeProf.Id);
        Test.stopTest();
    }

    @isTest
    private static void testHelperMethods() {
        Country_Code__c cc = new Country_Code__c(Country__c = 'United States');
        insert cc;
        
        Test.startTest();
        SMESearchCompCtrl.fetchPicklistValues('Credit Risk', new String[]{'garp','system'});
        
        SMESearchCompCtrl.fetchCountries();
        
        SMESearchCompCtrl.getCountryNames('United Kingdom');
        SMESearchCompCtrl.getCountryNames('China');
        Test.stopTest();
    }
}