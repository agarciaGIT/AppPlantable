public class GARP_MS_Shipping {
    
    public class shipOrderCustomer {
        @AuraEnabled Public String contactId {get;set;}
    }
    
    public class shipOrderAddress {
        @AuraEnabled Public String countryCode {get;set;}
    }

    public class shipOrderLineItem {
        @AuraEnabled Public String productCode {get;set;}
        @AuraEnabled Public String glCode {get;set;}
        @AuraEnabled Public Integer quantity {get;set;}
        @AuraEnabled Public Boolean needsShipping {get;set;}
    }
    
    public class shipOrder {
        @AuraEnabled Public shipOrderCustomer customer {get;set;}
        @AuraEnabled Public shipOrderAddress address {get;set;}
        @AuraEnabled Public List<shipOrderLineItem> lineItems {get;set;}
    }
    
    
    public static Shipping_Charge__c getShippingRate(String productCode, String glCode, String countryCode){
        return GARP_BC_Shipping.getShippingRate(productCode, glCode, countryCode);
    }

    @RemoteAction
    public static Shipping_Charge__c getShippingRate(GARP_MS_Shipping.shipOrder shipOrder){
        return GARP_BC_Shipping.getShippingRate(shipOrder);
    }

    public GARP_MS_Shipping(sfdcAppRemoter ctrl){}
}