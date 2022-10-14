public class opportunityTriggerUtils_New {
    
    public static Contract getNewRiskContract(OpportunityLineItem oli,Map<Id,Contact> accIdToContactMap){
        Id riskNetRecordTypeID = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','Risk_Net');
        Contract riskContract = new Contract();
        riskContract.Name = 'Risk.net';
        riskContract.Status = 'Draft';
        if(accIdToContactMap.containsKey(oli.Opportunity.AccountId)){
            Contact contact = accIdToContactMap.get(oli.Opportunity.AccountId);
            riskContract.CustomerSignedId = contact.Id;
            riskContract.Pearson_Member_First_Name__c = contact.FirstName;
            riskContract.Pearson_Member_Last_Name__c = contact.LastName;
            riskContract.Member_Email__c = contact.Email;
            riskContract.Pearson_Phone_No__c = contact.HomePhone;
        }
        riskContract.accountId = oli.Opportunity.AccountId;
        riskContract.Opportunity__c = oli.OpportunityId;
        riskContract.StartDate = system.today();
        riskContract.ContractTerm = Integer.valueOf(oli.quantity);
        riskContract.recordTypeID = riskNetRecordTypeID;
        return riskContract;
    }
    
    public static Contract getNewMemberContract(Opportunity opp,Id memberRecordType,string strMemberShipType){
        Contract objContract = new Contract();
        objContract.status = 'Draft';
        objContract.accountId = opp.accountId;
        objContract.Opportunity__c = opp.Id;
        objContract.StartDate = system.today();
        objContract.ContractTerm  = 12;
        objContract.Membership_Type__c = strMemberShipType;
        objContract.recordTypeID = memberRecordType;
        return objContract; 
        
    }
    
    public static Contract getNewOSTAContract(Id accountId,Id OppId,Id contactId,Id OSTARecTypeId,ID FRMProgramId){
        Contract ostaContract = new Contract();
        ostaContract.AccountId = accountId;
        ostaContract.Opportunity__c = OppId;
        ostaContract.RecordTypeId = OSTARecTypeId;
        ostaContract.FRM_Exam_Program__c = FRMProgramId != null ? FRMProgramId:null;
        ostaContract.Status = 'Draft';
        ostaContract.Name = 'OSTA Program';
        ostaContract.StartDate = System.today();
        ostaContract.ContractTerm = 9999;
        ostaContract.CustomerSignedId = contactId;
        
        return ostaContract;
    }
    
    public static String getUPSCode(String strDesc) {
        if(strDesc == null) return 'ERROR';
        if(strDesc.IndexOf('UPS Next Day Air Saver') >= 0)
            return '1DP';
        if(strDesc.IndexOf('UPS Next Day Air Early A.M.') >= 0)
            return '1DM';
        if(strDesc.IndexOf('UPS Worldwide Express Plus') >= 0)
            return 'EP';
        if(strDesc.IndexOf('UPS 2nd Day Air A.M.') >= 0)
            return '2DM';
        if(strDesc.IndexOf('UPS Saver') >= 0)
            return 'SV';
        if(strDesc.IndexOf('UPS Next Day Air') >= 0)
            return '1DA';
        if(strDesc.IndexOf('UPS 2nd Day Air') >= 0)
            return '2DA';
        if(strDesc.IndexOf('UPS Ground') >= 0)
            return 'GND';
        if(strDesc.IndexOf('UPS Worldwide Express')  >= 0)
            return 'ES';
        if(strDesc.IndexOf('UPS Worldwide Expedited') >= 0)
            return 'EX';
        if(strDesc.IndexOf('UPS Standard') >= 0)
            return 'ST';
        if(strDesc.IndexOf('UPS 3 Day Select') >= 0)
            return '3DS';
        return 'ERROR';
    }
    
}