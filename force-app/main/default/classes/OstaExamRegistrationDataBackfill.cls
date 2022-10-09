public class OstaExamRegistrationDataBackfill {
    
    public static Map<Id, Map<Id, Exam_Attempt__c>> createExamAttemptByExamGroupIdByFrmProgramIdMap(List<Exam_Attempt__c> examRegistrations) {
        
        Map<Id, Map<Id, Exam_Attempt__c>> examAttemptByExamGroupIdByFrmProgramMap = new Map<Id, Map<Id, Exam_Attempt__c>>();

        for(Exam_Attempt__c er: examRegistrations) {
            
            if(examAttemptByExamGroupIdByFrmProgramMap.containsKey(er.Exam_Site__r.Exam__r.Exam_Group__c)) {
                
                Map<Id, Exam_Attempt__c> examAttemptByFrmProgramIdMap = examAttemptByExamGroupIdByFrmProgramMap.get(er.Exam_Site__r.Exam__r.Exam_Group__c);
                
                /**
                 * Handle FRM Part 1 & FRM Part 2 Combined Registrations
                 */ 
                
                if(examAttemptByFrmProgramIdMap.containsKey(er.Candidate_Commitment__c)) {
                    
                    Exam_Attempt__c examAttempt = examAttemptByFrmProgramIdMap.get(er.Candidate_Commitment__c);
                    
                    if(er.Section__c == 'FRM Part 2') {
                        
                        /**
                         * At this point we know they signed up for a combined registration 
                         * and we want to only associate FRM Part 1.
                         */
                        
                        continue;
                        
                    }else if(er.Section__c == 'FRM Part 1') {
                        
                        /**
                         * Add FRM Part 1 or override FRM Part 2 if it exists in the map.  
                         * This handles combined registrations.
                         */
                        
                       examAttemptByFrmProgramIdMap.put(er.Candidate_Commitment__c, er); 
                        
                    } 
                    
                }else{
                    
                	examAttemptByFrmProgramIdMap.put(er.Candidate_Commitment__c, er);
                                        
                }
                
            }else {
                examAttemptByExamGroupIdByFrmProgramMap.put(
                    er.Exam_Site__r.Exam__r.Exam_Group__c, 
                    new Map<Id, Exam_Attempt__c>{er.Candidate_Commitment__c => er }
                );
                
            }
            
        }
        
        return examAttemptByExamGroupIdByFrmProgramMap;
        
    } 
    
    public static Map<Id, Map<Id, OSTA_Exam_Registration_Data__c>> createOstaExamRegistrationDataByFrmProgramByExamGroupIdMap(List<Contract> ostaPrograms) {
        
        List<OSTA_Exam_Registration_Data__c> ostaExamRegistrationData = new List<OSTA_Exam_Registration_Data__c>();
        for(Contract ostaProgram: ostaPrograms) {
            ostaExamRegistrationData.addAll(ostaProgram.OSTA_Exam_Registration_Data__r);
        }
        
        Map<Id, Map<Id, OSTA_Exam_Registration_Data__c>> ostaExamRegistrationDataByFrmProgramByExamGroupIdMap = new Map<Id, Map<Id, OSTA_Exam_Registration_Data__c>>();

        for(OSTA_Exam_Registration_Data__c oerd: ostaExamRegistrationData) {
            
            if(ostaExamRegistrationDataByFrmProgramByExamGroupIdMap.containsKey(oerd.OSTA_Program__r.FRM_Exam_Program__c)) {
                
                Map<Id, OSTA_Exam_Registration_Data__c> ostaExamRegistrationDataByFrmProgramIdMap = ostaExamRegistrationDataByFrmProgramByExamGroupIdMap.get(oerd.OSTA_Program__r.FRM_Exam_Program__c);
                
                ostaExamRegistrationDataByFrmProgramIdMap.put(oerd.Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c, oerd);
                
            }else {
                
                ostaExamRegistrationDataByFrmProgramByExamGroupIdMap.put(
                    oerd.OSTA_Program__r.FRM_Exam_Program__c, 
                    new Map<Id, OSTA_Exam_Registration_Data__c>{ oerd.Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c => oerd }
                );
                
            }
            
        }
        
        return ostaExamRegistrationDataByFrmProgramByExamGroupIdMap;
        
    }

    public static Set<OSTA_Exam_Registration_Data__c> run(List<Exam_Attempt__c> examRegistrations) {
        
		Map<Id, Contract> ostaProgramByFrmProgramIdMap = new Map<Id, Contract>();     
        Map<Id, Map<Id, Exam_Attempt__c>> examAttemptByExamGroupIdByFrmProgramIdMap = new Map<Id, Map<Id, Exam_Attempt__c>>();
        Map<Id, Map<Id, OSTA_Exam_Registration_Data__c>> ostaExamRegistrationDataByFrmProgramIdByExamGroupIdMap = new Map<Id, Map<Id, OSTA_Exam_Registration_Data__c>> ();

        //Create a set of all users associated with targeted Exam Registrations
        Set<Id> contactIds = new Set<Id>();
        for(Exam_Attempt__c examRegistration: examRegistrations){
            contactIds.add(examRegistration.Member__c);
        }
        
        /**
         * Create giant map of all Exam Registrations by Exam Group by FRM Program
         * -\ FRM Program
         * --\ Exam Group
         * ---\ Exam Registration
         **/
        examAttemptByExamGroupIdByFrmProgramIdMap = createExamAttemptByExamGroupIdByFrmProgramIdMap(examRegistrations);

        //Fetch all Contracts associated with target contacts.
        List<Contract> ostaPrograms = [
            SELECT Id, FRM_Exam_Program__c,
            (
                SELECT 
             	Id,
                OSTA_Program__c,
                OSTA_Program__r.FRM_Exam_Program__c,
                Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c
                FROM OSTA_Exam_Registration_Data__r
            )
            FROM Contract
            WHERE
            	Status = 'Activated ( Auto-Renew )' AND
            	RecordType.Name = 'OSTA Program' AND
            	CustomerSignedId IN :contactIds
        ];
        
        System.debug('OSTA Programs => ' + ostaPrograms.size());
        
		//Create map of OSTA Programs by FRM Program ID
        for(Contract ostaProgram: ostaPrograms){
        	ostaProgramByFrmProgramIdMap.put(ostaProgram.FRM_Exam_Program__c, ostaProgram);
        }
        
        // FRM Contract Id to Exam Group Id to OSTA Data
        ostaExamRegistrationDataByFrmProgramIdByExamGroupIdMap = createOstaExamRegistrationDataByFrmProgramByExamGroupIdMap(ostaPrograms);
        
        Set<OSTA_Exam_Registration_Data__c> toInsert = new Set<OSTA_Exam_Registration_Data__c>();
        
        //Iterating over FRM Programs
        for(Map<Id, Exam_Attempt__c> examAttemptByFrmProgramIdMap: examAttemptByExamGroupIdByFrmProgramIdMap.values()) {
            
            //Iterating over Exam Attempts
            for(Exam_Attempt__c examAttempt: examAttemptByFrmProgramIdMap.values()) {

                if(ostaExamRegistrationDataByFrmProgramIdByExamGroupIdMap.containsKey(examAttempt.Candidate_Commitment__c)){
                    Map<Id, OSTA_Exam_Registration_Data__c> fnd = ostaExamRegistrationDataByFrmProgramIdByExamGroupIdMap.get(examAttempt.Candidate_Commitment__c);
                    
                    /**
                     * If an OSTA Exam Registration Data record already exists for the 
                     * given Exam Group and FRM Program then just continue.  Only one OSTA Exam Registration Data
                     * record should exist per Exam Group for one Exam Registration. 
                     **/
                    if(fnd.containsKey(examAttempt.Exam_Site__r.Exam__r.Exam_Group__c)){
                        continue;
                    }
                    
                }

                //Creating the OSTA Exam Registration Data record
                if(ostaProgramByFrmProgramIdMap.containsKey(examAttempt.Candidate_Commitment__c)){
                    Id ostaProgramId = ostaProgramByFrmProgramIdMap.get(examAttempt.Candidate_Commitment__c).Id;
                    
                    OSTA_Exam_Registration_Data__c oerd = new OSTA_Exam_Registration_Data__c();
                    
                    oerd.OSTA_Program__c = ostaProgramId;
                    oerd.Exam_Registration__c = examAttempt.Id;
                    
                    toInsert.add(oerd);
                }
                
            }
        }

		if(!toInsert.isEmpty()) INSERT new List<OSTA_Exam_Registration_Data__c>(toInsert);
 
        return toInsert;

    }
    
}