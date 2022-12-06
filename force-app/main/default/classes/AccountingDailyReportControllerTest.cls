@isTest
public class AccountingDailyReportControllerTest {

    public static void setup(){
        
        Order_Transaction_Item_Map__c orderTransMap1 = new Order_Transaction_Item_Map__c(
            Name = 'FRM1', 
            Company__c = 'GARP', 
            Field_Name__c = 'PROD_FRM1_4007__c', 
            GL_Code__c = '4007', 
            Is_Shipping__c = False, 
            Product_Code__c = 'FRM1', 
            Sort_Order__c = 1, 
            Source_GL_Codes__c = '4007', 
            Source_Product_Codes__c = 'FRM1'
        );
        insert orderTransMap1;
        
        Order_Transaction_Item__c orderTransItem = new Order_Transaction_Item__c(
        	Company__c = 'GARP', 
            Transaction_Type__c = 'Charge', 
            Total_Amount__c = 100, 
            Invoice_Number__c = 'w01', 
            GARP_ID__c = '1234', 
            First_Name__c = 'FN',
            Last_Name__c = 'LN', 
            Country__c = 'USA', 
            State__c = 'NJ', 
            Exam_Site__c = 'Site', 
            Payment_Method__c = 'Credit Card', 
            Paid_Date_Time__c = DateTime.now(), 
            Gateway_ID__c = '123',
            Status__c = ' Approved'
        );
    }
    
    static testMethod void unitTest(){
        setup();
        test.startTest();

       	AccountingDailyReportLightningController adrlc = new AccountingDailyReportLightningController();
        adrlc.startDate = Date.newInstance(2021, 5, 1);
        adrlc.endDate = Date.newInstance(2021, 6, 1);
        adrlc.filter_garp = TRUE;
        adrlc.filter_gra = TRUE;
        adrlc.filter_nj = TRUE;
        adrlc.filter_charge = TRUE;
        adrlc.filter_refund = TRUE;
        adrlc.filter_debit = TRUE;
        adrlc.filter_credit = TRUE;
        adrlc.filter_cba = TRUE;
        adrlc.filter_cbl = TRUE;
        adrlc.filter_cc = TRUE;
        adrlc.filter_ccfax = TRUE;
        adrlc.filter_wire = TRUE;
        adrlc.filter_check = TRUE;
        adrlc.filter_ach = TRUE;
        adrlc.filter_free = TRUE;
        adrlc.pageNumber = 1;
        adrlc.pageSize = 100;
        adrlc.totalSize = 1;
        
        AccountingDailyReportLightningController.getOrderTransactions(adrlc,true);
        AccountingDailyReportLightningController.approveAllRowItems(adrlc);
        AccountingDailyReportLightningController.approveSelectedRows(adrlc);
        AccountingDailyReportLightningController.initClass();
        
        
        
        test.stopTest();
    }
}