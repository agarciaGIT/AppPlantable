public with sharing class cloneInitiative
{
    // properites
    public Initiative__c  tempInitiativeRecord{get;set;}
    ApexPages.StandardController stdController {get;set;}
    
    public cloneInitiative(ApexPages.StandardController controller) {
            tempInitiativeRecord = (Initiative__c)controller.getRecord();
            stdController = controller;
    }
    
    
    public PageReference cloneInitiative()
    {
        // setup the save point for rollback
        Savepoint sp = Database.setSavepoint();
        
        Initiative__c currentInitiativeRecord;
        Initiative__c newInitiativeRecord;
        try{
        // fetch the old exam group record and create a clone of that. before inserting the clone update the cloned_from__c 
        currentInitiativeRecord = [Select Id,name from Initiative__c where id =:ApexPages.currentPage().getParameters().get('Id') ];
        newInitiativeRecord = currentInitiativeRecord.clone(false);
        newInitiativeRecord.Name = tempInitiativeRecord.Name;
        //newInitiativeRecord.Exam_Date__c = tempInitiativeRecord.Exam_Date__c;
        
       // newInitiativeRecord.Cloned_From__c = currentInitiativeRecord.Id;    

        try{
        insert newInitiativeRecord;   
        }catch(Exception ex)
        {
            if(ex.getMessage().contains('duplicate'))
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Duplicate record. Please check the records in the system.'));
            else
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            return null;                    
        }
   
        // fetch all the story  record related to the Initiative
        List<Story__c> lst_exam = new List<Story__c>();
        for(Story__c story :[SELECT Id, Acceptance_Criteria__c, Cloned_From__c ,Add_Tasks__c, Blocked_Reason__c, Bunsiness_Sign_off_Decline_Reason__c, Bunsiness_Sign_off_Status__c, Business_Sponsor_Approver__c, Call_to_Action__c, Collateral_Types_for_Deliverable__c, Create_Tasks__c, Date_Closed__c, Date_Completed__c, IsDeleted, Department__c, Deployment__c, Deployment_Status__c, Distribution_Channel__c, Initiative__c, Iteration__c, Key_Message__c, Links_in_Deliverable__c, Not_a_Story__c, OwnerId, Parent_Story__c, Peer_Review_Completed__c, Code_Review_Items__c, Code_Reviews__c, Points__c, Priority__c, Product_Line__c, QA_Plan__c, QA_Results__c, QA_Status__c, Rank__c, Size__c, LOE_Size__c, Status__c, Story_ID__c, Story_Leads__c, Name,  Target_Audience__c, Target_Date_of_Completion__c, Title__c, Title_Name__c, Type__c FROM Story__c where Initiative__c!=null and Initiative__c =:currentInitiativeRecord.Id])
        {
            Story__c e = story.clone(false);
            
            e.Initiative__c = newInitiativeRecord.Id;
             e.cloned_from__c = story.Id;
           
            lst_exam.add(e);
        }
        
        if(lst_exam.size() > 0)
            insert lst_exam;
        
        // requery the exam record to create a map of old and new exam id
      //  Map<String,String> map_oldNewExam = new Map<String,String>();
      //  for(Story__c e:[Select Id from Story__c where Id In:lst_exam])
      //  {
      //    map_oldNewExam.put(e.Cloned_From__c,e.Id);
      //  }       
        
       
        
        }catch(exception e)
        {
          // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
        }
        PageReference p =  new PageReference('/'+newInitiativeRecord.Id+'/e');
        p.getParameters().put('retURL','/'+newInitiativeRecord.Id);
        p.setRedirect(true);
        return p;    
    }
}