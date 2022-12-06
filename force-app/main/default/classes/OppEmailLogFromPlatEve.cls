public class OppEmailLogFromPlatEve {
 
    public static void callOppLog(String oppId){
 
        Opportunity oppLogMatch = [ SELECT id,accountId,recordTypeId,GARP_Member_ID__c,ChargentSFA__Billing_First__c,ChargentSFA__Billing_Last__c,
            						Account.Name,Amount,Name,CloseDate,Display_Invoice_Number__c,
           						    Exam_Registration_FRM_I__c,Exam_Registration_FRM_II__c,Exam_Registration_ERP__c,
          							Exam_Registration_Type__c,Alternate_Method_of_Payment__c,Exam_Emails_Text__c,
        						    Program_Name__c,Exam_Emails__c,Mebership_Expiration_Date__c,Membership_Fee__c,
            						Membership_Emails__c,Member_Expire_Date__c,Shipping_First_Name__c,Shipping_Last_Name__c,
            						ChargentSFA__Billing_Email__c,Yardstick_pass__c,Shipping_E_mail__c,
            						Attending_Exam_Registration_Name__c,Auto_Renew__c,Billing_Email__c,
                                    Email_URL__c,Email_WebSite_URL__c,Event_Order__c,Exam_Registration_Modification__c,
                                    Frm1__c,Frm2__c,Has_Books__c,Invoice_Paid_status__c,Is_Exam_Cancelled__c,
                                    Payment_Method_New__c,Payment_Method__c,ChargentSFA__Payment_Status__c,
                                    Previous_Memerbship__c,Risk_net__c,Ship_Check__c,StageName,
                                    Type,Yardstick_Welcome_Email_Sent_Date__c FROM Opportunity WHERE Id  =: oppId];
        
        Account acc = [select id,recordTypeId from Account where id =: oppLogMatch.accountid];
        
        Email_log__c Opplogid = new Email_log__c();
        
        Opplogid.Opportunity_Account_Record_Type__c = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosById().get(acc.recordTypeId).getName();
        Opplogid.Opportunity_Name__c =  oppLogMatch.Name;
        Opplogid.Opportunity_GARP_Member_ID__c   = oppLogMatch.GARP_Member_ID__c;
        Opplogid.Opportunity_ChargentSFA_Billing_First__c    = oppLogMatch.ChargentSFA__Billing_First__c;
        Opplogid.Opportunity_ChargentSFA_Billing_Last__c = oppLogMatch.ChargentSFA__Billing_Last__c;
        Opplogid.Opportunity_Account_Name__c = oppLogMatch.Account.Name;
        Opplogid.Opportunity_Amount__c   = oppLogMatch.Amount;
        Opplogid.Opportunity_CloseDate__c    = oppLogMatch.CloseDate;
        Opplogid.Opportunity_Display_Invoice_Number__c   = oppLogMatch.Display_Invoice_Number__c;
        Opplogid.Opportunity_Exam_Registration_FRM_I__c  = oppLogMatch.Exam_Registration_FRM_I__c;
        Opplogid.Opportunity_Exam_Registration_FRM_II__c = oppLogMatch.Exam_Registration_FRM_II__c;
        Opplogid.Opportunity_Exam_Registration_ERP__c    = oppLogMatch.Exam_Registration_ERP__c;
        Opplogid.Opportunity_Exam_Registration_Type__c   = oppLogMatch.Exam_Registration_Type__c;
        Opplogid.Opportunity_Alternate_Method_of_Payment__c  = oppLogMatch.Alternate_Method_of_Payment__c;
        Opplogid.Opportunity_Exam_Emails_Text__c = oppLogMatch.Exam_Emails_Text__c;
        Opplogid.Opportunity_Program_Name__c = oppLogMatch.Program_Name__c;
        Opplogid.Opportunity_Exam_Emails__c  = oppLogMatch.Exam_Emails__c;
        Opplogid.Opportunity_Mebership_Expiration_Date__c    = oppLogMatch.Mebership_Expiration_Date__c;
        Opplogid.Opportunity_Membership_Fee__c   = oppLogMatch.Membership_Fee__c;
        Opplogid.Opportunity_Membership_Emails__c    = oppLogMatch.Membership_Emails__c;
        Opplogid.Opportunity_Member_Expire_Date__c   = oppLogMatch.Member_Expire_Date__c;
        Opplogid.Opportunity_Shipping_First_Name__c  = oppLogMatch.Shipping_First_Name__c;
        Opplogid.Opportunity_Shipping_Last_Name__c   = oppLogMatch.Shipping_Last_Name__c;
        Opplogid.Opportunity_ChargentSFA_Billing_Email__c    = oppLogMatch.ChargentSFA__Billing_Email__c;
        Opplogid.Opportunity_Yardstick_pass__c   = oppLogMatch.Yardstick_pass__c;
        Opplogid.Opportunity_Shipping_E_mail__c  = oppLogMatch.Shipping_E_mail__c;
        Opplogid.Opportunity_Attending_Exam_Registration__c	 = oppLogMatch.Attending_Exam_Registration_Name__c;
        Opplogid.Opportunity_Auto_Renew__c	 = oppLogMatch.Auto_Renew__c;
        Opplogid.Opportunity_Billing_Email__c	 = oppLogMatch.Billing_Email__c;
        /*Opplogid.Opportunity_Email_URL__c	 = oppLogMatch.Email_URL__c;
Opplogid.Opportunity_Email_WebSite_URL__c	 = oppLogMatch.Email_WebSite_URL__c;*/
        Opplogid.Opportunity_Event_Order__c	 = oppLogMatch.Event_Order__c;
        Opplogid.Opportunity_Exam_Registration_Modificati__c	 = oppLogMatch.Exam_Registration_Modification__c;
        Opplogid.Opportunity_Frm1__c	 = oppLogMatch.Frm1__c;
        Opplogid.Opportunity_Frm2__c	 = oppLogMatch.Frm2__c;
        Opplogid.Opportunity_Has_Books__c	 = oppLogMatch.Has_Books__c;
        Opplogid.Opportunity_Invoice_Payment_Status__c	 = oppLogMatch.Invoice_Paid_status__c;
        Opplogid.Opportunity_Is_Exam_Cancelled__c	 = oppLogMatch.Is_Exam_Cancelled__c;
        Opplogid.Opportunity_Membership_Bought__c	 = oppLogMatch.Membership_Emails__c;
        Opplogid.Opportunity_Membership_Emails__c    = oppLogMatch.Membership_Emails__c;
        Opplogid.Opportunity_Method_of_Payment_Code__c	 = oppLogMatch.Alternate_Method_of_Payment__c;
        Opplogid.Opportunity_Opportunity_Record_Type__c	 = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosById().get(oppLogMatch.recordTypeId).getName();
        Opplogid.Opportunity_Payment_Method__c	 = oppLogMatch.Payment_Method_New__c;
        Opplogid.Opportunity_Payment_Method_Calc__c	 = oppLogMatch.Payment_Method__c;
        Opplogid.Opportunity_Payment_Status__c	 = oppLogMatch.ChargentSFA__Payment_Status__c;
        Opplogid.Opportunity_Previous_Memerbship__c	 = oppLogMatch.Previous_Memerbship__c;
        Opplogid.Opportunity_Risk_net__c	 = oppLogMatch.Risk_net__c;
        Opplogid.Opportunity_Ship_Check__c	 = oppLogMatch.Ship_Check__c;
        Opplogid.Opportunity_Stage__c	 = oppLogMatch.StageName;
        Opplogid.Opportunity_Type__c	 = oppLogMatch.Type;
        Opplogid.Opportunity_Yardstick_Welcome_Email_Sent__c	 = oppLogMatch.Yardstick_Welcome_Email_Sent_Date__c;
        
        System.debug('Opplogid::'+Opplogid);
        insert Opplogid;
        
    }
    
}