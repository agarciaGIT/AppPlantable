@isTest
public class HLRedirectController_test {
    static testMethod void unitTest_1(){
        //testData();
        test.startTest();  
        
        ApexPages.currentPage().getParameters().put('eBookType', 'FRM Exam Part I');
        HLRedirectController op = new HLRedirectController();
        op.ssoURL = 'http://www.google.com';
        op.redirect();
        
        
        test.stopTest();
        
    }


}