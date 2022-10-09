@isTest
public class concontentupdateinsert_test{

    static testMethod void unitTest_1(){
        
        test.startTest();
        Content__c content = new Content__c();
        content.Content_Type__c = 'News Feed' ;
        content.Status__c = 'Draft' ;
        //content.Published_Date__c = system.today() ;
        content.Is_On_Demand__c = true;
        content.Raw_HTML__c = 'test';
        insert content;
        update content;
        test.stopTest();
        
    }
    
    @isTest 
    public static void testContentToWebcastAssoc(){
        
		Webcast__c w = new Webcast__c();
		w.Name = 'TEST WEBCAST';
		w.Title__c = 'TEST WEBCAST TITLE';
		w.Description__c = 'TEST WEBCAST DESCRIPTION';
        
        INSERT w;
        
        //The first peice of content was associated when the Webcast was inserted.
        Content__c c1 = new Content__c();
        c1.Name = 'SECOND CONTENT';
        c1.Webcast__c = w.Id;

        try{        
        	INSERT c1;
        }catch(Exception e){
         	System.assertEquals(e.getTypeName(), 'System.DmlException');
        }
        
        //Insert first with no association then try to UPDATE the association.
        Content__c c2 = new Content__c();
        c2.Name = 'SECOND CONTENT';

        INSERT c2;
        
        System.assertEquals([SELECT Id FROM Content__c WHERE Id = :c2.Id LIMIT 1].Id, c2.Id);
        
        c2.Webcast__c = w.Id;
        
        try{        
        	UPDATE c2;
        }catch(Exception e){
         	System.assertEquals(e.getTypeName(), 'System.DmlException');
        }
        
    }
   
    
}