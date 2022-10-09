@isTest
public class ProjectManagerDashBoard_Test {
    @testsetup
    public static void createObjects(){
        RecordType useThis = [Select id from RecordType where name ='Tech Request'];
        List<story__c> storiesForInsert = new List<Story__c>();
        List<Case> casesForInsert = new List<Case>();
        for(integer x=0; x<8; x++){
            if(x<3){
                story__c thisStory= new Story__c();
                thisStory.Code_Review_Items__c = 'Something';
                thisStory.Code_Reviews__c = 'Something';
                thisStory.QA_Plan__c = 'Something';
                thisStory.QA_Results__c='Something';
                thisStory.LOE_Size__c='5 - High';
                thiSStory.Status__c='Completed';
                thisStory.Type__c='Operational';
                thisStory.Iteration__c = '2017 Iteration 8: 4/17-4/30';
                
                storiesForInsert.add(thisStory);
                
                //Code_Review_Items__c,Code_Reviews__c, QA_Plan__c, Points__c, Story_Leads__c
                
            }
            if(x<6){
                story__c thisStory= new Story__c();
                thisStory.QA_Results__c='Something';
                thisStory.LOE_Size__c='5 - High';
                thiSStory.Status__c='Completed';
                thisStory.Type__c='Operational';
                thisStory.Iteration__c = '2017 Iteration 8: 4/17-4/30';
                
                storiesForInsert.add(thisStory);
                
            }
            if(x<8){
                story__c thisStory= new Story__c();
                thisStory.Code_Review_Items__c = 'Something';
                thisStory.Code_Reviews__c = 'Something';
                thisStory.QA_Plan__c = 'Something';
                thisStory.QA_Results__c='Something';
                thisStory.LOE_Size__c='5 - High';
                thiSStory.Status__c='Completed';
                thisStory.Type__c='Operational';
                thisStory.Iteration__c = '2017 Iteration 7: 4/3-4/16';
                
                storiesForInsert.add(thisStory);
            }
        }
        
        for(integer x=0; x<20;x++){
            if(x<5){
                Case thisCase = new Case();
                thisCase.RecordTypeId=useThis.id;
                thisCase.Status= 'Blocked';
                casesForInsert.add(thisCase);
            }
            if(x<11){
                Case thisCase = new Case();
                thisCase.RecordTypeId = useThis.id;
                thisCase.Priority = 'Urgent';
                casesForInsert.add(thisCase);
            }
            if(x<20){
                Case thisCase = new Case();
                thisCase.RecordTypeId = useThis.id;
                casesForInsert.add(thisCase);
            }
        }
        insert casesForInsert;
        insert storiesForInsert;
        
        
    }
    
    public testmethod static void testAll(){
       
        ProjectManagerDashBoard runThis = new ProjectManagerDashBoard();
        runthis.neededIteration = '2017 Iteration 8: 4/17-4/30';
        System.debug(runThis.neededIteration);
        runThis.Velocity();
        runThis.allStories();
        
    }
    
}