public without sharing class Registration{ 
    public static boolean bFRMActivatedXX = false;
    public static boolean bERPActivatedXX = false;
    static Decimal dTotalPrice = 0;
    static Id siteID = null; 
    static boolean bCreateMemContracts = true;
    static id userid = [select id, name, Record_id__c from updateids__c where name = 'User'].Record_id__c;
    static decimal dStandardAmount = 0;
    static boolean bHasFrmEnrollment = false;
    static boolean bHasErpEnrollment = false;
    static boolean bFRMPaidFor2009 = false;
    static boolean bERPPaidFor2009 = false;
    static boolean bHasErpcompleted = false;
    static boolean bHasFrmcompleted = false;
    public class wrapperSetLead {
        public TempAccount tempAccount {
            get;
            set;
        }
        public Id leadId {
            get;
            set;
        }
    }
    
    public class wrapperCheckExistingMember {
        public TempAccount tempAccount {
            get;
            set;
        }
        public Id contactId {
            get;
            set;
        }
    }
    
    
    public class wrapperCreateOrder {
        public Id contactId {
            get;
            set;
        }
        public Id opportunityId {
            get;
            set;
        }
        
        public String garpId {
            get;
            set;
        }
        
        public Decimal totalCost {
            get;
            set;
        }
        
        public String invoiceNumber {
            get;
            set;
        }
        
        public String company {
            get;
            set;
        }
        
        public Decimal shipping {
            get;
            set;
        }
        
        public Decimal tax {
            get;
            set;
        }
        
        public String productDetails {
            get;
            set;
        }
        
        public ChargentSFA__Payment_Request__c payRequest {
            get;
            set;            
        }
        
        public String errorMsg {
            get;
            set;
        }
        
        public List<OpportunityLineItem> opportunityLineItems { get; set; }
        public List<Product_Refunds__c> productRefunds { get; set; }        
    }
    
    public class wrapperCreateChapterMeetingRegistration {
        
        public String chapterMeetingRegistrationId {
            get;
            set;
        } 
        
        public wrapperCreateOrder wrapperCreateOrderData {
            get;
            set;
        }        
    }
    
    public class wrapperCreateWebcastRegistration {
        public Id contactId {
            get;
            set;
        }
        
        public String webcastRegistrationId {
            get;
            set;
        } 
    }
        
    public class purchaseCodeData {
        public Id priceBookEntryId { get; set; }
        public String prodCode { get; set; }
        public String glCode { get; set; }
        public String price { get; set; }
        public String description { get; set; }
        public Integer months { get; set; }
        public Integer quantity { get; set; }
    }
    
    public class bulkOrderReturnData {
        public List<Opportunity> oppData { get; set; }
        public List<ChargentSFA__Transaction__c> transData { get; set; }
        public Map<string,Integer > oppCountMap { get; set; }
        public purchaseCodeData bulkOrderExam1Product { get; set; }
        public purchaseCodeData bulkOrderExam2Product { get; set; }
        public purchaseCodeData bulkOrderExamEnrollment { get; set; }
    }        
    
    public class verifyBulkOrderReturnData {
        public bulkOrderReturnData bord { get; set; }
        public String errorMsg { get; set; }
    }        
    
    public class wrapperGetContact {
        public contact contactReturnData {
            get;
            set;
        }
        public TempAccount tempAccount {
            get;
            set;
        }
    }
    
    public class wrapperProductInfo {
        public string strProductCode {
            get;
            set;
        }
        public string strProductName {
            get;
            set;
        }
        public string strGLCode {
            get;
            set;
        }
        public string strDisplayName {
            get;
            set;
        }
        public boolean bFRMActivated {
            get;
            set;
        }
        public boolean bERPActivated {
            get;
            set;
        }
        public boolean bFRM1Deffered {
            get;
            set;
        }
        public boolean bFRM2Deffered {
            get;
            set;
        }
        public boolean bERPDeffered {
            get;
            set;
        }
        public boolean bERP1Deffered {
            get;
            set;
        }
        public boolean bERP2Deffered {
            get;
            set;
        }
        public boolean bFRM1UnDeffered {
            get;
            set;
        }
        public boolean bFRM2UnDeffered {
            get;
            set;
        }
        public boolean bERPUnDeffered {
            get;
            set;
        }
        public boolean bFRMSwitch {
            get;
            set;
        }
        public boolean bERPSwitch {
            get;
            set;
        }
        public String strFRMOneBookProdCode {
            get;
            set;
        }
        public String strFRMOneBookGLCode {
            get;
            set;
        }
        public decimal dFRMOneBookAmount {
            get;
            set;
        }
        public String strERPOneBookProdCode {
            get;
            set;
        }
        public String strERPOneBookGLCode {
            get;
            set;
        }
        public decimal dERPOneBookAmount {
            get;
            set;
        }
        public String strFRMTwoBookProdCode {
            get;
            set;
        }
        public String strFRMTwoBookGLCode {
            get;
            set;
        }
        public decimal dFRMTwoBookAmount {
            get;
            set;
        }
        public String strERPTwoBookProdCode {
            get;
            set;
        }
        public String strERPTwoBookGLCode {
            get;
            set;
        }
        
        public decimal dERPTwoBookAmount {
            get;
            set;
        }
        public String strFRMOneEnrollmentProdCode {
            get;
            set;
        }
        public String strFRMOneEnrollmentGLCode {
            get;
            set;
        }
        public decimal dFRMOneEnrollmentAmount {
            get;
            set;
        }
        public decimal examPrice {
            get;
            set;
        }
        public String strERPBookProdCode {
            get;
            set;
        }
        public String strERPBookGLCode {
            get;
            set;
        }
        public decimal dERPBookAmount {
            get;
            set;
        }
        public String strERPOneEnrollmentProdCode {
            get;
            set;
        }
        public String strERPOneEnrollmentGLCode {
            get;
            set;
        }
        public decimal dERPEnrollmentAmount {
            get;
            set;
        }
        public string strFCBRMemberProdCode {
            get;
            set;
        }
        public string strFCBRAMemberProdCode {
            get;
            set;
        }
        public string strFCBRNonMemberProdCode {
            get;
            set;
        }
        public string strFCBRANonMemberProdCode {
            get;
            set;
        }
        public string strFCBRMemberGlCode {
            get;
            set;
        }
        public string strFCBRAMemberGlCode {
            get;
            set;
        }
        public string strFCBRNonMemberGlCode {
            get;
            set;
        }
        public string strFCBRANonMemberGlCode {
            get;
            set;
        }
        public decimal dFCBRMemberExamAmt {
            get;
            set;
        }
        public decimal dFCBRAMemberExamAmt {
            get;
            set;
        }
        public decimal dFCBRNonMemberExamAmt {
            get;
            set;
        }
        public decimal dFCBRANonMemberExamAmt {
            get;
            set;
        }
        public string strCBRMemberProdCode {
            get;
            set;
        }
        public string strCBRNonMemberProdCode {
            get;
            set;
        }
        public string strCBRMemberGlCode {
            get;
            set;
        }
        public string strCBRNonMemberGlCode {
            get;
            set;
        }
        public decimal dCBRMemberExamAmt {
            get;
            set;
        }
        public decimal dCBRNonMemberExamAmt {
            get;
            set;
        }
        public decimal dCBRCorpNonMemberExamAmt { get; set; }
        public string strCBRCorpNonMemberProdCode { get; set; }
        public string strCBRCorpNonMemberGlCode { get; set; }
        public string strCBRCorpNonMemberAttestaionCopy { get; set; }

        public decimal dCBRCorpMemberExamAmt { get; set; }
        public string strCBRCorpMemberProdCode { get; set; }
        public string strCBRCorpMemberGlCode { get; set; }
        public string strCBRCorpMemberAttestaionCopy { get; set; }
        public Boolean strCBRCorpPrepay { get; set; }
        
        public string strMemberProdCode {
            get;
            set;
        }
        public string strMemberGLCode {
            get;
            set;
        }
        public decimal dMemberAmt {
            get;
            set;
        }
        public string strWileyProdCode {
            get;
            set;
        }
        public string strWileyGLCode {
            get;
            set;
        }
        public string strRiskNetProdCode {
            get;
            set;
        }
        public string strRiskNetGLCode {
            get;
            set;
        }
        public string strIndividualProdCode {
            get;
            set;
        }
        public string strIndividualGLCode {
            get;
            set;
        }
        
        public string strAffiliateGLCode {
            get;
            set;
        }
        public string strAffiliateProdCode {
            get;
            set;
        }
        public string strTaxGLCode {
            get;
            set;
        }
        public string strTaxProdCode {
            get;
            set;
        }
        public string strCanadianTaxGLCode {
            get;
            set;
        }
        public string strCanadianTaxProdCode {
            get;
            set;
        }
        public string strShippingGLCode {
            get;
            set;
        }
        public string strShippingProdCode {
            get;
            set;
        }
        public string strFreeIndividualProdCode {
            get;
            set;
        }
        public string strFreeIndividualGLCode {
            get;
            set;
        }
        public string strDeferredPaymentGLCode {
            get;
            set;
        }
        public string strDeferrePaymentProdCode {
            get;
            set;
        }
        public boolean returning {
            get;
            set;
        }
    }
        
    public static bulkOrderReturnData getBulkOrders(String institutionalSaleCode) {
        
        BulkOrderReturnData bord = new BulkOrderReturnData();
        
        bord.oppData = new List<Opportunity>();
        bord.oppCountMap = new Map<String, Integer>();
        
        List<Opportunity> masterOrders = [
            SELECT Account.Name, Id, Name, RecordTypeID, Institutional_Sale__c, Institutional_Sale_Stage__c, Inst_Sale_Code__c, Inst_Sale_Service_End_Date__c, Inst_Sale_Emails__c, Inst_Sale_Opp__c, Inst_Sale_Verification_Type__c, Inst_Sale_Email_Domain_Verification__c, StageName, 
            (
                SELECT Account.Name, Id, StageName, Inst_Sale_Opp__c 
                FROM Institutional_Sale_Opportunities__r 
                WHERE Institutional_Sale__c = True AND RecordType.Name = 'Automated'    
            ),
            (
                SELECT Id, Description, PricebookEntryId, Quantity, UnitPrice, SortOrder, TotalPrice, PricebookEntry.Id, PricebookEntry.Product2.ProductCode, PricebookEntry.Product2.GL_Code__c 
                FROM OpportunityLineItems
            ) 
            FROM Opportunity 
            WHERE 
            Inst_Sale_Code__c = :institutionalSaleCode AND 
            RecordType.Name = 'Manual'
            LIMIT 1
        ];
        
        if(masterOrders != null && !masterOrders.isEmpty()) {
            
            Opportunity masterOrder = masterOrders[0];
            
            if(
                masterOrder.Institutional_Sale__c == True && 
                masterOrder.Institutional_Sale_Stage__c == 'Approved' && 
                (
                    masterOrder.Inst_Sale_Service_End_Date__c == NULL || 
                    masterOrder.Inst_Sale_Service_End_Date__c >= System.Today()
                )
            ) {
                bord.oppData.add(masterOrder);
            }
            
            System.debug(masterOrder);
            System.debug(masterOrder.Institutional_Sale_Opportunities__r);
            
            bord.oppCountMap.put(masterOrder.Id, 0);
            
            if(masterOrder.Institutional_Sale_Opportunities__r != null && !masterOrder.Institutional_Sale_Opportunities__r.isEmpty()) {
                for(Opportunity childOrder :masterOrder.Institutional_Sale_Opportunities__r) {
                    if(childOrder.StageName != 'Closed Lost') {
                        
                        System.debug('MASTER ORDER: ' + masterOrder);
                        
                        Integer licenseCount = bord.oppCountMap.get(childOrder.Inst_Sale_Opp__c);
                        
                        System.debug('LICENSE COUNT: ' + licenseCount);
                        
                        if(licenseCount == null) {
                            bord.oppCountMap.put(childOrder.Inst_Sale_Opp__c, 1);
                        } else {
                            licenseCount++;
                            bord.oppCountMap.put(childOrder.Inst_Sale_Opp__c, licenseCount);
                        }
                        
                    }
                }
                
                List<ChargentSFA__Transaction__c> transactions = [
                    SELECT Id, Name, ChargentSFA__Amount__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Type__c, ChargentSFA__Response_Status__c, ChargentSFA__Payment_Method__c 
                    FROM ChargentSFA__Transaction__c 
                    WHERE ChargentSFA__Opportunity__c = :masterOrder.Id
                ];
                
                bord.transData = transactions;
            } 
            
        }
        
        return bord;
        
    }
    
    public static verifyBulkOrderReturnData verifyBulkOrder(TempAccount objData) {
        
        system.debug('objData:' + objData);
        
        VerifyBulkOrderReturnData vbord = new VerifyBulkOrderReturnData();
        
        String institutionalSaleCode = objData.promoCode;
        
        if(institutionalSaleCode == null){
            vbord.errorMsg = 'No institutional sales code was provided.';
            return vbord;
        }
        
        vbord.errorMsg = null;
        vbord.bord = getBulkOrders(institutionalSaleCode);
        
        system.debug(vbord.bord.oppData);
        
        if(vbord.bord != null && vbord.bord.oppData != null && vbord.bord.oppData.size() == 1){
            
            Opportunity masterOrder = vbord.bord.oppData[0];
            
            Integer licensesUsed = 0;
            if(vbord.bord.oppCountMap != null){
                Integer licenseCount = vbord.bord.oppCountMap.get(masterOrder.Id);
                if(licenseCount != null){
                    licensesUsed = licenseCount;
                }
            }
            
            Integer quantity = 0;
            
            Boolean oppHasFrmExamPart1Products = false;
            Boolean oppHasFrmExamPart2Products = false;            
            Boolean oppHasErpExamPart1Products = false;
            Boolean oppHasErpExamPart2Products = false;
            
            Boolean validationPassed = false;
            String emailValidationError = null;
            
            if(masterOrder.Inst_Sale_Email_Domain_Verification__c != null){
                if(objData.Email.contains(masterOrder.Inst_Sale_Email_Domain_Verification__c)){
                    validationPassed = true;
                }else{
                    emailValidationError = 'Your email address domain is not associated with this pre-paid order.';  
                }
            }
            
            if(masterOrder.Inst_Sale_Emails__c != null) {
                if(masterOrder.Inst_Sale_Emails__c.contains(objData.Email)) {
                    validationPassed = true;
                }else{
                    emailValidationError = 'Your email address is not associated with this pre-paid order.';
                }
            }    
            
            if(!validationPassed && emailValidationError != null){
                vbord.errorMsg = emailValidationError;
                return vbord;
            }
            
            if(masterOrder.OpportunityLineItems != null && masterOrder.OpportunityLineItems.size() > 0) {
                
                for(OpportunityLineItem oppLine :masterOrder.OpportunityLineItems) {
                    
                    if(oppLine.PricebookEntry.Product2.ProductCode != null) {
                        system.debug(objData.isFbrChecked+'      <<<:: oppLine.PricebookEntry.Product2.ProductCode ::>>   '+oppLine.PricebookEntry.Product2.ProductCode );
                        if((oppLine.PricebookEntry.Product2.ProductCode == 'FBRNM' && objData.isFbrChecked == true) || (oppLine.PricebookEntry.Product2.ProductCode == 'CBRNM' && objData.isIcbrChecked == true)) {
                            quantity = (Integer)oppLine.Quantity;
                            vbord.bord.bulkOrderExam1Product = new purchaseCodeData();
                            vbord.bord.bulkOrderExam1Product.priceBookEntryId = oppLine.PricebookEntry.Id;
                            vbord.bord.bulkOrderExam1Product.prodCode = oppLine.PricebookEntry.Product2.ProductCode;
                            vbord.bord.bulkOrderExam1Product.glCode = oppLine.PricebookEntry.Product2.GL_Code__c;
                            vbord.bord.bulkOrderExam1Product.price = String.valueOf(oppLine.UnitPrice);  
                        } else if((oppLine.PricebookEntry.Product2.ProductCode == 'FRM1E' || oppLine.PricebookEntry.Product2.ProductCode == 'FRM1S' || oppLine.PricebookEntry.Product2.ProductCode == 'FRM1L') && objData.isFrmChecked == true) {
                            oppHasFrmExamPart1Products = true;
                            quantity = (Integer)oppLine.Quantity;   
                            vbord.bord.bulkOrderExam1Product = new purchaseCodeData();
                            vbord.bord.bulkOrderExam1Product.priceBookEntryId = oppLine.PricebookEntry.Id;
                            vbord.bord.bulkOrderExam1Product.prodCode = oppLine.PricebookEntry.Product2.ProductCode;
                            vbord.bord.bulkOrderExam1Product.glCode = oppLine.PricebookEntry.Product2.GL_Code__c;
                            vbord.bord.bulkOrderExam1Product.price = String.valueOf(oppLine.UnitPrice);
                        } else if((oppLine.PricebookEntry.Product2.ProductCode == 'FRM2E' || oppLine.PricebookEntry.Product2.ProductCode == 'FRM2S' || oppLine.PricebookEntry.Product2.ProductCode == 'FRM2L') && objData.isFrmChecked == true) {
                            oppHasFrmExamPart2Products = true;
                            quantity = (Integer)oppLine.Quantity;                                                              
                            vbord.bord.bulkOrderExam2Product = new purchaseCodeData();
                            vbord.bord.bulkOrderExam2Product.priceBookEntryId = oppLine.PricebookEntry.Id;
                            vbord.bord.bulkOrderExam2Product.prodCode = oppLine.PricebookEntry.Product2.ProductCode;
                            vbord.bord.bulkOrderExam2Product.glCode = oppLine.PricebookEntry.Product2.GL_Code__c;
                            vbord.bord.bulkOrderExam2Product.price = String.valueOf(oppLine.UnitPrice);
                        } else if((oppLine.PricebookEntry.Product2.ProductCode == 'ENC1E' || oppLine.PricebookEntry.Product2.ProductCode == 'ENC1S' || oppLine.PricebookEntry.Product2.ProductCode == 'ENC1L') && objData.isErpChecked == true) {
                            oppHasErpExamPart1Products = true;
                            quantity = (Integer)oppLine.Quantity;                                                              
                            vbord.bord.bulkOrderExam1Product = new purchaseCodeData();
                            vbord.bord.bulkOrderExam1Product.priceBookEntryId = oppLine.PricebookEntry.Id;
                            vbord.bord.bulkOrderExam1Product.prodCode = oppLine.PricebookEntry.Product2.ProductCode;
                            vbord.bord.bulkOrderExam1Product.glCode = oppLine.PricebookEntry.Product2.GL_Code__c;
                            vbord.bord.bulkOrderExam1Product.price = String.valueOf(oppLine.UnitPrice);
                        } else if((oppLine.PricebookEntry.Product2.ProductCode == 'ENC2E' || oppLine.PricebookEntry.Product2.ProductCode == 'ENC2S' || oppLine.PricebookEntry.Product2.ProductCode == 'ENC2L') && objData.isErpChecked == true) {
                            oppHasErpExamPart2Products = true;
                            quantity = (Integer)oppLine.Quantity;                                                              
                            vbord.bord.bulkOrderExam2Product = new purchaseCodeData();
                            vbord.bord.bulkOrderExam2Product.priceBookEntryId = oppLine.PricebookEntry.Id;
                            vbord.bord.bulkOrderExam2Product.prodCode = oppLine.PricebookEntry.Product2.ProductCode;
                            vbord.bord.bulkOrderExam2Product.glCode = oppLine.PricebookEntry.Product2.GL_Code__c;
                            vbord.bord.bulkOrderExam2Product.price = String.valueOf(oppLine.UnitPrice);                    
                        } else if(oppLine.PricebookEntry.Product2.ProductCode == 'FRM1') {   
                            vbord.bord.bulkOrderExamEnrollment = new purchaseCodeData();
                            vbord.bord.bulkOrderExamEnrollment.priceBookEntryId = oppLine.PricebookEntry.Id;
                            vbord.bord.bulkOrderExamEnrollment.prodCode = oppLine.PricebookEntry.Product2.ProductCode;
                            vbord.bord.bulkOrderExamEnrollment.glCode = oppLine.PricebookEntry.Product2.GL_Code__c;
                            vbord.bord.bulkOrderExamEnrollment.price = String.valueOf(oppLine.UnitPrice);
                        } else if(oppLine.PricebookEntry.Product2.ProductCode == 'ENC') {                   
                            vbord.bord.bulkOrderExamEnrollment = new purchaseCodeData();
                            vbord.bord.bulkOrderExamEnrollment.priceBookEntryId = oppLine.PricebookEntry.Id;
                            vbord.bord.bulkOrderExamEnrollment.prodCode = oppLine.PricebookEntry.Product2.ProductCode;
                            vbord.bord.bulkOrderExamEnrollment.glCode = oppLine.PricebookEntry.Product2.GL_Code__c;
                            vbord.bord.bulkOrderExamEnrollment.price = String.valueOf(oppLine.UnitPrice);
                        }
                    }
                }
                
                String errExam = '';
                if(oppHasFrmExamPart1Products == true && oppHasFrmExamPart2Products == false) {
                    errExam = 'This promotional code is only valid for FRM Exam Part I.';
                } else if(oppHasFrmExamPart1Products == true && oppHasFrmExamPart2Products == true) {
                    errExam = 'This promotional code is for FRM Exam Part I and FRM Exam Part II.';
                } else if(oppHasFrmExamPart1Products == false && oppHasFrmExamPart2Products == true) {
                    errExam = 'This promotional code is only valid for FRM Exam Part II.';
                } else if(oppHasErpExamPart1Products == true && oppHasErpExamPart2Products == false) {
                    errExam = 'This promotional code is only valid for ERP Exam Part I.';
                } else if(oppHasErpExamPart1Products == true && oppHasErpExamPart2Products == true) {
                    errExam = 'This promotional code is for ERP Exam Part I and ERP Exam Part II.';
                } else if(oppHasErpExamPart1Products == false && oppHasErpExamPart2Products == true) {
                    errExam = 'This promotional code is only valid for ERP Exam Part II.';
                }
                
                System.debug('QUANTITY: ' + quantity + 'LICENSES USED: ' + licensesUsed);
                
                if(quantity == 0) {
                    vbord.errorMsg = 'This promotion code is not related to this exam.';
                    return vbord;
                } else if(licensesUsed >= quantity) {
                    vbord.errorMsg = 'There are no more items left on this promotion code.';
                    return vbord;
                }
                
                Boolean examRegistrationFrmPart1 = false;
                Boolean examRegistrationFrmPart2 = false;
                Boolean examRegistrationErpPart1 = false;
                Boolean examRegistrationErpPart2 = false;
                
                for (TempAccount.productDefinition objProdDef: objData.productcode1) {
                    if(objProdDef.ProductCode == 'FRM1E' || objProdDef.ProductCode == 'FRM1S' || objProdDef.ProductCode == 'FRM1L'){
                        examRegistrationFrmPart1 = true;
                    }
                    if(objProdDef.ProductCode == 'FRM2E' || objProdDef.ProductCode == 'FRM2S' || objProdDef.ProductCode == 'FRM2L'){
                        examRegistrationFrmPart2 = true;
                    }
                    if(objProdDef.ProductCode == 'ENC1E' || objProdDef.ProductCode == 'ENC1S' || objProdDef.ProductCode == 'ENC1L'){
                        examRegistrationErpPart1 = true;
                    }
                    if(objProdDef.ProductCode == 'ENC2E' || objProdDef.ProductCode == 'ENC2S' || objProdDef.ProductCode == 'ENC2L'){
                        examRegistrationErpPart2 = true;
                    }
                }        
                
                if(examRegistrationFrmPart1 == true && oppHasFrmExamPart1Products == false) {
                    vbord.errorMsg = errExam;
                } else if(examRegistrationFrmPart2 == true && oppHasFrmExamPart2Products == false) {
                    vbord.errorMsg = errExam;
                } else if(examRegistrationErpPart1 == true && oppHasErpExamPart1Products == false) {
                    vbord.errorMsg = errExam;
                } else if(examRegistrationErpPart2 == true && oppHasErpExamPart2Products == false) {
                    vbord.errorMsg = errExam;
                }
                
            }
            
        } else {
            
            vbord.errorMsg = 'The promotional code provided is invalid.';
            
        } 
        
        return vbord;
        
    }
    
    public static Boolean removeOrder(String oppId, Boolean removeContract, Boolean fromRegistration) {
        
        ID accountID;
        if(!fromRegistration)
            accountID = Utilities.verifyUserAccount();
        
        if (oppId != null) {
            
            //List <ChargentSFA__Transaction__c> lstTrans = [select Id, Name from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c = :oppId];
            //delete lstTrans;
            
            List < Opportunity > lstOpp;
            if(!fromRegistration)
                lstOpp  = [select Id, Name from Opportunity where id = : oppId and AccountId =:accountID and StageName = 'New Lead'];
            else lstOpp = [select Id, Name from Opportunity where id = : oppId and StageName = 'New Lead'];
            
            system.debug('removeOrder lstOpp:' + lstOpp);
            
            if (lstOpp != null && lstOpp.size() > 0) {
                
                List < Contract > lstContract = [select Id, Name, Opportunity__c from contract where Opportunity__c in : lstOpp];
                if (lstContract != null && lstContract.size() > 0 && removeContract) {
                    //for(Contract con :lstContract) {
                    //    ea.Cancelled__c = true;
                    //}
                    //update lstEA;                    
                    //delete lstContract;
                }
                List < Exam_Attempt__c > lstEA = [select Id, Name, Canceled_Reason_Type__c from Exam_Attempt__c where Opportunity__c in : lstOpp];
                if (lstEA != null && lstEA.size() > 0 && removeContract) {
                    for(Exam_Attempt__c ea :lstEA) {
                        ea.Cancelled__c = true;
                        if(fromRegistration == true) {
                            ea.Canceled_Reason_Type__c = 'Checkout Failed';   
                        } else {
                            ea.Canceled_Reason_Type__c = 'Remove Order';
                        }
                        
                    }
                    update lstEA;
                }
                for(Opportunity opp :lstOpp) {
                    opp.StageName = 'Closed Lost';
                }
                update lstOpp;
                //delete lstOpp;
                return true;
            }
        }
        return false;
    }
    
    
    public static Boolean clearIDContactInfo() {
        
        Id userId = UserInfo.getUserId();
        Boolean updated = false;
        
        List<User> users = [
            SELECT Id, ContactId, AccountId 
            FROM User
            WHERE Id = :userId
        ];
        
        Id contactId = null;
        if(users != NULL && users.size() > 0){
            List < contact > lstcnt = [
                SELECT 
                Id, 
                Name_As_it_Appears_On_ID__c, 
                ID_Type__c, 
                ID_Number__c
                FROM contact 
                WHERE Id = :users[0].ContactId
            ];
            if (lstcnt != null && lstcnt.size() > 0) {
                Contact con = lstcnt[0];
                con.Name_As_it_Appears_On_ID__c = NULL;
                con.ID_Type__c = NULL;
                con.ID_Number__c = NULL;
                
                update con;
                updated = true;
            }
        }
        return updated;
    }
    
    public static Contact setContactInfo(TempAccount tempAccount) {
        
        List < contact > lstcnt = [
            SELECT 
            Id, 
            Email, 
            Title, 
            Birthdate,
            ID_Expiration_Date__c,
            Full_Name_in_Chinese__c,
            Gender__c,
            Name_As_it_Appears_On_ID__c, 
            ID_Type__c, 
            ID_Number__c, 
            OSTA_ID_Location__c,
            First_Name_as_it_Appears_on_ID__c,
            Middle_Name_as_it_Appears_on_ID__c,
            Last_Name_as_it_Appears_on_ID__c,            
            Currently_Working_Status__c, 
            Currently_in_School_Status__c, 
            Company__c, 
            Corporate_Title__c, 
            Job_Function__c, 
            Risk_Specialty__c,
            Risk_Management_Working_Year__c,
            Area_of_Concentration__c, 
            Industry_Working_Year__c,
            Professional_Designation_CA__c, 
            Professional_Designation_CFA__c, 
            Professional_Designation_CMA__c, 
            Professional_Designation_CPA__c, 
            Professional_Designation_CAIA__c, 
            Professional_Designation_ACCA__c, 
            Professional_Designation_CFP__c, 
            Professional_Designation_CIA__c, 
            Professional_Designation_CMT__c, 
            Professional_Designation_CQF__c, 
            Professional_Designation_PMP__c, 
            Professional_Designation_Other__c,
            Other_Qualifications__c,
            School_Name__c, 
            Degree_Program_Name__c, 
            Currently_in_School__c, 
            Currently_Working__c,
            Expected_Graduation_Date__c,
            HomePhone,
            Experience__c,
            How_Did_You_Hear_About_Us__c,
            How_Did_You_Hear_About_Us_Other__c,
            OSTA_Full_ID__c,
            OSTA_Consent__c
            FROM contact 
            WHERE Id = :tempAccount.Id
        ];
        if (lstcnt != null && lstcnt.size() > 0) {
            
            DateTime now = DateTime.now();
            Contact con = lstcnt[0];
            
            // Protect Updates
            if(tempAccount.idName != NULL && tempAccount.idName.length() > 0)
                con.Name_As_it_Appears_On_ID__c = tempAccount.idName;
            
            if(tempAccount.idType != null && tempAccount.idType.length() > 0) {
                if(tempAccount.idType.indexOf('Driver') > -1) {
                    con.ID_Type__c = 'Driver\'s License';
                } else {
                    con.ID_Type__c = tempAccount.idType;    
                }
            }
            if(tempAccount.idLocation != NULL && tempAccount.idLocation.length() > 0)
            	con.OSTA_ID_Location__c = tempAccount.idLocation;
            
            // OSTA Save Full ID and last 5
            Boolean updateConsent = False;
            if(tempAccount.idNumber != null && tempAccount.idNumber.length() > 0) {
                if(tempAccount.idNumber.length() > 5 && tempAccount.Full_Name_in_Chinese!= NULL) {
                    con.OSTA_Full_ID__c = tempAccount.idNumber;
                    con.ID_Number__c = tempAccount.idNumber.right(5);
                    con.OSTA_Consent__c = now;
                    updateConsent = True;
                } else {
                    con.ID_Number__c = tempAccount.idNumber;    
                }
            }            
            
            if(tempAccount.idFirstName != NULL && tempAccount.idFirstName.length() > 0)
                con.First_Name_as_it_Appears_on_ID__c = tempAccount.idFirstName;
            
            if(tempAccount.idMiddleName != NULL && tempAccount.idMiddleName.length() > 0)
                con.Middle_Name_as_it_Appears_on_ID__c = tempAccount.idMiddleName;
            
            if(tempAccount.idLastName != NULL && tempAccount.idLastName.length() > 0)
                con.Last_Name_as_it_Appears_on_ID__c = tempAccount.idLastName;
            
            if(tempAccount.Birthdate != null && tempAccount.Birthdate.length() > 0)
                con.Birthdate = date.parse(tempAccount.Birthdate);
            
            if(tempAccount.Gender != null && tempAccount.Gender.length() > 0)
                con.Gender__c = tempAccount.Gender;
            
            if(tempAccount.ID_Expiration_Date != null && tempAccount.ID_Expiration_Date.length() > 0)
                con.ID_Expiration_Date__c = date.parse(tempAccount.ID_Expiration_Date);
            
            if(tempAccount.Full_Name_in_Chinese != null && tempAccount.Full_Name_in_Chinese.length() > 0)
                con.Full_Name_in_Chinese__c = tempAccount.Full_Name_in_Chinese;
            
            if(tempAccount.HomePhone != null && tempAccount.HomePhone.length() > 0)
                con.HomePhone = tempAccount.HomePhone;
            
            if(tempAccount.jobtitle != null && tempAccount.jobtitle.length() > 0)
                con.Title = tempAccount.jobtitle;
            
            if(tempAccount.Company != null && tempAccount.Company.length() > 0)
                con.Company__c = tempAccount.Company;
            
            if(tempAccount.Title != null && tempAccount.Title.length() > 0)
                con.Corporate_Title__c = tempAccount.Title;
            
            if(tempAccount.JobFunction != null && tempAccount.JobFunction.length() > 0)
                con.Job_Function__c = tempAccount.JobFunction;

            if(tempAccount.RiskSpecialty != null && tempAccount.RiskSpecialty.length() > 0)
                con.Risk_Specialty__c = tempAccount.RiskSpecialty;
            
            if(tempAccount.RiskManagementWorkingYear != null && tempAccount.RiskManagementWorkingYear.length() > 0)
                con.Risk_Management_Working_Year__c = tempAccount.RiskManagementWorkingYear;
                
            if(tempAccount.Industry != null && tempAccount.Industry.length() > 0)
                con.Area_of_Concentration__c = tempAccount.Industry;

            if(tempAccount.IndustryWorkingYear != null && tempAccount.IndustryWorkingYear.length() > 0)
                con.Industry_Working_Year__c = tempAccount.RiskManagementWorkingYear;
            
            if(tempAccount.Years_of_Experience != null && tempAccount.Years_of_Experience.length() > 0)
                con.Years_of_Experience__c = tempAccount.Years_of_Experience;
            
            if(tempAccount.Experience != null && tempAccount.Experience.length() > 0)
                con.Experience__c = tempAccount.Experience;
            
            if(tempAccount.howDidYouHear != null && tempAccount.howDidYouHear.length() > 0)
                con.How_Did_You_Hear_About_Us__c = tempAccount.howDidYouHear;
            
            if(tempAccount.howDidYouHearOther != null && tempAccount.howDidYouHearOther.length() > 0)
                con.How_Did_You_Hear_About_Us_Other__c = tempAccount.howDidYouHearOther;
            
            if(tempAccount.MailingStreet != null && tempAccount.MailingStreet.length() > 0)
                con.MailingStreet = tempAccount.MailingStreet;
            
            if(tempAccount.MailingStreet2 != null && tempAccount.MailingStreet2 != ''){
                con.MailingStreet+= ', ' + tempAccount.MailingStreet2;
            }
            if(tempAccount.MailingStreet3 != null && tempAccount.MailingStreet3 != ''){
                con.MailingStreet+= ', ' + tempAccount.MailingStreet3;
            }
            
            if(tempAccount.MailingCity != null && tempAccount.MailingCity.length() > 0)
                con.MailingCity = tempAccount.MailingCity;
            if(tempAccount.MailingState != null && tempAccount.MailingState.length() > 0)
                con.MailingState = tempAccount.MailingState;
            if(tempAccount.MailingCountry != null && tempAccount.MailingCountry.length() > 0)
                con.MailingCountry = tempAccount.MailingCountry;
            if(tempAccount.MailingPostalCode != null && tempAccount.MailingPostalCode.length() > 0)
                con.MailingPostalCode = tempAccount.MailingPostalCode;
            
            //con.Birthdate               = (tempAccount.Birthdate != null) ? date.parse(tempAccount.Birthdate) : null;
            //con.Gender__c               = tempAccount.Gender;
            //con.ID_Expiration_Date__c   = (tempAccount.ID_Expiration_Date != null) ? date.parse(tempAccount.ID_Expiration_Date) : null;
            //con.Full_Name_in_Chinese__c = tempAccount.Full_Name_in_Chinese;
            
            if(tempAccount.CA != null)
                con.Professional_Designation_CA__c = tempAccount.CA;
            if(tempAccount.CFA != null)            
                con.Professional_Designation_CFA__c = tempAccount.CFA;
            if(tempAccount.CMA != null)            
                con.Professional_Designation_CMA__c = tempAccount.CMA;
            if(tempAccount.CPA != null)            
                con.Professional_Designation_CPA__c = tempAccount.CPA;
            if(tempAccount.CIA != null)            
                con.Professional_Designation_CIA__c = tempAccount.CIA;
            if(tempAccount.ACCA != null)            
                con.Professional_Designation_ACCA__c = tempAccount.ACCA;
            if(tempAccount.CAIA != null)            
                con.Professional_Designation_CAIA__c = tempAccount.CAIA;
            if(tempAccount.CMT != null)            
                con.Professional_Designation_CMT__c = tempAccount.CMT;
            if(tempAccount.CQF != null)            
                con.Professional_Designation_CQF__c = tempAccount.CQF;
            if(tempAccount.PMP != null)            
                con.Professional_Designation_PMP__c = tempAccount.PMP;
            if(tempAccount.CFP != null)            
                con.Professional_Designation_CFP__c = tempAccount.CFP;            
            if(tempAccount.OtherDesignation != null) {
                con.Professional_Designation_Other__c = tempAccount.OtherDesignation;
                con.Other_Qualifications__c = tempAccount.OtherDesignationText;
            }
            
            if(tempAccount.School != null && tempAccount.School.length() > 0)
                con.School_Name__c = tempAccount.School;
            
            if(tempAccount.Degree_Program_Name != null && tempAccount.Degree_Program_Name.length() > 0)
                con.Degree_Program_Name__c = tempAccount.Degree_Program_Name;
            
            if(tempAccount.Expected_Graduation_Date != null && tempAccount.Expected_Graduation_Date.length() > 0)
                con.Expected_Graduation_Date__c = tempAccount.Expected_Graduation_Date;
            
            if(tempAccount.Expected_Graduation_Date != null)
                con.Email_Information_Exchange__c = tempAccount.infoExchange;
            
            //We moved this field to the Registration page from Registration Info page - sr 7/22/2015 
            //con.Exam_Prep_Provider_Outreach__c = tempAccount.eppHelp;
            
            //con.Currently_Working__c = tempAccount.isWorking;
            //con.Currently_in_School__c = tempAccount.inSchool;
            if(tempAccount.isWorking != Null) {
                if(tempAccount.isWorking == true)
                    con.Currently_Working_Status__c = 'Working';
                else con.Currently_Working_Status__c = 'Not Working';
            }
            
            if(tempAccount.inSchool != Null) {
                if(tempAccount.inSchool == true)
                    con.Currently_in_School_Status__c = 'In School';
                else con.Currently_in_School_Status__c = 'Not In School';
            }
            
            update con;

            if(tempAccount.examAttemptId != NULL && updateConsent) {
                List<Exam_Attempt__c> lstExamReg = [SELECT id, OSTA_Consent__c from Exam_Attempt__c where id = :tempAccount.examAttemptId];
                if(!lstExamReg.isEmpty()) {
                    lstExamReg[0].OSTA_Consent__c = now;
                    update lstExamReg;
                }
                
            }            
            return con;
        } else {
            return null;
        }
        
    }
    
    public static wrapperGetContact getContactInfo(String contactId) {
        
        wrapperGetContact retCon = new wrapperGetContact();
        retCon.tempAccount = new TempAccount();
        
        List<Contact> lstcnt = [
            SELECT 
            Id,  
            Email, 
            Title, 
            GARP_Member_ID__c, 
            Birthdate,
            ID_Expiration_Date__c,
            Full_Name_in_Chinese__c,
            Gender__c,
            Currently_Working_Status__c, 
            Currently_in_School_Status__c, 
            KPI_Membership_Payment_Status__c, 
            KPI_CPE_Participation__c, 
            Membership_Type__c, 
            Name_As_it_Appears_On_ID__c, 
            ID_Type__c, 
            ID_Number__c, 
            Company__c, 
            Corporate_Title__c, 
            Job_Function__c, 
            Risk_Specialty__c,
            Area_of_Concentration__c, 
            Years_of_Experience__c, 
            Professional_Designation_CA__c, 
            Professional_Designation_CFA__c, 
            Professional_Designation_CMA__c, 
            Professional_Designation_CPA__c, 
            Professional_Designation_Other__c, 
            Other_Qualifications__c, 
            School_Name__c, 
            Degree_Program_Name__c, 
            Email_Information_Exchange__c, 
            Exam_Prep_Provider_Outreach__c, 
            Currently_Working__c, 
            Currently_in_School__c,
            Expected_Graduation_Date__c,
            HomePhone,
            MobilePhone,
            Phone,
            MailingStreet,
            MailingCity,
            MailingState,
            MailingCountry,
            MailingPostalCode,
            Experience__c,
            How_Did_You_Hear_About_Us__c,
            How_Did_You_Hear_About_Us_Other__c,
            (
                SELECT Id, Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Name, Exam_Site__r.Country__c, Opportunity__r.ChargentSFA__Billing_Country__c, CreatedDate, 
                Exam_Site__r.Site__r.Is_OSTA_Information_Required__c, 
                Exam_Site__r.Site__r.Is_Gender_Required__c
                FROM Exam_Attempts__r 
                ORDER BY CreatedDate DESC
            )
            FROM Contact 
            WHERE (Id = :contactId OR GARP_Member_ID__c = :contactId)
        ];
        
        if (lstcnt != null && lstcnt.size() > 0) {
            retCon.contactReturnData = lstcnt[0];
            return retCon;
        } else {
            return null;
        }
        
    }
    
    public static wrapperCheckExistingMember CheckExistingMember(String Email) {
        contact cld = null;
        Id recId = RecordTypeHelper.GetRecordTypeId('Contact','Member');
        Id memBusRecType = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
        
        List < contact > lstcnt = [select Id, Email, RecordTypeId, Event_Participant__c, Event_Contributor__c from contact where Email = : Email];        
        wrapperCheckExistingMember em = new wrapperCheckExistingMember();
        for(Contact cont :lstcnt) {            
            if(cont.RecordTypeId == recId || (cont.RecordTypeId == memBusRecType && (cont.Event_Participant__c == True || cont.Event_Contributor__c == True))) {
                em.tempAccount = new TempAccount();
                em.contactId = cont.Id;
                return em;
            }
        }
        em.tempAccount = new TempAccount();
        em.contactId = null;
        return em;
    }
    
    public static Id setLead(String email, String firstName, String lastName, String formName, String cta) {
        
        if (email == null) return null; 
        
        Form_Data__c formData = new Form_Data__c();
        
        formData.First_Name__c = firstName;
        formData.Last_Name__c = lastName;
        formData.Email__c = email;
        formData.Status__c = 'Abandoned';
        formData.Call_To_Action__c = cta;
               
        Utilities.FormDataResponse rd = Utilities.manageFormSubmission(formData, formName);            
        
        if(rd.leadId != NULL) {
            return rd.leadId;
        } else {
            return rd.contactId;
        }
    }
    
    // Updated per [US-22986]
    public static Id setLeadFromMarketingEmail(String email) {
        Lead ld = null;
        contact cc = null;
        
        if (email == null) return null;
        
        List < contact > lstcnt = [select Id, Email from contact where Email = : Email];
        if (lstcnt != null && lstcnt.size() > 0) {
            cc = lstcnt[0];
            return cc.id;
        } else {
            List < Lead > lstLeads = [select id, Name, Email from Lead where Email = : email and Isconverted = false LIMIT 1];
            
            //wrapperSetLead wrapperSetLeadReturn = new wrapperSetLead();    
            //wrapperSetLeadReturn.tempAccount = new TempAccount();
            
            if (lstLeads != null && lstLeads.size() > 0) {
                ld = lstLeads[0];
                return ld.id;
            } else {
                Lead newLead = new Lead();
                newLead.FirstName = 'leadfirstname';
                newLead.LastName = 'leadlastname';
                newLead.Company = 'leadcompanyemail@leadcompanyemail.com';
                newLead.Email = email;
                newLead.Marketing_Email_Creation__c = true;
                newLead.Email_Career_Center_Job_Board__c = false;
                newLead.Email_Chapter_Meetings__c = false;
                newLead.Email_CPE_News__c = false;
                newLead.Email_Daily_News__c = false;
                newLead.Email_GARP_Updates__c = true;
                newLead.Email_FRM__c = true;
                newLead.Email_ERP__c = true;
                newLead.Email_Webcasts__c = true;
                newLead.Email_Information_Exchange__c = false;
                newLead.Email_Member_Update__c = false;
                newLead.Email_The_Week_in_Risk__c = false;
                
                insert newLead;
                return newLead.id; 
            }
        }
        
    }
    
    public static Exam_Group__c registrationDate() {
        //date d;
        List < Exam_Group__c > lstcnt = [select id, Active__c, Exam_Results_Available_Date__c, Exam_Date__c, Exam_Ticket_Available_Date__c, Last_Date_To_Apply_For_Deferral__c, Last_Date_For_ADA__c, Last_Date_For_Scholarship__c, Last_Date_For_Standard_Registration__c, Last_Date_For_Early_Registration__c, Registration_Start_Date__c from Exam_Group__c where Active__C = true];
        if (lstcnt != null && lstcnt.size() > 0) {
            return lstcnt[0];
        } else {
            return NULL;
        }
    }
    
    public static date testDate() {
        date d;
        List < Exam_Group__c > lstcnt = [select id, Active__c, Exam_Date__c, Registration_Start_Date__c from Exam_Group__c where Active__C = true];
        if (lstcnt != null && lstcnt.size() > 0) {
            d = lstcnt[0].Exam_Date__c;
        }
        return d;
    }
    
    
    public static List<Contact> GetBussinessContact(TempAccount objData) {
        
        Id memBusRecType = RecordTypeHelper.GetRecordTypeId('Contact','Business Relationship');
        
        contact cld = null;
        
        system.debug('GetBussinessContact:'+objData.Email);
        
        List < contact > lstcnt = [select id, Email, RecordTypeId, AccountId, Name, GARP_ID_New__c, Email_Daily_News__c, Email_The_Week_in_Risk__c 
                                   from contact where Email = : objData.Email and RecordTypeId = :memBusRecType];
        if (lstcnt != null && lstcnt.size() > 0) {
            
            return lstcnt;
            
        }
        return null;
        
    }
    
    
    public static boolean GetMember(TempAccount objData) {
        contact cld = null;
        
        system.debug('GetMember:'+objData.Email);
        
        List < contact > lstcnt = [select id, Email from contact where Email = : objData.Email];
        if (lstcnt != null && lstcnt.size() > 0) {
            
            cld = lstcnt[0];
            return true;
            
        } else {
            
            system.debug('Contact not Found!:'+objData.Email);
            
            List<User> lstUser = [Select Id,ContactId,Email from User where Email = :objData.Email and id = '00e400000017dA8' AND IsActive = True];
            
            system.debug('lstUser:'+lstUser);
            
            if (lstUser != null && lstUser.size() > 0) {
                return true;
            }
        }
        return false;
        
    }
    public static Id SetLead(TempAccount objData) {
        return checkLead(objData);
    }
    
    public static Id checkLead(TempAccount objData) {
        Lead ld = null;
        if (objData.Email == null) return null;
        List < Lead > lstLeads = [select id, Name, Email from Lead where Email = : objData.Email and Isconverted = false LIMIT 1];
        if (lstLeads != null && lstLeads.size() > 0) {
            ld = lstLeads[0];
            ld.FirstName = objData.FirstName;
            ld.LastName = objData.LastName;
            ld.Company = objData.FirstName + ' ' + objData.LastName;
            ld.Email = objData.Email;
            ld.Membership_Type__c = objData.garpMembership_Type;
            update ld;
            system.debug('ld=== ' + ld);
            return ld.id;
        } else {
            Lead newLead = new Lead();
            newLead.FirstName = objData.FirstName;
            newLead.LastName = objData.LastName;
            newLead.Company = objData.FirstName + ' ' + objData.LastName;
            newLead.Email = objData.Email;
            newLead.Membership_Type__c = objData.garpMembership_Type;
            insert newLead;
            return newLead.id;
        }
    }
    
    
    
    public static wrapperCreateChapterMeetingRegistration createChapterMeetingRegistration(TempAccount objData,String contactId) {
        wrapperCreateChapterMeetingRegistration returnChapterMeetingWrapper = new wrapperCreateChapterMeetingRegistration();
        wrapperCreateOrder newOrder;
        String userContactId = null;
        
        Boolean foundOrder = false;
        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            if(objProdDef.ProductCode == 'MEMI' || objProdDef.ProductCode == 'CHMT1')
                foundOrder=true;
        }        
        
        system.debug('foundOrder:' + foundOrder);
        
        if(contactId != null){
            // PORTAL
            System.debug('PORTAL');
            // No Order
            if(foundOrder == false) {
                System.debug(objData);               
                setChapterMeetingRegistration(objData, contactId, null, TRUE);
                userContactId = contactId;
            } else {
                newOrder = createOrderForPortalUsers(objData);
                userContactId = newOrder.contactId;
            }
            
        } else if(contactId == null){
            // PUBLIC
            System.debug('PUBLIC');
            // No Order
            if(foundOrder == false) {
                newOrder = CreateOrder(objData);
                System.debug('newOrder:' + newOrder);
                
                if(newOrder.errorMsg == NULL || newOrder.errorMsg.length() == 0) {
                    userContactId = newOrder.contactId;
                    setChapterMeetingRegistration(objData, userContactId, null, TRUE);
                }
            } else {
                newOrder = CreateOrder(objData);
                userContactId = newOrder.contactId;
            }
        }
        
        List < Chapter_Meeting_Registration__c  > chapterMeetingRegistrations = [SELECT Id FROM Chapter_Meeting_Registration__c where (Contact__c =: userContactId and Chapter_Meeting__c =: objData.chapterMeetingId)];        
        if(chapterMeetingRegistrations != NULL && chapterMeetingRegistrations.size() > 0) {
            returnChapterMeetingWrapper.chapterMeetingRegistrationId = chapterMeetingRegistrations[0].Id;    
        }
        returnChapterMeetingWrapper.wrapperCreateOrderData = newOrder;
        return returnChapterMeetingWrapper;
    }
    
    public static void setChapterMeetingRegistration(TempAccount objData, Id contactId, Id OpportunityId, Boolean isConfirmed){
        
        System.debug('objData:' + objData);    
        System.debug('contactId:' + contactId);    
        System.debug('OpportunityId:' + OpportunityId);    

        Chapter_Meeting_Registration__c chapterMeetingRegistration;
        Boolean newRegistration = true;
        if(objData.chapterMeetingRegistrationId == null) {
            List<Chapter_Meeting_Registration__c> lstChaptMeetRegs = [select Id, Name, Status__c, Role__c, Chapter_Meeting__c, Contact__c, Opportunity__c, Attendance_Method__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :objData.chapterMeetingId and Contact__c = :contactId];
            if(lstChaptMeetRegs != null && lstChaptMeetRegs.size() > 0) {
                chapterMeetingRegistration = lstChaptMeetRegs[0];
                newRegistration = false;
            } else {
                chapterMeetingRegistration  = new Chapter_Meeting_Registration__c();        
            }        
        } else {
            List<Chapter_Meeting_Registration__c> lstChaptMeetRegs = [select Id, Name, Status__c, Role__c, Chapter_Meeting__c, Contact__c, Opportunity__c, Attendance_Method__c from Chapter_Meeting_Registration__c where id = :objData.chapterMeetingRegistrationId];
            if(lstChaptMeetRegs != null && lstChaptMeetRegs.size() > 0) {
                chapterMeetingRegistration = lstChaptMeetRegs[0];
                newRegistration = false;
            } else {
                return;
            }        
        }
        
        if(isConfirmed == true) 
            chapterMeetingRegistration.put('Status__c','Confirmed');
        else 
            chapterMeetingRegistration.put('Status__c','Registered');
        
        chapterMeetingRegistration.put('Role__c','Registrant');
        chapterMeetingRegistration.put('Attendance_Method__c',objData.AttendanceMethod);        
        
        if(objData.privacyPolicyAttestation != null && objData.privacyPolicyAttestation){ 
            chapterMeetingRegistration.put('Privacy_Policy_Attestation__c',System.now());
        }
        
        if(objData.sponsorInformationExchangeAttestation != null && objData.sponsorInformationExchangeAttestation){
            chapterMeetingRegistration.put('Sponsor_Information_Exchange_Attestation__c',System.now());
        }
        
        if(objData.garpInformationExchangeAttestation != null && objData.garpInformationExchangeAttestation){
            chapterMeetingRegistration.put('GARP_Information_Exchange_Attestation__c',System.now());
        }        
        
        if(newRegistration == true)
            chapterMeetingRegistration.put('Chapter_Meeting__c', objData.chapterMeetingId);
        
        System.debug([SELECT Id, FirstName, LastName, AccountId, Account.Name FROM Contact WHERE Id = :contactId]);
        System.debug([SELECT Id, ContactId, Contact.FirstName, Contact.LastName FROM User WHERE ContactId = :contactId]);
        chapterMeetingRegistration.put('Contact__c', contactId); //System.DmlException: Insert failed. First exception on row 0; first error: UNKNOWN_EXCEPTION, java.lang.NullPointerException: []
        
        if(OpportunityId != null){
            chapterMeetingRegistration.put('Opportunity__c', OpportunityId);
        } else {
            chapterMeetingRegistration.put('Opportunity__c', null);
        }
        
        System.debug('**chapterMeetingRegistration:' + chapterMeetingRegistration); 
        
        if(newRegistration == true){
            
            INSERT chapterMeetingRegistration;
            
            List<Chapter_Meeting__c> chapterMeetings = [
                SELECT Id, Content__r.Form__r.Form_Name__c 
                FROM Chapter_Meeting__c 
                WHERE Id = :objData.chapterMeetingId
            ];
            
            // Only modify data on new Chapter Meeting Registration.
            if(!chapterMeetings.isEmpty()){
                Utilities.migrateLeadFormDataToContact(null, contactId, chapterMeetings[0].Content__r.Form__r.Form_Name__c, null);
            }
            
        }else{ 
            update chapterMeetingRegistration;
        }

        // Call ON24 for Virtual Chapter Meeting (free registration)
        // ON24 API call out 
        if(OpportunityId == null && contactId != NULL){
            List < Chapter_Meeting_Registration__c  > chapterMeetingRegistrationDetails = [SELECT Id,Chapter_Meeting__r.ON24_Event_Id__c,Chapter_Meeting__r.ON24_API_Key__c 
            FROM Chapter_Meeting_Registration__c 
            WHERE (Contact__c =: contactId and Chapter_Meeting__c =: objData.chapterMeetingId)];   
            if(chapterMeetingRegistrationDetails != null && !chapterMeetingRegistrationDetails.isEmpty() && chapterMeetingRegistrationDetails[0].Chapter_Meeting__r.ON24_Event_Id__c != null) {
                                
                API_Transaction__c trans = on24API.createAPITransactionRecord(
                    'chaptermeeting',
                    chapterMeetingRegistrationDetails[0].Id , 
                    contactId,
                    chapterMeetingRegistrationDetails[0].Chapter_Meeting__r.ON24_Event_Id__c, 
                    chapterMeetingRegistrationDetails[0].Chapter_Meeting__r.ON24_API_Key__c
                );
                if(trans != null){
                    on24API.SendRequest(null, trans.Id);
                } 
            }
        }
        
    }  
    
    public static wrapperCreateWebcastRegistration createWebcastRegistration(TempAccount objData,String contactId) {
        wrapperCreateWebcastRegistration returnWebcastWrapper = new wrapperCreateWebcastRegistration();
        wrapperCreateOrder newAffiliateOrder = new wrapperCreateOrder();
        String userContactId = null;
        
        List<Webcast__c> lstWebcasts = [select ID, Name, EventId__c, X0n24_API_Key__c from Webcast__c where ID = :objData.webcastId];
        if(lstWebcasts != null && lstWebcasts.size() > 0) {
            
            Webcast__c webCast = lstWebcasts[0];
            
            if(contactId != null){
                // PORTAL
                userContactId = contactId;
                insertWebcastRegistration(objData, contactId);
            } else if(contactId == null){
                // PUBLIC
                //if(objData.Membership_Type == 'Affiliate') {
                    newAffiliateOrder = CreateOrder(objData);
                    userContactId = newAffiliateOrder.contactId;
                    insertWebcastRegistration(objData, newAffiliateOrder.contactId);
                //} else {
                //    GARP_BC_Webcasts.createNonMemberWebcastRegistration(objData);
                //}
            }
            
            
           // List < Webcast_Registration__c  > webcastRegistration = [SELECT Id FROM Webcast_Registration__c where (Contact__c =: userContactId and Webcast__c =: objData.webcastId)];
           List < Webcast_Registration__c  > webcastRegistration = [SELECT Id,Lead__r.Id FROM Webcast_Registration__c where (Contact__c =: userContactId and Webcast__c =: objData.webcastId)];        
            if(webcastRegistration != null && webcastRegistration.size() > 0) {
                // API_Transaction__c trans = on24API.createAPITransactionRecord(webcastRegistration[0].Id, userContactId, webCast.EventId__c, webCast.X0n24_API_Key__c);
                API_Transaction__c trans = on24API.createAPITransactionRecord('webcast',webcastRegistration[0].Id, userContactId, webCast.EventId__c, webCast.X0n24_API_Key__c);
                
                if(trans != null)
                    on24API.SendRequest(null, trans.Id);
                
                returnWebcastWrapper.webcastRegistrationId = webcastRegistration[0].Id;
                returnWebcastWrapper.contactId = userContactId;
            }
        }
        
        return returnWebcastWrapper;
    }
    
    public static void insertWebcastRegistration(TempAccount objData,Id contactId){
        Webcast_Registration__c  newWebcastRegistration = new Webcast_Registration__c();
        
        String objName = objData.FirstName + ' ' + objData.LastName + '/' + objData.webcastId;
        
        newWebcastRegistration.Name = objName;
        newWebcastRegistration.Contact__c = contactId;
        newWebcastRegistration.Status__c = 'Registered';
        newWebcastRegistration.Webcast__c = objData.webcastId;
        
        //System.Debug('objData.sponsorInformationExchangeAttestation:' + objData.sponsorInformationExchangeAttestation);
        
        //newWebcastRegistration.Agree_To_Sponsor_Contact__c = objData.sponsorInformationExchangeAttestation ? DateTime.Now() : NULL;
        
        //System.Debug('newWebcastRegistration:' + newWebcastRegistration);        
        insert newWebcastRegistration;
    }
    
    public static Boolean isTempAccountItemTrue(Boolean item) {
        if(item != NULL && item == true)
            return true;
        else return false;
    }
    
    public static Boolean isUserAnAlumni(String email){
        Boolean isUserAnEventAlumni = false;
        //      List < Opportunity > allOpportunitiesByUser = [SELECT Id FROM Opportunity where ChargentSFA__Billing_Email__c=: email];
        //      List < OpportunityLineItem > allOpportunitiesOfAlumniAttendedEvents = [SELECT id, pricebookEntry.Product2.ProductCode, opportunityid FROM OpportunityLineItem where (pricebookEntry.Product2.ProductCode='CNY13' and opportunityid =: allOpportunitiesByUser)];
        
        List < ConventionAlumni__c > conventionAttendeeList = [SELECT id, name, Alumni_Email__c FROM ConventionAlumni__c where (Alumni_Email__c =: email)];
        
        Integer attendeeSize = conventionAttendeeList.size();
        if(attendeeSize > 0){
            isUserAnEventAlumni = true;
        }
        return isUserAnEventAlumni;
    }
    
    public static Opportunity setOpportunityName(TempAccount objData, Opportunity opp) {
        opp.Name = 'GARP Order';
        if(isTempAccountItemTrue(objData.isFrmChecked) || isTempAccountItemTrue(objData.isErpChecked)) {
            opp.Name = 'Exam Registration';    
        } else if(isTempAccountItemTrue(objData.isIcbrChecked) || isTempAccountItemTrue(objData.isFbrChecked) || isTempAccountItemTrue(objData.isFbraChecked)) {
            opp.Name = 'Course Registration';    
        } else if(isTempAccountItemTrue(objData.isEventChecked)) {
            opp.Name = 'Event Registration';
            opp.Event_Order__c = true;
        } else if(objData.chapterMeetingId != null) {
            opp.Name = 'Chapter Meeting Registration';
            opp.Event_Order__c = true;
        } else if(objData.siteId != null) {
            opp.Name = 'Exam Reschedule';
        }
        return Opp;
    }
    
    /**
* BELOW are Methods for registration flows for an Unknown from website
*
* DO NOT MODIFY ANYTHING PAST THIS POINT UNLESS YOU KNOW WHAT YOU'RE DOING!
*
* If you do modify anything below, you will also need to:
* (1) Temp Account and Contact remoter for properties definition and return calls to front end.
*
*/
    
    public static wrapperCreateOrder createOrder(TempAccount objData) {
        
        system.debug('inside CreateOrder CreateOrder');
        system.debug(objData);
        
        Id OpportunityId = null;
        String InvoiceNumber = null;
        Id contactId = null;
        Id accountId = null;
        
        Contact con = null;
        Account acct = null;
        wrapperCreateOrder returnWrapper = new wrapperCreateOrder();
        verifyBulkOrderReturnData vbord;
        Lead convertedLead;
        
        Boolean bValid = Utilities.verifyCaptcha(objData.cap,objData.capip);
        if(!bValid) {
            returnWrapper.errorMsg = 'Captcha Failed';
            return returnWrapper;
        }
        
        if(objData.sessionToken != NULL) {
            Utilities.updateFormSession(objData.sessionToken, objData.Email);
            Utilities.runCaptcha(objData.sessionToken); 
        }
        
        if(objData.promoCode != null) {
            vbord = verifyBulkOrder(objData);
            system.debug('vbord:' + vbord);
            if(vbord.errorMSg != null) {
                returnWrapper.errorMsg = vbord.errorMSg;
                return returnWrapper;
            }
        }
        
        // Existing Order? - Remove It
        if(objData.opportunityId != null) {
            removeOrder(objData.opportunityId, false, true);
        }
        
        List < Contact > lstContact = [SELECT Id, Name, AccountId FROM Contact WHERE Email = : objData.Email];
        if(lstContact != null && lstContact.size() > 0) {
            objData.contactId = lstContact[0].Id;
        }
        system.debug('Existing Contact?' + objData.contactId);
        
        if (objData.contactId != null) {
            contactId = objData.contactId;
            lstContact = [SELECT Id, Name, AccountId, GARP_ID_New__c FROM Contact WHERE Id = : contactId];
            
            if (lstContact != null && lstContact.size() > 0) {
                Id individualRecId = RecordTypeHelper.GetRecordTypeId('Account','Individual');
                List < Account > lstAcct = [select Id, Name, RecordTypeID from Account where Id = : lstContact[0].AccountId];
                if (lstAcct != null && lstAcct.size() > 0) {
                    
                    // Create Account and Add Contact Role
                    if(lstAcct[0].RecordTypeID != individualRecId) {
                        Account acctNew = new Account();
                        acctNew.RecordTypeID = individualRecId ;
                        acctNew.Name = lstContact[0].Name.replace(' ','');
                        acctNew.GARP_ID__c = lstContact[0].GARP_ID_New__c;
                        acctNew.ownerid = userid;
                        insert acctNew;
                        
                        lstContact[0].AccountId = acctNew.Id;
                        update lstContact;
                        
                        accountId = acctNew.Id;
                        
                        /* List<AccountContactRole> lstAcctContRole = [select Id, AccountId, ContactId from AccountContactRole where AccountId = :lstAcct[0].Id and ContactId = :lstContact[0].Id];
                        if(lstAcctContRole == null || lstAcctContRole.size() == 0) {
                        AccountContactRole role = new AccountContactRole();
                        role.AccountId = lstAcct[0].Id;
                        role.ContactId = lstContact[0].Id;
                        insert role;
                        }*/
                        
                    } else {
                        accountId = lstAcct[0].Id;
                    }
                    
                    
                    Opportunity opp = new Opportunity();
                    setOpportunityName(objData, opp);
                    opp.Accountid = accountId;
                    opp.StageName = 'New Lead';
                    opp.ChargentSFA__Billing_First__c = objData.FirstName;
                    opp.ChargentSFA__Billing_Last__c = objData.LastName;
                    opp.ChargentSFA__Billing_Email__c = objData.Email;
                    
                    opp.Alternate_Method_of_Payment__c = objData.paymentMethod;
                    
                    opp.CloseDate = system.today();
                    opp.Eligible_for_Membership_Extension__c = true;
                    if(objData.campaignId!=null){
                        opp.CampaignId = objData.campaignId;
                    }
                    opp.Call_To_Action__c = objData.cta;
                    
                    
                    System.debug('CREATE ORDER OPPORTUNITY');
                    System.debug(opp);
                    
                    insert opp;
                    
                    OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=lstContact[0].Id, Role='Decision Maker');
                    insert contactRole;
                    
                    OpportunityId = opp.Id;
                    InvoiceNumber = opp.Display_Invoice_Number__c;
                    
                }
            }
            
        } else {
            
            Database.LeadConvert convertLead = new Database.LeadConvert();
            convertLead.setLeadId(objData.id);
            LeadStatus ls = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
            convertLead.setConvertedStatus(ls.MasterLabel);
            Database.LeadConvertResult lcr = Database.convertLead(convertLead);
            if (lcr.isSuccess()) {
                convertedLead = [SELECT ConvertedAccountId, ConvertedContactId, ConvertedDate, ConvertedOpportunityId, Marketing_Email_Creation__c, Email_Career_Center_Job_Board__c, Email_Chapter_Meetings__c, Email_CPE_News__c, Email_Daily_News__c, Email_GARP_Updates__c, Email_Information_Exchange__c, Email_Member_Update__c, Email_The_Week_in_Risk__c FROM Lead where id = : objData.id];
                system.debug('convertedLead ==' + convertedLead);
                contactId = convertedLead.ConvertedContactId;
                accountId = convertedLead.ConvertedAccountId;
                OpportunityId = convertedLead.ConvertedOpportunityId;
                Opportunity newOpp = [select Id, Display_Invoice_Number__c from Opportunity where Id = :OpportunityId];
                InvoiceNumber = newOpp.Display_Invoice_Number__c;
                if (objData.isFrmChecked != true && objData.isErpChecked != true && !objData.isIcbrChecked)
                    updateOpportunityinfoForMembers(OpportunityId, objData);
                
                // Opt user into all Pardot
                if(!Test.isRunningTest()){
                    pardotClass.optInUser(objData.Email);
                }
                
            }
        }
        
        acct = updateAccountInfo(objData, accountId);
        con = updateContactInfo(objData, contactId, convertedLead);
        
        Id membershipContract = CreateMemberShipContract(objData, accountId, OpportunityId, contactId, true);
        
        List<OpportunityLineItem> opportunityLineItems = createOppLineItems(OpportunityId, objData, vbord);
        
        system.debug(opportunityLineItems);
        
        // Close Opp is not value
        Boolean closeOpportunity = false;
        Decimal totalTransmount = 0;
        for(OpportunityLineItem eachOpportunityLineItem: opportunityLineItems){
            totalTransmount = totalTransmount + eachOpportunityLineItem.UnitPrice;
        }
        system.debug('totalTransmount:' + totalTransmount);
        
        if(totalTransmount == 0){
            closeOpportunity = true;
        }
        
        Id contractID;
        List < Candidate_Requirement__c > lstCandReqs;
        if ((objData.isFBRChecked != null && objData.isFBRChecked) || (objData.isFbraChecked != null && objData.isFbraChecked)) {
            contractID = CreateContract(accountId, objData, OpportunityId, contactId);
            lstCandReqs = createCandidateRequirements(contractID, objData);
        }
                
        if(objData.chapterMeetingId != null) {
            updateOpportunityinfo(objData, OpportunityId, true, false, false, vbord, closeOpportunity);
            setChapterMeetingRegistration(objData,contactId, OpportunityId, FALSE);
        } else if((objData.isEventChecked == true)){
            createEventRegistration(objData, contactId, accountId, OpportunityId, vbord, closeOpportunity); 
            updateOpportunityinfo(objData, OpportunityId, true, false, false, vbord, closeOpportunity);
        } else if (objData.isFbrChecked){
            updateOpportunityinfo(objData, OpportunityId, true, false, false, vbord, closeOpportunity);
        } else if (objData.isFrmChecked|| objData.isErpChecked || objData.isIcbrChecked){
            createExamAttempts(objData, contactId, accountId, OpportunityId, (objData.isFrmChecked == true || objData.isErpChecked == true), vbord, closeOpportunity);
        } else {
            updateOpportunityinfo(objData, OpportunityId, true, false, false, vbord, closeOpportunity);
        }
        
        // Create Opp for Affiliate Membership so they can view pending orders
        if(objData.paymentMethod != 'CC' && objData.Membership_Type != 'AFREE') {
            
            Opportunity opp = new Opportunity();
            opp.Name = 'Affiliate Membership';
            opp.Accountid = accountId;
            opp.StageName = 'New Lead';
            opp.CloseDate = system.today();
            opp.Eligible_for_Membership_Extension__c = true;
            opp.ChargentSFA__Billing_First__c = objData.FirstName;
            opp.ChargentSFA__Billing_Last__c = objData.LastName;
            opp.ChargentSFA__Billing_Email__c = objData.Email;
            opp.Alternate_Method_of_Payment__c = objData.paymentMethod;
            
            if(objData.campaignId!=null){
                opp.CampaignId = objData.campaignId;
            }
            
            INSERT opp;
            
            OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=contactId, Role='Decision Maker');
            
            INSERT contactRole;
            
            objData.Membership_Type = 'AFREE';
            objData.garpMembership_Type = 'AFREE';
            
            TempAccount.productDefinition productDefition = new TempAccount.productDefinition();
            
            productDefition.GLCode = '4999';
            productDefition.ProductCode = 'AFREE';
            
            objData.productcode1 = new TempAccount.productDefinition[]{ productDefition };   
            objData.ShippingOptionsString='';
            
            Id membershipAffiliateContract = CreateMemberShipContract(objData, acct.Id, opp.Id, con.Id, false);
            
            createOppLineItems(opp.Id, objData, null);
            opp.StageName = 'Closed';
            
            UPDATE opp; 
            
        }
        
        if(con != NULL) {
            returnWrapper.garpId = con.GARP_Member_ID__c;
            returnWrapper.company = con.Company__c;
        }
        
        returnWrapper.totalCost = dTotalPrice;
        returnWrapper.contactId = contactId;
        returnWrapper.opportunityId =OpportunityId ;
        returnWrapper.invoiceNumber =InvoiceNumber ;
        
        return returnWrapper;
        
        
    }
    
    public static wrapperCreateOrder createOrderForPortalUsers(TempAccount objData) {
        
        wrapperCreateOrder returnWrapper = new wrapperCreateOrder();
        
        verifyBulkOrderReturnData vbord;
        
        if(objData.promoCode != null) {
            vbord = verifyBulkOrder(objData);
            if(vbord.errorMSg != null) {
                returnWrapper.errorMsg = vbord.errorMSg;
                return returnWrapper;
            }
        }
        
        if(objData.sessionToken != NULL) {
            try {
                Utilities.updateFormSession(objData.sessionToken, objData.Email);
                Utilities.runCaptcha(objData.sessionToken);
            }catch(exception ex){
                return null;
            } 
        }
        
        bCreateMemContracts = false;
        
        Contact objContact = [
            SELECT 
            Id, 
            GARP_Member_ID__c, 
            Name, 
            FirstName,
            LastName,
            Email,
            Accountid, 
            Title, 
            Company__c, 
            ID_Number__c, 
            ID_Type__c, 
            Name_As_it_Appears_On_ID__c, 
            ID_Expiration_Date__c, 
            Full_Name_in_Chinese__c, 
            Gender__c, 
            Birthdate, 
            Currently_Working_Status__c, 
            Currently_in_School_Status__c, 
            Degree_Program_Name__c, 
            School_Name__c, 
            HomePhone, 
            MailingCity, 
            MailingCountry, 
            MailingPostalCode, 
            MailingState, 
            MailingStreet,
            Account.BillingCity,
            Account.BillingCountry,
            Account.BillingPostalCode,
            Account.BillingState,
            Account.BillingStreet
            FROM Contact 
            WHERE Id = :objData.contactId
        ];        
        
        if(objContact != null){
            
            Set<String> subscriptions = new Set<String>();
            
            if(objData.emailEventsSubscription != null && objData.emailEventsSubscription){
                subscriptions.add('Conferences & Workshops');
            }
            if(objData.emailWebcastsSubscription != null && objData.emailWebcastsSubscription){
                subscriptions.add('Webcasts');
            }
            if(objData.emailChapterMeetingsSubscription != null && objData.emailChapterMeetingsSubscription){
                subscriptions.add('Chapter Meetings');
            }
            
            if(objData.emailSubscriptions != NULL && objData.emailSubscriptions.length() > 0) {
                String[] arrSubscriptions = objData.emailSubscriptions.split(';');
                for(String s :arrSubscriptions) {
                    subscriptions.add(s);
                }
            }
            
            // Move Form Data
            Utilities.migrateLeadFormDataToContact(null, objContact.Id, objData.formName, subscriptions);

        }
                
        // Update Contact if Company or Title is passed
        if(objData.Company != null){
            objContact.Company__c = objData.Company;
        }
        
        if(objData.jobtitle != null){
            objContact.Title = objData.jobtitle;
        }
        
        if(objData.Title != null){
            objContact.Corporate_Title__c = objData.Title;
        }
        
        if(objData.JobFunction != null){
            objContact.Job_Function__c = objData.JobFunction;
        }

        if(objData.RiskSpecialty != null){
            objContact.Risk_Specialty__c = objData.RiskSpecialty;
        }
        
        if(objData.Industry != null){
            objContact.Area_of_Concentration__c = objData.Industry;
        }
        
        if(objData.Company != null || objData.jobtitle != null) {
            UPDATE objContact;
        }
        
        // Exam Info
        if(objData.idName != NULL && objData.idName.length() > 0){
            objContact.Name_As_it_Appears_On_ID__c = objData.idName;
        }
        
        if(objData.idType != null && objData.idType.length() > 0){
            objContact.ID_Type__c = objData.idType;
        }
        
        if(objData.idNumber != null && objData.idNumber.length() > 0){
            objContact.ID_Number__c = objData.idNumber;
        }
        
        if(objData.Birthdate != null && objData.Birthdate.length() > 0){
            objContact.Birthdate = date.parse(objData.Birthdate);
        }
        
        if(objData.Gender != null && objData.Gender.length() > 0){
            objContact.Gender__c = objData.Gender;
        }
        
        if(objData.ID_Expiration_Date != null && objData.ID_Expiration_Date.length() > 0){
            objContact.ID_Expiration_Date__c = date.parse(objData.ID_Expiration_Date);
        }
        
        if(objData.Full_Name_in_Chinese != null && objData.Full_Name_in_Chinese.length() > 0){
            objContact.Full_Name_in_Chinese__c = objData.Full_Name_in_Chinese;
        }
        
        if(objData.HomePhone != null && objData.HomePhone.length() > 0){
            objContact.HomePhone = objData.HomePhone;
        }
        
        if(objData.isWorking != Null) {
            if(objData.isWorking == true){
                objContact.Currently_Working_Status__c = 'Working';
            } else {
                objContact.Currently_Working_Status__c = 'Not Working';
            }
        }
        
        if(objData.inSchool != Null) {
            if(objData.inSchool == true){
                objContact.Currently_in_School_Status__c = 'In School';
            } else {
                objContact.Currently_in_School_Status__c = 'Not In School';
            }
        }
        
        objContact.School_Name__c = objData.School;
        objContact.Degree_Program_Name__c = objData.Degree_Program_Name;
        
        Boolean foundERP1=false;
        Boolean foundERP2=false;
        Boolean foundFRM1=false;
        Boolean foundFRM2=false;
        Boolean membershipEligible = false;
        
        Set<String> prodCodes = new Set<String>();
        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            if(objProdDef.ProductCode == 'FRM1E' || objProdDef.ProductCode == 'FRM1S' || objProdDef.ProductCode == 'FRM1L')
                foundFRM1=true;
            if(objProdDef.ProductCode == 'FRM2E' || objProdDef.ProductCode == 'FRM2S' || objProdDef.ProductCode == 'FRM2L')
                foundFRM2=true;
            if(objProdDef.ProductCode == 'ENC1E' || objProdDef.ProductCode == 'ENC1S' || objProdDef.ProductCode == 'ENC1L')
                foundERP1=true;
            if(objProdDef.ProductCode == 'ENC2E' || objProdDef.ProductCode == 'ENC2S' || objProdDef.ProductCode == 'ENC2L')
                foundERP2=true;
            prodCodes.add(objProdDef.ProductCode);
        }        
        
        if(prodCodes.contains('MEMI') || prodCodes.contains('MEMF') || prodCodes.contains('MEMS')){
            membershipEligible = true;
        }
        
        Opportunity oppRecord; 
        
        if(foundFRM1==true || foundFRM2==true || foundERP1==true || foundERP2==true) {       
            
            List<Exam_Attempt__c> lstExamApptempts = [select Id, Name, Section__c from Exam_Attempt__c where Member__c = :objContact.ID and Exam_Site__r.Exam__r.Exam_Group__r.Active__c = true and Cancelled__c = false and Opportunity_StageName__c != 'Closed Lost' and Defered__c != 'Pending'];
            
            system.debug('lstExamApptempts:' + lstExamApptempts);
            
            for(Exam_Attempt__c ea :lstExamApptempts) {
                
                if(
                    (objData.isFrmChecked && ea.Section__c.indexOf('ERP') > -1) ||
                    (objData.isErpChecked && ea.Section__c.indexOf('FRM') > -1)
                ){
                       returnWrapper.errorMsg = 'You are already registered for another exam in a different program.';
                       return returnWrapper; 
                }
                
                if(
                    (foundERP1 && ea.Section__c == 'ERP Exam Part I') ||
                    (foundERP2 && ea.Section__c == 'ERP Exam Part II') ||
                    (foundFRM1 && ea.Section__c == 'FRM Part 1') ||
                    (foundFRM1 && ea.Section__c == 'FRM Part 2')
                ) {
                    returnWrapper.errorMsg = 'You are already registered for this exam.';
                    return returnWrapper; 
                }
                
            }
            
            if(objData.eppHelp != NULL) {
                objContact.Exam_Prep_Provider_Outreach__c = objData.eppHelp;            
            }
            
            UPDATE objContact;
            
            oppRecord = CreateOpportunity(objContact, objData);
            returnWrapper.opportunityLineItems = createOppLineItems(oppRecord.Id, objData, vbord);
            
            Id paymentId = null;
            
            List <campaign> lstCam;   
            if(objData.campaignId != null){
                lstCam = [SELECT Id, Name FROM campaign WHERE Id = : objData.campaignId];
            }
            
            createExamAttempts(objData, objContact.Id, oppRecord.AccountId, oppRecord.Id, true, vbord, false);
            
        } else if (objData.isEventChecked != null && objData.isEventChecked) {
            
            if(membershipEligible){
                objData.MembershipEligible = true;
            }
            
            update objContact;
            
            oppRecord = CreateOpportunity(objContact, objData);
            
            List<OpportunityLineItem> opportunityLineItems = createOppLineItems(oppRecord.Id, objData, vbord);
            
            returnWrapper.opportunityLineItems = opportunityLineItems;
                        
            // Close Opp is not value
            Boolean closeOpportunity = false;
            Decimal totalTransmount = 0;
            for(OpportunityLineItem eachOpportunityLineItem: opportunityLineItems){
                totalTransmount = totalTransmount + eachOpportunityLineItem.UnitPrice;
            }           
            
            if(totalTransmount == 0){
                closeOpportunity = true;
            }            
            
            createEventRegistration(objData, objContact.Id, objContact.AccountId, oppRecord.Id, vbord, closeOpportunity);

        } else if(objData.chapterMeetingId != null) {
            
            if(membershipEligible){
                objData.MembershipEligible = true;
            }
            
            oppRecord = CreateOpportunity(objContact, objData);
            returnWrapper.opportunityLineItems = createOppLineItems(oppRecord.Id, objData, vbord);
            setChapterMeetingRegistration(objData,objContact.Id, oppRecord.Id, FALSE);
            
        } else {
            
            if(membershipEligible){
                objData.MembershipEligible = true;
            }
            
            UPDATE objContact;
            
            oppRecord = CreateOpportunity(objContact, objData);
 
            returnWrapper.opportunityLineItems = createOppLineItems(oppRecord.Id, objData, vbord); 
            
        }
        
        if(objContact != NULL) {
            returnWrapper.contactId = objContact.Id;
            returnWrapper.garpId = objContact.GARP_Member_ID__c;        
        }
        if(oppRecord != null) {
            returnWrapper.opportunityId =oppRecord.Id;        
        }
        returnWrapper.totalCost = dTotalPrice;
        
        return returnWrapper;        
        
        
    }    
    
    public static void updateOpportunityinfoForMembers(Id recordId,TempAccount objData) {
        Opportunity opp = [select id, Eligible_for_Membership_Extension__c from opportunity where id = : recordId];
        
        if(objData.autoRenew == true) {
            opp.Auto_Renew__c=true;
        }
        opp.Eligible_for_Membership_Extension__c = true;
        
        update opp;
    }
    
    public Boolean changeExamSite(String examAttemptId, String newExamSiteId) {
        Exam_Attempt__c ea = [select Id, Name, Exam_Site__c from Exam_Attempt__c where Id = :examAttemptId];
        if(ea != null) {
            ea.Exam_Site__c = newExamSiteId;
            update ea;
            return true;
        }
        
        return false;
    }
    
    public static set < String > getActiveSites() {
        
        set < String > lstSiteNames = new set < String > ();
        String strQuery = 'select id,Site__c,Exam__c,site__r.name from Exam_Sites__c where site__r.Active__c = true and site__r.Non_selectable__c = false  and Exam__r.Exam_Group__r.Active__c = true';
        if (siteID != null)
            strQuery += ' and site__c =:siteID';
        system.debug('strQuery == ' + strQuery);
        for (Exam_Sites__c obj: Database.query(strQuery)) {
            lstSiteNames.add(obj.site__r.name);
        }
        return lstSiteNames;
    }
    
    public static Boolean returnBool(Boolean inBool) {
        if (inBool == null)
            return false;
        else return inBool;
    }
    
    // Updated per [US-22986]
    public static Contact updateContactInfo(TempAccount objData, Id recordId, Lead convertedLead) {
        
        Contact con = [
            SELECT id, GARP_ID_New__c, Title, GARP_Member_ID__c, Faculty_Reference__c, Degree_Program_Name__c, MailingCity, Other_Qualifications__c, Mailing_Address_Company__c, MailingCountry, MailingState, MailingPostalCode, MailingStreet, Middle_Initial__c, Nickname__c, Professional_Designation_CPA__c, Professional_Designation_Other__c, Professional_Designation_CA__c, professional_Designation_CFA__c, Professional_Designation_PMP__c, Email, Currently_in_School__c, School_Name__c, Company__c, Membership_Type__c, FirstName, HomePhone, Job_Function__c, Risk_Specialty__c, LastName, MobilePhone, Suffix__c, KPI_Membership_Auto_Renew_Orig_Status__c, Name_As_it_Appears_On_ID__c, ID_Type__c, ID_Number__c, ID_Expiration_Date__c, Full_Name_in_Chinese__c, Gender__c, Birthdate, Currently_Working_Status__c, Currently_in_School_Status__c 
            FROM contact 
            WHERE id = :recordId
        ];
        
        String strNameByProdcutCode = '';
        
        if(con.GARP_Member_ID__c == null){
            con.GARP_Member_ID__c = con.GARP_ID_New__c;
        }
        
        con.Degree_Program_Name__c = objData.Degree_Program_Name;
        con.Email = objData.Email;
        
        con.Title = objData.jobtitle;
        con.FirstName = objData.FirstName;
        con.HomePhone = objData.HomePhone;
        con.MobilePhone = objData.MobilePhone;
        
        con.Job_Function__c = objData.JobFunction;
        con.Risk_Specialty__c = objData.RiskSpecialty;
        con.Corporate_Title__c = objData.Title;
        con.Area_of_Concentration__c = objData.Industry;
        
        con.LastName = objData.LastName;
        con.Mailing_Address_Company__c = objData.MailingCompany;
        con.MailingCity = objData.MailingCity;
        con.MailingCountry = objData.MailingCountry;
        con.MailingStreet = objData.MailingStreet;
        
        if(objData.MailingStreetTwo != null && objData.MailingStreetTwo.length() > 0){
            con.MailingStreet += '\n' + objData.MailingStreetTwo;
        }
        
        if(objData.MailingStreetThree != null && objData.MailingStreetThree.length() > 0){
            con.MailingStreet += '\n' + objData.MailingStreetThree;
        }
        
        con.Company__c = objData.Company;
        con.Middle_Initial__c = objData.MiddleInitial;
        con.Suffix__c = objData.Salutation;
        con.MailingPostalCode = objData.MailingPostalCode;
        con.MailingState = objData.MailingState;
        
        if (objData.isFrmChecked == true || objData.isErpChecked == true){
            con.Membership_Type__c = 'Individual';
        }
        
        con.Professional_Designation_CA__c = returnBool(objData.CA);
        con.Professional_Designation_CFA__c = returnBool(objData.CFA);
        con.Professional_Designation_PMP__c = returnBool(objData.PMP);
        con.Professional_Designation_CPA__c = returnBool(objData.CPA);
        con.Professional_Designation_ACCA__c = returnBool(objData.ACCA);
        con.Professional_Designation_CMA__c = returnBool(objData.CMA);
        con.Professional_Designation_Other__c = returnBool(objData.OtherDesignation);
        
        if (objData.OtherDesignation == true){
            con.Other_Qualifications__c = objData.OtherDesignationText;
        }
        
        con.Nickname__c = objData.NickName;
        con.Currently_in_School__c = returnBool(objData.inSchool);
        
        // Protect Updates        
        if(objData.idName != NULL && objData.idName.length() > 0){
            con.Name_As_it_Appears_On_ID__c = objData.idName;
        }
        
        if(objData.idType != null && objData.idType.length() > 0){
            con.ID_Type__c = objData.idType;
        }
        
        if(objData.idNumber != null && objData.idNumber.length() > 0){
            con.ID_Number__c = objData.idNumber;
        }
        
        if(objData.Birthdate != null && objData.Birthdate.length() > 0){
            con.Birthdate = date.parse(objData.Birthdate);
        }
        
        if(objData.Gender != null && objData.Gender.length() > 0){
            con.Gender__c = objData.Gender;
        }
        
        if(objData.ID_Expiration_Date != null && objData.ID_Expiration_Date.length() > 0){
            con.ID_Expiration_Date__c = date.parse(objData.ID_Expiration_Date);
        }
        
        if(objData.Full_Name_in_Chinese != null && objData.Full_Name_in_Chinese.length() > 0){
            con.Full_Name_in_Chinese__c = objData.Full_Name_in_Chinese;
        }
        
        if(objData.HomePhone != null && objData.HomePhone.length() > 0){
            con.HomePhone = objData.HomePhone;
        }
        
        if(objData.isWorking != Null) {
            if(objData.isWorking == true){
                con.Currently_Working_Status__c = 'Working';
            }else{
                con.Currently_Working_Status__c = 'Not Working';
            }
        }
        
        if(objData.inSchool != Null) {
            if(objData.inSchool == true){
                con.Currently_in_School_Status__c = 'In School';
            }else{
                con.Currently_in_School_Status__c = 'Not In School';
            }
        }
        
        con.School_Name__c = objData.School;
        con.Degree_Program_Name__c = objData.Degree_Program_Name;
        con.KPI_Membership_Auto_Renew_Orig_Status__c = returnBool(objData.autoRenew);
        con.Exam_Prep_Provider_Outreach__c = objData.eppHelp;
        con.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
        
        if (objData.isStudentChecked != null && objData.isStudentChecked) {
            con.Faculty_Reference__c = objData.facultyReference;
            con.Faculty_Reference_Email_Address__c = objData.facultyReferenceEmail;
            con.Expected_Graduation_Date__c = objData.graduationDate;
        }
        
        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            if (objProdDef.ProductCode == 'AFREE') {
                con.Membership_Type__c = 'Afiliate';                
            } else if (objProdDef.ProductCode == 'MEMI' || objProdDef.ProductCode == 'MEMF') {
                con.Membership_Type__c = 'Individual';
            } else if (objProdDef.ProductCode == 'MEMS') {
                con.Membership_Type__c = 'Student';
            }
        }
        
        if(convertedLead != NULL) {
            
            Set<String> subscriptions = new Set<String>();
            
            if(objData.emailEventsSubscription != null && objData.emailEventsSubscription){
                subscriptions.add('Conferences & Workshops');
            }
            if(objData.emailWebcastsSubscription != null && objData.emailWebcastsSubscription){
                subscriptions.add('Webcasts');
            }
            if(objData.emailChapterMeetingsSubscription != null && objData.emailChapterMeetingsSubscription){
                subscriptions.add('Chapter Meetings');
            }
            
            if(objData.emailSubscriptions != NULL && objData.emailSubscriptions.length() > 0) {
                String[] arrSubscriptions = objData.emailSubscriptions.split(';');
                for(String s :arrSubscriptions) {
                    subscriptions.add(s);
                }
            }
            
            // Move Form Data
            Utilities.migrateLeadFormDataToContact(convertedLead.id, con.Id, objData.formName, subscriptions);
            
            // Assign MC Unique ID
            con.MC_Unique_Id__c = convertedLead.Id;
            
        }
        
        con.Created_From_Flow__c = true;
        con.do_not_fire__c = false;
        
        UPDATE con;
        
        return con;
        
    }
    
    public static Account updateAccountInfo(TempAccount objData, Id recordId) {
        Account acc = [select id, Billing_Address_Company__c, BillingCity, BillingCountry, BillingStreet, BillingPostalCode, BillingState, ShippingState, ShippingPostalCode, ShippingStreet, ShippingCity, ShippingCountry, Type from Account where id = : recordId];
        
        if (acc != null) {
            acc.BillingCity = objData.BillingCity;
            acc.BillingCountry = objData.BillingCountry;
            acc.Billing_Address_Company__c = objData.BillingCompany;
            acc.BillingStreet = objData.BillingStreet;
            
            if(objData.BillingStreetTwo != null && objData.BillingStreetTwo.length() > 0)
                acc.BillingStreet += '\n' + objData.BillingStreetTwo;
            if(objData.BillingStreetThree != null && objData.BillingStreetThree.length() > 0)
                acc.BillingStreet += '\n' + objData.BillingStreetThree;
            
            acc.BillingPostalCode = objData.BillingPostalCode;
            acc.BillingState = objData.BillingState;
            
            acc.ShippingCity = objData.MailingCity;
            acc.ShippingCountry = objData.MailingCountry;
            acc.ShippingStreet = objData.MailingStreet;
            
            if(objData.MailingStreetTwo != null && objData.MailingStreetTwo.length() > 0)
                acc.ShippingStreet += '\n' + objData.MailingStreetTwo;
            if(objData.MailingStreetThree != null && objData.MailingStreetThree.length() > 0)
                acc.ShippingStreet += '\n' + objData.MailingStreetThree;
            
            acc.ShippingPostalCode = objData.MailingPostalCode;
            acc.ShippingState = objData.MailingState;
            
            acc.Type = objData.Organization;
            acc.recordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Individual');
            acc.ownerid = userid;
        }
        update acc;
        
        return acc;
    }
    
    public static void updateOpportunityinfo(TempAccount objData, Id recordId, boolean basicInfoOnly, boolean bCheckMemExtn, boolean bIsPortalUser, verifyBulkOrderReturnData vbord, Boolean closeOpportunity) {
        
        opportunity opp = [select id, Name, StageName, Event_Order__c, Shipping_First_Name__c, Shipping_Last_Name__c, Shipping_Phone_No__c, 
                           Shipping_E_mail__c, Shipping_Serive_Selected__c, Shipping_Company_Name__c, Shipping_Street__c, 
                           Shipping_Country__c, Shipping_City__c, Shipping_Postal_Code__c, Shipping_State__c, Call_To_Action__c,
                           Switch_to_erp__c, Has_Books__c, Switch_to_frm__c, Eligible_for_Membership_Extension__c, Auto_Renew__c from opportunity where id = : recordId];
        
        opp.Shipping_First_Name__c = objData.FirstName;
        opp.Shipping_Last_Name__c = objData.LastName;
        opp.Shipping_Phone_No__c = objData.HomePhone;
        opp.Shipping_E_mail__c = objData.Email;
        
        if(objData.campaignId!=null)
            opp.CampaignId = objData.campaignId;        
        
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
        
        String strUPSDesc='';
        if (objData.ShippingOptionsString != '' && objData.ShippingOptionsString != null) {
            String[] arrShippingInfo = objData.ShippingOptionsString.split(',');
            if (arrShippingInfo != null && arrShippingInfo.size() > 0) {
                String[] arrPriceInfo = arrShippingInfo[0].split(':');
                String[] arrUPSDesc = arrShippingInfo[1].split(':');
                if(arrUPSDesc.size() > 1)
                    strUPSDesc = arrUPSDesc[1];
                //strUPSDesc = strUPSDesc.replace('"', '').replace('{', '').replace('}', '');
            }
        }
        
        opp.Shipping_Serive_Selected__c = strUPSDesc;
        
        opp.Switch_to_erp__c = returnBool(objData.erpSwitch);
        
        if(vbord == null || vbord.bord == null || vbord.bord.oppData == null || vbord.bord.oppData.size() == 0)
            opp.Has_Books__c = returnBool(objData.hasBooks);
        
        for (TempAccount.productDefinition objProd: objData.productcode1) {
            if(opp.Has_Books__c == true) {
                if (objProd.ProductCode == 'FRM1E' || objProd.ProductCode == 'FRM1L' || objProd.ProductCode == 'FRM1S')
                    opp.Books_FRM_I__c=true;
                else if (objProd.ProductCode == 'FRM2E' || objProd.ProductCode == 'FRM2L' || objProd.ProductCode == 'FRM2S')
                    opp.Books_FRM_II__c=true;
                
                // ERP Split
                //else if (objProd.ProductCode == 'ENCE' || objProd.ProductCode == 'ENCL' || objProd.ProductCode == 'ENCS')
                //    opp.Books_ERP__c=true;
                if (objProd.ProductCode == 'ENC1E' || objProd.ProductCode == 'ENC1L' || objProd.ProductCode == 'ENC1S')
                    opp.Books_ERP_I__c=true;
                else if (objProd.ProductCode == 'ENC2E' || objProd.ProductCode == 'ENC2L' || objProd.ProductCode == 'ENC2S')
                    opp.Books_ERP_II__c=true;
                
                else if(objData.isFBRChecked)
                    opp.Books_FBR__c=true;
                else if (objData.isIcbrChecked)
                    opp.Books_ICBRR__c=true;
            }
        }
        
        if(basicInfoOnly == false) {
            opp.Switch_to_frm__c = returnBool(objData.frmSwitch);
            if (bIsPortalUser) {
                opp.Eligible_for_Membership_Extension__c = bCheckMemExtn;
            } else {
                if(objData.MembershipEligible != NULL)
                    opp.Eligible_for_Membership_Extension__c = objData.MembershipEligible;
                else opp.Eligible_for_Membership_Extension__c = true;
            }
            
            opp.Auto_Renew__c = returnBool(objData.autorenew);            
        }
        
        if(vbord != null && vbord.bord != null && vbord.bord.oppData != null && vbord.bord.oppData.size() > 0) {
            opp.Institutional_Sale__c = true;
            opp.Inst_Sale_Opp__c = vbord.bord.oppData[0].Id;
            if(vbord.bord.oppData[0].StageName == 'Closed' && vbord.bord.oppData[0].Inst_Sale_Emails__c != null){
                opp.StageName = 'Closed';
            }
        } else if(closeOpportunity == true) {
            opp.StageName = 'Closed';
        }
        opp.Call_To_Action__c = objData.cta;
        
        setOpportunityName(objData, opp);        
        system.debug('* * * Update Opp:'+opp);
        
        update opp;        
    }
    
    public static List < Exam__c > getExamDetails(List < String > lstExamNames) {
        List < Exam__c > lstExamDetails = [select id, Exam__c, Exam_Group__r.Early_Exam_Registration_Fee__c, Exam_Date__c, Exam_Group__r.Standard_Exam_Registration_Fee__c, Exam_Group__r.Late_Exam_Registration_Fee__c, Exam_Group__r.Last_Date_For_Early_Registration__c, Exam_Group__r.Last_Date_For_Standard_Registration__c, Exam_Group__r.Last_Date_For_Late_Registration__c from Exam__c where Exam__c in : lstExamNames and Exam_Group__r.Active__c = true];
        return lstExamDetails;
        
    }
    
    public static Map < String, decimal > getExamFee(List < Exam__c > lstExamDetails) {
        if (lstExamDetails == null) return null;
        Map < String, decimal > mapExamFees = new Map < String, decimal > ();
        Decimal dExamFee = 0;
        for (Exam__c objExam: lstExamDetails) {
            if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Early_Registration__c)
                dExamFee = objExam.Exam_Group__r.Early_Exam_Registration_Fee__c;
            else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Standard_Registration__c)
                dExamFee = objExam.Exam_Group__r.Standard_Exam_Registration_Fee__c;
            else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Late_Registration__c)
                dExamFee = objExam.Exam_Group__r.Late_Exam_Registration_Fee__c;
            
            mapExamFees.put(objExam.Exam__c, dExamFee == null ? 0 : dExamFee);
        }
        return mapExamFees;
    }
    
    public static List < OpportunityLineItem > createOppLineItems(Id oppId, TempAccount objData, verifyBulkOrderReturnData vbord) {
        List < OpportunityLineItem > lstOppLineItems = new List < OpportunityLineItem >();
        system.debug('productcode1 == ' + objData.productcode1);
        if (objData.productcode1 == null) return lstOppLineItems;
        
        Team_Registration__c teamRegUsed;
        
        Decimal dExamFee = 0;
        String strNameByProdcutCode = '';
        List < String > lstExamNames = new List < String > ();
        boolean bFrm1 = false;
        boolean bFrm2 = false;
        decimal dShipPrice = 0;
        String strUPSDesc = '';
        boolean isMembershipBeingPurchasedOrGoodIndividualStudent = false;
        
        Id userId = UserInfo.getUserId();
        
        List<User> users = [
            SELECT Id, ContactId, AccountId 
            FROM User
            WHERE Id = :userId
        ];        
        System.debug('users:' + users);
        
        Id contactId = null;
        if(!users.isEmpty() && users[0].ContactId != null && users[0].AccountId != null){
            contactId = users[0].ContactId;
        }else{
            contactId = objData.contactId;
        }
        
        Set<String> setProdCodes = new Set <String>();
        Set<String> setGlCodes = new Set <String>();
        Set<String> setRelatedIdProductCodes = new Set <String>();
        Set<String> setRelatedIdGlCodes = new Set <String>();        
        Map<String, String> mapPrice = new Map<String, String>();
        Map<String, String> mapDesc = new Map<String, String>();
        Set<String> boughtProdGLs = new Set<String>();
        
        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            boughtProdGLs.add(objProdDef.ProductCode + ':' + objProdDef.GLCode);
            if(objProdDef.relatedId == null){
                setProdCodes.add(objProdDef.ProductCode);
                setGlCodes.add(objProdDef.GLCode);
                mapPrice.put(objProdDef.ProductCode,objProdDef.price);
                mapDesc.put(objProdDef.ProductCode,objProdDef.description);
            } else {
                setRelatedIdProductCodes.add(objProdDef.ProductCode);
                setRelatedIdGlCodes.add(objProdDef.GLCode);   
            }
        }
        
        system.debug('setProdCodes == ' + setProdCodes);
        system.debug('setGlCodes == ' + setGlCodes);
        
        system.debug('objData.ShippingOptionsString == ' + objData.ShippingOptionsString);
        
        Map < String, decimal > mapExamFees = getExamFee(getExamDetails(lstExamNames));
        if (objData.ShippingOptionsString != '' && objData.ShippingOptionsString != null) {
            String[] arrShippingInfo = objData.ShippingOptionsString.split(',');
            if (arrShippingInfo != null && arrShippingInfo.size() > 0) {
                String[] arrPriceInfo = arrShippingInfo[0].split(':');
                dShipPrice = decimal.valueOf(arrPriceInfo[1]);
                String[] arrUPSDesc = arrShippingInfo[1].split(':');
                strUPSDesc = arrUPSDesc[1];
                strUPSDesc = strUPSDesc.replace('"', '').replace('{', '').replace('}', '');
            }
        }
        
        system.debug('dShipPrice == ' + dShipPrice);
        system.debug('strUPSDesc == ' + strUPSDesc);
        
        decimal dTaxPrice = 0;
        if (objData.taxPrice != null) {
            dTaxPrice = objData.taxPrice;
            setProdCodes.add('SLSTX');
        }
        
        if (dShipPrice != 0){
            setProdCodes.add('SHIP');
        }
        
        //Set Exam Site Id for the CHLF OLI
        Id targetExamSiteId = null; 
        
        //Datamine Existing FRM Exams
        List<Exam_Attempt__c> examRegistrations = [
            SELECT Id, Exam_Name__c, Name, Reg_Status__c, Defered__c, Other_Exam_Registrations__c, Deferral_Status__c, Opportunity__c, Exam_Site__c, Exam_Site__r.Name, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.Site__r.Is_OSTA_Information_Required__c
            FROM Exam_Attempt__c 
            WHERE 
            (
                Exam_Site__r.Exam__r.Exam__c = 'FRM Part 1' OR
                Exam_Site__r.Exam__r.Exam__c = 'FRM Part 2' 
            ) AND
            Exam_Site__r.Exam__r.Exam_Group__r.Active__c = TRUE AND
            Member__c = :contactId AND 
            Cancelled__c = FALSE AND
            Opportunity__r.StageName = 'Closed'
            ORDER BY Exam_Site__r.Exam__r.Exam__c ASC
        ];
        
        //Datamine OSTA Programs
        List<Contract> ostaPrograms = new List<Contract>();
        
        
        if(contactId != null){      
            
            Contact contact = [
                SELECT Id, AccountId
                FROM Contact
                WHERE Id = :contactId
                LIMIT 1
            ];
            
            ostaPrograms = [
                SELECT Id, Name, Status, RecordType.Name
                FROM Contract
                WHERE 
                AccountId = :contact.AccountId AND
                RecordType.Name = 'OSTA Program' AND
                Status LIKE 'Activated%'
            ];
            
        } 
        
        System.debug(objData);
        System.debug(examRegistrations);
        
        if(objData.IsFrmChecked != null && objData.IsFrmChecked && objData.Membership_Type != 'AFREE' && examRegistrations.isEmpty()){  
            
            //Handles Exam Registrations
            
            if(objData.siteName != null && objData.siteName.contains('China') && !objData.siteName.contains('Hong Kong')){
                
                //Location Fee
                setGlCodes.add('2008');
                setProdCodes.add('CHLF'); 
                
                List<Exam_Sites__c> examSites = [
                    SELECT Id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c 
                    FROM Exam_Sites__c 
                    WHERE 
                    Site__r.Name = :objData.siteName AND 
                    Exam__r.Exam__c IN ('FRM Part 1', 'FRM Part 2') AND
                    Exam__r.Exam_Group__r.Active__c = TRUE
                    ORDER BY Exam__r.Exam__c ASC
                ];
                
                if(examSites.isEmpty()){
                    targetExamSiteId = 'a1e400000090DQq';
                }else{
                    targetExamSiteId = examSites[0].Id;
                }
                
                //OTSA Fee
                if(ostaPrograms.isEmpty()){                        
                    setGlCodes.add('2009');
                    setProdCodes.add('CHNDF');  
                }
                
            }
            
        }else if(objData.siteId != null && !examRegistrations.isEmpty()){
            
            //Handles Exam Site Switches
            
            String examName = examRegistrations[0].Exam_Name__c;
            
            if(examName != null && examName.contains('FRM')){
                
                List<Exam_Sites__c> targetExamSites = [
                    SELECT Id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c, Site__r.Is_OSTA_Information_Required__c
                    FROM Exam_Sites__c 
                    WHERE Id = :objData.siteId
                ];
                
                Boolean targetIsOstaInformationRequired = targetExamSites[0].Site__r.Is_OSTA_Information_Required__c;
                Boolean sourceIsOstaInformationRequired = examRegistrations[0].Exam_Site__r.Site__r.Is_OSTA_Information_Required__c;
                
                if(!sourceIsOstaInformationRequired && targetIsOstaInformationRequired){                         
                    
                    //Location Fee
                    setGlCodes.add('2008');
                    setProdCodes.add('CHLF'); 
                    targetExamSiteId = objData.siteId;
                    
                    //OTSA Fee
                    if(ostaPrograms.isEmpty()){                        
                        setGlCodes.add('2009');
                        setProdCodes.add('CHNDF');  
                    }
                    
                }
                
            }
            
        } 
        
        // Select Product Offer Rates
        MAP<String,Product_Rate_Offering__c> mapRates = new MAP<String,Product_Rate_Offering__c>();
        MAP<String,Product_Rate_Offering__c> mapDiscountRates = new MAP<String,Product_Rate_Offering__c>();
        LIST<Product_Rate_Offering__c> lstRates = [select id, Customer_Email__c, Offer_Amount__c, Current_Product__r.ProductCode, Current_Product__r.GL_Code__c, 
                                                   Contact__c, Attestation_Required__c,
                                                   Discount_Product__r.ProductCode, Discount_Product__r.GL_Code__c from Product_Rate_Offering__c where
                                                   Current_Product__r.ProductCode in :setProdCodes AND 
                                                   Current_Product__r.GL_Code__c in :setGLCodes AND 
                                                   Customer_Email__c = :objData.email AND Status__c = 'Active'];
        if(lstRates != NULL && lstRates.size() > 0) {
            for(Product_Rate_Offering__c por :lstRates) {
                        
                if(por.Discount_Product__r != NULL) {
                    setProdCodes.add(por.Discount_Product__r.ProductCode);
                    setGlCodes.add(por.Discount_Product__r.GL_Code__c);    
                    mapDiscountRates.put(por.Discount_Product__r.ProductCode + ':' + por.Discount_Product__r.Gl_Code__c, por);                        
                }
                mapRates.put(por.Current_Product__r.ProductCode + ':' + por.Current_Product__r.Gl_Code__c, por);    
            }
        }     
        System.debug('mapRates:' + mapRates);
        System.debug('mapDiscountRates:' + mapDiscountRates);
        
        
        // Team Registrations
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
        System.debug('mapRates:' + mapRates);
        System.debug('mapDiscountRates:' + mapDiscountRates);        
        
        List<PriceBookEntry> lstPrice = [SELECT Id, UnitPrice, ProductCode, Product2Id, Product2.Gl_Code__c, Product2.Name  
            FROM PriceBookEntry 
            WHERE 
            IsActive = TRUE AND
            Pricebook2.IsActive = TRUE AND 
            ProductCode IN :setProdCodes AND 
            Product2.Gl_Code__c IN :setGlCodes];
        
        MAP<String,PriceBookEntry> mapPriceBook = new MAP<String,PriceBookEntry>();
        for(PriceBookEntry pbe :lstPrice) {
            mapPriceBook.put(pbe.ProductCode + ':' + pbe.Product2.Gl_Code__c,pbe);
        }
        System.debug('mapPriceBook:' + mapPriceBook);
        
        for (PriceBookEntry PricebookEntryId: mapPriceBook.values()){
            
            System.debug('PricebookEntryId:' + PricebookEntryId);
            
            // Check it Prod Code + GL Code Combo exists
            if(!boughtProdGLs.contains(PricebookEntryId.ProductCode + ':' + PricebookEntryId.Product2.Gl_Code__c)) {
                continue;
            }
            
            dExamFee = PricebookEntryId.UnitPrice;
            
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            
            oppLineItem.OpportunityId = oppId;
            oppLineItem.PricebookEntryId = PricebookEntryId.Id;
            oppLineItem.Quantity = 1;
            
            Product_Rate_Offering__c fndDiscountRate = mapDiscountRates.get(PricebookEntryId.ProductCode + ':' + PricebookEntryId.Product2.Gl_Code__c);
            System.debug('fndDiscountRate:' + fndDiscountRate);
            if(fndDiscountRate != NULL) {
                continue;
            }
            
            // Set Rate Offer
            Product_Rate_Offering__c fndRate = mapRates.get(PricebookEntryId.ProductCode + ':' + PricebookEntryId.Product2.Gl_Code__c);
            System.debug('fndRate:' + fndRate);
            
            if(fndRate != NULL && fndRate.Discount_Product__r.ProductCode != NULL && fndRate.Discount_Product__r.GL_Code__c != NULL) {
                PriceBookEntry fndPrice = mapPriceBook.get(fndRate.Discount_Product__r.ProductCode + ':' + fndRate.Discount_Product__r.GL_Code__c);
                System.debug('fndPrice:' + fndPrice);
                
                if(fndPrice != NULL) {
                    
                    // Add Discount Product
                    OpportunityLineItem oppLineItemRate = new OpportunityLineItem();
                    oppLineItemRate.OpportunityId = oppId;
                    oppLineItemRate.PricebookEntryId = fndPrice.Id;
                    oppLineItemRate.Quantity = 1; 
                    oppLineItemRate.UnitPrice = (PricebookEntryId.UnitPrice - fndRate.Offer_Amount__c) * -1;
                    dTotalPrice += oppLineItemRate.UnitPrice;
                    
                    System.debug('oppLineItemRate:' + oppLineItemRate);
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
            
            // Bulk Orders
            if(vbord != null && vbord.bord != null && vbord.bord.oppData != null && vbord.bord.oppData.size() > 0) {
                if (
                    PricebookEntryId.productcode == 'FRM1E' || 
                    PricebookEntryId.productcode == 'FRM1S' || 
                    PricebookEntryId.productcode == 'FRM1L' ||
                    PricebookEntryId.productcode == 'FBRNM' || 
                    PricebookEntryId.productcode == 'CBRNM'
                ){
                    oppLineItem.PricebookEntryId = vbord.bord.bulkOrderExam1Product.priceBookEntryId;                    
                    dExamFee = Decimal.valueOf(vbord.bord.bulkOrderExam1Product.price);
                } else if (PricebookEntryId.productcode == 'FRM2E' || PricebookEntryId.productcode == 'FRM2S' || PricebookEntryId.productcode == 'FRM2L') {
                    oppLineItem.PricebookEntryId = vbord.bord.bulkOrderExam2Product.priceBookEntryId;                    
                    dExamFee = Decimal.valueOf(vbord.bord.bulkOrderExam1Product.price);
                } else if (PricebookEntryId.productcode == 'ENC1E' || PricebookEntryId.productcode == 'ENC1S' || PricebookEntryId.productcode == 'ENC1L') {
                    oppLineItem.PricebookEntryId = vbord.bord.bulkOrderExam1Product.priceBookEntryId;                    
                    dExamFee = Decimal.valueOf(vbord.bord.bulkOrderExam1Product.price);
                } else if (PricebookEntryId.productcode == 'ENC2E' || PricebookEntryId.productcode == 'ENC2S' || PricebookEntryId.productcode == 'ENC2L') {
                    oppLineItem.PricebookEntryId = vbord.bord.bulkOrderExam2Product.priceBookEntryId;                    
                    dExamFee = Decimal.valueOf(vbord.bord.bulkOrderExam1Product.price);
                } else if (PricebookEntryId.productcode == 'FRM1') {
                    oppLineItem.PricebookEntryId = vbord.bord.bulkOrderExamEnrollment.priceBookEntryId;                    
                    dExamFee = Decimal.valueOf(vbord.bord.bulkOrderExamEnrollment.price);                    
                } else if (PricebookEntryId.productcode == 'ENC') {
                    oppLineItem.PricebookEntryId = vbord.bord.bulkOrderExamEnrollment.priceBookEntryId;                    
                    dExamFee = Decimal.valueOf(vbord.bord.bulkOrderExamEnrollment.price);                    
                }
            }
            
            //Switch fees
            if (dExamFee == null){
                dExamFee = 0;
            }
            
            if ((objData.erpSwitch != null && objData.erpSwitch) && pricebookEntryId.productcode.indexOf('ENC') >= 0){
                dExamFee = Decimal.valueOf(((mapPrice != null && mapPrice.get(pricebookEntryId.productcode) != null) ? mapPrice.get(pricebookEntryId.productcode) : '0'));
            }
            
            if (objData.frmSwitch != null && objData.frmSwitch){
                dExamFee = Decimal.valueOf(((mapPrice != null && mapPrice.get(pricebookEntryId.productcode) != null) ? mapPrice.get(pricebookEntryId.productcode) : '0'));
            }
            
            if (pricebookEntryId.productcode.indexOf('MISC') >= 0 || PricebookEntryId.productcode == 'CBRHB' || PricebookEntryId.productcode == 'FBRHB' || PricebookEntryId.productcode == 'CHMT1'){
                dExamFee = Decimal.valueOf(((mapPrice != null && mapPrice.get(pricebookEntryId.productcode) != null) ? mapPrice.get(pricebookEntryId.productcode) : '0'));
                String descString = mapDesc.get(pricebookEntryId.productcode);
                if(descString != null)
                    oppLineItem.Description = descString;
            }
            
            //Switch Fees End Here
            if (PricebookEntryId.productcode == 'SHIP') {
                dExamFee = dShipPrice.setScale(2);
                oppLineItem.Description = strUPSDesc;
            }
            
            if (PricebookEntryId.productcode == 'SLSTX') {
                dExamFee = dTaxPrice;
            }
            
            if (PricebookEntryId.productcode == 'MEMW') {
                oppLineItem.Quantity = 12;
            }
            
            if (PricebookEntryId.productcode == 'MEMR') {
                oppLineItem.Quantity = 12;
                oppLineItem.TotalPrice = 100.00;
                dTotalPrice += 100;
                lstOppLineItems.add(oppLineItem);
                continue;
            }

            if (PricebookEntryId.productcode == 'CHNDF') {
                oppLineItem.UnitPrice       = PricebookEntryId.UnitPrice;
                dExamFee                    = PricebookEntryId.UnitPrice;
            }   
            
            if (PricebookEntryId.productcode == 'CHLF') {
               
                List<Exam_Sites__c> examSites = [
                    SELECT Id, Name, Exam__r.Name, Site__r.Name, Exam__r.Exam_Date__c
                    FROM Exam_Sites__c
                    WHERE Id = :targetExamSiteId
                ];
                
                Exam_Sites__c examSite = examSites[0];
                
                Date d = examSite.Exam__r.Exam_Date__c;
                Time t = Time.newInstance(0, 0, 0, 0);
                
                Datetime dt = Datetime.newInstance(d, t);
                
                String examName = examSite.Exam__r.Name;
                
                if(examName.indexOf('FRM') >= 0){
                    examName = 'FRM';
                }else if(examName.indexOf('ERP') >= 0){
                    examName = 'ERP';
                }
                
                //Example: Exam: FRM – Exam Date: Saturday, May 19 2019 – Exam Site: China, Wuhan
                String description = 'Exam: ' + examName + ' - Exam Date: ' + dt.format('EEEE, MMMM dd YYYY', 'America/New_York') + ' - Exam Site: ' + examSite.Site__r.Name;
                
                if(examRegistrations.isEmpty()){
                    
                    //Exam Registration
                    oppLineItem.Exam_Site__c  = examSite.Id;
                    oppLineItem.Description   = description; 
                    oppLineItem.UnitPrice     = PricebookEntryId.UnitPrice;
                    
                    dExamFee = PricebookEntryId.UnitPrice;
                    
                }else{
                    
                    //Exam Site Switch
                    
                    Integer numberOfExamsInCurrentCycle = 1;
                    
                    for(Exam_Attempt__c examRegistration: examRegistrations){
                        
                        if(
                            numberOfExamsInCurrentCycle == 2 && 
                            examRegistration.Defered__c != 'Pending'
                        ){
                            continue;
                        }
                        
                        oppLineItem = new OpportunityLineItem(); 
                        
                        oppLineItem.Exam_Registration__c    = examRegistration.Id;
                        oppLineItem.Exam_Site__c            = examSite.Id;
                        oppLineItem.Description             = description; 
                        oppLineItem.UnitPrice               = PricebookEntryId.UnitPrice;
                        oppLineItem.OpportunityId           = oppId;
                        oppLineItem.PricebookEntryId        = PricebookEntryId.Id;
                        oppLineItem.Quantity                = 1;
                        
                        dExamFee = PricebookEntryId.UnitPrice;
                        dTotalPrice += dExamFee;
                        lstOppLineItems.add(oppLineItem);
                        
                        numberOfExamsInCurrentCycle++;
                        
                    } 
                    
                    continue;
                    
                }
                
            }
            
            if (
                (PricebookEntryId.productcode == 'FRM1' || PricebookEntryId.productcode == 'ENC') && 
                (objData.returning != null && objData.returning == true)
            ) {
                dExamFee = 250;
            }
            
            if (PricebookEntryId.productcode == 'EVTDSC') {
                String feePrice = mapPrice.get(pricebookEntryId.productcode);
                dExamFee = Decimal.valueOf(feePrice);
                String descString = mapDesc.get(pricebookEntryId.productcode);
                if(descString != null){
                    oppLineItem.Description = descString;
                }
            }
            
            oppLineItem.UnitPrice = dExamFee;
            dTotalPrice += dExamFee;
            lstOppLineItems.add(oppLineItem);
            
        }
        
        Map<String, PriceBookEntry> mapProdCodePriceBookEntry = new Map<String, PriceBookEntry>(); 
        
        for (PriceBookEntry pricebookEntry: [
            SELECT Id, unitprice, productcode, product2.Gl_Code__c 
            FROM PriceBookEntry 
            WHERE 
            Pricebook2.isActive = TRUE AND 
            Pricebook2.isActive = TRUE AND 
            Productcode IN :setRelatedIdProductCodes AND 
            Product2.Gl_Code__c IN :setRelatedIdGlCodes AND 
            isActive = true
        ]) {
            mapProdCodePriceBookEntry.put(pricebookEntry.productcode + '~' + pricebookEntry.product2.Gl_Code__c, pricebookEntry);
        }
        
        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            
            if(objProdDef.relatedId != null){
                
                System.debug('Related objProdDef:' + objProdDef);
                
                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                
                oppLineItem.OpportunityId = oppId;
                
                if(mapProdCodePriceBookEntry.containsKey(objProdDef.ProductCode + '~' + objProdDef.GLCode)){
                    
                    PriceBookEntry priceBookEntry = mapProdCodePriceBookEntry.get(objProdDef.ProductCode + '~' + objProdDef.GLCode);
                    
                    if(objProdDef.description != null){
                        oppLineItem.Description = objProdDef.description;
                    }
                    
                    /**
                    * We should remove/protect this condition, as it could 
                    * allow a malicious user to override the UnitPrice by
                    * defining a price on the objProdDef.
                    */ 
                    if(objProdDef.price != null){
                        oppLineItem.UnitPrice = Decimal.valueOf(objProdDef.price);
                    }else{
                        oppLineItem.UnitPrice = priceBookEntry.UnitPrice;
                    }
                    
                    if (
                        objProdDef.ProductCode == 'FRMRET1' || 
                        objProdDef.ProductCode == 'FRMRET2' ||
                        objProdDef.ProductCode == 'ERPRET1' ||
                        objProdDef.ProductCode == 'ERPRET2'
                    ) {                      
                        oppLineItem.Exam_Registration__c = objProdDef.relatedId;
                    }
                    
                    oppLineItem.Quantity = 1;
                    oppLineItem.pricebookEntryId = priceBookEntry.Id;
                    
                    lstOppLineItems.add(oppLineItem);
                    
                }
                
            }
            
        }
        
        INSERT lstOppLineItems;
        
        Set<Id> opportunityLineItemIds = new Set<Id>();
        for(OpportunityLineItem oli: lstOppLineItems){
            opportunityLineItemIds.add(oli.Id);
        }
        
        lstOppLineItems = [
            SELECT 
            Id, 
            Exam_Registration__c,
            Exam_Site__c,
            Description,       
            UnitPrice,              
            OpportunityId,          
            PricebookEntryId,       
            Quantity,   
            Product2Id,
            Product2.Name
            FROM OpportunityLineItem
            WHERE Id IN :opportunityLineItemIds
        ];
                
        // Update Opp with Team Reg
        if(teamRegUsed != NULL) {
            Opportunity opp = [select id, Team_Registration__c from Opportunity where id = :oppId];
            opp.Team_Registration__c = teamRegUsed.Id;
            update opp;
            
        }
        
        return lstOppLineItems;

    }
    
    public static void publicChapterMeetingRegister(String chapterMeetingId, Boolean isComing, String leadEmailAddress){
        List < Contact > lstContact = [SELECT Id, Name, AccountId FROM Contact WHERE Email = :leadEmailAddress];
        String contactId = lstContact[0].Id;
        List<Chapter_Meeting_Registration__c> lstChapterMeetingRegistrations = [select Id, Name, Status__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = :chapterMeetingId and Contact__c = :contactId];
        if( lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0 ) { 
            if(!isComing) {
                delete lstChapterMeetingRegistrations[0];
            }
        } else if(isComing) {
            Chapter_Meeting_Registration__c newChapterMeetingRegistration = new Chapter_Meeting_Registration__c();
            newChapterMeetingRegistration.put('Status__c','Confirmed');
            newChapterMeetingRegistration.put('Role__c','Registrant');
            newChapterMeetingRegistration.put('Chapter_Meeting__c',chapterMeetingId);
            newChapterMeetingRegistration.put('Contact__c',contactId);
            insert newChapterMeetingRegistration;
        }        
    }
    
    public static void createEventRegistration(TempAccount objData, Id contID, Id accID, Id oppId, Registration.verifyBulkOrderReturnData vbord, Boolean closeOpportunity) {
        
        System.debug('createEventRegistration:' + objData);
        
        Set<String> setEventIds = new Set<String>();
        for (TempAccount.productDefinition objProdDef: objData.productcode1) {
            if(objProdDef.relatedId != null){
                setEventIds.add(objProdDef.relatedId); 
            }
        }
        
        //1. Check if relatedId is an Event Or a Combo Price. Query Combo Price with that ID. 
        List<Event_Combo_Rate__c> comboEventRates = [select Id, Main_Event_Rate__r.Event__r.Id, Combo_Event__r.Id from Event_Combo_Rate__c where (Id in :setEventIds)];        
        
        //2. If the response is more than 0, then its a combo ID
        Integer size = comboEventRates.size();
        
        if(size > 0){
            setEventIds.clear();
            for (Event_Combo_Rate__c  comboRate: comboEventRates) {
                if(comboRate.Id != null){
                    setEventIds.add(comboRate.Main_Event_Rate__r.Event__r.Id); 
                    setEventIds.add(comboRate.Combo_Event__r.Id); 
                }
            }
        }
        
        //3. If Its less 0, then its an event.  
        Decimal amt = 0;      
        if(size == 0){
            
            System.debug('objData.productcode1:' + objData.productcode1);
            
            for (TempAccount.productDefinition objProdDef: objData.productcode1) {
                
                System.debug('objProdDef:' + objProdDef);
                
                if(objProdDef.relatedId != null){
                    setEventIds.add(objProdDef.relatedId); 
                }
                if(objProdDef.price != null) {
                    try {
                        Decimal damt = Decimal.valueOf(objProdDef.price);
                        amt+=damt;
                        
                        System.debug('amt:' + amt);
                        
                    } catch (exception ex) {
                    }
                }
            } 
        }
        
        List<Event__c> lstEvents = [select Id, Name, Product_Code__c, Invite_Only__c, Hide_Address_fields__c from Event__c where Status__c = 'Active' and Id in :setEventIds];
        
        List<Event_Registration__c> lstExistingEventRegs = [select Id, Name, Event__c, Opportunity__c from Event_Registration__c where Contact__c = :contID and Event__c in :setEventIds];
        MAP<ID,Event_Registration__c> mapEventRegs = new MAP<ID,Event_Registration__c>();
        for(Event_Registration__c er :lstExistingEventRegs) {
            mapEventRegs.put(er.Event__c, er);
        }
        
        List<Event_Registration__c> lstEventRegUpdate = new List<Event_Registration__c>();
        List<Event_Registration__c> lstEventRegAdd = new List<Event_Registration__c>();        
        List<Event_Discount__c > discountCodesUsed = [select Id, Discount_Code__c, Registration_Type__c, Event__r.id from Event_Discount__c where Discount_Code__c = :objData.promocodesUsed];
        
        for(Event__c ev :lstEvents) {
            
            Event_Registration__c fndEventReg = mapEventRegs.get(ev.Id);
            
            if(fndEventReg == null) {
                
                Event_Registration__c er = new Event_Registration__c();
                
                if(objData.privacyPolicyAttestation != null && objData.privacyPolicyAttestation){
                    er.Privacy_Policy_Attestation__c = System.now();
                }
                
                if(objData.photographyPolicyAttestation != null && objData.photographyPolicyAttestation){ 
                    er.Photography_Policy_Attestation__c = System.now();
                }
                
                if(objData.sponsorInformationExchangeAttestation != null && objData.sponsorInformationExchangeAttestation){
                    er.Sponsor_Information_Exchange_Attestation__c = System.now();
                }
                
                if(objData.garpInformationExchangeAttestation != null && objData.garpInformationExchangeAttestation){
                    er.GARP_Information_Exchange_Attestation__c = System.now();
                }
                
                if(objData.AttendanceMethod != null){
                    er.Attendance_Method__c = objData.AttendanceMethod;
                }
                
                String objName = objData.FirstName + ' ' + objData.LastName + '/' + ev.Name;
                
                if(objName.length() > 80){
                    objName  = objName.substring(0, 80);
                }
                
                er.Name = objName;
                er.Contact__c = contID;
                er.Member_Email__c = objData.Email;
                
                if(objData.Alternate_Email_Address != NULL) {
                    er.Alternate_Email_Address__c = objData.Alternate_Email_Address;
                }
                
                er.Event__c = ev.Id;
                
                // AG 2/4/2019 Set these type in Code now
                if(ev.Invite_Only__c == True) {
                    er.Attendee_Type__c = 'Participant';
                    er.Participants__c = 'Invited Guest';
                } else {
                    er.Attendee_Type__c = 'Participant';
                    if(amt > 0) {
                        er.Participants__c = 'Paying';
                    } else {
                        er.Participants__c = 'Comp Guest';
                    }
                }

                for(Event_Discount__c dc :discountCodesUsed) {
                    if(ev.Id == dc.Event__r.Id){ 
                        // AG 2/4/2019 This is now in Event EventRegistration Service in createContributorEventRegistration()
                        //er.Registration_Type__c = dc.Registration_Type__c;
                        er.Discount_Code_Used__c = dc.Discount_Code__c;
                    }
                }
                er.Status__c = 'Registered';
                er.Opportunity__c = oppId;
                
                lstEventRegAdd.add(er);
                
            } else {
                
                if(objData.privacyPolicyAttestation != null && objData.privacyPolicyAttestation){
                    fndEventReg.Privacy_Policy_Attestation__c = System.now();
                }
                
                if(objData.photographyPolicyAttestation != null && objData.photographyPolicyAttestation){ 
                    fndEventReg.Photography_Policy_Attestation__c = System.now();
                }
                
                if(objData.sponsorInformationExchangeAttestation != null && objData.sponsorInformationExchangeAttestation){
                    fndEventReg.Sponsor_Information_Exchange_Attestation__c = System.now();
                }

                if(objData.garpInformationExchangeAttestation != null && objData.garpInformationExchangeAttestation){
                    fndEventReg.GARP_Information_Exchange_Attestation__c = System.now();
                }
                
                fndEventReg.Opportunity__c = oppId;
                fndEventReg.Contact__c = contID;
                fndEventReg.Member_Email__c = objData.Email;
                fndEventReg.Status__c = 'Registered';
                
                lstEventRegUpdate.add(fndEventReg);
                
            }
            
        }
        
        insert(lstEventRegAdd);    
        update(lstEventRegUpdate);
        
        updateOpportunityinfo(objData, oppId, true, false, false, vbord, closeOpportunity);
    }    
    
    public static void createExamAttempts(TempAccount objData, Id contID, Id accID, Id oppId, boolean bCreateContratcs, verifyBulkOrderReturnData vbord, Boolean closeOpportunity) {
        Id membershipContract = null;
        Id contractID = checkContractExist(objData, accID);
        List < Candidate_Requirement__c > lstCandReqs;
        
        if ((contractID == null && bCreateContratcs) || objData.isIcbrChecked) {
            contractID = CreateContract(accID, objData, oppId, contID);
            lstCandReqs = createCandidateRequirements(contractID, objData);            
        }
        
        if(contractID != null){
            updateOpportunityinfo(objData, oppId, false, true, (bCreateContratcs || objData.isFrmChecked == true || objData.isErpChecked == true), vbord, closeOpportunity);
        }
        
        if (lstCandReqs == null) {
            lstCandReqs = [select id, name, Exam__c from Candidate_Requirement__c where Candidate_Commitment__c = : contractID];
        }
        if (objData.isIcbrChecked) {
            createExamAttemptsForICBR(objData, contID, accID, oppId, lstCandReqs, contractID);
            return;
        }
        
        List < Exam_Sites__c > lstExamSites = new List < Exam_Sites__c > ();
        
        Set < String > setExamNames = new Set < String > ();
        for (TempAccount.productDefinition objProd: objData.productcode1) {
            if (objProd.ProductCode == 'FRM1E' || objProd.ProductCode == 'FRM1L' || objProd.ProductCode == 'FRM1S'){
                setExamNames.add('FRM Part 1');
            }else if (objProd.ProductCode == 'FRM2E' || objProd.ProductCode == 'FRM2L' || objProd.ProductCode == 'FRM2S'){
                setExamNames.add('FRM Part 2');
            }else if (objProd.ProductCode == 'ENC1E' || objProd.ProductCode == 'ENC1L' || objProd.ProductCode == 'ENC1S'){
                setExamNames.add('ERP Exam Part I');
            }else if (objProd.ProductCode == 'ENC2E' || objProd.ProductCode == 'ENC2L' || objProd.ProductCode == 'ENC2S'){
                setExamNames.add('ERP Exam Part II');
            }
        }        
        if(objData.isFrmChecked || objData.isErpChecked) {
            try {
                lstExamSites = [Select id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c from Exam_Sites__c where Site__r.Name = : objData.siteName and Exam__r.Exam__c in : setExamNames and Exam__r.Exam_Group__r.Active__c = true];
                if(lstExamSites.size()==0)
                    lstExamSites = [Select id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c from Exam_Sites__c where id='a1e400000090DQq'];
            } catch (exception ex) {
                lstExamSites = [Select id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c from Exam_Sites__c where id='a1e400000090DQq'];
            }
        }
        
        List<Exam_Attempt__c> lstEAs = registerExam(lstExamSites, contID, lstCandReqs, contractID, oppId);        
        if(lstEAs != NULL && lstEAs.size() > 0) {
            
            Opportunity opportunity = [
                SELECT Id, Deferred_Exam_Registration__c, 
                (SELECT Id, Exam_Registration__c, PriceBookEntry.Product2.ProductCode FROM OpportunityLineItems WHERE PriceBookEntry.Product2.ProductCode = 'CHLF')  
                FROM Opportunity 
                WHERE id = :oppId
            ];
            
            for(OpportunityLineItem oli: opportunity.OpportunityLineItems){
                if(oli.Exam_Registration__c != null) continue;
                else oli.Exam_Registration__c = lstEAs[0].Id;
                break;
            }            
            
            opportunity.Deferred_Exam_Registration__c = lstEAs[0].Id;
            update opportunity;
            
        }
    }
    
    public static void updateSelfRelations(List < Candidate_Requirement__c > lstCReq, TempAccount objData) {
        Map < String, Candidate_Requirement__c > mapNames = getCandidatesReqByName(lstCReq);
        if (mapNames == null || mapNames.size() <= 0) return;
        for (Candidate_Requirement__c obj: lstCReq) {
            
            if (obj.Name == 'Job Requirement' && objData.isFRMChecked){
                obj.Prerequisite__c = mapNames.get('Pass FRM2').Id;
            }
            if (obj.Name == 'Job Requirement' && objData.isERPChecked){
                obj.Prerequisite__c = mapNames.get('Pass ERP').Id;
            }else if (obj.Name == 'Pass FRM2'){
                obj.Prerequisite__c = mapNames.get('Pass FRM1').Id;
            }else if (obj.Name == 'Pass FRM2'){
                obj.Prerequisite__c = mapNames.get('Pass FRM1').Id;
            }
            
        }
        
        update lstCReq;
    }
    
    public static Map < String, Candidate_Requirement__c > getCandidatesReqByName(List < Candidate_Requirement__c > lstCReq) {
        if (lstCReq == null) return null;
        Map < String, Candidate_Requirement__c > mapNames = new Map < String, Candidate_Requirement__c > ();
        for (Candidate_Requirement__c obj: lstCReq) {
            mapNames.put(obj.Name, obj);
        }
        return mapNames;
    }
    
    public static ID CreateContract(ID accID, TempAccount objData, ID oppId, ID contID) {
        
        List < Contract > lstContract = new List < Contract > ();
        
        Contract objContract = new Contract();
        objContract.accountId = accID;
        objContract.Opportunity__c = oppId;
        objContract.StartDate = system.today();
        objContract.ContractTerm = 48;
        if (objData.isFrmChecked) {
            objContract.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            objContract.Last_Program_Responsibility_Signature__c = DateTime.now();
            lstContract.add(objContract);
        } else if (objData.isFBRChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'FBR Program');
            objContract.ContractTerm = 6;
            lstContract.add(objContract);
        } else if (objData.isIcbrChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ICBRR Program');
            objContract.ContractTerm = 9;
            objContract.Pearson_Member_First_Name__c = objData.FirstName;
            objContract.Pearson_Member_Last_Name__c = objData.LastName;
            objContract.Member_Email__c = objData.Email;
            objContract.CustomerSignedId =contID;
            objContract.BillingStreet =objData.BillingStreet;
            objContract.Billingpostalcode =objData.BillingPostalCode;
            objContract.Billingcountry = objData.BillingCountry;
            objContract.BillingState = objData.BillingState;
            objContract.BillingCity = objData.BillingCity;
            objContract.Pearson_Phone_No__c = objData.HomePhone;

            lstContract.add(objContract);
        } else if (objData.isErpChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            lstContract.add(objContract);
        } else if (objData.isErpChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            lstContract.add(objContract);
        }
        else if (objData.isFbraChecked) {
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'FBRA Program');
            objContract.ContractTerm = 6;
            lstContract.add(objContract);
        }
        
        if (lstContract.size() > 0) {
            insert lstContract;
            return lstContract[0].Id;
        } else {
            return null;
        }
        
    }
    
    public static ID CreateMemberShipContract(TempAccount objData, ID accID, ID oppId, ID contactId, Boolean doWiley) {
        
        Id memberRecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        Contract objContract = null;
        
        try {
            objContract = new Contract();
            objContract.Name = 'Membership';
            objContract.accountId = accID;
            objContract.CustomerSignedId = contactId;
            objContract.Opportunity__c = oppId;
            objContract.StartDate = system.today();
            // Set to 1 so trigger knows this is the first time!!
            // Trigger will set it to 12
            objContract.ContractTerm = 12;
            objContract.recordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
            for (TempAccount.productDefinition objProdDef: objData.productcode1) {
                
                if (objProdDef.ProductCode == 'AFREE')
                    objContract.Membership_Type__c = 'Affiliate';
                else if (objProdDef.ProductCode == 'MEMI' || objProdDef.ProductCode == 'MEMF')
                    objContract.Membership_Type__c = 'Individual';
                else if (objProdDef.ProductCode == 'MEMS')
                    objContract.Membership_Type__c = 'Student';
                
            }
            
            
            if(objContract.Membership_Type__c == null) return null;
            insert objContract;
            return objContract.Id;
            
        } catch (exception ex) {
            return null;
        }
        
    }
    
    public static List < Candidate_Requirement__c > createCandidateRequirements(Id contractID, TempAccount objData) {
        id oppID = [SELECT Opportunity__c FROM contract WHERE id = : contractID LIMIT 1].Opportunity__c;
        
        //string email = [SELECT Shipping_E_mail__c FROM opportunity WHERE id = : oppID LIMIT 1].Shipping_E_mail__c;
        String email = objData.Email;
        
        List < Candidate_Requirement__c > lstCandReq = new List < Candidate_Requirement__c > ();
        Candidate_Requirement__c objCandReq;
        
        // ERP Split
        Integer iCount = (objData.isFrmChecked ? 3 : (objData.isERPChecked ? 3 : (objData.isFBRChecked || objData.isIcbrChecked || objData.isFbraChecked) ? 1 : 0));
        
        system.debug('iCount:' + iCount);
        
        Id examRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Exam');
        Id jobExpRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        Candidate_Requirement__c crJob=null;
        Candidate_Requirement__c crE1=null;
        Candidate_Requirement__c crE2=null;
        
        for (Integer i = 0; i < iCount; i++) {
            objCandReq = new Candidate_Requirement__c();
            objCandReq.Candidate_Commitment__c = contractID;
            objCandReq.Candidate_Email__c = email;
            if (i == 0) {
                if (objData.isFBRChecked !=null && objData.isFBRChecked) {
                    objCandReq.Name = 'Pass FBR';
                    objCandReq.Exam__c = 'FBR';
                    objCandReq.Status__c = 'Initial';
                } 
                else if (objData.isFbraChecked !=null && objData.isFbraChecked) {
                    objCandReq.Name = 'Pass FBRA';
                    objCandReq.Exam__c = 'FBRA';
                    objCandReq.Status__c = 'Initial';
                }
                else if (objData.isIcbrChecked !=null && objData.isIcbrChecked) {
                    objCandReq.Name = 'Pass ICBRR';
                    objCandReq.Exam__c = 'ICBRR';
                    ObjCandReq.recordTypeID = examRecType;
                    objCandReq.Status__c = 'Initial';
                } else {
                    objCandReq.Name = 'Job Requirement';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = jobExpRecType;
                    objCandReq.Email_GARP_Member__c = objData.Email;
                    crJob = objCandReq;
                }
            } else if (i == 1) {
                if (objData.isERPChecked !=null && objData.isERPChecked) {
                    objCandReq.Name = 'Pass ERP1';
                    objCandReq.Exam__c = 'ERP Part I';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;
                    crE1 = objCandReq;
                } else {
                    objCandReq.Name = 'Pass FRM1';
                    objCandReq.Exam__c = 'FRM Part I';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;
                    crE1 = objCandReq;
                }
            } else {
                if (objData.isERPChecked !=null && objData.isERPChecked) {
                    objCandReq.Name = 'Pass ERP2';
                    objCandReq.Exam__c = 'ERP Part II';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;
                    crE2 = objCandReq;
                } else {
                    objCandReq.Name = 'Pass FRM2';
                    objCandReq.Exam__c = 'FRM Part II';
                    objCandReq.Status__c = 'Initial';
                    objCandReq.recordTypeID = examRecType;                    
                    crE2 = objCandReq;
                }
            }
            lstCandReq.add(objCandReq);
        }
        if (lstCandReq.size() > 0) {
            if(crE2!=null && crE1!=null) 
                crE2.Prerequisite__c = crE1.Id;
            if(crE2!=null && crJob!=null)
                crJob.Prerequisite__c = crE2.Id;
            insert lstCandReq;
        }
        
        
        return lstCandReq;
    }
    
    public static List<Exam_Attempt__c> registerExam(List <Exam_Sites__c> lstExamSites, Id contID, List <Candidate_Requirement__c> lstCandReqs, id ContractID, Id oppId) {
        Exam_Attempt__c objAttempt = null;
        Map < String, Id > mapCandIds = new Map < String, Id > ();
        
        for (Candidate_Requirement__c obj: lstCandReqs) {
            
            switch on obj.Exam__c{
                when 'FRM Part I'{
                    mapCandIds.put('FRM Part 1', obj.Id);
                    break;
                }
                when 'FRM Part II'{
                    mapCandIds.put('FRM Part 2', obj.Id);
                    break;
                }
                when 'ERP Part I'{
                    mapCandIds.put('ERP Exam Part I', obj.Id);
                    break;
                }
                when 'ERP Part II'{
                    mapCandIds.put('ERP Exam Part II', obj.Id);
                    break;
                }
            }
               
        }
        
        List <Exam_Attempt__c> examRegistrations = new List <Exam_Attempt__c>();
        
        Exam_Attempt__c objSwapEAFRM1=null;
        Exam_Attempt__c objSwapEAFRM2=null;

        Exam_Attempt__c objSwapEAERP1=null;
        Exam_Attempt__c objSwapEAERP2=null;
        
        Id examGroup;
        
        for (Exam_Sites__c objExamSite: lstExamSites) {
            objAttempt = new Exam_Attempt__c();
            objAttempt.Exam_Site__c = objExamSite.Id;
            objAttempt.Member__c = contID;
            String strExamName = '';
            objAttempt.Candidate_Commitment__c = ContractID;
            objAttempt.Opportunity__c = oppId;
            objAttempt.Candidate_Requirement__c = mapCandIds.get(objExamSite.Exam__r.Exam__c);
            examRegistrations.add(objAttempt);
            if(objExamSite.Exam__r.Exam_Group__c != null)
                examGroup = objExamSite.Exam__r.Exam_Group__c;
        }
        
        if (examRegistrations.size() > 0) {
            insert examRegistrations;
        }
        
        examRegistrations = [
            SELECT Id, Name, Exam_Site__r.Exam__r.Exam__c 
            FROM Exam_Attempt__c 
            WHERE 
            Member__c = :contID and 
            Candidate_Commitment__c = :ContractID and 
            Exam_Site__r.Exam__r.Exam_Group__c = :examGroup
            ORDER BY Exam_Site__r.Exam__r.Exam__c ASC
        ];
        
        for (Exam_Attempt__c ea: examRegistrations) {
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1') {
                objSwapEAFRM1 = ea;
            }
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2') {
                objSwapEAFRM2 = ea;
            }            
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part I') {
                objSwapEAERP1 = ea;
            }
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'ERP Exam Part II') {
                objSwapEAERP2 = ea;
            }
        }
        
        system.debug('* * * objSwapEAFRM1 ...'+ objSwapEAFRM1 + ':' + objSwapEAFRM2 + ':' + objSwapEAERP1 + ':' + objSwapEAERP2);
        
        if(objSwapEAFRM1!=null && objSwapEAFRM2!=null) {
            objSwapEAFRM1.Other_Exam_Registrations__c = objSwapEAFRM2.Id;
            objSwapEAFRM2.Other_Exam_Registrations__c = objSwapEAFRM1.Id;
            update examRegistrations;
        }
        
        if(objSwapEAERP1!=null && objSwapEAERP2!=null) {
            objSwapEAERP1.Other_Exam_Registrations__c = objSwapEAERP2.Id;
            objSwapEAERP2.Other_Exam_Registrations__c = objSwapEAERP1.Id;
            update examRegistrations;
        }
        
        if(examRegistrations != null && !examRegistrations.isEmpty()) return examRegistrations;
        else return null;
    }
    
    public static Opportunity CreateOpportunity(Contact objContact, TempAccount objData) {
        
        Opportunity opp = new Opportunity();
        
        setOpportunityName(objData, opp);
        opp.Accountid = objContact.AccountId;
        opp.StageName = 'New Lead';
        opp.CloseDate = system.today();
        opp.Program__c = 'FRM';
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated');
        opp.RecordTypeId = recordTypeID;
        
        if(objData.MembershipEligible != NULL && objData.MembershipEligible == True) {
            if(objData.autoRenew == true) {
                opp.Auto_Renew__c=true;
            }
            opp.Eligible_for_Membership_Extension__c = true;
        }
        
        //Contact Information
        opp.ChargentSFA__Billing_Email__c   = String.isNotEmpty(objData.Email) ? objData.Email : objContact.Email ;
        opp.ChargentSFA__Billing_First__c   = String.isNotEmpty(objData.FirstName) ? objData.FirstName : objContact.FirstName;
        opp.ChargentSFA__Billing_Last__c    = String.isNotEmpty(objData.LastName) ? objData.LastName : objContact.LastName;
        opp.ChargentSFA__Billing_Phone__c   = String.isNotEmpty(objData.HomePhone) ? objData.HomePhone : objContact.HomePhone;
        opp.ChargentSFA__Billing_Company__c = String.isNotEmpty(objData.BillingCompany) ? objData.BillingCompany : objContact.Company__c;
        
        //BillingStreet(s)
        String billingStreet1 = null;
        String billingStreet2 = null;
        String billingStreet3 = null;
        
        //Parsing BillingStreet off of the Account
        if (objContact.Account.BillingStreet != null) {
            String[] billingAddress = objContact.Account.BillingStreet.split('\n');
            if (billingAddress != null && !billingAddress.isEmpty()) {
                billingStreet1 = (billingAddress.size() > 0) ? billingAddress[0] : null;
                billingStreet2 = (billingAddress.size() > 1) ? billingAddress[1] : null;
                billingStreet3 = (billingAddress.size() > 2) ? billingAddress[2] : null;         
            }else{
                billingStreet1 = objContact.Account.BillingStreet;
            }
        }
        
        //Address Information
        if(String.isNotEmpty(objData.BillingStreet)){
            opp.ChargentSFA__Billing_Address__c = objData.BillingStreet;
        }else{
            opp.ChargentSFA__Billing_Address__c = billingStreet1;
        }
        
        if(String.isNotEmpty(objData.BillingStreetTwo)){
            opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetTwo;
        }else if(billingStreet2 != null){
            opp.ChargentSFA__Billing_Address__c += '\n' + billingStreet2;
        }
        
        if(String.isNotEmpty(objData.BillingStreetThree)){
            opp.ChargentSFA__Billing_Address__c += '\n' + objData.BillingStreetThree;
        }else if(billingStreet3 != null){
            opp.ChargentSFA__Billing_Address__c += '\n' + billingStreet3;
        }
        
        opp.ChargentSFA__Billing_City__c    = String.isNotEmpty(objData.BillingCity) ? objData.BillingCity : objContact.Account.BillingCity;
        opp.ChargentSFA__Billing_State__c   = String.isNotEmpty(objData.BillingState) ? objData.BillingState : objContact.Account.BillingState;
        opp.ChargentSFA__Billing_Zip__c     = String.isNotEmpty(objData.BillingPostalCode) ? objData.BillingPostalCode : objContact.Account.BillingPostalCode;
        opp.ChargentSFA__Billing_Country__c = String.isNotEmpty(objData.BillingCountry) ? objData.BillingCountry : objContact.Account.BillingCountry;
        
        INSERT opp;
        
        OpportunityContactRole contactRole = new OpportunityContactRole(OpportunityId=opp.id, ContactId=objContact.Id, Role='Decision Maker');
        INSERT contactRole;
        
        return opp;
    }
    
    
    
    public static Map < String, wrapperProductInfo > getProductCodes() {
        Id currentUSer = userInfo.getuserId();
        Id frmRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        Id erpRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
        User objUSer = [select id, Email, contactId from user where id = : currentUSer];

        List < Exam_Attempt__c > lstExamAttempts = [
            SELECT Id, Defered__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.site__c, Section__c, 
            Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c, Exam_Site__r.Exam__r.Exam__c
            FROM Exam_Attempt__c 
            WHERE 
            (
                Candidate_Commitment__r.Status LIKE '%Activated%' OR 
                Candidate_Commitment__r.Status = 'Completed'
            ) AND 
            Member__c = :objUser.contactId AND 
            Cancelled__c = FALSE
            ORDER BY Exam_Date__c DESC
        ];

        Set<String> examNamesForExamResultsBeingLoaded = new Set<String>();
        for(Exam_Attempt__c ea: lstExamAttempts){
            if(ea.Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c){
                examNamesForExamResultsBeingLoaded.add(ea.Exam_Site__r.Exam__r.Exam__c);
            }
        }

        System.debug('examNamesForExamResultsBeingLoaded: ' + examNamesForExamResultsBeingLoaded);
        system.debug('objUser.contactId::>>  '+objUser.contactId);
        Contact contactRecord = [
            SELECT Id, KPI_ERP_Enrollment_Date__c, AccountID, KPI_FRM_Enrollment_Date__c 
            FROM Contact 
            WHERE Id = :objUser.contactId
        ];
        system.debug('contactRecord::>>  '+contactRecord);
        for(Contract obj : [
            SELECT Id, RecordTypeId, StartDate, Enrollment_paid_for_2009__c, Status  
            FROM Contract 
            WHERE AccountId = :contactRecord.accountID AND (Status LIKE '%Activated%' OR Status LIKE '%completed%')
        ]){
            
            if(obj.status =='Activated' ||obj.status =='Activated ( Auto-Renew )'){
                if(obj.recordtypeID == frmRecordTypeId){
                    bHasFrmEnrollment = true;
                    if(obj.StartDate.Year() == 2009 && !obj.Enrollment_paid_for_2009__c)
                        bFRMPaidFor2009 = true;
                    
                }else if(obj.recordtypeID == erpRecordTypeId){
                    bHasERPEnrollment = true;
                }
            }
            
            if(obj.status =='Completed' ) {  
                if(obj.recordtypeID == frmRecordTypeId){
                    
                    bHasFrmcompleted =true;
                    
                }else if(obj.recordtypeID == erpRecordTypeId){
                    bHasErpcompleted = true;
                }
            }

        }
        
        List<String> lstExamNames = new List<String>();
        
        system.debug('bHasFrmcompleted == '+bHasFrmcompleted);
        system.debug('bHasErpcompleted == '+bHasErpcompleted);
        system.debug('bHasFrmEnrollment == '+bHasFrmEnrollment);
        system.debug('bHasERPEnrollment == '+bHasERPEnrollment);
        
        if(bHasFrmcompleted){
            lstExamNames.add('ERP Exam Part I');
            lstExamNames.add('ERP Exam Part II');
        }
        
        if(bHasErpcompleted){
            lstExamNames.add('FRM Part 1');
            lstExamNames.add('FRM Part 2');
        }
        
        if(!bHasFrmcompleted && !bHasErpcompleted){
            lstExamNames.add('FRM Part 1');
            lstExamNames.add('FRM Part 2');
            lstExamNames.add('ERP Exam Part I');
            lstExamNames.add('ERP Exam Part II');
        }
        
        Map<String, wrapperProductInfo > mapExamFees = null;
        if (lstExamAttempts != null && lstExamAttempts.size() > 0) {
            mapExamFees = getProductCodesBasedOnFilters1(lstExamAttempts, objUSer);
            mapExamFees = getMiscellaneousProdCodes(mapExamFees);
        } else {
            mapExamFees = getExamFee1(getExamDetails(lstExamNames));
            mapExamFees = getMiscellaneousProdCodes(mapExamFees);
        }

        // If loading exam results for FRM Part 1 OR Part 2 remove both FRM Exam products
        if(examNamesForExamResultsBeingLoaded.contains('FRM Part 1') || examNamesForExamResultsBeingLoaded.contains('FRM Part 2')){
            if(mapExamFees.containsKey('FRMPartOne')){
                mapExamFees.remove('FRMPartOne');
            }
            if(mapExamFees.containsKey('FRMPartTwo')){
                mapExamFees.remove('FRMPartTwo');
            }
        }
        
        // If loading exam results for ERP Part 1 OR Part 2 remove both ERP Exam products
        if(examNamesForExamResultsBeingLoaded.contains('ERP Exam Part I') || examNamesForExamResultsBeingLoaded.contains('ERP Exam Part II')){
            if(mapExamFees.containsKey('ERPPartOne')){
                mapExamFees.remove('ERPPartOne');
            }
            if(mapExamFees.containsKey('ERPPartTwo')){
                mapExamFees.remove('ERPPartTwo');
            }
        }

        system.debug('mapExamFees :' + mapExamFees);

        return mapExamFees;

    }

    public static Map < String, wrapperProductInfo > getProductCodesBasedOnFilters1(List < Exam_Attempt__c > lstExamAttempts, User objUSer) {
        system.debug('In getProductCodesBasedOnFilters1 lstExamAttempts == ' + lstExamAttempts);
        Set < String > setExamToRegister = new Set < String > ();
        boolean bInvokeFrms = false;
        boolean bInvokeErps = false;
        boolean bIsErpDeferred = false;
        
        for (Exam_Attempt__c objEA: lstExamAttempts) {
            if (!objEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) continue;
            //Check if registered for ERP then we should not show any exams. If erp is failed then show only ERP to the end user for registration
            if (objEA.Section__c.indexOf('ERP') >= 0) {
                bInvokeErps = true;
                // if (objEA.Defered__c == 'Pending')
                // bIsErpDeferred = true;
            } else if (objEA.Section__c.indexOf('FRM') >= 0) bInvokeFrms = true;
        }
        system.debug('bIsErpDeferred == '+bIsErpDeferred);
        system.debug('bInvokeFrms == '+bInvokeFrms);
        // if (bIsErpDeferred)
        //  setExamToRegister = getFRMExams(objUSer);
        if (bInvokeFrms)
            setExamToRegister = getFRMExams(objUSer);
        else if (bInvokeErps)
            setExamToRegister = getERPExams(objUSer);
        else if (!bInvokeFrms && !bInvokeErps) {
            Set < String > setFrms = getFRMExams(objUSer);
            Set < String > setErps = getERPExams(objUSer);
            if (setFrms != null) setExamToRegister.addAll(setFrms);
            if (setErps != null) setExamToRegister.addAll(setErps);
            
        }
        system.debug('&&&&&&&:'+setExamToRegister);
        if (setExamToRegister == null || setExamToRegister.size() <= 0) return null;
        system.debug('&&&&&&&:'+setExamToRegister);
        Map < String, wrapperProductInfo > mapExamFes = getExamFee1(getExamDetails(new List < String > (setExamToRegister)));
        return mapExamFes;
    }
    
    public static Set < String > getFRMExams(User objUser) {
        Date ExamDate = testDate();
        Set < String > setExamToRegister = new Set < String > ();
        boolean bhasRecords = false;
        boolean bhasFrm12 = false;
        Integer iDefferedCount = 0;
        Integer iActiveEA = 0;
        Date dtExamDate = null;
        boolean bFrm1 = false;
        boolean bFrm2 = false;
        boolean bPassFrm1 = false;
        
        Id frmRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        for (Exam_Attempt__c objFRMEA: [
            select id, Candidate_Commitment__r.EndDate,Candidate_Commitment__r.Last_Exam_registration_Date__c, Contract_End_Date__c, Defered__c, Opportunity_StageName__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.Exam__r.Exam_Group__r.Active__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status 
            from Exam_Attempt__c 
            where
            (
                Candidate_Commitment__r.Status like '%Activated%' or 
                Candidate_Commitment__r.Status = : 'Completed'
            ) and 
            Member__c = : objUser.contactId and 
            Opportunity_StageName__c ='closed' and 
            Candidate_Commitment__r.recordTypeID = : frmRecordTypeId and 
            Cancelled__c != true 
            order by Exam_Date__c DESC
        ]) {
            
            system.debug('objFRMEA == '+objFRMEA);
            system.debug('Active == '+objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c);
            
            // this is for 4 year expiration window
            
            if (
                objFRMEA.Candidate_Commitment__r.Last_Exam_registration_Date__c != null &&
                objFRMEA.Candidate_Commitment__r.Status == 'Activated' && 
                (
                    (objFRMEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.month() <= ExamDate.month()) && 
                    (objFRMEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.year() <= ExamDate.year()) &&
                    (objFRMEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.month() != ExamDate.month() )
                )
            ) return null;
            
            if (objFRMEA.Candidate_Commitment__r.Status == 'Completed') return null;
            bhasRecords = true;
            if (dtExamDate == null) dtExamDate = objFRMEA.Exam_Date__c;
            if (objFRMEA.Defered__c == 'Pending')
                iDefferedCount += 1;
            if (objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c)
                iActiveEA += 1;
            
            //&& objFRMEA.Defered__c == null
            if (objFRMEA.Section__c.indexOf('FRM Part 2') >= 0 && (objFRMEA.Result__c == 'pass' || objFRMEA.Result__c == null|| objFRMEA.Result__c == '')) {
                
                
                if ((objFRMEA.Result__c == null ||objFRMEA.Result__c =='Pass')&& !objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    setExamToRegister.clear();}
                system.debug('&&&&&&:'+bhasFrm12);
                
                bhasFrm12 = true;
                bFrm2 = true;
                break;
                
            } 
            
            else if (objFRMEA.Section__c.indexOf('FRM Full Program') >= 0 && !bFrm1 && !bFrm2) {
                bFRMActivatedXX = true;
                if (objFRMEA.Result__c == 'Pass') {
                    bhasFrm12 = true;
                    break;
                } else if ((objFRMEA.Result__c != null) && objFRMEA.Result__c != 'Pass' || objFRMEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    setExamToRegister.add('FRM Part 1');
                    setExamToRegister.add('FRM Part 2');
                }
            }
            
            
            else if (objFRMEA.Section__c.indexOf('FRM Part 1') >= 0) {
                bFRMActivatedXX = true;
                bFrm1 = true;
                
                if (objFRMEA.Result__c == null && !objFRMEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    break;
                    // setExamToRegister.clear();
                } else if ((objFRMEA.Result__c != null) && objFRMEA.Result__c != 'Pass' || objFRMEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    if(bPassFrm1==false)
                        setExamToRegister.add('FRM Part 1');
                    setExamToRegister.add('FRM Part 2');
                } else if (objFRMEA.Result__c == 'Pass' || objFRMEA.Result__c == null) {
                    
                    bPassFrm1=true ;              
                    setExamToRegister.clear();  
                    setExamToRegister.add('FRM Part 2');
                }
            }
            
        }
        
        system.debug('iDefferedCount == '+iDefferedCount);
        system.debug('iActiveEA == '+iActiveEA);
        if (iDefferedCount == iActiveEA && iDefferedCount > 0)
            setExamToRegister = getERPExams(objUser);
        system.debug('*********:'+bhasFrm12);
        if (bhasFrm12 && (iDefferedCount != iActiveEA) ) return null;
        else if (!bhasRecords) {
            setExamToRegister.add('FRM Part 1');
            setExamToRegister.add('FRM Part 2');
        }
        
        system.debug('setExamToRegister == '+setExamToRegister);
        return setExamToRegister;
    }
    
    public static Set < String > getERPExams(User objUser) {
        Date ExamDate = testDate();
        Set < String > setExamToRegister = new Set < String > ();
        boolean bhasRecords = false;
        boolean bhasErp12 = false;
        Integer iDefferedCount = 0;
        Integer iActiveEA = 0;
        Date dtExamDate = null;
        boolean bErp1 = false;
        boolean bErp2 = false;
        boolean bPassErp1 = false;
        Id erpRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
        for (Exam_Attempt__c objERPEA: [
            SELECT 
            Id, 
            Defered__c, 
            Member__c,
            Contract_End_Date__c,
            Opportunity_StageName__c,
            Exam_Date__c,
            Candidate_Commitment__r.Last_Exam_registration_Date__c, 
            Exam_Site__r.Exam__r.Exam_Group__r.Active__c, 
            Exam_Site__c, 
            Exam_Site__r.site__c, 
            Section__c, Result__c, 
            Candidate_Commitment__c, 
            Candidate_Commitment__r.Status 
            FROM Exam_Attempt__c 
            WHERE
            (
                Candidate_Commitment__r.Status LIKE '%Activated%' OR 
                Candidate_Commitment__r.Status = : 'Completed'
            ) AND 
            Member__c = : objUser.contactId AND 
            Candidate_Commitment__r.recordTypeID = : erpRecordTypeId AND 
            Opportunity_StageName__c = 'closed' AND  
            Cancelled__c != TRUE 
            order by Exam_Date__c DESC
        ]) {
            
            system.debug('objERPEA == '+objERPEA);
            system.debug('Active == '+objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c);
            // this is for 4 year expiration window
            
            if (objERPEA.Candidate_Commitment__r.Status == 'Activated' && ((objERPEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.month() <= ExamDate.month() )&& (objERPEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.year() <= ExamDate.year()) &&(objERPEA.Candidate_Commitment__r.Last_Exam_registration_Date__c.month() != ExamDate.month() ))) return null;
            
            
            
            if (objERPEA.Candidate_Commitment__r.Status == 'Completed') return null;
            bhasRecords = true;
            if (dtExamDate == null) dtExamDate = objERPEA.Exam_Date__c;
            
            if (objERPEA.Defered__c == 'Pending')
                iDefferedCount += 1;
            if (objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c)
                iActiveEA += 1;
            //&& objERPEA.Defered__c == null
            if (objERPEA.Section__c.indexOf('ERP Exam Part II') >= 0  && (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == null|| objERPEA.Result__c == '')) {
                
                
                setExamToRegister.clear();
                
                system.debug('&&&&&&:'+bhasErp12);
                
                bhasErp12 = true;
                bErp2 = true;
                break;
                
                
            } 
            
            else if (objERPEA.Section__c == 'ERP' && !bErp1 && !bErp2) {
                
                if (objERPEA.Result__c == 'Pass' || objERPEA.Result__c == ''|| objERPEA.Result__c == null) {
                    
                    bhasErp12 = true;
                    break;
                } else if ((objERPEA.Result__c != null) && objERPEA.Result__c != 'Pass' || objERPEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    setExamToRegister.add('ERP Exam Part I');
                    setExamToRegister.add('ERP Exam Part II');
                }
            }
            
            else if (objERPEA.Section__c.indexOf('ERP Exam Part I') >= 0) {
                bErp1 = true;
                if (objERPEA.Result__c == null && !objERPEA.Exam_Site__r.Exam__r.Exam_Group__r.Active__c) {
                    setExamToRegister.clear();
                } else if ((objERPEA.Result__c != null) && objERPEA.Result__c != 'Pass' || objERPEA.Result__c == 'No-Show') {
                    setExamToRegister.clear();
                    if(bPassErp1==false)
                        setExamToRegister.add('ERP Exam Part I');
                    setExamToRegister.add('ERP Exam Part II');
                } else if ((objERPEA.Result__c == 'Pass' || objERPEA.Result__c == null)) {
                    
                    bPassErp1=true ;         
                    
                    setExamToRegister.clear();  
                    setExamToRegister.add('ERP Exam Part II');
                }
                
            }
            
        }
        system.debug('iDefferedCount == '+iDefferedCount);
        system.debug('iActiveEA == '+iActiveEA);
        if (iDefferedCount == iActiveEA && iDefferedCount > 0)
            setExamToRegister = getFRMExams(objUser);
        system.debug('@@@@@@:'+bhasErp12);
        if (bhasErp12 &&(iDefferedCount != iActiveEA)) return null;  
        else if (!bhasRecords) {
            setExamToRegister.add('ERP Exam Part I');
            setExamToRegister.add('ERP Exam Part II');
        }
        
        system.debug('setExamToRegister == '+setExamToRegister);
        return setExamToRegister;
    }
    
    public static Id checkContractExist(TempAccount objData, Id accounID) {
        ID recTypeID = null;
        for (TempAccount.productDefinition objProd: objData.productcode1) {
            if (objProd.ProductCode == 'FRM1E' || objProd.ProductCode == 'FRM1L' || objProd.ProductCode == 'FRM1S' || objProd.ProductCode == 'FRM2E' || objProd.ProductCode == 'FRM2L' || objProd.ProductCode == 'FRM2S')
                recTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
            // ERP Split
            //else if (objProd.ProductCode == 'ENCE' || objProd.ProductCode == 'ENCL' || objProd.ProductCode == 'ENCS')
            //    recTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
            else if (objProd.ProductCode == 'ENC1E' || objProd.ProductCode == 'ENC1L' || objProd.ProductCode == 'ENC1S' || objProd.ProductCode == 'ENC2E' || objProd.ProductCode == 'ENC2L' || objProd.ProductCode == 'ENC2S')
                recTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'ERP Program');
        }
        try {
            Contract obj = [select id, recordtypeID from Contract where recordTypeID = : recTypeID and accountID = : accounID and Status like '%Activated%'
                            limit 1
                           ];
            return obj.Id;
        } catch (exception ex) {
            return null;
        }
    }
    
    public static void createExamAttemptsForICBR(TempAccount objData, Id contID, Id accID, Id oppId, List < Candidate_Requirement__c > lstCandReqs, Id contractID) {
        Map < String, Id > mapCandIds = new Map < String, Id > ();
        system.debug('lstCandReqs == ' + lstCandReqs);
        for (Candidate_Requirement__c obj: lstCandReqs) {
            mapCandIds.put(obj.Name, obj.Id);
        }
        system.debug('mapCandIds == ' + mapCandIds);
        Exam_Attempt__c objAttempt = new Exam_Attempt__c();
        objAttempt.Member__c = contID;
        String strExamName = 'Pass ICBR';
        objAttempt.Candidate_Commitment__c = contractID;
        objAttempt.Opportunity__c = oppId;
        objAttempt.Candidate_Requirement__c = mapCandIds.get('Pass ICBRR');
        updateids__c recIds = updateids__c.getInstance('ICBRR');
        objAttempt.Exam_Site__c = recIds.Record_id__c;//'a0Cf0000004O778';
        insert objAttempt;
    }
    
    public static decimal getProdPrice(String strKey, Map < String, Product2 > mapMayProductDetails, Map < Id, PriceBookEntry > mapPriceBookDetails) {
        system.debug('mapMayProductDetails == ' + mapMayProductDetails);
        system.debug('mapPriceBookDetails == ' + mapPriceBookDetails);
        system.debug('strKey == ' + strKey);
        if(mapMayProductDetails.get(strKey) != null){
            Id prodID = mapMayProductDetails.get(strKey).id;
            Decimal dPrice = mapPriceBookDetails.get(prodID).unitprice;
            system.debug('dPrice == ' + dPrice);
            return dPrice;
        }
        return null;
    }
    
    
    public static Map < String, wrapperProductInfo > getMiscellaneousProdCodes(Map < String, wrapperProductInfo > returnMap) {
        Set < String > setProdCodes = new set < String > ();
        setProdCodes.add('SLSTX');
        setProdCodes.add('SHIP');
        setProdCodes.add('PRFEE');
        setProdCodes.add('MISC');
        setProdCodes.add('AFREE');
        setProdCodes.add('MEMF');
        setProdCodes.add('MEMI');
        wrapperProductInfo objWrapper;
        if (returnMap == null) returnMap = new Map < String, wrapperProductInfo > ();
        for (PriceBookEntry PricebookEntryId: [select unitprice, productcode, product2Id, product2.Gl_code__c from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode in : setProdCodes and isActive = true]) {
            if (PricebookEntryId.productcode.indexOf('SLSTX') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = 0;
                objWrapper.strTaxGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strTaxProdCode = PricebookEntryId.productcode;
                returnMap.put('TAX', objWrapper);
                
            } else if (PricebookEntryId.productcode.indexOf('SHIP') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = 0;
                objWrapper.strShippingGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strShippingProdCode = PricebookEntryId.productcode;
                returnMap.put('Shipping', objWrapper);
                
            } else if (PricebookEntryId.productcode.indexOf('PRFEE') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strDeferredPaymentGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strDeferrePaymentProdCode = PricebookEntryId.productcode;
                returnMap.put('DeferredPayment', objWrapper);
                
            } else if (PricebookEntryId.productcode.indexOf('MISC') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strCanadianTaxGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strCanadianTaxProdCode = PricebookEntryId.productcode;
                returnMap.put('CanadianTax', objWrapper);
                
            } else if (PricebookEntryId.productcode.indexOf('AFREE') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strAffiliateGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strAffiliateProdCode = PricebookEntryId.productcode;
                returnMap.put('Affiliate', objWrapper);
                
            } else if (PricebookEntryId.productcode.indexOf('MEMF') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strFreeIndividualGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strFreeIndividualProdCode = PricebookEntryId.productcode;
                returnMap.put('FreeMembership', objWrapper);
            } else if (PricebookEntryId.productcode.indexOf('MEMI') >= 0) {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = PricebookEntryId.unitprice;
                objWrapper.strMemberGLCode = PricebookEntryId.product2.Gl_code__c;
                objWrapper.strMemberProdCode = PricebookEntryId.productcode;
                returnMap.put('MEMI', objWrapper);
            }
            
            
        }
        system.debug('mapWrapper 1== ' + returnMap);
        return returnMap;
    }
    
    
    public static Map < String, wrapperProductInfo > getFBRICBRProductCodes(string strProdType, String email, String teamCode) {
        Set < String > setProdCodes = new set < String > ();
        if (strProdType == 'FBR') {
            setProdCodes.add('FBRNM');
            setProdCodes.add('FCBR');
            setProdCodes.add('MEMI');
            setProdCodes.add('MEMC');
        } 
        else if (strProdType == 'FBRA') {
            setProdCodes.add('FBRA');
            
        }else if (strProdType == 'ICBRR') {
            setProdCodes.add('CBRNM');
            setProdCodes.add('CBR');
            setProdCodes.add('MEMI');
            setProdCodes.add('MEMC');
        } else if (strProdType == 'WILEY') {
            setProdCodes.add('MEMW');
        } else if (strProdType == 'RISKNET') {
            setProdCodes.add('MEMR');
        } else if (strProdType == 'INDIVIDUAL') {
            setProdCodes.add('MEMI');
            setProdCodes.add('MEMW');
            setProdCodes.add('MEMR');
        } else if (strProdType == 'STUDENT') {
            setProdCodes.add('MEMS');
            setProdCodes.add('MEMW');
            setProdCodes.add('MEMR');
        }
        
        System.debug('setProdCodes:' + setProdCodes);
        System.debug('email:' + email);
        
        // Select Product Offer Rates
        MAP<String,Product_Rate_Offering__c> mapRates = new MAP<String,Product_Rate_Offering__c>();
        LIST<Product_Rate_Offering__c> lstRates = [select id, Customer_Email__c, Offer_Amount__c, Attestation_Required__c, 
                                                   Attestation_Copy__c, Current_Product__r.ProductCode, Discount_Product__r.ProductCode, 
                                                   Discount_Product__r.GL_Code__c from Product_Rate_Offering__c where 
                                                   Current_Product__r.ProductCode in :setProdCodes AND 
                                                   Customer_Email__c = :email AND Status__c = 'Active'];
        if(lstRates != NULL && lstRates.size() > 0) {
            for(Product_Rate_Offering__c por :lstRates) {
                mapRates.put(por.Current_Product__r.ProductCode, por);    
            }
        }
        System.debug('mapRates:' + mapRates);
        
        // Team Registrations
        //String teamCode = 'SAOT2O!YR';
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
        
        Map < String, wrapperProductInfo > mapWrapper = new Map < String, wrapperProductInfo > ();
        wrapperProductInfo objWrapper;
        for (PriceBookEntry objPriceBook: [
            SELECT UnitPrice, ProductCode, Product2Id, Product2.Gl_code__c 
            FROM PriceBookEntry 
            WHERE Pricebook2.IsActive = true AND Pricebook2.IsActive = true AND productcode IN :setProdCodes AND isActive = true
        ]){
            system.debug('objPriceBook == ' + objPriceBook);
            system.debug('objPriceBook Gl_code__c == ' + objPriceBook.product2.Gl_code__c);
            
            if (objPriceBook.productcode.indexOf('FBRA') >= 0 && objPriceBook.product2.Gl_code__c == '4000') {
                objWrapper = mapWrapper.get('FBRA');
                if(objWrapper == null)
                    objWrapper = new wrapperProductInfo();
                
                objWrapper.dFCBRAMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strFCBRAMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strFCBRAMemberProdCode = objPriceBook.productcode;
                objWrapper.dFCBRANonMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strFCBRANonMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strFCBRANonMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('FBRA', objWrapper);   
                
            } 
            else if (objPriceBook.productcode.indexOf('FCBR') >= 0 && objPriceBook.product2.Gl_code__c == '4000') {
                objWrapper = mapWrapper.get('FBR');
                if(objWrapper == null)
                    objWrapper = new wrapperProductInfo();
                
                objWrapper.dFCBRMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strFCBRMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strFCBRMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('FBR', objWrapper);   
                
            } else if (objPriceBook.productcode.indexOf('FBRNM') >= 0 && objPriceBook.product2.Gl_code__c == '4000') {
                objWrapper = mapWrapper.get('FBR');
                if(objWrapper == null)
                    objWrapper = new wrapperProductInfo();
                
                objWrapper.dFCBRNonMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strFCBRNonMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strFCBRNonMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('FBR', objWrapper);                
                
            } else if (objPriceBook.productcode == 'CBR' && objPriceBook.product2.Gl_code__c == '4000') {
                
                system.debug('IN CBR');
                
                objWrapper = mapWrapper.get('ICBRR');
                system.debug('GET ICBRR: ' + objWrapper);
                
                if(objWrapper == null) {
                    system.debug('New objWrapper');
                    objWrapper = new wrapperProductInfo();
                }
                                
                objWrapper.dCBRMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strCBRMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strCBRMemberProdCode = objPriceBook.productcode;
                system.debug('Add objWrapper:' + objWrapper);
                
                // Rate Offer?
                Product_Rate_Offering__c fndRate = mapRates.get(objPriceBook.productcode);
                System.debug('fndRate:' + fndRate); 
                if(fndRate != NULL) {
                    if(fndRate.Discount_Product__r.ProductCode != NULL) {
                        // Set normal product to $0
                        //objWrapper.dCBRMemberExamAmt = 0;
                        
                        // Add Discount Product
                        objWrapper.dCBRCorpMemberExamAmt = fndRate.Offer_Amount__c;
                        objWrapper.strCBRCorpMemberGlCode = fndRate.Discount_Product__r.GL_Code__c;
                        objWrapper.strCBRCorpMemberProdCode = fndRate.Discount_Product__r.ProductCode;
                        if(fndRate.Attestation_Required__c == True) {
                            objWrapper.strCBRCorpMemberAttestaionCopy = fndRate.Attestation_Copy__c;   
                        }
                        
                    } else {
                        objWrapper.dCBRMemberExamAmt = fndRate.Offer_Amount__c;
                    }
                }
                
                // Team Registration
                System.debug('teamReg:' + teamReg); 
                if(teamReg != NULL) {
                    
                    System.debug('productcode:' + objPriceBook.productcode); 
                    System.debug('Gl_code__c:' + objPriceBook.product2.Gl_code__c); 
                    
                    Team_Registration_Products__c findTrp = mapTeamProds.get(objPriceBook.productcode + '~' + objPriceBook.product2.Gl_code__c);
                    System.debug('findTrp:' + findTrp); 
                    if(findTrp != NULL) {
                        
                        if(teamReg.Attestation_Required__c == True) {
                            objWrapper.strCBRCorpMemberAttestaionCopy = teamReg.Attestation_Copy__c;   
                        }
                        
                        if(teamReg.Discounted_Price__c != NULL) {
                            // Add Discount Product
                            objWrapper.dCBRCorpMemberExamAmt = teamReg.Discounted_Price__c;
                            objWrapper.strCBRCorpMemberGlCode = findTrp.GL_Code__c;
                            objWrapper.strCBRCorpMemberProdCode = findTrp.Product_Code__c;
                        } else {
                            objWrapper.strCBRCorpPrepay = true;
                        }
                        
                        System.debug('findTrp:' + findTrp); 
                        
                    }
                }
                
                mapWrapper.put('ICBRR', objWrapper);   
                system.debug('Put mapWrapper:' + mapWrapper);
                
            } else if (objPriceBook.productcode == 'CBRNM' && objPriceBook.product2.Gl_code__c == '4000') {
                system.debug('IN CBRNM');
                
                objWrapper = mapWrapper.get('ICBRR');
                system.debug('GET ICBRR: ' + objWrapper);
                
                if(objWrapper == null) {
                    system.debug('New objWrapper');
                    objWrapper = new wrapperProductInfo();
                }
                
                
                objWrapper.dCBRNonMemberExamAmt = objPriceBook.unitprice;
                objWrapper.strCBRNonMemberGlCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strCBRNonMemberProdCode = objPriceBook.productcode;
                system.debug('Add objWrapper:' + objWrapper);
                
                // Rate Offer?
                Product_Rate_Offering__c fndRate = mapRates.get(objPriceBook.productcode);
                System.debug('fndRate:' + fndRate); 
                if(fndRate != NULL) {
                    if(fndRate.Discount_Product__r.ProductCode != NULL) {
                        
                        // Add Discount Product
                        objWrapper.dCBRCorpNonMemberExamAmt = fndRate.Offer_Amount__c;
                        objWrapper.strCBRCorpNonMemberGlCode = fndRate.Discount_Product__r.GL_Code__c;
                        objWrapper.strCBRCorpNonMemberProdCode = fndRate.Discount_Product__r.ProductCode;
                        
                        if(fndRate.Attestation_Required__c == True) {
                            objWrapper.strCBRCorpNonMemberAttestaionCopy = fndRate.Attestation_Copy__c;   
                        }                        
                                                
                    } else {
                        objWrapper.dCBRNonMemberExamAmt = fndRate.Offer_Amount__c;
                    }
                }
                
                // Team Registration
                if(teamReg != NULL) {
                    Team_Registration_Products__c findTrp = mapTeamProds.get(objPriceBook.productcode + '~' + objPriceBook.product2.Gl_code__c);
                    if(findTrp != NULL) {
                        
                        if(teamReg.Attestation_Required__c == True) {
                            objWrapper.strCBRCorpMemberAttestaionCopy = teamReg.Attestation_Copy__c;   
                        }
                        
                        if(teamReg.Discounted_Price__c != NULL) {
                            // Add Discount Product
                            objWrapper.dCBRCorpNonMemberExamAmt = teamReg.Discounted_Price__c;
                            objWrapper.strCBRCorpNonMemberGlCode = findTrp.GL_Code__c;
                            objWrapper.strCBRCorpNonMemberProdCode = findTrp.Product_Code__c;
                        } else {
                            objWrapper.strCBRCorpPrepay = true;
                        }
                        
                        System.debug('findTrp:' + findTrp); 

                    }
                }
                
                mapWrapper.put('ICBRR', objWrapper);           
                system.debug('Put mapWrapper:' + mapWrapper);
                
            } else if (objPriceBook.productcode.indexOf('MEMI') >= 0 && objPriceBook.product2.Gl_code__c == '4040') {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strMemberGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('MEMI', objWrapper);
                
            } else if (objPriceBook.productcode.indexOf('MEMC') >= 0 && objPriceBook.product2.Gl_code__c == '4040') {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strMemberGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('MEMC', objWrapper);
                
            } else if (objPriceBook.productcode.indexOf('MEMS') >= 0 && objPriceBook.product2.Gl_code__c == '4040') {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strMemberGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strMemberProdCode = objPriceBook.productcode;
                mapWrapper.put('MEMS', objWrapper);
                
            } else if (objPriceBook.productcode.indexOf('MEMW') >= 0 && objPriceBook.product2.Gl_code__c == '2007') {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strWileyGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strWileyProdCode = objPriceBook.productcode;
                mapWrapper.put('WILEY', objWrapper);
            } else if (objPriceBook.productcode.indexOf('MEMR') >= 0 && objPriceBook.product2.Gl_code__c == '2007') {
                objWrapper = new wrapperProductInfo();
                objWrapper.dMemberAmt = objPriceBook.unitprice;
                objWrapper.strRiskNetGLCode = objPriceBook.product2.Gl_code__c;
                objWrapper.strRiskNetProdCode = objPriceBook.productcode;
                mapWrapper.put('RISKNET', objWrapper);
            }
            
        }
        system.debug('mapWrapper == ' + mapWrapper);
        return mapWrapper;
    }
    
    public static Boolean getMonthDetailsOfProdCodes(
        String strExamName, 
        String strExamStage, 
        Integer iMonth, 
        wrapperProductInfo objProductWrapper,
        Map < String, Product2 > mapMayProductDetails, 
        Map < Id, PriceBookEntry > mapPriceBookDetails
    ) {
        String strGLCode = (iMonth == 5 ? '4001' : '4002');
        system.debug('strGLCode == ' + strGLCode);
        String strProdCode = (strExamName.indexOf('FRM Part 1') >= 0 ? 'FRM1' :strExamName.indexOf('FRM Part 2') >= 0 ? 'FRM2':strExamName.indexOf('ERP Exam Part II') >= 0 ? 'ENC2':strExamName.indexOf('ERP Exam Part I') >= 0 ? 'ENC1':'ERP') + strExamStage;
        system.debug('strProdCode == ' + strProdCode);
        system.debug('strExamName == ' + strExamName);
        if (strExamName.indexOf('FRM Part 1') >= 0) {
            
            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'FRM Part I';
            
            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strFRMOneBookProdCode = 'FRM1H';
            objProductWrapper.strFRMOneBookGLCode = '4030';
            objProductWrapper.dFRMOneBookAmount = getProdPrice(objProductWrapper.strFRMOneBookGLCode + objProductWrapper.strFRMOneBookProdCode, mapMayProductDetails, mapPriceBookDetails);
            
            objProductWrapper.strFRMOneEnrollmentProdCode = 'FRM1';
            objProductWrapper.strFRMOneEnrollmentGLCode = '4010';
            if(bFRMPaidFor2009)
            {
                objProductWrapper.dFRMOneEnrollmentAmount = 250;
                objProductWrapper.returning = true;
            }
            else if(!bHasFRMEnrollment)
            {
                if (dStandardAmount != 0) objProductWrapper.dFRMOneEnrollmentAmount = dStandardAmount;
                else objProductWrapper.dFRMOneEnrollmentAmount = getProdPrice(objProductWrapper.strFRMOneEnrollmentGLCode + objProductWrapper.strFRMOneEnrollmentProdCode, mapMayProductDetails, mapPriceBookDetails);
            }
            
            
        } else if (strExamName.indexOf('FRM Part 2') >= 0) {
            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'FRM Part II';
            
            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strFRMTwoBookProdCode = 'FRM2H';
            objProductWrapper.strFRMTwoBookGLCode = '4030';
            objProductWrapper.dFRMTwoBookAmount = getProdPrice(objProductWrapper.strFRMTwoBookGLCode + objProductWrapper.strFRMTwoBookProdCode, mapMayProductDetails, mapPriceBookDetails);
            
        } else if (strExamName.indexOf('ERP Exam Part II') >= 0) {
            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'ERP Exam Part II';
            
            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strERPTwoBookProdCode = 'ENC2B';
            objProductWrapper.strERPTwoBookGLCode = '4030';
            objProductWrapper.dERPTwoBookAmount = getProdPrice(objProductWrapper.strERPTwoBookGLCode + objProductWrapper.strERPTwoBookProdCode, mapMayProductDetails, mapPriceBookDetails);
            
        }   else if (strExamName.indexOf('ERP Exam Part I') >= 0) {
            objProductWrapper.examPrice = getProdPrice(strGLCode + strProdCode, mapMayProductDetails, mapPriceBookDetails);
            objProductWrapper.strGLCode = strGLCode;
            objProductWrapper.strProductCode = strProdCode;
            objProductWrapper.strDisplayName = 'ERP Exam Part I';
            
            //Populate Book and Enrollment below to the wrapper
            objProductWrapper.strERPOneBookProdCode = 'ENC1B';
            objProductWrapper.strERPOneBookGLCode = '4030';
            objProductWrapper.dERPOneBookAmount = getProdPrice(objProductWrapper.strERPOneBookGLCode + objProductWrapper.strERPOneBookProdCode, mapMayProductDetails, mapPriceBookDetails);
            
            objProductWrapper.strERPOneEnrollmentProdCode = 'ENC';
            objProductWrapper.strERPOneEnrollmentGLCode = '4010';
            
            if(bERPPaidFor2009)
            {
                objProductWrapper.dERPEnrollmentAmount = 250;
                objProductWrapper.returning = true;
            }else if(!bHasERPEnrollment){
                objProductWrapper.dERPEnrollmentAmount = getProdPrice(objProductWrapper.strERPOneEnrollmentGLCode + objProductWrapper.strERPOneEnrollmentProdCode, mapMayProductDetails, mapPriceBookDetails);
            }
        } else {
            return false;
        }
        
        return true;
        
    }
    
    //Changed on July 8/2014
    public static Map < String, wrapperProductInfo > getExamFee1(List < Exam__c > lstExamDetails) {
        system.debug('lstExamDetails ==' + lstExamDetails);
        if (lstExamDetails == null) return null;
        Set < String > setProdCodes = new Set <String> {'FRM1L', 'FRM1S', 'FRM1E', 'FRM2L', 'FRM2S', 'FRM2E', 'ENC1E', 'ENC1L', 'ENC1S','ENC2E', 'ENC2L', 'ENC2S', 'FRM1H', 'FRM2H', 'FRM1', 'ENC', 'ENC1B', 'ENC2B', 'FBRA'};
            
            Map < String, Product2 > mapMayProductDetails = new Map < String, Product2 > ();
        Map < Id, PriceBookEntry > mapPriceBookDetails = new Map < ID, PriceBookEntry > ();
        system.debug('Product2>>>'+[select id, productcode, name, IsActive, GL_Code__c from Product2]);
        for (Product2 objProd: [select id, productcode, name, IsActive, GL_Code__c from Product2 where productcode in : setProdCodes and isActive = true]) {
            mapMayProductDetails.put(objProd.GL_Code__c + objProd.productcode, objProd);
        }
        for (PriceBookEntry PricebookEntryId: [select unitprice, productcode, product2Id from PriceBookEntry where Pricebook2.IsActive = true and productcode in : setProdCodes and isActive = true]) {
            mapPriceBookDetails.put(PricebookEntryId.product2Id, PricebookEntryId);
            
        }
        system.debug('mapMayProductDetails == '+mapMayProductDetails);
        system.debug('mapPriceBookDetails == '+mapPriceBookDetails);
        List < wrapperProductInfo > lstWrapper = new List < wrapperProductInfo > ();
        wrapperProductInfo objWrapper;
        Decimal dExamFee = 0;
        String strProdCode = '';
        system.debug('mapMayProductDetails>>>'+mapMayProductDetails);
        Map < String, wrapperProductInfo > mapWrapper = new Map < String, wrapperProductInfo > ();
        Boolean productsSet = false;
        for (Exam__c objExam: lstExamDetails) {
            objWrapper = new wrapperProductInfo();
            if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Early_Registration__c) {
                productsSet =getMonthDetailsOfProdCodes(objExam.Exam__c, 'E', objExam.Exam_Date__c.month(), objWrapper, mapMayProductDetails, mapPriceBookDetails);
                
            } else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Standard_Registration__c) {
                productsSet =getMonthDetailsOfProdCodes(objExam.Exam__c, 'S', objExam.Exam_Date__c.month(), objWrapper, mapMayProductDetails, mapPriceBookDetails);
                
            } else if (system.today() <= objExam.Exam_Group__r.Last_Date_For_Late_Registration__c) {
                productsSet =getMonthDetailsOfProdCodes(objExam.Exam__c, 'L', objExam.Exam_Date__c.month(), objWrapper, mapMayProductDetails, mapPriceBookDetails);
                
            }
            
            if(productsSet == true) {
                //String strExamName = (objExam.Exam__c.indexOf('FRM Part 1') >= 0 ? 'FRMPartOne' :(objExam.Exam__c.indexOf('FRM Part 2') >= 0 ? 'FRMPartTwo' : objExam.Exam__c));
                String strExamName = (objExam.Exam__c.indexOf('FRM Part 1') >= 0 ? 'FRMPartOne' :(objExam.Exam__c.indexOf('FRM Part 2') >= 0 ? 'FRMPartTwo' : (objExam.Exam__c.indexOf('ERP Exam Part II') >= 0 ? 'ERPPartTwo' : objExam.Exam__c.indexOf('ERP Exam Part I') >= 0 ? 'ERPPartOne' : objExam.Exam__c)));
                //:(objExam.Exam__c.indexOf('ERP Exam Part II') >= 0 ? 'ERPPartTwo' : objExam.Exam__c):(objExam.Exam__c.indexOf('ERP Exam Part I') >= 0 ? 'ERPPartOne' : objExam.Exam__c)
                mapWrapper.put(strExamName, objWrapper);
            }
        }
        
        system.debug('mapWrapper>>>'+mapWrapper);
        
        return mapWrapper;
    }

    public static Map < String, Registration.wrapperProductInfo > getProductCodes1(String strExamType, String email) {
        return getProductInternal(strExamType, email, null);
    }
    
    public static Map < String, Registration.wrapperProductInfo > getProductInternal(String strExamType, String email, String teamCode) {
        Id currentUSer = userInfo.getuserId();
        system.debug('currentUSer == ' + currentUSer);
        system.debug('teamCode:' + teamCode);
        
        User objUSer = [select id, Email, contactId from user where id = : currentUSer];
        system.debug('objUSer == ' + objUSer);
        List < Exam_Attempt__c > lstExamAttempts = [
            SELECT Id, Defered__c, Member__c, Exam_Date__c, Exam_Site__c, Exam_Site__r.site__c, Section__c, Result__c, Candidate_Commitment__c, Candidate_Commitment__r.Status, Exam_Site__r.Exam__r.Exam_Group__r.Active__c 
            FROM Exam_Attempt__c 
            WHERE 
                Candidate_Commitment__r.Status = : 'Activated' AND 
                Member__c = : objUser.contactId AND 
                Cancelled__c != true 
                ORDER BY Exam_Date__c DESC
        ];
        
        List < String > lstExamNames = new List < String > ();
        if (strExamType == 'FRM') {
            lstExamNames.add('FRM Part 1');
            lstExamNames.add('FRM Part 2');
        } else if(strExamType == 'ERP'){
            lstExamNames.add('ERP Exam Part I');
            lstExamNames.add('ERP Exam Part II');}
        
        Map < String, wrapperProductInfo > mapWrapper = new Map < String, wrapperProductInfo > ();
        if (strExamType == 'FBR' || strExamType == 'ICBRR' || strExamType == 'INDIVIDUAL' || strExamType == 'STUDENT' || strExamType == 'WILEY' || strExamType == 'RISKNET' || strExamType == 'FBRA') {
            mapWrapper = getFBRICBRProductCodes(strExamType, email, teamCode);
            mapWrapper = getMiscellaneousProdCodes(mapWrapper);
        } else {
            mapWrapper = getExamFee1(getExamDetails(lstExamNames));
            mapWrapper = getMiscellaneousProdCodes(mapWrapper);
        }
        
        return mapWrapper;
        
        
        
    }
    public static Decimal getPrice(String strProductCode) {
        if (strProductCode == null) return null;
        String strExamName = '';
        if (strProductCode == 'GL0008')
            strExamName = 'FRM Part 1';
        else if (strProductCode == 'GL0009')
            strExamName = 'FRM Part 2';
        else if (strProductCode == 'GL0016')
            strExamName = 'ERP';
        if (strExamName != '') {
            Map < String, decimal > mapExamFees = getExamFee(getExamDetails(new List < String > {
                strExamName
                    }));
            if (mapExamFees == null) return 0;
            return mapExamFees.get(strExamName);
        } else {
            try {
                PriceBookEntry objPricebook = [select unitprice, productcode, Product2Id, Pricebook2Id, Name from PriceBookEntry where Pricebook2.IsActive = true and Pricebook2.IsActive = true and productcode = : strProductCode and isActive = true limit 1];
                return objPricebook.unitprice;
            } catch (exception ex) {
                return 0;
                
            }
        }
    }
    
    public static boolean chapterMeetingRegister(String contactId, String chapterMeetingId, Boolean isComing) {
        List < Chapter_Meeting_Registration__c > lstChapterMeetingRegistrations = [select Id, Name, Status__c from Chapter_Meeting_Registration__c where Chapter_Meeting__c = : chapterMeetingId and Contact__c = : contactId];
        if (lstChapterMeetingRegistrations != null && lstChapterMeetingRegistrations.size() > 0) {
            
            if (!isComing) {
                delete lstChapterMeetingRegistrations[0];
            }
            
        } else if (isComing) {
            
            Chapter_Meeting_Registration__c newChapterMeetingRegistration = new Chapter_Meeting_Registration__c();
            newChapterMeetingRegistration.put('Status__c', 'Confirmed');
            newChapterMeetingRegistration.put('Role__c', 'Registrant');
            newChapterMeetingRegistration.put('Chapter_Meeting__c', chapterMeetingId);
            newChapterMeetingRegistration.put('Contact__c', contactId);
            insert newChapterMeetingRegistration;
            
        }
        return true;
    }
    
    public Static String charge(Id opportunityId, String cardMonth, String cardYear, String paymentType, String cardType, String cardSecurity, String cardNumber){
        
        Opportunity opportunity = [
            SELECT Id, Amount 
            FROM opportunity 
            WHERE Id = :opportunityId
        ];
        
        system.debug('Opportunity Amount: ' + opportunity.Amount);
        
        if(opportunity.Amount == 0) {
            
            opportunity.StageName = 'Closed';
            
            UPDATE opportunity;
            
            return 'Closed Opp Approved'; 
            
        } else {
            
            Payment payment = new Payment(cardNumber, cardSecurity, cardMonth, cardYear);
            
            ChargentSFA.TChargentOperations.TChargentResult chargentResponse = payment.charge(opportunity.Id);                
            
            system.debug('Chargent Response: '+ chargentResponse);
            system.debug('Chargent Result: '+ chargentResponse.Message); 
            
            return chargentResponse.Message;
            
        }
        
    }
    
}