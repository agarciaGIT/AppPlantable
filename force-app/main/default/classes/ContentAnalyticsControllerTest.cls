@isTest
public class ContentAnalyticsControllerTest {

    public static Content__c contentWithViewCounts;
    public static Content__c contentWithoutViewCounts;
    
	public static Contact contactWithContentViewed;
	public static Contact contactWithoutContentViewed;
    
    public static void setup(){
        
        contentWithoutViewCounts = new Content__c();   
        contentWithoutViewCounts.Topic__c = 'TESTTOPIC';
        contentWithoutViewCounts.Content_Type__c = 'TESTCONTENTTYPE';
        contentWithoutViewCounts.Status__c = 'Active';
        INSERT contentWithoutViewCounts;
        
        contentWithViewCounts = new Content__c();   
        contentWithViewCounts.Topic__c = 'TESTTOPIC';
        contentWithViewCounts.Content_Type__c = 'TESTCONTENTTYPE';
        contentWithViewCounts.Status__c = 'Active';
        contentWithViewCounts.View_Count__c = 10;
        contentWithViewCounts.Bucket1__c = 10;
        contentWithViewCounts.Bucket2__c = 200;
        INSERT contentWithViewCounts;
        
        contactWithContentViewed = new Contact();
        contactWithContentViewed.FirstName = 'TESTFIRSTNAME';
        contactWithContentViewed.LastName = 'LASTFIRSTNAME';
        contactWithContentViewed.Email = 'TEST@TEST.com';
        contactWithContentViewed.Content_Types_Viewed__c = 'TESTCONTENTTYPE';
        contactWithContentViewed.Content_Topics_Viewed__c = 'TESTTOPIC';
        contactWithContentViewed.Content_Viewed__c = contentWithViewCounts.Id;
        INSERT contactWithContentViewed;
        
        contactWithoutContentViewed = new Contact();
        contactWithoutContentViewed.FirstName = 'TESTFIRSTNAME';
        contactWithoutContentViewed.LastName = 'LASTFIRSTNAME';
        contactWithoutContentViewed.Email = 'TEST@TEST.com';
        INSERT contactWithoutContentViewed;
                
    }
       
    @isTest
    public static void unitTest1(){
             
        setup();
        
        Test.startTest();
        
        Test.setCurrentPage(Page.ContentAnalytics);
        
        System.currentPageReference().getParameters().put('contentId', contentWithViewCounts.Id);
        System.currentPageReference().getParameters().put('contactId', contactWithContentViewed.Id);
        
        ContentAnalyticsController ctrl = new ContentAnalyticsController();
        
        ContentAnalyticsController.doContentAnalytics();
        
        Test.stopTest();     	
        
    }  
    
    @isTest
    public static void unitTest2(){
             
        setup();
        
        Test.startTest();
        
        Test.setCurrentPage(Page.ContentAnalytics);
        
        System.currentPageReference().getParameters().put('contentId', contentWithViewCounts.Id);
        System.currentPageReference().getParameters().put('contactId', contactWithoutContentViewed.Id);
        
        ContentAnalyticsController ctrl = new ContentAnalyticsController();
        
        ContentAnalyticsController.doContentAnalytics();
        
        Test.stopTest();     	
        
    }  
    
    @isTest
    public static void unitTest3(){
             
        setup();
        
        Test.startTest();
        
        Test.setCurrentPage(Page.ContentAnalytics);
        
        System.currentPageReference().getParameters().put('contentId', contentWithoutViewCounts.Id);
        System.currentPageReference().getParameters().put('contactId', contactWithContentViewed.Id);
        
        ContentAnalyticsController ctrl = new ContentAnalyticsController();
        
        ContentAnalyticsController.doContentAnalytics();
        
        Test.stopTest();     	
        
    }  
    
    @isTest
    public static void unitTest4(){
             
        setup();
        
        Test.startTest();
        
        Test.setCurrentPage(Page.ContentAnalytics);
        
        System.currentPageReference().getParameters().put('contentId', contentWithoutViewCounts.Id);
        System.currentPageReference().getParameters().put('contactId', contactWithoutContentViewed.Id);
        
        ContentAnalyticsController ctrl = new ContentAnalyticsController();
        
        ContentAnalyticsController.doContentAnalytics();
        
        Test.stopTest();     	
        
    }  
    
    @isTest
    public static void unitTest5(){
             
        setup();
        
        Test.startTest();
        
        Test.setCurrentPage(Page.ContentAnalytics);
        
        System.currentPageReference().getParameters().put('contentId', contentWithViewCounts.Id);
        
        ContentAnalyticsController ctrl = new ContentAnalyticsController();
        
        ContentAnalyticsController.doContentAnalytics();
        
        Test.stopTest();     	
        
    }  
    
    @isTest
    public static void unitTest6(){
             
        setup();
        
        Test.startTest();
        
        Test.setCurrentPage(Page.ContentAnalytics);
        
        System.currentPageReference().getParameters().put('contentId', contentWithoutViewCounts.Id);
        
        ContentAnalyticsController ctrl = new ContentAnalyticsController();
        
        ContentAnalyticsController.doContentAnalytics();
        
        Test.stopTest();     	
        
    }  
        
}