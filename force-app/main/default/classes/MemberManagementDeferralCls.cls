public class MemberManagementDeferralCls {
    @AuraEnabled
    Public Static String GARPIdValidation(String GARPId){
        String retval ='';
        List<Contact> conList = [Select Id,Account.BillingStreet,Account.BillingCountry,Account.BillingPostalCode,Account.BillingCity From Contact Where GARP_Member_ID__c=:GARPId And RecordType.Name ='Member'];
        if(conList.isEmpty()){
            retval = 'Error' ;
        }else if(conList[0].Account.BillingStreet == null || conList[0].Account.BillingCountry == null || conList[0].Account.BillingPostalCode == null || conList[0].Account.BillingCity == null){
            retval = 'Error Address';
        }else{
            retval = conList[0].Id;
        }
        return retval;
    }
    
    @AuraEnabled
    Public Static Map<String,Exam_Group__c> getExamGroupsList(){
        Map<String,Exam_Group__c>  exgroupMap = new Map<String,Exam_Group__c>();
        for(Exam_Group__c exgp:[Select Id,Name,Exam_Date__c,Active__c From Exam_Group__c Where (Not Name Like '%SCR%') And  (Not Name Like '%ICBRR%') Order By Exam_Date__c DESC Limit 3]){
            exgroupMap.put(exgp.Id,exgp);
        } 
        return exgroupMap;
    }
    
    
    @AuraEnabled
    Public Static Map<String,List<Exam_Attempt__c>> getexamAttemptDetailsList(String contactId,Date FromExamDate)
    { 
        Map<String,List<Exam_Attempt__c>> examAttemptMapList = new Map<String,List<Exam_Attempt__c>>();
        List<Exam_Attempt__c> examAttemptList = [select id,Name,Exam_Site_Name__c,Site_Code__c,Section__c,
                                                 Candidate_Commitment__r.AccountId,
                                                 Exam_Site__r.Name,Exam_Site__r.Site__r.Name,Defered__c,
                                                 Exam_Site__r.Exam__r.Exam_Group__r.Active__c,
                                                 Exam_Site__r.Exam_Date__c,Exam_Site__r.Exam__r.Exam__c,
                                                 Exam_Date__c,Other_Exam_Registrations__r.Exam_Date__c 
                                                 from Exam_Attempt__c where  Member__c =: contactId  
                                                 and Opportunity_StageName__c ='closed' 
                                                 and result__C =:null And Cancelled__c = false 
                                                 And Exam_Date__c =:FromExamDate order by Exam_Date__c DESC limit 2];
        examAttemptMapList.put('Success',examAttemptList);
        if(!examAttemptList.isEmpty()){
            if(examAttemptList.size() == 2){
                String sec1 = examAttemptList[0].Section__c;
                String sec2 = examAttemptList[1].Section__c;
                if(sec1.substring(0, 3) != sec2.substring(0, 3)){
                    examAttemptMapList = new Map<String,List<Exam_Attempt__c>>();
                    examAttemptList = new List<Exam_Attempt__c>(); 
                    examAttemptMapList.put('Error',examAttemptList);
                }
            }
        }
        system.debug(examAttemptList);
        return examAttemptMapList;
        
    }
    
    public static Map<Id,Opportunity> OSTAoppMap = new Map<Id,Opportunity>();
    @AuraEnabled
    Public Static List<Deferredstatus> updateDeferralDetail(String examAttemptId,String currentExamGrp,String FreeDeferral,String ChargeProcessing,Date FromExamDate,Date ToExamdate)
    { 
        String retval ='';
        Integer iCount = 0;
        String strPaymentId = '';
        String examName = '';
        boolean bWire = false;
        boolean charge = false;
        boolean refund = false;
        List<Deferredstatus> defstatusList= new List<Deferredstatus>();
        Map<Id,Opportunity> oppmap = new Map<Id,Opportunity>();
        Deferredstatus defwrap = new Deferredstatus();
        try{
            Registration.wrapperCreateOrder wco = new Registration.wrapperCreateOrder();
            List<Exam_Attempt__c>  examAttemptList = [select id,Name,Cloned_From__c,Opportunity__c,Exam_Site__r.Site__r.Is_OSTA_Information_Required__c,Exam_Site_Name__c,Member__c,Result__c,Site_Code__c,Section__c,Candidate_Commitment__r.AccountId,Exam_Site__r.Name,Exam_Site__r.Site__r.Name,Defered__c,Exam_Site__r.Exam__r.Exam_Group__r.Active__c,Exam_Site__r.Exam_Date__c,Exam_Site__r.Exam__r.Exam__c,Exam_Date__c,Other_Exam_Registrations__r.Exam_Date__c from Exam_Attempt__c where  Id =: examAttemptId];
            Exam_Attempt__c objEA = new Exam_Attempt__c();
            if(!examAttemptList.isEmpty()){
                objEA = examAttemptList[0];
                boolean isvalidate = validatedeferral(objEA.Member__c,objEA.Section__c.substring(0, 3));
                if(isvalidate == true){
                    defwrap = new Deferredstatus();
                    defwrap.defType ='Error';
                    defwrap.defStatus = 'We can\'t perform this operation' ;  
                    defstatusList.add(defwrap);
                    return defstatusList;
                }
            }
           
            if(ToExamdate == null && Freedeferral == 'No')
                examName = 'Exam Deferral';
            if(ToExamdate != null && Freedeferral == 'Yes')  
                examName = 'Free Late Exam Deferral';
            if(ToExamdate != null && Freedeferral == 'No')
                examName = 'Late Exam Deferral';
            if(ToExamdate == null && Freedeferral == 'Yes')
                examName = 'Free Exam Deferral';
            if(Freedeferral == 'No' && ChargeProcessing == 'Yes')
                bWire = true;
            if(objEA.Exam_Site__r.Site__r.Is_OSTA_Information_Required__c == true){
                examAttemptList = new List<Exam_Attempt__c>();  
                if(FromExamDate != null){   
                    examAttemptList = [select id,Name,Defered__c,Section__c,Cloned_From__c,Cloned_From__r.Exam_Site__c,Exam_Site__c from Exam_Attempt__c where Member__c =: objEA.Member__c And Cancelled__c = false 
                                       and Opportunity_StageName__c ='closed' 
                                       and result__C =:null 
                                       And Exam_Date__c =:FromExamDate 
                                       order by Exam_Date__c DESC limit 2];
                    for(Exam_Attempt__c examat:examAttemptList){  
                        if(examAttemptList.size() == 2 && objEA.Section__c == 'FRM Part 2'){
                            charge = true;  
                        } 
                        if(examat.Defered__c == 'Pending' && objEA.Section__c == 'FRM Part 1' && objEA.Id != examat.Id){ 
                            refund = true;  
                        }
                    }
                }
                if(ToExamdate != null){ 
                    //objEA Selected Exam Attempt
                    examAttemptList = new List<Exam_Attempt__c>();
                    examAttemptList = [select id,Name,Defered__c,Section__c from Exam_Attempt__c where Member__c =: objEA.Member__c And Cancelled__c = false 
                                       and Opportunity_StageName__c ='closed' 
                                       and result__C =:null 
                                       And Exam_Date__c =:ToExamdate 
                                       order by Exam_Date__c DESC limit 2]; 
                    for(Exam_Attempt__c examat:examAttemptList){ 
                        if(examat.Defered__c == 'Approved' && examat.Section__c == 'FRM Part 2' && objEA.Section__c == 'FRM Part 1'){
                            refund = true; 
                        } 
                    }
                }
            }
            
            if(objEA != null && examName != ''){
                if(objEA.Section__c != null){
                    if(objEA.Section__c != '' && (objEA.Section__c.toLowerCase() == 'frm part 1' || objEA.Section__c.toLowerCase() == 'frm part 2')){
                        wco = portalClass.createOppRecord(ObjEA,examName,'FRM1','4020',bWire); 
                    }else{ 
                        wco = portalClass.createOppRecord(ObjEA,examName,'ENC','4020',bWire);
                    } 
                } 
                if(FreeDeferral == 'Yes'){
                    updateopportunityoli(wco.opportunityId);
                }            
                
                if(charge == true && wco.opportunityId != null){ 
                    Map<String,Decimal> oliMap = createOpportunityLineItems('CHLF','2008',wco.opportunityId,objEA.Id,objEA.Section__c );
                    oppmap = getoppobj(new set<Id>{wco.opportunityId});
                    if(oliMap.containsKey(wco.opportunityId)){ 
                        defwrap = new Deferredstatus();
                        defwrap.defType ='Charge';
                        defwrap.defStatus = 'Success';
                        defwrap.amount = oliMap.get(wco.opportunityId);
                        defwrap.InvoiceNumber = oppmap.get(wco.opportunityId).Display_Invoice_Number__c; 
                        if(oppmap.get(wco.opportunityId).Amount >0)
                            defwrap.CustomerSecureCheck = Label.MemberManagementUrlLabel.replace('oppId',oppmap.get(wco.opportunityId).Id);
                        defstatusList.add(defwrap);
                    }
                }      
                if(FreeDeferral == 'Yes' && charge == false && wco.opportunityId != null){
                    createTransactions(wco.opportunityId);
                }
                if(refund == true){
                    Map<String,Decimal> isProductRefund = new Map<String,Decimal>();
                    isProductRefund = ProductRefunds(objEA.Id,null,wco.opportunityId,FreeDeferral);
                    if(isProductRefund.size() == 0 && objEA.Cloned_From__c != null){
                        isProductRefund = ProductRefunds(objEA.Cloned_From__c,null,wco.opportunityId,FreeDeferral);
                    }
                    if(isProductRefund.size() == 0 && objEA.Opportunity__c != null){
                        isProductRefund = ProductRefunds(null,objEA.Opportunity__c,wco.opportunityId,FreeDeferral);
                    }
                    Set<Id> OppIds = new Set<Id>();
                    for(String s:isProductRefund.keyset()){
                        OppIds.add(s); 
                    }
                    
                    Map<Id,Opportunity> opportunityMap = getoppobj(OppIds);
                    for(String s:isProductRefund.keyset()){
                        if(opportunityMap.containsKey(s)){
                            defwrap = new Deferredstatus();
                            defwrap.defType ='Refund';
                            defwrap.defStatus = 'Success';
                            defwrap.amount = isProductRefund.get(s);
                            defwrap.InvoiceNumber = opportunityMap.get(s).Display_Invoice_Number__c;
                            if(opportunityMap.get(s).Amount >0)
                            defwrap.CustomerSecureCheck = Label.MemberManagementUrlLabel.replace('oppId',opportunityMap.get(s).Id);
                            defstatusList.add(defwrap);
                        }
                    }
                } 
                oppmap = getoppobj(new set<Id>{wco.opportunityId});
                defwrap = new Deferredstatus();
                defwrap.defType ='New Opportunity';
                defwrap.defStatus = 'Success';
                defwrap.amount = oppmap.get(wco.opportunityId).Amount;
                defwrap.InvoiceNumber = oppmap.get(wco.opportunityId).Display_Invoice_Number__c; 
                if(oppmap.get(wco.opportunityId).Amount >0)
                    defwrap.CustomerSecureCheck = Label.MemberManagementUrlLabel.replace('oppId',oppmap.get(wco.opportunityId).Id);
                defstatusList.add(defwrap);
            } 
            if(!OSTAoppMap.Isempty()){
                update OSTAoppMap.values();
            } 
        }catch(Exception ex){
            retval = ex.getMessage();
            defwrap = new Deferredstatus();
            defwrap.defType ='Error';
            defwrap.defStatus = 'Order can\'t be processed Please Contact IT';
            defstatusList.add(defwrap);
        } 
        return defstatusList;
        
    }
    
    
  public Static boolean validatedeferral(String ContactId,String section){
        boolean isvalidate = false; 
        String sec = section;
        if(sec == 'FRM'){
            section = 'ERP';
        }else if(sec =='ERP'){
            section = 'FRM';
        }
         section = '%'+section+'%';
        List<Exam_Attempt__c> examAttemptList = new List<Exam_Attempt__c>();  
                examAttemptList = [select id,Section__c,Defered__c from Exam_Attempt__c where Member__c =:ContactId and Opportunity_StageName__c ='closed' And Cancelled__c = false and result__c =null and Section__c like:section order by Exam_Date__c];
        if(examAttemptList.size()>0){
            isvalidate = true;
        }
        return isvalidate;
    }
    public static Map<Id,Opportunity> getoppobj(Set<Id> oppId){
        Map<Id,Opportunity> opp = new Map<Id,Opportunity>([Select Id,Display_Invoice_Number__c,Name,Amount,Customer_Secure_Checkout_Link__c from Opportunity where Id In:oppId]);  
        return opp;
    }
    
    public class Deferredstatus{
        @AuraEnabled
        public String defType{get;set;}
        @AuraEnabled
        public String defStatus{get;set;}
        @AuraEnabled
        public Decimal amount{get;set;}
        @AuraEnabled
        public String InvoiceNumber{get;set;}
        @AuraEnabled
        public String CustomerSecureCheck{get;set;} 
    }
    
    public static void updateopportunityoli(string oppid){
        List<OpportunityLineItem>  updateoli = [Select Id,Unitprice from OpportunityLineItem where OpportunityId =:oppid];
        for(OpportunityLineItem oli:updateoli){
            oli.Unitprice = 0;
        }
        if(!updateoli.isEmpty()){
            update updateoli;
        }
    }
    
    // create Opportunity Line Items. 
    public static Map<String,Decimal> createOpportunityLineItems(String setProdCodes,String setGlCodes, string oppid,String examAttId,String Section){ 
        list<OpportunityLineItem> oppls = new list<OpportunityLineItem> ();
        Map<String,Decimal> oliMap= new Map<String,Decimal>();
        List<OpportunityLineItem> oliList = [select id from OpportunityLineItem where PricebookEntry.Product2.ProductCode = 'CHLF' and OpportunityId =:oppid];
        if(!oliList.isEmpty()){
            delete oliList;
        }
        for (PriceBookEntry PricebookEntryId: [select unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode = :setProdCodes and product2.Gl_Code__c = :setGlCodes and isActive = true]) {
            system.debug('PricebookEntryId:'+PricebookEntryId);
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = oppid;
            oppLineItem.Exam_Registration__c = examAttId;
            oppLineItem.Description = Section;
            oppLineItem.UnitPrice  = PricebookEntryId.UnitPrice; 
            oppLineItem.PricebookEntryId = PricebookEntryId.Id;
            oppLineItem.Quantity = 1;
            oliMap.put(oppid,PricebookEntryId.UnitPrice);
            oppls.add(oppLineItem);
            if(PricebookEntryId.productcode =='CHLF'){
                Opportunity op = new Opportunity();
                op.Id =oppid;
                op.OSTA_Check__c = true;
                OSTAoppMap.put(oppid,op);
            }
        }
        
        insert oppls;
        return oliMap;
    }
    
    // create Transactions. 
    public static void createTransactions(string oppid){ 
        
        ChargentSFA__Transaction__c Transactions = new ChargentSFA__Transaction__c();
        Transactions.ChargentSFA__Opportunity__c = oppid;
        Transactions.ChargentSFA__Type__c = 'Charge';
        Transactions.ChargentSFA__Response__c ='0';
        Transactions.ChargentSFA__Response_Status__c ='Approved';
        Transactions.ChargentSFA__Response_Message__c='Approved';
        Transactions.ChargentSFA__Gateway_Date__c =system.now();
        Transactions.ChargentSFA__Payment_Method__c ='Free'; 
        Transactions.ChargentSFA__Amount__c = 0;
        
        insert Transactions; 
    }
    
    //  Product Refunds. 
    public static Map<String,Decimal> ProductRefunds(String examAttId,Id examAttOppId,Id newOppId,String freeDef){ 
        Set<Id> olioppId = new Set<Id>();
        Map<String,Decimal> refundAmountOpp = new Map<String,Decimal>();
        boolean iscreated = false;
        String query='';
        query = 'Select Id,OpportunityId,Unitprice From OpportunityLineItem Where Opportunity.Stagename =\'Closed\' And ProductCode =\'CHLF\' And Product2.Gl_Code__c =\'2008\'';
        if(examAttId != null){
            query += ' And Exam_Registration__c=:examAttId';
        }
        if(examAttOppId != null){
            query += ' And OpportunityId=:examAttOppId';
        }
        List<OpportunityLineItem> oliList = database.query(query);
        system.debug(oliList.size());
        for(OpportunityLineItem oli:oliList){
            olioppId.add(oli.OpportunityId);
            refundAmountOpp.put(oli.OpportunityId,oli.Unitprice); 
        } 
        
        if(!olioppId.isEmpty()){ 
            for(Product_Refunds__c pr:[Select Id,Opportunity__c From Product_Refunds__c where Opportunity__c In:olioppId and Product__r.productcode = 'CHLF' and Product__r.Gl_Code__c = '2008']){
                if(olioppId.contains(pr.Opportunity__c)){
                    olioppId.remove(pr.Opportunity__c);
                }
            }
            
            if(!olioppId.isEmpty()){ 
                createProductRefunds(olioppId,refundAmountOpp,newOppId,freeDef); 
                return refundAmountOpp;
            }
        }
        return refundAmountOpp;
    }
    
    //create Product Refunds. 
    public static void createProductRefunds(Set<Id> oppid,Map<String,Decimal> unitpricamap,Id newOppId,String freeDef){ 
        list<Product_Refunds__c> productrefundlist = new list<Product_Refunds__c> ();
        //List<PriceBookEntry> pricebookent=[select unitprice, productcode, product2Id from PriceBookEntry where Pricebook2.IsActive = true and productcode = 'CHLF' and product2.Gl_Code__c = '2008' and isActive = true];
        List<Product2> productList = [select Id,ProductCode from Product2 where IsActive = true and productcode = 'CHLF' and Gl_Code__c = '2008'];
        Map<Id,Id> TransactionMap = new Map<Id,Id>(); 
        for(ChargentSFA__Transaction__c Transactions :[Select Id,ChargentSFA__Opportunity__c From ChargentSFA__Transaction__c Where ChargentSFA__Type__c = 'Charge' 
                                                       And ChargentSFA__Response__c ='0' And ChargentSFA__Response_Status__c ='Approved' And ChargentSFA__Response_Message__c='Approved' And ChargentSFA__Opportunity__c In:oppid]){
            TransactionMap.put(Transactions.ChargentSFA__Opportunity__c,Transactions.Id);                             
        }
        Map<Id,Opportunity> OSTAopprefundMap = new Map<Id,Opportunity>();
        if(!productList.isEmpty()){ 
            for(Id op:oppid){
                system.debug(unitpricamap);
                system.debug(unitpricamap.get(op));
                Product_Refunds__c pr = new Product_Refunds__c();
                pr.Opportunity__c =op;
                pr.Product__c = productList[0].Id;
                if(unitpricamap.containsKey(op))
                    pr.Refund_amount__c = unitpricamap.get(op);
                if(TransactionMap.containsKey(op))
                    pr.Payment_Transaction__c = TransactionMap.get(op);
                productrefundlist.add(pr);
                if(productList[0].ProductCode =='CHLF'){
                    Opportunity opp = new Opportunity();
                    opp.Id = op;
                    opp.OSTA_Check__c = true;
                    OSTAoppMap.put(op,opp);
                }
                if(freeDef == 'No'){
                    Opportunity oppref = new Opportunity();
                    oppref.Id = newOppId;
                    oppref.OSTA_Opportunity_Refund__c = op; 
                    OSTAopprefundMap.put(newOppId,oppref);
                }
            }
        } 
         
        if(!OSTAopprefundMap.isEmpty() && freeDef == 'No'){
            Update OSTAopprefundMap.values();
        }
        if(!productrefundlist.isEmpty() && freeDef == 'Yes'){
            insert productrefundlist;
        }
    } 
}