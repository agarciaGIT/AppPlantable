/**
* Class ContractTriggerHandler
*
* Trigger Handler for the 'Contract'(Contract) SObject. This class implements the TriggerAbstract
* interface to help ensure the trigger code is bulkified and all in one place. 
*/
public without sharing class ContractTriggerHandler implements TriggerAbstract {
    // Constructor
    
    static Map<id,Contract> newlyCompletedContractMap = new Map<id,Contract>();
    static Map<id,Contract> newlyActivatedContractMap = new Map<id,Contract>();
    static Map<id,Contract> newlyLapsedContractMap = new Map<id,Contract>();
    
    static MAP<id,id> currentContractAndAccountIds = new MAP<id,id>();
    static Map<Id,Contract> mapContractDetails = new Map<Id,contract>();
    static Map<Id,Contact> ContactMap = new Map<Id,contact>();
    static Map<String,set<Id>> mapUpdateEmail = new Map<String,set<Id>>();
    static List<Contract> PearsonVueNewContracts =new List<Contract>();
    static List<Opportunity> lstOpportunitiesUpdate = new List<Opportunity>();
    static Map<Id,Contract> PearsonVueOldMapContracts = new Map<Id,Contract>();
    static List<Id> lstOpp = new List<Id>(); 
    static List<Id> ContactId = new List<Id>(); 
    static set<Id> riskDotNetContractIds = new set<Id>();
    static Set<Id> setOpps1 = new Set<Id>();
    static Set<String> accountIds = new Set<String>();
    static List<Contact_Update_Event__e> contUpdEvts = new List<Contact_Update_Event__e>();
    
    static Id SCRRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','SCR_Program');
    static Id ERPRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ERP_Program');
    static Id FRMRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','FRM_Program');
    static Id CPERecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','CPE');
    static Id ICBRRRecId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ICBRR_Program');
    static Id CPECandidateReqRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Candidate_Requirement__c','CPE');
    static Id MembershipContractRTId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','Membership');
    static Id AttestCandidateReqRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Candidate_Requirement__c','Attest');
    static Id RiskNetId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'Risk_Net');
    public static boolean stopRecurssion = true;
    
    public ContractTriggerHandler(){
        system.debug('**********In ContractTriggerHandler Constructor*******  ');
        contUpdEvts = new List<Contact_Update_Event__e>();
        lstOpportunitiesUpdate = new List<Opportunity>();
    }
    
    /**
* bulkBefore
*
* This method is called prior to execution of a BEFORE trigger. Use this to cache
* any data required into maps prior execution of the trigger.
*/
    public void bulkBefore() {
        //if(stopRecurssion){
            if(trigger.isUpdate){
                for(Contract newContract : (List<Contract>)trigger.New){
                    ContactId.add(newContract.CustomerSignedId);
                }
                for(Contact con : [SELECT Id,Email FROM Contact WHERE Id IN: ContactId]){
                    ContactMap.put(con.Id,con);
                }
            }
        //}
    }
    
    public void bulkAfter(){
    }
    
    public void beforeInsert(SObject so){
    }
    
    public void beforeUpdate(SObject oldSo, SObject so) {
        system.debug('**********In ContractTriggerHandler beforeUpdate*******  ');
        Contract newContract = (Contract)so;
        Contract oldContract = (Contract)oldSo;
        //if(stopRecurssion){
            if(ContactMap.size() > 0){
                Contact ContactRecord = ContactMap.containskey(newContract.CustomerSignedId) ? ContactMap.get(newContract.CustomerSignedId): null;
                if(newContract.RecordTypeId == MembershipContractRTId && newContract.Status != 'Draft' && ContactRecord != null && newContract.Member_Email__c != ContactRecord.Email){
                        newContract.Member_Email__c = ContactRecord.Email;
                }
                if(newContract.Status == 'Completed' && (newContract.Status != oldContract.Status)) {
                    newContract.Member_Email__c = ContactRecord.Email;
                }
            }
            
            if(newContract.ContractTerm != oldContract.ContractTerm && newContract.Status.indexOf('Activ') > -1 ){
                newContract.Days_Left__c = newContract.StartDate.daysBetween(newContract.EndDate);
            }
            
            if (newContract.All_Requirements_Completed__c != oldContract.All_Requirements_Completed__c && newContract.All_Requirements_Completed__c == true ) {
                newContract.All_Requirements_Completed_Date__c = system.today(); 
            }
        //}
    }
    
    
    public void beforeDelete(SObject so){
        // Cast the SObject to an Exam_Attempt__c
        system.debug('**********In ContractTriggerHandler beforeDelete*******  ');
    }
    
    public void afterInsert(SObject so){
        
    }
    
    public void afterUpdate(SObject oldSo, SObject so) {
        system.debug('**********In ContractTriggerHandler afterUpdate*******  ');
        Contract newContract = (Contract)so;
        Contract oldContract = (Contract)oldSo;
        
        //if(stopRecurssion){
            
            if(newContract.All_Requirements_Completed__c != oldContract.All_Requirements_Completed__c &&
               newContract.All_Requirements_Completed__c == TRUE){
                   allRequirementsComplete(newContract,oldContract);
               }
            
            if(newContract.Status != 'Draft' && oldContract.Status != newContract.Status){
                contUpdEvts.add(triggerutilities.getContactEvents(newContract.accountID,'Contract',JSON.serialize(newContract),JSON.serialize(oldContract),newContract.Id));
            }
            
            if(newContract.RecordTypeId == SCRRecordTypeId || newContract.RecordTypeId == ICBRRRecId) {
                PearsonVueNewContracts.add(newContract);
                PearsonVueOldMapContracts.put(newContract.Id,oldContract);
            }
            if( (oldContract.ContractTerm != newContract.ContractTerm
                 || oldContract.Pearson_Member_Last_Name__c != newContract.Pearson_Member_Last_Name__c 
                 || oldContract.Pearson_Member_First_Name__c != newContract.Pearson_Member_First_Name__c
                 || oldContract.Pearson_Phone_No__c != newContract.Pearson_Phone_No__c
                 || oldContract.Member_Email__c != newContract.Member_Email__c 
                 || oldContract.Status != newContract.Status) 
               && newContract.RecordTypeId == RiskNetId  
               && newContract.API_Transaction_Status__c == null
              ) {
                  if(newContract.Status == 'Activated' || newContract.Status == 'Canceled' || newContract.Status == 'Expired') 
                  { 
                      riskDotNetContractIds.add(newContract.Id);
                  }
              }
            
            // AG Store newly Activated and Expired Contracts
           if(oldContract.Status != newContract.Status && newContract.Status.indexOf('Activ') > -1 && newContract.RecordTypeId == MembershipContractRTId && (newContract.Membership_Type__c == 'Individual' || newContract.Membership_Type__c == 'Affiliate')) {
               system.debug('check account Id:'+newContract.AccountId);
               system.debug('check account Id:'+accountIds);
               accountIds.add(newContract.AccountId);
               system.debug('check account Id:'+accountIds);
           }
           if(oldContract.Status != newContract.Status && newContract.Status == 'Expired' && newContract.RecordTypeId == MembershipContractRTId && newContract.Membership_Type__c == 'Individual') {
               accountIds.add(newContract.AccountId);
           }
           if(oldContract.All_Requirements_Completed__c != newContract.All_Requirements_Completed__c && newContract.All_Requirements_Completed__c == True && newContract.RecordTypeId == FRMRecordTypeId) {
               accountIds.add(newContract.AccountId);
           }
           if(oldContract.Status != newContract.Status && newContract.Status == 'Canceled' && 
              ((newContract.RecordTypeId == MembershipContractRTId && newContract.Membership_Type__c == 'Individual')
              	|| newContract.RecordTypeId == FRMRecordTypeId
              	|| newContract.RecordTypeId == ERPRecordTypeId)) {
               accountIds.add(newContract.AccountId);
           }
        
            if((oldContract.status == 'Activated ( Auto-Renew )' && newContract.Status != 'Activated ( Auto-Renew )')
               && newContract.RecordTypeID == MembershipContractRTId 
               &&(newContract.Membership_type__C =='Individual' || newContract.Membership_type__C =='student') 
               && oldContract.status != newContract.status)
            {
                setOpps1.add(newContract.Opportunity__c);
                lstOpp.add(newContract.Opportunity__c);
            }
        //}
        
        
    }
    
    public void afterDelete(SObject so){
        system.debug('**********In ContractTriggerHandler afterDelete*******  ');
    }
    
    /**
* andFinally
*
* This method is called once all records have been processed by the trigger. Use this
* method to accomplish any final operations such as creation or updates of other records.
*/
    public void andFinally(){
        system.debug('**********In ContractTriggerHandler andFinally*******  ');
        //if(stopRecurssion){
            // ChargentSFAPayment
            if(Trigger.isAfter && Trigger.isUpdate ) {
                
                if(lstOpp.size() > 0) {
                    List<Opportunity> opp = [SELECT id,Do_Not_change_amount__c,ChargentSFA__Payment_Status__c,Certified_Membership_Individual__c,
                                             ChargentSFA__Payment_Frequency__c,ChargentSFA__Payment_Stop__c,ChargentSFA__Next_Transaction_Date__c,
                                             ChargentSFA__Manual_Charge__c,ChargentSFA__Charge_Amount__c,ChargentSFA__Payment_Start_Date__c 
                                             FROM Opportunity
                                             WHERE id IN : lstOpp ];
                    if(setOpps1.size()>0) {
                        lstOpportunitiesUpdate.addAll(ContractTriggerHelper.StoppingChargentSFAPayment(opp,setOpps1)); 
                    } 
                }
                
                if(lstOpportunitiesUpdate.size()>0){
                    update lstOpportunitiesUpdate; 
                }
                
                // CPE Contract
                if(newlyCompletedContractMap.size()>0 && stopRecurssion){
                    stopRecurssion = false;
                    ContractTriggerHelper.CPEContract(newlyCompletedContractMap,currentContractAndAccountIds);
                    
                }
                if(!riskDotNetContractIds.isEmpty()) {
                    List<Integration_Stream_Event__e> riskDotNetEvent = TriggerUtilities.getIntgEvents(riskDotNetContractIds, 'Contract', 'RiskDotNet');
                    EventBus.publish(riskDotNetEvent);  
                }
                if(!PearsonVueNewContracts.isEmpty() && !PearsonVueOldMapContracts.isEmpty()) {
                    ScrContractTriggerHelper.createPearsonVueData(PearsonVueNewContracts,PearsonVueOldMapContracts);
                }
                if(!accountIds.isEmpty()){
                    ContractTriggerHelper.publishFontevaEvents(accountIds);
                }
                
                //Publish platform events to update contacts
                if(!contUpdEvts.isEmpty()){
                    system.debug(contUpdEvts.size()+'   <<::contUpdEvts::>>   '+contUpdEvts);
                    Eventbus.publish(contUpdEvts);
                }
            }
       
            
        //}
    }
    
    public void allRequirementsComplete(Contract newContract, Contract oldContract) {
        system.debug('newContract====>'+newContract.Id);
        if ((newContract.RecordTypeId == ERPRecordTypeId || newContract.RecordTypeId == FRMRecordTypeId ||
             newContract.RecordTypeId == SCRRecordTypeId || newContract.RecordTypeId == CPERecordTypeId ) &&
            newContract.All_Requirements_Completed__c == TRUE) {
                if ((oldContract != NULL && (oldContract.status == 'Activated' || oldContract.status == 'Activated ( Auto-Renew )') && 
                     newContract.All_Requirements_Completed__c != oldContract.All_Requirements_Completed__c )) {
                         newlyCompletedContractMap.put(newContract.id,newContract) ;
                         currentContractAndAccountIds.put(newContract.AccountId,newContract.CustomerSignedId);
                     }
            }
    }
}