public class GARP_BC_Shipping {

    public static Shipping_Charge__c getShippingRate(String productCode, String glCode, String countryCode){
        Shipping_Charge__c ret;
        
        if(countryCode != NULL && glCode != NULL && countryCode.length() > 0 && glCode.length() > 0) {
            List<Shipping_Charge__c> lstShip = [select id, Shipping_Charge__c from Shipping_Charge__c where Product_Code__c = :productCode AND GL_Code__c = :glCode AND Country_Code__r.LetterCode__c = :countryCode];
            if(!lstShip.isEmpty()) {
                ret = lstShip[0];
            }
        }
        return ret;
    }
    

    public static Shipping_Charge__c getShippingRate(GARP_MS_Shipping.shipOrder shipOrder){
        Shipping_Charge__c ret;
        
        
        if(shipOrder == NULL || shipOrder.lineItems == NULL || shipOrder.address == NULL || shipOrder.address.countrycode == NULL) {
            return ret;
        }

        System.debug('shipOrder:' + shipOrder);

        
        Set<String> prodCodes = new Set<String>();
        Set<String> glCodes = new Set<String>();
        
        Integer totalQuantity = 0;
        for(GARP_MS_Shipping.shipOrderLineItem lineItem :shipOrder.lineItems) {
            prodCodes.add(lineItem.productCode);
            glCodes.add(lineItem.glCode);
        }
        
        System.debug('prodCodes:' + prodCodes);
        System.debug('glCodes:' + glCodes);
        
        if(prodCodes.size() > 0) {
            GARP_MS_Shipping.shipOrderLineItem lineItem = shipOrder.lineItems[0];

            List<Shipping_Charge__c> lstShip = [select id, Shipping_Charge__c, Product_Code__c, GL_Code__c 
                                                from Shipping_Charge__c 
                                                where 
                                                Product_Code__c <> NULL AND
                                                GL_Code__c <> NULL AND
                                                Country_Code__r.LetterCode__c <> NULL AND
                                                Product_Code__c in :prodCodes AND 
                                                GL_Code__c in :glCodes AND 
                                                Country_Code__r.LetterCode__c = :shipOrder.address.countrycode];
            System.debug('lstShip:' + lstShip);
            MAP<String,Shipping_Charge__c> mapShipCharges = new MAP<String,Shipping_Charge__c>();
                        
            if(!lstShip.isEmpty()) {

                for(Shipping_Charge__c sc :lstShip) {
                    mapShipCharges.put(sc.Product_Code__c + '~' + sc.GL_Code__c,sc);
                }
                
                for(GARP_MS_Shipping.shipOrderLineItem li :shipOrder.lineItems) {
                    Shipping_Charge__c fndShipCharge = mapShipCharges.get(li.productCode + '~' + li.glCode);
                    if(fndShipCharge != NULL) {
                        totalQuantity += li.quantity;                    
                    }
                }
                
                if(totalQuantity > 1) {
                    if(shipOrder.address.countrycode == 'US') {
                        ret = new Shipping_Charge__c(
                            Shipping_Charge__c = 70
                        );                        
                        
                    } else {
                        ret = new Shipping_Charge__c(
                            Shipping_Charge__c = 165
                        );                        
                    }
                } else {
                    ret = lstShip[0];    
                }
            }
        }
        
        return ret;
    }

    public static List<OpportunityLineItem> stageShippingOpportunityLineItems(GARP_MS_Shipping.shipOrder shipOrder){
        
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        Integer numberOfShippableProducts = 0;
        Decimal totalShippingCost = 0;
        
        Set<String> prodCodes = new Set<String>();
        Set<String> glCodes = new Set<String>();
        
        Integer totalQuantity = 0;
        for(GARP_MS_Shipping.shipOrderLineItem lineItem :shipOrder.lineItems) {
            prodCodes.add(lineItem.productCode);
            glCodes.add(lineItem.glCode);
        }
        
        System.debug('prodCodes:' + prodCodes);
        System.debug('glCodes:' + glCodes);
        
        Set<String> shippableProductIds = new Set<String>();
        for(PricebookEntry pbe: [
            SELECT Id, Product2.Id, Product2.Weight__c, Product2.Taxable__c, Product2.ProductCode, Product2.GL_Code__c
            FROM PricebookEntry 
            WHERE Product2.ProductCode in :prodCodes AND Product2.GL_Code__c in :glCodes AND
            IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE
        ]){
            if(pbe.Product2.Weight__c != null && pbe.Product2.Weight__c > 0){
                shippableProductIds.add(pbe.Product2.Id);
            }
        } 
        numberOfShippableProducts = shippableProductIds.size();
        
        system.debug('numberOfShippableProducts:' + shippableProductIds);
        
        Shipping_Charge__c fndShipRate = GARP_MS_Shipping.getShippingRate(shipOrder);
        system.debug('fndShipRate:' + fndShipRate);
        
        if(fndShipRate != NULL) {
            
            totalShippingCost = fndShipRate.Shipping_Charge__c;
                        
            // --- New logic for Sage
            List<PricebookEntry> pbeShip = [
                SELECT Id, UnitPrice, ProductCode, Product2Id, Product2.Name, Product2.Weight__c, Product2.Taxable__c, Product2.Product_ID__c, Pricebook2Id
                FROM PricebookEntry 
                WHERE IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE AND 
                ProductCode in ('SHIPFRM1','SHIPFRM2','SHIPSCR','SHIPFRR','SHIPFFR')
            ];
            system.debug('pbeShip:' + pbeShip);
            
            if(!pbeShip.isEmpty()) {
                MAP<String,PricebookEntry> mapShipPrices = new MAP<String,PricebookEntry>();
                for(PricebookEntry pbes :pbeShip) {
                    mapShipPrices.put(pbes.ProductCode, pbes);
                }
                system.debug('mapShipPrices:' + mapShipPrices);
                
                for(GARP_MS_Shipping.shipOrderLineItem li :shipOrder.lineItems) {
                    
                    system.debug('li:' + li);
                    
                    if(li.productCode == 'FRM1H') {
                        
                        PricebookEntry fndPrice = mapShipPrices.get('SHIPFRM1');
                        if(fndPrice != NULL) {                        
                            OpportunityLineItem oli = new OpportunityLineItem(                               
                                PricebookEntryId    = fndPrice.Id,
                                Product2Id          = fndPrice.Product2Id,
                                UnitPrice           = totalShippingCost / numberOfShippableProducts,
                                Quantity            = 1,
                                Description         = fndPrice.Product2.Name
                            );
                            system.debug('oli:' + oli);
                            oppLineItems.add(oli);
                        }
                    } else if(li.productCode == 'FRM2H') {
                        PricebookEntry fndPrice = mapShipPrices.get('SHIPFRM2');
                        if(fndPrice != NULL) {                        
                            OpportunityLineItem oli = new OpportunityLineItem(                               
                                PricebookEntryId    = fndPrice.Id,
                                Product2Id          = fndPrice.Product2Id,
                                UnitPrice           = totalShippingCost / numberOfShippableProducts,
                                Quantity            = 1,
                                Description         = fndPrice.Product2.Name
                            );
                            oppLineItems.add(oli);
                        }
                    } else if(li.productCode == 'SCRH') {
                        PricebookEntry fndPrice = mapShipPrices.get('SHIPSCR');
                        if(fndPrice != NULL) {                        
                            OpportunityLineItem oli = new OpportunityLineItem(                               
                                PricebookEntryId    = fndPrice.Id,
                                Product2Id          = fndPrice.Product2Id,
                                UnitPrice           = totalShippingCost / numberOfShippableProducts,
                                Quantity            = 1,
                                Description         = fndPrice.Product2.Name
                            );
                            oppLineItems.add(oli);
                        }
                    } else if(li.productCode == 'CBRHI') {
                        PricebookEntry fndPrice = mapShipPrices.get('SHIPFRR');
                        if(fndPrice != NULL) {                        
                            OpportunityLineItem oli = new OpportunityLineItem(                               
                                PricebookEntryId    = fndPrice.Id,
                                Product2Id          = fndPrice.Product2Id,
                                UnitPrice           = totalShippingCost / numberOfShippableProducts,
                                Quantity            = 1,
                                Description         = fndPrice.Product2.Name
                            );
                            oppLineItems.add(oli);
                        }
                    } else if(li.productCode == 'FBRHB') {
                        PricebookEntry fndPrice = mapShipPrices.get('SHIPFFR');
                        if(fndPrice != NULL) {                        
                            OpportunityLineItem oli = new OpportunityLineItem(                               
                                PricebookEntryId    = fndPrice.Id,
                                Product2Id          = fndPrice.Product2Id,
                                UnitPrice           = totalShippingCost / numberOfShippableProducts,
                                Quantity            = 1,
                                Description         = fndPrice.Product2.Name
                            );
                            oppLineItems.add(oli);
                        }
                    }
                }
            }   
        }
        system.debug('oppLineItems:' + oppLineItems);
        return oppLineItems;
    }
    

}