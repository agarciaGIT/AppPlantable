@isTest
public class OneWireJobServiceTest {

    public static String jobsJSON = '[{"City__c":"test","State__c":"test","Postal_Code__c":"test","Salary__c":"123123","Experience__c":"test","Company__c":"test","Job_Type__c":"test","Category__c":"test","Sponsored__c":"test","Title__c":"test","URL__c":"www.test.com","Reference_Number__c":"A000001","Description__c":"UPDATED VALUE","Published_Date__c":"Fri, 08 Jun 2018 04:00:00 GMT"},{"City__c":"test","State__c":"test","Postal_Code__c":"test","Salary__c":"123123","Experience__c":"test","Company__c":"test","Job_Type__c":"test","Category__c":"test","Sponsored__c":"test","Title__c":"test","URL__c":"www.test.com","Reference_Number__c":"A000007","Description__c":"test","Published_Date__c":"Fri, 08 Jun 2018 04:00:00 GMT"}] '; 
	public static String keysJSON = '["A000001", "A000007"]';
    public static String jobRecordTypeId = RecordTypeHelper.getRecordTypeId('Job__c', 'OneWire Jobs');
    
    @testSetup
    private static void setup(){
  
        List<Job__c> jobs = new List<Job__c>{
            new Job__c(
                Reference_Number__c = 'A000001',
                Description__c  = 'test',
                RecordTypeId = jobRecordTypeId
            ),
            new Job__c(
                Reference_Number__c = 'A000002',
                Description__c  = 'test',
                RecordTypeId = jobRecordTypeId
            ),           
            new Job__c(
                Reference_Number__c = 'A000003',
                Description__c  = 'test',
                RecordTypeId = jobRecordTypeId
            ),
            new Job__c(
                Reference_Number__c = 'A000004',
                Description__c  = 'test',
                RecordTypeId = jobRecordTypeId
            ),
            new Job__c(
                Reference_Number__c = 'A000005',
                Description__c  = 'test',
                RecordTypeId = jobRecordTypeId
            )
        };
            
        INSERT jobs;
        
    }
    
    @isTest
    private static void insertUpdateJobs (){
        
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/onewire/insert/jobs';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(jobsJSON);
        
        RestContext.request = req;
        RestContext.response = res;
        
        OneWireJobServiceInsertUpdate.doPost();
        
        Test.stopTest();
        
        System.assert(!([SELECT Id, Reference_Number__c FROM Job__c WHERE Reference_Number__c = 'A000007']).isEmpty());//RECORD WAS INSERTED
        System.assertEquals('UPDATED VALUE', [SELECT Id, Reference_Number__c, Description__c FROM Job__c WHERE Reference_Number__c = 'A000001' LIMIT 1].Description__c);//RECORD WAS UPDATED
        
    }
    
    @isTest
    private static void deleteJobs (){
  
        Test.startTest();
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        
        req.requestURI = '/onewire/delete/jobs';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(keysJSON);
        
        RestContext.request = req;
        RestContext.response = res;
        
        OneWireJobServiceDelete.doPost();
        
        Test.stopTest();
             
        System.assert( ([SELECT Id, Reference_Number__c FROM Job__c WHERE Reference_Number__c = 'A000005']).isEmpty());//RECORD WAS DELETED
        
    }
    
}