trigger UpdateContractNew on Candidate_Requirement__c(after update) {
    Map < Id,Candidate_Requirement__c > mapDetails = new Map < Id,Candidate_Requirement__c > ();
    set < Id > setContractIds = new Set < Id > ();
    
    Id examRecordTypeID = RecordTypeHelper.getRecordTypeIdFromSchema('Candidate_Requirement__c','Exam');
    Id jobRecordTypeID = RecordTypeHelper.getRecordTypeIdFromSchema('Candidate_Requirement__c','Job_Experience');
    Id frmRecordTypeID = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','FRM_Program');
    Id erpRecordTypeID = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ERP_Program');
    Id icbrrRecordTypeID = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ICBRR_Program');
    
    for (Candidate_Requirement__c obj : trigger.new) {
        
        if((trigger.oldMap.get(obj.Id).Status__c != obj.Status__c && (obj.RecordTypeId == examRecordTypeID || obj.RecordTypeId == jobRecordTypeID)) ||
           (trigger.oldMap.get(obj.Id).Certificate_Sent_Date__c != obj.Certificate_Sent_Date__c)){
               
               system.debug('* * * Add CR:' + obj);
               
               setContractIds.add(obj.Candidate_Commitment__c);
               mapDetails.put(obj.Candidate_Commitment__c, obj);  
           }
    }
    
    if (setContractIds.size() > 0) {
        map < Id,Candidate_Requirement__c > dbCR = new map < Id, Candidate_Requirement__c > ();
        for (Candidate_Requirement__c objCandReq : [select id, Name, Status__c, RecordTypeId, Candidate_Commitment__c,Candidate_Commitment__r.RecordTypeId,Certificate_Sent_Date__c, Date_of_Completion__c, Date_of_Ready_for_Review__c, Date_of_Failed_Review__c from Candidate_Requirement__c where Candidate_Commitment__c in : setContractIds]) {
            
            system.debug('* * * Loop CR:' + objCandReq);
            dbCR.put(objCandReq.Id, objCandReq);
            
        }
        
        
        List < Contract > lstContracts = new List < Contract > ();
        MAP <ID, Candidate_Requirement__c> mapFRMAccountCR = new MAP <ID, Candidate_Requirement__c>();
        MAP <ID, Candidate_Requirement__c> mapERPAccountCR = new MAP <ID, Candidate_Requirement__c>();
        
        for (Contract objCon : [select id, AccountId, recordTypeId, recordType.Name, Status, Membership_Type__c, ContractTerm, EndDate, StartDate, All_Requirements_Completed__c, All_Requirements_Completed_Date__c from Contract where id in : setContractIds]) {
            
            Candidate_Requirement__c objCR = mapDetails.get(objCon.Id);
            
            if(objCR.RecordTypeId == jobRecordTypeID && objCon.RecordTypeId == frmRecordTypeID && (objCon.status.indexof('Activated') > -1 || objCon.status.indexof('Completed') > -1)) {
                system.debug('* * * In 4');
                mapFRMAccountCR.put(objCon.AccountId, objCR);
            }
            if(objCR.RecordTypeId == jobRecordTypeID && objCon.RecordTypeId == erpRecordTypeID && (objCon.status.indexof('Activated') > -1 || objCon.status.indexof('Completed') > -1)) {
                system.debug('* * * In 5');
                mapERPAccountCR.put(objCon.AccountId, objCR);
            }
            
            
        }
        
        system.debug('* * * mapFRMAccountCR:' + mapFRMAccountCR); 
        system.debug('* * * mapERPAccountCR:' + mapERPAccountCR);
        
        if(mapFRMAccountCR.size() > 0 || mapERPAccountCR.size() > 0) {
            List<Contact> lstCont = [select Id, Name, AccountId, KPI_FRM_Resume_Program_Requirement_ID__c, KPI_ERP_Resume_Program_Requirement_ID__c, KPI_FRM_Resume_Status__c, KPI_FRM_Resume_Status_Date__c, KPI_FRM_Resume_Certificate_Sent_Date__c, KPI_ERP_Resume_Status__c, KPI_ERP_Resume_Status_Date__c, KPI_ERP_Resume_Certificate_Sent_Date__c from Contact where AccountId in :mapFRMAccountCR.keySet() or AccountId in :mapERPAccountCR.keySet()];
            List<Candidate_Requirement__c> lstCR = new List<Candidate_Requirement__c>();
            for(Contact objContact :lstCont) {
                Candidate_Requirement__c c = mapFRMAccountCR.get(objContact.AccountId); 
                if(c != null) {
                    
                    Candidate_Requirement__c cr = dbCR.get(c.Id); 
                    
                    if(cr != null) {
                        
                        system.debug('* * * mapFRMAccountCR:' + mapFRMAccountCR);
                        
                        if(cr.Status__c == 'Initial')
                            objContact.KPI_FRM_Resume_Status__c = NULL;
                        
                        if(cr.Status__c == 'Ready For Review'){
                            objContact.KPI_FRM_Resume_Status__c = 'Waiting for Review';
                            objContact.KPI_FRM_Resume_Submission_Date__c = cr.Date_of_Ready_for_Review__c;}
                        
                        
                        if(cr.Status__c == 'Failed Review')
                            objContact.KPI_FRM_Resume_Status__c = 'Denied';
                        
                        if(cr.Status__c == 'Completed')
                            objContact.KPI_FRM_Resume_Status__c = 'Approved';
                        
                        
                        objContact.KPI_FRM_Resume_Program_Requirement_ID__c = cr.Id;
                        
                        if(cr.Status__c == 'Completed') {
                            
                            objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Completion__c;
                        }                    
                        
                        if(cr.Status__c == 'Ready For Review') {
                            if(trigger.oldMap.get(cr.Id).Status__c != cr.Status__c) {
                            }
                        }
                        
                        if(cr.Status__c == 'Failed Review') {
                            
                            objContact.KPI_FRM_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;
                        }
                        
                        if(cr.Certificate_Sent_Date__c != null) {
                            objContact.KPI_FRM_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;
                        }
                        
                    }
                }
                c = mapERPAccountCR.get(objContact.AccountId); 
                if(c != null) {
                    
                    Candidate_Requirement__c cr = dbCR.get(c.Id); 
                    
                    if(cr != null) {
                        
                        if(cr.Status__c == 'Initial')
                            objContact.KPI_ERP_Resume_Status__c = NULL;
                        
                        if(cr.Status__c == 'Ready For Review'){
                            objContact.KPI_ERP_Resume_Status__c = 'Waiting for Review';
                            objContact.KPI_ERP_Resume_Submission_Date__c = cr.Date_of_Ready_for_Review__c;}
                        
                        if(cr.Status__c == 'Failed Review')
                            objContact.KPI_ERP_Resume_Status__c = 'Denied';
                        
                        if(cr.Status__c == 'Completed')
                            objContact.KPI_ERP_Resume_Status__c = 'Approved';
                        
                        
                        objContact.KPI_ERP_Resume_Program_Requirement_ID__c = cr.Id;
                        
                        if(cr.Status__c == 'Completed') {
                            
                            objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Completion__c;
                        }                    
                        
                        if(cr.Status__c == 'Ready For Review') {
                            
                        }
                        
                        if(cr.Status__c == 'Failed Review') {
                            
                            objContact.KPI_ERP_Resume_Status_Date__c = cr.Date_of_Failed_Review__c;
                        }
                        
                        if(cr.Certificate_Sent_Date__c != null) {
                            objContact.KPI_ERP_Resume_Certificate_Sent_Date__c = cr.Certificate_Sent_Date__c;
                        }
                    }
                }                
            }
            update lstCont;
        }
    }
}