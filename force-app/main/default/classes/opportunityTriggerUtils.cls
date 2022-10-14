public class opportunityTriggerUtils {
    
    public static boolean bIsRecursive = false;
    public static boolean bIsRecursiveForOpps = false;
    public static boolean bIsRecursiveForRenewOpps = false;
    public static boolean bIsRecursiveForFFROpps = false;
    public static boolean bIsRecursiveForFFRAOpps = false;
    
    public static boolean bUpdateEA = false;
    public static boolean bActivateCons = false;
    public static boolean bAutoRenew = false;
    public static Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
    public static Id frmRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
    public static Id erpRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
    public static Id fbrRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
    public static Id icbrrRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
    public static Id fbraRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FBRA Program');
    public static Id WileyRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Wiley Bookstore');
    public static Id riskNetRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','Risk.Net');
    public static Id SCRRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','SCR Program');
    
    // public static String MobiusProductYear = '2020'; 
    public static String MobiusProductYear;  
    
    @TestVisible private static Contract createContract(Opportunity opp,Date startDate,Id memberRecordType,String strStatus,string strMemberShipType,integer iMonths){
        Contract objContract = new Contract();
        objContract.status = strStatus;
        objContract.accountId = opp.accountId;
        objContract.Opportunity__c = opp.Id;
        objContract.StartDate = startDate;
        objContract.ContractTerm  = iMonths;
        objContract.Membership_Type__c = strMemberShipType;
        objContract.recordTypeID = memberRecordType;
        return objContract; 
        
    }
    
    public static void closeRateOffers(Set<String> productCodes, Set<String> glCodes, Set<String> emailAddresses, Set<String> productKeys){
        LIST<Product_Rate_Offering__c> lstRates = [select id, Customer_Email__c, Status__c, 
                                                   Current_Product__r.ProductCode, Current_Product__r.GL_Code__c, 
                                                   Contact__c, Attestation_Required__c
                                                   from Product_Rate_Offering__c WHERE
                                                   Current_Product__r.ProductCode in :productCodes AND 
                                                   Current_Product__r.GL_Code__c in :glCodes AND 
                                                   Customer_Email__c in :emailAddresses AND Status__c = 'Active'];
        
        System.debug('lstRates:' + lstRates);
        
        List<Contact> lstContact = [select Id, Name, Email from Contact where Email in :emailAddresses];
        System.debug('lstContact:' + lstContact);
        
        MAP<String,String> mapEmailCont = new MAP<String,String>();
        for(Contact c :lstContact) {
            mapEmailCont.put(c.Email.tolowercase(),c.Id);
        }
        System.debug('mapEmailCont:' + mapEmailCont);
        
        if(lstRates != NULL && lstRates.size() > 0) {
            List<Product_Rate_Offering__c> updateProductRates = new List<Product_Rate_Offering__c>();
            for(Product_Rate_Offering__c pro :lstRates) {
                
                System.debug('pro:' + pro + pro.Current_Product__r.ProductCode + ':' + pro.Current_Product__r.GL_Code__c + ':' + pro.Customer_Email__c.tolowercase());
                
                if(productKeys.contains(pro.Current_Product__r.ProductCode + ':' + pro.Current_Product__r.GL_Code__c + ':' + pro.Customer_Email__c.tolowercase())) {
                    if(pro.Attestation_Required__c) {
                        pro.Status__c = 'Attested';
                    } else {
                        pro.Status__c = 'Used';
                    }
                    pro.Contact__c = mapEmailCont.get(pro.Customer_Email__c.tolowercase());
                    
                    System.debug('Update pro:' + pro);
                    updateProductRates.add(pro);
                }
            }
            update updateProductRates;
        }
    }
    
    public static void CreateDuplicateShipping(Id accountId, String garpId, String certType){
        
        Id DuplicateCertificates = RecordTypeHelper.GetRecordTypeId('certificate_shipping__c','Duplicate Certificate');
        Map<Id, Id> mapContact = new Map<Id, Id>();  
        
        for(Contact ct : [select id,AccountId,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,email,firstname,lastname,Phone from contact where accountId = : accountId]){
            mapContact.put(ct.accountId,ct.ID);
        }
        
        certificate_shipping__c c = new certificate_shipping__c();
        
        c.Member__c = mapContact.get(accountId);
        c.RecordTypeid = DuplicateCertificates;
        c.Garp_id__c = garpId;
        c.Certificate_Type__c = certType;
        c.Run_Now__c = true;
        
        INSERT c;
        
    } 
    
    public static void extendWiley(map<ID, Opportunity> wileyOpps, Map < Id, OpportunityLineItem > wileyOppItems){
        
        List<ID> draftContractIDs = new List<ID>();
        Map<ID,Opportunity> mapAcctIds = new Map<ID,Opportunity>();
        for(Opportunity opp :wileyOpps.values()) {
            mapAcctIds.put(opp.AccountId, Opp);
        }            
        system.debug('mapAcctIds:' + mapAcctIds);
        
        List<Contract> lstContractWiley = [
            SELECT Id, Status, RecordTypeId, EndDate, Opportunity__c, ContractTerm, AccountId 
            FROM contract 
            WHERE 
            recordTypeId =: wileyRecordTypeID AND 
            (Status = 'Activated' OR status = 'Activated ( Auto-Renew )' OR status = 'Draft') AND 
            accountId IN :mapAcctIds.keySet()
        ];
        
        MAP<ID,Contract> mapContIds = new MAP<ID,Contract>();
        for(Contract con :lstContractWiley) {
            mapContIds.put(con.AccountId, con);
        }            
        system.debug('mapContIds:' + mapContIds);
        
        List<Contract> newContracts = new List<Contract>();
        List<Contract> draftContracts = new List<Contract>();
        List<Contract> updateContracts = new List<Contract>();
        List<ID> lstDraftIDS = new List<ID>();
        
        for(Opportunity opp :wileyOpps.values()) {
            Contract con = mapContIds.get(opp.AccountId);
            OpportunityLineItem lineItem = wileyOppItems.get(opp.Id);
            
            if(lineItem != NULL) {
                Integer quantity = Integer.valueOf(lineItem.Quantity);
                if(con != null && con.status == 'Draft') {
                    con.ContractTerm = quantity;
                    con.Opportunity__c = opp.Id;
                    draftContracts.add(con);
                    lstDraftIDS.add(opp.Id);
                } else if(con != null && con.status != 'Draft') {
                    con.ContractTerm+=quantity;
                    con.Opportunity__c = opp.Id;
                    updateContracts.add(con);
                } else {
                    Contract objWContract = new Contract();
                    objWContract.Name = 'JWiley';
                    //objWContract.CustomerSigned = contID;
                    objWContract.accountId = opp.AccountId;
                    objWContract.Opportunity__c = opp.Id;
                    objWContract.StartDate = system.today();
                    objWContract.ContractTerm = quantity;
                    objWContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Wiley Bookstore');
                    newContracts.add(objWContract);
                    lstDraftIDS.add(opp.Id);
                }
            }
        }
        
        system.debug('draftContracts:' + newContracts);
        system.debug('newContracts:' + newContracts);
        system.debug('updateContracts:' + updateContracts);
        
        if(newContracts != null && newContracts.size() > 0) {
            insert newContracts;
        }
        
        List<Contract> lstActContractWiley = [
            SELECT id,status,recordTypeId,Enddate,Opportunity__c,ContractTerm 
            FROM contract 
            WHERE 
            recordTypeId = :wileyRecordTypeID AND 
            Status = 'Draft' AND 
            accountId IN :mapAcctIds.keySet() AND 
            Opportunity__c IN :lstDraftIDS
        ];
        system.debug('lstActContractWiley:' + lstActContractWiley);
        
        if(lstActContractWiley != null && lstActContractWiley.size() > 0) {
            for(Contract con :lstActContractWiley) {
                con.Status = 'Activated';
            }
            system.debug('lstActContractWiley:' + lstActContractWiley);
            update lstActContractWiley;
        }
        update updateContracts;
    }
    
    public static void extendRiskNet(Map<Id, Opportunity> riskNetOpps, Map<Id, OpportunityLineItem> riskNetOppItems){
        
        Map<Id, Opportunity> opportunityByAccountIdMap = new Map<Id, Opportunity>();
        for(Opportunity opp :riskNetOpps.values()) {
            opportunityByAccountIdMap.put(opp.AccountId, opp);
        }            
        
        Map<Id, Contact> contactByAccountId = new Map<Id, Contact>();
        for(Contact contact: [SELECT Id, AccountId, FirstName, LastName, Email, HomePhone FROM Contact WHERE AccountId IN :opportunityByAccountIdMap.keySet()]){
            contactByAccountId.put(contact.AccountId, contact);
        }
        
        List<Contract> riskNetContracts = [
            SELECT Id, Status, RecordTypeId, EndDate, Opportunity__c, ContractTerm, AccountId 
            FROM contract 
            WHERE 
            recordTypeId =: riskNetRecordTypeID AND 
            (Status = 'Activated' OR status = 'Activated ( Auto-Renew )' OR status = 'Draft') AND 
            accountId IN :opportunityByAccountIdMap.keySet()
        ];
        
        MAP<ID,Contract> contractsMap = new MAP<ID,Contract>();
        for(Contract con :riskNetContracts) {
            contractsMap.put(con.AccountId, con);
        }            
        
        List<Contract> newContracts = new List<Contract>();
        List<Contract> draftContracts = new List<Contract>();
        List<Contract> updateContracts = new List<Contract>();
        
        Set<Id> draftContractIds = new Set<Id>();
        
        for(Opportunity opp :riskNetOpps.values()) {
            Contract contract = contractsMap.get(opp.AccountId);
            OpportunityLineItem lineItem = riskNetOppItems.get(opp.Id);
            if(lineItem != null) {
                Integer quantity = Integer.valueOf(lineItem.Quantity);
                if (contract != null && contract.status == 'Draft') {
                    contract.ContractTerm = quantity;
                    contract.Opportunity__c = opp.Id;
                    draftContracts.add(contract);
                    draftContractIds.add(opp.Id);
                } else if (contract != null && contract.status != 'Draft') {
                    // Expiring the existing Contracts
                    contract.status = 'Expired';
                    contract.Opportunity__c = opp.Id;
                    updateContracts.add(contract);
                    
                    // Create new Contract after updating the existing 'Activated' or 'Activated-Autorenew'
                    contract = new Contract();
                    contract.Name = 'Risk.net';
                    if(contactByAccountId.containsKey(opp.AccountId)){
                        Contact contact = contactByAccountId.get(opp.AccountId);
                        contract.CustomerSignedId = contact.Id;
                        contract.Pearson_Member_First_Name__c = contact.FirstName;
                        contract.Pearson_Member_Last_Name__c = contact.LastName;
                        contract.Member_Email__c = contact.Email;
                        contract.Pearson_Phone_No__c = contact.HomePhone;
                    }
                    contract.accountId = opp.AccountId;
                    contract.Opportunity__c = opp.Id;
                    contract.StartDate = system.today();
                    contract.ContractTerm = quantity;
                    contract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Risk.Net');
                    newContracts.add(contract);
                    draftContractIds.add(opp.Id);
                    
                } else {
                    contract = new Contract();
                    contract.Name = 'Risk.net';
                    if(contactByAccountId.containsKey(opp.AccountId)){
                        Contact contact = contactByAccountId.get(opp.AccountId);
                        contract.CustomerSignedId = contact.Id;
                        contract.Pearson_Member_First_Name__c = contact.FirstName;
                        contract.Pearson_Member_Last_Name__c = contact.LastName;
                        contract.Member_Email__c = contact.Email;
                        contract.Pearson_Phone_No__c = contact.HomePhone;
                    }
                    contract.accountId = opp.AccountId;
                    contract.Opportunity__c = opp.Id;
                    contract.StartDate = system.today();
                    contract.ContractTerm = quantity;
                    contract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Risk.Net');
                    newContracts.add(contract);
                    draftContractIds.add(opp.Id);
                }
            }
        }
        
        system.debug('draftContracts:' + newContracts);
        system.debug('newContracts:' + newContracts);
        system.debug('updateContracts:' + updateContracts);
        
        if(newContracts != null && newContracts.size() > 0) {
            INSERT newContracts;
        }
        
        List<Contract> lstActContractRiskNet = [
            SELECT id,status,recordTypeId,Enddate,Opportunity__c,ContractTerm 
            FROM contract 
            WHERE 
            recordTypeId = :riskNetRecordTypeID AND 
            Status = 'Draft' AND 
            accountId IN :opportunityByAccountIdMap.keySet() AND 
            Opportunity__c IN :draftContractIds
        ];
        
        if(lstActContractRiskNet != null && lstActContractRiskNet.size() > 0) {
            for(Contract con :lstActContractRiskNet) {
                con.Status = 'Activated';
            }
            UPDATE lstActContractRiskNet;
        }
        UPDATE updateContracts;
    }
    
    public static void provisionMobiuseBook(map<ID, Opportunity> eBookOpps, String exam, String part) {
        
        system.debug('eBookOpps:' + eBookOpps);
        system.debug('eBookOpps.keySet():' + eBookOpps.keySet());
        
        List<Opportunity> lstOpp = [
            select Id, name,Shipping_First_Name__c,Shipping_Last_Name__c,GARP_Member_ID__c,Shipping_E_mail__c,ChargentSFA__Invoice_Number__c, (SELECT Id,ProductCode, Product_ID__c FROM OpportunityLineItems) 
            from Opportunity 
            where id in :eBookOpps.keySet()
        ];
        system.debug('lstOpp:' + lstOpp);
        
        MAP<String, String> mapProd = new MAP<String, String>();
        for(Opportunity opp :lstOpp) {           
            for(OpportunityLineItem ol :opp.OpportunityLineItems){
                mapProd.put(ol.ProductCode,ol.Product_ID__c);
            }                        
        }
        system.debug('mapProd:' + mapProd);
        
        Map<String,Mobius_Products__c> mProds = Mobius_Products__c.getall();
        Mobius_Products__c MobiusProductYearObj = mProds.get(exam + ' Current Year');
        system.debug('MobiusProductYear======>'+MobiusProductYear);
        system.debug('MobiusProductYearObj=======>'+MobiusProductYearObj);
        // If Find Current Year proceed
        // If not defined do not - this is when the eBook is not available
        if(MobiusProductYearObj != null) {
            MobiusProductYear = MobiusProductYearObj.Year__c;
            
            system.debug('MobiusProductYear:' + MobiusProductYear);
            
            List<Integer> iProdList = new List<Integer>();
            String productID;
            Integer accessDuration;
            for(Mobius_Products__c mp :mProds.values()) {
                if(mp.Year__c == MobiusProductYear && mp.Exam__c == exam && mp.Part__c == part && mp.Name.IndexOf('Current') == -1) {
                    iProdList.add(Integer.valueOf(mp.Product_Id__c));
                    productID = mapProd.get(mp.Salesforce_Product_Code__c);
                    if(mp.Access_Duration_in_Months__c != NULL) {
                        accessDuration = Integer.ValueOf(mp.Access_Duration_in_Months__c);
                    }
                }                        
            }
            system.debug('iProdList:' + iProdList);
            system.debug('productID:' + productID);
            system.debug('accessDuration :' + accessDuration );            
            
            if(iProdList.size() > 0) {
                if(EBookSyncQueue.useQueue) {
                    System.enqueueJob(new EBookSyncQueue(exam, part, productID, accessDuration, iProdList, lstOpp, 0, false));
                }else {
                    for(Opportunity opp :lstOpp) {
                        
                        //mobiusAPI.mProvisionAnEBook(exam, part, productID, accessDuration, iProdList, opp.Id,opp.Shipping_E_mail__c,opp.Shipping_First_Name__c,opp.Shipping_Last_Name__c,opp.GARP_Member_ID__c,opp.ChargentSFA__Invoice_Number__c );
                         mobiusAPI.mProvisionAnEBook(exam, part, productID, accessDuration, iProdList, opp.Id,opp.Shipping_E_mail__c,opp.Shipping_First_Name__c,opp.Shipping_Last_Name__c,opp.GARP_Member_ID__c);
                    } 
                }
            }
        }
    }
    
    public static void unprovisionMobiuseBook(Map<Id, String> garpMemberIdByOpportunityId, String exam, String part) {
        Set<Integer> productIds = new Set<Integer>();
        Map<String, Mobius_Products__c> mobiusProducts = Mobius_Products__c.getall();                
        Mobius_Products__c MobiusProductYearObj = mobiusProducts.get(exam + ' Current Year');
        if(MobiusProductYearObj != null) {
            MobiusProductYear = MobiusProductYearObj.Year__c;
            
            
            for(Mobius_Products__c mobiusProduct :mobiusProducts.values()) {
                if(mobiusProduct.Year__c == MobiusProductYear && mobiusProduct.Exam__c == exam && mobiusProduct.Part__c == part){
                    productIds.add(Integer.valueOf(mobiusProduct.Product_Id__c));
                }
            }
        
            
            for(String key: garpMemberIdByOpportunityId.keySet()){
                system.debug('');
                MobiusAPI.mUnProvisionAnEBook(key, Integer.valueOf(garpMemberIdByOpportunityId.get(key)), productIds);
            }
        }
    }
        
        public static void provisionYardstick(map<ID, Opportunity> eBookOpps, String programid){
            Opportunity lstOpp = [select Id, name,ChargentSFA__Billing_Email__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c from Opportunity where id in :eBookOpps.keySet()];
            string username =lstOpp.ChargentSFA__Billing_Email__c;
            string OpptyId  =lstOpp.Id;
            string FirstName;
            if(lstOpp.ChargentSFA__Billing_Last__c != NULL) {
                FirstName = lstOpp.ChargentSFA__Billing_First__c.replaceAll( '\\s+', '');
            }
            string LastName;
            if(lstOpp.ChargentSFA__Billing_Last__c != NULL) {
                LastName = lstOpp.ChargentSFA__Billing_Last__c.replaceAll( '\\s+', '');
                
            }
            yardStickApi.CreateUserToken(username,OpptyId,programid,FirstName,LastName);
        }
        
        public static void provisionEBookWithKeys(map<ID, Opportunity> eBookOpps, String eBookType) {
            
            List<Opportunity> lstOpp = [select Id, name,Shipping_First_Name__c,Shipping_Last_Name__c,GARP_Member_ID__c,Shipping_E_mail__c,
                                        (SELECT Id,ProductCode, Product_ID__c FROM OpportunityLineItems) 
                                        from Opportunity where id in :eBookOpps.keySet()];
            system.debug('lstOpp:' + lstOpp);
            
            MAP<String, String> mapProd = new MAP<String, String>();
            for(Opportunity opp :lstOpp) {           
                for(OpportunityLineItem ol :opp.OpportunityLineItems){
                    mapProd.put(ol.ProductCode,ol.Product_ID__c);
                }                        
            }
            system.debug('mapProd:' + mapProd);
            system.debug('eBookType:' + eBookType);
            // Get Product ID
            String productId;
            if(eBookType == 'ERP Exam Part I') {
                productId = mapProd.get('ENC1X');
            } else if(eBookType == 'ERP Exam Part II') {
                productId = mapProd.get('ENC2X');
            } else if (eBookType == 'FFR'){
                productId = mapProd.get('FBR1X');
            } else if (eBookType == 'FRR'){
                productId = mapProd.get('CBR1X');
            }
            system.debug('productId:' + productId);
            
            
            List<eBook_Key__c> lstKeysUsed = [select Id, Key__c, Opportunity__c from eBook_Key__c where Type__c = :eBookType and Opportunity__c != null and Opportunity__c in :eBookOpps.keySet()];
            MAP<Id,eBook_Key__c> mapEBookKeysUsed = new MAP<Id,eBook_Key__c>();
            for(eBook_Key__c ebk :lstKeysUsed) {
                mapEBookKeysUsed.put(ebk.Opportunity__c,ebk);
            }
            
            List<eBook_Key__c> lstUpdateKeys = new List<eBook_Key__c>();
            List<eBook_Key__c> lstKey = [select Id, Key__c, Opportunity__c,Access_Duration_in_Months__c from eBook_Key__c where Type__c = :eBookType and Status__c = 'Available'];
            Integer getCount = 0;
            
            system.debug('provisionEBookWithKeys:' + eBookOpps);
            for(Opportunity opp :eBookOpps.values()) {
                
                if(lstKey != null && lstKey.size() > 0 && getCount < lstKey.size() && mapEBookKeysUsed.get(opp.Id) == null) {
                    lstKey[getCount].Opportunity__c = opp.Id;
                    lstKey[getCount].Member_EMail__c = opp.Shipping_E_mail__c;
                    lstKey[getCount].Product_ID__c = productId;
                    lstKey[getCount].Opportunity_1Assigned_Date__c = System.Today();
                    if(lstKey[getCount].Access_Duration_in_Months__c != null) {
                        lstKey[getCount].Access_Expiration_Date__c = System.today().addMonths(integer.valueOf(lstKey[getCount].Access_Duration_in_Months__c));    
                    }
                    lstUpdateKeys.add(lstKey[getCount]);
                    getCount++;
                    system.debug('Found eBook:' + getCount);
                }
                
            }
            update lstUpdateKeys;
            
        }    
        
        public static void updateRenewContracts(Set<Id> setOpps,Set<Id> setAccountIds,Map<Id,Set<String>> mapProdCodesWithAccount,opportunity opp){ 
            
            bIsRecursiveForRenewOpps = true;
            id memRecordType = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
            Map<Id,String> mapProdCodesForMemberShip = new Map<Id,String>();
            system.debug('mapProdCodesWithAccount == '+mapProdCodesWithAccount);
            
            for(Id objId : mapProdCodesWithAccount.keySet()){
                Set<String> setProdCodes = mapProdCodesWithAccount.get(objID);
                system.debug('setProdCodes == '+setProdCodes);
                if(setProdCodes.Contains('AFREE'))
                    mapProdCodesForMemberShip.put(objId,'Affiliate');
                else if(setProdCodes.Contains('MEMI'))
                    mapProdCodesForMemberShip.put(objId,'Individual');
                else if(setProdCodes.Contains('MEMS'))
                    mapProdCodesForMemberShip.put(objId,'Student');
                else if(setProdCodes.Contains('MEMC'))
                    mapProdCodesForMemberShip.put(objId,'Individual');
                else if(setProdCodes.Contains('MEMF'))
                    mapProdCodesForMemberShip.put(objId,'Individual');     
            }
            
            system.debug('mapProdCodesForMemberShip == '+mapProdCodesForMemberShip);
            
            List<Contract> lsNewContracts = new List<Contract>();
            Set<Contract> setUpdatingContracts = new Set<Contract>();
            boolean bIsOneContractActive = false;
            boolean bHasDraftContract = false;
            List<Contract> lstCons = [select id,recordtypeId,Status ,startdate,enddate,ContractTerm,Membership_Type__c,accountId,Opportunity__c from contract where accountId in: setAccountIds and Status != 'Canceled'];
            Map<Id,Contract> mapActivatedCon = new Map<Id,Contract>();
            for(Contract con : lstCons){
                if(con.recordTypeID == memRecordType && (con.Status == 'Activated' || con.Status == 'Activated ( Auto-Renew )')){
                    mapActivatedCon.put(con.accountId,con);
                    bIsOneContractActive = true;}
                else if(con.recordTypeID == memRecordType && con.Status == 'Draft')
                    bHasDraftContract = true;
                
            }
            system.debug('mapActivatedCon == '+mapActivatedCon);
            
            boolean bIsExpired = false;
            for(Contract objContract : lstCons){
                
                system.debug('mapProdCodesForMemberShip == '+mapProdCodesForMemberShip);
                system.debug('objContract == '+objContract);
                system.debug('Membership_Type__c:' + objContract.Membership_Type__c);
                system.debug('mapProdCodesForMemberShip:' + mapProdCodesForMemberShip.get(objContract.accountId));
                
                boolean bHasActivatedContract = false;
                Contract obJActivatedontract = new Contract();
                
                if(mapActivatedCon.containsKey(objContract.accountId))
                {   
                    bHasActivatedContract = true;
                    obJActivatedontract = mapActivatedCon.get(objContract.accountId);
                }
                
                if(objContract.status == 'Draft' && objContract.recordTypeID == riskNetRecordTypeID && setOpps.contains(objContract.Opportunity__c)){
                    
                    objContract.status = 'Activated ';
                    setUpdatingContracts.add(objContract);
                }
                
                if(objContract.status == 'Draft' && (ObjContract.recordTypeID == SCRRecordTypeID ||objContract.recordTypeID == icbrrRecordTypeID) && setOpps.contains(objContract.Opportunity__c))
                {
                    system.debug('1 objContract == '+objContract);
                    objContract.status = 'Activated';
                    objContract.StartDate = system.today();
                    setUpdatingContracts.add(objContract);
                }
                
                if(objContract.status == 'Draft' && (objContract.recordTypeID == frmRecordTypeID || objContract.recordTypeID == erpRecordTypeID || objContract.recordTypeID == fbrRecordTypeID  || objContract.recordTypeID ==fbraRecordTypeID) && setOpps.contains(objContract.Opportunity__c))
                {
                    system.debug('2 objContract == '+objContract);
                    objContract.status = 'Activated ( Auto-Renew )';
                    objContract.StartDate = system.today();
                    setUpdatingContracts.add(objContract);
                }
                else if(mapProdCodesForMemberShip.size() > 0 &&  objContract.status == 'Draft' && objContract.recordTypeID == memRecordType && !bHasActivatedContract && setOpps.contains(objContract.Opportunity__c))
                {
                    system.debug('3 objContract == '+objContract);
                    if(opp.Auto_Renew__c|| objContract.Membership_Type__c == 'Affiliate') objContract.status ='Activated ( Auto-Renew )';
                    else objContract.status ='Activated';
                    objContract.StartDate = system.today();
                    setUpdatingContracts.add(objContract);
                    
                }
                else if(mapProdCodesForMemberShip.size() > 0 && objContract.status == 'Draft' && objContract.recordTypeID == memRecordType && bHasActivatedContract && obJActivatedontract.Membership_Type__c == 'Affiliate' && setOpps.contains(objContract.Opportunity__c))
                {
                    system.debug('4 objContract == '+objContract);
                    obJActivatedontract.status = 'Canceled';
                    objContract.status = 'Activated';
                    objContract.StartDate = system.today();
                    if(opp.Auto_Renew__c) objContract.status ='Activated ( Auto-Renew )';
                    setUpdatingContracts.add(objContract);
                    setUpdatingContracts.add(obJActivatedontract);
                    
                }
                else if(mapProdCodesForMemberShip.size() > 0)
                {
                    system.debug('3 objContract == '+objContract);
                    //objContract.Enddate >= system.today() &&
                    
                    if( objContract.recordTypeID == memRecordType && objContract.Membership_Type__c == mapProdCodesForMemberShip.get(objContract.accountId) &&(objContract.Status == 'Activated'||objContract.Status == 'Activated ( Auto-Renew )')){
                        system.debug('1 objContract == '+objContract);
                        
                        objContract.ContractTerm = objContract.ContractTerm + 12;
                        if(opp.Auto_Renew__c) objContract.status ='Activated ( Auto-Renew )';
                        setUpdatingContracts.add(objContract);
                        bIsOneContractActive = true;
                    }
                    else if(objContract.Enddate < system.today() && objContract.recordTypeID == memRecordType  && objContract.Status == 'Expired' && !bIsOneContractActive && mapProdCodesForMemberShip.get(objContract.accountId)!='Affiliate' && !bIsExpired)
                    {
                        
                        system.debug('7 objContract == '+objContract);
                        setUpdatingContracts.add(objContract);
                        bIsExpired = true;
                        Contract newCon = createContract(opp,system.today(),memRecordType,'Draft',mapProdCodesForMemberShip.get(objContract.accountId),12);
                        
                        lsNewContracts.add(newCon);
                    } 
                    else if((objContract.Membership_Type__c != mapProdCodesForMemberShip.get(objContract.accountId)) && objContract.recordTypeID == memRecordType && objContract.Enddate >= system.today() && mapProdCodesForMemberShip.get(objContract.accountId)!='Affiliate' && (objContract.Status == 'Activated'||objContract.Status == 'Activated ( Auto-Renew )')){
                        
                        
                        system.debug('2 objContract == '+objContract);
                        
                        
                        objContract.Status = 'Canceled';
                        Integer iMonthsLeftOver = 0;
                        if(objContract.Membership_Type__c == 'Affiliate') iMonthsLeftOver = 12;
                        else
                        {
                            Integer iMonthsTilDate = objContract.startDate.monthsBetween(system.today());
                            if(objContract.enddate >= system.today())
                                iMonthsLeftOver = system.today().monthsBetween(objContract.enddate);
                            else
                                iMonthsLeftOver = objContract.enddate.monthsBetween(system.today());
                            objContract.ContractTerm = iMonthsTilDate == 0 ? 1 : iMonthsTilDate;
                            if(iMonthsTilDate == 0)
                                objContract.Technically_Zero__c = true;
                            
                            iMonthsLeftOver += 12;
                        }
                        setUpdatingContracts.add(objContract);
                        Contract newCon = createContract(opp,system.today(),memRecordType,'Draft',mapProdCodesForMemberShip.get(objContract.accountId),iMonthsLeftOver);
                        lsNewContracts.add(newCon);
                        
                        
                    }
                    
                    else if((opp.Cross_Check__c == true) &&(objContract.Membership_Type__c != mapProdCodesForMemberShip.get(objContract.accountId)) && objContract.recordTypeID == memRecordType && mapProdCodesForMemberShip.get(objContract.accountId)!='Affiliate' && (objContract.Status == 'Activated'||objContract.Status == 'Activated ( Auto-Renew )')){
                        
                        Integer iMonthsLeftOver = 12;
                        system.debug('10 objContract == '+objContract);
                        Contract newCon = createContract(opp,system.today(),memRecordType,'Draft',mapProdCodesForMemberShip.get(objContract.accountId),iMonthsLeftOver);
                        lsNewContracts.add(newCon);
                        
                        
                    }   
                    
                    else if(bIsOneContractActive== true && bHasDraftContract == false  && (objContract.Status == 'Activated'||objContract.Status == 'Activated ( Auto-Renew )')&& objContract.Membership_Type__c == 'Affiliate' ){   
                        
                        Integer iMonthsLeftOver = 12;   
                        system.debug('10 objContract == '+objContract); 
                        Contract newCon = createContract(opp,system.today(),memRecordType,'Draft',mapProdCodesForMemberShip.get(objContract.accountId),iMonthsLeftOver);    
                        lsNewContracts.add(newCon);  
                        
                        
                    }     
                }
            }
            
            List<Contract> upsertList = New List<Contract>();
            upsertList.addAll(setUpdatingContracts);
            
            
            upsertList.addAll(lsNewContracts);
            System.debug('%%%%%:'+upsertList);
            if(!upsertList.isEmpty()){
                
                try{
                    
                    UPSERT upsertList;
                    
                    List<Contract> contracts = [SELECT Id, Status FROM Contract WHERE Id IN:upsertList  and status ='Draft' ];
                    System.debug('%%%%%:'+contracts);
                    if(!contracts.isEmpty()){
                        Contract contract = contracts[0];
                        if(opp.Auto_Renew__c){
                            contract.status ='Activated ( Auto-Renew )';
                        }else{
                            contract.Status = 'Activated';
                        }
                        
                        UPDATE contract;
                        
                    }
                    System.debug('%%%%%:'+contracts);
                }catch(Exception e){
                    System.debug(e.getMessage());
                    System.debug(e.getStackTraceString());
                }
                
            }
            
        }  
        
        public static void updateShipService(Map<Id,Opportunity> mapOppIds) {
            
            bIsRecursiveForOpps = true;
            
            Map<Id,oppLineWrapper> mapOppLines = new Map<Id,oppLineWrapper>();
            
            for(OpportunityLineItem oppLine : [
                SELECT id,ProductCode, Product2.Is_Shippable__c, OpportunityId, Product2.Weight__c, Product2.Product_ID__c, Product2.Bookstore__c, Description, Quantity, Product2.Name, Product2.Customs_Cost__c  
                FROM OpportunityLineItem 
                WHERE OpportunityId in: mapOppIds.keySet()
            ]){
                Opportunity opp = mapOppIds.get(oppLine.OpportunityId);
                if(oppLine.ProductCode == 'Ship')
                {   
                    opp.Shipping_Serive_Selected__c = oppLine.Description;
                    opp.UPS_Service_Code_For_Xml__c = getUPSCode(oppLine.Description);
                    
                }
                oppLineWrapper oWrapper;
                if(mapOppLines.containsKey(oppLine.OpportunityId))
                {
                    oWrapper = mapOppLines.get(oppLine.OpportunityId);
                }
                else
                    oWrapper = new oppLineWrapper();
                
                if(oppLine.Product2.Is_Shippable__c == true)
                {
                    if(oWrapper.Product_Codes == null)
                        oWrapper.Product_Codes =   oppLine.Product2.Product_ID__c;
                    else
                        oWrapper.Product_Codes =   oWrapper.Product_Codes + ',' +oppLine.Product2.Product_ID__c;
                    
                    if(oWrapper.Product_Names == null)
                        oWrapper.Product_Names =   oppLine.Product2.Name;
                    else
                        oWrapper.Product_Names =   oWrapper.Product_Names + ',' +oppLine.Product2.Name;
                    
                    if(oWrapper.Customs_Cost == null)
                        oWrapper.Customs_Cost =   string.valueof(oppLine.quantity * integer.valueof(oppLine.Product2.Customs_Cost__c));
                    else
                        oWrapper.Customs_Cost =   oWrapper.Customs_Cost + ',' +string.valueof(oppLine.quantity * integer.valueof(oppLine.Product2.Customs_Cost__c));
                    
                    
                    if(oWrapper.Product_Weight == null)
                        oWrapper.Product_Weight =   oppLine.quantity *oppLine.Product2.Weight__c;
                    else
                        oWrapper.Product_Weight =   oWrapper.Product_Weight + (oppLine.quantity *oppLine.Product2.Weight__c);
                    
                    
                    //oWrapper.Product_Weight = (oWrapper.Product_Weight == null ? 0 : oWrapper.Product_Weight) +  oppLine.Product2.Weight__c == null ? 0 : oppLine.Product2.Weight__c;
                    
                    mapOppLines.put(oppLine.OpportunityId,oWrapper);
                    
                }
                
            }
            system.debug('mapOppLines :'+mapOppLines);
            list<Opportunity> opp1 = new list<Opportunity>();
            for(Id oppId : mapOppLines.keySet())
            {
                Opportunity opp = mapOppIds.get(oppId);
                opp.Total_Package_Weight__c = mapOppLines.get(oppId).Product_Weight;
                opp.Product_Ids__c = mapOppLines.get(oppId).Product_Codes;
                opp.Product_Names__c = mapOppLines.get(oppId).Product_Names;
                opp.Customs_Cost__c = mapOppLines.get(oppId).Customs_Cost;
                opp1.add(opp);
                
                
            }
            
            update opp1;
            
        }
        
        public class oppLineWrapper {
            public string Product_Codes;
            public Decimal Product_Weight; 
            public string Product_Names;
            public string Customs_Cost;
        }
        
        public static String getUPSCode(String strDesc) {
            if(strDesc == null) return 'ERROR';
            if(strDesc.IndexOf('UPS Next Day Air') >= 0)
                return '1DA';
            if(strDesc.IndexOf('UPS 2nd Day Air') >= 0)
                return '2DA';
            if(strDesc.IndexOf('UPS Ground') >= 0)
                return 'GND';
            if(strDesc.IndexOf('UPS Worldwide Express')  >= 0)
                return 'ES';
            if(strDesc.IndexOf('UPS Worldwide Expedited') >= 0)
                return 'EX';
            if(strDesc.IndexOf('UPS Standard') >= 0)
                return 'ST';
            if(strDesc.IndexOf('UPS 3 Day Select') >= 0)
                return '3DS';
            if(strDesc.IndexOf('UPS Next Day Air Saver') >= 0)
                return '1DP';
            if(strDesc.IndexOf('UPS Next Day Air Early A.M.') >= 0)
                return '1DM';
            if(strDesc.IndexOf('UPS Worldwide Express Plus') >= 0)
                return 'EP';
            if(strDesc.IndexOf('UPS 2nd Day Air A.M.') >= 0)
                return '2DM';
            if(strDesc.IndexOf('UPS Saver') >= 0)
                return 'SV';
            return 'ERROR';
        }
        
        public static void updateShippingInfo(List<Opportunity> lstOpp) {
            Set<Id> setAccountId = new Set<Id>();
            for(Opportunity opp : lstOpp)
                setAccountId.add(opp.accountId);
            
            Map<Id,Contact> mapContact = new Map<Id,Contact>();
            for(Contact ct : [select id,AccountId,MailingCity,MailingState,MailingCountry,MailingPostalCode,MailingStreet,email,firstname,lastname,Phone from contact where accountId in : setAccountId])
                mapContact.put(ct.accountId,ct);
            
            for(Opportunity oppUpdate : lstOpp){
                Contact con = mapContact.get(oppUpdate.accountId);
                oppUpdate.Shipping_City__c = con.MailingCity;
                oppUpdate.Shipping_Postal_Code__c = con.MailingPostalCode;
                oppUpdate.Shipping_State__c = con.MailingState;
                oppUpdate.Shipping_Country__c = con.MailingCountry;
                oppUpdate.Shipping_E_mail__c = con.email;
                oppUpdate.Shipping_First_Name__c = con.firstname;
                oppUpdate.Shipping_Last_Name__c = con.lastname;
                oppUpdate.Shipping_Phone_No__c = con.Phone;
                oppUpdate.Shipping_Street__c = con.MailingStreet;                    
            }
            
        }
        
        public static void updateAutoRenew(Set<Id> accountIds) {
            bAutoRenew = true;
            List<Contract> lstContracts = new List<Contract>();
            List<Contact> lstContacts = [select id,KPI_Membership_Auto_Renew_Status__c from contact where accountId in: accountIds];
            for(Contact objCon : lstContacts)
            {
                objCon.KPI_Membership_Auto_Renew_Status__c = true;
                update objcon;
            }
            for(Contract objContr : [select id, Status ,RecordTypeId,accountId,Opportunity__c,ContractTerm,EndDate,startdate,Membership_Type__c from contract where  accountId in : accountIds and RecordTypeId =: memberRecordTypeID])
            {
                if(objContr.Status == 'Activated' || objContr.Status == 'Draft')
                {
                    objContr.status = 'Activated ( Auto-Renew )';
                    lstContracts.add(objContr);
                }
            }
            
            if(lstContracts.size() > 0)
                update  lstContracts;
            
        }
    
        public static void updateGarpDirectoryOptIn(Set<Id> OppAccountId) {
            List<Contact> lstcon = new List<Contact>();
            for(Contact c: [Select id from Contact where AccountId IN: OppAccountId and GARP_Directory_Opt_In__c != true and Membership_Type__c != 'Individual']){
                c.GARP_Directory_Opt_In__c = true;
                lstcon.add(c);
            }
            update lstcon;
        }

        public static void updateGarpON24HubOptIn(Set<Id> OppAccountId) {
            List<Contact> lstcon = new List<Contact>();
            for(Contact c: [Select id from Contact where AccountId IN: OppAccountId]){
                on24API.createON24EngagementHubRegistration(c.id);
            }
            update lstcon;
        }
    
        public static void updateRegisterExamAttempts(Set < ID > setRegisterExamAttempts) {
            system.debug('* * * setRegisterExamAttempts ...'+ setRegisterExamAttempts);  
            
            /*
MAP<ID,ID> mapMemberExamAttempt = new MAP<ID,ID>();
LIST<Exam_Attempt__c> lstExamAttempFinal = new LIST<Exam_Attempt__c>();
if (setRegisterExamAttempts.size() > 0) {
List < Exam_Attempt__c > lstExamAttempts = [select id, Section__c, Member__c, Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where id in : setRegisterExamAttempts];
for(Exam_Attempt__c ea :lstExamAttempts) {
ID fnd = mapMemberExamAttempt.get(ea.Member__c);
if(fnd == NULL)
lstExamAttempFinal.add(ea);
mapMemberExamAttempt.put(ea.Member__c,ea.Id);

}
system.debug('lstExamAttempFinal: '+ lstExamAttempFinal);  
if(lstExamAttempFinal.size() > 0)
update lstExamAttempFinal;
} 
*/           
        }
        
        public static void provisionEvents(Set < Id > setOpportunities) {
            LIST<Event_Registration__c > lstEventRegistrations = [select Id,Event__r.ON24_Event_Id__c,Event__r.ON24_API_Key__c,Contact__r.id,Status__c from Event_Registration__c where Opportunity__c  in :setOpportunities];
            for(Event_Registration__c  itemEventRegistrations :lstEventRegistrations) {
                itemEventRegistrations.Status__c = 'Registered and Paid';
                
                // Call ON24 for Virtual Standard Event
                // List < Event_Registration__c  > eventRegistrationDetails = [SELECT Id,Event__r.ON24_Event_Id__c,Event__r.ON24_API_Key__c FROM Event_Registration__c where id =: itemEventRegistrations.Id];   
                if(itemEventRegistrations.Event__r.ON24_Event_Id__c != null) {
                    API_Transaction__c trans = on24API.createAPITransactionRecord('event',itemEventRegistrations.Id,itemEventRegistrations.Contact__r.Id,
                                                                                  itemEventRegistrations.Event__r.ON24_Event_Id__c, itemEventRegistrations.Event__r.ON24_API_Key__c);
                    if(trans != null){
                        on24API.SendRequest(null, trans.Id);
                    } 
                }
            }
            update lstEventRegistrations;
        }
        
        public static void provisionChapterMeetingRegistrations(Map < Id, Opportunity > oppMap) {
            List<Chapter_Meeting_Registration__c> lstChaptMeetRegs = [select Id,contact__r.id, Name,Chapter_Meeting__r.ON24_Event_Id__c,Chapter_Meeting__r.ON24_API_Key__c, Opportunity__c, Status__c from Chapter_Meeting_Registration__c where Opportunity__c in :oppMap.keySet()];
            System.debug('lstChaptMeetRegs: ' + lstChaptMeetRegs);
            
            for(Chapter_Meeting_Registration__c cmr :lstChaptMeetRegs) {
                cmr.Status__c = 'Confirmed';
                // Call ON24 for Virtual Chapter Meeting (that has an order/purchased membership during registration)
                // List < Chapter_Meeting_Registration__c  > chapterMeetingRegistrationDetails = [SELECT Id,Chapter_Meeting__r.ON24_Event_Id__c,Chapter_Meeting__r.ON24_API_Key__c FROM Chapter_Meeting_Registration__c where (Contact__c =: contactId and Chapter_Meeting__c =: objData.chapterMeetingId)];   
                if(cmr.Chapter_Meeting__r.ON24_Event_Id__c != null) {
                    API_Transaction__c trans = on24API.createAPITransactionRecord('chaptermeeting',cmr.Id , cmr.contact__r.id,
                                                                                  cmr.Chapter_Meeting__r.ON24_Event_Id__c, cmr.Chapter_Meeting__r.ON24_API_Key__c);
                    if(trans != null){
                        on24API.SendRequest(null, trans.Id);
                    } 
                }
            }
            update lstChaptMeetRegs;
        }
        
        public static void provisionFFRA(Map < Id, Opportunity > oppMap) {
            
            bIsRecursiveForFFROpps = true;
            system.debug('* * * provisionFFR ...'+ oppMap);
            MAP<ID,ID> ids = new MAP<ID,ID>();
            MAP<ID,ID> contactAcct = new MAP<ID,ID>();
            MAP<ID,String> mapAPITrans = new MAP<ID,String>();
            for(Opportunity opp :oppMap.values()) {
                ids.put(opp.AccountId, opp.id);
            }
            system.debug('ids:' + ids);
            LIST<Contact> conts = [select Id, AccountId from Contact where AccountId in :ids.keySet()];
            for(Contact cont :conts) {
                contactAcct.put(cont.AccountId, cont.id);
            }
            system.debug('contactAcct:' + contactAcct);
            List<API_Transaction__c> apiTrans = [select Id, Request__c, Opportunity__c, Ignore_for_Retry__c from API_Transaction__c where Opportunity__c in :ids.keySet()];
            for(API_Transaction__c transA :apiTrans) {
                if(transA.Ignore_for_Retry__c != True)
                    mapAPITrans.put(transA.Opportunity__c, transA.Request__c);
            }
            system.debug('mapAPITrans:' + mapAPITrans);
            for(Opportunity opp :oppMap.values()) {
                ID contId = contactAcct.get(opp.AccountId);
                String transMap = mapAPITrans.get(opp.Id);
                if(contId != NULL && (transMap == null || transMap.indexOf('RecordPurchase') == -1)) {
                    API_Transaction__c trans = smartProsAPI.RecordPurchaseStart(contId, opp.ChargentSFA__Billing_Company__c, opp.ChargentSFA__Billing_First__c, opp.ChargentSFA__Billing_Last__c, opp.ChargentSFA__Billing_Email__c, opp.Id);
                    smartProsAPI.SendRequest(trans.Request__c, trans.Id);
                }
            }
        }
        
        public static void cancelFFRA(Set<Id> oppIDs) {
            system.debug('* * * cancelFFR ...'+ oppIDs);
            MAP<ID,ID> ids = new MAP<ID,ID>();
            MAP<ID,ID> contactAcct = new MAP<ID,ID>();
            
            LIST<Opportunity> opps = [select Id, AccountId, ChargentSFA__Billing_Email__c from Opportunity where ID in :oppIDs];
            for(Opportunity opp :opps) {
                ids.put(opp.AccountId, opp.id);
            }
            system.debug('ids:' + ids);
            LIST<Contact> conts = [select Id, AccountId from Contact where AccountId in :ids.keySet()];
            for(Contact cont :conts) {
                contactAcct.put(cont.AccountId, cont.id);
            }
            system.debug('contactAcct:' + contactAcct);
            
            for(Opportunity opp :opps) {
                ID contId = contactAcct.get(opp.AccountId);
                if(contId != NULL) {            
                    API_Transaction__c trans = smartProsAPI.cancelPurchaseStart(opp.ChargentSFA__Billing_Email__c, opp.Id);
                    smartProsAPI.SendRequest(trans.Request__c, trans.Id);
                }
            }
            Id fbrRecordType = RecordTypeHelper.GetRecordTypeId('Contract', 'FBR Program');
            List<Contract> lstContr = [select Id, Status, AccountID from Contract where AccountID in :ids.keySet() and RecordTypeID = :fbrRecordType];
            for(Contract contr :lstContr) {
                contr.Status = 'Canceled';
            }
            update lstContr;
        }
        
        public static void closeBulkOrders(Map<Id, Opportunity> masterOrdersMap) {
            
            Set<Id> masterOrderIds = masterOrdersMap.keySet();
            
            System.debug('Master Order IDs: ' + masterOrderIds);
            
            if(!masterOrderIds.isEmpty()) {
                
                List<ChargentSFA__Transaction__c> transactions = [
                    SELECT Id, Name, ChargentSFA__Opportunity__c, ChargentSFA__Amount__c, ChargentSFA__Gateway_ID__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c 
                    FROM ChargentSFA__Transaction__c 
                    WHERE ChargentSFA__Opportunity__c in :masterOrderIds
                ];
                
                Map<Id, ChargentSFA__Transaction__c> transactionByMasterOrderId = new Map<Id, ChargentSFA__Transaction__c>();
                for(ChargentSFA__Transaction__c t: transactions){
                    transactionByMasterOrderId.put(t.ChargentSFA__Opportunity__c, t);
                }
                
                List<Opportunity> childOpportunities = [
                    SELECT Id, Name, StageName, Inst_Sale_Opp__c 
                    FROM Opportunity 
                    WHERE Inst_Sale_Opp__c in :masterOrderIds
                ];
                
                List<Opportunity> childOppportunitiesToClose = new List<Opportunity>();
                Map<Id, ChargentSFA__Transaction__c> childOppportunityTransactionsByOpportunityId = new Map<Id, ChargentSFA__Transaction__c>();        
                
                for(Opportunity childOpportunity :childOpportunities) {
                    
                    if(childOpportunity.StageName != 'Closed Lost'){
                        
                        Opportunity masterOpportunity = masterOrdersMap.get(childOpportunity.Inst_Sale_Opp__c);
                        
                        childOpportunity.StageName =  'Closed';
                        
                        if(transactionByMasterOrderId.containsKey(masterOpportunity.Id)){
                            
                            ChargentSFA__Transaction__c masterOrderTransaction = transactionByMasterOrderId.get(masterOpportunity.Id);
                            
                            ChargentSFA__Transaction__c childOppportunityTransaction = new ChargentSFA__Transaction__c();
                            
                            childOppportunityTransaction.ChargentSFA__Amount__c         = masterOrderTransaction.ChargentSFA__Amount__c;
                            childOppportunityTransaction.ChargentSFA__Gateway_Date__c   = masterOrderTransaction.ChargentSFA__Gateway_Date__c;
                            childOppportunityTransaction.ChargentSFA__Type__c           = masterOrderTransaction.ChargentSFA__Type__c;
                            childOppportunityTransaction.ChargentSFA__Payment_Method__c = masterOrderTransaction.ChargentSFA__Payment_Method__c;
                            childOppportunityTransaction.ChargentSFA__Gateway_ID__c     = masterOrderTransaction.ChargentSFA__Gateway_ID__c;
                            childOppportunityTransaction.ChargentSFA__Opportunity__c    = childOpportunity.Id;
                            
                            childOppportunityTransactionsByOpportunityId.put(childOpportunity.Id, childOppportunityTransaction);
                            
                        }
                        
                        childOppportunitiesToClose.add(childOpportunity);
                        
                    }
                    
                }
                
                database.executeBatch(new BulkCloseInstitutionalSaleOrdersBatch(childOppportunitiesToClose, childOppportunityTransactionsByOpportunityId), 1);
                
            }            
            
        }
        
        public static void updateExamAttempts(Set < ID > setExamAttempts,Set < ID > setUnDeferredExamAttempts,set<ID> setLateDeferredExamAttempts,set<ID> setLateUnDeferredExamAttempts){
            bUpdateEA = true;
            List<Exam_Attempt__c> lstUpdateEAs = new List<Exam_Attempt__c>();
            List<Exam_Attempt__c> lstUpdateEAs1 = new List<Exam_Attempt__c>();
            List<Exam_Attempt__c> lstExamAttempts1 = new List<Exam_Attempt__c>();
            
            
            set<id> opps = new set<id>();
            list<opportunity>opplist = new list<opportunity>();
            MAP<Id, Id> mapExamAttempts = new MAP<Id, Id>();
            // logic for defering depending if it is frm1 or frm 2
            
            system.debug('* * * updateExamAttempts ...'+ setExamAttempts + ':' + setUnDeferredExamAttempts);        
            if (setExamAttempts.size() > 0) {
                
                List < Exam_Attempt__c > lstExamAttempts = [select id, Section__c,Opportunity_StageName__c,Opportunity__c,Cancelled__c, Member__c, Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where id in : setExamAttempts and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true and Cancelled__c = false and Opportunity_StageName__c ='closed'];
                Set < Id > setMemberIds = new Set < Id > ();
                
                for (Exam_Attempt__c objExaAttmept: lstExamAttempts) {
                    
                    ExamManagementController.createDeferralProductRefunds(
                        objExaAttmept.Id, ExamManagementController.DeferralAction.DEFER
                    ); 
                    
                    mapExamAttempts.put(objExaAttmept.Id, objExaAttmept.Id);
                    if (objExaAttmept.Section__c == 'FRM Part 1' || objExaAttmept.Section__c == 'ERP Exam Part I'&& objExaAttmept.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == true) {
                        setMemberIds.add(objExaAttmept.Member__c);
                    }
                }
                
                for (Exam_Attempt__c objEA: [select id, Section__c,Opportunity_StageName__c,Opportunity__c, Member__c, Defered__c,Cancelled__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where Member__c in : setMemberIds and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true ]) {
                    
                    Id findEA = mapExamAttempts.get(objEA.Id);
                    if ((objEA.Section__c == 'FRM Part 1' || objEA.Section__c == 'FRM Part 2' || objEA.Section__c == 'ERP Exam Part I' || objEA.Section__c == 'ERP Exam Part II') && findEA == null && objEA.Cancelled__c == false && objEA.Opportunity_StageName__c =='closed') {
                        
                        lstExamAttempts.add(objEA);
                        
                    }
                    
                    if ((objEA.Section__c == 'FRM Part 1' || objEA.Section__c == 'FRM Part 2' || objEA.Section__c == 'ERP Exam Part I' || objEA.Section__c == 'ERP Exam Part II') && findEA == null && objEA.Opportunity_StageName__c !='closed') {
                        
                        opps.add(objEA.Opportunity__c);
                        lstExamAttempts1.add(objEA);
                        
                        
                    }
                }
                
                system.debug('* * * setExamAttempts ...'+ lstExamAttempts);
                
                for (Exam_Attempt__c updEA: lstExamAttempts1) {
                    updEA.cancelled__C = true;
                    lstUpdateEAs1.add(updEA);
                }
                
                
                for (Exam_Attempt__c updEA: lstExamAttempts) {
                    updEA.Defered__c = 'Pending';
                    lstUpdateEAs.add(updEA);
                }
                
                update lstUpdateEAs;
                update lstUpdateEAs1;
                
                
                for (opportunity opp:[select stagename, id from opportunity where id in:opps]) {
                    opp.stagename = 'Closed Lost';
                    opplist.add(opp);
                    //lstUpdateEAs.add(updEA);
                } 
                
                update opplist;
                
            }
            // logic for undeferring depending on frm1 or frm2.
            
            if (setUnDeferredExamAttempts.size() > 0) {
                
                List < Exam_Attempt__c > lstExamAttempts = [select id,Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Section__c, Member__c, Defered__c from Exam_Attempt__c where id in : setUnDeferredExamAttempts];
                Set < Id > setMemberIds = new Set < Id > ();
                
                for (Exam_Attempt__c objExaAttmept: lstExamAttempts) {
                    
                    ExamManagementController.createDeferralProductRefunds(
                        objExaAttmept.Id, ExamManagementController.DeferralAction.UNDEFER
                    ); 
                    
                    mapExamAttempts.put(objExaAttmept.Id, objExaAttmept.Id);
                    if (objExaAttmept.Section__c == 'FRM Part 2' || objExaAttmept.Section__c == 'ERP Exam Part II'&& objExaAttmept.Exam_Site__r.Exam__r.Exam_Group__r.Active__c == true) {
                        setMemberIds.add(objExaAttmept.Member__c);
                    }
                }
                
                system.debug('* * * setMemberIds ...'+ setMemberIds);
                
                for (Exam_Attempt__c objEA: [select id, Section__c, Member__c, Defered__c from Exam_Attempt__c where Member__c in : setMemberIds]) {
                    
                    Id findEA = mapExamAttempts.get(objEA.Id);
                    if ((objEA.Section__c == 'FRM Part 1' || objEA.Section__c == 'FRM Part 2' || objEA.Section__c == 'ERP Exam Part I' || objEA.Section__c == 'ERP Exam Part II') && findEA == null) {
                        
                        lstExamAttempts.add(objEA);
                        
                    }
                }
                
                system.debug('* * * setUnDeferredExamAttempts ...'+ lstExamAttempts);
                
                for (Exam_Attempt__c updEA: lstExamAttempts) {
                    updEA.Defered__c='';
                }
                update lstExamAttempts;
            }
            
            
            // LOGIC FOR LATE DEFERRALS
            
            if (setLateDeferredExamAttempts.size() > 0) {
                
                for(Exam_Attempt__c ea : [select id,Section__c, Opportunity__c ,Exam_Site__r.Exam_Site_Code_idetifier__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Exam_Date__c,Defered__c from Exam_Attempt__c where id in: setLateDeferredExamAttempts and Cancelled__c = false and Opportunity_StageName__c ='closed'])
                {
                    
                    if(ea.Section__c== 'FRM Part 2' || ea.Section__c == 'ERP Exam Part II')
                        updateExm(new List<Exam_Attempt__c>{ea}, ea.Member__c,ea.opportunity__C );
                    else   
                        for(Exam_Attempt__c ea1 : [select id,Section__c,Exam_Site__r.Exam_Site_Code_idetifier__c,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c from Exam_Attempt__c 
                                                   where Exam_Date__c =: ea.Exam_Date__c and Member__c =: ea.Member__c  and Cancelled__c = false and Opportunity_StageName__c ='closed'])
                        updateExm(new List<Exam_Attempt__c>{ea1}, ea1.Member__c,ea1.opportunity__C );
                    
                }
                
                
            }
            
            // LOGIC FOR LATE Un-DEFERRALS
            if (setLateUnDeferredExamAttempts.size() > 0) {
                
                for(Exam_Attempt__c ea : [select id,Section__c,Cloned_From__R.Cancelled__c,Cloned_From__R.Defered__c,Cloned_From__c, Opportunity__c ,Exam_Site__r.Exam_Site_Code_idetifier__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Exam_Date__c,Defered__c from Exam_Attempt__c where id in: setLateUnDeferredExamAttempts and Cancelled__c = false and Opportunity_StageName__c ='closed'])
                {
                    
                    if(ea.Section__c== 'FRM Part 1' || ea.Section__c == 'ERP Exam Part I')
                        UnDeferExm(new List<Exam_Attempt__c>{ea}, ea.Member__c,ea.opportunity__C );
                    else   
                        for(Exam_Attempt__c ea1 : [select id,Section__c,Cloned_From__c,Exam_Site__r.Exam_Site_Code_idetifier__c,Opportunity__c,Deferral_Status__c,Candidate_Commitment__c,Member__c,Candidate_Requirement__c,Exam_Site__c,Defered__c from Exam_Attempt__c 
                                                   where Exam_Date__c =: ea.Exam_Date__c and Member__c =: ea.Member__c  and Cancelled__c = false and Opportunity_StageName__c ='closed'])
                        UnDeferExm(new List<Exam_Attempt__c>{ea1}, ea1.Member__c,ea1.opportunity__C );
                    
                }
                
                
            }
            
        }
        
        public static void UnDeferExm(List<Exam_Attempt__c> examAttmpt,id ca,id opp){
            
            
            List<Exam_Attempt__c> lstToUpdate = new List<Exam_Attempt__c>();
            List<Exam_Attempt__c> lstToUpdate1 = new List<Exam_Attempt__c>();
            
            
            for(Exam_Attempt__c obj : examAttmpt)  
            {
                obj.Cancelled__c =true;
                obj.Cancel_Reason__c ='Un-Deferral';
                obj.Defered__c ='';
                lstToUpdate.add(obj);
                system.debug('%%%%%:'+lstToUpdate);
                if(obj.Cloned_From__c != null){
                    Exam_Attempt__c clObj = new Exam_Attempt__c();
                    clObj.Id = obj.Cloned_From__c;
                    clObj.Cancelled__c = false;
                    clObj.Defered__c= '';
                    lstToUpdate1.add(clObj);
                }
                
                // erere.Cancelled__c =false;
                // erere.Defered__c ='';
                //  lstToUpdate1.add(erere);
                // system.debug('$$$$$$:'+lstToUpdate1);
                
            }
            if(!lstToUpdate.isEmpty())
                update lstToUpdate;
            if(!lstToUpdate1.isEmpty())
                update lstToUpdate1;
        }
        
        public static void updateExm(List<Exam_Attempt__c> examAttmpt,id ca,id opp){
            
            Map<String,Id> mapOldSiteCodes = new Map<String,Id>();
            Map<String,Id> mapNewSiteCodes = new Map<String,Id>();
            List<Exam_Attempt__c> lstToUpdate = new List<Exam_Attempt__c>();
            List<Exam_Attempt__c> lstToUpdate1 = new List<Exam_Attempt__c>();
            
            for(Exam_sites__c  objSite : [select id,name,Exam_Site_Code_idetifier__c from Exam_sites__c where Exam__r.Exam_Group__r.active__c = true])
            {
                mapNewSiteCodes.put(objSite.Exam_Site_Code_idetifier__c,objSite.Id);
            }
            
            
            Map<Id,Exam_Attempt__c> mapDetails = new Map<Id,Exam_Attempt__c>();
            for(Exam_Attempt__c obj : examAttmpt)  
            {
                
                mapOldSiteCodes.put(obj.Exam_Site__r.Exam_Site_Code_idetifier__c,obj.Exam_Site__c);
                Exam_Attempt__c clonedRec = obj.clone(false,true,false,false);
                if(!Test.isRunningTest()){
                    
                    
                    clonedRec.Exam_Site__c = mapNewSiteCodes.get(obj.Exam_Site__r.Exam_Site_Code_idetifier__c);
                    clonedRec.Defered__c = 'Approved';
                    clonedRec.Deferral_Status__c = 'Deferred In';
                    clonedRec.Cloned_From__c = obj.id;
                    clonedRec.opportunity__C = opp;
                    clonedRec.member__C=ca;
                }
                obj.Defered__c = 'Approved';
                obj.Cancelled__c =true;
                obj.Cancel_Reason__c ='Deferral';
                obj.Deferral_Status__c ='Deferred Out';
                
                lstToUpdate.add(obj);
                system.debug('%%%%%:'+lstToUpdate);
                if(!Test.isRunningTest()){
                    lstToUpdate1.add(clonedRec);
                    system.debug('$$$$$$:'+lstToUpdate1);
                }
            }
            
            upsert lstToUpdate;
            upsert lstToUpdate1;
        }
        
        //create Product Refunds. 
        public static void createProductRefunds(Set<String> oppid){ 
            list<Product_Refunds__c> productrefundlist = new list<Product_Refunds__c> ();
            List<PriceBookEntry> pricebookent=[select unitprice, productcode, product2Id from PriceBookEntry where Pricebook2.IsActive = true and productcode = 'CHLF' and product2.Gl_Code__c = '2008' and isActive = true];
            Map<Id,Id> TransactionMap = new Map<Id,Id>(); 
            for(ChargentSFA__Transaction__c Transactions :[Select Id,ChargentSFA__Opportunity__c From ChargentSFA__Transaction__c Where ChargentSFA__Type__c = 'Charge' 
                                                           And ChargentSFA__Response__c ='0' And ChargentSFA__Response_Status__c ='Approved' And 
                                                           ChargentSFA__Response_Message__c='Approved' And ChargentSFA__Opportunity__c in:oppid]){
                                                               TransactionMap.put(Transactions.ChargentSFA__Opportunity__c,Transactions.Id);                             
                                                           }
            
            if(!pricebookent.isEmpty()){
                for(String op:oppid){
                    Product_Refunds__c pr = new Product_Refunds__c();
                    pr.Opportunity__c =op;
                    pr.Product__c = pricebookent[0].Product2Id; 
                    pr.Refund_amount__c = pricebookent[0].unitprice;
                    if(TransactionMap.containsKey(op))
                        pr.Payment_Transaction__c = TransactionMap.get(op);
                    productrefundlist.add(pr);   
                }
            } 
            
            if(!productrefundlist.isEmpty()){
                insert productrefundlist;
            }
        }
        
        public Static Void getExamSitedata(Set<String> SiteCode,Set<String> examAttemptMember){
            
            List<Exam_Attempt__c> examAttemptList = [select id,Name,Site_Code__c,Section__c,Opportunity__c,Defered__c,Exam_Date__c from Exam_Attempt__c where  Member__c In:examAttemptMember and Opportunity_StageName__c ='closed' and result__C =:null And Cancelled__c = false order by Exam_Date__c DESC];
            if(!examAttemptList.isEmpty()){
                Date myDate = date.newinstance(2020, 10, 24);
                Set<String> SectionList = new Set<String>();
                Set<Date> ExamdateList = new Set<Date>();
                for(Exam_Attempt__c ex:examAttemptList){
                    SectionList.add(ex.Section__c);  
                    if(myDate == ex.Exam_Date__c){
                        Date dt = date.newInstance(2020, 05, 16);
                        ExamdateList.add(dt); 
                    }else{
                        ExamdateList.add(ex.Exam_Date__c);  
                    } 
                }
                
                
                Map<String,String> examsiteMap = new Map<String,String>();
                List<Exam_Sites__c> examSiteLst = [Select Id,Move_Exam_Registration_code__c,Exam_Date__c,Site_code__c from Exam_Sites__c Where Site_code__c In:SiteCode And Move_Exam_Registration_code__c In:SectionList and Exam_Date__c In:ExamdateList];
                
                if(!examSiteLst.isEmpty()){  
                    for(Exam_Sites__c exs:examSiteLst){
                        if(exs.Move_Exam_Registration_code__c != null){ 
                            String key = exs.Site_code__c+''+exs.Move_Exam_Registration_code__c+''+exs.Exam_Date__c; 
                            examsiteMap.put(key,exs.Id); 
                        }
                        
                    }
                }
                
                Map<Id,Exam_Attempt__c> updateexamattemptlist = new Map<Id,Exam_Attempt__c>();
                for(Exam_Attempt__c ex:examAttemptList){ 
                    for(String s:SiteCode){
                        Exam_Attempt__c exa = new Exam_Attempt__c();
                        date dt = ex.Exam_Date__c;
                        if(myDate == ex.Exam_Date__c){
                            dt = date.newInstance(2020, 05, 16);
                        }
                        String keyval = s+''+ex.Section__c+''+dt; 
                        if(examsiteMap.containsKey(keyval)){ 
                            exa.Exam_Site__c = examsiteMap.get(keyval);
                            exa.Id = ex.Id;
                            updateexamattemptlist.put(exa.Id,exa);
                        }  
                    }
                } 
                if(!updateexamattemptlist.isEmpty()){
                    Update updateexamattemptlist.values();
                }
            }
        }
        
        public static void UpdateATAPsi(set<id> AtaPsiInteration){ 
            
            
            
            List<Exam_Attempt__c> lstUpdateEAs = new List<Exam_Attempt__c>();
            
            List < Exam_Attempt__c > lstExamAttempts = [select id, Section__c,Opportunity_StageName__c,Opportunity__c,Cancelled__c , ATA_subject_code__c, ATA_subject_name__c, ATA_region_code__c,ATA_region_name__c , Exam_Part__r.Delivery_Method__c, Member__c, Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c from Exam_Attempt__c where  Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true and Cancelled__c = false and Opportunity_StageName__c ='closed' and Opportunity__c in :AtaPsiInteration and Exam_Part__r.Delivery_Method__c!='Pen and Paper'];
            
            for (Exam_Attempt__c updEA: lstExamAttempts) {
                if(updEA.ATA_region_name__c  !=null && updEA.ATA_region_code__c != null){
                    updEA.Outbound_Type__c ='ATA';
                    updEA.Integration_Type__c ='Import Registration New';
                    lstUpdateEAs.add(updEA);
                }
                
                if(updEA.ATA_region_name__c ==null && updEA.ATA_region_code__c ==null){
                    updEA.Outbound_Type__c ='PSI';
                    updEA.Integration_Type__c ='Eligibility Lifecycle';
                    lstUpdateEAs.add(updEA);
                }  
            }
            if(lstUpdateEAs.size()>0){
                system.debug(lstUpdateEAs.size());
                update lstUpdateEAs;
            } 
        }
        
    }