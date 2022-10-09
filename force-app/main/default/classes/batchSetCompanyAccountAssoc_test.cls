@isTest
public class batchSetCompanyAccountAssoc_test{
    
    @testSetup
    private static void setup(){
        
        List<Account> businessAccounts = new List<Account>{
            new Account(
                Name = 'AB Corp',
                Alt_Company_Name__c = '\nabcorp\nalphabetacorp\nabcorporation\nalphabeta',
                RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Business')
            ),
            new Account(
                Name = 'DZ Inc.',
                Alt_Company_Name__c = '\ndz\ndzinc\ndzincorporated\ndeltazetaincorporated',
                RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Business')
            ),
            new Account(
                Name = 'NO MATCH',
                Alt_Company_Name__c = '\ndz\ndzinc\ndzincorporated\ndeltazetaincorporated',
                RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Business')
            ) 
        };                    
        INSERT businessAccounts;  
        
    }
    
    @isTest
    private static void testCron(){
        
        Test.startTest();    
        
        Account account = new Account(
            Name = 'TestUserAccount'
        );
        INSERT account;
        
        Contact contact = new Contact(
            LastName = 'TestUserContact', 
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member'),
            AccountId = account.Id,
            Email ='valid@user.com', 
            Company__c = 'Alpha Beta Corp', 
            Company_Account__c = null,
            KPI_FRM_Certified__c = true
        );
        INSERT contact; 
        
        batchSetCompanyAccountAssocSchedule scheduled = new batchSetCompanyAccountAssocSchedule();
        System.schedule('Test Schedule','0 0 0 * * ?', scheduled);        
        
        Test.stopTest();       
        
    }
    
    @isTest
    private static void testBatch(){
        
        Test.startTest();    
        
        Account account = new Account(
            Name = 'TestUserAccount'
        );
        INSERT account;
        
        Contact contact = new Contact(
            LastName = 'TestUserContact', 
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member'),
            AccountId = account.Id,
            Email ='valid@user.com', 
            Company__c = 'Alpha Beta Corp', 
            Company_Account__c = null,
            KPI_FRM_Certified__c = true
        );
        INSERT contact; 
        
        batchSetCompanyAccountAssoc batch = new batchSetCompanyAccountAssoc('join',null);
        Database.executeBatch(batch);

        batchSetCompanyAccountAssoc batch1 = new batchSetCompanyAccountAssoc('join',String.valueOf(contact.Id));
        Database.executeBatch(batch1);
        
        batchSetCompanyAccountAssoc batch2 = new batchSetCompanyAccountAssoc('joinreg2016',null);
        Database.executeBatch(batch2);
        
            
        Test.stopTest();
        
        System.assertEquals([SELECT Id, Name FROM Account WHERE Name = 'AB Corp' LIMIT 1].Id, [SELECT Id, Name, Company_Account__c FROM Contact WHERE Id = :contact.Id LIMIT 1].Company_Account__c);        
        
    }
    
    @isTest
    private static void testBatch2(){
        
        Test.startTest();    
        
        Account account = new Account(
            Name = 'TestUserAccount',
            KPI_Employee_Total_Count__c = null
        );
        INSERT account;

        Account account1 = new Account(
            Name = 'TestUserAccount',
            KPI_Employee_Total_Count__c = 1
        );
        INSERT account1;
        
        Contact contact = new Contact(
            LastName = 'TestUserContact', 
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member'),
            AccountId = account.Id,
            Email ='valid@user.com', 
            Company__c = 'Alpha Beta Corp', 
            Company_Account__c = account.Id,
            KPI_FRM_Certified__c = true,
            KPI_Last_Exam_Registration__c = 'FRM 2016',
            Company_Association_Processed__c = true
        );
        INSERT contact; 
        
        batchSetCompanyAccountAssoc batch2 = new batchSetCompanyAccountAssoc('acctcount',null);
        Database.executeBatch(batch2);

        batchSetCompanyAccountAssoc batch3 = new batchSetCompanyAccountAssoc('acctdelete',null);
        Database.executeBatch(batch3);
        
        batchSetCompanyAccountAssoc batch = new batchSetCompanyAccountAssoc('delete',null);
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        //System.assertEquals([SELECT Id, Name FROM Account WHERE Name = 'AB Corp' LIMIT 1].Id, [SELECT Id, Name, Company_Account__c FROM Contact WHERE Id = :contact.Id LIMIT 1].Company_Account__c);        
        
    }    
       
}