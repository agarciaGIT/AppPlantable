@IsTest
public class OneWireJobNewsletterGeneratorCtrlTest {

    @TestSetup
    private static void setup(){
        
        List<Job__c> jobs = new List<Job__c>{
            new Job__c(
                Category__c = 'Legal',
                City__c = 'Boston',
                Company__c = 'Test Co',
                Country__c = 'USA',
                Description__c = 'Lorem ispum delta alpha beta',
                Experience__c = '3 - 5 Years',
                Job_Type__c = 'Full Time',
                Postal_Code__c = '123123',
                Published_Date__c = Date.today(),
                Reference_Number__c = '123213',
                Salary__c = '$0.00-$0.00',
                Sponsored__c = 'Company Sponsor',
                State__c = 'Mass.',
                Title__c = 'Test Title',
                URL__c = 'www.google.com'      
            ),
            new Job__c(
                Category__c = 'Legal',
                City__c = 'Boston',
                Company__c = 'Test Co',
                Country__c = 'USA',
                Description__c = 'Lorem ispum delta alpha beta',
                Experience__c = '3 - 5 Years',
                Job_Type__c = 'Full Time',
                Postal_Code__c = '123123',
                Published_Date__c = Date.today(),
                Reference_Number__c = '234235',
                Salary__c = '$0.00-$0.00',
                Sponsored__c = 'Company Sponsor',
                State__c = 'Mass.',
                Title__c = 'Test Title',
                URL__c = 'www.google.com'      
            )
        };
            
        INSERT jobs;
        
        Content_Selector__c cs = new Content_Selector__c();
        cs.Name = 'Test List 01';
        cs.Application_Reference__c = 'OneWire Job Newsletter Generator';
        cs.Content_IDs__c = jobs[0].Id;
        
        INSERT cs;
        
    }
    
    @IsTest
    private static void doSelectRemoveSortUpSortDownSave(){
        
        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);  
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();    
        
        ctrl.metadataListId = [SELECT Id, Name, Application_Reference__c FROM Content_Selector__c WHERE Application_Reference__c = 'OneWire Job Newsletter Generator' LIMIT 1].Id;
        
        PageReference nextPageReference = ctrl.doOpen();
        
        Test.setCurrentPage(nextPageReference);
        
        OneWireJobNewsletterGeneratorCtrl nextPageCtrl = new OneWireJobNewsletterGeneratorCtrl();            
        
        nextPageCtrl.jobId = [SELECT Id FROM Job__c LIMIT 1].Id;
        
        nextPageCtrl.doSelect();
        
        nextPageCtrl.doRemove();
        
        nextPageCtrl.doSelect();
        
        nextPageCtrl.moveDn();
        
        nextPageCtrl.moveUp();
        
        nextPageCtrl.doSave();
        
        nextPageCtrl.doGenerateHTML();
        
    }
    
    @IsTest
    private static void doSOQLSearch(){

        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);  
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();    
        
        ctrl.metadataListId = [SELECT Id, Name, Application_Reference__c FROM Content_Selector__c WHERE Application_Reference__c = 'OneWire Job Newsletter Generator' LIMIT 1].Id;
        
        PageReference nextPageReference = ctrl.doOpen();
        
        Test.setCurrentPage(nextPageReference);
        
        OneWireJobNewsletterGeneratorCtrl nextPageCtrl = new OneWireJobNewsletterGeneratorCtrl();            
        
        nextPageCtrl.category = 'legal';
        
        nextPageCtrl.doSearch();
        
        nextPageCtrl.performActions();
        
    }
    
    @IsTest
    private static void doSOSLSearch(){

        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);  
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();    
        
        ctrl.metadataListId = [SELECT Id, Name, Application_Reference__c FROM Content_Selector__c WHERE Application_Reference__c = 'OneWire Job Newsletter Generator' LIMIT 1].Id;
        
        PageReference nextPageReference = ctrl.doOpen();
        
        Test.setCurrentPage(nextPageReference);
        
        OneWireJobNewsletterGeneratorCtrl nextPageCtrl = new OneWireJobNewsletterGeneratorCtrl();            
        
        nextPageCtrl.searchString = 'legal';
                
       
        
        nextPageCtrl.performActions();
        
    }
    
    @IsTest
    private static void paginateNext(){

        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);  
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();    
        
        ctrl.metadataListId = [SELECT Id, Name, Application_Reference__c FROM Content_Selector__c WHERE Application_Reference__c = 'OneWire Job Newsletter Generator' LIMIT 1].Id;
        
        PageReference nextPageReference = ctrl.doOpen();
        
        Test.setCurrentPage(nextPageReference);
        
        OneWireJobNewsletterGeneratorCtrl nextPageCtrl = new OneWireJobNewsletterGeneratorCtrl();            
        
        nextPageCtrl.next();
        
    }
    
    @IsTest
    private static void paginatePrev(){
        
        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);  
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();    
        
        ctrl.metadataListId = [SELECT Id, Name, Application_Reference__c FROM Content_Selector__c WHERE Application_Reference__c = 'OneWire Job Newsletter Generator' LIMIT 1].Id;
        
        PageReference nextPageReference = ctrl.doOpen();
        
        Test.setCurrentPage(nextPageReference);
        
        OneWireJobNewsletterGeneratorCtrl nextPageCtrl = new OneWireJobNewsletterGeneratorCtrl();            
        
        nextPageCtrl.prev();
        
    }
    
    @IsTest
    private static void openExistingList(){
        
        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();        
        
        ctrl.metadataListId = [SELECT Id, Name, Application_Reference__c FROM Content_Selector__c WHERE Application_Reference__c = 'OneWire Job Newsletter Generator' LIMIT 1].Id;
        
        PageReference nextPageReference = ctrl.doOpen();
                      
        Test.setCurrentPage(nextPageReference);
        
        OneWireJobNewsletterGeneratorCtrl nextPageCtrl = new OneWireJobNewsletterGeneratorCtrl();     
        
    }
    
    @IsTest
    private static void createNewListWithNullName(){
        
        PageReference ref = Page.OneWireJobNewsletterGenerator;
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();        

        ctrl.doSaveAs();
      
        System.assert(ApexPages.getMessages().size() > 0);

    }
    
    @IsTest
    private static void createNewListWithDuplicateName(){
        
        PageReference ref = Page.OneWireJobNewsletterGenerator;
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();        
        
        ctrl.metadataListName = 'Test List 01';
        ctrl.doSaveAs();
              
        System.assert(ApexPages.getMessages().size() > 0);
        
    }
    
    @IsTest
    private static void createNewList(){
        
        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();        
        
        ctrl.metadataListName = 'Test List 02';
        
        PageReference nextPageReference = ctrl.doSaveAs();
              
        System.assertEquals([SELECT Id, Name FROM Content_Selector__c WHERE Name = 'Test List 02' LIMIT 1].Name, 'Test List 02');
        
        Test.setCurrentPage(nextPageReference);
        
        OneWireJobNewsletterGeneratorCtrl nextPageCtrl = new OneWireJobNewsletterGeneratorCtrl(); 
        
        nextPageCtrl.doDelete();
        
    }

    @IsTest
    private static void doNew(){
        
        PageReference currentPageRef = Page.OneWireJobNewsletterGenerator;
        
        Test.setCurrentPage(currentPageRef);
        
        OneWireJobNewsletterGeneratorCtrl ctrl = new OneWireJobNewsletterGeneratorCtrl();        
        
        ctrl.doNew();
        
    }
    
}