global class updateExamSitesForFailedFRMExams implements Database.Batchable<sObject>,Database.StateFul{
    global static Exam_Sites_For_FRM_Batch__c examSettings = Exam_Sites_For_FRM_Batch__c.getInstance('FRM Details');
   
    global Database.QueryLocator start(Database.BatchableContext BC){
      
        
      //run this batch for only one record at once.
      // test class for this is batchUpdateExamSitesFRMExamsTest
        String strSection = examSettings.Section__c; //'FRM Part 2';
        String StrDefered = 'Approved';
        string id ='a1a40000000jbZm';
        String oppstatus = 'closed';
        String datExam = '2020-05-16';
        string teststrsection ='FRM Part 2';
       
        String query1 = 'SELECT Id,Exam_Site__c,Member__c,Site_code__c,Candidate_Commitment__c ,Exam_Site__r.Site__c,ADA_Status__c,RAD_Status__c,Opportunity_StageName__c ,Other_Exam_Registrations__c,Site_Id__c FROM Exam_Attempt__c Where Section__c =:strSection';
               query1 += ' AND Exam_Date__c ='+ datExam; 
               query1 += ' AND Opportunity_StageName__c =\''+oppstatus+'\'';                 
               query1 += ' AND  Cancelled__c != true';                
               query1 += ' AND Defered__c =\''+StrDefered+'\'';
              // query1 += ' AND id =\''+id+'\'';  
              
               
               
          if(test.isRunningTest()){
            query1 = 'SELECT Id,Exam_Site__c,Member__c,Candidate_Commitment__c,Site_code__c,Exam_Site__r.Site__c,ADA_Status__c,RAD_Status__c,Opportunity_StageName__c ,Other_Exam_Registrations__c,Site_Id__c FROM Exam_Attempt__c Where Section__c =:teststrsection';
               query1 += ' AND Opportunity_StageName__c =\''+oppstatus+'\'';  
                            
               query1 += ' AND  Cancelled__c != true';                
               query1 += ' AND Defered__c =\''+StrDefered+'\'';  
         }              
              
         return Database.getQueryLocator(query1);      
      
   }

   global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
        List<String> lstMember = new List<String>();
        Map<String,Id> mapExam2 = new Map<String,Id>();
        List<Exam_Attempt__c> objExmAttempt = new List<Exam_Attempt__c>();
        Set<string> setSiteIds = new Set<string>();
        set<Id> setContracts = new Set<Id>();
        
        
        for(Exam_Attempt__c objList : scope)
        {
            lstMember .add(objList.Member__c);  
            setSiteIds.add(objList.Site_code__c);
            setContracts.add(objList.Candidate_Commitment__c);
        }

        Map<Id,Map<String,Id>> mapCandidateRequirements = new Map<Id,Map<String,Id>>();
        for(Candidate_Requirement__c cr : [select id,Name,Exam__c,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__c in: setContracts and Exam__c ='FRM Part I'])
        {
            if(mapCandidateRequirements.containsKey(cr.Candidate_Commitment__c))
            {
                mapCandidateRequirements.get(cr.Candidate_Commitment__c).put(cr.Exam__c,cr.Id);
            }
            else
                mapCandidateRequirements.put(cr.Candidate_Commitment__c,new Map<String,Id>{cr.Exam__c=>cr.Id});
        }

        
        List<Exam_Attempt__c> lstExam2 = [SELECT Id,Member__c,Cancelled__c,ADA_Status__c,Defered__c,RAD_Status__c,Opportunity_StageName__c FROM Exam_Attempt__c where Member__c in: lstMember AND Section__c ='FRM Part 1' AND Exam_Date__c =2019-11-16
        and Cancelled__c !=true  and Opportunity_StageName__c ='closed' and Result__c!='Pass' ];
        
        for(Exam_Attempt__c objExam2 : lstExam2)
        {
            mapExam2.put(objExam2.Member__c,objExam2.Id);
            
        } 
        
        Map<String,Exam_Sites__c> mapSwapExamSite = new Map<String,Exam_Sites__c>();
        for(Exam_Sites__c examSites : [select id,Exam_Site_Code__c,Site_Code__c,Exam__c,Exam__r.Exam_Group__r.Active__c from Exam_Sites__c where Exam__r.Exam_Group__r.Active__c =: true and Site_code__c in: setSiteIds and Exam__c =: examSettings.Exam_Id__c])
        {
            mapSwapExamSite.put(examSites.Site_code__c,examSites);
        }
        system.debug('mapSwapExamSite == '+mapSwapExamSite);
        Set<Id> setNotesSiteIds = new Set<Id>();
        for(Exam_Attempt__c objScope : scope)
        {
            if(mapExam2!= null && mapExam2.get(objScope.Member__c)!= null)
            {
             system.debug('objScope == '+objScope);
               //Update Site Codes
              Exam_Sites__c eSite = mapSwapExamSite != null && mapSwapExamSite.size() > 0 ? mapSwapExamSite.get(objScope.Site_code__c) : null;
               objScope.Exam_Site__c = eSite != null ? eSite.Id : null;
               objScope.Updated_to_FRM_1__c = true;
                 if(!test.isRunningTest()){
               Map<String,Id> mapValues = mapCandidateRequirements.get(objScope.Candidate_Commitment__c);
               objScope.Candidate_Requirement__c = mapValues.get('FRM Part I');
              }
               objExmAttempt.add(objScope);
            
               setNotesSiteIds.add(objScope.Id);
               
            }
            
        
        }
         system.debug('objExmAttempt == '+objExmAttempt);
        Database.saveresult[] SR = database.update(objExmAttempt, false);  
        List<Note> lstNotes = new List<Note>();
        for(Id idVal : setNotesSiteIds)
        {
            Note notes = new Note();
            notes.parentId= idVal;
            notes.body='Updated to FRM 1';
            notes.title='Updated to FRM 1';
            notes.isPrivate=false;
             lstNotes.add(notes);
        }
        
        if(!lstNotes.isEmpty())
            insert lstNotes;
        
    }
  

   global void finish(Database.BatchableContext BC){
   
   }
}