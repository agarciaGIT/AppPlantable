@isTest
public class FrmPart2ExtendEbookAccess_test {
    static Account account ;
    static Opportunity opportunity; 
    static Contract contract;
    static Contract frmContract;
    static Contract mberContract;
    static Exam_Attempt__c attempt;
    
    static Exam_Group__c objExamGrp;
    static Exam_Group__c objExamGrp1;
    static Exam__c exam;
    static Exam_Sites__c exmSite;
    static Site__c site;
    static Contact contact;
    static ChargentBase__Gateway__c chrgGtway;
    static Contract mberContract1;
    
    static void testData(){ 
        
        account = new Account(Name = 'test');
        insert account;

        opportunity = new Opportunity(amount = 123,Name = 'Test',Eligible_for_Membership_Extension__c = false,company__c = 'Payment', accountId = account.id,stageName = 'Closed',Program__c = 'Print' ,closedate = system.today()+ 15,Give_Ebook_for_Free__c = true,E_book_Type__c ='Frm part 2');        
        insert opportunity; 
        
                
    }
    
    
    static testMethod void unitTest_1(){
        testData();
        test.starttest();
        FrmPart2ExtendEbookAccess batch = new FrmPart2ExtendEbookAccess();
        database.executebatch(batch,1);
        test.stopTest();
        
        
    }
}