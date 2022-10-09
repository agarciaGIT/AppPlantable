public class RegistrationFormShippingHelper {

    public static Response.Collection validateShippingSelection(Shipping_Charge__c shipping, Lead lead, Set<Id> pricebookEntryIds){
    
        Response.Collection response = new Response.Collection();
        
        if(shipping == NULL || shipping.Shipping_Charge__c == NULL) {
            response.status = 100;
            return response;
        }
    
        GARP_MS_Shipping.shipOrder shipOrder = new GARP_MS_Shipping.shipOrder();
        shipOrder.lineItems = new List<GARP_MS_Shipping.shipOrderLineItem>();

        //Create a set of all shippable study material IDs
        Set<String> shippableProductIds = new Set<String>();
        for(PricebookEntry pbe: [
            SELECT Id, Product2.Id, Product2.Weight__c, Product2.Taxable__c, Product2.ProductCode, Product2.GL_Code__c
            FROM PricebookEntry 
            WHERE Id IN :pricebookEntryIds AND IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE
        ]){
            if(pbe.Product2.Weight__c != null && pbe.Product2.Weight__c != 0){
                shippableProductIds.add(pbe.Product2.Id);
                GARP_MS_Shipping.shipOrderLineItem soli = new GARP_MS_Shipping.shipOrderLineItem();
                soli.productCode = pbe.Product2.ProductCode;
                soli.glCode = pbe.Product2.GL_Code__c;
                soli.quantity = 1;
                shipOrder.lineItems.add(soli);
            }
        } 
        
        //system.debug('validateShippingSelection shippingInfo:' + shipOrder.lineItems);
        system.debug('shippableProductIds:' + shippableProductIds);
        
        FINAL String postalCode = (lead.Shipping_Address_Same_as_Billing_Address__c) ? lead.Billing_Postal_Code__c : lead.Shipping_Postal_Code__c;
        FINAL String isoCode = (lead.Shipping_Address_Same_as_Billing_Address__c) ? lead.Billing_Country_ISO_Code__c : lead.Shipping_Country_ISO_Code__c;
    
        
        shipOrder.address = new GARP_MS_Shipping.shipOrderAddress();
        shipOrder.address.countryCode = isoCode;

        System.Debug('shipOrder:' + shipOrder);
    
        Shipping_Charge__c fndShipRate = GARP_MS_Shipping.getShippingRate(shipOrder);
        if(fndShipRate != NULL && fndShipRate.Shipping_Charge__c == shipping.Shipping_Charge__c) {
            
            Decimal shippingCost = shipping.Shipping_Charge__c;
            
            PricebookEntry pbe = [
                SELECT Id, UnitPrice, ProductCode, Product2Id, Product2.Name, Product2.Weight__c, Product2.Taxable__c, Product2.Product_ID__c, Pricebook2Id
                FROM PricebookEntry 
                WHERE IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE AND ProductCode = 'SHIP'
                LIMIT 1
            ];
            
            OpportunityLineItem oli = new OpportunityLineItem(                               
                PricebookEntryId    = pbe.Id,
                Product2Id          = pbe.Product2Id,
                UnitPrice           = shippingCost,
                Quantity            = 1,
                Description         = 'Standard Shipping'
            );
            
            response.status = 200;
            response.data = new List<Object>();
            response.data.add(oli);
            
            System.Debug('response.data:' + oli);
            
            // New Sage Logic
            //response.data = GARP_BC_Shipping.stageShippingOpportunityLineItems(shipOrder);
            //system.debug('stageShippingOpportunityLineItems response.data:' + response.data);
            
        } else {
            throw new Response.ResponseException('Shipping option was not selected.', 400, new List<String>{'Shipping option was not selected.'});
        }
    
        return response;
    }



    public static Response.Collection validateShippingSelection(UpsXmlRatingServiceSelectionResponse.RatedShipment shipping, Lead lead, Set<Id> pricebookEntryIds){
        
        Response.Collection response = new Response.Collection();
        
        // New Sage Logic
        //GARP_MS_Shipping.shipOrder shipOrder = new GARP_MS_Shipping.shipOrder();
        //shipOrder.lineItems = new List<GARP_MS_Shipping.shipOrderLineItem>();
        
        //Create a set of all shippable study material IDs
        Set<String> shippableProductIds = new Set<String>();
        for(PricebookEntry pbe: [
            SELECT Id, Product2.Id, Product2.Weight__c, Product2.Taxable__c, Product2.ProductCode, Product2.GL_Code__c
            FROM PricebookEntry 
            WHERE Id IN :pricebookEntryIds AND IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE
        ]){
            if(pbe.Product2.Weight__c != null && pbe.Product2.Weight__c != 0){
                shippableProductIds.add(pbe.Product2.Id);
                
                // New Sage Logic
                //GARP_MS_Shipping.shipOrderLineItem soli = new GARP_MS_Shipping.shipOrderLineItem();
                //soli.productCode = pbe.Product2.ProductCode;
                //soli.glCode = pbe.Product2.GL_Code__c;
                //soli.quantity = 1;
                //shipOrder.lineItems.add(soli);
            }
        } 
        
        FINAL String postalCode = (lead.Shipping_Address_Same_as_Billing_Address__c) ? lead.Billing_Postal_Code__c : lead.Shipping_Postal_Code__c;
        FINAL String isoCode = (lead.Shipping_Address_Same_as_Billing_Address__c) ? lead.Billing_Country_ISO_Code__c : lead.Shipping_Country_ISO_Code__c;
        
        /**
         * Fetch the most up-to-date shipping options from UPS
         * Ensure that there is a Postal Code in the request
        **/
        Response.Detail responsFetch;
        if(shippableProductIds.isEmpty()){
            response.status = 100;
        }else{
            responsFetch = RegistrationFormShippingHelper.fetchShippingOptions(isoCode, postalCode, shippableProductIds);
        }
        
        if(responsFetch != null && responsFetch.status == 200){

            UpsXmlRatingServiceSelectionResponse ratingServiceSelectionResponse = (UpsXmlRatingServiceSelectionResponse)responsFetch.data;

            Map<String, UpsXmlRatingServiceSelectionResponse.RatedShipment> ratedShippingMap = ratingServiceSelectionResponse.ratedShipmentsMap;
                      
            if(shipping != null && shipping.serviceCode != null && ratedShippingMap.containsKey(shipping.serviceCode)){
                
                Decimal shippingCost = Decimal.valueOf(ratedShippingMap.get(shipping.serviceCode).monetaryValue);                             
                
                PricebookEntry pbe = [
                    SELECT Id, UnitPrice, ProductCode, Product2Id, Product2.Name, Product2.Weight__c, Product2.Taxable__c, Product2.Product_ID__c, Pricebook2Id
                    FROM PricebookEntry 
                    WHERE IsActive = TRUE AND Pricebook2.IsActive = TRUE AND Product2.IsActive = TRUE AND ProductCode = 'SHIP'
                    LIMIT 1
                ];
                
                OpportunityLineItem oli = new OpportunityLineItem(                               
                    PricebookEntryId    = pbe.Id,
                    Product2Id          = pbe.Product2Id,
                    UnitPrice           = shippingCost,
                    Quantity            = 1,
                    Description         = ratedShippingMap.get(shipping.serviceCode).label
                );
                
                response.status = 200;
                //response.data = oli;
                
                response.data = new List<Object>();
                response.data.add(oli);

                
                // New Sage Logic
                //shipOrder.address = new GARP_MS_Shipping.shipOrderAddress();
                //shipOrder.address.countryCode = isoCode;
                                
                //response.data = GARP_BC_Shipping.stageShippingOpportunityLineItems(shipOrder);
                //system.debug('stageShippingOpportunityLineItems response.data:' + response.data);
                
                //System.Debug('shipOrder:' + shipOrder);

                                
                System.Debug('response.data:' + response.data);
                
            }else{
                
                throw new Response.ResponseException('Shipping option was not selected.', 400, new List<String>{'Shipping option was not selected.'});
                
            }
            
        }
        
        return response;
        
    }

    public static Response.Detail validateAddress(Lead lead){
        
        Response.Detail response = new Response.Detail();
        
        String address1     = null;
        String address2     = null;
        String city         = null;
        String stateCode    = null;
        String postalCode   = null;
        String countryCode  = null;
        
        if(lead.Shipping_Address_Same_as_Billing_Address__c){
            address1    = lead.Billing_Address_1__c;
            address2    = lead.Billing_Address_2__c;
            city        = lead.Billing_City__c;
            stateCode   = lead.Billing_State__c;
            postalCode  = lead.Billing_Postal_Code__c;
            countryCode = lead.Billing_Country_ISO_Code__c;
        }else{
            address1    = lead.Shipping_Address_1__c;
            address2    = lead.Shipping_Address_2__c;
            city        = lead.Shipping_City__c;
            stateCode   = lead.Shipping_State__c;
            postalCode  = lead.Shipping_Postal_Code__c;
            countryCode = lead.Shipping_Country_ISO_Code__c;
        }
        
        UpsXmlAddressValidationResponse addressValidationResponse = new UpsXmlAddressValidationRequest(address1, address2, city, stateCode, postalCode, countryCode).fetch();
        
        if(addressValidationResponse.response.errorCode == '264002'){
            
            throw new Response.ResponseException(
                'Please enter a valid country code.',
                400,
                new List<String>{ addressValidationResponse.response.errorCode, addressValidationResponse.response.errorDescription, addressValidationResponse.response.errorSeverity }
            );
            
        }else if(addressValidationResponse.addressKeyFormats.isEmpty()){
            
            throw new Response.ResponseException(
                'Invalid address.',
                400,
                new List<String>{ 'No address found for the given address.' }
            );
            
        }else if(!addressValidationResponse.exactMatch){
            
            throw new Response.ResponseException(
                'Invalid address.',
                400,
                new List<String>{ 'More than one address found for the given address.' }
            );
            
        }else if(addressValidationResponse.exactMatch){
            
            response.status = 200;
            response.message = 'Valid address.';
            response.data = response.data = addressValidationResponse.addressKeyFormats;
            
        }else{
            
            throw new Response.ResponseException(
                'Invalid address.',
                400,
                new List<String>{ addressValidationResponse.response.errorCode, addressValidationResponse.response.errorDescription, addressValidationResponse.response.errorSeverity }
            );
            
        }        
        
        return response;
        
    }
    
    public static Response.Detail fetchShippingOptions(String countryCode, String postalCode, Set<String> productIds){
        
        Response.Detail response = new Response.Detail();
        
        List<Product2> products = [SELECT Id, Weight__c, Product2.Taxable__c FROM Product2 WHERE Id IN :productIds];
        
        if(countryCode == null){
            
            throw new Response.ResponseException(
                'Request is missing ISO Country Code.',
                400,
                new List<String>{'Request is missing ISO Country Code.'}
            );
            
        }else if(countryCode == 'US' && postalCode == null){
            
            throw new Response.ResponseException(
                'Request is missing Postal Code.',
                400,
                new List<String>{'Request is missing Postal Code.'}
            );
            
        }else if (products.isEmpty()){
            
            throw new Response.ResponseException(
                'Request is missing Products.',
                400,
                new List<String>{'Request is missing Products.'}
            );
            
        }
        
        Decimal totalWeight = 0;
        
        for(Product2 product: products){
            totalWeight += product.Weight__c;
        }
        
        if(Test.isRunningTest()){
            Test.setMock(HttpCalloutMock.class, new UpsXmlRatingServiceSelectionRequestMock());
        }
        
        UpsXmlRatingServiceSelectionResponse ratingServiceSelectionResponse = new UpsXmlRatingServiceSelectionRequest(countryCode, postalCode, totalWeight).fetch();
        
        if(ratingServiceSelectionResponse.response.errorCode == '111210'){
            
            throw new Response.ResponseException(
                'Please enter a valid postal code.', 
                400, 
                new List<String>{ ratingServiceSelectionResponse.response.errorCode, ratingServiceSelectionResponse.response.errorDescription, ratingServiceSelectionResponse.response.errorSeverity }
            );
            
        }else if(ratingServiceSelectionResponse.response.errorCode == '110208'){
            
            throw new Response.ResponseException(
                'Please enter a valid country code.',
                400,
                new List<String>{ ratingServiceSelectionResponse.response.errorCode, ratingServiceSelectionResponse.response.errorDescription, ratingServiceSelectionResponse.response.errorSeverity }
            );
            
        }else{
            
            response.data = ratingServiceSelectionResponse;
            response.message = 'Successfully retrieved UPS Pricing.';
            response.status = 200; 
            
        }
        
        return response;          
        
    }

}