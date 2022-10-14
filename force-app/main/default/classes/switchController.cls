public class switchController {
    
    @TestVisible public class objectWrapper{
        // Declaring the object variables to store data to clone to FRM.
        @auraEnabled  public string conid ;
        @auraEnabled  public string accid ;
        @auraEnabled  public string Message ;
        @auraEnabled  public list<contract> cr ;
        @auraEnabled  public list<Exam_Attempt__c> ea ;
        @auraEnabled  public opportunity opp ;
        @auraEnabled  public list<ChargentSFA__Transaction__c> tran; 
        @auraEnabled  public list<Product_Refunds__c> pr; 
        @auraEnabled  public list<OpportunityLineItem> oppLine;
        @auraEnabled  public list<Product2> prod;
        
        @TestVisible  public objectWrapper(){
            // initialize above vairables as they are array.     
            cr = new list<contract>();
            ea = new list<Exam_Attempt__c>();
            opportunity opp = new opportunity ();
            tran = new list<ChargentSFA__Transaction__c>();
            pr = new list<Product_Refunds__c>();
            oppLine = new list<OpportunityLineItem>();
            prod = new list<Product2>();
       
        }
        
    }
    
    @TestVisible public class dataWrapper{
        
        // Declaring variables for the data transormation.
        
        @auraEnabled public String conid;
        @auraEnabled public String accid;    
        @auraEnabled public String fname;
        @auraEnabled public String lname;
        @auraEnabled public String examPartOne;
        @auraEnabled public String examPartTwo;
        @auraEnabled public boolean enrollment;
        @auraEnabled public String   exam;
        @auraEnabled public boolean recurring;
        @auraEnabled public String email;
        @auraEnabled public String examsite;
        @auraEnabled public String company;
        @auraEnabled public String addr1;
        @auraEnabled public String addr2;
        @auraEnabled public String addr3;
        @auraEnabled public String country;
        @auraEnabled public String city;
        @auraEnabled public String state;
        @auraEnabled public String zip;
        @auraEnabled public String saddr;
        @auraEnabled public String scountry;
        @auraEnabled public String scity;
        @auraEnabled public String sstate;
        @auraEnabled public String szip;
        @auraEnabled public String phone;
        @auraEnabled public String paymentType;
        @auraEnabled public decimal paymentAmt;
        @auraEnabled public String AUTHCODE;
        @auraEnabled public string chinaSelection;
        @auraEnabled public boolean Membership;
        @auraEnabled public boolean switchToFrm;
        @auraEnabled public string  oldoppid;
        public set<String > setProdCodes;
        public set<String > setGlCodes;
        
        @TestVisible    public dataWrapper(){
            // initialize above vairables as they are array.  
            setProdCodes = new set<String >();
            setGlCodes = new set<String >();
            
        }
    }
    
    @TestVisible public class returnWrapper{
        
        @auraEnabled public string payType ; 
        @auraEnabled public string month;
        @auraEnabled public string  china;
        @auraEnabled public string  examSiteId;
        @auraEnabled public string  Message;
        @auraEnabled public string  invoiceNumber;
        
    }
    
    
    @auraEnabled
    public static returnWrapper returndata(string name){
        returnWrapper re = new returnWrapper ();
        
        opportunity opp =[select id, StageName ,Exam_Registration_Type__c ,Eligible_for_Membership_Extension__c ,Payment_Method__c,ChargentSFA__Tokenization__c,Shipping_Country__c,Shipping_City__c,Auto_Renew__c,Shipping_Postal_Code__c,Shipping_State__c,Shipping_Street__c,Shipping_Phone_No__c,Shipping_E_mail__c,Shipping_First_Name__c,Shipping_Last_Name__c,ChargentSFA__Billing_Zip__c,ChargentSFA__Billing_Country__c,ChargentSFA__Billing_State__c,ChargentSFA__Billing_City__c,ChargentSFA__Billing_Address_Line_2__c,Has_Books__c,ChargentSFA__Billing_Address__c,ChargentSFA__Billing_Company__c,ChargentSFA__Billing_Phone__c,ChargentSFA__Billing_First__c,ChargentSFA__Billing_Last__c,ChargentSFA__Billing_Email__c, Display_Invoice_Number__c,accountid  from opportunity where Display_Invoice_Number__c =:name]; 
        system.debug('opp:'+opp);
        
        if(opp.Has_Books__c == true ){
            re.Message ='This opprotunity has books and cannot do switch.';}
        if(opp.StageName !='closed')
            re.Message ='This opprotunity is not closed please close it first.';
        
        re.payType  =opp.Exam_Registration_Type__c;
        re.invoiceNumber   = opp.Display_Invoice_Number__c;
        
        list<exam_attempt__C> ea =[select id, Exam_Site__r.name from exam_attempt__C where Exam_Site__r.name like'%china%' and(not Exam_Site__r.name like '%Hong Kong%') and  Opportunity__c=:opp.id];
        
        if(ea.size()>0){
            re.china = 'Yes';}
        if(ea.size()==0){
            re.china = 'No';}
        
        return re;      
        
    }
    @auraEnabled
    public static objectWrapper cancelErpOrder(string name , string payType ,string china,string examSiteId){
        @TestVisible  objectWrapper data = new objectWrapper ();
        @TestVisible dataWrapper m = new dataWrapper ();
        
        system.debug('%%%%%%:'+name);
        system.debug('payType:'+payType);
        system.debug('china:'+china);
        system.debug('examSiteId:'+examSiteId);
        
        
        
        
        // cancel Erp order and assigning variables.
        
        opportunity opp =[select id, StageName ,Switch_to_frm__c ,Exam_Registration_Type__c ,Program__c,Eligible_for_Membership_Extension__c ,Payment_Method__c,ChargentSFA__Tokenization__c,Shipping_Country__c,Shipping_City__c,Auto_Renew__c,Shipping_Postal_Code__c,Shipping_State__c,Shipping_Street__c,Shipping_Phone_No__c,Shipping_E_mail__c,Shipping_First_Name__c,Shipping_Last_Name__c,ChargentSFA__Billing_Zip__c,ChargentSFA__Billing_Country__c,ChargentSFA__Billing_State__c,ChargentSFA__Billing_City__c,ChargentSFA__Billing_Address_Line_2__c,Has_Books__c,ChargentSFA__Billing_Address__c,ChargentSFA__Billing_Company__c,ChargentSFA__Billing_Phone__c,ChargentSFA__Billing_First__c,ChargentSFA__Billing_Last__c,ChargentSFA__Billing_Email__c, Display_Invoice_Number__c,accountid  from opportunity where Display_Invoice_Number__c =:name]; 
        system.debug('opp:'+opp);
        
        
        if(opp.Has_Books__c == true || opp.StageName !='closed' ||(china=='yes' && (examSiteId=='' || examSiteId=='null'))){
            if(opp.Has_Books__c == true)
                data.Message ='This opprotunity has books and cannot do switch.';
            else if(opp.Program__c=='FRM')
                data.Message ='Switch can only be done from Erp to Frm,please select correct opportunity.';
            else if(opp.StageName !='closed')
                data.Message ='This opprotunity is not closed please close it first.';
            else if(china=='yes' && (examSiteId=='' || examSiteId=='null'))  
                data.Message ='please Input Exam Site Id.';
           
           else  if((examSiteId!='' || examSiteId!='null')){
                list<Exam_Sites__c> es = [Select id,site__C from Exam_Sites__c where Site__c= :examSiteId  and Exam__r.Exam_Group__r.Active__c = true];
                if(es.size()==0)
                    data.Message ='No site Found with the Id, please enter a valid Site Id.'; 
            }
            return data;
        }
        
        system.debug('opp.ChargentSFA__Billing_First__c:'+opp.ChargentSFA__Billing_First__c);
        m.fname = opp.ChargentSFA__Billing_First__c; 
        m.lname =opp.ChargentSFA__Billing_Last__c ;
        m.email =opp.ChargentSFA__Billing_Email__c ;
        m.phone =opp.ChargentSFA__Billing_Phone__c ;
        m.company =opp.ChargentSFA__Billing_Company__c; 
        m.addr1 =opp.ChargentSFA__Billing_Address__c; 
        m.addr2 =opp.ChargentSFA__Billing_Address_Line_2__c ;
        m.city =opp.ChargentSFA__Billing_City__c     ;
        m.state =opp.ChargentSFA__Billing_State__c  ;   
        m.country =opp.ChargentSFA__Billing_Country__c;
        m.zip =opp.ChargentSFA__Billing_Zip__c ;
        m.saddr =opp.Shipping_Street__c ;
        m.scity =opp.Shipping_City__c ;
        m.sstate =opp.Shipping_State__c ;
        m.szip =opp.Shipping_Postal_Code__c ;
        m.recurring =opp.Auto_Renew__c ;
        m.scountry =opp.Shipping_Country__c;
        m.AUTHCODE =opp.ChargentSFA__Tokenization__c ;
        m.paymentType =opp.Payment_Method__c ;   
        m.accid = opp.accountid;
        m.Membership = opp.Eligible_for_Membership_Extension__c ;
        m.chinaSelection = china;
        if(examSiteId !='' ||examSiteId !='null')
            m.examsite = examSiteId;
        system.debug('cc:'+m.accid);
        m.conid =[select id from contact where AccountId=:m.accid].id;
        
        // CALLING NEXT METHOD.
        
        cancelErpContracts(data,opp.id);
        cancelErpExamAttempts(m,data,opp.id); 
        string tranId= createDebitTransaction(m,opp.id); 
        if(tranId !='null' ||tranId !='')
            createprodcutrefund( m,opp.id,tranId,data,payType);
        
        // THIS IS FOR THE LIGHTENING TO KNOW THE RESPONSE.
        data.Message = 'sucess';
        return data;
        
    }
    
    @auraEnabled
    public static void cancelErpContracts(objectWrapper data, string oppid){ 
        
        data.cr =[select id, Opportunity__c,status   from contract where Opportunity__c=:oppid];
        list<contract> cc = new list<contract>();
        for(contract cron : data.cr){
            
            cron.status='Canceled';
            cc.add(cron);
        }
        system.debug('cc:'+cc);
        if(cc.size()>0)
            update cc;
        
        
    }
    
    @auraEnabled 
    public static void cancelErpExamAttempts(dataWrapper m,objectWrapper data, string oppid){   
        
        // cancel exam attempt.
        
            data.ea =[select id, Cancelled__c,Member__c, Exam_Site__r.site__C,Exam_Site__r.site__r.name from Exam_Attempt__c where Opportunity__c=:oppid];
        list<Exam_Attempt__c> ea = new list<Exam_Attempt__c>();
        for(Exam_Attempt__c ee : data.ea){
            if(m.chinaSelection!='Yes') 
                m.examsite=ee.Exam_Site__r.site__C; 
            system.debug(' m.examsite:'+ m.examsite);
            ee.Cancelled__c=true;
            ee.Cancel_Reason__c='switch';
            ea.add(ee);
        }
        system.debug('ea:'+ea);
        if(ea.size()>0)
            update ea;
    
    }
    
    @auraEnabled
    public static string createDebitTransaction(dataWrapper m, string oppid){  
        
        list<ChargentSFA__Transaction__c> newtranList = new list<ChargentSFA__Transaction__c> ();
        ChargentSFA__Transaction__c tran = [select id, ChargentSFA__Opportunity__c ,ChargentSFA__Type__c,ChargentSFA__Response__c,ChargentSFA__Response_Status__c,ChargentSFA__Gateway_Date__c,ChargentSFA__Amount__c     from ChargentSFA__Transaction__c where ChargentSFA__Opportunity__c =:oppid and ChargentSFA__Type__c ='charge' and ChargentSFA__Response_Status__c ='Approved'];
        system.debug('tran:'+tran);
        ChargentSFA__Transaction__c newtran = new ChargentSFA__Transaction__c ();
        
        newtran.ChargentSFA__Opportunity__c =oppid;
        newtran.ChargentSFA__Type__c    ='Debit';
        newtran.ChargentSFA__Response__c ='0';
        newtran.ChargentSFA__Response_Status__c ='Approved';
        newtran.ChargentSFA__Response_Message__c ='Approved';
        newtran.ChargentSFA__Gateway_Date__c  = system.now();
       
        newtran.ChargentSFA__Amount__c = -(tran.ChargentSFA__Amount__c);
        m.paymentAmt =tran.ChargentSFA__Amount__c;
        
        newtranList.add(newtran);
        if(newtranList.size()>0)
            insert newtranList;
        
        return newtranList[0].id;
        
    } 
    
    // This method refunds and also does the logic of what needs to be created as FRM opplinitems and the cost.    
    @auraEnabled
    public static void createprodcutrefund(dataWrapper m, string oppid, string tranId, objectWrapper data,string payType){  
        list<Product_Refunds__c> prList = new list<Product_Refunds__c>();
        data.oppLine =[select id, opportunityid, Product2Id,quantity,ProductCode,opportunity.stagename,Product2.GL_Code__c     from OpportunityLineItem where Opportunityid=:oppid];
        //oldoppid = oppid;
        m.oldoppid=oppid;
        for(OpportunityLineItem ol: data.oppLine){
           m.setProdCodes.add(ol.ProductCode);
          m.setGlCodes.add(ol.Product2.GL_Code__c);
            if(ol.ProductCode =='ENC1L' ||ol.ProductCode =='ENC1S'||ol.ProductCode =='ENC1E'){
                m.examPartOne = 'FRM Exam Part I';
                if(payType =='Early'){
                    m.setProdCodes.add('FRM1E');
                     m.setProdCodes.add('FRM1X');
                     m.setGlCodes.add('4030');
                    m.setProdCodes.remove('ENC1E');}
                if(payType =='Standard'){
                    m.setProdCodes.add('FRM1S');
                     m.setProdCodes.add('FRM1X');
                      m.setGlCodes.add('4030');
                    m.setProdCodes.remove('ENC1S');}
                if(payType =='Late'){
                    m.setProdCodes.add('FRM1L');
                    m.setProdCodes.add('FRM1X');
                     m.setGlCodes.add('4030');
                    m.setProdCodes.remove('ENC1L');}
                
            }
            
            if(ol.ProductCode =='ENC2L' ||ol.ProductCode =='ENC2S'||ol.ProductCode =='ENC2E'){
                m.examPartTwo = 'FRM Exam Part II';
                if(payType =='Early'){
                    m.setProdCodes.add('FRM2E');
                    m.setProdCodes.remove('ENC2E');}
                if(payType =='Standard'){
                    m.setProdCodes.add('FRM2S');
                    m.setProdCodes.remove('ENC2S');}
                if(payType =='Late'){
                    m.setProdCodes.add('FRM2L');
                    m.setProdCodes.remove('ENC2L');}
                
            }
            
            if(ol.ProductCode =='ENC'){
                m.enrollment = true;
                m.setProdCodes.add('FRM1');
                m.setProdCodes.remove('ENC');
                m.setGlCodes.add('4010');
                
            }
           
            Product_Refunds__c pr = new Product_Refunds__c();
            
            
            pr.Product__c = ol.Product2Id;
            Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Product_Refunds__c', 'Product Refunds');
            pr.recordTypeID = recordTypeID;
            pr.Payment_Transaction__c = tranId;
            pr.Reason__c = 'Switch';
            pr.Opportunity__c =oppid;
            pr.Status__c ='Completed';
            pr.Unique_Id__c = string.valueOf(oppid)+string.valueOf(ol.Product2Id); 
            decimal dQuantity = ol.quantity; 
            prList.add(pr);
            
        }
        system.debug('m.setGlCodes:'+m.setGlCodes);
        system.debug(' m.setProdCodes:'+ m.setProdCodes);
         system.debug(' prList:'+ prList);
        if(prList.size()>0)
           
          insert prList;
       
        createFrmOrder(m);    
        
        
    }
    // Process start for creating Frm program starting with opportunity.
    
    @auraEnabled
    public static void createFrmOrder(dataWrapper m){
        objectWrapper data = new objectWrapper ();
        opportunity opp = new opportunity ();
        system.debug('^^^^^:'+m.accid);
        system.debug('m:'+m);
        
        // create new opportunity
        opp.Accountid = m.accid;
        opp.Name = 'Exam Registration';
        opp.StageName = 'New Lead';
        opp.CloseDate = system.today();
        opp.Program__c = 'FRM';
        opp.Eligible_for_Membership_Extension__c = m.Membership; 
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated');
        opp.RecordTypeId = recordTypeID;
        
        opp.ChargentSFA__Billing_First__c =  m.fname ; 
        opp.ChargentSFA__Billing_Last__c = m.lname ;
        opp.ChargentSFA__Billing_Email__c  =m.email  ;
        opp.ChargentSFA__Billing_Phone__c = m.phone ;
        opp.ChargentSFA__Billing_Company__c = m.company ; 
        opp.ChargentSFA__Billing_Address__c =  m.addr1; 
        opp.ChargentSFA__Billing_Address_Line_2__c= m.addr2 ;
        opp.ChargentSFA__Billing_City__c   = m.city;
        opp.ChargentSFA__Billing_State__c = m.state;   
        opp.ChargentSFA__Billing_Country__c = m.country ;
        opp.ChargentSFA__Billing_Zip__c = m.zip ;
        opp.Shipping_Street__c  =  m.saddr ;
        opp.Shipping_City__c  = m.scity ;
        opp.Shipping_State__c = m.sstate ;
        opp.Shipping_Postal_Code__c = m.szip;
        opp.Auto_Renew__c = m.recurring ;
        opp.Shipping_Country__c  = m.scountry;
        if(m.recurring)
        opp.ChargentSFA__Tokenization__c  = m.AUTHCODE ;
        opp.Shipping_First_Name__c =m.fname ;
        opp.Shipping_Last_Name__c =m.lname ;
        opp.Shipping_E_mail__c    =m.email  ;
        opp.Shipping_Phone_No__c  =m.phone ;
        opp.Switch_to_frm__c = true;
        opp.Cloned_From__c  = m.oldoppid;
        insert opp;
        system.debug('insertopp:'+opp);
        // calling next method to create Line items.
        createOpportunityLineItems( m,opp.id);
        
    }
    // create Opportunity Line Items.
    @auraEnabled
    public static void createOpportunityLineItems(dataWrapper m, string oppid){ 
        system.debug('m.setProdCodes:'+m.setProdCodes);
        system.debug('m.setGlCodes:'+m.setGlCodes);
        list<OpportunityLineItem> oppls = new list<OpportunityLineItem> ();
        for (PriceBookEntry PricebookEntryId: [select unitprice, productcode, product2.Gl_Code__c from PriceBookEntry where Pricebook2.IsActive = true and productcode in :m.setProdCodes and product2.Gl_Code__c in :m.setGlCodes and isActive = true]) {
             system.debug('PricebookEntryId:'+PricebookEntryId);
            OpportunityLineItem oppLineItem = new OpportunityLineItem();
            oppLineItem.OpportunityId = oppid;
            if(PricebookEntryId.ProductCode  =='FRM1X')
            oppLineItem.UnitPrice  = 0.00;
            else{
            oppLineItem.UnitPrice  = PricebookEntryId.UnitPrice;}
            oppLineItem.PricebookEntryId = PricebookEntryId.Id;
            oppLineItem.Quantity = 1;
            oppls.add(oppLineItem);
             system.debug('oppls:'+oppls);
        }
        
        insert oppls;
        system.debug('oppls:'+oppls);
        // calling next method to create programs.
        createProgram( m,oppid);
    }
    
    // create Programs.
    @auraEnabled
    public static void createProgram(dataWrapper m, string oppid){         
        
        contract cr = new contract();
        contract cr1 = new contract();
        List < Contract > lstContract = new List < Contract > ();
        
        
        cr.accountId =m.accid;
        cr.Opportunity__c = oppid;
        cr.StartDate = system.today();
        cr.ContractTerm = 48;
        cr.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'FRM Program');
        lstContract.add(cr);
        
        if(m.enrollment){
            cr1.accountId =m.accid;
            cr1.Opportunity__c = oppid;
            cr1.StartDate = system.today();
            cr1.ContractTerm = 12;
            cr1.Membership_Type__c = 'Individual';
            cr1.recordTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
            lstContract.add(cr1);
            
        }
        if (lstContract.size() > 0) {
            insert lstContract;
        } 
        // calling next method to create program Requirements.
        
        createProgramRequirement( m,oppid,cr);
    }
    
    // create Program requirements.
    @auraEnabled
    public static void createProgramRequirement(dataWrapper m, string oppid,contract cr){  
        
        Candidate_Requirement__c Cre = new Candidate_Requirement__c ();
        
        List < Candidate_Requirement__c > lstCandReq = new List < Candidate_Requirement__c > ();
        Candidate_Requirement__c objCandReq;
        Integer iCount = 3;
        
        
        Id examRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Exam');
        Id jobExpRecType = RecordTypeHelper.GetRecordTypeId('Candidate_Requirement__c', 'Job Experience');
        
        Candidate_Requirement__c crJob=null;
        Candidate_Requirement__c crE1=null;
        Candidate_Requirement__c crE2=null;
        
        for (Integer i = 0; i < iCount; i++) {
            objCandReq = new Candidate_Requirement__c();
            objCandReq.Candidate_Commitment__c = cr.id;
            objCandReq.Candidate_Email__c = m.email;
            if (i == 0) {
                
                objCandReq.Name = 'Job Requirement';
                objCandReq.Status__c = 'Initial';
                objCandReq.recordTypeID = jobExpRecType;
                objCandReq.Email_GARP_Member__c = m.Email;
                crJob = objCandReq;
                
            } else if (i == 1) {
                
                objCandReq.Name = 'Pass FRM1';
                objCandReq.Exam__c = 'FRM Part I';
                objCandReq.Status__c = 'Initial';
                objCandReq.recordTypeID = examRecType;
                crE1 = objCandReq;
                
            } else {
                
                objCandReq.Name = 'Pass FRM2';
                objCandReq.Exam__c = 'FRM Part II';
                objCandReq.Status__c = 'Initial';
                objCandReq.recordTypeID = examRecType;                    
                crE2 = objCandReq;
            }
            
            lstCandReq.add(objCandReq);
        }
        if (lstCandReq.size() > 0) {
            if(crE2!=null && crE1!=null) 
                crE2.Prerequisite__c = crE1.Id;
            if(crE2!=null && crJob!=null)
                crJob.Prerequisite__c = crE2.Id;
            
        }
        insert lstCandReq;
        // calling next method to create Exam Attempts.
        
        createExamAttempts(m,oppid,lstCandReq,cr);
    }
    
    // create Exam Attempts.
    @auraEnabled
    public static void createExamAttempts(dataWrapper m, string oppid, List < Candidate_Requirement__c > lstCandReq,contract cr){
        Exam_Attempt__c ea = new Exam_Attempt__c ();
        ID examGroup;
        list < Exam_Sites__c > lstExamSites = new List < Exam_Sites__c > ();
        Set < String > setExamNames = new Set < String > ();
        
        system.debug('m.examPartOne=== ' + m.examPartOne);
        system.debug('m.examPartTwo=== ' + m.examPartTwo);
        if (m.examPartOne == 'FRM Exam Part I' )
            setExamNames.add('FRM Part 1');
        if (m.examPartTwo == 'FRM Exam Part II')
            setExamNames.add('FRM Part 2');
        
        system.debug('setExamNames=== ' + setExamNames);
        lstExamSites = [Select id, Name, Exam__r.Exam__c, Exam__r.Exam_Group__c from Exam_Sites__c where Site__c= : m.examsite and Exam__r.Exam__c in : setExamNames and Exam__r.Exam_Group__r.Active__c = true];
        
        Map < String, Id > mapCandIds = new Map < String, Id > ();
        Map <string, Id > mapExamIds = new Map <string, Id > ();
        
        for (Candidate_Requirement__c obj: lstCandReq) {
            string strName = '';
            if (obj.Exam__c == 'FRM Part I')
                strName = 'FRM Part 1';
            else if (obj.Exam__c == 'FRM Part II')
                strName = 'FRM Part 2';
            
            mapCandIds.put(strName, obj.Id);
           
        }
        
        system.debug('lstExamSites=== ' + lstExamSites);
        
        List < Exam_Attempt__c > lstExamApptempts = new List < Exam_Attempt__c > ();
        Exam_Attempt__c objSwapEAFRM1=null;
        Exam_Attempt__c objSwapEAFRM2=null;
        
        for (Exam_Sites__c objExamSite: lstExamSites) {
          //  mapExamIds.put(objExamSite.Exam__r.exam__C,objExamSite.Exam__r.id);
            Exam_Attempt__c   objAttempt = new Exam_Attempt__c();
            objAttempt.Exam_Site__c = objExamSite.Id;
            objAttempt.Member__c = m.conid;
            String strExamName = '';
            objAttempt.Candidate_Commitment__c = cr.id;
            objAttempt.Opportunity__c = oppid;
            objAttempt.Opportunity__c = oppid;
            objAttempt.Candidate_Requirement__c = mapCandIds.get(objExamSite.Exam__r.Exam__c);
           // objAttempt.Exam__c  = mapExamIds.get(objExamSite.Exam__r.Exam__c);
            lstExamApptempts.add(objAttempt);
            if(objExamSite.Exam__r.Exam_Group__c != null)
                examGroup = objExamSite.Exam__r.Exam_Group__c;
        }
        if (lstExamApptempts.size() > 0) {
            insert lstExamApptempts;
        }
        lstExamApptempts = [select Id, Name, Exam_Site__r.Exam__r.Exam__c from Exam_Attempt__c where Member__c = :m.conid and Candidate_Commitment__c = :cr.id and Exam_Site__r.Exam__r.Exam_Group__c = :examGroup];
        
        system.debug('* * * lstExamApptempts ...'+ lstExamApptempts);
        
        for (Exam_Attempt__c ea1: lstExamApptempts) {
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 1') {
                objSwapEAFRM1 = ea1;
            }
            if(ea.Exam_Site__r.Exam__r.Exam__c == 'FRM Part 2') {
                objSwapEAFRM2 = ea1;
            }            
            
        }
        
        system.debug('* * * objSwapEAFRM1 ...'+ objSwapEAFRM1 + ':' + objSwapEAFRM2 );
        
        if(objSwapEAFRM1!=null && objSwapEAFRM2!=null) {
            objSwapEAFRM1.Other_Exam_Registrations__c = objSwapEAFRM2.Id;
            objSwapEAFRM2.Other_Exam_Registrations__c = objSwapEAFRM1.Id;
            update lstExamApptempts;
        }
        // calling next method to create Transction.
        createTransaction(m,oppid,lstExamApptempts);
    }
    
    // create Transaction.
    @auraEnabled
    public static void createTransaction(dataWrapper m, string oppid,List <Exam_Attempt__c> lstExamApptempts){
        
        ChargentSFA__Transaction__c newTranFrm = new ChargentSFA__Transaction__c ();
        
        newTranFrm.ChargentSFA__Opportunity__c =oppid;
        newTranFrm.ChargentSFA__Type__c ='Credit';
        newTranFrm.ChargentSFA__Response__c ='0';
        newTranFrm.ChargentSFA__Response_Status__c ='Approved';
        newTranFrm.ChargentSFA__Response_Message__c ='Approved';
        newTranFrm.ChargentSFA__Gateway_Date__c  = system.now();
        newTranFrm.ChargentSFA__Amount__c = m.paymentAmt;
        
        insert newTranFrm;
        
       // closeOpportunity(oppid,lstExamApptempts);
        
    }
    
    @auraEnabled
    public static void closeOpportunity( string oppid,List <Exam_Attempt__c> lstExamApptempts){
        
        opportunity opportunity2 = [select id,stagename, Display_Invoice_Number__c from opportunity where id=:oppid];
        
        system.debug('opportunity2:'+opportunity2);
        
        opportunity2.stagename='Closed';
        if(lstExamApptempts.size()>0){
            opportunity2.Deferred_Exam_Registration__c =lstExamApptempts[0].id;}
        update opportunity2;
        
        
    }
    
}