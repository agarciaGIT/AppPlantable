@isTest
public class batchDeDupeLeads_test {

    static void testData(){ 
        Lead l = new Lead(Company='Bob', LastName='Frank',Email='a@a.com');
        insert l;
        
        Form_Data__c fd = new Form_Data__c(Email__c = 'a@a.com', Lead__c = l.id);
        insert fd;

        Contact c = new Contact(FirstName='Bob', LastName='Frank', Email='a@a.com');
        insert c;
    }
    
    static testMethod void unitTest_1(){   
        
        testdata();
        test.startTest();
        batchDeDupeLeads b = new batchDeDupeLeads(null);
        database.executeBatch(b);
        
        scheduleBatchDeDupeLeads s1= new scheduleBatchDeDupeLeads();
        system.schedule('Test Schedule','0 0 0 * * ?',s1);
        
        test.stopTest();
        
    }
    
}