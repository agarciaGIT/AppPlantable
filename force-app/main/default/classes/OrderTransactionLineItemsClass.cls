public class OrderTransactionLineItemsClass {

    public class processingError {
        public String oppID { get; set; }
        public String errMsg { get; set; }
    }

    // Verify nothing getting approved has an older non-approved transaction
    public static Boolean onSetStatus(Set<String> orderTransItemIds) {
        Boolean ret = True;
        
        List<Order_Transaction_Item__c> lstOrderTransItems = [select Id, Status__c, Paid_Date_Time__c, Opportunity__c, Opportunity__r.AccountID, Transaction__c from Order_Transaction_Item__c where id in :orderTransItemIds];
        
        MAP<String,DateTime> mapAccountIDsApprovedByDate = new MAP<String,DateTime>();
        DateTime leastDate;
        for(Order_Transaction_Item__c oti :lstOrderTransItems) {
            if(oti.Status__c == 'Approved' && oti.Paid_Date_Time__c != NULL) {
                System.debug('oti:' + oti);
                
                DateTime lastDate = mapAccountIDsApprovedByDate.get(oti.Opportunity__r.AccountID);    
                System.debug('lastDate:' + lastDate);
                
                // Update oldest date by account
                if(lastDate == NULL || oti.Paid_Date_Time__c < lastDate) {
                    mapAccountIDsApprovedByDate.put(oti.Opportunity__r.AccountID,oti.Paid_Date_Time__c);
                }
                
                // Find the oldest date
                if(leastDate == NULL || oti.Paid_Date_Time__c < lastDate) {
                    leastDate = oti.Paid_Date_Time__c;
                }
            }
        }
        
        List<Order_Transaction_Item__c> lstOldOrderTransItems = [select Id, Status__c, Paid_Date_Time__c, Opportunity__c, Opportunity__r.AccountID, Transaction__c 
                                                              from Order_Transaction_Item__c where Opportunity__r.AccountID in :mapAccountIDsApprovedByDate.keySet() AND 
                                                              Paid_Date_Time__c < :leastDate];
        for(Order_Transaction_Item__c oti :lstOldOrderTransItems) {
            DateTime lastDate = mapAccountIDsApprovedByDate.get(oti.Opportunity__r.AccountID);
            if(lastDate != NULL && oti.Paid_Date_Time__c < lastDate && oti.Status__c != 'Approved') {
                // Error have older transaction not yet approved
                return False;
            }
        }
        
        return ret;
    }
    
    public static Boolean setOrders(Set<String> oppIds) {
        Boolean ret;
        
        List<processingError> errs = new List<processingError>();
        
        List<Order_Transaction_Item_Map__c> orderTransMap = [select Name, Company__c, Field_Name__c, GL_Code__c, Is_Shipping__c, Product_Code__c, Sort_Order__c, Source_GL_Codes__c, Source_Product_Codes__c, Weight__c from Order_Transaction_Item_Map__c];
        System.debug('orderTransMap:' + orderTransMap);        
        
        // Setup MAP
        MAP<String,Order_Transaction_Item_Map__c> mapOrderTransMap = new MAP<String,Order_Transaction_Item_Map__c>();
        MAP<String,Order_Transaction_Item_Map__c> mapOrderTransShipMap = new MAP<String,Order_Transaction_Item_Map__c>();
        for(Order_Transaction_Item_Map__c otim :orderTransMap) {
            if(otim.Source_GL_Codes__c!=NULL && otim.Source_Product_Codes__c!=NULL) {
                if(otim.Is_Shipping__c) {
                    for(String glkey: otim.Source_GL_Codes__c.split(';')){
                        for(String pckey: otim.Source_Product_Codes__c.split(';')){
                            mapOrderTransShipMap.put(pckey + '~' + glkey,otim);
                        }
                    }                    
                } else {
                    for(String glkey: otim.Source_GL_Codes__c.split(';')){
                        for(String pckey: otim.Source_Product_Codes__c.split(';')){
                            mapOrderTransMap.put(pckey + '~' + glkey,otim);
                        }
                    }
                }
            }
        }
        System.debug('mapOrderTransMap:' + mapOrderTransMap);        
        
        List<Opportunity> lstOpps = [select id, name, Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name, Shipping_Country__c, Shipping_State__c,
                                     Member_First_Name__c, Member_Last_Name__c, GARP_Member_ID__c, Display_Invoice_Number__c, Company__c,
                                     (SELECT Id,Description,ProductCode,Product2Id,PricebookEntryId,Quantity,UnitPrice,SortOrder,TotalPrice,PricebookEntry.product2.Id, Product2.GL_Code__c FROM OpportunityLineItems) from Opportunity where id in :oppIds];
        System.debug('lstOpps:' + lstOpps);  
        
        List<ChargentSFA__Transaction__c> lstTrans = [select Id, Name, ChargentSFA__Gateway_Date__c, ChargentSFA__Gateway_Response__c, ChargentSFA__Payment_Method__c,
                                                      ChargentSFA__Amount__c, ChargentSFA__Type__c, ChargentSFA__Opportunity__c from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c in :oppIds];
        System.debug('lstTrans:' + lstTrans);  
        
        Set<String> transIds = new Set<String>();  
        MAP<String,List<ChargentSFA__Transaction__c>> mapOppTrans = new MAP<String,List<ChargentSFA__Transaction__c>>();
        for(ChargentSFA__Transaction__c trans :lstTrans) {
            transIds.add(trans.id);
            List<ChargentSFA__Transaction__c> fndTrans = mapOppTrans.get(trans.ChargentSFA__Opportunity__c);
            if(fndTrans == NULL) {
                List<ChargentSFA__Transaction__c> newLstTrans = new List<ChargentSFA__Transaction__c>();
                newLstTrans.add(trans);
                mapOppTrans.put(trans.ChargentSFA__Opportunity__c,newLstTrans);
            } else {
                fndTrans.add(trans);
                mapOppTrans.put(trans.ChargentSFA__Opportunity__c,fndTrans);
            }
        }
        System.debug('mapOppTrans:' + mapOppTrans);  
        
        List<Product_Refunds__c> prs = [select Id, Payment_Transaction__c, Payment_Transaction__r.ChargentSFA__Tokenization__c, Opportunity__c, 
                                        Product__c, Product_Code__c, GL_Code__c, Reason__c, Refund_amount__c, Refund_Code__c, Sales_Price__c, Status__c, 
                                        Unique_Id__c, CreatedDate from Product_Refunds__c where Status__c = 'Completed' AND Opportunity__c in :oppIds and Payment_Transaction__c in :transIds];
        System.debug('prs:' + prs);  
        
        MAP<String,Product_Refunds__c> mapRefunds = new MAP<String,Product_Refunds__c>();
        for(Product_Refunds__c ref :prs) {
            mapRefunds.put(ref.Opportunity__c + '~' + ref.Product_Code__c + '~' + ref.GL_Code__c, ref);
        }
        System.debug('mapRefunds:' + mapRefunds);  
        
        List<Order_Transaction_Item__c> olis = [select Id, Status__c, Opportunity__c, Transaction__c from Order_Transaction_Item__c where Opportunity__c in :oppIds];
        System.debug('olis:' + olis);
            
        MAP<String,Order_Transaction_Item__c> mapOrderLineItemsOppTrans = new MAP<String,Order_Transaction_Item__c>();
        for(Order_Transaction_Item__c li :olis) {
            mapOrderLineItemsOppTrans.put(li.Opportunity__c + '~' + li.Transaction__c, li);            
        }
        System.debug('mapOrderLineItemsOppTrans:' + mapOrderLineItemsOppTrans);
        
        // Get Fields
        SObjectType accountType = Schema.getGlobalDescribe().get('Order_Transaction_Item__c');
        Map<String,Schema.SObjectField> mfields = accountType.getDescribe().fields.getMap();
        System.debug('mfields:' + mfields);
        
        // set Order Line Items
        List<Order_Transaction_Item__c> removeOrderLineItems = new List<Order_Transaction_Item__c>();
        List<Order_Transaction_Item__c> addOrderLineItems = new List<Order_Transaction_Item__c>();
        for(Opportunity opp :lstOpps) {
            
            // Begin Processing Items
            List<ChargentSFA__Transaction__c> fndTrans = mapOppTrans.get(opp.id);
            System.debug('fndTrans:' + fndTrans);             
            if(fndTrans != NULL) {                
                for(ChargentSFA__Transaction__c trans :fndTrans) {
                    
                    Order_Transaction_Item__c fndOrderTransItem = mapOrderLineItemsOppTrans.get(opp.id + '~' + trans.id);
                    System.debug('fndOrderTransItem:' + fndOrderTransItem); 
                    
                    if(fndOrderTransItem == NULL) {
                        
                        Order_Transaction_Item__c newOrderTransItem = new Order_Transaction_Item__c(
                            Opportunity__c = opp.id,
                            Transaction__c = trans.id,
                            Paid_Date_Time__c = trans.ChargentSFA__Gateway_Date__c,
                            Payment_Method__c = trans.ChargentSFA__Payment_Method__c,
                            Exam_Site__c = opp.Deferred_Exam_Registration__r.Exam_Site__r.Site__r.Name,
                            Country__c = opp.Shipping_Country__c,
                            State__c = opp.Shipping_State__c,
                            First_Name__c = opp.Member_First_Name__c,
                            Last_Name__c = opp.Member_Last_Name__c,
                            GARP_ID__c = opp.GARP_Member_ID__c,
                            Invoice_Number__c = opp.Display_Invoice_Number__c,
                            Transaction_Type__c = (trans.ChargentSFA__Type__c == 'Charge Back Accepted') ? 'Charge Back' : 
                            (trans.ChargentSFA__Type__c == 'Charge Back Loss') ?  'Charge Back' : trans.ChargentSFA__Type__c,
                            Company__c = opp.Company__c,
                            Is_NJ__c = (opp.Shipping_State__c == 'New Jersey') ? True:False,
                            Charge_Back_Status__c = (trans.ChargentSFA__Type__c == 'Charge Back Accepted') ? 'Accepted' : 
                            (trans.ChargentSFA__Type__c == 'Charge Back Loss') ?  'Loss' : NULL
                        );
                        
                        if(trans.ChargentSFA__Gateway_Response__c != NULL) {
                            Pattern p = Pattern.compile('^.*PNREF=([^&]*)&.*$');
                            Matcher pm = p.matcher( trans.ChargentSFA__Gateway_Response__c );
                            
                            if( pm.matches() ){
                                newOrderTransItem.Gateway_ID__c = pm.group(1);
                            }
                        }
                        System.debug('newOrderTransItem:' + newOrderTransItem); 
                        
                        // Loop over Line Items to get shipment totals
                        Decimal totalWeight=0;
                        Integer totalShipments=0;
                        for(OpportunityLineItem line :opp.OpportunityLineItems) {
                            Order_Transaction_Item_Map__c mp = mapOrderTransShipMap.get(line.ProductCode + '~' + line.Product2.GL_Code__c);
                            System.debug('Ship mp:' + mp); 
                            
                            if(mp != NULL && mp.Is_Shipping__c && mp.Weight__c != NULL) {
                                totalWeight+= mp.Weight__c;
                                totalShipments++;
                            }
                        }
                        System.debug('totalWeight:' + totalWeight);
                        
                        
                        newOrderTransItem.Total_Amount__c=trans.ChargentSFA__Amount__c;
                        System.debug('Total_Amount__c:' + newOrderTransItem.Total_Amount__c);
                        
                        if(trans.ChargentSFA__Type__c == 'Refund' || trans.ChargentSFA__Type__c == 'Credit' || 
                           trans.ChargentSFA__Type__c == 'Charge Back Accepted' || trans.ChargentSFA__Type__c == 'Charge Back Loss') {
                               
                               if(newOrderTransItem.Total_Amount__c > 0) {
                                   newOrderTransItem.Total_Amount__c = newOrderTransItem.Total_Amount__c * -1;    
                               }
                               
                           }
                        System.debug('Make Negative:' + newOrderTransItem.Total_Amount__c);
                        
                        // Loop over Line Items to get product amounts
                        for(OpportunityLineItem line :opp.OpportunityLineItems) {
                            
                            System.debug('line:' + line);
                            
                            Order_Transaction_Item_Map__c mp = mapOrderTransMap.get(line.ProductCode + '~' + line.Product2.GL_Code__c);
                            System.debug('mp:' + mp);
                            
                            Order_Transaction_Item_Map__c mpShip = mapOrderTransShipMap.get(line.ProductCode + '~' + line.Product2.GL_Code__c);
                            System.debug('mpShip:' + mpShip);
                            
                            
                            if(mp != NULL) {
                                
                                Decimal amt = line.TotalPrice;
                                // If refund transaction, match product refund else skip
                                if(trans.ChargentSFA__Type__c == 'Refund') {
                                    Product_Refunds__c fndRefund = mapRefunds.get(opp.Id + '~' + line.ProductCode + '~' + line.Product2.GL_Code__c);
                                    if(fndRefund == NULL) {
                                        continue;
                                    }
                                }
                                System.debug('After refund:' + trans.ChargentSFA__Type__c);
                                
                                // Prorate shipping
                                if(mpShip != NULL && mpShip.Is_Shipping__c && mpShip.Weight__c != NULL) {
                                    amt = amt * (mpShip.Weight__c / totalWeight);
                                    mp = mpShip;
                                }
                                System.debug('Prorate shipping:' + amt);
                                
                                // Make negative for certain transaction types
                                if(trans.ChargentSFA__Type__c == 'Refund' || trans.ChargentSFA__Type__c == 'Credit' || 
                                   trans.ChargentSFA__Type__c == 'Charge Back Accepted' || trans.ChargentSFA__Type__c == 'Charge Back Loss') {  
                                       if(amt > 0) {
                                           amt = amt * -1; 
                                       }
                                   }
                                System.debug('Make negative:' + amt);
                                
                                // Set the product amount
                                Decimal curAmt = 0;
                                Schema.SObjectField fndField = mfields.get(mp.Field_Name__c);
                                if(fndField != NULL) {
                                    Object val = newOrderTransItem.get(mp.Field_Name__c);
                                    if(val != NULL) {
                                        curAmt = (Decimal)newOrderTransItem.get(mp.Field_Name__c);    
                                    }
                                    System.debug('Get curAmt:' + amt);
                                } else {
                                    processingError pe = new processingError();
                                    pe.oppID = opp.id;
                                    pe.errMsg = 'Field missing: ' + mp.Field_Name__c;
                                    errs.add(pe);    
                                }
                                
                                curAmt += amt;                        
                                newOrderTransItem.put(mp.Field_Name__c,curAmt);
                                System.debug('Add curAmt:' + newOrderTransItem);
                                
                            }
                            
                        }
                        addOrderLineItems.add(newOrderTransItem);
                    }
                }
            }
        }
        delete removeOrderLineItems;
        insert addOrderLineItems;
        
        System.debug('Errors~~~~~~~~~~~~~~~~~~~~~~~');
        System.debug('errs:' + errs);
        System.debug('~~~~~~~~~~~~~~~~~~~~~~~');
        
        return ret;
    }

}