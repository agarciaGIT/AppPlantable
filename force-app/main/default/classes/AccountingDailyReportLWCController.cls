public class AccountingDailyReportLWCController { 
    @AuraEnabled
    public static Map<String,List<OpportunityLineItem>> getAccountingDailyReport(List<String> intacctTransaction,List<String> paymentMethod,Date startDate,Date endDate) {
        Map<String,List<OpportunityLineItem>> oppLineItemsMap = new Map<String,List<OpportunityLineItem>>();
        
        for(OpportunityLineItem opp:[select id,Opportunity.ChargentSFA__Billing_State__c,Opportunity.ChargentSFA__Billing_Country__c,Opportunity.Amount,Opportunity.ia_crm__Intacct_Transaction__c,OpportunityId,Opportunity.Company__c,Opportunity.GARP_Member_ID__c,Opportunity.AccountId,Opportunity.Account.Name,Opportunity.ContactId,Opportunity.Display_Invoice_Number__c,
                                     Opportunity.Sage_Document_Number__c,Opportunity.Shipping_Country__c,Opportunity.Shipping_State__c,Opportunity.ChargentSFA__Payment_Method__c,
                                     Opportunity.ChargentSFA__Card_Type__c,Opportunity.Sage_Paid_Date__c,Product_ID__c,ServiceDate,Opportunity.ChargentSFA__Tokenization__c, 
                                     ia_crm__Class__c,Site_Code__c,Intacct_Template__c,ia_crm__Class__r.Name,Site_Code__r.name,Intacct_Template__r.name,
                                     TotalPrice from OpportunityLineItem where Opportunity.StageName = 'Closed' and Opportunity.ia_crm__Intacct_Transaction__c In:intacctTransaction and Opportunity.Sage_Paid_Date__c >=:startDate and Opportunity.Sage_Paid_Date__c <=:endDate and Opportunity.ia_crm__Intacct_Sync_Status_1__c != 'OK' and Product_ID__c != 'MEMA' and Opportunity.ChargentSFA__Payment_Method__c In:paymentMethod and Product_Family__c != 'Events' order by Opportunity.Count_of_OrderItems__c desc,TotalPrice desc]){
                                         if(oppLineItemsMap.containsKey(opp.OpportunityId)){
                                             List<OpportunityLineItem> tempdata = oppLineItemsMap.get(opp.OpportunityId);
                                             tempdata.add(opp);
                                             oppLineItemsMap.put(opp.OpportunityId,tempdata);
                                         } else{  
                                             oppLineItemsMap.put(opp.OpportunityId,new List<OpportunityLineItem>{opp});
                                         }
                                         
                                     }
        return oppLineItemsMap;
    } 
    
    @AuraEnabled
    public static string insertOrderTransactionItems(List<String> opportunityIds){
        String message;
        try{
            if(!opportunityIds.isEmpty()){
                List<Order_Transaction_Item__c> orderTransactionList = new List<Order_Transaction_Item__c>();
                
                for(String oppid:opportunityIds){ 
                    Order_Transaction_Item__c opptr = new Order_Transaction_Item__c();
                    opptr.Status__c = 'Approved';
                    opptr.Opportunity__c = oppid;
                    orderTransactionList.add(opptr); 
                }
                
                if(!orderTransactionList.isEmpty()){
                    insert orderTransactionList;
                }
                message = 'Success';
            }
        }catch(Exception ex){
            message = ex.getMessage();
        }
        return message;
    }
}