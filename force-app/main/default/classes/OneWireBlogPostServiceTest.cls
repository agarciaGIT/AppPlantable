@isTest
public class OneWireBlogPostServiceTest{

    @testSetup
    public static void setup(){
    
        String contentBlogPostRecordTypeId = RecordTypeHelper.getRecordTypeId('Content__c', 'Blog Post');
        
        List<Content__c> contents = new List<Content__c>{
            new Content__c( 
                RecordTypeId = contentBlogPostRecordTypeId,
                Media_Type__c = 'OneWire Blog Posts',
                External_ID__c = '48591',
                Name = 'test1'
            ),
            new Content__c( 
                RecordTypeId = contentBlogPostRecordTypeId,
                Media_Type__c = 'OneWire Blog Posts',
                External_ID__c = '98531',
                Name = 'test2' 
            )
        };
        
        INSERT contents;
        
    }
    
    @isTest
    public static void request(){
    
    	Test.setMock(HttpCalloutMock.class, new OneWireBlogPostServiceMockHttpCallout());
        
        Test.startTest();
        OneWireBlogPostService.retrieveOneWireBlogPosts();
        Test.stopTest();    
        
    }
    
    
}