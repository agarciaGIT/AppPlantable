global class expireScholarship implements Database.Batchable<SObject>
{
   
  
    global Database.QueryLocator start(Database.BatchableContext BC){
    
    
    Date dtEndDate = system.today();    
    string id1 ='a95g0000000Cmiu';
    
  
        return Database.getQueryLocator('select id,Exam_Group__c,Status__c,Exam_Group__r.Next_Exam_Group__r.Last_Date_For_Late_Registration__c from Scholarship_Application__c where Exam_Group__r.Next_Exam_Group__r.Last_Date_For_Late_Registration__c <: dtEndDate');
        
     }
    
    
    global void execute(Database.BatchableContext BC, List<Scholarship_Application__c> scope){
    
       List<Scholarship_Application__c> SClist = new List<Scholarship_Application__c>();
        for(Scholarship_Application__c SC : scope)
        {
           
       
               SC.Status__c = 'Expired';  
               SClist.add(sc);
            
            }

            update SClist;
           
      }
     
    global void finish(Database.BatchableContext BC){
         
       
    }

}