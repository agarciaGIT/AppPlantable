trigger updateLeads on lead (after update) {
    
   
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
       
        trigger.new[0].Email_Subscription_Change_Source__c != trigger.old[0].Email_Subscription_Change_Source__c) && !LeadAuditHistory.bPKIDRecusrive2){
        
        
                LeadAuditHistory.trackLeadFields(Trigger.new, Trigger.oldMap);

        }}