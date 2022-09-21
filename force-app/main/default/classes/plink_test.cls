@isTest 
public class plink_test {
    
 @isTest
    private static void test1(){
        Test.startTest();    
        
        plink ts = new plink();
        ts.pubType = '1';
        ts.redirect();
        ts.pubType = '2';
        ts.redirect();
        ts.pubType = '3';
        ts.redirect();
        ts.pubType = '4';
        ts.redirect();
        ts.pubType = '5';
        ts.redirect();
        
        Test.stopTest();        
    }    

}