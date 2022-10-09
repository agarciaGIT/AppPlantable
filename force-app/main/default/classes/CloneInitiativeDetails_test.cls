@isTest
public class CloneInitiativeDetails_test {
    
  
    static Initiative__c Initiative;
    static Story__c story;
   
        
    static void testData(){ 
           
      
        
        Initiative = new Initiative__c();
        Initiative.name ='test';
         
        insert Initiative;
        
        Story = new Story__c();
        Story.Initiative__c = Initiative.id;
        Story.name = 'test';
       
        insert Story;
        
      
    }
    
    static testMethod void unitTest_1(){
        testData();
        test.startTest();
        ApexPages.currentPage().getParameters().put('Id',Initiative.id);
        cloneInitiative clonedetails = new cloneInitiative(new ApexPages.StandardController(Initiative));
        clonedetails.tempInitiativeRecord = Initiative;
        cloneDetails.cloneInitiative();
        test.stopTest();
    }
}