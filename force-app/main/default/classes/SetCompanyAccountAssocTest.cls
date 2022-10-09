@isTest
public class SetCompanyAccountAssocTest{
    
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
        
        SetCompanyAccountAssocScheduleBatch scheduled = new SetCompanyAccountAssocScheduleBatch();
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
        
        SetCompanyAccountAssocBatch batch = new SetCompanyAccountAssocBatch('frm');
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        System.assertEquals([SELECT Id, Name FROM Account WHERE Name = 'AB Corp' LIMIT 1].Id, [SELECT Id, Name, Company_Account__c FROM Contact WHERE Id = :contact.Id LIMIT 1].Company_Account__c);        
        
    }
    
    @isTest
    private static void testBatch2(){
        
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
            KPI_FRM_Certified__c = true,
            Company_Association_Processed__c = true
        );
        INSERT contact; 
        
        SetCompanyAccountAssocBatch batch = new SetCompanyAccountAssocBatch('delete');
        Database.executeBatch(batch);
        
        Test.stopTest();
        
        //System.assertEquals([SELECT Id, Name FROM Account WHERE Name = 'AB Corp' LIMIT 1].Id, [SELECT Id, Name, Company_Account__c FROM Contact WHERE Id = :contact.Id LIMIT 1].Company_Account__c);        
        
    }    
       
}