trigger updateAccounts on Contact (after update) {
    Object_Trigger_Switch__mdt metadataSwitch = Object_Trigger_Switch__mdt.getInstance('ContactMDT');
    System.debug('metadataSwitch::>>    '+metadataSwitch);
    Boolean runTrigger = False;
    if(metadataSwitch != null && !metadataSwitch.isActive__c && !Test.isRunningTest()){
        runTrigger = True;
    }
    
    if(Test.isRunningTest() && TestClassUtil.isOldTrigger == 'OLD' ){
        runTrigger = True;
    }
    
    if(runTrigger){
        Set<Id> setAccountIds = new Set<Id>();
        Map<Id,Contact> mapContacts = new Map<Id,Contact>();
        Map<Id,Contact> mapexpirationdate = new Map<Id,Contact>();
        Id memberRecId = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        String accountId;
        Default_Record_References__c drr = Default_Record_References__c.getAll().get('UNMATCHED-BUSINESS-ACCOUNT');
        if(drr != null){
            accountId = drr.Record_Reference_ID__c;
        }
        for(Contact cn : trigger.New)
        {
            if(cn.AccountId != null && cn.RecordTypeID == memberRecId && cn.AccountId != accountId) {
                system.debug('* * * Contact Trigger ...'+ cn + ':' + UpdateAccountTriggerUtils.bPKIDRecusrive);            
                mapContacts.put(cn.accountId,cn);
            }
            
        }
        
        if(!mapContacts.isEmpty() && !UpdateAccountTriggerUtils.bPKIDRecusrive)
        {
            UpdateAccountTriggerUtils.UpdatePKID(mapContacts);
            
        }    
        if((trigger.new[0].Email != trigger.old[0].Email                                                        ||
            trigger.new[0].FirstName != trigger.old[0].FirstName                                                ||
            trigger.new[0].LastName != trigger.old[0].LastName                                                  ||
            trigger.new[0].Email_Daily_News__c != trigger.old[0].Email_Daily_News__c                            ||
            trigger.new[0].Email_The_Week_in_Risk__c != trigger.old[0].Email_The_Week_in_Risk__c                ||
            trigger.new[0].Email_Chapter_Meetings__c != trigger.old[0].Email_Chapter_Meetings__c                ||
            trigger.new[0].Exam_Prep_Provider_Outreach__c != trigger.old[0].Exam_Prep_Provider_Outreach__c      ||
            trigger.new[0].Email_Webcasts__c != trigger.old[0].Email_Webcasts__c                                ||
            trigger.new[0].Email_Events__c != trigger.old[0].Email_Events__c                                    ||
            trigger.new[0].Email_CorporateTeamBuilding__c != trigger.old[0].Email_CorporateTeamBuilding__c      ||
            trigger.new[0].Email_InsightAnalysis__c != trigger.old[0].Email_InsightAnalysis__c                  ||
            trigger.new[0].Email_GARP_Updates__c != trigger.old[0].Email_GARP_Updates__c                        ||
            trigger.new[0].Email_Information_Exchange__c != trigger.old[0].Email_Information_Exchange__c        ||
            trigger.new[0].Email_Member_Update__c != trigger.old[0].Email_Member_Update__c                      ||
            trigger.new[0].Email_Career_Center_Job_Board__c != trigger.old[0].Email_Career_Center_Job_Board__c  ||
            trigger.new[0].Email_CPE_News__c != trigger.old[0].Email_CPE_News__c                                ||
            trigger.new[0].HasOptedOutOfEmail != trigger.old[0].HasOptedOutOfEmail                              ||
            trigger.new[0].Email_FRM__c != trigger.old[0].Email_FRM__c                                          ||
            trigger.new[0].Email_ERP__c != trigger.old[0].Email_ERP__c                                          ||
            trigger.new[0].SCR_Updates__c != trigger.old[0].SCR_Updates__c                                      ||
            
            trigger.new[0].Email_Subscription_Change_Source__c != trigger.old[0].Email_Subscription_Change_Source__c) && !ContactAuditHistory.bPKIDRecusrive1){
                
                ContactAuditHistory.trackContactFields(Trigger.new, Trigger.oldMap);
            }
    }
}