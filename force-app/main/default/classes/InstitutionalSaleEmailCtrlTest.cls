// 07/01/2019 Xiang - No longer use ConnectApi, don't need SeeAllData any more.
// System.UnsupportedOperationException: ConnectApi methods are not supported in data siloed tests. Please use @IsTest(SeeAllData=true).
@IsTest
private class InstitutionalSaleEmailCtrlTest {

    @isTest private static void testMainFlow() {
        User u = TestingHelper.createUser('Accounting', 'xlt_sales@person.com', true);
        Opportunity tstOppty = TestingHelper.createInstSaleOppty('Apex Test Oppty', 'GARP', false, false);
        tstOppty.GARP_Sales_Contact__c = u.Id;
        tstOppty.Inst_Sale_Billing_Email__c = 'exampletstUsr@gmail.com';
        tstOppty.Inst_Sale_Attention__c = 'Example User';
        insert tstOppty;

        Test.startTest();
        System.runAs(u) {
            tstOppty.Institutional_Sale_Stage__c = 'Approved';
            update tstOppty;
            
            tstOppty.StageName = 'Closed Lost';
            update tstOppty;
        }

        try {
            InstitutionalSaleEmailCtrl.getPdfAttach(tstOppty.Id, 'TestDownload');
        }catch(Exception e) {
            System.debug(e);
        }
		
        Boolean sendMail = InstitutionalSaleEmailCtrl.sendInstEmail;
        
        InstitutionalSaleEmailCtrl.processResults(new List<Messaging.SendEmailResult>(), 'testMainFlow');
        Test.stopTest();
    }
	
    @isTest private static void testReject() {
        User u = TestingHelper.createUser('Accounting', 'xlt_sales@person.com', true);
        Opportunity tstOppty = TestingHelper.createInstSaleOppty('Apex Test Oppty', 'GARP', false, false);
        tstOppty.GARP_Sales_Contact__c = u.Id;
        tstOppty.Inst_Sale_Billing_Email__c = 'exampletstUsr@gmail.com';
        tstOppty.Inst_Sale_Attention__c = 'Example User';
        insert tstOppty;
        
        Test.startTest();
        System.runAs(u) {
            tstOppty.Institutional_Sale_Stage__c = 'Rejected';
            update tstOppty;
        }
        Test.stopTest();
    }
}