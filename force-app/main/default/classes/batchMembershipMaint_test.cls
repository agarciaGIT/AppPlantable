@isTest
public class batchMembershipMaint_test {
    
    Static Reporting_Snapshot_Membership__c snap;

    public static void setup(){
        snap = new Reporting_Snapshot_Membership__c(Year__c=2017, Member_Type_Description__c='xx', Country__c='abc');
		insert snap;
    }
    
    @isTest
    private static void testBatch(){
        
        setup();
        Test.startTest();    
                
        batchMembershipMaint batch = new batchMembershipMaint(2017,null);
        Database.executeBatch(batch);

        Test.stopTest();        
    }
    
}