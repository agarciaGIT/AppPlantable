public class FBRICBRUtils
{
    public static decimal dTotalPrice = 0;
    public class productList {
        public String GLCode { get; set; }
        public String price { get; set; }
    }
    public static List<wrapperUtils.wrapperProductDetails> getProductCodes(){
        try {
            User objUser = Utilities.getCurrentUserDetails();
            if(objUser.Contactid == null) return null;
            Contact objCont = [select id,accountid, KPI_Membership_Payment_Status__c, KPI_FRM_Certified__c, KPI_ERP_Certified__c from contact where id =: objUser.Contactid];
            if(objCont == null) return null;
            id memrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','Membership');
            id icbrrrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
            id fbrrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
            id fbrarecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FBRA Program');
            id scrrecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','SCR Program');
            
            
            List<PriceBookEntry> lstProceBooks = null;
            List<Contract> lstContracts = [
                SELECT Id, Membership_Type__c, AccountId,Eligible_For_Scr_Discount__c,Eligible_For_Scr_Discount_Date__c, Status, EndDate, RecordTypeId 
                FROM Contract 
                WHERE AccountId = :objCont.accountid AND 
                (
                    RecordTypeId = :memrecordTypeId OR 
                    RecordTypeId = :icbrrrecordTypeId OR 
                    RecordtypeId = :fbrrecordTypeId OR 
                    RecordtypeId = :fbrarecordTypeId OR
                    RecordtypeId = :scrrecordTypeId
                )
            ];
            boolean bICBRActiveContract = false;
            boolean bSCRActiveContract = false;
            Id icbrContractID = null;
            Id scrContractID = null;
            system.debug('lstContracts == '+lstContracts);
            Contract objMemberContract;
            Contract objICBRContract;
            
            boolean bIcbrrCompleted = false;
            boolean bscrCompleted = false;
            boolean bFbrCompleted = false;
            boolean bFbraCompleted = false;
            boolean bscrDiscount = false;
            for(Contract objCon : lstContracts)
            {
                if(objCon.recordtypeId == icbrrrecordTypeId && objCon.Status =='Completed')
                    bIcbrrCompleted = true;
                if(objCon.recordtypeId == fbrrecordTypeId && objCon.Status =='Completed')
                    bFbrCompleted = true;
                if(objCon.recordtypeId == fbrarecordTypeId && objCon.Status =='Completed')
                    bFbraCompleted = true;
                if(objCon.recordtypeId == scrrecordTypeId && objCon.Status =='Completed')
                    bscrCompleted = true;
                if(objCon.recordtypeId == icbrrrecordTypeId && (objCon.Status == 'Activated' || objCon.Status =='Activated ( Auto-Renew )'))
                {
                    bICBRActiveContract = true;
                    icbrContractID = objCon.Id;
                    objICBRContract = objCon;
                }

                if(objCon.recordtypeId == scrrecordTypeId && (objCon.Status == 'Activated'))
                {
                    bSCRActiveContract = true;
  
                }
                
                 if(objCon.recordtypeId == scrrecordTypeId && objCon.Status == 'Expired' && objCon.Eligible_For_Scr_Discount__c == true && objCon.Eligible_For_Scr_Discount_Date__c!=null && objCon.Eligible_For_Scr_Discount_Date__c<=system.today())
                {
                    bscrDiscount = true;
                    scrContractID = objCon.Id;
                    
                }

                if(objCon.recordtypeId == memrecordTypeId && (objCon.Status == 'Activated'|| objCon.Status =='Activated ( Auto-Renew )'))
                {
                    objMemberContract = objCon;
                }
                
            }
            system.debug('bICBRActiveContract == '+bICBRActiveContract);
            List<Exam_Attempt__c> lstExamAttempts = null;
            List<Exam_Attempt__c> ScrlstExamAttempts = null;
            if(icbrContractID != null)
            {
                lstExamAttempts = [select id,Icbrr_Exam_Date__c,Result__c,Candidate_Commitment__c from Exam_Attempt__c where Candidate_Commitment__c =: icbrContractID and Cancelled__C = false and Opportunity_StageName__c ='closed' order by Icbrr_Exam_Date__c DESC];
            }
            

            if(scrContractID != null)
            {
                ScrlstExamAttempts = [select id,Icbrr_Exam_Date__c,Result__c,Candidate_Commitment__c from Exam_Attempt__c where Candidate_Commitment__c =: scrContractID and Cancelled__C = false and Opportunity_StageName__c ='closed' order by Icbrr_Exam_Date__c DESC];
            }
            
            system.debug('lstExamAttempts == '+lstExamAttempts);
            System.debug('scrContractID == '+scrContractID);
            Set<String> setProductCodes = new Set<String>{'MEMC','MEMI','FCBR','FBRNM','CBR','CBRNM','CBR2A','FBRA','SCRM','SCR2A','SCRNM','SCRCM'};
                //if(objContract.Membership_Type__c == 'Individual') 
                
                lstProceBooks = [select unitprice,productcode,product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode in: setProductCodes and IsActive =: true];
            system.debug('lstProceBooks == '+lstProceBooks);
            if(lstProceBooks == null) return null;
            boolean bIsIndividualMember = objMemberContract != null && objMemberContract.Membership_Type__c == 'Individual';
            wrapperUtils.wrapperProductDetails wrapObject;
            List<wrapperUtils.wrapperProductDetails> lstWrapper = new List<wrapperUtils.wrapperProductDetails>();
            boolean bAddIndividualMemberPrice = false;
            
            system.debug('objMemberContract == '+objMemberContract);
            system.debug('bIsIndividualMember == '+bIsIndividualMember);
            
            Exam_Attempt__c objICBRREA = (lstExamAttempts == null || lstExamAttempts.size() <= 0 ? null :lstExamAttempts[0]);
            system.debug('objICBRREA == '+objICBRREA);
            
            Exam_Attempt__c objSCREA = (ScrlstExamAttempts == null || ScrlstExamAttempts.size() <= 0 ? null :ScrlstExamAttempts[0]);
            system.debug('objSCREA == '+objSCREA);
            
            for(PriceBookEntry obj :lstProceBooks)
            {
                wrapObject = new wrapperUtils.wrapperProductDetails();
                system.debug('obj == '+obj);
                system.debug('bFbrCompleted == '+bFbrCompleted);
                system.debug('bIcbrrCompleted == '+bIcbrrCompleted);
                
                if(obj.productcode == 'MEMI') {
                    
                    if(!bIsIndividualMember && objCont.KPI_FRM_Certified__c == false && objCont.KPI_ERP_Certified__c == false) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                    }
                    
                } else if(obj.productcode == 'MEMC') {
                    
                    if(!bIsIndividualMember && (objCont.KPI_FRM_Certified__c == true || objCont.KPI_ERP_Certified__c == true)) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                    }
                    
                } else if(obj.productcode == 'FCBR') {
                    
                    if(!bFbrCompleted) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                    }
                } 
                else if(obj.productcode == 'FBRA') {
                    
                    if(!bFbraCompleted ) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;  
                        bAddIndividualMemberPrice = true;            
                    }        
                }
                
                else if(obj.productcode == 'FBRNM') {
                    
                    if(!bFbrCompleted && !bIsIndividualMember) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;  
                        bAddIndividualMemberPrice = true;            
                    }        
                } else if(obj.productcode == 'CBR') {
                    if(!bIcbrrCompleted && !bICBRActiveContract) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                    }
                } else if(obj.productcode == 'CBRNM') {
                    if(!bIcbrrCompleted && !bIsIndividualMember && !bICBRActiveContract) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                        bAddIndividualMemberPrice = true;    
                    }        
                } else if(obj.productcode == 'CBR2A') {
                    
                    Date dtCurrentDate = system.today();
                    Integer iDaysDifference = 0;
                    if(objICBRREA != null && objICBRREA.Icbrr_Exam_Date__c != null)
                        iDaysDifference = objICBRREA.Icbrr_Exam_Date__c.daysBetween(dtCurrentDate);
                    system.debug('iDaysDifference == '+iDaysDifference);
                    
                    if(bICBRActiveContract && objICBRREA != null && objICBRREA.Result__c != 'Pass' && iDaysDifference >= 30) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                    }
                }

                else if(obj.productcode == 'SCRM') {
                    if(!bscrCompleted && !bSCRActiveContract &&bIsIndividualMember ) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                        bAddIndividualMemberPrice = true;    
                    }        
                }

                else if(obj.productcode == 'SCRNM') {
                    if(!bscrCompleted && !bIsIndividualMember && !bSCRActiveContract ) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                        bAddIndividualMemberPrice = true;    
                    }        
                }

                else if(obj.productcode == 'SCRCM') {
                    if(!bscrCompleted  && !bICBRActiveContract &&(objCont.KPI_FRM_Certified__c == true || objCont.KPI_ERP_Certified__c == true)) {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                        bAddIndividualMemberPrice = true;    
                    }        
                }
               
               else if(obj.productcode == 'SCR2A') {
                    if(!bscrCompleted && bscrDiscount&& !bSCRActiveContract && objSCREA != null && objSCREA.result__C =='Fail') {
                        wrapObject.strProductCode = obj.productcode;
                        wrapObject.dPrice = obj.unitprice;
                        wrapObject.strGlCode = obj.product2.Gl_Code__c;          
                        bAddIndividualMemberPrice = true;    
                    }        
                }



                if(wrapObject.strProductCode != null && wrapObject.dPrice != null) {
                    lstWrapper.add(wrapObject);                
                }
            }
            system.debug('lstWrapper == '+lstWrapper);
            return lstWrapper;
        }catch(exception ex){
            throw ex;
        }       
        
    }
    
    public static Registration.wrapperCreateOrder generateOrders(Map<String,string[]> mapProdDetails, TempAccount objData){
        Registration.wrapperCreateOrder returnWrapper = new Registration.wrapperCreateOrder();
        Decimal dTotalAmount = 0;
        
        system.debug('mapProdDetails == '+mapProdDetails);
        User objUser = Utilities.getCurrentUserDetails();
        if(objUser.Contactid == null) return null;
        
        if(objData.sessionToken != NULL) {
            try {
                Utilities.updateFormSession(objData.sessionToken, objData.Email);
                Utilities.runCaptcha(objData.sessionToken);
            }catch(exception ex){
                return null;
            } 
        } 
        
        Contact objContact = [select id,Name,GARP_Member_ID__c ,Accountid,MailingCity,MailingCountry,MailingPostalCode,MailingState,MailingStreet from contact where id =: objUSer.contactId];
        
        Utilities.migrateLeadFormDataToContact(null, objContact.Id, objData.formName, null);
        
        Opportunity oppRecord;
        if(objData.promoCode != null) {
            Registration.verifyBulkOrderReturnData vbord = Registration.verifyBulkOrder(objData);
            if(vbord.errorMSg != null) {
                returnWrapper.errorMsg = vbord.errorMSg;
                return returnWrapper;
            }
            oppRecord = CreateOpportunity(mapProdDetails, objContact, objData, vbord);
        } else {
            oppRecord = CreateOpportunity(mapProdDetails, objContact, objData, null);    
        }
        
        system.debug('oppRecord:' + oppRecord);
        system.debug('mapProdDetails:' + mapProdDetails);
        
        Set<String> productCodes = new Set<String>();
        Set<String> glCodes = new Set<String>();
        for(String key :mapProdDetails.keySet()) {
            String[] arrText = key.split(':');
            if(arrText.size() > 1) {
                productCodes.add(arrText[0]);
                glCodes.add(arrText[1]);
            }
        }
        System.debug('productCodes:' + productCodes); 
        System.debug('glCodes:' + glCodes);         
        
        // Select Product Offer Rates
        MAP<String,Product_Rate_Offering__c> mapRates = new MAP<String,Product_Rate_Offering__c>();
        MAP<String,Product_Rate_Offering__c> mapDiscountRates = new MAP<String,Product_Rate_Offering__c>();
        LIST<Product_Rate_Offering__c> lstRates = [select id, Customer_Email__c, Offer_Amount__c, Current_Product__r.ProductCode, Current_Product__r.GL_Code__c, 
                                                   Contact__c, Attestation_Required__c,
                                                   Discount_Product__r.ProductCode, Discount_Product__r.GL_Code__c from Product_Rate_Offering__c WHERE
                                                   Current_Product__r.ProductCode in :productCodes AND 
                                                   Current_Product__r.GL_Code__c in :glCodes AND 
                                                   Customer_Email__c = :objData.email AND Status__c = 'Active'];
        if(lstRates != NULL && lstRates.size() > 0) {
            for(Product_Rate_Offering__c por :lstRates) {
                if(por.Discount_Product__r != NULL) {
                    mapDiscountRates.put(por.Discount_Product__r.ProductCode + ':' + por.Discount_Product__r.Gl_Code__c, por);  
                    string[] arrayGLPrice = new string[3];
                    mapProdDetails.put(por.Discount_Product__r.ProductCode + ':' + por.Discount_Product__r.Gl_Code__c,arrayGLPrice);
                }
                mapRates.put(por.Current_Product__r.ProductCode + ':' + por.Current_Product__r.Gl_Code__c, por);    
            }
        }     
        System.debug('mapRates:' + mapRates);
        System.debug('mapDiscountRates:' + mapDiscountRates);
        
        dTotalAmount = createOppLineItems(oppRecord.Id,mapProdDetails, mapRates, mapDiscountRates, objContact.Id, objData);
        
        //Id paymentId = createPaymentDetails(oppRecord.Id,objContact.Id,oppRecord.AccountId);
        createExamAttempts(mapProdDetails,objContact.Id,oppRecord.AccountId,oppRecord.Id,true);
        
        returnWrapper.garpId = objContact.GARP_Member_ID__c;
        returnWrapper.totalCost = dTotalAmount;
        returnWrapper.contactId = objContact.Id;
        returnWrapper.opportunityId =oppRecord.Id ; 
        
        return returnWrapper;
    }
    
    public static Opportunity CreateOpportunity(Map<String,String[]> mapProdDetails, Contact objContact, TempAccount objData, Registration.verifyBulkOrderReturnData vbord){
        
        Id oppRecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated');
        Opportunity opp = new Opportunity();
        try{
            opp.Name = 'Course Registration';
            opp.Accountid = objContact.AccountId;
            opp.StageName = 'New Lead';
            opp.CloseDate = system.today();
            opp.ChargentSFA__Payment_Method__c = 'Credit Card';
            opp.RecordTypeId = oppRecordTypeId;
            //  opp.Eligible_for_Membership_Extension__c = (mapProdDetails.containsKey('MEMI'));
            opp.Eligible_for_Membership_Extension__c = true;
            opp.Shipping_First_Name__c = objData.FirstName;
            opp.Shipping_Last_Name__c = objData.LastName;
            opp.Shipping_Phone_No__c = objData.HomePhone;
            opp.Shipping_E_mail__c = objData.Email;
            
            opp.Shipping_Company_Name__c = objData.MailingCompany;
            opp.Shipping_Street__c = objData.MailingStreet;
            if(objData.MailingStreetTwo != null && objData.MailingStreetTwo.length() > 0)
                opp.Shipping_Street__c += '\n' + objData.MailingStreetTwo;
            if(objData.MailingStreetThree != null && objData.MailingStreetThree.length() > 0)
                opp.Shipping_Street__c += '\n' + objData.MailingStreetThree;
            
            opp.Shipping_City__c = objData.MailingCity;
            opp.Shipping_State__c = objData.MailingState;
            opp.Shipping_Country__c = objData.MailingCountry;
            opp.Shipping_Postal_Code__c = objData.MailingPostalCode;
            
            opp.ChargentSFA__Billing_Email__c = objData.Email;
            opp.ChargentSFA__Billing_First__c = objData.FirstName;
            opp.ChargentSFA__Billing_Last__c = objData.LastName;
            opp.ChargentSFA__Billing_Phone__c = objData.HomePhone;
            opp.ChargentSFA__Billing_Company__c = objData.BillingCompany;
            
            opp.ChargentSFA__Billing_Address__c = objData.BillingStreet;
            if(objData.BillingStreetTwo != null && objData.BillingStreetTwo.length() > 0)
                opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetTwo;
            if(objData.BillingStreetThree != null && objData.BillingStreetThree.length() > 0)
                opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetThree;
            
            opp.ChargentSFA__Billing_City__c = objData.BillingCity;
            opp.ChargentSFA__Billing_State__c = objData.BillingState;
            opp.ChargentSFA__Billing_Zip__c = objData.BillingPostalCode;
            opp.ChargentSFA__Billing_Country__c = objData.BillingCountry;
            
            opp.Alternate_Method_of_Payment__c = objData.paymentMethod;
            opp.Has_Books__c = objData.hasBooks;
            
            if(objData.icbrrLegacyRetry == true)
                opp.ICBRR_Legacy_Retry__c = true;
            
            if(vbord != NULL && vbord.bord.oppData != null && vbord.bord.oppData.size() > 0) {
                opp.Institutional_Sale__c = true;
                opp.Inst_Sale_Opp__c = vbord.bord.oppData[0].Id;
            }
            
            if(objData.teamCode != NULL) {
                Team_Registration__c teamReg;
                LIST<Team_Registration__c> lstTeamRates = [select id, Discounted_Price__c, Attestation_Required__c, Attestation_Copy__c
                                                           from Team_Registration__c where Payment_Status__c = 'Paid' AND Access_Code__c = :objData.teamCode];
                System.debug('lstTeamRates:' + lstTeamRates);
                if(!lstTeamRates.isEmpty()) {
                	opp.Team_Registration__c = lstTeamRates[0].Id;    
                }
                
            }
            insert opp;
            return opp;
        }catch(exception ex){
            return null;
        }
        
        
    }
    
    public static decimal createOppLineItems(Id oppId,Map<String,String[]> mapProdDetails, MAP<String,Product_Rate_Offering__c> mapRates, MAP<String,Product_Rate_Offering__c> mapDiscountRates, String contactId, TempAccount objData){
        if(mapProdDetails == null) return null;
        Decimal dExamFee = 0;
        dTotalPrice = 0;
        String strNameByProdcutCode  = '';
        List<String> lstExamNames = new List<String>();
        List<OpportunityLineItem> lstOppLineItems = new List<OpportunityLineItem>();
        Boolean hasFRRBook = false;
        
        Set<String> productCodes = new Set<String>();
        Set<String> glCodes = new Set<String>();
        for(String key :mapProdDetails.keySet()) {
            String[] arrText = key.split(':');
            if(arrText.size() > 1) {
                productCodes.add(arrText[0]);
                glCodes.add(arrText[1]);
                
                if(arrText[0] == 'CBRHB') {
                    hasFRRBook = True;
                }
            }            
        }
        System.debug('productCodes:' + productCodes); 
        System.debug('glCodes:' + glCodes); 
        
		// Team Registrations
		Team_Registration__c teamRegUsed;
        String teamCode = objData.teamCode;
        Team_Registration__c teamReg;
        LIST<Team_Registration__c> lstTeamRates = [select id, Discounted_Price__c, Attestation_Required__c, Attestation_Copy__c
                                                     from Team_Registration__c where Payment_Status__c = 'Paid' AND Access_Code__c = :teamCode];
        System.debug('lstTeamRates:' + lstTeamRates);
        
        // Team Registration Custom Settings
        Map<String, Team_Registration_Products__c> mapCustTeamProds = Team_Registration_Products__c.getAll();
        Map<String, Team_Registration_Products__c> mapTeamProds = new Map<String, Team_Registration_Products__c>();            
        if(!lstTeamRates.isEmpty()) {
            teamReg = lstTeamRates[0];
            
            if(mapCustTeamProds != NULL) {
                for(Team_Registration_Products__c trp :mapCustTeamProds.values()) {
                    mapTeamProds.put(trp.Product_Code__c + '~' + trp.GL_Code__c, trp);
                }
            }
            System.debug('mapCustTeamProds:' + mapCustTeamProds);
            System.debug('mapTeamProds:' + mapTeamProds);            
                
        }        
        
        List<PriceBookEntry> lstPrice = [select unitprice,productcode,product2.Gl_Code__c from PriceBookEntry 
                                         where Pricebook2.IsActive = true AND
                                         ((productcode in :productCodes AND 
                                         product2.Gl_Code__c in :glCodes) OR
                                         ProductCode in ('SHIPFRM1','SHIPFRM2','SHIPSCR','SHIPFRR','SHIPFFR','CBRX','FFRXF'))
                                         AND
                                         isActive =: true];
        System.debug('lstPrice:' + lstPrice); 
        
        MAP<String,PriceBookEntry> mapPriceBook = new MAP<String,PriceBookEntry>();
        for(PriceBookEntry pbe :lstPrice) {
            mapPriceBook.put(pbe.ProductCode + ':' + pbe.Product2.Gl_Code__c,pbe);
        }
        System.debug('mapPriceBook:' + mapPriceBook);        
        
        for(PriceBookEntry PricebookEntryId :lstPrice) {
            
            System.debug('PricebookEntryId:' + PricebookEntryId);
            
            // Skip Discount Product
            Product_Rate_Offering__c fndDiscountRate = mapDiscountRates.get(PricebookEntryId.ProductCode + ':' + PricebookEntryId.Product2.Gl_Code__c);
            System.debug('fndDiscountRate:' + fndDiscountRate);
            if(fndDiscountRate != NULL) {
                continue;
            }        
            
            String[] fndProdDetails = mapProdDetails.get(PricebookEntryId.ProductCode + ':' + PricebookEntryId.Product2.Gl_Code__c);
            System.debug('fndProdDetails:' + fndProdDetails);
            if(fndProdDetails == NULL) {
                continue;
            }
            
            // AG 11/17/2022 - Add eBooks for FRR
            if(PricebookEntryId.ProductCode == 'CBR' || PricebookEntryId.ProductCode == 'CBRNM') {
                PriceBookEntry fndPrice = mapPriceBook.get('CBRX:4030');
                if(fndPrice != NULL) {
                    OpportunityLineItem oppLineItemEBook = new OpportunityLineItem();
                    oppLineItemEBook.OpportunityId = oppId;
                    oppLineItemEBook.PricebookEntryId = fndPrice.Id;
                    oppLineItemEBook.Quantity = 1; 
                    oppLineItemEBook.UnitPrice = 0;
                    System.debug('FRR oppLineItemEBook:' + oppLineItemEBook);
                    lstOppLineItems.add(oppLineItemEBook);
                }
            }
            

			if(PricebookEntryId.ProductCode == 'FCBR' || PricebookEntryId.ProductCode == 'FBRNM') {
                PriceBookEntry fndPrice = mapPriceBook.get('FFRXF:4030');
                if(fndPrice != NULL) {
                    OpportunityLineItem oppLineItemEBook = new OpportunityLineItem();
                    oppLineItemEBook.OpportunityId = oppId;
                    oppLineItemEBook.PricebookEntryId = fndPrice.Id;
                    oppLineItemEBook.Quantity = 1; 
                    oppLineItemEBook.UnitPrice = 0;
                    System.debug('FFR oppLineItemEBook:' + oppLineItemEBook);
                    lstOppLineItems.add(oppLineItemEBook);
                }
            }
            
            // AG 11/17/2022 - Sage Shipping
            if(PricebookEntryId.ProductCode == 'SHIP' && hasFRRBook) {
                PricebookEntryId = mapPriceBook.get('SHIPFFR:4999');
                if(PricebookEntryId == NULL) {
                    continue;
                }
            }
            
            dExamFee = 0;
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            String[] arrGlPrice = mapProdDetails.get(PricebookEntryId.productcode + ':' + PricebookEntryId.Product2.Gl_Code__c);
            system.debug('PricebookEntryId == '+PricebookEntryId);
            system.debug('arrGlPrice == '+arrGlPrice);
            if(PricebookEntryId.productcode == 'SHIPFFR' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);
            else if(PricebookEntryId.productcode == 'SLSTX' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);
            else if(PricebookEntryId.productcode == 'MISC' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);
            else if(PricebookEntryId.productcode == 'CBRHB' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);                
            else if(PricebookEntryId.productcode == 'FBRHB' && PricebookEntryId.product2.Gl_Code__c == arrGlPrice[0])
                oppLineItem.UnitPrice = decimal.valueOf(arrGlPrice[1]);                
            else
                oppLineItem.UnitPrice = PricebookEntryId.unitprice;
            
            oppLineItem.OpportunityId = oppId;
            if(arrGlPrice.size() > 1 && arrGlPrice[2] != null)
                oppLineItem.Description = arrGlPrice[2];
            oppLineItem.PricebookEntryId = PricebookEntryId.Id;
            oppLineItem.Quantity = 1;
            system.debug('3 dExamFee == '+dExamFee);
            
            // Set Rate Offer
            Product_Rate_Offering__c fndRate = mapRates.get(PricebookEntryId.ProductCode + ':' + PricebookEntryId.Product2.Gl_Code__c);
            System.debug('fndRate:' + fndRate);          
            
            if(fndRate != NULL) {
                
                PriceBookEntry fndPrice = mapPriceBook.get(fndRate.Discount_Product__r.productcode + ':' + fndRate.Discount_Product__r.GL_Code__c);
                System.debug('fndPrice:' + fndPrice);
                
                if(fndRate.Discount_Product__r != NULL && fndPrice != NULL) {        
                    OpportunityLineItem oppLineItemRate = new OpportunityLineItem();
                    oppLineItemRate.OpportunityId = oppId;
                    oppLineItemRate.PricebookEntryId = fndPrice.Id;
                    oppLineItemRate.Quantity = 1;                    
                    oppLineItemRate.UnitPrice = (oppLineItem.UnitPrice - fndRate.Offer_Amount__c) * -1;
                    lstOppLineItems.add(oppLineItemRate);                    
                }
            }
            
            // Team Registration discount 
            System.debug('teamReg:' + teamReg); 
            
            if(teamReg != NULL) {                
                System.debug('PricebookEntryId.ProductCode:' + PricebookEntryId.ProductCode); 
                System.debug('PricebookEntryId.Product2.Gl_Code__c:' + PricebookEntryId.Product2.Gl_Code__c); 
                
                Team_Registration_Products__c findTrp = mapTeamProds.get(PricebookEntryId.ProductCode + '~' + PricebookEntryId.Product2.Gl_Code__c);
                System.debug('findTrp:' + findTrp); 
                
                if(findTrp != NULL) {                
                    teamRegUsed = teamReg;
                    
                    if(teamReg.Discounted_Price__c != NULL) {
                        // Add Discount Product
                        OpportunityLineItem oppLineItemRate = new OpportunityLineItem();
                        oppLineItemRate.OpportunityId = oppId;
                        oppLineItemRate.Product2Id = findTrp.Discount_Product_Id__c;
                        oppLineItemRate.PricebookEntryId = findTrp.Discount_Product_Price_Id__c;
                        oppLineItemRate.Quantity = 1; 
                        oppLineItemRate.UnitPrice = (PricebookEntryId.UnitPrice - teamReg.Discounted_Price__c) * -1;
                        dTotalPrice += oppLineItemRate.UnitPrice;
                        
                        System.debug('oppLineItemRate:' + oppLineItemRate);
                        lstOppLineItems.add(oppLineItemRate);
                    }
                }
            }
            
            
            dTotalPrice += oppLineItem.UnitPrice;
            system.debug('&&&&:'+dTotalPrice);
            lstOppLineItems.add(oppLineItem);
            
        }    
        system.debug('lstOppLineItems == '+lstOppLineItems);            
        insert lstOppLineItems;
        
        return dTotalPrice;
    }   
    
    
    
    public static Contract checkContractExist(Map<String,String[]> mapProdDetails,Id accounID){
        ID recTypeID = null;
        if(mapProdDetails.containsKey('CBR:4000') || mapProdDetails.containsKey('CBRNM:4000') || mapProdDetails.containsKey('CBR2A:4000'))
            recTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
        try{
            system.debug('accounID == '+accounID);
            system.debug('recTypeID == '+recTypeID);
            Contract obj = [select id,recordtypeID,enddate from Contract where recordTypeID =: recTypeID and accountID =: accounID and (Status =:'Activated' or Status =: 'Activated ( Auto-Renew )') limit 1];
            return obj;
        }catch(exception ex){
            return null;
        }
        
        
    }
    
    public static void createExamAttempts(Map<String,String[]> mapProdDetails,Id contID,Id accID,Id oppId,boolean bCreateContratcs){
        List<Candidate_Requirement__c> lstCandReqs;
        Contract objContract;
        Id contractID;
        boolean bISIcBRR = (mapProdDetails.containsKey('CBR:4000') || mapProdDetails.containsKey('CBRNM:4000') || mapProdDetails.containsKey('CBR2A:4000'));
        if(bISIcBRR)
            objContract = checkContractExist(mapProdDetails,accID);
        system.debug('objCon==='+objContract);
        system.debug('bISIcBRR==='+bISIcBRR);
        contractID = objContract != null ? objContract.Id : null;
        if(!bISIcBRR || (objContract != null && objContract.EndDate < System.today()) || (bISIcBRR && objContract == null))
            contractID = CreateContract(accID,mapProdDetails,oppId);
        system.debug('Contract Id == '+contractId);
        lstCandReqs = createCandidateRequirements(contractID,mapProdDetails,oppId);
        
        system.debug('lstCandReqs == '+lstCandReqs);
        
        if(lstCandReqs == null)
        {
            lstCandReqs = [select id,name from Candidate_Requirement__c where Candidate_Commitment__c =: contractID];
        }
        
        list<Exam_Sites__c> lstExamSites = new List<Exam_Sites__c>();
        
        try
        {
            
            updateids__c recIds = updateids__c.getInstance('ICBRR');
            string str = recIds.Record_id__c;
            lstExamSites = [Select id,Name,Exam__r.Exam__c from Exam_Sites__c where id =: str];
            
        }
        catch(exception ex)
        {
            lstExamSites = null;
        }
        if(bISIcBRR)
            registerExam(lstExamSites,contID,lstCandReqs,contractID,oppId);
        
    }
    
    public static ID CreateContract(ID accID,Map<String,String[]> mapProdDetails,ID oppId){
        
        Contract objContract = new Contract();
        objContract.accountId = accID;
        objContract.Opportunity__c = oppId;
        objContract.StartDate = system.today();
        id contID;
        system.debug('CreateContract == '+mapProdDetails);
        opportunity opp =[select id , ChargentSFA__Billing_Address__c, Shipping_Postal_Code__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Country__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c, ChargentSFA__Billing_Email__c, ChargentSFA__Billing_Phone__c from opportunity where id=:oppId];
      if(!test.isRunningTest()){
       contID =[select id,accountid from contact where accountid=:accID ].id;
       }
        if(mapProdDetails.containsKey('FCBR:4000') || mapProdDetails.containsKey('FBRNM:4000'))
        {
            objContract.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FBR Program');
            objContract.ContractTerm  = 6;
        }
        else if(mapProdDetails.containsKey('CBR:4000') || mapProdDetails.containsKey('CBRNM:4000') || mapProdDetails.containsKey('CBR2A:4000'))
        {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','ICBRR Program');
            objContract.ContractTerm  = 9;
            objContract.Pearson_Member_First_Name__c = opp.ChargentSFA__Billing_First__c;
           objContract.Pearson_Member_Last_Name__c = opp.ChargentSFA__Billing_Last__c;
           objContract.Member_Email__c = opp.ChargentSFA__Billing_Email__c;
          if(!test.isRunningTest()){
          objContract.CustomerSignedId =contID;
          }
           objContract.BillingStreet =opp.ChargentSFA__Billing_Address__c;
          objContract.Billingpostalcode =opp.Shipping_Postal_Code__c;
          objContract.Billingcountry = opp.ChargentSFA__Billing_Country__c;
          objContract.BillingState = opp.ChargentSFA__Billing_State__c;
          objContract.BillingCity = opp.ChargentSFA__Billing_City__c;
          objContract.Pearson_Phone_No__c = opp.ChargentSFA__Billing_Phone__c;
        }
        
      
        
        else if(mapProdDetails.containsKey('FBRA:4000') )
        {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract','FBRA Program');
            objContract.ContractTerm  = 6;
        }
        insert objContract;  
        system.debug('objContract == '+objContract);        
        return objContract.Id;
        
    }
    
    public static List<Candidate_Requirement__c> createCandidateRequirements(Id contractID,Map<String,String[]> mapProdDetails,id oppId){
        
        //id oppID = [SELECT Opportunity__c FROM contract WHERE id = :contractID LIMIT 1].Opportunity__c ;
        string email = [SELECT Shipping_E_mail__c FROM opportunity WHERE id = :oppID LIMIT 1].Shipping_E_mail__c ;
        List<Candidate_Requirement__c> lstCandReq = new List<Candidate_Requirement__c>();
        Candidate_Requirement__c objCandReq;
        
        Integer iCount = 1;
        for(Integer i = 0; i <iCount; i++)
        {
            objCandReq = new Candidate_Requirement__c();  
            objCandReq.Candidate_Commitment__c = contractID;
            objCandReq.Candidate_Email__c = email ;
            if(mapProdDetails.containsKey('FCBR:4000') || mapProdDetails.containsKey('FBRNM:4000'))
                objCandReq.Name = 'Pass FBR';
            else if(mapProdDetails.containsKey('CBR:4000') || mapProdDetails.containsKey('CBRNM:4000'))
                objCandReq.Name = 'Pass ICBRR';
            else if(mapProdDetails.containsKey('FBRA:4000') )
                objCandReq.Name = 'Pass FBRA';
            lstCandReq.add(objCandReq);
            
        }
        
        if(lstCandReq.size() > 0)
            insert lstCandReq;    
        
        return lstCandReq;
    }
    
    public static void registerExam(List<Exam_Sites__c> lstExamSites,Id contID,List<Candidate_Requirement__c> lstCandReqs,id ContractID,Id oppId){
        Exam_Attempt__c objAttempt = null;
        Map<String,Id> mapCandIds = new Map<String,Id>();
        
        for(Candidate_Requirement__c obj: lstCandReqs)
        {
            mapCandIds.put(obj.Name,obj.Id);
        }
        List<Exam_Attempt__c> lstExamApptempts = new List<Exam_Attempt__c>();
        system.debug('mapCandIds == '+mapCandIds);
        for(Exam_Sites__c objExamSite : lstExamSites)
        {
            objAttempt = new Exam_Attempt__c();
            objAttempt.Exam_Site__c = objExamSite.Id;
            objAttempt.Member__c = contID;
            String strExamName = '';
            objAttempt.Candidate_Commitment__c = ContractID;
            objAttempt.Opportunity__c = oppId;
            objAttempt.Candidate_Requirement__c = mapCandIds.get('Pass ICBRR');
            lstExamApptempts.add(objAttempt);
        }
        system.debug('objAttempt == '+objAttempt);
        if(lstExamApptempts.size() > 0)
            insert lstExamApptempts;
        
    }
    
    
    
}