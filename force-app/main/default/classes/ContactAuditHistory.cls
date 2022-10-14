public class ContactAuditHistory {
    
    public static boolean bPKIDRecusrive1 = false;
    public static boolean isChanged = false;
    
    public static void trackContactFields(List<Contact> contacts, Map<Id, Contact> oldMap) {

        bPKIDRecusrive1 = true;
        List<Object_History__c > contactHistories = new List<Object_History__c >(); 
        
        for(Contact c : contacts){
            
            Object_History__c contactHistory = new Object_History__c();
            
            if(c.GARP_Directory_Invite_Opt_Out__c != oldMap.get(c.Id).GARP_Directory_Invite_Opt_Out__c){
                contactHistory.Contact__c = c.Id;
                isChanged = true;
            }

            if(c.Email != null && oldMap.get(c.Id).Email != c.Email){ 
                contactHistory.Email_Modified_Value__c = c.Email;
                contactHistory.Email_Prior_Value__c = oldMap.get(c.Id).Email; 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
   
            if(c.FirstName != null && oldMap.get(c.Id).FirstName != c.FirstName){ 
                contactHistory.First_Name_Modified_Value__c = c.FirstName;
                contactHistory.First_Name_Prior_Value__c = oldMap.get(c.Id).FirstName; 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.LastName != null && oldMap.get(c.Id).LastName != c.LastName){ 
                contactHistory.Last_Name_Modified_Value__c = c.LastName;
                contactHistory.Last_Name_Prior_Value__c = oldMap.get(c.Id).LastName; 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.SCR_Updates__c != null && oldMap.get(c.Id).SCR_Updates__c != c.SCR_Updates__c){ 
                contactHistory.SCR_Updates_Modified_Value__c = string.valueof(c.SCR_Updates__c);
                contactHistory.SCR_Updates_Prior_Value__c = string.valueof(oldMap.get(c.Id).SCR_Updates__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_Daily_News__c != null && oldMap.get(c.Id).Email_Daily_News__c != c.Email_Daily_News__c){ 
                contactHistory.Daily_News_Modified_Value__c = string.valueof(c.Email_Daily_News__c);
                contactHistory.Daily_News_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_Daily_News__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_The_Week_in_Risk__c != null && oldMap.get(c.Id).Email_The_Week_in_Risk__c != c.Email_The_Week_in_Risk__c){ 
                contactHistory.Week_in_Risk_Modified_Value__c = string.valueof(c.Email_The_Week_in_Risk__c);
                contactHistory.Week_in_Risk_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_The_Week_in_Risk__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_Chapter_Meetings__c != null && oldMap.get(c.Id).Email_Chapter_Meetings__c != c.Email_Chapter_Meetings__c){ 
                contactHistory.Chap_Mtg_Modified_Value__c = string.valueof(c.Email_Chapter_Meetings__c);
                contactHistory.Chap_Mtg_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_Chapter_Meetings__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Exam_Prep_Provider_Outreach__c != null && oldMap.get(c.Id).Exam_Prep_Provider_Outreach__c != c.Exam_Prep_Provider_Outreach__c){ 
                contactHistory.EPP_Modified_Value__c = string.valueof(c.Exam_Prep_Provider_Outreach__c);
                contactHistory.EPP_Prior_Value__c = string.valueof(oldMap.get(c.Id).Exam_Prep_Provider_Outreach__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_Webcasts__c != null && oldMap.get(c.Id).Email_Webcasts__c != c.Email_Webcasts__c){ 
                contactHistory.Webcast_Modified_Value__c = string.valueof(c.Email_Webcasts__c);
                contactHistory.Webcast_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_Webcasts__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_Events__c != null && oldMap.get(c.Id).Email_Events__c != c.Email_Events__c){ 
                contactHistory.Conf_and_Workshop_Modified_Value__c = string.valueof(c.Email_Events__c);
                contactHistory.Conf_and_Workshop_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_Events__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_CorporateTeamBuilding__c != null && oldMap.get(c.Id).Email_CorporateTeamBuilding__c != c.Email_CorporateTeamBuilding__c){ 
                contactHistory.Corp_Team_Modified_Value__c = string.valueof(c.Email_CorporateTeamBuilding__c);
                contactHistory.Corp_Team_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_CorporateTeamBuilding__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_InsightAnalysis__c != null && oldMap.get(c.Id).Email_InsightAnalysis__c != c.Email_InsightAnalysis__c){ 
                contactHistory.Insights_Modified_Value__c = string.valueof(c.Email_InsightAnalysis__c);
                contactHistory.Insights_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_InsightAnalysis__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_GARP_Updates__c != null && oldMap.get(c.Id).Email_GARP_Updates__c != c.Email_GARP_Updates__c){ 
                contactHistory.GARP_Updates_Modified_Value__c = string.valueof(c.Email_GARP_Updates__c);
                contactHistory.GARP_Updates_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_GARP_Updates__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_Information_Exchange__c != null && oldMap.get(c.Id).Email_Information_Exchange__c != c.Email_Information_Exchange__c){ 
                contactHistory.Info_Exchange_Modified_Value__c = string.valueof(c.Email_Information_Exchange__c);
                contactHistory.Info_Exchange_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_Information_Exchange__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id; 
            }
            
            if(c.Email_Member_Update__c != null && oldMap.get(c.Id).Email_Member_Update__c != c.Email_Member_Update__c){ 
                contactHistory.Member_Update_Modified_Value__c = string.valueof(c.Email_Member_Update__c);
                contactHistory.Member_Update_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_Member_Update__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;   
            }
            
            if(c.Email_Career_Center_Job_Board__c != null && oldMap.get(c.Id).Email_Career_Center_Job_Board__c != c.Email_Career_Center_Job_Board__c){ 
                contactHistory.Career_Center_Modified_Value__c = string.valueof(c.Email_Career_Center_Job_Board__c);
                contactHistory.Career_Center_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_Career_Center_Job_Board__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_CPE_News__c != null && oldMap.get(c.Id).Email_CPE_News__c != c.Email_CPE_News__c){ 
                contactHistory.CPD_Bulletin_Modified_Value__c = string.valueof(c.Email_CPE_News__c);
                contactHistory.CPD_Bulletin_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_CPE_News__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.HasOptedOutOfEmail != null && oldMap.get(c.Id).HasOptedOutOfEmail != c.HasOptedOutOfEmail){ 
                contactHistory.Email_Opt_Out_Modified_Value__c = string.valueof(c.HasOptedOutOfEmail);
                contactHistory.Email_Opt_Out_Prior_Value__c = string.valueof(oldMap.get(c.Id).HasOptedOutOfEmail); 
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_FRM__c != null && oldMap.get(c.Id).Email_FRM__c != c.Email_FRM__c){ 
                contactHistory.FRM_Exam_Update_Modified_Value__c = string.valueof(c.Email_FRM__c);
                contactHistory.FRM_Exam_Update_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_FRM__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id; 
            }
            
            if(c.Email_ERP__c != null && oldMap.get(c.Id).Email_ERP__c != c.Email_ERP__c){ 
                contactHistory.ERP_Exam_Update_Modified_Value__c = string.valueof(c.Email_ERP__c);
                contactHistory.ERP_Exam_Update_Prior_Value__c = string.valueof(oldMap.get(c.Id).Email_ERP__c); 
                isChanged = true;
                contactHistory.Contact__c = c.Id; 
            }
            
            if(c.Email_Subscription_Change_Source__c != null && oldMap.get(c.Id).Email_Subscription_Change_Source__c != c.Email_Subscription_Change_Source__c){ 
                contactHistory.Source_that_Made_Change__c = c.Email_Subscription_Change_Source__c;
                contactHistory.Contact__c = c.Id;
            }
            
            if(c.Email_Subscription_Change_Source__c != null && oldMap.get(c.Id).Email_Subscription_Change_Source__c == c.Email_Subscription_Change_Source__c&& isChanged == true){ 
                contactHistory.Source_that_Made_Change__c = 'GARP Employee Update-'+c.LastModifiedById;
                isChanged = true;
                contactHistory.Contact__c = c.Id;
            }  
            
            if(((c.Email_Subscription_Change_Source__c == null || c.Email_Subscription_Change_Source__c == '') || (oldMap.get(c.Id).Email_Subscription_Change_Source__c == c.Email_Subscription_Change_Source__c)) && isChanged == true){ 
                contactHistory.Source_that_Made_Change__c = 'GARP Employee Update-'+c.LastModifiedById;
                isChanged = true;
                contactHistory.Contact__c = c.Id; 
            }
            
            contactHistories.add(contactHistory);
            
            if(!contactHistories.isEmpty()){
                UPSERT contactHistories;
            }
            
        }
        
    }
    
}