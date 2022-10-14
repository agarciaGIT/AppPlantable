public class allRequirementsCompleteTrgHandler   {
    
    list< contract > newCPEContracts = new List<contract>();
    List<Contract> CPEContractList = new List<Contract>();
    List<Contract> contractsToUpdate = new List<Contract>();
    list< Candidate_Requirement__c > newCPERequirements = new List<Candidate_Requirement__c>();
    list< Candidate_Requirement__c > newAttestRequirements = new List<Candidate_Requirement__c>();
    list< Candidate_Requirement__c > CPERequirementsToUpdate = new List<Candidate_Requirement__c>();
    list<CPE_Claim__c> lstCreateCpeClaim = new list<CPE_Claim__c>();
    Map<id,Contract> newlyCompletedContractMap = new Map<id,Contract>() ;
    map< id, id > ContractID2reqID = new map< id, id >() ;
    set< id > accountIDsOfMembersWithNewlyCompletedContracts = new Set<id>() ;
    map<string, map<string,id>> recTypeDevName2sObjectType2ID = new map<string, map<string,id>> () ;
    Map<Id,contract> mapContractDetails = new  Map<Id,contract>();
    Map<Id,Contract> accountToCPEContractMap = new  Map<Id,Contract>();
    Set<Id> setOpps = new Set<Id>();
    Set<Id> setOpps1 = new Set<Id>();
    Map<id,id> currentContractRecordTypeIds = new map<id,id>();
    MAP<id,id> currentContractAndAccountIds = new MAP<id,id>();
    // RecordTypeIDs   Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Membership').getRecordTypeId();
    Id SCRRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('SCR_Program').getRecordTypeId();
    Id ERPRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ERP_Program').getRecordTypeId();
    Id FRMRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('FRM_Program').getRecordTypeId();
    Id CPERecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('CPE').getRecordTypeId();
    Id CPECandidateReqRecordTypeId = Schema.SObjectType.Candidate_Requirement__c.getRecordTypeInfosByDeveloperName().get('CPE').getRecordTypeId();
    Id AttestCandidateReqRecordTypeId = Schema.SObjectType.Candidate_Requirement__c.getRecordTypeInfosByDeveloperName().get('Attest').getRecordTypeId();
    Id MembershipContractRTId = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('Membership').getRecordTypeId();
    @testvisible
    static Boolean stopRecursion = false;    
    public boolean allRequirementsComplete (List<Contract> newcon,Map<Id,Contract> newMap,Map<Id,Contract> oldMap) {
        
        if(!stopRecursion) {
            stopRecursion = true;
            for ( contract c : newcon ) {
                system.debug(' Contract==='+c);
                
                if (oldMap.get(c.Id).status == 'Activated' && c.All_Requirements_Completed__c == TRUE && c.All_Requirements_Completed__c != oldMap.get(c.Id).All_Requirements_Completed__c) {          
                    if (c.RecordTypeId == ERPRecordTypeId || c.RecordTypeId == FRMRecordTypeId || c.RecordTypeId == SCRRecordTypeId ) {
                        system.debug('RecordTypeId ==='+c.RecordTypeId);
                        newlyCompletedContractMap.put(c.id,c) ;
                        accountIDsOfMembersWithNewlyCompletedContracts.add( c.AccountId ) ;
                        currentContractAndAccountIds.put(c.AccountId,c.CustomerSignedId);
                    }
                    system.debug('accountIDsOfMembersWithNewlyCompletedContracts======>'+accountIDsOfMembersWithNewlyCompletedContracts);
                }
                system.debug('OLD MAP ==='+Trigger.OldMap);
                if(c.Status == 'Activated ( Auto-Renew )'&& c.RecordTypeID == MembershipContractRTId &&(c.Membership_type__C =='Individual' || c.Membership_type__C =='student') && oldMap.get(c.Id).KPI_Last_Updated__c == newMap.get(c.Id).KPI_Last_Updated__c)
                {
                    setOpps.add(c.Opportunity__c);
                    mapContractDetails.put(c.Opportunity__c,c);
                }
                
                if(oldMap.get(c.Id).status == 'Activated ( Auto-Renew )'&& c.RecordTypeID == MembershipContractRTId &&(c.Membership_type__C =='Individual' || c.Membership_type__C =='student') && oldMap.get(c.Id).status != newMap.get(c.Id).status)
                {
                    setOpps1.add(c.Opportunity__c);
                    
                }
                
            }
            
            if ( newlyCompletedContractMap.size() > 0 ) {
                
                system.debug('============newlyCompletedContractMap=====');
                
                Date today = date.today();
                Date laststartDt = date.newInstance(date.today().year()-1, 1, 1 );
                Date ThisStartDt = date.newInstance(date.today().year(), 1, 1 );
                Date NextStartDt;
                Date startDt = date.newInstance(date.today().year(), 1, 1 );
                if(today.month() >= 7) {
                    startDt = date.newInstance(date.today().year()+1, 1, 1 );
                    lastStartDt = date.newInstance(date.today().year()-1, 1, 1 );
                    ThisStartDt = date.newInstance(date.today().year(), 1, 1 );
                    NextStartDt = date.newInstance(date.today().year()+1, 1, 1 );
                }
                
                CPEContractList = [SELECT Id,  AccountId, Opportunity__c, OwnerId, StartDate,EndDate,Status,
                                   Opportunity__r.AccountId,Opportunity__r.Frm1__c,Opportunity__r.Frm2__c,Opportunity__r.Erp1__c,Opportunity__r.Erp2__c,CustomerSignedId,
                                   (Select Id,CPE_Credit_Requirement__c,Candidate_Commitment__c,GARP_ID__c from Candidate_Requirements__r where recordTypeID =: CPECandidateReqRecordTypeId) 
                                   FROM Contract  WHERE AccountId IN :accountIDsOfMembersWithNewlyCompletedContracts AND RecordTypeId =: CPERecordTypeId];
                
                for( contract c : CPEContractList) {
                   // if(c.Status == 'Activated ( Auto-Renew )' || c.Status == 'Completed'){
                   if((c.Status == 'Activated ( Auto-Renew )' || c.Status == 'Completed') && 
                      (c.StartDate == lastStartDt || c.StartDate == ThisStartDt || c.StartDate == NextStartDt)) {
                       
                          accountToCPEContractMap.put(c.AccountId,c);
                          
                    }
                    System.debug('accountToCPEContractMap======>'+accountToCPEContractMap.size());
                }
                
                //Get CPE_Activity_Type__c 'Passing Relevant Exams' record Id from Custom Label
                String cpeClaimActivityTypeId = System.Label.PassingRelevantCPEClaimRecord;
                
                for ( contract c : newlyCompletedContractMap.values()){
                    if(accountToCPEContractMap.containsKey(c.AccountId)){
                        Contract cpe = accountToCPEContractMap.get(c.AccountId);
                        system.debug('c.CustomerSignedId ===========>'+ c.CustomerSignedId );
                        System.debug('cpe==========>'+cpe);
                         if((cpe.Status == 'Activated ( Auto-Renew )' || cpe.Status == 'Completed') && (cpe.StartDate == lastStartDt || cpe.StartDate == ThisStartDt || cpe.StartDate == NextStartDt))
                         {
                            Candidate_Requirement__c cr = cpe.Candidate_Requirements__r[0];
                             System.debug('=======Entered to created CPD Claim=======');
                            if(c.RecordTypeID == SCRRecordTypeId && cpe.Status == 'Activated ( Auto-Renew )'){
                                CPE_Claim__c  cpeClaim = new CPE_Claim__c ();
                                cpeClaim.Candidate_Requirement__c = cr.id;
                                cpeClaim.CPE_Activity_Type__c = cpeClaimActivityTypeId;
                                cpeClaim.Credits_Earned__c = 12;
                                cpeClaim.Member__c = c.CustomerSignedId;
                                cpeClaim.Date_of_Completion__c = Date.Today() ;
                                cpeClaim.EventTitle__c = 'Sustainability and Climate Risk (SCR) Exam';
                                cpeClaim.Area_of_Study__c = 'Sustainability and Climate Risk';
                                cpeClaim.Provider__c = c.Opportunity__r.AccountId;
                                if(cpe.Opportunity__r.Frm1__c == true || cpe.Opportunity__r.Frm2__c == true){
                                    cpeClaim.FRM__c = true;
                                } else if(cpe.Opportunity__r.Erp1__c == true || cpe.Opportunity__r.Erp2__c == true) {
                                    cpeClaim.ERP__c = true;
                                }
                                lstCreateCpeClaim.add(cpeClaim);
                            }else if(c.RecordTypeID == ERPRecordTypeId || c.RecordTypeID == FRMRecordTypeId){
                                cr.CPE_Credit_Requirement__c = 40;
                                CPERequirementsToUpdate.add(cr);
                                if(cpe.Status == 'Completed' && (cpe.StartDate == lastStartDt || cpe.StartDate == ThisStartDt || cpe.StartDate == NextStartDt)){
                                    cpe.Status = 'Activated ( Auto-Renew )';
                                    contractsToUpdate.add(cpe);
                                }
                            }
                            
                        }else{
                            contract newCPEContract = new contract (AccountId = c.AccountId,OwnerId = c.OwnerId,ContractTerm = 24, Opportunity__c = c.Opportunity__c,RecordTypeId = CPERecordTypeId,StartDate = startDt,Status = 'draft',CustomerSignedId = c.CustomerSignedId);
                            newCPEContracts.add(newCPEContract) ;
                            currentContractRecordTypeIds.put(c.AccountId, c.RecordTypeId);
                        }
                    }else if(!accountToCPEContractMap.containsKey(c.AccountId)){
                        contract newCPEContract = new contract (AccountId = c.AccountId,OwnerId = c.OwnerId,ContractTerm = 24, Opportunity__c = c.Opportunity__c,RecordTypeId = CPERecordTypeId,StartDate = startDt,Status = 'draft', CustomerSignedId = c.CustomerSignedId);
                        newCPEContracts.add(newCPEContract) ;
                        currentContractRecordTypeIds.put(c.AccountId, c.RecordTypeId);
                    }
                }
                
                if(!newCPEContracts.isEmpty())
                    insert newCPEContracts;
                
                if(!CPERequirementsToUpdate.isEmpty())
                    update CPERequirementsToUpdate;
                
                if(!lstCreateCpeClaim.isEmpty())
                    insert lstCreateCpeClaim;
                
                List<Contact> lstContacts = [select Id, Name, Email_CPE_News__c, MailingCountry from contact where AccountID in :accountIDsOfMembersWithNewlyCompletedContracts];
                for(Contact con :lstContacts) {
                    
                    //if(con.MailingCountry != 'Canada') {
                    con.Email_CPE_News__c = true;
                    //}
                }
                
                update lstContacts;
                
                for ( contract c : newCPEContracts ) {
                    c.status = 'Activated ( Auto-Renew )';
                    contractsToUpdate.add(c);
                }
                if(!contractsToUpdate.isEmpty())
                    update contractsToUpdate ;
                
                // insert CPE
                for( Contract c: newCPEContracts ) {
                    if(currentContractRecordTypeIds.get(c.AccountId) == SCRRecordTypeId){
                        system.debug('add SCR');
                        newCPERequirements.add ( new Candidate_Requirement__c ( Candidate_Commitment__c = c.id, recordTypeID = CPECandidateReqRecordTypeId,Name = 'CPE', Status__c = 'Initial', CPE_Credit_Requirement__c  = 20 )) ;                  
                    } else if(currentContractRecordTypeIds.get(c.AccountId) == FRMRecordTypeId || currentContractRecordTypeIds.get(c.AccountId) == ERPRecordTypeId){
                        system.debug('Add FRM/ERP');
                        newCPERequirements.add ( new Candidate_Requirement__c ( Candidate_Commitment__c = c.id, recordTypeID = CPECandidateReqRecordTypeId,Name = 'CPE', Status__c = 'Initial', CPE_Credit_Requirement__c = 40 )) ;                   
                    }
                }
                
                if(!newCPERequirements.isEmpty())
                    insert newCPERequirements ;
                
                // insert Attest
                for ( Candidate_Requirement__c c : newCPERequirements )
                    ContractID2reqID.put( c.Candidate_Commitment__c, c.id ) ;
                
                for ( Contract c: newCPEContracts ) {  
                    newAttestRequirements.add ( new Candidate_Requirement__c ( Candidate_Commitment__c = c.id, recordTypeID = AttestCandidateReqRecordTypeId ,Prerequisite__c = ContractID2reqID.get( c.id ),Name = 'Attest', Status__c = 'Initial' )) ;
                }
                
                if(!newAttestRequirements.isEmpty())
                    insert newAttestRequirements ;
            }
            
            system.debug(' setOpps==='+setOpps);
            if(setOpps.size() > 0)
            {
                system.debug(' mapContractDetails==='+mapContractDetails);
                List<Opportunity> lstOpps = new List<Opportunity>();
                for(Opportunity objOpp : [select id,Do_Not_change_amount__c,ChargentSFA__Payment_Status__c,Certified_Membership_Individual__c,ChargentSFA__Payment_Frequency__c,ChargentSFA__Payment_Stop__c,ChargentSFA__Next_Transaction_Date__c,ChargentSFA__Manual_Charge__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Payment_Start_Date__c from Opportunity where id in: setOpps])
                {
                    system.debug(' objOpp==='+objOpp);
                    objOpp.ChargentSFA__Payment_Status__c = 'Recurring';
                    objOpp.ChargentSFA__Payment_Frequency__c = 'Annual';
                    objOpp.ChargentSFA__Payment_Stop__c = 'Unending';
                    objOpp.ChargentSFA__Manual_Charge__c = True;
                    Contract con = mapContractDetails.get(objOpp.Id);
                    //  objOpp.ChargentSFA__Next_Transaction_Date__c = con.Enddate;
                    objOpp.ChargentSFA__Payment_Start_Date__c = con.Enddate;
                    if(con.Membership_Type__c == 'Individual' && (objOpp.Do_Not_change_amount__c == true ||objOpp.Certified_Membership_Individual__c == true)){
                        
                        objOpp.ChargentSFA__Charge_Amount__c = 150;}
                    
                    else if(con.Membership_Type__c == 'Individual' && objOpp.Do_Not_change_amount__c != true){
                        objOpp.ChargentSFA__Charge_Amount__c = 195;}
                    
                    else if(con.Membership_Type__c == 'Student')
                        objOpp.ChargentSFA__Charge_Amount__c = 95;
                    
                    lstOpps.add(objOpp);
                }
                
                system.debug('Updated OPPS == '+lstOpps);
                
                update lstOpps;
            }
            
            
            
            if(setOpps1.size() > 0)
            {
                system.debug(' mapContractDetails==='+mapContractDetails);
                List<Opportunity> lstOpps = new List<Opportunity>();
                for(Opportunity objOpp : [select id,ChargentSFA__Payment_Status__c,Certified_Membership_Individual__c,ChargentSFA__Payment_Frequency__c,ChargentSFA__Payment_Stop__c,ChargentSFA__Next_Transaction_Date__c,ChargentSFA__Manual_Charge__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Payment_Start_Date__c from Opportunity where id in: setOpps1])
                {
                    system.debug(' objOpp==='+objOpp);
                    objOpp.ChargentSFA__Payment_Status__c = 'Stopped';
                    
                    lstOpps.add(objOpp);
                }
                
                system.debug('Updated OPPS == '+lstOpps);
                
                update lstOpps;
            }
        }  
        return stopRecursion;
    }
}