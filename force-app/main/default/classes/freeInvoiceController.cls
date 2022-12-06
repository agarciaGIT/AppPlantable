public class freeInvoiceController {
    public static Opportunity opps;
    public static List<OpportunityLineItem> oppLineItms = new List<OpportunityLineItem>{};
    Public static set<String> ProductCodes = new set<String>{'FRM1','SCR','ENC1'};
    Public static String GLcode = '4020';
    @AuraEnabled 
    public static void cloneOpp(String InvoiceNumber){
        
        // cloning opp with products
        Opportunity opp = [select id,Name,AccountId,Exam_Comp_Type__c,ChinaLocationFee__c,Amount,StageName,Type,Exam_Emails__c,Risk_net_fee__c,CloseDate ,
                           ChargentSFA__Billing_First__c,ChargentSFA__Billing_Last__c,ChargentSFA__Billing_Email__c,ChargentSFA__Billing_Phone__c,
                           ChargentSFA__Billing_Address__c,ChargentSFA__Billing_Address_Line_2__c,ChargentSFA__Billing_City__c,ChargentSFA__Billing_State__c,
                           ChargentSFA__Billing_Country__c,ChargentSFA__Billing_Zip__c,ChargentSFA__Billing_Company__c,Additional_Invoice_Information__c,
                           ChargentSFA__Payment_Method__c,ChargentSFA__Payment_Received__c,ChargentSFA__Gateway__c,ChargentSFA__Card_Name__c,ChargentSFA__Card_Type__c,
                           ChargentSFA__Charge_Amount__c ,Program__c ,Institutional_Sale_Stage__c ,Membership_Fee__c ,FRM_1_Registration_Fee__c ,
                           FRM_2_Registration_Fee__c ,ERP_Registration_Fee__c ,ERP_1_Registration_Fee__c ,ERP_2_Registration_Fee__c ,FRM_Enrollment_Fee__c ,ERP_Enrollment_Fee__c ,
                           Probability ,Company__c ,ChargentSFA__Currency__c , Current_Member_Type__c ,Exam_Registration_Modification__c ,Sub_Program__c ,Alternate_Method_of_Payment__c,
                           Exam_Registration_Modification__r.Part_I_Exam_Registration__c,Exam_Registration_Modification__r.Part_II_Exam_Registration__c,
                           (select OpportunityId,Product2Id ,Description ,Product_company__c ,Exam_Site__c,UnitPrice,Quantity,Product_ID__c,PriceBookEntryid from OpportunityLineItems
                           where ProductCode IN: ProductCodes and product2.GL_Code__c =: GLcode)
                           from Opportunity where ChargentSFA__Invoice_Number__c =: InvoiceNumber];
        
        Set<Id> regIds = new Set<Id>();
        List<Exam_Attempt__c> regToUpdate = new List<Exam_Attempt__c>();
        if(opp.Exam_Registration_Modification__c != null){
            if(opp.Exam_Registration_Modification__r.Part_I_Exam_Registration__c != null){
                regIds.add(opp.Exam_Registration_Modification__r.Part_I_Exam_Registration__c);
            }
            if(opp.Exam_Registration_Modification__r.Part_II_Exam_Registration__c != null){
                regIds.add(opp.Exam_Registration_Modification__r.Part_II_Exam_Registration__c);
            }
        }
        
        if(!regIds.isEmpty()){
            List<Exam_Attempt__c> regList = [Select Id,Deferral_SubType__c from Exam_Attempt__c where Id IN: regIds];
            
            for(Exam_Attempt__c ea : regList){
                ea.Deferral_SubType__c = 'Deferral Free';
                regToUpdate.add(ea);
            }
        }
        
        Opportunity newOpp = opp.clone(false,true);
        newOpp.CloseDate  = system.Today();
        newopp.Deferral_SubType__c = 'Deferral Free';
        system.debug('newOpp.CloseDate =====>'+newOpp.CloseDate );
        Insert newOpp;
        system.debug('Id======>'+newOpp.id);
        system.debug('opp.OpportunityLineItems=======>'+opp.OpportunityLineItems);
        system.debug('opp.OpportunityLineItems.PriceBookEntryid=======>'+opp.OpportunityLineItems[0].PriceBookEntryid); 
        for(OpportunityLineItem oli : newOpp.OpportunityLineItems ){
            OpportunityLineItem oliNew = oli.clone(false, true);
            oliNew.OpportunityId = newOpp.id;
            oliNew.UnitPrice = 0;
            oppLineItms.add(oliNew);
        }
        insert oppLineItms;
        ChargentBase__Gateway__c gateWay = [select id,name from ChargentBase__Gateway__c where name = 'paypal garp' LIMIT 1];
        ChargentSFA__Transaction__c trns = new ChargentSFA__Transaction__c ();
        trns.ChargentSFA__Gateway_Date__c = system.now();
        trns.ChargentSFA__Opportunity__c = newOpp.id;
        trns.ChargentSFA__Gateway__c = gateWay.id;
        trns.ChargentSFA__Amount__c = 0.0;
        trns.ChargentSFA__Type__c = 'Charge';
        trns.ChargentSFA__Payment_Method__c ='free';
        trns.ChargentSFA__Response_Message__c  = 'Approved';
        trns.ChargentSFA__Response_Status__c = 'Approved';
        insert trns;
        
        if(!regToUpdate.isEmpty()){
            update regToUpdate;
        }
        
    }
}