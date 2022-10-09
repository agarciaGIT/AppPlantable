@isTest 
public class getEmailDuplicateLeadsTest {
    public static testmethod void testduplicateleads(){
        List<Lead> leadList = new  List<Lead>(); 
        Lead ld = new Lead();
        ld.Company = 'Test Company';
        ld.LastName = 'Test LastName';
        ld.FirstName = 'Test FirstName';
        ld.Email = 'test@test.com';
        leadList.add(ld);
        Lead ld1 = new Lead();
        ld1.Company = 'Test Company1';
        ld1.LastName = 'Test LastName1';
        ld1.FirstName = 'Test FirstName1';
        ld1.Email = 'test@test1.com';
        leadList.add(ld1);
        
        insert leadList;
        test.startTest(); 
        getEmailDuplicateLeads batchable = new getEmailDuplicateLeads();
        database.executeBatch(batchable);
        test.stopTest();
    }
}