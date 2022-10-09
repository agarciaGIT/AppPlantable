@isTest
private class pardotClass_test {
    
    Private static testMethod void myUnitTest_1(){
        
        test.starttest();

        Pardot_API_Config__c pc1 = new Pardot_API_Config__c(Name='AuthEmail', Value__c='garcia.alberto.crespo@gmail.com');
        insert pc1;
        Pardot_API_Config__c pc2 = new Pardot_API_Config__c(Name='AuthPassword', Value__c='Pardot#w77$');
        insert pc2;
        Pardot_API_Config__c pc3 = new Pardot_API_Config__c(Name='AuthUserKey', Value__c='61d8199c1ead02d8ae02eecc49634656');
        insert pc3;
        Pardot_API_Config__c pc4 = new Pardot_API_Config__c(Name='LoginEndPoint', Value__c='https://pi.pardot.com/api/login/version/3');
        insert pc4;
        Pardot_API_Config__c pc5 = new Pardot_API_Config__c(Name='ProspectUpdateEndPoint', Value__c='https://pi.pardot.com/api/prospect/version/3/do/update/email');
        insert pc5;
            
        pardotClass.optInUser('garcia.alberto.crespo@gmail.com');
 		test.stoptest();
    }

}