/* Input for this batch is Exam Type, string should match the Exam__c picklist value on Exam__c object for FRM,ERP and SCR
 * Boolean input should be set to True is Part 2 exams are Pen and Paper and Part Exams are CBT
 * Exam Group Id should be saved to ExamGrpIdForExamSiteBatch custom label, query will filter Registrations with that Group Id
 * ExamAdminForFailedExamRegQuery - Exam Admins Id for the Exam Registration where results are loaded
 * Part2ExamGrpIdForExamSiteBatch - custom label is used to store the Exam group Id to query Part 2 exam registrations from a particular group
 * Part1ExamAdminIdForExamSiteBatch - custom label is used to story Exam Admin Id for Part 1 Exam to which Part 2 regs will be converted to 
 */
global class updateExamSitesForFailedExamsBatch implements Database.Batchable<sObject>,Database.StateFul{
	private string ExamGroupId = System.Label.ExamGrpIdForExamSiteBatch;
    private string nextExamGroupId = System.Label.Part2ExamGrpIdForExamSiteBatch;
    private string examadminIdForPart1 = System.Label.Part1ExamAdminIdForExamSiteBatch;
    private string examAdminForResults = System.Label.ExamAdminForFailedExamRegQuery;
   	private string examType;
    private string recordId;
    private boolean checkOldSiteCodes;
    public updateExamSitesForFailedExamsBatch(string examTypeStr,boolean checkCustomSettingSiteCodes){
        examType = examTypeStr;
        checkOldSiteCodes = checkCustomSettingSiteCodes;
    }
    public updateExamSitesForFailedExamsBatch(string examTypeStr,boolean checkCustomSettingSiteCodes,string inputRecordId){
        examType = examTypeStr;
        recordId = inputRecordId;
        checkOldSiteCodes = checkCustomSettingSiteCodes;
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        //run this batch for only one record at once.
        Set<String> strSection = new Set<String>{examType};
        String StrDefered = 'Approved';
        String oppstatus = 'closed';
        String passResult = 'Pass';
       
        String query1 = 'SELECT Id,Exam_Site__c,Exam_Administration__c,Exam_Site__r.Exam__c,Member__c,Site_code__c,Candidate_Commitment__c ,Exam_Site__r.Site__c,ADA_Status__c,RAD_Status__c,Opportunity_StageName__c ,Other_Exam_Registrations__c,Site_Id__c FROM Exam_Attempt__c Where Section__c IN:strSection';
               query1 += ' AND Exam_Site__r.Exam__r.Exam_Group__c =:examGroupId';
               query1 += ' AND Exam_Administration__c =: examAdminForResults'; 
               query1 += ' AND Opportunity_StageName__c =:oppstatus';                 
               query1 += ' AND Cancelled__c != true';
        	   query1 += ' AND Skip_Part_2_to_1_update_check__c != true';
        	   query1 += ' AND Result__c != null AND Result__c !=:passResult';
        if(String.isNotBlank(recordId)) {
            query1 += ' AND Id=: recordId';
        }  
              
        if(test.isRunningTest()){
            query1 = 'SELECT Id,Exam_Site__c,Exam_Administration__c,Exam_Site__r.Exam__c,Member__c,Candidate_Commitment__c,Site_code__c,Exam_Site__r.Site__c,ADA_Status__c,RAD_Status__c,Opportunity_StageName__c ,Other_Exam_Registrations__c,Site_Id__c FROM Exam_Attempt__c Where Section__c IN:strSection';
            query1 += ' AND Opportunity_StageName__c =:oppstatus';  
            query1 += ' AND  Cancelled__c != true';
            query1 += ' AND Result__c != null AND Result__c !=:passResult Limit 1';
        }              
        
        return Database.getQueryLocator(query1);      
      
   }

   global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        
       List<String> lstMember = new List<String>();
       Map<String,Id> mapExam2 = new Map<String,Id>();
       List<Exam_Attempt__c> objExmAttempt = new List<Exam_Attempt__c>();
       Set<string> setSiteIds = new Set<string>();
       set<Id> setContracts = new Set<Id>();
       Set<Id> examIds = new Set<Id>();
       //Set<Id> examAdminIds = new Set<Id>();
       List<Exam_Attempt__c> lstExam2 = new List<Exam_Attempt__c>();
       Map<String,String> oldToNewSiteCodeMap = new Map<String,String>();
       String part2Section;
       String candReqrmntExamName;
       if(examType == 'FRM Part 1'){
           part2Section = 'FRM Part 2';
           candReqrmntExamName = 'FRM Part I';
       }else if(examType == 'ERP Exam Part I'){
           part2Section = 'ERP Exam Part II';
           candReqrmntExamName = 'ERP Part I';
       }
       
       for(Exam_Attempt__c objList : scope)
       {
           lstMember .add(objList.Member__c);  
           setContracts.add(objList.Candidate_Commitment__c);
           mapExam2.put(objList.Member__c,objList.Id);
           examIds.add(objList.Exam_Site__r.Exam__c);
       }
       
       string examId;
       for (string eid : examIds) {
           examId = eid;
           break;
       }
       List<SiteMappingCodes__c> smcList = SiteMappingCodes__c.getall().values();
       for(SiteMappingCodes__c smc : smcList){
           oldToNewSiteCodeMap.put(smc.Old_Site_Code__c,smc.New_Site_Code__c);
       }
       
       if(test.isRunningTest()){
           lstExam2 = [SELECT Id,Exam_Administration__r.Exam_Group__c,Candidate_Commitment__c,Member__c,Site_code__c,Exam_Administration__c,Cancelled__c,ADA_Status__c,Defered__c,RAD_Status__c,Opportunity_StageName__c FROM Exam_Attempt__c where Member__c in: lstMember AND Section__c =:part2Section
                       and Defered__c = 'Approved' AND Cancelled__c !=true  and Opportunity_StageName__c ='closed' and Result__c =''];
       }else{
		   lstExam2 = [SELECT Id,Exam_Administration__r.Exam_Group__c,Candidate_Commitment__c,Member__c,Site_code__c,Exam_Administration__c,Cancelled__c,ADA_Status__c,Defered__c,RAD_Status__c,Opportunity_StageName__c FROM Exam_Attempt__c where Member__c in: lstMember AND Section__c =:part2Section
                       and Exam_Administration__r.Exam_Group__c =: nextExamGroupId AND Cancelled__c !=true  and Opportunity_StageName__c ='closed' and Result__c =''];
       }
       
       for(Exam_Attempt__c objList : lstExam2){
           if(checkOldSiteCodes == true){
               if(oldToNewSiteCodeMap.containskey(objList.Site_code__c)){
                   setSiteIds.add(oldToNewSiteCodeMap.get(objList.Site_code__c));
               }else{
                   setSiteIds.add(objList.Site_code__c);
               }
           }else if(checkOldSiteCodes == false){
               setSiteIds.add(objList.Site_code__c);
           }
           /*if(objList.Exam_Administration__c != null){
               examAdminIds.add(objList.Exam_Administration__c);
           }*/
       }
       Map<Id,Map<String,Id>> mapCandidateRequirements = new Map<Id,Map<String,Id>>();
       for(Candidate_Requirement__c cr : [select id,Name,Exam__c,Candidate_Commitment__c from Candidate_Requirement__c where Candidate_Commitment__c in: setContracts and Exam__c =:candReqrmntExamName])
       {
           if(mapCandidateRequirements.containsKey(cr.Candidate_Commitment__c))
           {
               mapCandidateRequirements.get(cr.Candidate_Commitment__c).put(cr.Exam__c,cr.Id);
           }
           else
               mapCandidateRequirements.put(cr.Candidate_Commitment__c,new Map<String,Id>{cr.Exam__c=>cr.Id});
       }
       
       Map<String,Exam_Sites__c> mapSwapExamSite = new Map<String,Exam_Sites__c>();
       for(Exam_Sites__c examSites : [select id,Exam_Site_Code__c,Site_Code__c,Exam__c,Exam__r.Exam_Group__r.Active__c from Exam_Sites__c where Site_code__c in: setSiteIds and Exam__c =: examId])
       {
           mapSwapExamSite.put(examSites.Site_code__c,examSites);
       }
       Map<String,Exam_Part__c> examPartMap = new Map<String,Exam_Part__c>();
       for(Exam_Part__c examPart : [Select Id,Exam_Administration__c,Exam__c,Exam__r.Exam__c,(select id,Exam_Site_Code__c,Site_Code__c,Exam__c from Exam_Sites__r where Site_code__c in: setSiteIds) from Exam_Part__c where Exam_Administration__c =: examadminIdForPart1]){
           examPartMap.put(examPart.Exam__r.Exam__c,examPart);
       }
       system.debug('mapSwapExamSite == '+mapSwapExamSite);
       Set<Id> setNotesSiteIds = new Set<Id>();
       for(Exam_Attempt__c objScope : lstExam2)
       {
           if(objScope.Exam_Administration__c == null){
               system.debug('objScope == '+objScope);
               //Update Site Codes
               Exam_Sites__c eSite = mapSwapExamSite != null && mapSwapExamSite.containskey(objScope.Site_code__c) ? mapSwapExamSite.get(objScope.Site_code__c) : null;
               if(eSite != null){
                   objScope.Exam_Site__c = eSite != null ? eSite.Id : null;
                   if(examType.contains('FRM')){
                       objScope.Updated_to_FRM_1__c = true;
                   }else if(examType.contains('ERP')){
                       objScope.Updated_to_ERP_1__c = true;
                   }
                   if(!test.isRunningTest()){
                       Map<String,Id> mapValues = mapCandidateRequirements.get(objScope.Candidate_Commitment__c);
                       objScope.Candidate_Requirement__c = mapValues.get(candReqrmntExamName);
                   }
                   objExmAttempt.add(objScope);
                   setNotesSiteIds.add(objScope.Id);
               }else{
                   objScope.Update_To_Part_1_Failed__c = true;
                   objExmAttempt.add(objScope);
               }
           }else if(objScope.Exam_Administration__c != null){
               Exam_Part__c examPart = examPartMap != null && examPartMap.containskey(examType) ? examPartMap.get(examType) : null;
               Exam_Sites__c eSite = examPart != null && examPart.Exam_Sites__r.size() > 0 ? examPart.Exam_Sites__r[0] : null;
               
               if(eSite != null && examPart != null){
                   objScope.Exam_Site__c = eSite != null ? eSite.Id : null;
                   objScope.Exam_Part__c = examPart != null ? examPart.Id : null;
                   objScope.Exam_Administration__c = examPart.Exam_Administration__c;
                   if(examType.contains('FRM')){
                       objScope.Updated_to_FRM_1__c = true;
                   }else if(examType.contains('ERP')){
                       objScope.Updated_to_ERP_1__c = true;
                   }
                   if(!test.isRunningTest()){
                       Map<String,Id> mapValues = mapCandidateRequirements.get(objScope.Candidate_Commitment__c);
                       objScope.Candidate_Requirement__c = mapValues.get(candReqrmntExamName);
                   }
                   objExmAttempt.add(objScope);
                   setNotesSiteIds.add(objScope.Id);
               }else{
                   objScope.Update_To_Part_1_Failed__c = true;
                   objExmAttempt.add(objScope);
               }
           }
       }
       system.debug('objExmAttempt == '+objExmAttempt);
       Database.saveresult[] SR = database.update(objExmAttempt, false);  
       List<Note> lstNotes = new List<Note>();
       for(Id idVal : setNotesSiteIds)
       {
           Note notes = new Note();
           notes.parentId= idVal;
           if(examType.contains('FRM')){
               notes.body='Updated to FRM 1';
               notes.title='Updated to FRM 1';
           }else if(examType.contains('ERP')){
               notes.body='Updated to ERP 1';
               notes.title='Updated to ERP 1';
           }
           notes.isPrivate=false;
           lstNotes.add(notes);
       }
       
       if(!lstNotes.isEmpty())
           insert lstNotes;
        
    }
  	global void finish(Database.BatchableContext BC){
   
   	}
}