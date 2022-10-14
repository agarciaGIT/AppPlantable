public class GARP_ExamManagement {
    
    public Enum DeferralAction { DEFER, UNDEFER }
    
    public static Exam_Attempt__c fetchExamRegistrationInContext(Id examRegistrationId){
        
        List<Exam_Attempt__c> examRegistrations = [
            SELECT
                Id, 
                Cloned_From__c,
                Cloned_From__r.Exam_Site__r.Exam__r.Exam__c,
                Cloned_From__r.Other_Exam_Registrations__r.Reg_Status__c,
                Cloned_From__r.Other_Exam_Registrations__r.Exam_Site__r.Exam__r.Exam__c,
                Opportunity__c, 
                Defered__c,
                Reg_Status__c, 
                Cancelled__c,
                Member__c, 
                Exam_Type__c, 
                Exam_Site__c, 
                Exam_Site__r.Name, 
                Exam_Site__r.Exam__r.Exam__c, 
                Exam_Site__r.Site__c, 
                Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,
                Exam_Site__r.Site__r.Is_Gender_Required__c,
                Exam_Site__r.Site__r.Display_Address__c, 
                Exam_Site__r.Exam__r.Exam_Group__r.Active__c,
                (
                    SELECT 
                    Id, Name, CreatedDate, ProductCode, Product2Id, TotalPrice, Event__c, Exam_Site__c, Exam_Registration__c, OpportunityId, UnitPrice, Quantity, Opportunity.AccountId, Opportunity.Program_Name__c, Description
                    FROM Opportunity_Line_Items__r
                    WHERE ProductCode = 'CHLF' AND Opportunity.StageName = 'Closed'
                    ORDER BY CreatedDate DESC
                )  
            FROM Exam_Attempt__c 
            WHERE Id = :examRegistrationId
            LIMIT 1
        ];        
        
        return (!examRegistrations.isEmpty()) ? examRegistrations[0] : null;
        
    }
       
    public static Map<Id, Exam_Attempt__c> getExamRegistrationByContactIdAndTestSiteId(String contactId, String testSiteId){
        
        /**
         * Get all CHLF Opportunity Line Items for all child Closed Opportunities
         * associated with all retrieved Exam Registrations and place in a map by Exam Registration ID
        **/ 
        
        Map<Id, Exam_Attempt__c> examRegistrationMap = new Map<Id, Exam_Attempt__c>([
            SELECT 
                Id, 
                Cloned_From__c,
                Cloned_From__r.Exam_Site__r.Exam__r.Exam__c,
                Cloned_From__r.Other_Exam_Registrations__r.Reg_Status__c,
                Cloned_From__r.Other_Exam_Registrations__r.Exam_Site__r.Exam__r.Exam__c,
                Opportunity__c, 
                Defered__c,
                Reg_Status__c,
                Cancelled__c,
                Member__c, 
                Exam_Type__c, 
                Exam_Site__c, 
                Exam_Site__r.Name, 
                Exam_Site__r.Exam__r.Exam__c, 
                Exam_Site__r.Site__c, 
                Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,
                Exam_Site__r.Site__r.Is_Gender_Required__c,
                Exam_Site__r.Site__r.Display_Address__c, 
                Exam_Site__r.Exam__r.Exam_Group__r.Active__c,
                (
                    SELECT 
                    Id, Name, CreatedDate, ProductCode, Product2Id, TotalPrice, Event__c, Exam_Site__c, Exam_Registration__c, OpportunityId, UnitPrice, Quantity, Opportunity.AccountId, Opportunity.Program_Name__c, Description
                    FROM Opportunity_Line_Items__r
                    WHERE ProductCode = 'CHLF' AND Opportunity.StageName = 'Closed'
                    ORDER BY CreatedDate DESC
                )           
            FROM Exam_Attempt__c 
            WHERE
            Exam_Site__r.Exam__r.Exam_Group__r.Active__c = TRUE AND
            Member__c = :contactId AND 
            Cancelled__c = FALSE AND
            Opportunity__r.StageName = 'Closed'
            ORDER BY Exam_Site__r.Exam__r.Exam__c ASC
        ]);
        
        Set<Id> clonedFromIds = new Set<Id>();
        for(Exam_Attempt__c examRegistration: examRegistrationMap.values()){
            if(examRegistration.Cloned_From__c != null){
                clonedFromIds.add(examRegistration.Cloned_From__c);
            }
        }
        
        if(!clonedFromIds.isEmpty()){
            examRegistrationMap.putAll([
                SELECT 
                    Id, 
                    Cloned_From__c,
                    Cloned_From__r.Exam_Site__r.Exam__r.Exam__c,
                    Cloned_From__r.Other_Exam_Registrations__r.Reg_Status__c,
                    Cloned_From__r.Other_Exam_Registrations__r.Exam_Site__r.Exam__r.Exam__c,
                    Opportunity__c, 
                    Defered__c,
                    Reg_Status__c, 
                    Member__c,
                    Cancelled__c,
                    Exam_Type__c, 
                    Exam_Site__c, 
                    Exam_Site__r.Name, 
                    Exam_Site__r.Exam__r.Exam__c, 
                    Exam_Site__r.Site__c, 
                    Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,
                    Exam_Site__r.Site__r.Is_Gender_Required__c,
                    Exam_Site__r.Site__r.Display_Address__c, 
                    Exam_Site__r.Exam__r.Exam_Group__r.Active__c,
                    (
                        SELECT 
                        Id, Name, CreatedDate, ProductCode, Product2Id, TotalPrice, Event__c, Exam_Site__c, Exam_Registration__c, OpportunityId, UnitPrice, Quantity, Opportunity.AccountId, Opportunity.Program_Name__c, Description
                        FROM Opportunity_Line_Items__r
                        WHERE ProductCode = 'CHLF' AND Opportunity.StageName = 'Closed'
                        ORDER BY CreatedDate DESC
                    )           
                FROM Exam_Attempt__c 
                WHERE Id IN :clonedFromIds
            ]);
        }
        
        return examRegistrationMap;
       
    }
    
    public static Map<Id, List<OpportunityLineItem>> getOpportunityLineItemByOpportunityIdMap(Set<Id> opportunityIds){
        
        /**
         * Get all CHLF Opportunity Line Items for all parent or child Closed Opportunities
         * associated with all retrieved Exam Registrations and place in a map by OpportunityId
        **/  
       
        Map<Id, List<OpportunityLineItem>> opportunityLineItemByOpportunityId = new Map<Id, List<OpportunityLineItem>>();            
        for(OpportunityLineItem opportunityLineItem: [
            SELECT 
            Id, Name, CreatedDate, ProductCode, Product2Id, TotalPrice, Event__c, OpportunityId, Opportunity.StageName, UnitPrice, Quantity, Opportunity.AccountId, Opportunity.Program_Name__c, Description, Exam_Registration__r.Result__c
            FROM OpportunityLineItem
            WHERE 
                OpportunityId IN :opportunityIds AND 
                ProductCode = 'CHLF' AND 
                Opportunity.StageName = 'Closed' AND
                Exam_Registration__r.Result__c = NULL
            ORDER BY CreatedDate DESC
        ]){
            Id opportunityId = opportunityLineItem.OpportunityId;
            if(opportunityLineItemByOpportunityId.containsKey(OpportunityId)){
                opportunityLineItemByOpportunityId.get(opportunityId).add(opportunityLineItem);
            }else{               
                opportunityLineItemByOpportunityId.put(opportunityId, new List<OpportunityLineItem>{opportunityLineItem});  
            }
        } 
        
        return opportunityLineItemByOpportunityId;
        
    }
    
    public static Map<Id, List<Product_Refunds__c>> getProductRefundsByOpportunityIdMap(Set<Id> opportunityIds){
        
        /**
         * Get all CHLF Product Refunds for all parent or child Closed Opportunities
         * associated with all retrieved Exam Registrations and place in a map by OpportunityId
        **/ 
        
        Map<Id, List<Product_Refunds__c>> productRefundsByOpportunityId = new Map<Id, List<Product_Refunds__c>>();        
        for(Product_Refunds__c productRefund :[
            SELECT  Id, Reason__c, Opportunity_Product_ID__c, Name, GL_Code__c, Product_Code__c, Opportunity__c, Opportunity__r.StageName
            FROM Product_Refunds__c 
            WHERE Opportunity__c IN :opportunityIds AND Product_Code__c = 'CHLF' AND Opportunity__r.StageName = 'Closed'
        ]){            
            Id opportunityId = productRefund.Opportunity__c;
            if(productRefundsByOpportunityId.containsKey(opportunityId)){
                productRefundsByOpportunityId.get(opportunityId).add(productRefund);                    
            }else{
                productRefundsByOpportunityId.put(opportunityId, new List<Product_Refunds__c>{productRefund}); 
            }   
        }  
        
        return productRefundsByOpportunityId;
        
    }
    
    public static Exam_Sites__c getNewExamSite(Id newExamSiteId){
        
        List<Exam_Sites__c> examSites = [
            SELECT Id, Name, Exam__c, Site__r.Display_Address__c, Site__c, Exam__r.Exam__c, 
            Site__r.Is_OSTA_Information_Required__c, 
            Site__r.Is_Gender_Required__c
            FROM Exam_Sites__c 
            WHERE Id = :newExamSiteId
        ];   
        
        return (!examSites.isEmpty()) ? examSites[0] : null;
        
    }
    
    public static Map<String, Exam_Sites__c> getExamSiteByExamTypeMap(Id testSiteId){
        
        /**
         * Retrieves all Exam Sites for a specific Test Site (Site__c)
         * and creates a map by the Exam Name (i.e. FRM Part 1 or ERP Part II etc...)
        **/ 
        
        Map<String, Exam_Sites__c> examSiteByExamType = new Map<String, Exam_Sites__c>();
        for(Exam_Sites__c examSite: [
            SELECT Id, Site__c, 
            Site__r.Is_OSTA_Information_Required__c, 
            Site__r.Is_Gender_Required__c, Exam__r.Exam__c
            FROM Exam_Sites__c  
            WHERE Site__c = :testSiteId
        ]){
            examSiteByExamType.put(examSite.Exam__r.Exam__c, examSite);
        }
        
        return examSiteByExamType;
        
    }
    
    public static Set<Id> getAllOpportunityIdsByExamRegistration(Exam_Attempt__c examRegistration){
        
        /**
         * Get all Opportunity IDs that are a parent (Opportunity__c) or 
         * child (Opportunity_Line_Items__r => OpportunityId) of the Exam Registration
        **/ 
        
        Set<Id> opportunityIds = new Set<Id>();
        
        opportunityIds.add(examRegistration.Opportunity__c);
        
        if(examRegistration.Opportunity_Line_Items__r != null){
            for(OpportunityLineItem oli: examRegistration.Opportunity_Line_Items__r){
                opportunityIds.add(oli.OpportunityId);
            }
        }
        
        return opportunityIds;
        
    }
    
    public static Set<Id> getAllOpportunityIdsByExamRegistrations(List<Exam_Attempt__c> examRegistrations){
        
        /**
         * Get all Opportunity IDs that are a parent (Opportunity__c) or 
         * child (Opportunity_Line_Items__r => OpportunityId) of the Exam Registrations
        **/ 
        
        Set<Id> opportunityIds = new Set<Id>();
        
        for(Exam_Attempt__c examRegistration: examRegistrations){
            opportunityIds.add(examRegistration.Opportunity__c); 
            if(examRegistration.Opportunity_Line_Items__r != null){
                for(OpportunityLineItem oli: examRegistration.Opportunity_Line_Items__r){
                    opportunityIds.add(oli.OpportunityId);
                }
            }            
        }      
        
        
        /**
        * Excludes the Exam_Attempt__c parent Opportunity Id in the
        * below scenario.  This covers an edge case, where the 
        * Opportunity is incorrectly being included for a refund.
        **/
        for(Exam_Attempt__c examRegistration: examRegistrations){
            if(
                examRegistration.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2' &&
                examRegistration.Reg_Status__c == 'Deferred In' && 
                examRegistration.Cloned_From__r.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2' &&
                examRegistration.Cloned_From__r.Other_Exam_Registrations__r.Reg_Status__c != 'Deferred Out' && 
                examRegistration.Cloned_From__r.Other_Exam_Registrations__r.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1'
            ){
                opportunityIds.remove(examRegistration.Opportunity__c);
            }
        }
        
        return opportunityIds;
        
    }
    
    public static Map<Id, ChargentSFA__Transaction__c> getApprovedTransactionByOpportunityIdMap(Set<Id> opportunityIds){
        
        
        System.Debug('opportunityIds:' + opportunityIds);
        
        List<ChargentSFA__Transaction__c> transactions = [
            SELECT Id, ChargentSFA__Opportunity__c, ChargentSFA__Response_Status__c, ChargentSFA__Amount__c 
            FROM ChargentSFA__Transaction__c 
            WHERE ChargentSFA__Opportunity__c IN :opportunityIds AND ChargentSFA__Response_Status__c = 'Approved'
            ORDER BY ChargentSFA__Amount__c ASC
        ];
        
        System.Debug('transactions :' + transactions );
        
        Map<Id, ChargentSFA__Transaction__c> approvedTransactionByOpportunityId = new Map<Id, ChargentSFA__Transaction__c>();
        for(ChargentSFA__Transaction__c ct: transactions){
            approvedTransactionByOpportunityId.put(ct.ChargentSFA__Opportunity__c,  ct);
        }
        
        System.Debug('approvedTransactionByOpportunityId:' + approvedTransactionByOpportunityId);
        
        return approvedTransactionByOpportunityId;
        
    }
    
    public static Integer getExamPartNumber(String examName){
        switch on examName{
            when 'FRM Part 1'{
                return 1;
            }
            when 'FRM Part 2'{
                return 2;
            }
            when 'ERP Exam Part I'{
                return 1;
            }
            when 'ERP Exam Part II'{
                return 2;
            }
            when else{
                return null;
            }
        }
    }
    
    public static Integer computeNumberOfExamRegistrationsInActiveCycle(List<Exam_Attempt__c> examRegistrations){
        
        Integer numberOfExamRegistrations = 0;
        for(Exam_Attempt__c examRegistration: examRegistrations){
            if(examRegistration.Exam_Site__r.Exam__r.Exam_Group__r.Active__c){
                numberOfExamRegistrations++;
            }
        }     
        
        return numberOfExamRegistrations;
                
    }
    
    public static Integer computeNumberOfDeferredOutExamRegistrationsInActiveCycle(List<Exam_Attempt__c> examRegistrations){
        
        Integer numberOfExamRegistrationsDeferredOut = 0;
        for(Exam_Attempt__c examRegistration: examRegistrations){
            if(
                examRegistration.Exam_Site__r.Exam__r.Exam_Group__r.Active__c && 
                (examRegistration.Reg_Status__c == 'Deferred Out Pending' || examRegistration.Reg_Status__c == 'Deferred Out')
            ){
                numberOfExamRegistrationsDeferredOut++;
            }
        }    
        
        return numberOfExamRegistrationsDeferredOut;
                
    }
    
    public static List<Product_Refunds__c> createChinaDataFeeProductRefunds(Id contactId){
        
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE Id = :contactId
        ];
        
        List<Contract> ostaContracts = [
            SELECT Id, Name, Status, RecordType.Name, OSTA_Last_Upload_Date__c,
            (
                SELECT Id, UnitPrice, Product2Id, OpportunityId, Description, Quantity
                FROM Program_Fees__r
                WHERE ProductCode = 'CHNDF'
            )
            FROM Contract
            WHERE 
            RecordType.Name = 'OSTA Program' AND
            AccountId = :contacts[0].AccountId AND
            Status LIKE 'Activated%'
        ];
        
        List<Product_Refunds__c> toInsert = new List<Product_Refunds__c>();
        
        if(!ostaContracts.isEmpty() && ostaContracts[0].OSTA_Last_Upload_Date__c == null){
        
            Set<Id> opportunityIds = new Set<Id>();
            for(OpportunityLineItem ostaFee: ostaContracts[0].Program_Fees__r){
                opportunityIds.add(ostaFee.OpportunityId);
            }
            
            System.Debug('opportunityIds:' + opportunityIds);
            
            Map<Id, ChargentSFA__Transaction__c> approvedTransactionByOpportunityId = getApprovedTransactionByOpportunityIdMap(opportunityIds);
            
            System.Debug('approvedTransactionByOpportunityId:' + approvedTransactionByOpportunityId );

            for(OpportunityLineItem ostaFee: ostaContracts[0].Program_Fees__r){
                
                Product_Refunds__c productRefund = new Product_Refunds__c();
                
                productRefund.Payment_Transaction__c    = null;
                productRefund.Status__c                 = 'Submitted';
                productRefund.Product__c                = ostaFee.Product2Id;
                productRefund.Opportunity__c            = ostaFee.OpportunityId;         
                productRefund.Reason__c                 = ostaFee.Description;
                productRefund.Refund_Amount__c          = (ostaFee.UnitPrice*ostaFee.Quantity).setScale(2);
                productRefund.Sales_Price__c            = (ostaFee.UnitPrice*ostaFee.Quantity).setScale(2);
                productRefund.Opportunity_Product_ID__c = ostaFee.Id;
                
                System.Debug('ostaFee:' + ostaFee);
                
                if(approvedTransactionByOpportunityId.containsKey(ostaFee.OpportunityId)){
                    productRefund.Payment_Transaction__c = approvedTransactionByOpportunityId.get(ostaFee.OpportunityId).Id;
                }
                
                toInsert.add(productRefund);
                
            }
            
            ostaContracts[0].Status = 'Canceled';
            
            UPDATE ostaContracts[0];
            
        }
        
        return toInsert;
        
    }
    
    public static List<Product_Refunds__c> createChinaLocationFeeProductRefunds(Map<Id, Exam_Attempt__c> examRegistrations, Set<Id> opportunityIds){

        Map<Id, List<OpportunityLineItem>> opportunityLineItemByOpportunityId   = getOpportunityLineItemByOpportunityIdMap(opportunityIds);
        Map<Id, List<Product_Refunds__c>> productRefundsByOpportunityId         = getProductRefundsByOpportunityIdMap(opportunityIds);
        Map<Id, ChargentSFA__Transaction__c> approvedTransactionByOpportunityId = getApprovedTransactionByOpportunityIdMap(opportunityIds);
        
        Map<Id, Map<Id, Product_Refunds__c>> productRefundsByOpportunityLineItemByOpportunityId = new Map<Id, Map<Id, Product_Refunds__c>>();
        for(List<Product_Refunds__c> productRefunds: productRefundsByOpportunityId.values()){
            for(Product_Refunds__c productRefund: productRefunds){
                if(productRefundsByOpportunityLineItemByOpportunityId.containsKey(productRefund.Opportunity__c)){
                    productRefundsByOpportunityLineItemByOpportunityId.get(productRefund.Opportunity__c).put((Id)productRefund.Opportunity_Product_ID__c, productRefund);
                }else{
                    productRefundsByOpportunityLineItemByOpportunityId.put(productRefund.Opportunity__c, new Map<Id, Product_Refunds__c>{(Id)productRefund.Opportunity_Product_ID__c => productRefund});
                }                
            }
        }
        
        Map<Id, Product_Refunds__c> productRefundByUniqueOpportunityLineItem = new Map<Id, Product_Refunds__c>();
        
        for(Exam_Attempt__c examRegistration: examRegistrations.values()){
            
            Id opportunityId = examRegistration.Opportunity__c;
            
            List<OpportunityLineItem> locationFees = null;
            if(opportunityLineItemByOpportunityId.containsKey(opportunityId)){
                locationFees = opportunityLineItemByOpportunityId.get(opportunityId);
            }
            
            if(examRegistration.Opportunity_Line_Items__r != null && !examRegistration.Opportunity_Line_Items__r.isEmpty()){
                locationFees = examRegistration.Opportunity_Line_Items__r;
            }   
                        
            if(locationFees != null && !locationFees.isEmpty()){
                for(OpportunityLineItem locationFee: locationFees){
                    
                    if(!productRefundsByOpportunityLineItemByOpportunityId.containsKey(locationFee.OpportunityId)){
                        
                        /**
                         * Applying a refund before any CHLF refunds
                         * have been applied.
                         */ 
                        
                        Product_Refunds__c productRefund = new Product_Refunds__c();
                        
                        productRefund.Payment_Transaction__c    = null;
                        productRefund.Status__c                 = 'Submitted';
                        productRefund.Product__c                = locationFee.Product2Id;
                        productRefund.Opportunity__c            = locationFee.OpportunityId;         
                        productRefund.Reason__c                 = locationFee.Description;
                        productRefund.Refund_Amount__c          = (locationFee.UnitPrice*locationFee.Quantity).setScale(2);
                        productRefund.Sales_Price__c            = (locationFee.UnitPrice*locationFee.Quantity).setScale(2);
                        productRefund.Opportunity_Product_ID__c = locationFee.Id;
                        
                        if(approvedTransactionByOpportunityId.containsKey(locationFee.OpportunityId)){
                            productRefund.Payment_Transaction__c = approvedTransactionByOpportunityId.get(locationFee.OpportunityId).Id;
                        }
                        
                        productRefundByUniqueOpportunityLineItem.put(locationFee.Id, productRefund);                              
                        
                    }else{
                        
                        /**
                         * Applying a refund after a partial CHLF refund
                         * has been applied to a single opportunity.
                         */                      

                        Map<Id, Product_Refunds__c> productRefundByOpportunityProductId = productRefundsByOpportunityLineItemByOpportunityId.get(locationFee.OpportunityId);
                        
                        /**
                         * Creates a map of all Product Refunds
                         * missing Opportunity_Product_ID__c, to prevent the creation of
                         * unecessary refunds because Opportunity_Product_ID__c is null
                         */ 
                        Map<Id, Product_Refunds__c> productRefundMissingOpportunityProductId = new Map<Id, Product_Refunds__c>();
                        for(Product_Refunds__c productRefund: productRefundByOpportunityProductId.values()){
                            if(productRefund.Opportunity_Product_ID__c == null){
                                productRefundMissingOpportunityProductId.put(productRefund.Id, productRefund);
                            }
                        }
                        
                        if(
                            productRefundByOpportunityProductId != null && 
                            !productRefundByOpportunityProductId.containsKey(locationFee.Id) && 
                            !productRefundMissingOpportunityProductId.containsKey(locationFee.Id)
                        ){
                            
                            Product_Refunds__c productRefund = new Product_Refunds__c();
                            
                            productRefund.Payment_Transaction__c    = null;
                            productRefund.Status__c                 = 'Submitted';
                            productRefund.Product__c                = locationFee.Product2Id;
                            productRefund.Opportunity__c            = locationFee.OpportunityId;         
                            productRefund.Reason__c                 = locationFee.Description;
                            productRefund.Refund_Amount__c          = (locationFee.UnitPrice*locationFee.Quantity).setScale(2);
                            productRefund.Sales_Price__c            = (locationFee.UnitPrice*locationFee.Quantity).setScale(2);
                            productRefund.Opportunity_Product_ID__c = locationFee.Id;
                            
                            if(approvedTransactionByOpportunityId.containsKey(locationFee.OpportunityId)){
                                productRefund.Payment_Transaction__c = approvedTransactionByOpportunityId.get(locationFee.OpportunityId).Id;
                            }
                            
                            productRefundByUniqueOpportunityLineItem.put(locationFee.Id, productRefund); 
                            
                        }
                        
                    }
                    
                }
            }
            
        }            
        
        return productRefundByUniqueOpportunityLineItem.values();
        
    }
    
    public static void createDeferralProductRefunds(Id examRegistrationId, GARP_ExamManagement.DeferralAction action){

        Exam_Attempt__c examRegistrationInContext = fetchExamRegistrationInContext(examRegistrationId);
        
        if(examRegistrationInContext.Exam_Site__r.Exam__r.Exam__c.contains('FRM')){ 
            
            Id siteId = examRegistrationInContext.Exam_Site__r.Site__c;
            Id contactId = examRegistrationInContext.Member__c;
            
            Exam_Sites__c sourceExamSite = examRegistrationInContext.Exam_Site__r;
            
            String sourceExamSiteName = sourceExamSite.Name.toUpperCase();
            
            Map<Id, Exam_Attempt__c> examRegistrations = getExamRegistrationByContactIdAndTestSiteId(contactId, siteId);
            
            List<Product_Refunds__c> productRefunds = new List<Product_Refunds__c>();
            List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();

            if(sourceExamSite.Site__r.Is_OSTA_Information_Required__c){  
                
                Integer numberOfExamRegistrations = computeNumberOfExamRegistrationsInActiveCycle(examRegistrations.values());
                Integer numberOfExamRegistrationsDeferredOut = computeNumberOfDeferredOutExamRegistrationsInActiveCycle(examRegistrations.values());
                Integer examRegistrationPartInContext = getExamPartNumber(examRegistrationInContext.Exam_Site__r.Exam__r.Exam__c);
                
                if(action == DeferralAction.DEFER){
                    
                    if(numberOfExamRegistrations == 2 && numberOfExamRegistrationsDeferredOut == 1 && examRegistrationPartInContext == 1){
                        
                        Set<Id> opportunityIds = getAllOpportunityIdsByExamRegistration(examRegistrationInContext);
                        
                        Map<Id, Exam_Attempt__c> examAttemptMap = new Map<Id, Exam_Attempt__c>{examRegistrationInContext.Id => examRegistrationInContext};
                                    
                        productRefunds = createChinaLocationFeeProductRefunds(examAttemptMap, opportunityIds);
                        
                    }
                    
                }else if(action == DeferralAction.UNDEFER){
                    
                    if(numberOfExamRegistrations == 2 && numberOfExamRegistrationsDeferredOut == 1 && examRegistrationPartInContext == 2){
                        
                        Set<Id> opportunityIds = getAllOpportunityIdsByExamRegistration(examRegistrationInContext);
                        
                        Map<Id, Exam_Attempt__c> examAttemptMap = new Map<Id, Exam_Attempt__c>{examRegistrationInContext.Id => examRegistrationInContext};
                                    
                        productRefunds = createChinaLocationFeeProductRefunds(examAttemptMap, opportunityIds);
                        
                    }
                    
                } 
                
                if(!productRefunds.isEmpty()){
                    INSERT productRefunds;
                }
                
            }
 
        }
        
    }
        
    public static void switchExamSites(Id examRegistrationId, Id targetExamSiteId){
        
        Exam_Attempt__c examRegistrationInContext = fetchExamRegistrationInContext(examRegistrationId);
        
        Id siteId = examRegistrationInContext.Exam_Site__r.Site__c;
        Id contactId = examRegistrationInContext.Member__c;

        Exam_Sites__c sourceExamSite = examRegistrationInContext.Exam_Site__r;
        Exam_Sites__c targetExamSite = getNewExamSite(targetExamSiteId);
        
        String sourceExamSiteName = sourceExamSite.Name.toUpperCase();
        String targetExamSiteName = targetExamSite.Name.toUpperCase();
        
        System.Debug('sourceExamSiteName :' + sourceExamSiteName );
        System.Debug('targetExamSiteName :' + targetExamSiteName );
           
        Map<Id, Exam_Attempt__c> examRegistrations = getExamRegistrationByContactIdAndTestSiteId(contactId, siteId);
        
        //system.assert(false, 'BOOM!3'+ examRegistrations );

        
        Map<String, Exam_Sites__c> examSiteByExamType = getExamSiteByExamTypeMap(targetExamSite.Site__c);
        
        for(Exam_Attempt__c examRegistration: examRegistrations.values()){
            
            System.Debug('examRegistration:' + examRegistration);

            if(
                examRegistration.Cancelled__c == FALSE &&
                examRegistration.Exam_Type__c != null && 
                examSiteByExamType.containsKey(examRegistration.Exam_Type__c) &&
                examRegistration.Exam_Site__r.Exam__r.Exam_Group__r.Active__c 
            ){
                examRegistration.Exam_Site__c = examSiteByExamType.get(examRegistration.Exam_Type__c).Id;

                System.Debug('examRegistration Update:' + examRegistration);

            }

        }
               
        UPDATE examRegistrations.values();
 
    }
    
    public static Contract fetchOstaProgram(Id accountId){
        
        List<Contract> programs = [
            SELECT Id, Name, Status, RecordType.Name, Opportunity__c, CustomerSignedId, AccountId 
            FROM Contract
            WHERE                               
                AccountId = :accountId AND
                Status LIKE 'Activated%' AND 
                RecordType.Name = 'OSTA Program'                             
        ];
        
        if(programs.isEmpty()){
            return null;
        }else{
            return programs[0];
        }
        
    }

    public static Contract cancelOstaProgram(String accountID){
        
        system.debug('cancelOstaProgram: ' + accountID);
        
        Contract ostaProgram;
        LIST<Contract> ostaPrograms = [
            SELECT Id, Name, Status, RecordType.Name, AccountId, Opportunity__c
            FROM Contract
            WHERE 
            AccountId = :accountID AND
            RecordType.Name = 'OSTA Program' AND
            Status LIKE 'Activated%'
        ];        
        
        system.debug('ostaPrograms: ' + ostaPrograms);
        
        if(ostaPrograms != NULL && ostaPrograms.size() > 0) {
            ostaProgram = ostaPrograms[0];
            ostaProgram.Status = 'Canceled';
            
            system.debug('Update ostaProgram: ' + ostaProgram);
            
            update ostaProgram;
        }
        
        return ostaProgram;
    }

    
    public static Contract createOstaProgram(Opportunity opportunity, OpportunityLineItem chinaDataFee){
        
        system.debug('createOstaProgram: ' + opportunity + '~' + chinaDataFee);
        
        Map<String, Contract> frmAndOstaContractMap = new Map<String, Contract>();
        
        List<Contact> contacts = [
            SELECT Id, Name, AccountId
            FROM Contact
            WHERE AccountId = :opportunity.AccountId
            LIMIT 1
        ];
        
        /**
        * Fetch all FRM and OSTA Programs
        * that are currently being created or previously created.
        */ 
        
        List<Contract> programs = [
            SELECT Id, Name, Status, RecordType.Name, Opportunity__c, CustomerSignedId 
            FROM Contract
            WHERE 
            (
                AccountId = :opportunity.AccountId AND
                Status LIKE 'Activated%' AND 
                RecordType.Name = 'FRM Program' 
            ) OR
            (
                AccountId = :opportunity.AccountId AND
                Opportunity__c = :opportunity.Id AND
                RecordType.Name = 'FRM Program' AND
                Status = 'Draft'
            ) OR                                 
            (
                AccountId = :opportunity.AccountId AND
                Status LIKE 'Activated%' AND 
                RecordType.Name = 'OSTA Program' 
            )                                
        ];
        
        system.debug('programs: ' + programs);
        
        for(Contract program: programs){
            if(program.RecordType.Name == 'FRM Program' || program.RecordType.Name == 'OSTA Program'){
                frmAndOstaContractMap.put(program.RecordType.Name, program);
            }
        }
        
        system.debug('frmAndOstaContractMap: ' + frmAndOstaContractMap);
        
        if(!frmAndOstaContractMap.containsKey('OSTA Program')){
            
            Contract ostaContract = new Contract(
                AccountId = opportunity.AccountId,
                Opportunity__c = opportunity.Id,
                RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'OSTA Program'),
                FRM_Exam_Program__c = frmAndOstaContractMap.get('FRM Program').Id,
                Status = 'Draft',
                Name = 'OSTA Program',
                StartDate = Date.today(),
                ContractTerm = 9999
            );
            
            system.debug('ostaContract: ' + ostaContract);

            
            ostaContract.CustomerSignedId = contacts[0].Id;
            
            INSERT ostaContract;
            
            ostaContract.Status = 'Activated ( Auto-Renew )';
            
            UPDATE ostaContract;
            
            if(chinaDataFee != NULL) {
                chinaDataFee.Program__c = ostaContract.Id;
                UPDATE chinaDataFee;
            }
                
            return ostaContract;
            
        }else{
            
            return frmAndOstaContractMap.get('OSTA Program');
            
        }
        
    }
    
    public static void createOrUpdateOstaExamRegistrationData(Contract ostaProgram){
        
        /**
         * Creates a single OSTA Exam Registration Data record
         * or updates the existing one for the current Active 
         * Exam Group.
         */ 
        
        Id contactId = null;
        if(ostaProgram.CustomerSignedId != null){
            contactId = ostaProgram.CustomerSignedId;
        }else{
            Account account = [
                SELECT Id, 
                (SELECT Id FROM Contacts WHERE RecordType.Name = 'Member' LIMIT 1) 
                FROM Account 
                WHERE Id = :ostaProgram.AccountId
            ];
            contactId = account.contacts[0].Id;
        }
        
        List<Exam_Attempt__c> examRegistrations = [
            SELECT Id, Opportunity__c, Opportunity__r.StageName, Exam_Site__r.Exam__r.Exam_Group__r.Active__c,
            (
                SELECT Id, OSTA_Program__c, Exam_Registration__c FROM OSTA_Exam_Registration_Data__r
            )  
            FROM Exam_Attempt__c
            WHERE 
                Opportunity__r.StageName = 'Closed' AND
                Member__c = :contactId AND 
                Exam_Site__r.Exam__r.Exam_Group__r.Active__c = TRUE             
        ];
        
        List<OSTA_Exam_Registration_Data__c> toUpdate = new List<OSTA_Exam_Registration_Data__c>();
        List<OSTA_Exam_Registration_Data__c> toInsert = new List<OSTA_Exam_Registration_Data__c>();
        
        /**
         * Defines whether or not the Exam Registration(s) have at least one
         * OSTA Exam Registration Data record for the given cycle.
         */ 
        Boolean hasOstaExamRegistrationDataRecord = FALSE;
            
        for(Exam_Attempt__c examRegistration: examRegistrations){
            if(!examRegistration.OSTA_Exam_Registration_Data__r.isEmpty()){
                hasOstaExamRegistrationDataRecord = TRUE;
            }
        }
        
        for(Exam_Attempt__c examRegistration: examRegistrations){
            if(examRegistration.OSTA_Exam_Registration_Data__r.isEmpty() && hasOstaExamRegistrationDataRecord == FALSE){
                OSTA_Exam_Registration_Data__c ostaExamRegistrationData = new OSTA_Exam_Registration_Data__c(
                    OSTA_Program__c = ostaProgram.Id,
                    Exam_Registration__c = examRegistration.Id
                );
                toInsert.add(ostaExamRegistrationData);
            }else if(!examRegistration.OSTA_Exam_Registration_Data__r.isEmpty()){
                OSTA_Exam_Registration_Data__c ostaExamRegistrationData = examRegistration.OSTA_Exam_Registration_Data__r[0];
                ostaExamRegistrationData.OSTA_Program__c = ostaProgram.Id;
                toUpdate.add(ostaExamRegistrationData);
            }
            break;
        }
        
        if(!toInsert.isEmpty()){
            INSERT toInsert;
        }
        
        if(!toUpdate.isEmpty()){
            UPDATE toUpdate;
        }
        
    }
    
    public static void setExamRegistionReScoreStatusForReview(Set<Id> retabulationRequestExamRegistrationIds, Map<Id, OpportunityLineItem> retabulationRequestFeesMapByOpportunityId){
        
        Map<Id, Exam_Attempt__c> examRegistrations = new Map<Id, Exam_Attempt__c>([
            SELECT Id, Exam_Name__c, Exam_Date__c, Re_score_Status__c
            FROM Exam_Attempt__c
            WHERE Id IN :retabulationRequestExamRegistrationIds
        ]);
        
        if(!examRegistrations.values().isEmpty()){ 
            for(Exam_Attempt__c examRegistration: examRegistrations.values()){
                examRegistration.Re_score_Status__c = 'Awaiting Review';
            }
        }
        
        if(!retabulationRequestFeesMapByOpportunityId.values().isEmpty()){
            for(OpportunityLineItem oli: retabulationRequestFeesMapByOpportunityId.values()){
                if(examRegistrations.containsKey(oli.Exam_Registration__c)){
                    Exam_Attempt__c examRegistration = examRegistrations.get(oli.Exam_Registration__c);                    
                    Datetime dt = Datetime.newInstance(examRegistration.Exam_Date__c, Time.newInstance(0, 0, 0, 0));
                    oli.Description = dt.format('MMM YYYY');                                     
                }
            }
            UPDATE retabulationRequestFeesMapByOpportunityId.values();
        }
        
        if(!examRegistrations.values().isEmpty()){
            UPDATE examRegistrations.values();
        }        
        
    }
    
    public static void setScholarshipApplicationStatusAsUsed(Set<Id> scholarshipApplicationIds){
    
        List<Scholarship_Application__c> scholarshipApplications = [
            SELECT Id, Status__c, Applicant__c, Exam_Group__c, Exam_Group__r.Next_Exam_Group__c
            FROM Scholarship_Application__c
            WHERE
            Status__c = 'Approved' AND
            Id IN :scholarshipApplicationIds
        ];
        
        for(Scholarship_Application__c sa: scholarshipApplications){
            sa.Status__c = 'Used';
        }
        
        if(!scholarshipApplications.isEmpty()){
            UPDATE scholarshipApplications;
        }
        
    }

    /**
     * @description Entry point for modifying the deferral/undeferral order to include Product Refunds or Location Fee OpportunityLineItems if applicable.
     * @param deferralOpportunityId the deferral or undeferral Opportunity Id
     * @param examRegistrationId the Exam Registration being deferred or undeferred
     * @param action the enum value which determines if the method should process this order as DEFER or UNDEFER
     * @return an sObject (OpportunityLineItem || Product_Refunds__c) 
     */
    public static sObject computeDeferralLocationFeesOrProductRefunds(Id deferralOpportunityId, Id examRegistrationId, GARP_ExamManagement.DeferralAction action){
        
        Exam_Attempt__c examRegistrationInContext = fetchExamRegistrationInContext(examRegistrationId);
        
        if(examRegistrationInContext.Exam_Site__r.Exam__r.Exam__c.contains('FRM')){
            
            Id siteId = examRegistrationInContext.Exam_Site__r.Site__c;
            Id contactId = examRegistrationInContext.Member__c;
            
            Exam_Sites__c sourceExamSite = examRegistrationInContext.Exam_Site__r;
            
            String sourceExamSiteName = sourceExamSite.Name.toUpperCase();
            
            Map<Id, Exam_Attempt__c> examRegistrations = getExamRegistrationByContactIdAndTestSiteId(contactId, siteId);
            
            List<Product_Refunds__c> productRefunds = new List<Product_Refunds__c>();
            List<OpportunityLineItem> opportunityLineItems = new List<OpportunityLineItem>();

            if(examRegistrationInContext.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c){  
                
                Integer numberOfExamRegistrations = computeNumberOfExamRegistrationsInActiveCycle(examRegistrations.values());
                Integer numberOfExamRegistrationsDeferredOut = computeNumberOfDeferredOutExamRegistrationsInActiveCycle(examRegistrations.values());
                Integer examRegistrationPartInContext = getExamPartNumber(examRegistrationInContext.Exam_Site__r.Exam__r.Exam__c);
                
                System.debug('numberOfExamRegistrations: ' + numberOfExamRegistrations + ', numberOfExamRegistrationsDeferredOut: ' + numberOfExamRegistrationsDeferredOut + ', examRegistrationPartInContext: ' + examRegistrationPartInContext);
                
                if(action == DeferralAction.DEFER){
                    
                    if(numberOfExamRegistrations == 2 && numberOfExamRegistrationsDeferredOut == 0 && examRegistrationPartInContext == 2){
                        
                        PriceBookEntry priceBookEntry = [
                            SELECT UnitPrice, ProductCode
                            FROM PriceBookEntry 
                            WHERE 
                            Pricebook2.IsActive = TRUE AND 
                            Productcode = 'CHLF' AND 
                            IsActive = TRUE
                            LIMIT 1
                        ];
                        
                        OpportunityLineItem locationFee = new OpportunityLineItem(
                            Exam_Registration__c    = examRegistrationInContext.Id,
                            Exam_Site__c            = examRegistrationInContext.Exam_Site__c,
                            Description             = examRegistrationInContext.Exam_Site__r.Exam__r.Exam__c,                       
                            Quantity                = 1,
                            PricebookEntryId        = priceBookEntry.Id,
                            UnitPrice               = priceBookEntry.UnitPrice,
                            OpportunityId           = deferralOpportunityId
                        );
                        
                        opportunityLineItems.add(locationFee);
                        
                    }else if(numberOfExamRegistrations == 2 && numberOfExamRegistrationsDeferredOut == 1 && examRegistrationPartInContext == 1){
                        
                        Set<Id> opportunityIds = getAllOpportunityIdsByExamRegistration(examRegistrationInContext);
                        
                        Map<Id, Exam_Attempt__c> examAttemptMap = new Map<Id, Exam_Attempt__c>{examRegistrationInContext.Id => examRegistrationInContext};
                                    
                        productRefunds = createChinaLocationFeeProductRefunds(examAttemptMap, opportunityIds);
                        
                    }
                    
                }else if(action == DeferralAction.UNDEFER){
                    
                    if(numberOfExamRegistrations == 2 && numberOfExamRegistrationsDeferredOut == 2 && examRegistrationPartInContext == 1){
                        
                        PriceBookEntry priceBookEntry = [
                            SELECT Id, UnitPrice, ProductCode
                            FROM PriceBookEntry 
                            WHERE 
                            Pricebook2.IsActive = TRUE AND 
                            Productcode = 'CHLF' AND 
                            IsActive = TRUE
                            LIMIT 1
                        ];
                        
                        OpportunityLineItem locationFee = new OpportunityLineItem(
                            Exam_Registration__c    = examRegistrationInContext.Id,
                            Exam_Site__c            = examRegistrationInContext.Exam_Site__c,
                            Description             = examRegistrationInContext.Exam_Site__r.Exam__r.Exam__c,                       
                            Quantity                = 1,
                            PriceBookEntryId        = priceBookEntry.Id,
                            UnitPrice               = priceBookEntry.UnitPrice,
                            OpportunityId           = deferralOpportunityId
                        );
                        
                        opportunityLineItems.add(locationFee);
                        
                    }else if(numberOfExamRegistrations == 2 && numberOfExamRegistrationsDeferredOut == 1 && examRegistrationPartInContext == 2){
                        
                        Set<Id> opportunityIds = getAllOpportunityIdsByExamRegistration(examRegistrationInContext);
                        
                        Map<Id, Exam_Attempt__c> examAttemptMap = new Map<Id, Exam_Attempt__c>{ examRegistrationInContext.Id => examRegistrationInContext };
                            
                        productRefunds = createChinaLocationFeeProductRefunds(examAttemptMap, opportunityIds);
                        
                    }
                    
                }                       
                
            }
            
            if(!productRefunds.isEmpty()){
                /**
                * Product Refunds are inserted after
                * the deferral/undeferral refund is closed
                */ 
                return productRefunds[0];
            }else if(!opportunityLineItems.isEmpty()){
                INSERT opportunityLineItems[0];
                return opportunityLineItems[0];
            }
            
        }
        
        return null;
        
    }

    // AG 9/4/2020 - New My Program Logic
    
    public class allProgramData {  
        public programInfo frm { get; set; }
        public programInfo erp { get; set; }
        public programInfo scr { get; set; }
    }
    
    public class programInfo {  
        String name { get; set; }
        String type { get; set; }
        Boolean isEnrolled { get; set; }
        Boolean isLapsed { get; set; }
        Boolean isAllPartsPassed { get; set; }
        Boolean isAllPartsPassedHideCard { get; set; }
        Boolean isCVAwaitingReview { get; set; }
        Boolean isCVFailedReview { get; set; }
        Boolean isCertified { get; set; }
        
        Boolean isRegistrationOpen { get; set; }
        String  currentWindow { get; set; }
        Date    currentWindowEndDate{ get; set; }
                        
        Date registrationCloseDate { get; set; }
        
        Boolean isPartIAvailableForRegistration { get; set; }
        Boolean isPartIIAvailableForRegistration { get; set; }
        
        //Boolean isAdminAvailable { get; set; }
        //Boolean isDeferralAvailable { get; set; }
        
        //DateTime adminAvailableStartDate { get; set; }
        //Date adminAvailableEndDate { get; set; }
        
        Date nextRegistrationOpenDate { get; set; }
        
        
        Date programExpireDate  { get; set; }  

        String currentExamYear  { get; set; }
        String mostReleventPart  { get; set; }
                
        String idName { get; set; }
        String idNumber { get; set; }
        String idType { get; set; }
        Date idExpireDate { get; set; }
        Boolean isMissingFullID { get; set; }
        
        String gender { get; set; }
        String ostaChineseName { get; set; }
        Date ostaDateOfBirth { get; set; }
        String ostaPhone { get; set; }
        String ostaWorkStatus { get; set; }
        String ostaCompany { get; set; }
        String ostaEducationStatus { get; set; }
        String ostaSchool { get; set; }
        String ostaDegree { get; set; }
        String phone { get; set; }
        
        public partInfo part1 { get; set; }
        public partInfo part2 { get; set; }
        
        ExamRegistrationForm.RegistrationEligibility registrationEligibility { get; set; }
    }

    public class partInfo  {  
        String name { get; set; }
        Integer part { get; set; }
        String administration { get; set; }
        String deliveryMethod { get; set; }
        String provider { get; set; }
        DateTime examDateTime { get; set; }
        String examLocation { get; set; }
        Boolean isOSTA { get; set; }
        
        String oppId { get; set; }
        String examRegId { get; set; }
        
        String result { get; set; }
        Boolean hasViloation { get; set; }
        
        Boolean isPaid { get; set; }
        Boolean isScheduled { get; set; }
        Boolean isSetupComplete { get; set; }
        
        Boolean isActiveExamGroup { get; set; }
        String activeExamGroupName { get; set; }
        
        Boolean isSchedulingLapsed { get; set; }
        Boolean isScheduleWindowAvailable { get; set; }        
        
        Boolean isPassed { get; set; }
        Boolean isDeferred { get; set; }
        String deferredExamAdmin {get; set; }
        DateTime nextAdminOpenDate { get; set; }
        
        Boolean isTicketAvailable { get; set; }
        Boolean isAwaitingTicket { get; set; }
        DateTime ticketDownloadDate { get; set; }
        Boolean isSeatAllocated { get; set; }
        Date ticketAvailableDate  { get; set; }

        Date lastDateForADA { get; set; }
        Date lastDateForRAD { get; set; }
        
        DateTime examResultsAvailableDate { get; set; }
        String examResultsAvailableStatement { get; set; }
        Boolean isExamAwaitingResults { get; set; }
        Boolean isExamResultsAvailable { get; set; }
        Boolean showExamResults { get; set; }
        
        Boolean allowSchedulingOverride { get; set; }
        
        // AG 2/17/2022        	
        // Scheduling is Choose Exam Site and visit provider to schedule	
        // Uses Exam_Administration__r.Exam_Scheduling_Start_Date__c and Exam_Scheduling_End_Date__c	
        Boolean isSchedulingOpen { get; set; }	
        DateTime schedulingStartDate { get; set; }	
        DateTime schedulingEndDate { get; set; } 
        
        // Exam Admin Modification (Deferral) is seperate, but can only happen within the Scheduling window
        // Exam Admin Modification uses Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c and Exam_Admin_Modifications_End_Date__c        
        Boolean isAdminModOpen { get; set; }
        DateTime adminModStartDate { get; set; }
        DateTime adminModEndDate { get; set; }     
    }
    
    // AG 8/23/2020 - New Exam Reschedule Logic
    public class examRescheduleData {  
        public Exam_Sites__c currentSitePartI { get; set; }
        public Exam_Sites__c currentSitePartII { get; set; }
        public Exam_Sites__c selectedSitePartI { get; set; }
        public Exam_Sites__c selectedSitePartII { get; set; }
        
        public Exam_Administration__c currentAdminPartI { get; set; }
        public Exam_Administration__c currentAdminPartII { get; set; }
        public Exam_Administration__c selectedAdminPartI { get; set; }
        public Exam_Administration__c selectedAdminPartII { get; set; }        

        public Exam_Attempt__c examRegPartI { get; set; }
        public Exam_Attempt__c examRegPartII { get; set; }

        public Exam_Attempt__c otherProgramExamRegPartI { get; set; }
        public Exam_Attempt__c otherProgramExamRegPartII { get; set; }
        
        
        public Boolean canDeferPartI { get; set; }
        public Boolean canDeferPartII { get; set; }
        public Exam_Group__c examGroup { get; set; }
        public Exam_Group__c nextExamGroup { get; set; } 
        public Opportunity opp { get; set; } 
        
        public List<Exam_Sites__c> examSites { get; set; }
        public List<Exam_Administration__c> examAdmins { get; set; }
        public List<Exam_Part__c> examParts { get; set; }
        
        public List<prodLine> fees { get; set; }
        public Exam_Registration_Modification__c ExamRegMod { get; set; }
        public Contact contact { get; set; }
        public Contract program { get; set; }
        
        public String errMsg { get; set; }
        public Integer statusCode { get; set; }
        public Integer errorCode { get; set; }
        
        // AG 2/17/2022	
        // These are now by Part	
        // Setup uses Exam_Administration__r.Exam_Scheduling_Start_Date__c and Exam_Scheduling_End_Date__c	
        // Deferral uses Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c and Exam_Admin_Modifications_End_Date__c	
        public Boolean allowSchedulingPartI { get; set; }	
        public Boolean allowAdminModPartI { get; set; }	
        public Boolean allowSchedulingPartII { get; set; }	
        public Boolean allowAdminModPartII { get; set; }
    }
    
    public class prodLine {
        public String prodCode { get; set; }
        public String glCode { get; set; }
        public String description { get; set; }
        public Decimal amount { get; set; }
        public String examRegId { get; set; }
        public String examSiteId { get; set; }
    }
    
    public class ostaMaps {
        public MAP<String,Exam_Part__c> mapCurrentPartOSTA { get; set; }
        public MAP<String,Exam_Part__c> mapSelectedPartOSTA  { get; set; }
    }
        
    static public partInfo setProgramPartInfo(String programType, programInfo pri, Exam_Attempt__c ea, String partName, partInfo part) {
        
        //partInfo part = new partInfo();
        Date tdy = Date.today();
        DateTime now = DateTime.now();
        
        part.name = programType == 'frm' ? 'FRM Exam Part ' + partName : programType == 'erp' ? 'ERP Exam Part ' + partName : 'SCR Exam';
        part.part = partName == 'I' ? 1 : 2;
        
        
        if(programType != 'scr' && ea.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
            part.isActiveExamGroup = TRUE;
        } else if(ea.Exam_Site__r.Exam__r.Exam_Group__r.SCR_Active__c) {
            part.isActiveExamGroup = TRUE;            
        }
        
        part.allowSchedulingOverride = ea.Allow_Scheduling_Override__c;
                
        // Old Exam Setup
        if(ea.Exam_Part__r == NULL) {
            
            DateTime dt;
            
            if(programType == 'scr') {
                if(ea.Integration_Data_Exam_Scheduled_Date__c != NULL) {
                    dt = ea.Integration_Data_Exam_Scheduled_Date__c;
                } else {
                    dt = DateTime.newInstance(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.month(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.day(),8,0,0);
                }
            
            } else {            
                if(partName == 'I') {
                    dt = DateTime.newInstance(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.month(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.day(),8,0,0);
                } else {
                    dt = DateTime.newInstance(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.month(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.day(),14,0,0);            
                }
            }    
            //DateTime dt = DateTime.newInstance(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.month(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.day());            
            part.administration = dt.format('MMMMM') + ' ' + dt.format('YYYY');    
            
            part.deliveryMethod = 'Pen and Paper';
            part.provider = 'GARP';
            part.examDateTime = dt;
            part.examLocation = ea.Exam_Site__r.Name;
            part.isOSTA = (ea.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c == True && programType == 'frm');
            part.oppId = ea.Opportunity__c;                    
            part.examRegId = ea.Id;                    
            part.isPaid = (ea.Opportunity_StageName__c == 'Closed');
            part.isDeferred = (ea.Defered__c == 'Pending');              
            if(part.isDeferred) {
                dt = ea.Exam_Site__r.Exam__r.Exam_Group__r.Next_Exam_Group__r.Exam_Date__c;
                part.deferredExamAdmin = dt.format('MMMMM') + ' ' + dt.format('YYYY'); 
                part.nextAdminOpenDate = ea.Exam_Site__r.Exam__r.Exam_Group__r.Next_Exam_Group__r.Exam_Change_Start_Date_Time__c;
            } else {
                
                // If old can only be deferred or has results                    
                part.isScheduled = TRUE;
                part.isSchedulingLapsed = FALSE;
                
                part.isPassed = (!ea.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c && ea.Result__c != NULL && ea.Result__c == 'Pass');        
                                
                part.lastDateForADA = ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_ADA__c;
                part.lastDateForRAD = ea.Exam_Site__r.Exam__r.Exam_Group__r.Religious_Alternative_Last_Date__c;

                if(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c != NULL) {
                    
                    system.debug('isAwaitingTicket:' + ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c + ':' + tdy + ':' + ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c.addDays(-30) + ':' + ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c);
                    
                    part.isAwaitingTicket = (part.isPaid && part.isScheduled && 
                                             ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c != NULL &&
                                             tdy >= ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c.addDays(-30) &&
                                             tdy < ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c);
                    
                    part.isTicketAvailable = (part.isPaid && part.isScheduled && 
                                              ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c != NULL &&
                                              tdy >= ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c &&
                                              tdy <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.addDays(2));
                    
                    part.isSeatAllocated = (ea.Seat_No__c != NULL);
                    part.ticketAvailableDate = ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c;
                }
                part.ticketDownloadDate = ea.Ticket_Download_Date__c;                
                
                // Results
                //DateTime erad = ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c;
                //part.examResultsAvailableDate = Date.newInstance(erad.year(), erad.month(), erad.day());
                part.examResultsAvailableDate =  ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c;
                                
                if(tdy > ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c && (part.isScheduled || part.deliveryMethod == 'Pen and Paper')) {
                    
                    if(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c != NULL) {
                        if(now < ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c) {
                            part.isExamAwaitingResults = True;
                        } else {
                            part.isExamResultsAvailable = True;
                            if(now <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c.addDays(90)) {
                                part.showExamResults = True;
                            }
                                
                            if(ea.Result__c != NULL && ea.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c == False) {
                                part.result = ea.Result__c; 
                                part.hasViloation = ea.hasViolation__c;
                            } else {
                                part.result = NULL;  
                            }
                        }
                    }
                }                
                
            }
            part.isSetupComplete = true;
            
        } else {
            
            DateTime dt;
            Date examEndDate;
            if(ea.Exam_Part__r.Exam_Date__c != NULL) {
                //dt = DateTime.newInstance(ea.Exam_Part__r.Exam_Date__c.year(), ea.Exam_Part__r.Exam_Date__c.month(), ea.Exam_Part__r.Exam_Date__c.day());
                examEndDate = ea.Exam_Part__r.Exam_Date__c;
                if(ea.Integration_Data_Exam_Scheduled_Date__c != NULL) {
                    examEndDate = Date.newInstance(ea.Integration_Data_Exam_Scheduled_Date__c.year(),ea.Integration_Data_Exam_Scheduled_Date__c.month(), ea.Integration_Data_Exam_Scheduled_Date__c.day());
                }
                                    
                if(partName == 'I') {
                    dt = DateTime.newInstance(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.month(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.day(),8,0,0);
                } else {
                    dt = DateTime.newInstance(ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.year(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.month(), ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.day(),14,0,0);            
                }
                
            } else {
                dt = DateTime.newInstance(ea.Exam_Part__r.Exam_Start_Date__c.year(), ea.Exam_Part__r.Exam_Start_Date__c.month(), ea.Exam_Part__r.Exam_Start_Date__c.day());
                part.isScheduleWindowAvailable = True;
                examEndDate = ea.Exam_Part__r.Exam_End_Date__c;
                if(ea.Integration_Data_Exam_Scheduled_Date__c != NULL) {
                    examEndDate = Date.newInstance(ea.Integration_Data_Exam_Scheduled_Date__c.year(),ea.Integration_Data_Exam_Scheduled_Date__c.month(), ea.Integration_Data_Exam_Scheduled_Date__c.day());
                }                
            }
            part.administration = dt.format('MMMMM') + ' ' + dt.format('YYYY');     
            
            part.deliveryMethod = ea.Exam_Part__r.Delivery_Method__c;
            part.provider = ea.Exam_Site__r.Exam_Provider__r.Name;
            if(part.provider == 'GARP') {
                part.examLocation = ea.Exam_Site__r.Name;
                
                List<Venue__c> lstVenue = [select Id, Name, Institution_Name__c, Building_Name__c, Address1__c, Address2__c,City__c, State__c,Zipcode__c,Country__c from Venue__c where Site__c = :ea.Exam_Site__r.Site__c and Active__c = True];
                if(lstVenue != NULL && lstVenue.size() > 0) {
                    Venue__c v = lstVenue[0];
                    if(v.Address1__c != NULL) {
                        part.examLocation = '';                    
                        if(v.Institution_Name__c != NULL) {
                            part.examLocation += v.Institution_Name__c;
                        }
                        if(v.Building_Name__c!= NULL) {
                            if(part.examLocation != '') { part.examLocation += ', '; }
                            part.examLocation += v.Building_Name__c;
                        }
                        if(v.Address1__c!= NULL)  {
                            if(part.examLocation != '') { part.examLocation += ', '; }
                            part.examLocation += v.Address1__c;
                        }
                        if(v.Address2__c!= NULL)  {
                            if(part.examLocation != '') { part.examLocation += ', '; }
                            part.examLocation += v.Address2__c;
                        }
                        if(v.City__c != NULL)  {
                            if(part.examLocation != '') { part.examLocation += ', '; }
                            part.examLocation += v.City__c;
                        }
                        if(v.State__c != NULL)  {
                            if(part.examLocation != '') { part.examLocation += ', '; }
                            part.examLocation += v.State__c;
                        }
                        if(v.Zipcode__c!= NULL)  {
                            if(part.examLocation != '') { part.examLocation += ', '; }
                            part.examLocation += v.Zipcode__c;
                        }
                        if(v.Country__c != NULL)  {
                            if(part.examLocation != '') { part.examLocation += ', '; }
                            part.examLocation += v.Country__c;
                        }                    
                    }
                }
                part.examDateTime = dt;
            } else {
                part.examLocation = ea.Integration_Data_Exam_Location__c;
                part.examDateTime = ea.Integration_Data_Exam_Scheduled_Date__c;
            }
            part.isOSTA = (ea.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c == True && programType == 'frm');
            part.oppId = ea.Opportunity__c;                    
            part.examRegId = ea.Id;                    
            part.isPaid = (ea.Opportunity_StageName__c == 'Closed');
            part.isDeferred = (ea.Defered__c == 'Pending');  
            
            Date amdt = ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_To_Apply_For_Deferral__c;
            if(ea.Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c != NULL) {
            	amdt = ea.Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c;        
            }            
            part.adminModStartDate = DateTime.newInstance(amdt.year(), amdt.month(), amdt.day(), 0, 0, 0);
            
            Date amet =  ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_To_Request_Exam_Change__c;
            if(ea.Exam_Administration__r.Exam_Admin_Modifications_End_Date__c != NULL) {
            	amet = ea.Exam_Administration__r.Exam_Admin_Modifications_End_Date__c;    
            }                
            part.adminModEndDate = DateTime.newInstance(amet.year(), amet.month(), amet.day(), 23, 59, 59);
            if(now >= part.adminModStartDate && now <= part.adminModEndDate) {
                part.isAdminModOpen = true;
            }
            
            if(part.isDeferred) {
                
                Set<String> examPartNames;
                if(programType == 'frm') {
                    examPartNames = new Set<String>{'FRM Part 1', 'FRM Part 2'};
                } else if(programType == 'erp') {
                    examPartNames = new Set<String>{'ERP Exam Part I', 'ERP Exam Part II'};
                } else {
                    examPartNames = new Set<String>{'SCR'};
                }        
                Decimal partNum = (partName == 'I') ? 1 : 2;
                
                System.debug('examPartNames:' + examPartNames);
                System.debug('partNum:' + partNum);
                
                List<Exam_Part__c> examParts = [select Id, Name, Exam__c, Exam_Administration__c, Delivery_Method__c, Exam_Part_Number__c,
                                                Exam_Date__c, Exam_Start_Date__c
                                                from 
                                                Exam_Part__c where 
                                                Exam_Administration__c = :ea.Deferred_Exam_Administration__c AND Exam__r.Exam__c in :examPartNames AND Exam_Part_Number__c = :partNum];        
                
                System.debug('examParts:' + examParts);
                
                Exam_Part__c fndPart;
                if(examParts != NULL && examParts.size() > 0) {
                    fndPart = examParts[0];
                }
                
                if(fndPart.Exam_Date__c != NULL) {
                    dt = DateTime.newInstance(fndPart.Exam_Date__c.year(), fndPart.Exam_Date__c.month(), fndPart.Exam_Date__c.day());
                } else {
                    dt = DateTime.newInstance(fndPart.Exam_Start_Date__c.year(), fndPart.Exam_Start_Date__c.month(), fndPart.Exam_Start_Date__c.day());
                }
                part.deferredExamAdmin = dt.format('MMMMM') + ' ' + dt.format('YYYY');            
                
                DateTime st = ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Change_Start_Date_Time__c;
                Date esdt = Date.newInstance(st.year(), st.month(), st.day());
                if(ea.Exam_Administration__r.Exam_Scheduling_Start_Date__c != NULL) {
                	esdt = ea.Deferred_Exam_Administration__r.Exam_Scheduling_Start_Date__c;
                }
                part.nextAdminOpenDate = DateTime.newInstance(esdt.year(), esdt.month(), esdt.day(), 0, 0, 0);
                
            } else {
                
                DateTime st = ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Change_Start_Date_Time__c;
                Date esdt = Date.newInstance(st.year(), st.month(), st.day());
                if(ea.Exam_Administration__r.Exam_Scheduling_Start_Date__c != NULL) {
                    esdt = ea.Exam_Administration__r.Exam_Scheduling_Start_Date__c;
                }
                part.schedulingStartDate = DateTime.newInstance(esdt.year(), esdt.month(), esdt.day(), 0, 0, 0);	
                    	
                Date eedt = ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_To_Request_Exam_Change__c;
                if(ea.Exam_Administration__r.Exam_Scheduling_End_Date__c != NULL) {
                    eedt = ea.Exam_Administration__r.Exam_Scheduling_End_Date__c;
                }
                part.schedulingEndDate = DateTime.newInstance(eedt.year(), eedt.month(), eedt.day(), 23, 59, 59);
                if(now >= part.schedulingStartDate && now <= part.schedulingEndDate) {
                    part.isSchedulingOpen = true;
                }
                part.schedulingEndDate = DateTime.newInstance(eedt.year(), eedt.month(), eedt.day(), 23, 59, 59);	
                if(now >= part.schedulingStartDate && now <= part.schedulingEndDate) {	
                    part.isSchedulingOpen = true;	
                }
                part.isScheduled = (ea.Exam_Part__r.Delivery_Method__c == 'CBT' && ea.Integration_Data_Exam_Scheduled_Date__c != NULL);
                // AG Modify for Deadline Changes	
                part.isSchedulingLapsed = !ea.Allow_Scheduling_Override__c && ea.Integration_Data_Exam_Scheduled_Date__c == NULL && ea.Exam_Part__r.Delivery_Method__c == 'CBT'&& tdy > part.schedulingEndDate;	
                //part.isSchedulingLapsed = !ea.Allow_Scheduling_Override__c && ea.Integration_Data_Exam_Scheduled_Date__c == NULL && ea.Exam_Part__r.Delivery_Method__c == 'CBT'&& tdy > ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_To_Request_Exam_Change__c;
                part.isPassed = (!ea.Exam_Administration__r.Exam_Results_Loading__c && ea.Result__c != NULL && ea.Result__c == 'Pass');        
                
                part.isAwaitingTicket = (part.isPaid && ea.Exam_Part__r.Delivery_Method__c != 'CBT' &&
                                         ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c != NULL &&
                                         tdy >= ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c.addDays(-30) &&
                                         tdy < ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c);
                
                part.isTicketAvailable = (part.isPaid && ea.Exam_Part__r.Delivery_Method__c != 'CBT' &&
                                          ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c != NULL &&
                                          tdy >= ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c &&
                                          tdy <= ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c.addDays(2));
                
                part.isSeatAllocated = (ea.Seat_No__c != NULL);
                part.ticketAvailableDate = ea.Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c;
                part.ticketDownloadDate = ea.Ticket_Download_Date__c;
                
                part.lastDateForADA = ea.Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_ADA__c;
                part.lastDateForRAD = ea.Exam_Site__r.Exam__r.Exam_Group__r.Religious_Alternative_Last_Date__c;

                // Results
                if(ea.Exam_Administration__r.Exam_Results_Release_Date__c != NULL) {
                    //DateTime erad = ea.Exam_Administration__r.Exam_Results_Release_Date__c;
                    //part.examResultsAvailableDate = Date.newInstance(erad.year(), erad.month(), erad.day());
                    part.examResultsAvailableDate = ea.Exam_Administration__r.Exam_Results_Release_Date__c;
                    
                    if(tdy > examEndDate && (part.isScheduled || part.deliveryMethod == 'Pen and Paper')) {
                        
                        if(now < ea.Exam_Administration__r.Exam_Results_Release_Date__c) {
                            part.isExamAwaitingResults = True;
                        } else {
                            part.isExamResultsAvailable = True;
                            if(ea.Result__c != NULL && ea.Exam_Administration__r.Exam_Results_Loading__c == False) {
                                part.result = ea.Result__c;                                 
                                part.hasViloation = ea.hasViolation__c;
                            } else {
                                part.result = NULL;  
                            }
                        }
                        
                    }
                }else if(ea.Exam_Administration__r.Exam_Results_Available_Statement__c != NULL) {
                    part.examResultsAvailableStatement = ea.Exam_Administration__r.Exam_Results_Available_Statement__c;
                    
                    if(tdy > examEndDate && (part.isScheduled || part.deliveryMethod == 'Pen and Paper')) {
                        part.isExamAwaitingResults = True;
                    }
                }
                
                // If Results are entered override awaiting results
                if(ea.Result__c != NULL && ea.Exam_Administration__r.Exam_Results_Loading__c == False) {
                    part.isScheduled = True;
                    part.isExamAwaitingResults = False;
                    part.examResultsAvailableDate = NULL;
                    part.examResultsAvailableStatement = NULL;
                    
                    part.isExamResultsAvailable = True;                        
                    part.result = ea.Result__c;                                 
                    part.hasViloation = ea.hasViolation__c;                    
                }                
            }
            
            
            System.debug('part:' + part);
            
            // Is Setup Completed?
            // Need ID info, Gender id Saudi and Paper, Exam Auth if CBT, and Scheduled
            part.isSetupComplete = true;
            if(!part.isDeferred) {
                if(pri.idNumber == NULL ||
                   pri.idType == NULL ||
                   pri.idName == NULL) {
                       part.isSetupComplete = false;
                   }
                
                if(ea.Exam_Site__r.Site__r.Is_Gender_Required__c && pri.gender == NULL) {
                    part.isSetupComplete = false;
                }
                
                if(part.isOSTA) {
                    if(pri.ostaChineseName == NULL ||
                       pri.ostaDateOfBirth == NULL ||
                       pri.ostaPhone == NULL ||
                       pri.ostaWorkStatus == NULL ||
                       pri.ostaCompany == NULL ||
                       pri.ostaEducationStatus == NULL ||
                       pri.ostaSchool == NULL ||
                       pri.ostaDegree == NULL) {
                           part.isSetupComplete = false;
                       }
                    
                }                
                if(part.deliveryMethod == 'CBT') {
                    // No Scheduled Time on record, they need to schedule with provider still
                    if(ea.Active_Integration_Data__c == NULL || ea.Integration_Data_Exam_Scheduled_Date__c == NULL || ea.Integration_Data_Exam_Location__c == NULL) {
                        part.isSetupComplete = false;
                    }                    
                }
            }
            
            if(ea.Allow_Scheduling_Override__c) {
                part.isSetupComplete = true;
            }
            
        }

        System.debug('part:' + part);
        return part;
    }

    
    
    static public programInfo getProgramData(String programType) {
        programInfo pri = new programInfo();
        
        // Set Default Values
        pri.name = programType == 'frm' ? 'Financial Risk Manager' : programType == 'erp' ? 'Energy Risk Professional' : 'Sustainability and Climate Risk';
        pri.type = programType;
        pri.isEnrolled = False;
        pri.isLapsed = False;
        pri.isAllPartsPassed = False;
        pri.isAllPartsPassedHideCard = False;
        pri.isCVAwaitingReview = False;
        pri.isCertified = False;
        pri.isRegistrationOpen = False;
        pri.isPartIAvailableForRegistration = False;
        pri.isPartIIAvailableForRegistration = False;
        //pri.isAdminAvailable = False;
        //pri.isDeferralAvailable = False;
        pri.isMissingFullID = False;
        
        Date tdy = Date.today();
        DateTime now = DateTime.now();
        pri.currentExamYear = (tdy.Month() > 11) ? String.valueOf(tdy.year() + 1) :  String.valueOf(tdy.year());
        pri.mostReleventPart = null;
        
        if(programType == 'frm' || programType == 'erp') {
            partInfo pi1 = new partInfo();
            
            pi1.name = programType == 'frm' ? 'FRM Exam Part I' : 'ERP Exam Part I';
            pi1.isOSTA = False;
            pi1.isPaid = False;
            pi1.isScheduled = False;                
            pi1.isSetupComplete = False;                
            pi1.isSchedulingLapsed = False;                
            pi1.isPassed = False;                
            pi1.isDeferred = False;                
            pi1.isExamAwaitingResults = False;
            pi1.isExamResultsAvailable = False;
            pi1.showExamResults = False;
            pi1.isScheduleWindowAvailable = False;
            pi1.isActiveExamGroup = False;
            pi1.hasViloation = False;
            pi1.allowSchedulingOverride = False;
            pi1.isSchedulingOpen = False;
            pi1.isAdminModOpen = False;
                        
            partInfo pi2 = new partInfo();
            pi2.name = programType == 'frm' ? 'FRM Exam Part II' : 'ERP Exam Part II';
            pi2.isOSTA = False;
            pi2.isPaid = False;
            pi2.isScheduled = False;                
            pi2.isSetupComplete = False;                
            pi2.isSchedulingLapsed = False;                
            pi2.isPassed = False;                
            pi2.isDeferred = False;     
            pi2.isExamAwaitingResults = False;
            pi2.isExamResultsAvailable = False;
            pi2.showExamResults = False;
            pi2.isScheduleWindowAvailable = False;
            pi2.isActiveExamGroup = False;
            pi2.hasViloation = False;
            pi2.allowSchedulingOverride = False;	
            pi2.isSchedulingOpen = False;
            pi2.isAdminModOpen = False;
            
            pri.part1 = pi1;
            pri.part2 = pi2;
        } else {
            partInfo pi1 = new partInfo();
            
            pi1.name = 'SCR Exam';
            pi1.isOSTA = False;
            pi1.isPaid = False;
            pi1.isScheduled = False;                
            pi1.isSetupComplete = False;                
            pi1.isSchedulingLapsed = False;                
            pi1.isPassed = False;                
            pi1.isDeferred = False;    
            pi1.isExamAwaitingResults = False;
            pi1.isExamResultsAvailable = False;
            pi1.isActiveExamGroup = False;
            
            pri.part1 = pi1;
        }
        
        System.debug('pri:' + pri);
        
        //system.assert(false, 'BOOM!3'+ pri );
        
        // User and Contact
        String userId ;
        if(test.isRunningTest()){
           User u = [Select id from user LIMIT 1];  
           userId = u.Id; 
        } else {
            userId = UserInfo.getUserId(); 
        }
        Contact contact;
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        system.debug('userId======>'+userId);
        system.debug('lstUser.id==========>'+lstUser[0].id);
        system.debug('lstUser.ContactId==========>'+lstUser[0].ContactId);
        if( lstUser != null && lstUser.size() > 0 ) {   
            List<Contact> lstCont = new List<Contact>();
            if(test.isRunningTest()){
                lstCont = [Select Id, Name, AccountId, Name_as_it_Appears_on_ID__c, 
                           ID_Type__c,First_Name_as_it_Appears_on_ID__c,
                           Middle_Name_as_it_Appears_on_ID__c,Last_Name_as_it_Appears_on_ID__c,
                           ID_Number__c, ID_Expiration_Date__c,Full_Name_in_Chinese__c,
                           Gender__c, Birthdate, Currently_Working_Status__c, Company__c,
                           Currently_in_School_Status__c,School_Name__c, 
                           Degree_Program_Name__c, HomePhone, OSTA_Full_ID__c  from Contact LIMIT 1];
            
            } else {
            lstCont = [Select Id, Name, AccountId, Name_as_it_Appears_on_ID__c, First_Name_as_it_Appears_on_ID__c, Middle_Name_as_it_Appears_on_ID__c, Last_Name_as_it_Appears_on_ID__c,
                                     ID_Type__c, ID_Number__c, ID_Expiration_Date__c, 
                                     Full_Name_in_Chinese__c, Gender__c, Birthdate, Currently_Working_Status__c, Company__c, Currently_in_School_Status__c,
                                     School_Name__c, Degree_Program_Name__c, HomePhone, OSTA_Full_ID__c 
                                     from Contact where Id = :lstUser[0].ContactId];
            
            }
                        
            if(lstCont != NULL && lstCont.size() > 0) {
                contact = lstCont[0];
                
                LIST<Contract> OSTAPrograms = [
                    SELECT Id, Name, Status, RecordType.Name, AccountId, EndDate
                    FROM Contract
                    WHERE 
                    AccountId = :contact.AccountId AND
                    RecordType.Name = 'OSTA Program' AND
                    Status LIKE 'Activated%'
                    Order by StartDate DESC
                ];
                
                if(programType == 'scr') {
                //system.assert(false, 'BOOM!3'+ programType );
                    if(contact.First_Name_as_it_Appears_on_ID__c != NULL) {
                        pri.idName = contact.First_Name_as_it_Appears_on_ID__c;
                    }
                    if(contact.Middle_Name_as_it_Appears_on_ID__c != NULL) {
                        if(pri.idName != NULL) {
                            pri.idName = pri.idName + ' ';
                        }
                        pri.idName += contact.Middle_Name_as_it_Appears_on_ID__c;
                    }
                    if(contact.Last_Name_as_it_Appears_on_ID__c != NULL) {
                        if(pri.idName != NULL) {
                            pri.idName = pri.idName + ' ';
                        }
                        pri.idName += contact.Last_Name_as_it_Appears_on_ID__c;
                    }
                    
                } else {
                    pri.idName = contact.Name_as_it_Appears_on_ID__c;                
                }
                pri.idNumber = contact.ID_Number__c;
                pri.idType = contact.ID_Type__c;
                pri.idExpireDate = contact.ID_Expiration_Date__c;
                pri.gender = contact.Gender__c;
                pri.ostaChineseName = contact.Full_Name_in_Chinese__c;
                pri.ostaDateOfBirth = contact.Birthdate;
                pri.ostaPhone = contact.HomePhone;
                pri.ostaWorkStatus = contact.Currently_Working_Status__c;
                pri.ostaCompany = contact.Company__c;
                pri.ostaEducationStatus = contact.Currently_in_School_Status__c;
                pri.ostaSchool = contact.School_Name__c;
                pri.ostaDegree = contact.Degree_Program_Name__c;
                
                if(pri.idNumber != NULL && pri.idNumber.length() == 5 && contact.OSTA_Full_ID__c == NULL && !OSTAPrograms.isEmpty()) {
                    pri.isMissingFullID = TRUE;
                }
                
            } else {
                return null;
            }
            
            System.debug('contact:' + contact);
            System.debug('pri:' + pri);            
           
            // Contract
            String recordTypeName = programType.toUpperCase() + ' Program';
            LIST<Contract> programs = [
                SELECT Id, Name, Status, RecordType.Name, AccountId, EndDate
                FROM Contract
                WHERE 
                AccountId = :contact.AccountId AND
                RecordType.Name = :recordTypeName AND
                (Status LIKE 'Activated%' OR Status = 'Expired' OR Status = 'Completed')
                Order by StartDate DESC
            ];
            
            System.debug('programs:' + programs);
            
            MAP<String,Boolean> mapExamPartPass = new MAP<String,Boolean>();
            if(programs != NULL && programs.size() > 0) {
                Contract program = programs[0];
                
                if(program.Status == 'Expired'&& programType != 'scr') {
                    pri.isLapsed = True;
                } else if(program.Status == 'Completed') {
                    pri.isCertified = True;   
                } else {
                    pri.isEnrolled = True;    
                }
                pri.programExpireDate = program.EndDate;
                
                System.debug('pri:' + pri);

                // Check Program Parts
                if(programType != 'scr') {
                    
                    List<Candidate_Requirement__c> lstCanReq = [select Id, Name, Status__c, Exam__c, Date_of_Completion__c from Candidate_Requirement__c where Candidate_Commitment__c = :program.Id];                    
                    System.debug('lstCanReq:' + lstCanReq);

                    Integer partCnt=0;
                    Date mostRecentPass= Date.newInstance(1970, 1, 1);
                    if(lstCanReq != NULL && lstCanReq.size() > 0) {
                        for(Candidate_Requirement__c cr:lstCanReq) {
                            if(cr.Status__c == 'Completed' && cr.Exam__c != NULL) {
                                mapExamPartPass.put(cr.Exam__c,TRUE);  
                                partCnt++;
                                if(cr.Exam__c == 'FRM Full' || cr.Exam__c == 'ERP') {
                                    partCnt++;
                                }
                                if(cr.Date_of_Completion__c > mostRecentPass) {
                                    mostRecentPass = cr.Date_of_Completion__c;
                                }
                            } else if(cr.Exam__c != NULL) {
                                mapExamPartPass.put(cr.Exam__c,FALSE);
                            } else if(cr.Status__c == 'Ready For Review') {
                                // Job Awaiting Review
                                pri.isCVAwaitingReview = True;
                            } else if(cr.Status__c == 'Failed Review') {
                                // Job Awaiting Review
                                pri.isCVFailedReview = True;
                            }
                        }
                    }
                    
                    System.debug('partCnt:' + lstCanReq);
                    System.debug('mapExamPartPass:' + mapExamPartPass);
                    
                    if(partCnt == 2) {
                        pri.isAllPartsPassed = True; 
                        if(tdy > mostRecentPass.addDays(60)) {
                            pri.isAllPartsPassedHideCard = True;
                        }
                    }   
                    
                    System.debug('pri:' + pri);
                    
                }
            }
            
            // Active Exam Group
            List<Exam_Group__c> lstExamGroup;
            if(programType == 'frm' || programType == 'erp') {
                lstExamGroup = [select Id, Name, Registration_Start_Date__c, Last_Date_For_Early_Registration__c, Last_Date_For_Standard_Registration__c, Exam_Change_Start_Date_Time__c, 
                                        Last_Date_To_Request_Exam_Change__c, Exam_Results_Available_Date__c,Last_Date_To_Apply_For_Deferral__c,
                                        Next_Exam_Group__r.Registration_Start_Date__c, Next_Exam_Group__r.Exam_Change_Start_Date_Time__c
                                        
                                from Exam_Group__c where Active__c = True];       
            } else {
                lstExamGroup = [select Id, Name, Registration_Start_Date__c, Last_Date_For_Early_Registration__c, Last_Date_For_Standard_Registration__c, Exam_Change_Start_Date_Time__c, 
                                        Last_Date_To_Request_Exam_Change__c, Exam_Results_Available_Date__c,Last_Date_To_Apply_For_Deferral__c,
                                        Next_Exam_Group__r.Registration_Start_Date__c, Next_Exam_Group__r.Exam_Change_Start_Date_Time__c
                                from Exam_Group__c where SCR_Active__c = True];       
            }
            
            System.debug('lstExamGroup:' + lstExamGroup);
            
            if(lstExamGroup != NULL && lstExamGroup.size() > 0) {
                Exam_Group__c examGroup = lstExamGroup[0];
                if(tdy >= examGroup.Registration_Start_Date__c && tdy <= examGroup.Last_Date_For_Standard_Registration__c) {
                    pri.isRegistrationOpen = True;
                    
                    if(tdy >= examGroup.Registration_Start_Date__c && tdy <= examGroup.Last_Date_For_Early_Registration__c) {
                        pri.currentWindow = 'Early';
                        pri.currentWindowEndDate = examGroup.Last_Date_For_Early_Registration__c;
                    } else {
                        pri.currentWindow = 'Standard';
                        pri.currentWindowEndDate = examGroup.Last_Date_For_Standard_Registration__c;                        
                    }
                    
                }
                pri.registrationCloseDate = examGroup.Last_Date_For_Standard_Registration__c;
                
                // AG Remove for new deadlines
                //if(now >= examGroup.Exam_Change_Start_Date_Time__c && tdy <= examGroup.Last_Date_To_Request_Exam_Change__c) {
                //    pri.isAdminAvailable = True;
                //}
                //if(now >= examGroup.Exam_Change_Start_Date_Time__c && tdy <= examGroup.Last_Date_To_Apply_For_Deferral__c) {
                //    pri.isDeferralAvailable = True;
                //}
                // AG Remove for new deadlines
                //pri.adminAvailableStartDate = examGroup.Exam_Change_Start_Date_Time__c;
                //pri.adminAvailableEndDate = examGroup.Last_Date_To_Request_Exam_Change__c;                
                
                pri.nextRegistrationOpenDate = examGroup.Next_Exam_Group__r.Registration_Start_Date__c;
                //pri.nextAdminOpenDate = examGroup.Next_Exam_Group__r.Exam_Change_Start_Date_Time__c;
                
                // activeExamGroupName
                List<String> parts = new List<String>();
                if(programType == 'frm') {
                    parts.add('FRM Part 1');
                    parts.add('FRM Part 2');
                } else if(programType == 'erp') {
                    parts.add('ERP Exam Part I');
                    parts.add('ERP Exam Part II');
                } else if(programType == 'scr') {
                    parts.add('SCR');
                }
                List<Exam_Part__c> lstExamParts = [Select Id, Exam_Date__c, Exam_Start_Date__c from Exam_Part__c where Exam__r.Exam__c in :parts];
            }
            
            System.debug('priX:' + pri);
            
            if(programType == 'frm') {
                
                FrmRegistrationForm form = new FrmRegistrationForm();
                ExamRegistrationForm.RegistrationEligibility ee = form.getEligibileExams(contact.Id);
                System.debug('ee:' + ee);      
                pri.registrationEligibility = ee;
                
                if(ee != NULL && ee.eligibleExams != NULL && ee.eligibleExams.contains('FRM Part 1')) {
                    pri.isPartIAvailableForRegistration = True;
                }
                
                if(ee != NULL && ee.eligibleExams != NULL && ee.eligibleExams.contains('FRM Part 2')) {
                    pri.isPartIIAvailableForRegistration = True;
                }

            } else if(programType == 'erp') {
                ErpRegistrationForm form = new ErpRegistrationForm();
                ExamRegistrationForm.RegistrationEligibility ee = form.getEligibileExams(contact.Id);
                System.debug('ee:' + ee);                
                pri.registrationEligibility = ee;
                    
                if(ee != NULL && ee.eligibleExams != NULL && ee.eligibleExams.contains('ERP Exam Part I')) {
                    pri.isPartIAvailableForRegistration = True;
                }

                if(ee != NULL && ee.eligibleExams != NULL && ee.eligibleExams.contains('ERP Exam Part II')) {
                    pri.isPartIIAvailableForRegistration = True;
                }
            } else if(programType == 'scr') {
                
                ScrExamRegistrationForm form = new ScrExamRegistrationForm();
                ExamRegistrationForm.RegistrationEligibility ee = form.getEligibileExams(contact.Id);
                System.debug('ee:' + ee);                
                pri.registrationEligibility = ee;
                
                if(ee != NULL && ee.eligibleExams != NULL && ee.eligibleExams.contains('SCR')) {
                    pri.isPartIAvailableForRegistration = True;
                }
            }
            
            System.debug('pri:' + pri);
            
            // Exam Registrations
            List<String> examName;
            if(programType == 'frm') {
                examName = new list<String> { 'FRM Part 1', 'FRM Part 2', 'FRM Full Program' };
            } else if(programType == 'erp') {
                examName = new list<String> { 'ERP Exam Part I', 'ERP Exam Part II', 'ERP' };
            } else {
                examName = new list<String> { 'SCR' };                        
            }
            
            System.debug('examName:' + examName);
            
            List<Exam_Attempt__c> lstExamReg = [select Id, Exam_Site__c, Defered__c, Deferral_Status__c, Deferred_Exam_Administration__c,
                                                Deferred_Exam_Administration__r.Exam_Scheduling_Start_Date__c,	
                                                Deferred_Exam_Administration__r.Exam_Scheduling_End_Date__c,
                                                Deferred_Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c,
                                                Deferred_Exam_Administration__r.Exam_Admin_Modifications_End_Date__c,
                                                Result__c,hasViolation__c,Allow_Scheduling_Override__c,
                                                Exam_Site__r.Name,
                                                Exam_Site__r.Exam__r.Exam__c, 
                                                Exam_Site__r.Exam__r.Exam_Group__c, Member__c, Opportunity_StageName__c,
                                                Opportunity__c, Opportunity__r.AccountId, Integration_Data_Status__c, Seat_No__c,
                                                Active_Integration_Data__c, Active_Integration_Data__r.Call_out_Status__c, Ticket_Download_Date__c,
                                                Integration_Data_Exam_Location__c, 
                                                Integration_Data_Exam_Scheduled_Date__c,
                                                Exam_Part__r.Delivery_Method__c,
                                                Exam_Administration__r.Name,
                                                Exam_Administration__r.Exam_Results_Loading__c,
                                                Exam_Administration__r.Exam_Results_Release_Date__c,
                                                Exam_Administration__r.Exam_Results_Available_Statement__c,
                                                Exam_Administration__r.Exam_Scheduling_Start_Date__c,	
                                                Exam_Administration__r.Exam_Scheduling_End_Date__c,
                                                Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c,
                                                Exam_Administration__r.Exam_Admin_Modifications_End_Date__c,
                                                Exam_Part__r.Exam_Date__c,
                                                Exam_Part__r.Exam_Start_Date__c,                                                
                                                Exam_Part__r.Exam_End_Date__c,
												Exam_Site__r.Exam__r.Exam_Group__r.Exam_Change_Start_Date_Time__c,                                                
                                                Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_To_Request_Exam_Change__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_To_Apply_For_Deferral__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Exam_Ticket_Available_Date__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Exam_Results_Available_Date__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Last_Date_For_ADA__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Religious_Alternative_Last_Date__c,
                                                Exam_Site__r.Exam_Provider__r.Name,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Active__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.SCR_Active__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Next_Exam_Group__r.Registration_Start_Date__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Next_Exam_Group__r.Exam_Change_Start_Date_Time__c,
                                                Exam_Site__r.Exam__r.Exam_Group__r.Next_Exam_Group__r.Exam_Date__c,
                                                Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,
                                                Exam_Site__r.Site__r.Is_Gender_Required__c
                                                from Exam_Attempt__c where 
                                                Member__c = :contact.Id AND Cancelled__c = False AND
                                                Exam_Site__r.Exam__r.Exam__c in :examName ORDER BY Exam_Site__r.Exam__r.Exam_Group__r.Exam_Date__c DESC, Registered_On__c DESC];         
            
            System.debug('lstExamReg:' + lstExamReg);
            
            // Get Exam Registrations By Part
            if(lstExamReg != NULL && lstExamReg.size() > 0) {
                Exam_Attempt__c p1;
                Exam_Attempt__c p2;
                for(Exam_Attempt__c ea: lstExamReg) {
                    
                    System.debug('ea:' + ea);
                    System.debug('ea.Exam_Site__r.Exam__r.Exam__c:' + ea.Exam_Site__r.Exam__r.Exam__c);
                    
                    if(programType == 'scr' && p1 == null) {
                        p1 = ea;
                    } else if(p1 == NULL && (ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1' || ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Full Program' || ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I' || ea.Exam_Site__r.Exam__r.Exam__c == 'ERP')) {
                        p1 = ea;
                    } else if(p2 == NULL && (ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2' || ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II')) {
                        p2 = ea;
                    }
                    System.debug('set p1:' + p1);
                    System.debug('set p2:' + p2);
                }
                
                System.debug('p1:' + p1);
                System.debug('p2:' + p2);
                
                // Compute Part 1 Data
                if(p2 != null) {
                    pri.part2 = setProgramPartInfo(programType, pri, p2, 'II', pri.part2);
                    pri.mostReleventPart = '2';
                    System.debug('pri.part2:' + pri.part2);
                }

                if(p1 != null) {
                    pri.part1 = setProgramPartInfo(programType, pri, p1, 'I', pri.part1);
                    pri.mostReleventPart = '1';
                    System.debug('pri.part1:' + pri.part1);   
                }

                
            }            
            
        }        
        
        return pri;
    }

    static public void updateOSTAIDInfo(Id contactId, String idType, String idNumber, Date expDate) {
        
        DateTime now = DateTime.now();
        List<Contact> lstCont = [select Id, ID_Type__c, ID_Number__c, ID_Expiration_Date__c, OSTA_Consent__c, OSTA_Full_ID__c from Contact where id = :contactId];
        if(lstCont != NULL && lstCont.size() > 0) {
            Contact contact = lstCont[0];
            if(idType.indexOf('Driver') > -1) {
                contact.ID_Type__c = 'Driver\'s License';
            } else {
                contact.ID_Type__c = idType;    
            }
            contact.ID_Number__c = idNumber.right(5);
            contact.OSTA_Full_ID__c = idNumber;
            contact.ID_Expiration_Date__c = expDate;
            contact.OSTA_Consent__c = now;
            update contact;
        }
        
        programInfo pi = getProgramData('frm');

        Set<String> regIDs = new Set<String>();
        if(pi.part1.isOSTA) {
            regIDs.add(pi.part1.examRegId);
        }
        if(pi.part2.isOSTA) {
            regIDs.add(pi.part2.examRegId);
        }
        
        if(!regIDs.isEmpty()) {
            List<Exam_Attempt__c> eas = [select id, OSTA_Consent__c from Exam_Attempt__c where id in :regIDs];
            if(!eas.isEmpty()) {
                for(Exam_Attempt__c ea :eas) {
                    ea.OSTA_Consent__c = now;
                }
                update eas;
            }
        }

    }
    
    static public void createCBTIntegrationAuthorization(String examRegId) {
        List<Exam_Attempt__c> lstEA = [select Id, RPT_Exam_Provider__c, Integration_Type__c, Outbound_Type__c, ATA_PSI_Is_Override__c from Exam_Attempt__c where id = :examRegId];
        if(lstEA != NULL && lstEA.size() > 0) {
            Exam_Attempt__c ea = lstEA[0];
            
            ea.Outbound_Type__c = NULL;
            ea.Integration_Type__c = NULL;
            update lstEA;
            
            if(ea.RPT_Exam_Provider__c == 'PSI') {
                ea.Outbound_Type__c = lstEA[0].RPT_Exam_Provider__c;
                ea.Integration_Type__c = 'Eligibility Lifecycle';
                update lstEA;
            } else if(ea.RPT_Exam_Provider__c == 'ATA') {
                ea.Outbound_Type__c = lstEA[0].RPT_Exam_Provider__c;
                ea.Integration_Type__c = 'Import Registration New';
                update lstEA;            
            }

        }

    }
 
    static public Opportunity findRefundOpp(Exam_Attempt__c ea) {
      
        System.debug('findRefundOpp In:' + ea);
        
        Set<String> opIDs = new Set<String>();
        
        // Get Main EA
        Exam_Attempt__c mainEA;
        mainEA=fetchExamRegistrationInContext(ea.Id);
        if(mainEA != NULL) {
            opIDs.add(mainEA.Opportunity__c);
            if(mainEA.Opportunity_Line_Items__r != NULL) {
                for(OpportunityLineItem oli :mainEA.Opportunity_Line_Items__r) {
                    opIDs.add(oli.OpportunityId);    
                }
                
            }
        }
        
        System.debug('opIDs:' + opIDs);
        
        // Find Cloned EA
        Exam_Attempt__c clonedEA;
        if(ea.Cloned_From__c!=NULL) {
            clonedEA=fetchExamRegistrationInContext(ea.Cloned_From__c);
            if(clonedEA != NULL) {
                opIDs.add(clonedEA.Opportunity__c);
                if(clonedEA.Opportunity_Line_Items__r != NULL) {
                    for(OpportunityLineItem oli :clonedEA.Opportunity_Line_Items__r) {
                        opIDs.add(oli.OpportunityId);    
                    }                
                }
            }
        }
        
        System.debug('clonedEA:' + clonedEA);
        System.debug('opIDs:' + opIDs);
        
        // Get all Opps and Refunds
        List<Opportunity> lstOpp = [select Id, Name,
                                    (SELECT Id, ProductCode, Product2Id, Product2.ProductCode, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice FROM OpportunityLineItems)
                                    from Opportunity where ID in :opIDs Order BY CreatedDate DESC];
        MAP<String,Integer> mapOpp = new MAP<String,Integer>();
        for(Opportunity opp :lstOpp) {
            for(OpportunityLineItem ol :opp.OpportunityLineItems) {
                if(ol.ProductCode == 'CHLF') {
                    Integer cnt = mapOpp.get(opp.Id);
                    if(cnt == NULL) {
                        mapOpp.put(opp.Id, 1);    
                    } else {
                        cnt++;
                        mapOpp.put(opp.Id, cnt); 
                    }
                }
            }
        }

        System.debug('lstOpp:' + lstOpp);
        System.debug('mapOpp:' + mapOpp);

        List<Product_Refunds__c> lstRef = [select Id, Name, Opportunity__c from Product_Refunds__c where Opportunity__c in :opIDs AND Product_Code__c = 'CHLF' AND Status__c != 'Denied'];
        MAP<String,Integer> mapRef = new MAP<String,Integer>();
        for(Product_Refunds__c pr :lstRef) {
            Integer cnt = mapRef.get(pr.Opportunity__c);
            if(cnt == NULL) {
                mapRef.put(pr.Opportunity__c, 1);    
            } else {
                cnt++;
                mapRef.put(pr.Opportunity__c, cnt); 
            }
        }
        
        System.debug('mapRef:' + mapRef);        

        // Get latest Opp with fee and not all refunded
        for(Opportunity opp :lstOpp) {

            Integer fndOpp = mapOpp.get(opp.Id);
            System.debug('fndOpp:' + fndOpp ); 
            if(fndOpp != NULL) {
                           
                Integer pr = mapRef.get(opp.Id);
                System.debug('find pr:' + pr);        
                
                if(pr == NULL || pr < fndOpp ) {
                    System.debug('return fndOpp:' + fndOpp);    
                    return opp;
                }
            }                
        }
        
        return NULL;
    }
    
    //@future(callout=true)
    static public List<Product_Refunds__c> issueProductRefund(String OppId, String prodCode, Integer part) {
        
        System.debug('part:' + part);
        
        List<Opportunity> lstOppFnd = [select Id, Name,
                                       (SELECT Id, ProductCode, Product2Id, Product2.ProductCode, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice FROM OpportunityLineItems)
                                       from Opportunity where ID = :OppId];
        
        System.debug('lstOppFnd:' + lstOppFnd);
        
        Set<Id> opportunityIds = new Set<Id>();
        opportunityIds.add(OppId);
        System.Debug('opportunityIds:' + opportunityIds);
        
        Map<Id, ChargentSFA__Transaction__c> approvedTransactionByOpportunityId = getApprovedTransactionByOpportunityIdMap(opportunityIds);
        System.Debug('approvedTransactionByOpportunityId:' + approvedTransactionByOpportunityId );
                    
        
        List<Product_Refunds__c> prs = new List<Product_Refunds__c>();
        Integer cnt=1;
        for(OpportunityLineItem ol :lstOppFnd[0].OpportunityLineItems) {
            
            System.debug('ol:' + ol);
            System.debug('cnt:' + cnt);
            
            if(ol.ProductCode == prodCode) {
            
                if(cnt <= part) {                
                    Product_Refunds__c productRefund = new Product_Refunds__c();
                    
                    productRefund.Payment_Transaction__c    = null;
                    productRefund.Status__c                 = 'Submitted';
                    productRefund.Product__c                = ol.Product2Id;
                    productRefund.Opportunity__c            = OppId;         
                    productRefund.Reason__c                 = ol.Description;
                    productRefund.Refund_Amount__c          = (ol.UnitPrice*ol.Quantity).setScale(2);
                    productRefund.Sales_Price__c            = (ol.UnitPrice*ol.Quantity).setScale(2);
                    productRefund.Opportunity_Product_ID__c = ol.Id;
                    
                    if(approvedTransactionByOpportunityId.containsKey(OppId)){
                        productRefund.Payment_Transaction__c = approvedTransactionByOpportunityId.get(OppId).Id;
                    }     
                    
                    System.debug('Add productRefund:' + productRefund);
                    prs.add(productRefund);    
                    }
                
                cnt++;                                
            }
            
        }    
        
        System.debug('prs:' + prs);
        
        return prs;
    }
    
    static public ostaMaps computeOSTAProgramMoves(Exam_Attempt__c examRegPartI, Exam_Attempt__c examRegPartII, Exam_Sites__c currentSitePartI, Exam_Sites__c currentSitePartII, Exam_Administration__c currentAdminPartI, Exam_Administration__c currentAdminPartII,
                                                   Exam_Sites__c selectedSitePartI, Exam_Sites__c selectedSitePartII, Exam_Administration__c selectedAdminPartI, Exam_Administration__c selectedAdminPartII
                                                  ) {

                                                      
            ostaMaps om = new ostaMaps(); 
                                                      
            System.debug('examRegPartI:' + examRegPartI);
            System.debug('examRegPartII:' + examRegPartII);
            System.debug('currentSitePartI:' + currentSitePartI);
            System.debug('currentSitePartII:' + currentSitePartII);
            System.debug('currentAdminPartI:' + currentAdminPartI);
            System.debug('currentAdminPartII:' + currentAdminPartII);
            System.debug('selectedSitePartI:' + selectedSitePartI);
            System.debug('selectedSitePartII:' + selectedSitePartII);
            System.debug('selectedAdminPartI:' + selectedAdminPartI);
            System.debug('selectedAdminPartII:' + selectedAdminPartII);
            
            om.mapCurrentPartOSTA = new MAP<String,Exam_Part__c>();
            om.mapSelectedPartOSTA = new MAP<String,Exam_Part__c>();
        
            //system.debug('currentSitePartII=========>'+currentSitePartII);
            //system.debug('currentSitePartII.Site__r.Is_OSTA_Information_Required__c=========>'+currentSitePartII.Site__r.Is_OSTA_Information_Required__c);
            //system.debug('currentSitePartII.Site__c=========>'+currentSitePartII.Site__c);
                                                      
            if(currentSitePartII != NULL && currentSitePartII.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapCurrentAdminOSTA.put(currentSitePartII.Exam_Part__r.Exam_Administration__c, currentSitePartII.Exam_Part__r);
                om.mapCurrentPartOSTA.put(currentSitePartII.Exam_Part__c, currentSitePartII.Exam_Part__r);
            }
            if(currentSitePartI != NULL && currentSitePartI.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapCurrentAdminOSTA.put(currentSitePartI.Exam_Part__r.Exam_Administration__c, currentSitePartI.Exam_Part__r);
                om.mapCurrentPartOSTA.put(currentSitePartI.Exam_Part__c, currentSitePartI.Exam_Part__r);
            }
                                                      
            // If Part was deferred out and current site is OSTA, assume they are going to an OSTA site
            if(currentSitePartII == NULL && selectedAdminPartII != NULL && examRegPartII.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapCurrentAdminOSTA.put(currentAdminPartII.Id, examRegPartII.Exam_Site__r.Exam_Part__r);
                om.mapCurrentPartOSTA.put(examRegPartII.Exam_Site__r.Exam_Part__c, examRegPartII.Exam_Site__r.Exam_Part__r);
            }
            if(currentSitePartI == NULL && selectedAdminPartI != NULL && examRegPartI.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapCurrentAdminOSTA.put(currentAdminPartI.Id, examRegPartI.Exam_Site__r.Exam_Part__r);
                om.mapCurrentPartOSTA.put(examRegPartI.Exam_Site__r.Exam_Part__c, examRegPartI.Exam_Site__r.Exam_Part__r);
            }
            
            if(selectedSitePartII != NULL && selectedSitePartII.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapSelectedAdminOSTA.put(selectedSitePartII.Exam_Part__r.Exam_Administration__c, selectedSitePartII.Exam_Part__r);
                om.mapSelectedPartOSTA.put(selectedSitePartII.Exam_Part__c, selectedSitePartII.Exam_Part__r);
            }
            if(selectedSitePartI != NULL && selectedSitePartI.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapSelectedAdminOSTA.put(selectedSitePartI.Exam_Part__r.Exam_Administration__c, selectedSitePartI.Exam_Part__r);
                om.mapSelectedPartOSTA.put(selectedSitePartI.Exam_Part__c, selectedSitePartI.Exam_Part__r);
            }
            // If Part was deferred out and current site is OSTA, assume they are going to an OSTA site
            if(selectedSitePartII == NULL && selectedAdminPartII != NULL && examRegPartII.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapSelectedAdminOSTA.put(selectedAdminPartII.Id, examRegPartII.Exam_Site__r.Exam_Part__r);
                om.mapSelectedPartOSTA.put(examRegPartII.Exam_Site__r.Exam_Part__c, examRegPartII.Exam_Site__r.Exam_Part__r);
            }
            if(selectedSitePartI == NULL && selectedAdminPartI != NULL && examRegPartI.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c) {
                //om.mapSelectedAdminOSTA.put(selectedAdminPartI.Id, examRegPartI.Exam_Site__r.Exam_Part__r);
                om.mapSelectedPartOSTA.put(examRegPartI.Exam_Site__r.Exam_Part__c, examRegPartI.Exam_Site__r.Exam_Part__r);
            }
                  
            System.debug('mapCurrentPartOSTA:' + om.mapCurrentPartOSTA);
            System.debug('mapSelectedPartOSTA:' + om.mapSelectedPartOSTA);
                                                      
            return om;
        
    }
    
    /*static public void processExamRegMods(Set<Id> setExamRegMods, boolean doNotCountOneTimeDefrl, boolean freeDeferral) {
                 
        // Get Data based on Current and Selected Admins and Sites
        Set<Id> setAdmins = new Set<Id>();
        Set<Id> setSites = new Set<Id>();
        Set<Id> setRegistrations = new Set<Id>();
        Set<Id> setExamGroups = new Set<Id>();
        Set<Id> setAccounts = new Set<Id>();
        
        MAP<String,Exam_Administration__c> mapExamAdmin = new MAP<String,Exam_Administration__c>();
        MAP<String,Exam_Attempt__c> mapExamAttempt = new MAP<String,Exam_Attempt__c>();
        MAP<String,Exam_Sites__c> mapExamSite = new MAP<String,Exam_Sites__c>();
        MAP<String,Contract> mapOSTACont = new MAP<String,Contract>();
        MAP<String,Opportunity> mapOpp = new MAP<String,Opportunity>();
        boolean eaInActiveGroup = false;
        
        List<Exam_Attempt__c> eaUpdates = new List<Exam_Attempt__c>();
        
        
        List<Exam_Registration_Modification__c> lstExamRegMods = [
            SELECT Id, Customer_Email__c, Part_I_Exam_Admin_From__c,Part_I_Exam_Admin_To__c,
                    Part_I_Exam_Registration__c,Part_I_Exam_Site_From__c,
                    Part_I_Exam_Site_To__c,Part_II_Exam_Admin_From__c,Part_II_Exam_Admin_To__c,
                    Part_II_Exam_Registration__c,
                    Part_II_Exam_Site_From__c,
                    Part_II_Exam_Site_To__c,Status__c,User__c,
                    Part_I_Exam_Registration__r.Candidate_Commitment__r.AccountId,
                    Part_II_Exam_Registration__r.Candidate_Commitment__r.AccountId
            FROM Exam_Registration_Modification__c 
            WHERE Id = :setExamRegMods AND Status__c = 'Pending'
        ];
        
        for (Exam_Registration_Modification__c examRegMod :lstExamRegMods) {
            
            if(examRegMod.Part_I_Exam_Registration__c != NULL)
                setRegistrations.add(examRegMod.Part_I_Exam_Registration__c);
            if(examRegMod.Part_II_Exam_Registration__c != NULL)
                setRegistrations.add(examRegMod.Part_II_Exam_Registration__c);
            
            if(examRegMod.Part_I_Exam_Admin_From__c != NULL)
                setAdmins.add(examRegMod.Part_I_Exam_Admin_From__c);
            if(examRegMod.Part_II_Exam_Admin_From__c != NULL)
                setAdmins.add(examRegMod.Part_II_Exam_Admin_From__c);
            if(examRegMod.Part_I_Exam_Admin_To__c != NULL)
                setAdmins.add(examRegMod.Part_I_Exam_Admin_To__c);
            if(examRegMod.Part_II_Exam_Admin_To__c != NULL)
                setAdmins.add(examRegMod.Part_II_Exam_Admin_To__c);
            
            if(examRegMod.Part_I_Exam_Site_From__c != NULL)
                setSites.add(examRegMod.Part_I_Exam_Site_From__c);
            if(examRegMod.Part_II_Exam_Site_From__c != NULL)
                setSites.add(examRegMod.Part_II_Exam_Site_From__c);
            if(examRegMod.Part_I_Exam_Site_To__c != NULL)
                setSites.add(examRegMod.Part_I_Exam_Site_To__c);
            if(examRegMod.Part_II_Exam_Site_To__c != NULL)
                setSites.add(examRegMod.Part_II_Exam_Site_To__c);
        }
        
        // Get Data
        List<Exam_Administration__c> examAdmins = [select Id, Name, Exam_Group__c, Exam_Type__c 
                          from Exam_Administration__c 
                          where Id in :setAdmins];
        
        for(Exam_Administration__c ea :examAdmins) {
            mapExamAdmin.put(ea.Id, ea);
            setExamGroups.add(ea.Exam_Group__c);
        }
        
        List<Exam_Attempt__c> lstExamReg = [select Id, Exam_Administration__c, Exam_Part__c, Member_Email__c,
                                            Exam_Site__c, Defered__c, Deferral_Status__c, Future_Free_Deferral__c,
                                            Cloned_From__c, Exam_Site__r.Exam__r.Exam_Group__c, Member__c,
                                            Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,
                                            Exam_Site__r.Exam_Part__r.Exam_Part_Number__c,Result__c,
                                            Opportunity__c, Opportunity__r.AccountId, RPT_Exam_Program__c,
                                            Exam_Administration__r.Exam_Group__r.Active__c,Exam_Administration__r.Exam_Group__r.SCR_Active__c
                                            from 
                                            Exam_Attempt__c where
                                            Id in :setRegistrations];           
        
        for(Exam_Attempt__c ea :lstExamReg) {
            system.debug('ea.Exam_Administration__r.Exam_Group__r.Active__c'+ea.Exam_Administration__r.Exam_Group__r.Active__c);
            system.debug('ea.Exam_Administration__r.Exam_Group__r.SCR_Active__c'+ea.Exam_Administration__r.Exam_Group__r.SCR_Active__c);
            if(ea.Exam_Administration__r.Exam_Group__r.Active__c || ea.Exam_Administration__r.Exam_Group__r.SCR_Active__c){
                eaInActiveGroup = true;
            }
            mapExamAttempt.put(ea.Id, ea);
            setExamGroups.add(ea.Exam_Site__r.Exam__r.Exam_Group__c);
            setAccounts.add(ea.Opportunity__r.AccountId);
        }
        
        LIST<Contract> ostaPrograms = [
            SELECT Id, Name, Status, RecordType.Name, AccountId, OSTA_Last_Upload_Date__c
            FROM Contract
            WHERE 
             AccountId in :setAccounts AND
            RecordType.Name = 'OSTA Program' AND
            Status LIKE 'Activated%'
        ];
        
        for(Contract con :ostaPrograms) {
            mapOSTACont.put(con.AccountId, con);
        }
        
        List<Opportunity> lstOpp = [select Id, AccountId from Opportunity where Exam_Registration_Modification__c in :setExamRegMods];
        for(Opportunity opp :lstOpp) {
            mapOpp.put(opp.AccountId, Opp);
        }
        
        List<Exam_Sites__c> lstExamSites = [               
            SELECT 
            Id, 
            Name,
            Exam_Part__c,
            Exam_Part__r.Exam_Administration__c, 
            Exam_Part__r.Exam__r.Exam__c,
            Exam_Part__r.Exam_Part_Number__c,
            Exam__c, 
            Exam__r.Exam__c, 
            Exam__r.Exam_Group__c,
            Site__c, 
            Site__r.Name, 
            Site__r.Is_OSTA_Information_Required__c, 
            Site__r.Is_Gender_Required__c, 
            Site__r.AM_Exam_Capacity_Available__c, 
            Site__r.PM_Exam_Capacity_Available__c 
            FROM Exam_Sites__c
            WHERE 
            Id in :setSites
        ];                                      
        
        for(Exam_Sites__c ea :lstExamSites) {
            mapExamSite.put(ea.Id, ea);
            setExamGroups.add(ea.Exam__r.Exam_Group__c);
        }
        
        System.Debug('mapExamSite:' + mapExamSite);
        
        // Process Modifications
        for (Exam_Registration_Modification__c examRegMod :lstExamRegMods) {
            
            System.Debug('examRegMod:' + examRegMod);

            Exam_Attempt__c er1 = mapExamAttempt.get(examRegMod.Part_I_Exam_Registration__c);
            Exam_Attempt__c er2 = mapExamAttempt.get(examRegMod.Part_II_Exam_Registration__c);
            
            Exam_Sites__c es1f = mapExamSite.get(examRegMod.Part_I_Exam_Site_From__c);
            Exam_Sites__c es2f = mapExamSite.get(examRegMod.Part_II_Exam_Site_From__c);
            Exam_Sites__c es1t = mapExamSite.get(examRegMod.Part_I_Exam_Site_To__c);
            Exam_Sites__c es2t = mapExamSite.get(examRegMod.Part_II_Exam_Site_To__c);

            Exam_Administration__c ea1f = mapExamAdmin.get(examRegMod.Part_I_Exam_Admin_From__c);
            Exam_Administration__c ea2f = mapExamAdmin.get(examRegMod.Part_II_Exam_Admin_From__c);
            Exam_Administration__c ea1t = mapExamAdmin.get(examRegMod.Part_I_Exam_Admin_To__c);
            Exam_Administration__c ea2t = mapExamAdmin.get(examRegMod.Part_II_Exam_Admin_To__c);
            
            System.debug('er1:' + er1);
            System.debug('er2:' + er2);
            
            System.debug('es1f:' + es1f);
            System.debug('es2f:' + es2f);
            System.debug('es1t:' + es1t);
            System.debug('es2t:' + es2t);
            
            System.debug('ea1f:' + ea1f);
            System.debug('ea2f:' + ea2f);
            System.debug('ea1t:' + ea1t);
            System.debug('ea2t:' + ea2t);
            
            Boolean updateER1 = false;
            Boolean updateER2 = false;
            Set<ID> OSTAAdminsOut = new Set<ID>();
            Set<ID> OSTAAdminsIn = new Set<ID>();
            String AccountId = (er1 != NULL) ? examRegMod.Part_I_Exam_Registration__r.Candidate_Commitment__r.AccountId : examRegMod.Part_II_Exam_Registration__r.Candidate_Commitment__r.AccountId;
            System.debug('AccountId:' + AccountId);
            
            Opportunity Opp = mapOpp.get(AccountId);
            System.debug('Opp:' + Opp);

            if((er1 != NULL && (ea1f == NULL || ea1t == NULL)) ||
               (er2 != NULL && (ea2f == NULL || ea2t == NULL))) {
                   examRegMod.Status__c = 'Error';
                   System.debug('Error:' + examRegMod.Status__c);
                   continue;
               }
            if(eaInActiveGroup){
                 if(er1 != null && doNotCountOneTimeDefrl){
                    er1.Selected_To_Allow_Future_Deferral__c = true;
                     if(er1.Result__c != null && er1.Result__c ==
                        
                        
                        'No-Show')
                        er1.Result__c = null;
                    updateER1 = True;
                }
                if(er1 != null && freeDeferral){
                    er1.Future_Free_Deferral__c = true;
                    if(er1.Result__c != null && er1.Result__c == 'No-Show')
                        er1.Result__c = null;
                    updateER1 = True;
                }
                if(er2 != null && doNotCountOneTimeDefrl){
                    er2.Selected_To_Allow_Future_Deferral__c = true;
                    if(er2.Result__c != null && er2.Result__c == 'No-Show')
                        er2.Result__c = null;
                    updateER2 = True;
                }
                if(er2 != null && freeDeferral){
                    er2.Future_Free_Deferral__c = true;
                    if(er2.Result__c != null && er2.Result__c == 'No-Show')
                        er2.Result__c = null;
                    updateER2 = True;
                }
                // Move Admin Between Groups - Deferral Out
                if(er1 != NULL && ea1f.Id != ea1t.Id && ea1f.Exam_Group__c != ea1t.Exam_Group__c && ea1t.Exam_Group__c != er1.Exam_Site__r.Exam__r.Exam_Group__c) {
                    er1.Defered__c = 'Pending';
                    er1.Deferral_Status__c = 'Deferred Out';
                    er1.Deferred_Exam_Administration__c = ea1t.Id;
                    updateER1=True;
                    
                    System.debug('defer er1:' + er1);
                }
                
                if(er2 != NULL && ea2f.Id != ea2t.Id && ea2f.Exam_Group__c != ea2t.Exam_Group__c && ea2t.Exam_Group__c != er2.Exam_Site__r.Exam__r.Exam_Group__c) {
                    er2.Defered__c = 'Pending';
                    er2.Deferral_Status__c = 'Deferred Out';
                    er2.Deferred_Exam_Administration__c = ea2t.Id;
                    updateER2=True;
                    
                    System.debug('defer er2:' + er2);
                }
                
                // Move Admin Between Groups - UnDeferral
                if(er1 != NULL && ea1f.Id != ea1t.Id && ea1f.Exam_Group__c != ea1t.Exam_Group__c && ea1t.Exam_Group__c == er1.Exam_Site__r.Exam__r.Exam_Group__c) {
                    er1.Defered__c = NULL;
                    er1.Deferral_Status__c = NULL;
                    er1.Deferred_Exam_Administration__c = NULL;
                    er1.Exam_Site__c = es1t.Id;
                    er1.Exam_Administration__c = ea1t.Id;
                    er1.Exam_Part__c = es1t.Exam_Part__c;
                    updateER1=True;
                    
                    System.debug('undefer er1:' + er1);
                }
                
                if(er2 != NULL && ea2f.Id != ea2t.Id && ea2f.Exam_Group__c != ea2t.Exam_Group__c && ea2t.Exam_Group__c == er2.Exam_Site__r.Exam__r.Exam_Group__c) {
                    er2.Defered__c = NULL;
                    er2.Deferral_Status__c = NULL;
                    er2.Deferred_Exam_Administration__c = NULL;
                    er2.Exam_Site__c = es2t.Id;
                    er2.Exam_Administration__c = ea2t.Id;
                    er2.Exam_Part__c = es2t.Exam_Part__c;
                    
                    updateER2=True;
                    
                    System.debug('undefer er2:' + er2);
                }
                
                // Move Admin Between Within same Groups in current group
                if(er1 != NULL && ea1f.Id != ea1t.Id && ea1f.Exam_Group__c == ea1t.Exam_Group__c ) {
                    
                    // If in current Exam Group
                    if(ea1t.Exam_Group__c == er1.Exam_Site__r.Exam__r.Exam_Group__c) {
                        er1.Exam_Administration__c = ea1t.Id;
                        er1.Exam_Part__c = es1t.Exam_Part__c;
                        er1.Exam_Part__c = es1t.Exam_Part__c;
                    } else {
	                    er1.Deferred_Exam_Administration__c = ea1t.Id;                        
                    }
                    
                    updateER1=True;
                    
                    System.debug('move admin er1:' + er1);
                }
                
                if(er2 != NULL && ea2f.Id != ea2t.Id && ea2f.Exam_Group__c == ea2t.Exam_Group__c ) {
                    
                    // If in current Exam Group
                    if(ea2t.Exam_Group__c == er2.Exam_Site__r.Exam__r.Exam_Group__c) {
                        er2.Exam_Administration__c = ea2t.Id;
                        er2.Exam_Part__c = es2t.Exam_Part__c;
                        er2.Exam_Part__c = es2t.Exam_Part__c;
                    } else { 
	                    er2.Deferred_Exam_Administration__c = ea2t.Id;                        
                    }
                    
                    updateER2=True;
                    
                    System.debug('move admin er2:' + er2);
                }

                // Site Change            
                System.debug('site change er1:' + er1 + '~' + es1f + ':' + es1t);
                
                if(er1 != NULL && 
                   ((es1f == NULL && es1t != NULL) ||
                    (es1f != NULL && es1t != NULL && es1f.Id != es1t.Id))) {
                        er1.Exam_Site__c = es1t.Id;
                        er1.Exam_Administration__c = ea1t.Id;
                        er1.Exam_Part__c = es1t.Exam_Part__c;
                        
                        //er1.Defered__c = NULL;
                        //er1.Deferral_Status__c = NULL;
                        //er1.Deferred_Exam_Administration__c = NULL;
                        
                        updateER1=True;
                        //Opp = mapOpp.get(er1.Opportunity__r.AccountId);
                        //AccountId = Opp.AccountID;
                        
                        System.debug('site change er1:' + er1);
                    }
                
                if(er2 != NULL && es2f != NULL && es2t != NULL && es2f.Id != es2t.Id) {
                    er2.Exam_Site__c = es2t.Id;
                    er2.Exam_Administration__c = ea2t.Id;
                    er2.Exam_Part__c = es2t.Exam_Part__c;
                    
                    //er2.Defered__c = NULL;
                    //er2.Deferral_Status__c = NULL;
                    //er2.Deferred_Exam_Administration__c = NULL;
                    
                    updateER2=True;      
                    //Opp = mapOpp.get(er2.Opportunity__r.AccountId);
                    //AccountId = Opp.AccountID;
                    
                    System.debug('site change er2:' + er2);
                }
                
                System.debug('updateER1:' + updateER1);
                System.debug('updateER2:' + updateER2);
                
                if(updateER1)
                    eaUpdates.add(er1);
                if(updateER2)
                    eaUpdates.add(er2);
            }

            // OSTA            
            List<Product_Refunds__c> productRefunds = new List<Product_Refunds__c>();
            if((er1 != NULL && er1.RPT_Exam_Program__c == 'FRM') || (er2 != NULL && er2.RPT_Exam_Program__c == 'FRM')) {
                
                Contract ostaCon = mapOSTACont.get(AccountId);
                
                // Setup Admin OSTA Data
                MAP<String,Exam_Part__c> mapCurrentAdminOSTA = new MAP<String,Exam_Part__c>();
                MAP<String,Exam_Part__c> mapSelectedAdminOSTA = new MAP<String,Exam_Part__c>();
                
                ostaMaps om = computeOSTAProgramMoves(er1, er2, es1f, es2f, ea1f, ea2f, es1t, es2t, ea1t, ea2t);
                
                System.debug('mapCurrentPartOSTA:' + om.mapCurrentPartOSTA);
                System.debug('mapSelectedPartnOSTA:' + om.mapSelectedPartOSTA);
                
                Integer totalCurrentPartWithOSTA = om.mapCurrentPartOSTA.size();
                Integer totalSelectedPartWithOSTA = om.mapSelectedPartOSTA.size();
                
                System.debug('totalCurrentPartWithOSTA :' + totalCurrentPartWithOSTA );
                System.debug('totalSelectedPartWithOSTA:' + totalSelectedPartWithOSTA);
                
                System.Debug('ostaPrograms:' + ostaPrograms);
                
                // If no OSTA program exists and have any OSTA Admins, create one 
                if((ostaPrograms == NULL || ostaPrograms.size() == 0) && totalSelectedPartWithOSTA > 0 && opp != NULL) {
                    createOstaProgram(opp,NULL);
                }
                
                // if Less OSTA selected, refund it
                if(totalSelectedPartWithOSTA < totalCurrentPartWithOSTA) {
                    
                    // If have OSTA Program and not uploaded data and now no Parts with OSTA then cancel program and refund
                    if(ostaPrograms != NULL && ostaPrograms.size() > 0 && ostaPrograms[0].OSTA_Last_Upload_Date__c == NULL && totalSelectedPartWithOSTA == 0) {
                        Contract ostaProgram = cancelOstaProgram(AccountId);
                        if(ostaProgram.Opportunity__c != NULL) {
                            List<Product_Refunds__c> prs = issueProductRefund(ostaProgram.Opportunity__c, 'CHNDF', 1);
                            for(Product_Refunds__c pr :prs) {
                                productRefunds.add(pr);
                            }
                        }
                    }
                    
                    Set<Decimal> partsInvolved = new Set<Decimal>();
                    Set<String> oppsInvolved = new Set<String>();
                    Exam_Attempt__c eaRefund=NULL;
                    Exam_Attempt__c eaRefundOther=NULL;
                    String contactID;
                    for(String curkey :om.mapCurrentPartOSTA.keySet()) {
                        
                        Exam_Part__c curVal = om.mapCurrentPartOSTA.get(curkey);
                        Exam_Part__c selVal = om.mapSelectedPartOSTA.get(curkey);
                        
                        System.debug('curVal:' + curVal);
                        System.debug('selVal:' + selVal);
                        
                        if(selVal == NULL && curVal != NULL) {
                            partsInvolved.add(curVal.Exam_Part_Number__c);
                            if(curVal.Exam_Part_Number__c == 1) {
                                oppsInvolved.add(er1.Opportunity__c);
                            } else {
                                oppsInvolved.add(er2.Opportunity__c);
                            }
                            
                        }
                    }
                    System.debug('partsInvolved:' + partsInvolved);
                    System.debug('oppsInvolved:' + oppsInvolved);
                    
                    Integer numberOfLocationRefunds = (totalCurrentPartWithOSTA - totalSelectedPartWithOSTA);
                    System.debug('numberOfLocationRefunds :' + numberOfLocationRefunds);
                    
                    if(partsInvolved.contains(1)) {
                        eaRefund = er1;
                        contactID = er1.Member__c;
                        if(er2 != NULL) {
                            eaRefundOther = er2;
                        }
                    } else if(partsInvolved.contains(2)) {
                        eaRefund = er2;
                        contactID = er2.Member__c;
                        if(er1 != NULL) {
                            eaRefundOther = er1;
                        }
                    }
                    
                    System.debug('eaRefund :' + eaRefund );
                    System.debug('eaRefundOther :' + eaRefundOther );
                    
                    // Issue Refund for eaRefund
                    if(eaRefund != NULL) {
                        Opportunity oppRefund = findRefundOpp(eaRefund);    
                        System.debug('findRefundOpp:' + oppRefund);
                        
                        if(oppRefund == NULL && eaRefundOther != NULL) {                        
                            oppRefund = findRefundOpp(eaRefundOther);    
                            System.debug('findRefundOpp Other:' + oppRefund);                        
                        }
                        
                        if(oppRefund != NULL) {
                            List<Product_Refunds__c> prs = issueProductRefund(oppRefund.Id, 'CHLF',numberOfLocationRefunds);
                            for(Product_Refunds__c pr :prs) {
                                productRefunds.add(pr);
                            }
                        } else {
                            AppError__c appError = new AppError__c();
                            appError.Error__c = 'No OSTA fee found to refund';
                            appError.Contact__c = contactID;
                            appError.Message__c = 'No OSTA fee found to refund';
                            insert appError;
                        }
                        
                    }         
                    
                    System.debug('oppsInvolved.size:' + oppsInvolved.size());
                    if(oppsInvolved.size() == 2 && numberOfLocationRefunds == 2) {
                        if(eaRefundOther != NULL) {  
                            Opportunity oppRefund = findRefundOpp(eaRefundOther);    
                            System.debug('findRefundOpp Other:' + oppRefund);
                            
                            if(oppRefund != NULL) {
                                List<Product_Refunds__c> prs = issueProductRefund(oppRefund.Id, 'CHLF',numberOfLocationRefunds);
                                for(Product_Refunds__c pr :prs) {
                                    productRefunds.add(pr);
                                }
                            }
                        }
                    }
                }
            }
            
            if(productRefunds.size() > 0) {
                insert productRefunds;
            }
            
            if(eaInActiveGroup)
                examRegMod.Status__c = 'Completed';
            if(er1 != NULL) {
                examRegMod.Customer_Email__c = er1.Member_Email__c;    
            } else if(er2 != NULL) {
                examRegMod.Customer_Email__c = er2.Member_Email__c;    
            }
            //system.assert(false, 'BOOM!3'+ examRegMod + ':' + examRegMod );
            
        }
        
        if(eaUpdates.size() > 0)
            update eaUpdates;
        
        Update lstExamRegMods;
    }*/
    
    static public OpportunityLineItem createOppLineItem(String oppId, prodLine pl, MAP<String, Product2> mapProdCode, MAP<String, PricebookEntry> mapPrice) {
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem(); 
        
        System.Debug('oppId: ' + oppId);
        System.Debug('prodLine: ' + pl);
        System.Debug('mapProdCode: ' + mapProdCode);
        System.Debug('mapPrice: ' + mapPrice);
        
        if(pl.prodCode != NULL) {
            
            Product2 fndProd = mapProdCode.get(pl.prodCode);
            if(fndProd != NULL) {
                PricebookEntry fndPrice = mapPrice.get(fndProd.Id);
                system.debug('fndProd.Id=========>'+fndProd.Id);
                if(fndPrice != NULL) {
                    oppLineItem.Exam_Registration__c    = pl.examRegId;
                    oppLineItem.Exam_Site__c            = pl.examSiteId;
                    oppLineItem.Description             = pl.description; 
                    oppLineItem.UnitPrice               = pl.amount;
                    oppLineItem.OpportunityId           = oppId;
                    oppLineItem.PricebookEntryId        = fndPrice.Id;
                    oppLineItem.Quantity                = 1;
                    
                    System.Debug('insert oppLineItem: ' + oppLineItem);

                    insert oppLineItem;
                }
            }
            
        }
        
        return oppLineItem;
    }
    
    public static Opportunity createExamRescheduleOpp(Contact objContact, TempAccount objData) {
        Opportunity opp = new Opportunity();
        if(!test.isRunningTest()){ 
        opp = Registration.CreateOpportunity(objContact, objData);
        }  
        return opp;
        
    }
        
    static public examRescheduleData createExamRescheduleFeesOrderInternal(String examGroupId, String program, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII, Id userId, boolean freeDeferral,string subType) {

        system.debug('examGroupId:' + examGroupId);
        system.debug('selectedAdminPartI:' + selectedAdminPartI);
        system.debug('selectedAdminPartII' + selectedAdminPartII);
        system.debug('selectedSitePartI' + selectedSitePartI);
        system.debug('selectedSitePartII' + selectedSitePartII);

        
        examRescheduleData erd = getExamRescheduleFeesInternal(examGroupId, program, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId,freeDeferral);

        system.debug('fees:' + erd.fees);
        
        Decimal totalFees=0;
        for(prodLine pl :erd.fees) {
            totalFees=totalFees+pl.amount;
        }
        system.debug('totalFees:' + totalFees);
        
        List<Product2> lstProducts = [select Id, Name, ProductCode, GL_Code__c, Description, Image__c from Product2 where IsActive = True];
        MAP<String, Product2> mapProdCode = new MAP<String, Product2>();
        for(Product2 p : lstProducts) {
            mapProdCode.put(p.ProductCode, p);
        }
            
        List<PricebookEntry> lstPriceBookEntry = [SELECT Id, Name, Product2Id, ProductCode, Unitprice from PriceBookEntry where Pricebook2.Name = 'GARP 2015/2016' AND Product2Id in :lstProducts];
        
        MAP<String, PricebookEntry> mapPrice = new MAP<String, PricebookEntry>();
        for(PricebookEntry pe : lstPriceBookEntry) {
            mapPrice.put(pe.Product2Id, pe);
        }
        
        if((erd.fees != NULL && erd.fees.size() > 0 && totalFees > 0) || freeDeferral) {
            TempAccount objData = new TempAccount();
            objData.siteId = selectedAdminPartI != NULL ? selectedAdminPartI : selectedAdminPartII;   
            erd.opp = createExamRescheduleOpp(erd.contact, objData);
        }
        
        System.debug('erd.opp:' + erd.opp);
        
        insert erd.ExamRegMod;
        
        if((erd.fees != NULL && erd.fees.size() > 0 && totalFees > 0) || freeDeferral) {
            erd.opp.Exam_Registration_Modification__c = erd.ExamRegMod.Id;
            
            // Set Opp to Wire if CC not Allowed in these countries
            if(erd.contact.Account.BillingCountry != NULL && (erd.contact.Account.BillingCountry.toLowerCase() == 'ghana' || erd.contact.Account.BillingCountry.toLowerCase() == 'nigeria')) {
                erd.opp.Alternate_Method_of_Payment__c = 'wire'; 
            }
            
            
            Boolean partIMoved=False;
            Boolean partIIMoved=False;
            
            if(erd.currentAdminPartI != NULL && erd.selectedAdminPartI != NULL && erd.currentAdminPartI.Id != erd.selectedAdminPartI.Id) {
                partIMoved=True;
            }

            if(erd.currentAdminPartII != NULL && erd.selectedAdminPartII != NULL && erd.currentAdminPartII.Id != erd.selectedAdminPartII.Id) {
                partIIMoved=True;
            }
            
            System.debug('***partIMoved:' + partIMoved);
            System.debug('***partIIMoved:' + partIIMoved);
            
            //system.assert(false, 'BOOM!3'+ partIMoved + ':' + partIIMoved );
            
            String examParts;
            if(program == 'frm') {
                if(partIMoved && partIIMoved) {
                    examParts = 'FRM Exam Part I & FRM Exam Part II';
                } else if(partIMoved) {
                    examParts = 'FRM Exam Part I';
                } else if(partIIMoved) {
                    examParts = 'FRM Exam Part II';
                }
            } else if(program == 'erp') {
                if(partIMoved && partIIMoved) {
                    examParts = 'ERP Exam Part I & ERP Exam Part II';
                } else if(partIMoved) {
                    examParts = 'ERP Exam Part I';
                } else if(partIIMoved) {
                    examParts = 'ERP Exam Part II';
                }                
            } else {
                examParts = 'SCR';
            }
            erd.opp.Exam_Emails__c = examParts;            
            erd.opp.Deferral_SubType__c = subType;
            if(!Test.isRunningTest()){
                update erd.opp;
            }
            decimal newChargeFees = 0;
            if(erd.fees != NULL) {
                for(prodLine pl :erd.fees) {
                    if(pl.amount > 0 || pl.amount == 0 || pl.amount == 0.00) {
                        createOppLineItem(erd.opp.Id, pl, mapProdCode, mapPrice);
                        newChargeFees =+ pl.amount;
                    }
                }
            }
            
            if(freeDeferral && (newChargeFees == 0 || newChargeFees == 0.00)){
                createTransaction(erd.opp.Id);
            }
        }
        
        return erd;        
    }
        
    static public examRescheduleData getExamRescheduleFeesInternal(String examGroupId, String program, String selectedAdminPartI, String selectedAdminPartII, String selectedSitePartI, String selectedSitePartII, Id userId,boolean freeDeferral) {
               
        examRescheduleData erd = getExamRescheduleData(examGroupId, program, selectedAdminPartI, selectedAdminPartII, selectedSitePartI, selectedSitePartII, userId);
        
        system.debug('get fees erd:' + erd);
        
        erd.errMsg = null;
        erd.statusCode = null;
        erd.errorCode = null;
        
        MAP<String,String> mapMonths = new MAP<String,String>();
        mapMonths.put('January','Jan');
        mapMonths.put('February','Feb');
        mapMonths.put('March','Mar');
        mapMonths.put('April','Apr');
        mapMonths.put('May','May');
        mapMonths.put('June','June');
        mapMonths.put('July','July');
        mapMonths.put('August','Aug');
        mapMonths.put('September','Sept');
        mapMonths.put('October','Oct');
        mapMonths.put('November','Nov');
        mapMonths.put('December','Dec');
        
        
        List<Product2> lstProducts = [select Id, Name, ProductCode, GL_Code__c, Description, Image__c from Product2 where IsActive = True];
        MAP<String, Product2> mapProdCode = new MAP<String, Product2>();
        for(Product2 p : lstProducts) {
            mapProdCode.put(p.ProductCode, p);
        }
        
        List<PricebookEntry> lstPriceBookEntry = [SELECT Id, Name, Product2Id, ProductCode, Unitprice from PriceBookEntry where Product2Id in :lstProducts];
        
        MAP<String, PricebookEntry> mapPrice = new MAP<String, PricebookEntry>();
        for(PricebookEntry pe : lstPriceBookEntry) {
            mapPrice.put(pe.Product2Id, pe);
        }
        
        MAP<String,Exam_Part__c> mapExamPart = new MAP<String,Exam_Part__c>();
        for(Exam_Part__c ep : erd.examParts) {
            String key = ep.Exam_Part_Number__c + '~' + ep.Exam_Administration__c;
            mapExamPart.put(key, ep);
        }
        system.debug('get mapExamPart:' + mapExamPart);
        
        // Validation Rules
        Date tdy = Date.today();
        DateTime now = DateTime.now();
        
        // AG Change for new deadlines	
        if(erd.selectedAdminPartI != NULL && (tdy < erd.examRegPartI.Exam_Administration__r.Exam_Scheduling_Start_Date__c || tdy > erd.examRegPartI.Exam_Administration__r.Exam_Scheduling_End_Date__c)) {	
        //if(tdy > erd.examGroup.Last_Date_To_Request_Exam_Change__c || now < erd.examGroup.Exam_Change_Start_Date_Time__c) {           
                erd.errMsg = 'Exam changes are currently not available';
                erd.errorCode = 501;
        }
                        
        Exam_Part__c fndSelPart1;
        if(erd.selectedAdminPartI != NULL) {
            fndSelPart1 = mapExamPart.get('1~' + erd.selectedAdminPartI.Id);
            system.debug('get fndSelPart1:' + fndSelPart1);
        }
                
        Exam_Part__c fndSelPart2;
        if(erd.selectedAdminPartII != NULL) {
            fndSelPart2 = mapExamPart.get('2~' + erd.selectedAdminPartII.Id);
            system.debug('get fndSelPart2:' + fndSelPart2);
        }
        
        // If Part I was moved
        if(erd.examRegPartI != NULL && erd.currentAdminPartI.Id != erd.selectedAdminPartI.Id && erd.currentSitePartI != NULL && erd.selectedSitePartI == NULL) {
            
            system.debug('Part 1 moved');
            //system.assert(false, 'BOOM!3'+ program);
            
            if(erd.examRegPartI.Defered__c == 'Pending') {
                erd.errMsg = 'You cannot defer Part I because it has already been deferred out into a future exam administration. You can only defer your exam registration once.';
                erd.errorCode = 502;
            }
            if(erd.examRegPartI.Defered__c == 'Approved' && erd.examRegPartI.Allow_Future_Deferral__c == False) {
                erd.errMsg = 'You cannot defer Part I because it was deferred in from a previous exam administration. You can only defer your exam registration once.';
                erd.errorCode = 503;
            }
            
            if(erd.otherProgramExamRegPartI != NULL && erd.otherProgramExamRegPartI.Defered__c == 'Pending') {
                erd.errMsg = 'Cannot defer Part I, another program was already deferred out';
                erd.errorCode = 504;
            }
            
            if(erd.examRegPartI.Exam_Part__r.Delivery_Method__c == 'CBT' && erd.examRegPartI.Integration_Data_Exam_Scheduled_Date__c != NULL && program.ToUpperCase() == 'SCR') {
                erd.errMsg = 'To complete your SCR Exam deferral, please go to Pearson and cancel your existing exam appointment. Then, return here to select to your new date.';
                erd.errorCode = 510;
            }
            
            if(fndSelPart1 != NULL) {
                DateTime p1dt = fndSelPart1.Exam_Date__c != NULL ? fndSelPart1.Exam_Date__c : fndSelPart1.Exam_Start_Date__c;    

                if(p1dt > erd.program.Last_Exam_Deferral_Date__c) {
                    erd.errMsg = 'Cannot defer Part I beyond the end of the '+ program.ToUpperCase()  +' Program';
                    erd.errorCode = 505;
                }            
            }
            
        }
        
        // If Part II was moved out
        if(erd.examRegPartII != NULL && erd.currentAdminPartII.Id != erd.selectedAdminPartII.Id && erd.currentSitePartII != NULL && erd.selectedSitePartII == NULL) {
          
            system.debug('Part 2 moved');
            
            if(erd.examRegPartII.Defered__c == 'Pending') {
                erd.errMsg = 'Cannot defer Part II, it is already deferred out';
                erd.errorCode = 506;
            }
            if(erd.examRegPartII.Defered__c == 'Approved' && erd.examRegPartII.Allow_Future_Deferral__c == False) {
                erd.errMsg = 'Cannot defer Part II, it was deferred in from the last exam';
                erd.errorCode = 507;
            }

            if(erd.otherProgramExamRegPartII != NULL && erd.otherProgramExamRegPartII.Defered__c == 'Pending') {
                erd.errMsg = 'Cannot defer Part II, another program was already deferred out';
                erd.errorCode = 508;
            }

            Exam_Part__c fndPart2 = mapExamPart.get('2~' + erd.selectedAdminPartII.Id);
            system.debug('get fndPart2:' + fndPart2);
            
            if(fndSelPart2 != NULL) {
                DateTime p1dt = fndSelPart2.Exam_Date__c != NULL ? fndSelPart2.Exam_Date__c : fndSelPart2.Exam_Start_Date__c;
                if(p1dt > erd.program.Last_Exam_Deferral_Date__c) {
                    erd.errMsg = 'Cannot defer Part II beyond the end of the '+ program.ToUpperCase()  +' Program';
                    erd.errorCode = 509;
                }            
            }
            
        }
        
        // If have Part I and II and move Part I must move both
        //if(erd.examRegPartI != NULL && erd.examRegPartII != NULL && 
        //   erd.currentAdminPartI != NULL && erd.selectedAdminPartI != NULL && erd.currentAdminPartI != erd.selectedAdminPartI &&
        //   erd.currentAdminPartII != NULL && erd.selectedAdminPartII != NULL && erd.currentAdminPartII == erd.selectedAdminPartII
        //  ) {
        //      erd.errMsg = 'Part I cannot be moved without Part II';
        //      erd.statusCode = 510;
        //  }
        
        // Cannot move Part II before Part I
        if(erd.examRegPartI != NULL && erd.examRegPartII != NULL && erd.selectedAdminPartI != NULL && erd.selectedAdminPartII != NULL &&
            fndSelPart1 != NULL && fndSelPart2 != NULL) {
            
            DateTime p1dt = fndSelPart1.Exam_Date__c != NULL ? fndSelPart1.Exam_Date__c : fndSelPart1.Exam_Start_Date__c;
            DateTime p2dt = fndSelPart2.Exam_Date__c != NULL ? fndSelPart2.Exam_Date__c : fndSelPart2.Exam_Start_Date__c;
                
            System.debug('p1dt:' + p1dt);
            System.debug('p2dt:' + p2dt);
            
            if(p2dt < p1dt) {
                erd.errMsg = 'Part II cannot be taken before Part I';
                erd.errorCode = 511;
            }
        }
        
        //if(erd.statusCode != NULL) {
        //    return erd;
        //}
        
        LIST<Contract> ostaPrograms = [
            SELECT Id, Name, Status, OSTA_Last_Upload_Date__c
            FROM Contract
            WHERE 
            AccountId = :erd.contact.AccountId AND
            RecordType.Name = 'OSTA Program' AND
            Status LIKE 'Activated%'
        ];
        
        // See if fees exist
        List<prodLine> lstProds = new List<prodLine>();
        
        // Admin Switch
        if((erd.currentAdminPartI != NULL && erd.selectedAdminPartI != NULL && erd.currentAdminPartI.Id != erd.selectedAdminPartI.Id) ||
           (erd.currentAdminPartII != NULL && erd.selectedAdminPartII != NULL && erd.currentAdminPartII.Id != erd.selectedAdminPartII.Id)) {
               prodLine pc = new prodLine();
               
               if(program == 'frm') {
                   pc.prodCode = 'FRM1';
                   if(freeDeferral){
                       pc.amount = 0;
                   }else{
                       pc.amount = 200;
                   }
               } else if(program == 'erp') {
                   pc.prodCode = 'ENC';
                   if(freeDeferral){
                       pc.amount = 0;
                   }else{
                       pc.amount = 200;
                   }
               } else {
                   pc.prodCode = 'SCR';
                   if(freeDeferral){
                       pc.amount = 0;
                   }else{
                       pc.amount = 50;
                   }
               }
               
               // Make description
               String descrtipion;
               if(program == 'frm' && erd.currentAdminPartI != NULL && erd.currentAdminPartI.Id != erd.selectedAdminPartI.Id) {
                   descrtipion = 'FRM Part I from ' + mapMonths.get(erd.currentAdminPartI.Month__c) + ' ' + erd.currentAdminPartI.Year__c + ' to ' + mapMonths.get(erd.selectedAdminPartI.Month__c) + ' ' + erd.selectedAdminPartI.Year__c;
                   if(erd.currentAdminPartII != NULL && erd.currentAdminPartII.Id != erd.selectedAdminPartII.Id) {
                       descrtipion += ' and FRM Part II from ' + mapMonths.get(erd.currentAdminPartII.Month__c) + ' ' + erd.currentAdminPartII.Year__c + ' to ' + mapMonths.get(erd.selectedAdminPartII.Month__c) + ' ' + erd.selectedAdminPartII.Year__c;
                   }
               } else if(program == 'frm' && erd.currentAdminPartII != NULL && erd.currentAdminPartII.Id != erd.selectedAdminPartII.Id) {
                   descrtipion = 'FRM Part II from ' + mapMonths.get(erd.currentAdminPartII.Month__c) + ' ' + erd.currentAdminPartII.Year__c + ' to ' + mapMonths.get(erd.selectedAdminPartII.Month__c) + ' ' + erd.selectedAdminPartII.Year__c;
               }
               
               if(program == 'erp' && erd.currentAdminPartI != NULL && erd.currentAdminPartI.Id != erd.selectedAdminPartI.Id) {
                   descrtipion = 'of ERP Part I from ' +mapMonths.get(erd.currentAdminPartI.Month__c) + ' ' + erd.currentAdminPartI.Year__c + ' to ' + mapMonths.get(erd.selectedAdminPartI.Month__c) + ' ' + erd.selectedAdminPartI.Year__c;
                   
                   if(erd.currentAdminPartII != NULL && erd.currentAdminPartII.Id != erd.selectedAdminPartII.Id) {
                       descrtipion += ' and ERP Part II from ' + mapMonths.get(erd.currentAdminPartII.Month__c) + ' ' + erd.currentAdminPartII.Year__c + ' to ' + mapMonths.get(erd.selectedAdminPartII.Month__c) + ' ' + erd.selectedAdminPartII.Year__c;
                   }
               } else if(program == 'erp' && erd.currentAdminPartII != NULL && erd.currentAdminPartII.Id != erd.selectedAdminPartII.Id) {
                   descrtipion = 'ERP Part II from ' + mapMonths.get(erd.currentAdminPartII.Month__c) + ' ' + erd.currentAdminPartII.Year__c + ' to ' + mapMonths.get(erd.selectedAdminPartII.Month__c) + ' ' + erd.selectedAdminPartII.Year__c;
               }
               
               if(program == 'scr' && erd.currentAdminPartI != NULL && erd.currentAdminPartI.Id != erd.selectedAdminPartI.Id) {
                   descrtipion = 'SCR from ' + mapMonths.get(erd.currentAdminPartI.Month__c) + ' ' + erd.currentAdminPartI.Year__c + ' to ' + mapMonths.get(erd.selectedAdminPartI.Month__c) + ' ' + erd.selectedAdminPartI.Year__c;
               }
               
               pc.glCode = '4020';
               pc.description = descrtipion;
               pc.examRegId = null;
               pc.examSiteId = selectedSitePartI != NULL ? selectedSitePartI : selectedSitePartII;            
               lstProds.add(pc);
               erd.statusCode = 200;
           }
        
        System.Debug('Admin Fee: ' + lstProds);
        
        system.debug('erd.currentSitePartI:' + erd.currentSitePartI);
        system.debug('erd.selectedSitePartI' + erd.selectedSitePartI);
        system.debug('erd.currentSitePartII' + erd.currentSitePartII);
        system.debug('erd.selectedSitePartII' + erd.selectedSitePartII);
        

        system.debug('erd.currentAdminPartI:' + erd.currentAdminPartI);
        system.debug('erd.selectedAdminPartI' + erd.selectedAdminPartI);
        system.debug('erd.currentAdminPartII' + erd.currentAdminPartII);
        system.debug('erd.selectedAdminPartII' + erd.selectedAdminPartII);

        // Site Switch
        if((erd.currentSitePartI == NULL && erd.selectedSitePartI != NULL) ||
           (erd.currentSitePartI != NULL && erd.selectedSitePartI != NULL && erd.currentSitePartI.Id != erd.selectedSitePartI.Id) ||
           (erd.currentSitePartII != NULL && erd.selectedSitePartII != NULL && erd.currentSitePartII.Id != erd.selectedSitePartII.Id)) {
               
               erd.statusCode = 200; // Changes found but no fees or refunds
           }
        
        
        // Get OSTA Fees
        if(program == 'frm') {
            
            Decimal ostaLocationFee = 40;
            Product2 fndProd = mapProdCode.get('CHLF');
            if(fndProd != NULL) {
                PricebookEntry fndPrice = mapPrice.get(fndProd.Id);
                if(fndPrice != NULL) {
                    ostaLocationFee = fndPrice.Unitprice;
                }
            }
            
            Decimal ostaDataFee = 10;
            fndProd = mapProdCode.get('CHNDF');
            if(fndProd != NULL) {
                PricebookEntry fndPrice = mapPrice.get(fndProd.Id);
                if(fndPrice != NULL) {
                    ostaDataFee = fndPrice.Unitprice;
                }
            }        
            
            // OSTA Fees
            // Setup Admin OSTA Data
            ostaMaps om = computeOSTAProgramMoves(erd.examRegPartI, erd.examRegPartII, erd.currentSitePartI, erd.currentSitePartII, erd.currentAdminPartI, erd.currentAdminPartII, 
                                                  erd.selectedSitePartI, erd.selectedSitePartII, erd.selectedAdminPartI, erd.selectedAdminPartII);


            Decimal totalFee = 0;
            Integer totalCurrentPartWithOSTA = om.mapCurrentPartOSTA.size();
            Integer totalSelectedPartWithOSTA = om.mapSelectedPartOSTA.size();
            
            // Net fee is diff between current distinct admins with OSTA v. selected distinct Admins with OSTA
            totalFee = totalFee + (ostaLocationFee * (totalSelectedPartWithOSTA - totalCurrentPartWithOSTA));
            
            // Find Exam Reg to relate to Fee
            Set<Decimal> partsInvolved = new Set<Decimal>();
            Exam_Attempt__c eaFee;
            for(String selkey :om.mapSelectedPartOSTA.keySet()) {
                
                Exam_Part__c curVal = om.mapCurrentPartOSTA.get(selkey);
                Exam_Part__c selVal = om.mapSelectedPartOSTA.get(selkey);
                
                System.debug('curVal:' + curVal);
                System.debug('selVal:' + selVal);
                
                if(selVal != NULL && curVal == NULL) {
                    partsInvolved.add(selVal.Exam_Part_Number__c);
                }
            }
            System.debug('partsInvolved:' + partsInvolved);
            //erd.errMsg = 'Parts Involved:' + partsInvolved;
            if(partsInvolved.contains(1)) {
                eaFee = erd.examRegPartI;
            } else if(partsInvolved.contains(2)) {
                eaFee = erd.examRegPartII;
            }
            
            // If any fees add them
            if(totalFee > 0) {        
                
                if(partsInvolved.size() > 0) {
                    prodLine pc = new prodLine();
                    pc.prodCode = 'CHLF';
                    //pc.examRegId = erd.examRegPartI != NULL ? erd.examRegPartI.Id : erd.examRegPartII.Id;
                    //pc.examSiteId = erd.selectedSitePartI != NULL ? erd.selectedSitePartI.Id : erd.selectedSitePartII.Id;
                    pc.glCode = '2008';
                    pc.description = 'OSTA Location Fee';
                    pc.amount = ostaLocationFee;
                    pc.examRegId = eaFee.Id;
                    lstProds.add(pc);                    
                }
                
                if(partsInvolved.size() > 1) {
                    prodLine pc = new prodLine();
                    pc.prodCode = 'CHLF';
                    //pc.examRegId = erd.examRegPartI != NULL ? erd.examRegPartI.Id : erd.examRegPartII.Id;
                    //pc.examSiteId = erd.selectedSitePartI != NULL ? erd.selectedSitePartI.Id : erd.selectedSitePartII.Id;
                    pc.glCode = '2008';
                    pc.description = 'OSTA Location Fee';
                    pc.amount = ostaLocationFee;
                    pc.examRegId = eaFee.Id;
                    lstProds.add(pc);                    
                }
                erd.statusCode = 200;
            }
            
            // If have any OSTA Admins
            if(totalSelectedPartWithOSTA > 0) {
                // If no OSTA program exists charge to put them into it
                if(ostaPrograms == NULL || ostaPrograms.size() == 0) {
                    prodLine pc = new prodLine();
                    pc.prodCode = 'CHNDF';
                    //pc.examRegId = erd.examRegPartI != NULL ? erd.examRegPartI.Id : erd.examRegPartII.Id;
                    //pc.examSiteId = erd.selectedSitePartI != NULL ? erd.selectedSitePartI.Id : erd.selectedSitePartII.Id;
                    pc.glCode = '2009';
                    pc.description = 'OSTA Data Fee';
                    pc.amount = ostaDataFee;
                    lstProds.add(pc);
                }
            }
            
            System.Debug('OSTA Fee In: ' + lstProds);

            // If any Refunds add them
            // Find Exam Reg to relate to Fee
            partsInvolved = new Set<Decimal>();
            eaFee=NULL;
            for(String curkey :om.mapCurrentPartOSTA.keySet()) {
                
                Exam_Part__c curVal = om.mapCurrentPartOSTA.get(curkey);
                Exam_Part__c selVal = om.mapSelectedPartOSTA.get(curkey);
                
                System.debug('curVal:' + curVal);
                System.debug('selVal:' + selVal);
                
                if(selVal == NULL && curVal != NULL) {
                    if(curVal.Exam_Part_Number__c != NULL) {
                        partsInvolved.add(curVal.Exam_Part_Number__c);    
                    }
                }
            }
            System.debug('partsInvolved:' + partsInvolved);
            //erd.errMsg += 'Parts Involved refund:' + partsInvolved;
            if(partsInvolved.contains(1)) {
                eaFee = erd.examRegPartI;
            } else if(partsInvolved.contains(2)) {
                eaFee = erd.examRegPartII;
            }
            
            //if(totalRefund < 0) {        
            if(totalFee < 0) {
                if(partsInvolved.size() > 0) {
                    prodLine pc = new prodLine();
                    pc.prodCode = 'CHLF';
                    pc.glCode = '2008';
                    pc.description = 'OSTA Location fee Refund';
                    pc.amount = ostaLocationFee * -1;
                    pc.examRegId = eaFee.Id;
                    lstProds.add(pc);
                }
                if(partsInvolved.size() > 1) {
                    prodLine pc = new prodLine();
                    pc.prodCode = 'CHLF';
                    pc.glCode = '2008';
                    pc.description = 'OSTA Location fee Refund';
                    pc.amount = ostaLocationFee * -1;
                    pc.examRegId = eaFee.Id;
                    lstProds.add(pc);
                }
                erd.statusCode = 200;
            }
            
            // If no Part with OSTA left        
            if(totalSelectedPartWithOSTA == 0) {
                
                // If have OSTA Program but never uploaded data then refund
                if(ostaPrograms != NULL && ostaPrograms.size() > 0 && ostaPrograms[0].OSTA_Last_Upload_Date__c == NULL) {
                    prodLine pc = new prodLine();
                    pc.prodCode = 'CHNDF';
                    pc.glCode = '2008';
                    pc.description = 'OSTA Data fee Refund';
                    pc.amount = ostaDataFee * -1;
                    lstProds.add(pc);
                    erd.statusCode = 200;
                }
                
            }
            System.Debug('OSTA Fee Out: ' + lstProds);
        }
        
        erd.fees = lstProds;
        
        return erd;
    }
        
    static public examRescheduleData getExamRescheduleData(Id examGroupId, String program, Id selectedAdminPartI, Id selectedAdminPartII, Id selectedSitePartI, Id selectedSitePartII, Id userId) {
        
        examRescheduleData erd = new examRescheduleData();
        
        system.debug('GET examGroupId:' + examGroupId);
        system.debug('GET selectedAdminPartI:' + selectedAdminPartI);
        system.debug('GET selectedAdminPartII' + selectedAdminPartII);
        system.debug('GET selectedSitePartI' + selectedSitePartI);
        system.debug('GET selectedSitePartII' + selectedSitePartII);
        
        erd.allowSchedulingPartI = FALSE;	
        erd.allowAdminModPartI = FALSE;	
        erd.allowSchedulingPartII = FALSE;	
        erd.allowAdminModPartII = FALSE;
        
        erd.ExamRegMod = new Exam_Registration_Modification__c();
        
        Set<String> examPartNames;
        Set<String> otherExamPartNames;
        Set<String> examAdminTypeNames;
        
        if(program == 'frm') {
            examPartNames = new Set<String>{'FRM Part 1', 'FRM Part 2'};
            otherExamPartNames = new Set<String>{'ERP Exam Part I', 'ERP Exam Part II'};
            examAdminTypeNames = new Set<String>{'FRM','FRM/ERP'};
        } else if(program == 'erp') {
            examPartNames = new Set<String>{'ERP Exam Part I', 'ERP Exam Part II'};
            otherExamPartNames = new Set<String>{'FRM Part 1', 'FRM Part 2'};
            examAdminTypeNames = new Set<String>{'ERP','FRM/ERP'};
        } else {
            examPartNames = new Set<String>{'SCR'};
            examAdminTypeNames = new Set<String>{'SCR','SCR'};
        }
            
        system.debug('examPartNames:' + examPartNames);
        system.debug('examAdminTypeNames:' + examAdminTypeNames);

        //String userId = UserInfo.getUserId();        
        List<User> lstUser = [Select u.Id,u.ContactId, FullPhotoUrl from User u where u.Id = :userId];
        if( lstUser != null && lstUser.size() > 0 ) {   
            List<Contact> lstCont ;
            if(test.isRunningTest()) {
              
                lstCont = [Select Id, Name, AccountId,
                                         Email, FirstName, LastName, HomePhone,
                                         Company__c, Account.BillingStreet,
                                         Account.BillingCity,
                                         Account.BillingState,
                                         Account.BillingPostalCode,
                                         Account.BillingCountry
                                         from Contact ];  
                } else {
                lstCont = [Select Id, Name, AccountId,
                                         Email, FirstName, LastName, HomePhone,
                                         Company__c, Account.BillingStreet,
                                         Account.BillingCity,
                                         Account.BillingState,
                                         Account.BillingPostalCode,
                                         Account.BillingCountry
                                         from Contact where Id = :lstUser[0].ContactId];
                }
            if(lstCont != NULL && lstCont.size() > 0) {
                erd.contact = lstCont[0];
            }
            
            String recordTypeName = program.toUpperCase() + ' Program';
            LIST<Contract> programs = [
                SELECT Id, Name, Status, RecordType.Name, AccountId,
                Last_Exam_Deferral_Date__c
                FROM Contract
                WHERE 
                AccountId = :erd.contact.AccountId AND
                RecordType.Name = :recordTypeName AND
                (Status LIKE 'Activated%' OR Status = 'Lapsed' OR Status = 'Completed')
            ];
            System.debug('programs:' + programs);            
            if(programs != NULL && programs.size() > 0) {
                erd.program = programs[0];
            }
        }
        
        List<ID> lstExamGroupIDs = new List<ID>();
        lstExamGroupIDs.add(examGroupId);
        //erd.examGroupID = examGroupId;
        
        List<Exam_Group__c> lstExamGroup = [select Id, Name, Next_Exam_Group__c,Exam_Date__c,Last_Date_To_Apply_For_Deferral__c,
                                            Registration_Start_Date__c, Last_Date_To_Request_Exam_Change__c, Exam_Change_Start_Date_Time__c,
                                            Next_Exam_Group__r.Exam_Date__c, Next_Exam_Group__r.Registration_Start_Date__c, Next_Exam_Group__r.Last_Date_To_Request_Exam_Change__c 
                                            from Exam_Group__c where ID = :examGroupId];        
        if(lstExamGroup != NULL && lstExamGroup.size() > 0) {
            erd.examGroup = lstExamGroup[0];
            if(lstExamGroup[0].Next_Exam_Group__c != NULL) {
                lstExamGroupIDs.add(lstExamGroup[0].Next_Exam_Group__c);                
                erd.nextExamGroup = lstExamGroup[0].Next_Exam_Group__r;
            }
            
            // AG modify for Deadlines	
            //Date tdy = Date.today();	
            //DateTime now = DateTime.now();	
            //if(now >= erd.examGroup.Exam_Change_Start_Date_Time__c && tdy <= erd.examGroup.Last_Date_To_Request_Exam_Change__c) {	
            //    erd.allowSetup = TRUE;	
            //}	
            //if(now >= erd.examGroup.Exam_Change_Start_Date_Time__c && tdy <= erd.examGroup.Last_Date_To_Apply_For_Deferral__c) {	
            //     erd.allowDeferral = TRUE;	
            //}             
        }
        
        system.debug('GET lstExamGroup:' + lstExamGroup);
        system.debug('GET lstExamGroupIDs:' + lstExamGroupIDs);
        
        
        erd.examAdmins = [select Id, Name, Exam_Group__c, Exam_Type__c, Month__c, Year__c 
                          from Exam_Administration__c 
                          where Exam_Group__c in :lstExamGroupIDs AND
                                 Exam_Type__c in :examAdminTypeNames];

        
        system.debug('GET erd.examAdmins:' + erd.examAdmins);
        
        MAP<String, Exam_Administration__c> mapAdmin = new MAP<String, Exam_Administration__c>();
        //if(selectedAdminPartI != NULL || selectedAdminPartII != NULL) {
            for(Exam_Administration__c ea :erd.examAdmins) {

                mapAdmin.put(ea.Id, ea);

                if(ea.Id == selectedAdminPartI) {
                    erd.selectedAdminPartI = ea;
                }
                if(ea.Id == selectedAdminPartII) {
                    erd.selectedAdminPartII = ea;
                }
            }
        //}
        
        erd.examParts = [select Id, Name, Exam__c, Exam_Administration__c, Delivery_Method__c, Exam_Part_Number__c,
                                Exam_Date__c, Exam_Start_Date__c, Exam_End_Date__c
                         from 
                         Exam_Part__c where 
                         Exam_Administration__c in :erd.examAdmins AND Exam__r.Exam__c in :examPartNames];
        
        List<Exam_Attempt__c> lstExamReg = [
            SELECT 
            Id, Exam_Site__c, Defered__c, Member_Email__c,
            Deferral_Status__c, 
            Deferred_Exam_Administration__c,
            RPT_Exam_Part__c,            
            Active_Integration_Data__c,
            Integration_Data_Exam_Scheduled_Date__c,
            Free_Deferral__c,
            Allow_Future_Deferral__c,
            ATA_Name_as_it_appears_on_ID__c,
            Exam_Part__c,
            Exam_Part__r.Exam_Administration__c,
            Exam_Part__r.Exam__r.Exam__c,
            Exam_Part__r.Exam_Part_Number__c,
            Exam_Part__r.Delivery_Method__c,
            Exam_Site__r.Name,
            Exam_Site__r.Country__c,
            Exam_Site__r.Exam_Part__c,
            Exam_Site__r.Exam_Part__r.Exam_Administration__c,	
            Exam_Administration__r.Exam_Scheduling_Start_Date__c,	
            Exam_Administration__r.Exam_Scheduling_End_Date__c,	
            Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c,	
            Exam_Administration__r.Exam_Admin_Modifications_End_Date__c, 
            Exam_Site__r.Exam_Part__r.Exam__r.Exam__c,
            Exam_Site__r.Exam_Part__r.Exam_Part_Number__c,
            Exam_Site__r.Exam_Part__r.Delivery_Method__c,
            Exam_Site__r.Exam_Provider__r.Name,
            Exam_Site__r.Exam__c, 
            Exam_Site__r.Exam__r.Exam__c, 
            Exam_Site__r.Exam__r.Exam_Group__c,
            Exam_Site__r.Site__c, 
            Exam_Site__r.Site__r.Name, 
            Exam_Site__r.Site__r.Is_OSTA_Information_Required__c, 
            Exam_Site__r.Site__r.Is_Gender_Required__c, 
            Exam_Site__r.Site__r.AM_Exam_Capacity_Available__c, 
            Exam_Site__r.Site__r.PM_Exam_Capacity_Available__c 
            FROM 
            Exam_Attempt__c 
            WHERE 
            Cancelled__c != TRUE AND
            Opportunity__r.StageName = 'Closed' AND
            (Exam_Site__r.Exam__r.Exam__c in :examPartNames OR Exam_Site__r.Exam__r.Exam__c in :otherExamPartNames) AND
            Member__c = :erd.contact.Id AND 
            Exam_Site__r.Exam__r.Exam_Group__c = :examGroupId
        ]; 
            
        system.debug('GET lstExamReg:' + lstExamReg);
        
        system.debug('GET erd.examAdmins:' + erd.examAdmins);
            // See if recently deferred each part
            erd.canDeferPartI = False;
            erd.canDeferPartII = False;
        
            for(Exam_Attempt__c ea :lstExamReg) {
                
                system.debug('GET ea:' + ea);
                
                if(ea.RPT_Exam_Part__c == 'I' || ea.RPT_Exam_Part__c == 'Full') {
                    
                    system.debug('GET ea1:' + ea.Exam_Site__r.Exam__r.Exam__c);
                    system.debug('GET ea2:' + examPartNames);
                    
                    if(examPartNames.contains(ea.Exam_Site__r.Exam__r.Exam__c)) {

                        system.debug('GET ea3:' + ea.Deferred_Exam_Administration__c);
                        
                        if(ea.Deferred_Exam_Administration__c == NULL) { 
                            
                            system.debug('GET ea4:' + program);
                            system.debug('GET ea5:' + ea.Exam_Site__r.Site__r.Name);
                            
                            
                            //if(program != 'scr' && ea.Exam_Site__r.Site__r.Name != 'SCR') {
                                erd.currentSitePartI = ea.Exam_Site__r;
                            //}
                            erd.currentAdminPartI = mapAdmin.get(ea.Exam_Site__r.Exam_Part__r.Exam_Administration__c);
                            system.debug('erd.currentAdminPartI======>'+erd.currentAdminPartI);
                            system.debug('ea.Exam_Site__r.Exam_Part__r.Exam_Administration__c=======>'+ea.Exam_Site__r.Exam_Part__r.Exam_Administration__c);
                        } else {
                            erd.currentSitePartI = NULL;
                            erd.currentAdminPartI = mapAdmin.get(ea.Deferred_Exam_Administration__c);
                        }
                        erd.examRegPartI = ea;
                    } else {
                        erd.otherProgramExamRegPartI = ea;
                    }
                                        
                } else if(ea.RPT_Exam_Part__c == 'II') {
                    
                     if(examPartNames.contains(ea.Exam_Site__r.Exam__r.Exam__c)) {
                        if(ea.Deferred_Exam_Administration__c == NULL) {                        
                            erd.currentSitePartII = ea.Exam_Site__r;
                            erd.currentAdminPartII = mapAdmin.get(ea.Exam_Site__r.Exam_Part__r.Exam_Administration__c);
                        } else {
                            erd.currentSitePartII = NULL;
                            erd.currentAdminPartII = mapAdmin.get(ea.Deferred_Exam_Administration__c);
                        }                    
                        erd.examRegPartII = ea;
                     } else {
                         erd.otherProgramExamRegPartII = ea;
                     }
                }
            }


        System.debug('erd.examRegPartI:' + erd.examRegPartI);
        System.debug('erd.examRegPartII:' + erd.examRegPartII);
        
        System.debug('erd.currentSitePartI:' + erd.currentSitePartI);
        System.debug('erd.currentSitePartII:' + erd.currentSitePartII);
        System.debug('erd.currentAdminPartI:' + erd.currentAdminPartI);
        System.debug('erd.currentAdminPartII:' + erd.currentAdminPartII);
            
            erd.examSites = [               
                SELECT 
                Id, 
                Name,
                Exam_Part__c,
                Exam_Part__r.Exam_Administration__c, 
                Exam_Part__r.Exam__r.Exam__c,
                Exam_Part__r.Exam_Part_Number__c,
                Exam_Part__r.Delivery_Method__c,
                Exam_Provider__c,
                Exam_Provider__r.Name,
                Exam__c, 
                Exam__r.Exam__c, 
                Exam__r.Exam_Group__c, 
                Site__c, 
                Site__r.Name, 
                Site__r.Is_OSTA_Information_Required__c, 
                Site__r.Is_Gender_Required__c, 
                Site__r.AM_Exam_Capacity_Available__c, 
                Site__r.PM_Exam_Capacity_Available__c 
                FROM Exam_Sites__c
                WHERE 
                Exam_Part__r.Exam__r.Exam__c IN :examPartNames AND
                Site__r.Active__c = TRUE AND 
                Site__r.Non_Selectable__c = FALSE AND 
                Exam__r.Exam_Group__c in :lstExamGroupIDs AND
                Site__r.Name != 'SCR'
                ORDER BY Site__r.Name ASC 
            ];
                    
        system.debug('GET erd.examSites:' + erd.examSites);
        
        if(selectedSitePartI != NULL || selectedSitePartII != NULL) {
            
            for(Exam_Sites__c es :erd.examSites) {
            
                //System.Debug('es.Id: ' + es.Id);
            
                if(es.Id == selectedSitePartI) {
                    erd.selectedSitePartI = es;
                }
                if(es.Id == selectedSitePartII) {
                    erd.selectedSitePartII = es;
                }
            }
        }
                
        erd.ExamRegMod.User__c = lstUser[0].Id;
        
        Date tdy = Date.today();	
        DateTime now = DateTime.now();	

        if(erd.examRegPartI != NULL) {	
            erd.ExamRegMod.Part_I_Exam_Registration__c = erd.examRegPartI.Id;	
            if(tdy >= erd.examRegPartI.Exam_Administration__r.Exam_Scheduling_Start_Date__c &&	
               tdy <= erd.examRegPartI.Exam_Administration__r.Exam_Scheduling_End_Date__c)	
            	erd.allowSchedulingPartI = TRUE;	
            	
            if(tdy >= erd.examRegPartI.Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c &&	
               tdy <= erd.examRegPartI.Exam_Administration__r.Exam_Admin_Modifications_End_Date__c)            	
            	erd.allowAdminModPartI = TRUE;	
        }
        
        if(erd.examRegPartII != NULL) {	
            erd.ExamRegMod.Part_II_Exam_Registration__c = erd.examRegPartII.Id;	
            if(tdy >= erd.examRegPartII.Exam_Administration__r.Exam_Scheduling_Start_Date__c &&	
               tdy <= erd.examRegPartII.Exam_Administration__r.Exam_Scheduling_End_Date__c)	
            	erd.allowSchedulingPartII = TRUE;	
            if(tdy >= erd.examRegPartII.Exam_Administration__r.Exam_Admin_Modifications_Start_Date__c &&	
               tdy <= erd.examRegPartII.Exam_Administration__r.Exam_Admin_Modifications_End_Date__c)            	
				erd.allowAdminModPartII = TRUE;	
        }
        
        if(erd.currentAdminPartI != NULL)
            erd.ExamRegMod.Part_I_Exam_Admin_From__c = erd.currentAdminPartI.Id;
        
        if(erd.selectedAdminPartI != NULL)
            erd.ExamRegMod.Part_I_Exam_Admin_To__c = erd.selectedAdminPartI.Id;
        
        if(erd.currentAdminPartII != NULL)
            erd.ExamRegMod.Part_II_Exam_Admin_From__c = erd.currentAdminPartII.Id;
        
        if(erd.selectedAdminPartII != NULL)
            erd.ExamRegMod.Part_II_Exam_Admin_To__c = erd.selectedAdminPartII.Id;

        if(erd.currentSitePartI != NULL) {
            erd.ExamRegMod.Part_I_Exam_Site_From__c = erd.currentSitePartI.Id;
            erd.ExamRegMod.Part_I_Exam_Group_From__c = erd.currentSitePartI.Exam__r.Exam_Group__c;
            erd.ExamRegMod.Part_I_Exam_Part_From__c = erd.currentSitePartI.Exam_Part__c;
        }
            
        
        if(erd.selectedSitePartI != NULL) {
            erd.ExamRegMod.Part_I_Exam_Site_To__c = erd.selectedSitePartI.Id;
            erd.ExamRegMod.Part_I_Exam_Group_To__c = erd.selectedSitePartI.Exam__r.Exam_Group__c;
            erd.ExamRegMod.Part_I_Exam_Part_To__c = erd.selectedSitePartI.Exam_Part__c;
        }
            
        
        if(erd.currentSitePartII != NULL) {
            erd.ExamRegMod.Part_II_Exam_Site_From__c = erd.currentSitePartII.Id;
            erd.ExamRegMod.Part_II_Exam_Group_From__c = erd.currentSitePartII.Exam__r.Exam_Group__c;
            erd.ExamRegMod.Part_II_Exam_Part_From__c = erd.currentSitePartII.Exam_Part__c;
        }
            
        
        if(erd.selectedSitePartII != NULL) {
            erd.ExamRegMod.Part_II_Exam_Site_To__c = erd.selectedSitePartII.Id;
            erd.ExamRegMod.Part_II_Exam_Group_To__c = erd.selectedSitePartII.Exam__r.Exam_Group__c;
            erd.ExamRegMod.Part_II_Exam_Part_To__c = erd.selectedSitePartII.Exam_Part__c;
        }
            
        
        erd.ExamRegMod.Status__c = 'Pending';
        
        System.debug('erd.selectedSitePartI:' + erd.selectedSitePartI);
        System.debug('erd.selectedSitePartII:' + erd.selectedSitePartII);
        System.debug('erd.selectedAdminPartI:' + erd.selectedAdminPartI);
        System.debug('erd.selectedAdminPartII:' + erd.selectedAdminPartII);
        
        
        return erd;
    }
    
    public static ChargentSFA__Transaction__c createTransaction(String oppId) {
        
        ChargentSFA__Transaction__c trans = new ChargentSFA__Transaction__c();
        if(String.isNotBlank(OppId)){
            trans.ChargentSFA__Opportunity__c = oppId;
            trans.ChargentSFA__Amount__c = 0.00;
            trans.ChargentSFA__Response_Message__c = 'Approved';
            trans.ChargentSFA__Response_Status__c = 'Approved';
            trans.ChargentSFA__Type__c = 'Charge';
            trans.ChargentSFA__Gateway_Date__c =system.now();
            
            insert trans;
        }
        return trans;
    } 
    
    public static void processExamRegMods(Set<Id> setExamRegMods, boolean doNotCountOneTimeDefrl, boolean freeDeferral){
        dmlListWrapper dmlList = processExamRegModsBulk(setExamRegMods,doNotCountOneTimeDefrl,freeDeferral);
        List<Contract> contractsToUpdate = new List<Contract>();
        List<Contract> insertedContractList = new List<Contract>();
        if(dmlList.contractsToInsert != null && !dmlList.contractsToInsert.isEmpty()){
            insert dmlList.contractsToInsert;
            insertedContractList = [Select Id,Status,AccountId,RecordTypeId from Contract where Id IN: dmlList.contractsToInsert];
        }
		
		for(Contract cont : insertedContractList){
            cont.Status = 'Activated ( Auto-Renew )';
            contractsToUpdate.add(cont);
        }
        if(dmlList.contractsToUpdate != null && !dmlList.contractsToUpdate.isEmpty()){
            contractsToUpdate.addAll(dmlList.contractsToUpdate);
        }
        
        if(!contractsToUpdate.isEmpty()){
            update contractsToUpdate;
			
			
        }
        
        if(dmlList.examRegToUpdate != null && !dmlList.examRegToUpdate.isEmpty()){
            update dmlList.examRegToUpdate;
			
        }
    }
    
    public static dmlListWrapper processExamRegModsBulk(Set<Id> setExamRegMods, boolean doNotCountOneTimeDefrl, boolean freeDeferral){
			
		Id OSTARecTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'OSTA_Program');
        Id frmRecordTypeID = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'FRM_Program');
        List<Exam_Attempt__c> eaUpdates = new List<Exam_Attempt__c>();
        List<Product_Refunds__c> productRefunds = new List<Product_Refunds__c>();
        Set<Id> setAccounts = new Set<Id>();
        Set<Id> examRegIds = new Set<Id>();
        Set<Id> oppIds = new Set<Id>();
        List<AppError__c> appErrors = new List<AppError__c>();
        List<Contract> contractsToUpdate = new List<Contract>();
        List<Contract> contractsToInsert = new List<Contract>();
        Map<Id,Contract> accIdToOSTAPrgMap = new Map<Id,Contract>();
        Map<Id,Contract> accIdToFRMPrgMap = new Map<Id,Contract>();
        List<Exam_Registration_Modification__c> examRegModList = [SELECT Id, Customer_Email__c,
                                                                  Part_I_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.Active__c,Part_I_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.SCR_Active__c,
                                                                  Part_II_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.Active__c,Part_II_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.SCR_Active__c,
                                                                  Part_I_Exam_Registration__c,Part_I_Exam_Registration__r.Member__c,Part_I_Exam_Registration__r.Member_Email__c,Part_I_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c,Part_I_Exam_Registration__r.Candidate_Commitment__r.AccountId,Part_I_Exam_Registration__r.Defered__c,Part_I_Exam_Registration__r.Deferral_Status__c,Part_I_Exam_Registration__r.Future_Free_Deferral__c,Part_I_Exam_Registration__r.Cloned_From__c,Part_I_Exam_Registration__r.Opportunity__c,Part_I_Exam_Registration__r.Opportunity__r.AccountId,Part_I_Exam_Registration__r.RPT_Exam_Program__c,Part_I_Exam_Registration__r.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,Part_I_Exam_Registration__r.Exam_Site__r.Exam_Part__c,Part_I_Exam_Registration__r.Exam_Site__r.Exam_Part__r.Exam_Part_Number__c,
                                                                  Part_I_Exam_Admin_From__c,Part_I_Exam_Admin_From__r.Exam_Group__c,Part_I_Exam_Admin_From__r.Exam_Group__r.Active__c,Part_I_Exam_Admin_From__r.Exam_Group__r.SCR_Active__c,Part_I_Exam_Admin_From__r.Exam_Type__c, 
                                                                  Part_I_Exam_Admin_To__c,Part_I_Exam_Admin_To__r.Exam_Group__c,Part_I_Exam_Admin_To__r.Exam_Group__r.Active__c,Part_I_Exam_Admin_To__r.Exam_Group__r.SCR_Active__c,Part_I_Exam_Admin_To__r.Exam_Type__c,
                                                                  Part_I_Exam_Site_From__c,Part_I_Exam_Site_From__r.Exam_Part__c,Part_I_Exam_Site_From__r.Exam_Part__r.Exam__r.Exam__c,Part_I_Exam_Site_From__r.Exam_Part__r.Exam_Administration__c,Part_I_Exam_Site_From__r.Exam_Part__r.Exam_Part_Number__c,Part_I_Exam_Site_From__r.Site__c,Part_I_Exam_Site_From__r.Site__r.Name,Part_I_Exam_Site_From__r.Site__r.Is_OSTA_Information_Required__c,
                                                                  Part_I_Exam_Site_To__c,Part_I_Exam_Site_To__r.Exam_Part__c,Part_I_Exam_Site_To__r.Exam_Part__r.Exam_Administration__c,Part_I_Exam_Site_To__r.Exam_Part__r.Exam__r.Exam__c,Part_I_Exam_Site_To__r.Exam_Part__r.Exam_Part_Number__c,Part_I_Exam_Site_To__r.Site__c,Part_I_Exam_Site_To__r.Site__r.Name,Part_I_Exam_Site_To__r.Site__r.Is_OSTA_Information_Required__c,
                                                                  Part_II_Exam_Registration__c,Part_II_Exam_Registration__r.Member__c,Part_II_Exam_Registration__r.Member_Email__c,Part_II_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c,Part_II_Exam_Registration__r.Candidate_Commitment__r.AccountId,Part_II_Exam_Registration__r.Defered__c,Part_II_Exam_Registration__r.Deferral_Status__c,Part_II_Exam_Registration__r.Future_Free_Deferral__c,Part_II_Exam_Registration__r.Cloned_From__c,Part_II_Exam_Registration__r.Opportunity__c,Part_II_Exam_Registration__r.Opportunity__r.AccountId,Part_II_Exam_Registration__r.RPT_Exam_Program__c,Part_II_Exam_Registration__r.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,Part_II_Exam_Registration__r.Exam_Site__r.Exam_Part__c,Part_II_Exam_Registration__r.Exam_Site__r.Exam_Part__r.Exam_Part_Number__c,
                                                                  Part_II_Exam_Admin_From__c,Part_II_Exam_Admin_From__r.Exam_Group__c,Part_II_Exam_Admin_From__r.Exam_Group__r.Active__c,Part_II_Exam_Admin_From__r.Exam_Group__r.SCR_Active__c,Part_II_Exam_Admin_From__r.Exam_Type__c,
                                                                  Part_II_Exam_Admin_To__c,Part_II_Exam_Admin_To__r.Exam_Group__c,Part_II_Exam_Admin_To__r.Exam_Group__r.Active__c,Part_II_Exam_Admin_To__r.Exam_Group__r.SCR_Active__c,Part_II_Exam_Admin_To__r.Exam_Type__c,
                                                                  Part_II_Exam_Site_From__c,Part_II_Exam_Site_From__r.Exam_Part__c,Part_II_Exam_Site_From__r.Exam_Part__r.Exam_Administration__c,Part_II_Exam_Site_From__r.Exam_Part__r.Exam__r.Exam__c,Part_II_Exam_Site_From__r.Exam_Part__r.Exam_Part_Number__c,Part_II_Exam_Site_From__r.Site__c,Part_II_Exam_Site_From__r.Site__r.Name,Part_II_Exam_Site_From__r.Site__r.Is_OSTA_Information_Required__c,
                                                                  Part_II_Exam_Site_To__c,Part_II_Exam_Site_To__r.Exam_Part__c,Part_II_Exam_Site_To__r.Exam_Part__r.Exam_Administration__c,Part_II_Exam_Site_To__r.Exam_Part__r.Exam__r.Exam__c,Part_II_Exam_Site_To__r.Exam_Part__r.Exam_Part_Number__c,Part_II_Exam_Site_To__r.Site__c,Part_II_Exam_Site_To__r.Site__r.Name,Part_II_Exam_Site_To__r.Site__r.Is_OSTA_Information_Required__c,
                                                                  Part_I_Exam_Registration__r.Result__c,Part_II_Exam_Registration__r.Result__c,
                                                                  Status__c,User__c,
                                                                  (select Id, AccountId from Opportunities__r)
                                                                  FROM Exam_Registration_Modification__c 
                                                                  WHERE Id = :setExamRegMods AND Status__c = 'Pending'];
		
		for(Exam_Registration_Modification__c erm : examRegModList){
            if(erm.Part_I_Exam_Registration__c != NULL){
                setAccounts.add(erm.Part_I_Exam_Registration__r.Candidate_Commitment__r.AccountId);
                examRegIds.add(erm.Part_I_Exam_Registration__c);
                if(erm.Part_I_Exam_Registration__r.Cloned_From__c != null)
                    examRegIds.add(erm.Part_I_Exam_Registration__r.Cloned_From__c);
            }
            if(erm.Part_II_Exam_Registration__c != NULL){
                setAccounts.add(erm.Part_II_Exam_Registration__r.Candidate_Commitment__r.AccountId);
                examRegIds.add(erm.Part_II_Exam_Registration__c);
                if(erm.Part_II_Exam_Registration__r.Cloned_From__c != null)
                    examRegIds.add(erm.Part_II_Exam_Registration__r.Cloned_From__c);
            }
        }
        
        Map<Id,Exam_Attempt__c> examRegMap = new Map<Id,Exam_Attempt__c>([Select Id,Cloned_From__c,Opportunity__c,
                                                                          (SELECT Id, Name, CreatedDate, ProductCode,Exam_Registration__c, OpportunityId
                                                                            FROM Opportunity_Line_Items__r WHERE (ProductCode = 'CHLF' OR ProductCode = 'CHNDF') AND Opportunity.StageName = 'Closed'
                                                                            ORDER BY CreatedDate DESC)  
                                                                          from Exam_Attempt__c where Id IN: examRegIds]);
		
		for(Exam_Attempt__c ea : examRegMap.values()){
            oppIds.add(ea.Opportunity__c);
            if(!ea.Opportunity_Line_Items__r.isEmpty()) {
                for(OpportunityLineItem oli :ea.Opportunity_Line_Items__r) {
                    oppIds.add(oli.OpportunityId);    
                }
            }
        }
		
        LIST<Contract> ostaPrograms = [
            SELECT Id, Name, Status, RecordType.Name, AccountId, OSTA_Last_Upload_Date__c,Opportunity__c
            FROM Contract
            WHERE 
            AccountId in :setAccounts AND
            ((RecordTypeId =: OSTARecTypeId AND Status LIKE 'Activated%') OR
              (RecordTypeId =: frmRecordTypeID AND (Status LIKE 'Activated%' OR Status = 'Draft')))
        ];
		
        for(Contract cont : ostaPrograms){
            if(cont.RecordTypeId == frmRecordTypeID){
                accIdToFRMPrgMap.put(cont.AccountId,cont);
            }else if(cont.RecordTypeId == OSTARecTypeId){
                accIdToOSTAPrgMap.put(cont.AccountId,cont);
                oppIds.add(cont.Opportunity__c);
            }
        }
        
        MAP<Id,Opportunity> mapOpp = new MAP<Id,Opportunity>([select Id, AccountId,Name,
                                    (SELECT Id, ProductCode, Product2Id, Product2.ProductCode, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice FROM OpportunityLineItems),
                                    (SELECT Id, ChargentSFA__Opportunity__c, ChargentSFA__Response_Status__c, ChargentSFA__Amount__c FROM ChargentSFA__Transactions__r 
                                     WHERE ChargentSFA__Response_Status__c = 'Approved' ORDER BY ChargentSFA__Amount__c ASC),
                                    (select Id, Name, Opportunity__c from Product_Refunds__r where Product_Code__c = 'CHLF' AND Status__c != 'Denied')
                                    from Opportunity where Exam_Registration_Modification__c in :setExamRegMods OR ID IN: oppIds]);
        
        for(Exam_Registration_Modification__c erm :examRegModList) {
            Boolean updateER1 = false;
            Boolean updateER2 = false;
            Opportunity opp = !erm.Opportunities__r.isEmpty()?erm.Opportunities__r[0]:null;
            String AccountId = (erm.Part_I_Exam_Registration__c != NULL) ? erm.Part_I_Exam_Registration__r.Candidate_Commitment__r.AccountId : erm.Part_II_Exam_Registration__r.Candidate_Commitment__r.AccountId;
        	Id contactId = (erm.Part_I_Exam_Registration__c != NULL) ? erm.Part_I_Exam_Registration__r.Member__c : erm.Part_II_Exam_Registration__r.Member__c;
            Exam_Attempt__c er1 = new Exam_Attempt__c(Id = erm.Part_I_Exam_Registration__c);
            Exam_Attempt__c er2 = new Exam_Attempt__c(Id = erm.Part_II_Exam_Registration__c);
            if((erm.Part_I_Exam_Registration__c != NULL && (erm.Part_I_Exam_Admin_From__c == NULL || erm.Part_I_Exam_Admin_To__c == NULL)) 
               || (erm.Part_II_Exam_Registration__c != NULL && (erm.Part_II_Exam_Admin_From__c == NULL || erm.Part_II_Exam_Admin_To__c == NULL))) {
                erm.Status__c = 'Error';
                continue;
            }
            if((erm.Part_I_Exam_Registration__c != null && (erm.Part_I_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.Active__c || erm.Part_I_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.SCR_Active__c))
               || (erm.Part_II_Exam_Registration__c != null && (erm.Part_II_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.Active__c || erm.Part_II_Exam_Registration__r.Exam_Administration__r.Exam_Group__r.SCR_Active__c))){
                   if(erm.Part_II_Exam_Registration__c != null && doNotCountOneTimeDefrl){
                       er1.Selected_To_Allow_Future_Deferral__c = true;
                       if(erm.Part_I_Exam_Registration__r.Result__c != null && erm.Part_I_Exam_Registration__r.Result__c == 'No-Show')
                       	  er1.Result__c = null;
                       updateER1 = True;
                   }
                   if(erm.Part_I_Exam_Registration__c != null && freeDeferral){
                       er1.Future_Free_Deferral__c = true;
                       if(erm.Part_I_Exam_Registration__r.Result__c != null && erm.Part_I_Exam_Registration__r.Result__c == 'No-Show')
                       	  er1.Result__c = null;
                       updateER1 = True;
                   }
                   if(erm.Part_II_Exam_Registration__c != null && doNotCountOneTimeDefrl){
                       er2.Selected_To_Allow_Future_Deferral__c = true;
                       if(erm.Part_II_Exam_Registration__r.Result__c != null && erm.Part_II_Exam_Registration__r.Result__c == 'No-Show')
                       	  er2.Result__c = null;
                       updateER2 = True;
                   }
                   if(erm.Part_II_Exam_Registration__c != null && freeDeferral){
                       er2.Future_Free_Deferral__c = true;
                       if(erm.Part_II_Exam_Registration__r.Result__c != null && erm.Part_II_Exam_Registration__r.Result__c == 'No-Show')
                       	  er2.Result__c = null;
                       updateER2 = True;
                   }
                   // Move Admin Between Groups - Deferral Out
                   if(erm.Part_I_Exam_Registration__c != NULL && erm.Part_I_Exam_Admin_From__c != erm.Part_I_Exam_Admin_To__c 
                      && erm.Part_I_Exam_Admin_From__r.Exam_Group__c != erm.Part_I_Exam_Admin_To__r.Exam_Group__c 
                      && erm.Part_I_Exam_Admin_To__r.Exam_Group__c != erm.Part_I_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c) {
                          er1.Defered__c = 'Pending';
                          er1.Deferral_Status__c = 'Deferred Out';
                          er1.Deferred_Exam_Administration__c = erm.Part_I_Exam_Admin_To__c;
                          updateER1=True;
                          
                      }
                   
                   if(erm.Part_II_Exam_Registration__c != NULL && erm.Part_II_Exam_Admin_From__c != erm.Part_II_Exam_Admin_To__c 
                      && erm.Part_II_Exam_Admin_From__r.Exam_Group__c != erm.Part_II_Exam_Admin_To__r.Exam_Group__c 
                      && erm.Part_II_Exam_Admin_To__r.Exam_Group__c != erm.Part_II_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c) {
                          er2.Defered__c = 'Pending';
                          er2.Deferral_Status__c = 'Deferred Out';
                          er2.Deferred_Exam_Administration__c = erm.Part_II_Exam_Admin_To__c;
                          updateER2=True;
                      }
                   
                   // Move Admin Between Groups - UnDeferral
                   if(erm.Part_I_Exam_Registration__c != NULL && erm.Part_I_Exam_Admin_From__c != erm.Part_I_Exam_Admin_To__c 
                      && erm.Part_I_Exam_Admin_From__r.Exam_Group__c != erm.Part_I_Exam_Admin_To__r.Exam_Group__c 
                      && erm.Part_I_Exam_Admin_To__r.Exam_Group__c == erm.Part_I_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c) {
                          er1.Defered__c = NULL;
                          er1.Deferral_Status__c = NULL;
                          er1.Deferred_Exam_Administration__c = NULL;
                          er1.Exam_Site__c = erm.Part_I_Exam_Site_To__c;
                          er1.Exam_Administration__c = erm.Part_I_Exam_Admin_To__c;
                          er1.Exam_Part__c = erm.Part_I_Exam_Site_To__r.Exam_Part__c;
                          updateER1=True;
                      }
                   
                   if(erm.Part_II_Exam_Registration__c != NULL && erm.Part_II_Exam_Admin_From__c != erm.Part_II_Exam_Admin_To__c 
                      && erm.Part_II_Exam_Admin_From__r.Exam_Group__c != erm.Part_II_Exam_Admin_To__r.Exam_Group__c 
                      && erm.Part_II_Exam_Admin_To__r.Exam_Group__c == erm.Part_II_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c) {
                          er2.Defered__c = NULL;
                          er2.Deferral_Status__c = NULL;
                          er2.Deferred_Exam_Administration__c = NULL;
                          er2.Exam_Site__c = erm.Part_II_Exam_Site_To__c;
                          er2.Exam_Administration__c = erm.Part_II_Exam_Admin_To__c;
                          er2.Exam_Part__c = erm.Part_II_Exam_Site_To__r.Exam_Part__c;
                          updateER2=True;
                      }
                   
                   // Move Admin Between Within same Groups in current group
                    if(erm.Part_I_Exam_Registration__c != NULL && erm.Part_I_Exam_Admin_From__c != erm.Part_I_Exam_Admin_To__c && 
                       erm.Part_I_Exam_Admin_From__r.Exam_Group__c == erm.Part_I_Exam_Admin_To__r.Exam_Group__c ) {
                        
                        // If in current Exam Group
                        if(erm.Part_I_Exam_Admin_To__r.Exam_Group__c == erm.Part_I_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c) {
                            er1.Exam_Administration__c = erm.Part_I_Exam_Admin_To__c;
                            er1.Exam_Part__c = erm.Part_I_Exam_Site_To__r.Exam_Part__c;
                            er1.Exam_Site__c = erm.Part_I_Exam_Site_To__c;
                        } else {
                            er1.Deferred_Exam_Administration__c = erm.Part_I_Exam_Admin_To__c;                        
                        }
                        
                        updateER1=True;
                        
                        System.debug('move admin er1:' + er1);
                    }
                    
                    if(erm.Part_II_Exam_Registration__c != NULL && erm.Part_II_Exam_Admin_From__c != erm.Part_II_Exam_Admin_To__c && 
                       erm.Part_II_Exam_Admin_From__r.Exam_Group__c == erm.Part_II_Exam_Admin_To__r.Exam_Group__c ) {
                        
                        // If in current Exam Group
                        if(erm.Part_II_Exam_Admin_To__r.Exam_Group__c == erm.Part_II_Exam_Registration__r.Exam_Site__r.Exam__r.Exam_Group__c) {
                            er2.Exam_Administration__c = erm.Part_II_Exam_Admin_To__c;
                            er2.Exam_Part__c = erm.Part_II_Exam_Site_To__r.Exam_Part__c;
                            er2.Exam_Site__c = erm.Part_II_Exam_Site_To__c;
                        } else {
                            er2.Deferred_Exam_Administration__c = erm.Part_II_Exam_Admin_To__c;                        
                        }
                        
                        updateER2=True;
                        
                        System.debug('move admin er2:' + er2);
                    }
                   
                   // Site Change
                   if(erm.Part_I_Exam_Registration__c != NULL && 
                      ((erm.Part_I_Exam_Site_From__c == NULL && erm.Part_I_Exam_Site_To__c != NULL) ||
                       (erm.Part_I_Exam_Site_From__c != NULL && erm.Part_I_Exam_Site_To__c != NULL && erm.Part_I_Exam_Site_From__c != erm.Part_I_Exam_Site_To__c))) {
                           er1.Exam_Site__c = erm.Part_I_Exam_Site_To__c;
                           er1.Exam_Administration__c = erm.Part_I_Exam_Admin_To__c;
                           er1.Exam_Part__c = erm.Part_I_Exam_Site_To__r.Exam_Part__c;
                           updateER1=True;
                       }
                   
                   if(erm.Part_II_Exam_Registration__c != NULL && erm.Part_II_Exam_Site_From__c != NULL && erm.Part_II_Exam_Site_To__c != NULL 
                      && erm.Part_II_Exam_Site_From__c != erm.Part_II_Exam_Site_To__c) {
                          er2.Exam_Site__c = erm.Part_II_Exam_Site_To__c;
                          er2.Exam_Administration__c = erm.Part_II_Exam_Admin_To__c;
                          er2.Exam_Part__c = erm.Part_II_Exam_Site_To__r.Exam_Part__c;
                          updateER2=True;
                      }
                   
                   erm.Status__c = 'Completed';
                   if(erm.Part_I_Exam_Registration__c != NULL) {
                       erm.Customer_Email__c = erm.Part_I_Exam_Registration__r.Member_Email__c;    
                   } else if(erm.Part_II_Exam_Registration__c != NULL) {
                       erm.Customer_Email__c = erm.Part_II_Exam_Registration__r.Member_Email__c;    
                   }   
                   if(updateER1)
                       eaUpdates.add(er1);
                   if(updateER2)
                       eaUpdates.add(er2);
               }
            if((erm.Part_I_Exam_Registration__c != NULL && erm.Part_I_Exam_Registration__r.RPT_Exam_Program__c == 'FRM') 
               || (erm.Part_II_Exam_Registration__c != NULL && erm.Part_II_Exam_Registration__r.RPT_Exam_Program__c == 'FRM')){
                   MAP<String,Exam_Part__c> mapCurrentAdminOSTA = new MAP<String,Exam_Part__c>();
                   MAP<String,Exam_Part__c> mapSelectedAdminOSTA = new MAP<String,Exam_Part__c>();
                   ostaMaps om = computeOSTAProgramMoves(erm.Part_I_Exam_Registration__r, erm.Part_II_Exam_Registration__r, erm.Part_I_Exam_Site_From__r, erm.Part_II_Exam_Site_From__r, erm.Part_I_Exam_Admin_From__r, erm.Part_II_Exam_Admin_From__r, erm.Part_I_Exam_Site_To__r, erm.Part_II_Exam_Site_To__r, erm.Part_I_Exam_Admin_To__r, erm.Part_II_Exam_Admin_To__r);
                   Integer totalCurrentPartWithOSTA = om.mapCurrentPartOSTA.size();
                   Integer totalSelectedPartWithOSTA = om.mapSelectedPartOSTA.size();
                   // If no OSTA program exists and have any OSTA Admins, create one 
                   if(!accIdToOSTAPrgMap.containskey(accountId) && totalSelectedPartWithOSTA > 0 && opp != NULL) {
                       Contract ostaContract = opportunityTriggerUtils_New.getNewOSTAContract(accountId,opp.Id,contactId,OSTARecTypeId,accIdToFRMPrgMap.get(accountId).Id);
                       contractsToInsert.add(ostaContract);
                   }
                   if(totalSelectedPartWithOSTA < totalCurrentPartWithOSTA) {
                       system.debug('Inside here');
                       // If have OSTA Program and not uploaded data and now no Admins with OSTA then cancel program and refund
                       if(accIdToOSTAPrgMap.containskey(accountId) && accIdToOSTAPrgMap.get(accountId).OSTA_Last_Upload_Date__c == NULL && totalSelectedPartWithOSTA == 0) {
                           system.debug('Inside here 2');
                           Contract ostaProgram = accIdToOSTAPrgMap.get(accountId);
                           ostaProgram.Status = 'Canceled';
                           contractsToUpdate.add(ostaProgram);
                           if(ostaProgram.Opportunity__c != NULL) {
                               system.debug('Inside here 3');
                               List<Product_Refunds__c> prs = issueProductRefund(mapOpp.get(ostaProgram.Opportunity__c), 'CHNDF',1);
                               productRefunds.addAll(prs);
                           }
                       }
                       
                       Set<Decimal> partsInvolved = new Set<Decimal>();
                       Set<String> oppsInvolved = new Set<String>();
                       Id eaRefund=NULL;
                       Id eaRefundOther=NULL;
                       for(String curkey :om.mapCurrentPartOSTA.keySet()) {
                           
                           Exam_Part__c curVal = om.mapCurrentPartOSTA.get(curkey);
                           Exam_Part__c selVal = om.mapSelectedPartOSTA.get(curkey);
                           
                           System.debug('curVal:' + curVal);
                           System.debug('selVal:' + selVal);
                           
                           if(selVal == NULL && curVal != NULL) {
                               partsInvolved.add(curVal.Exam_Part_Number__c);
                               if(curVal.Exam_Part_Number__c == 1) {
                                   oppsInvolved.add(er1.Opportunity__c);
                               } else {
                                   oppsInvolved.add(er2.Opportunity__c);
                               }
                           }
                       }
                       System.debug('partsInvolved:' + partsInvolved);
                       
                       Integer numberOfLocationRefunds = (totalCurrentPartWithOSTA - totalSelectedPartWithOSTA);
                       System.debug('numberOfLocationRefunds :' + numberOfLocationRefunds);
                       if(partsInvolved.contains(1)) {
                           eaRefund = erm.Part_I_Exam_Registration__c;
                           if(erm.Part_II_Exam_Registration__c != NULL) {
                               eaRefundOther = erm.Part_II_Exam_Registration__c;
                           }
                       } else if(partsInvolved.contains(2)) {
                           eaRefund = erm.Part_II_Exam_Registration__c;
                           if(erm.Part_I_Exam_Registration__c != NULL) {
                               eaRefundOther = erm.Part_I_Exam_Registration__c;
                           }
                       }
                       
                       
                       system.debug('check this map'+examRegMap);
                       system.debug('check this map'+mapOpp);
                       system.debug('check this reg'+eaRefund);
                       // Issue Refund for eaRefund
                       if(eaRefund != NULL) {
                           Opportunity oppRefund = findRefundOpp(examRegMap.get(eaRefund),mapOpp,examRegMap);    
                           System.debug('findRefundOpp:' + oppRefund);
                           
                           if(oppRefund == NULL && eaRefundOther != NULL) {                        
                               oppRefund = findRefundOpp(examRegMap.get(eaRefundOther),mapOpp,examRegMap);    
                               System.debug('findRefundOpp Other:' + oppRefund);                        
                           }
                           
                           if(oppRefund != NULL) {
                               List<Product_Refunds__c> prs = issueProductRefund(oppRefund, 'CHLF',numberOfLocationRefunds);
                               productRefunds.addAll(prs);
                           } else {
                               AppError__c appError = new AppError__c();
                               appError.Error__c = 'No OSTA fee found to refund';
                               appError.Contact__c = contactID;
                               appError.Message__c = 'No OSTA fee found to refund';
                               appErrors.add(appError);
                           }
                           
                       }
                       
                       if(oppsInvolved.size() == 2 && numberOfLocationRefunds == 2) {
                           if(eaRefundOther != NULL) {  
                               Opportunity oppRefund = findRefundOpp(examRegMap.get(eaRefundOther),mapOpp,examRegMap);    
                               System.debug('findRefundOpp Other:' + oppRefund);
                               
                               if(oppRefund != NULL) {
                                   List<Product_Refunds__c> prs = issueProductRefund(oppRefund.Id, 'CHLF',numberOfLocationRefunds);
                                   productRefunds.addAll(prs);
                               }
                           }
                       }
                   }
               }
                   
        }
        
        if(!productRefunds.isEmpty()){
            insert productRefunds;
	    }
        if(!appErrors.isEmpty()){
        	insert appErrors;
        }
        if(!examRegModList.isEmpty()){
        	update examRegModList;
        }
        
        dmlListWrapper dmls = new dmlListWrapper();
        if(!contractsToInsert.isEmpty())
            dmls.contractsToInsert = contractsToInsert;
        if(!contractsToUpdate.isEmpty())
            dmls.contractsToUpdate = contractsToUpdate;
        if(!eaUpdates.isEmpty())
            dmls.examRegToUpdate = eaUpdates;
        return dmls;
    }
    
    public static List<Product_Refunds__c> issueProductRefund(Opportunity opp, String prodCode, Integer part) {
        
        ChargentSFA__Transaction__c paymentTransaction = !opp.ChargentSFA__Transactions__r.isEmpty()?opp.ChargentSFA__Transactions__r[0]:null;
        List<Product_Refunds__c> prs = new List<Product_Refunds__c>();
        Integer cnt=1;
        for(OpportunityLineItem ol :opp.OpportunityLineItems) {
            if(ol.ProductCode == prodCode) {
                if(cnt <= part) {
                    Product_Refunds__c productRefund = new Product_Refunds__c();
                    productRefund.Payment_Transaction__c    = null;
                    productRefund.Status__c                 = 'Submitted';
                    productRefund.Product__c                = ol.Product2Id;
                    productRefund.Opportunity__c            = opp.Id;         
                    productRefund.Reason__c                 = ol.Description;
                    productRefund.Refund_Amount__c          = (ol.UnitPrice*ol.Quantity).setScale(2);
                    productRefund.Sales_Price__c            = (ol.UnitPrice*ol.Quantity).setScale(2);
                    productRefund.Opportunity_Product_ID__c = ol.Id;
                    if(paymentTransaction != null){
                        productRefund.Payment_Transaction__c = paymentTransaction.Id;
                    }     
                    prs.add(productRefund);                                    
                }
                cnt++;
            }
                
        }    
        return prs;
    }
    
    public static Opportunity findRefundOpp(Exam_Attempt__c ea,MAP<Id,Opportunity> mapOpp,Map<Id,Exam_Attempt__c> examRegMap) {
      
        Set<String> opIDs = new Set<String>();
        
        Exam_Attempt__c mainEA;
        mainEA=fetchExamRegistrationInContext(ea.Id);
        opIDs.add(mainEA.Opportunity__c);
        if(mainEA.Opportunity_Line_Items__r != NULL) {
            for(OpportunityLineItem oli :mainEA.Opportunity_Line_Items__r) {
                opIDs.add(oli.OpportunityId);    
            }
        }
        
        // Find Cloned EA
        Exam_Attempt__c clonedEA;
        if(ea.Cloned_From__c!=NULL) {
            clonedEA=examRegMap.get(ea.Cloned_From__c);
            if(clonedEA != NULL) {
                opIDs.add(clonedEA.Opportunity__c);
                if(clonedEA.Opportunity_Line_Items__r != NULL) {
                    for(OpportunityLineItem oli :clonedEA.Opportunity_Line_Items__r) {
                        opIDs.add(oli.OpportunityId);    
                    }                
                }
            }
        }
        
        for(Id oppId :opIDs) {
			Opportunity fndOpp = mapOpp.containsKey(oppId)?mapOpp.get(oppId):null;
            if(fndOpp != NULL) {
                for(OpportunityLineItem oli : fndOpp.OpportunityLineItems){
                    if(oli.ProductCode == 'CHLF' && fndOpp.Product_Refunds__r.isEmpty()){
                        return fndOpp;
                    }
                }
            }                
        }
        
        return NULL;
    }
    
    public class dmlListWrapper {
        public List<Contract> contractsToInsert;
        public List<Contract> contractsToUpdate;
        public List<Exam_Attempt__c> examRegToUpdate;
    } 
    
    public GARP_ExamManagement(sfdcAppRemoter ctrl){}
    
}