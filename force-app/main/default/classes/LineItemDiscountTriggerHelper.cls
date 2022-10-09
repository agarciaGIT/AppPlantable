/* Note: This approach need each OpportunityLineItem under same Opportunity has a unique product
 * 06/10/2019 Xiang - [US-22178] Created. Auto populate Product Discount upon saving, and create placeholder Opportunity Line Item
 */
public without sharing class LineItemDiscountTriggerHelper {
    
    private static String placeHolderProduct = 'Inst Sale Total Discount';
    private static String instSaleLineItemDesc = 'System generated line item to reflect total discount amount. Do NOT modify.';
    
    // Valid Discount = Has Product Id, has either Discount Percent or Discount Amount
    public static void processBeforeInsert(List<Line_Item_Discount__c> itemDiscList) {
        List<Line_Item_Discount__c> validDiscList = new List<Line_Item_Discount__c>();
        
        for(Line_Item_Discount__c itemDisc : itemDiscList) {
            if(null != itemDisc.Product__c && hasDiscountValue(itemDisc)) {
                validDiscList.add(itemDisc);
            }
        }
        
        processDicounts(validDiscList);
    }
    
    // Valid Discount and has value changes
    public static void processBeforeUpdate(List<Line_Item_Discount__c> updtList, Map<Id, Line_Item_Discount__c> oldMap) {
        List<Line_Item_Discount__c> validDiscList = new List<Line_Item_Discount__c>();
        
        for(Line_Item_Discount__c itemDisc : updtList) {
            if(null != itemDisc.Product__c && hasDiscountValue(itemDisc)) {
                Line_Item_Discount__c oldDisc = oldMap.get(itemDisc.Id);
                
                if(itemDisc.Discount_Percent__c != oldDisc.Discount_Percent__c ||
                   itemDisc.Discount_Amount__c != oldDisc.Discount_Amount__c ||
                   itemDisc.Product__c != oldDisc.Product__c) {
                    validDiscList.add(itemDisc);
                }
            }
        }
        
        processDicounts(validDiscList);
    }
    
    // Process valid Discounts
    private static void processDicounts(List<Line_Item_Discount__c> itemDiscList) {
        // Gather related Opportunity Ids - MasterDetail, always present.
        Set<Id> oppIds = new Set<Id>();
        for(Line_Item_Discount__c itemDisc : itemDiscList) {
            oppIds.add(itemDisc.Opportunity__c);
        }
        
        // Fetch related Opportunities along with Line Items
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>(
            [SELECT Id, (SELECT Id, Product2Id, Quantity, UnitPrice, TotalPrice FROM OpportunityLineItems) FROM Opportunity WHERE Id In :oppIds]
        );
        
        // Populate Discount fields
        for(Line_Item_Discount__c itemDisc: itemDiscList) {
            Opportunity opp = oppMap.get(itemDisc.Opportunity__c);
            Map<Id, OpportunityLineItem> prodIdToItem = getProdToItemMap(opp);
            
            OpportunityLineItem lineItem = prodIdToItem.get(itemDisc.Product__c);
            if(null != lineItem) {
                Decimal targetPrice = lineItem.UnitPrice;
                
                itemDisc.Line_Item_Id__c = lineItem.Id;
                itemDisc.Line_Item_Quantity__c = lineItem.Quantity;
                if(itemDisc.Discount_Percent__c != null) {
                    itemDisc.Discount_Amount__c = itemDisc.Discount_Percent__c * targetPrice / (Decimal)100;
                }else if(itemDisc.Discount_Amount__c != null) {
                    itemDisc.Discount_Percent__c = (Decimal)100 * itemDisc.Discount_Amount__c / targetPrice;
                }
            }
        }
    }
    
    // Valid Discount will have Line_Item_Id__c populated from before trigger
    public static void processAfterInsert(List<Line_Item_Discount__c> itemDiscList) {
		Set<Id> oppIds = new Set<Id>();
        
        for(Line_Item_Discount__c itemDisc : itemDiscList) {
            if(null != itemDisc.Line_Item_Id__c) {
                oppIds.add(itemDisc.Opportunity__c);
            }
        }
        
        processPlaceholderLineItem(oppIds);
    }
    
    // Valid Discount and has value changes
    public static void processAfterUpdate(List<Line_Item_Discount__c> updtList, Map<Id, Line_Item_Discount__c> oldMap) {
        Set<Id> oppIds = new Set<Id>();
        
        for(Line_Item_Discount__c itemDisc : updtList) {
            if(null != itemDisc.Line_Item_Id__c) {
                Line_Item_Discount__c oldDisc = oldMap.get(itemDisc.Id);
                
                if(itemDisc.Discount_Percent__c != oldDisc.Discount_Percent__c ||
                   itemDisc.Discount_Amount__c != oldDisc.Discount_Amount__c ||
                   itemDisc.Product__c != oldDisc.Product__c) {
                    oppIds.add(itemDisc.Opportunity__c);
                }
            }
        }
        
        processPlaceholderLineItem(oppIds);
    }
    
    // Create a placeholder Opportunity Line Item to adjust discount amount
    private static void processPlaceholderLineItem(Set<Id> oppIds) {
        List<Product2> discProd = [SELECT Id FROM Product2 WHERE Name = :placeHolderProduct LIMIT 1];
        
        if(discProd.size() > 0) {
            Id discProdId = discProd[0].Id;
            List<OpportunityLineItem> updtOliList = new List<OpportunityLineItem>();
            List<Opportunity> oppList = [SELECT Id, 
                                         (SELECT Id, UnitPrice FROM OpportunityLineItems WHERE Product2Id = :discProdId),
                                         (SELECT Id, Discount_Amount__c, Line_Item_Quantity__c FROM Line_Item_Discounts__r WHERE Line_Item_Id__c != NULL)
                                         FROM Opportunity WHERE Id IN :oppIds AND Institutional_Sale__c = true AND Inst_Sale_Opp__c = null];
            
            for(Opportunity opp : oppList) {
                OpportunityLineItem oli;
                if(opp.OpportunityLineItems.size() > 0) {
                    oli = opp.OpportunityLineItems[0];
                }else {
                    oli = new OpportunityLineItem(Is_Inst_Sale_Discount__c = true, OpportunityId = opp.Id, Quantity = 1, UnitPrice = 0, Product2Id = discProdId, Description = instSaleLineItemDesc);
                }
                
                Decimal totalDisc = 0;
                for(Line_Item_Discount__c itemDisc : opp.Line_Item_Discounts__r) {
                    System.debug(itemDisc);
                    totalDisc += itemDisc.Discount_Amount__c * itemDisc.Line_Item_Quantity__c;
                }
                oli.UnitPrice = -1 * totalDisc;
                
                updtOliList.add(oli);
            }
            
            upsert updtOliList;
        }
    }
    
    private static Set<Id> deleteDiscountOppIds = new Set<Id>();
    
    // Gather affected Opportunity Ids before delete
    public static void gatherOppIds(List<Line_Item_Discount__c> oldList) {
        for(Line_Item_Discount__c discItem : oldList) {
            if(null != discItem.Line_Item_Id__c) {
                deleteDiscountOppIds.add(discItem.Opportunity__c);
            }
        }
    }
    
    // Recalculate Opportunity Amount after delete
    public static void recalculateOppAmount() {
        if(deleteDiscountOppIds.size() > 0) {
            processPlaceholderLineItem(deleteDiscountOppIds);
        }
    }
    
    // Utility Method
    private static Map<Id, OpportunityLineItem> getProdToItemMap(Opportunity opp) {
        Map<Id, OpportunityLineItem>  prodIdToItem = new Map<Id, OpportunityLineItem>();
        for(OpportunityLineItem lineItem : opp.OpportunityLineItems) {
            prodIdToItem.put(lineItem.Product2Id, lineItem);
        }
        
        return prodIdToItem;
    }
    
    private static Boolean hasDiscountValue(Line_Item_Discount__c itemDisc) {
        return (itemDisc.Discount_Percent__c != null || itemDisc.Discount_Amount__c != null);
    }
}