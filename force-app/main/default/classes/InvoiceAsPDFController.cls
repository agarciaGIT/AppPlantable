/*  Apex Controller for Opportunity "Download Invoce" button
 *  02/15/2019 Xiang - [US-17765] Added redirect logic for handling Institutional Sale master Invoice
 *  05/14/2019 Xiang - [US-21939] Replaced Invoice number field for master order
 */
global without sharing class InvoiceAsPDFController{
    
    private static final String LONG_TIME_FORMAT = 'EEEE, MMMM d, yyyy h:mm a';
    private static final String SHORT_TIME_FORMAT = 'EEEE, MMMM d yyyy';
    private static final String SYS_DATE_FORMAT = 'MM/dd/yyyy h:mm a';
    
    @TestVisible private static final String IND_GL = '4040';
    @TestVisible private static final String NOV_EXAM_REG_GL = '4002';
    @TestVisible private static final String MAY_EXAM_REG_GL = '4001';
    @TestVisible private static final String JUL_EXAM_REG_GL = '4007';
    @TestVisible private static final String DEC_EXAM_REG_GL = '4012';
    @TestVisible private static final String APR_EXAM_REG_GL = '4004';
    @TestVisible private static final String AUG_EXAM_REG_GL = '4008';
        
    @TestVisible private static final String FBR_GL = '4000';
    @TestVisible private static final String PAY_DEFERRED_GL = '6110';
    @TestVisible private static final String FRM_PARCTICE_1_PROD_CODE = 'FRMC1';
    @TestVisible private static final String FRM_PARCTICE_2_PROD_CODE = 'FRMC2';
    @TestVisible private static final String ERP_PARCTICE_1_PROD_CODE = 'ENCC1';
    @TestVisible private static final String ERP_PARCTICE_2_PROD_CODE = 'ENCC2';
    
    global Id oppId {get;set;} 
    global String status {get;set;}
    global string type {get;set;}
    global string msg {get;set;}
    global Boolean isPaid {get;set;}

    global Boolean hasNoWeightProducts {get;set;}
    global Boolean hasElectronicDelivery {get;set;}
    
    global OpportunityWrapper oppty {get;set;}
    global ExamAttemptWrapper exam {get; set;}
    global ExamAttemptWrapper Otherexam {get; set;}
    global List<LineItemWrapper> lineItems {get; set;}
    global List<PaymentWrapper> payments {get; set;}
    global List<String> specialNotes {get; set;}
    
    global EventRegWrapper eventcancel {get; set;}
    global List<EventRegWrapper> eventLstWrapper {get; set;}
        
    global ChaptMeetingRegWrapper chaptMeetReg {get; set;}
    
    global Boolean Practice {get;set;}

    global Boolean FRM1 {get;set;}
    global Boolean FRM2 {get;set;}


    global Boolean FRM {get;set;}
    global Boolean ERP {get;set;}
    global Boolean SCR {get;set;}
    global Boolean ICBRR {get;set;}
    global Boolean FBR {get;set;}
    global Boolean ChaptMeeting {get;set;}
    global Boolean Membership {get; set;}    
    global Boolean Wire  {get;set;}
    global Boolean Check {get;set;}
    global Boolean CreditByFax {get;set;}
    global Boolean CC {get;set;}
    global Decimal OrderNet {get;set;}
   
    global Boolean FBRA {get;set;}
    
    global Boolean Event {get;set;}
   
    global String examRegistrationType{get;set;}
    global String examAdminType {get;set;}
    global Boolean showSpecialNotes {get;set;}
 
   global InvoiceAsPDFController() {
     status = 'Unpaid';
     isPaid = false;
     type = ''; 
     
     msg='hi';
       
     FRM = false;
     FRM1 = false;
     FRM2 = false;
     ERP= false;
     ICBRR = false;
     FBR = false;
     SCR = false;
     Membership = false;
     Wire = false;
     Check = false;
     CreditByFax = false;
     CC = true;  
     OrderNet = 0;
     FBRA = false;
     Event = false;
     ChaptMeeting = false;
     showSpecialNotes = false;
       
     eventLstWrapper = new List<EventRegWrapper>();
     specialNotes = new List<String>();
   }
   
   global String getNow() {
       return System.now().format(SYS_DATE_FORMAT);
   }
 
   global PageReference fetchData() {
   
       //Get opportunity data
       oppId = ApexPages.currentPage().getParameters().get('id');
       Opportunity rawOpp = [Select id, Company__c, StageName, CloseDate, Additional_Invoice_Information__c, EA_Id__c, Undefred_EA_Id__c, Alternate_Method_of_Payment__c, ChargentSFA__Payment_Method__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c, ChargentSFA__Billing_Company__c, 
                ChargentSFA__Billing_Address__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Zip__c, ChargentSFA__Billing_Country__c,
                ChargentSFA__Billing_Phone__c, ChargentSFA__Billing_Email__c, Shipping_First_Name__c, Shipping_State__c, Shipping_Postal_Code__c,Shipping_Last_Name__c, 
                Shipping_Phone_No__c, Shipping_Company_Name__c, Shipping_Country__c, Display_Invoice_Number__c,Product_Name__c, Shipping_City__c,
                Institutional_Sale__c, Inst_Sale_Opp__c, Inst_Sale_Opp__r.StageName, Inst_Sale_Opp__r.ChargentSFA__Billing_Company__c, Inst_Sale_Opp__r.CloseDate, Inst_Sale_Opp__r.Display_Invoice_Number__c, Inst_Sale_Opp__r.Inst_Sale_Display_Invoice_Number__c, 
                Shipping_Street__c, Shipping_E_mail__c, ChargentSFA__Charge_Amount__c, Amount, GARP_Member_ID__c, CreatedDate, LEGACY_Purchase_Date__c, Program_Name__c, Program_Abbrev__c,
                Team_Registration__c, Team_Registration__r.Manual_Invoice_Number__c, Team_Registration__r.Manual_Invoice_Payment_Date__c, Team_Registration__r.Account__r.Name
				FROM Opportunity
                WHERE id= :oppId and StageName != 'Recurring Intent'];
       
       // [US-17765] Handle Master Invoice in a seperate visualforce page
       if(rawOpp.Institutional_Sale__c == true && rawOpp.Inst_Sale_Opp__c == null) {
            PageReference pageRef = new PageReference('/apex/InstitutionalSalesInvoice?id=' + rawOpp.Id);
            pageRef.setRedirect(true);
            
            return pageRef;
       }
                
       oppty = new OpportunityWrapper(rawOpp);
       //system.debug('Exam?:' + oppty.examAttemptId);
       
       system.debug('Event Oppty:' + oppty);
       
       //Get exam data 
       list<Exam_Attempt__c> ea = [Select id, Section__c, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Name, Exam_Site__r.Site__r.Name, Original_Exam_Site__c, Exam_Date__c, Opportunity__r.Id, RPT_Administration_Year__c, RPT_Administration_Month__c, Original_Exam_Administration__r.Month__c, Original_Exam_Administration__r.Year__c, RPT_Exam_Program__c, RPT_Exam_Part__c from  Exam_Attempt__c where (Opportunity__r.Id = :oppID OR Id = :oppty.deferExamAttemptId OR Id = :oppty.undeferExamAttemptId) and Exam_Site__r.Exam__r.Exam__c <> 'ICBRR' Order By Exam_Date__c ASC];
       list<Exam_Attempt__c> eaCloned = [Select id, Section__c, Exam_Site__r.Exam__r.Exam__c, Exam_Site__r.Name, Exam_Site__r.Site__r.Name, Original_Exam_Site__c, Exam_Date__c, Opportunity__r.Id, RPT_Administration_Year__c, RPT_Administration_Month__c, Original_Exam_Administration__r.Month__c, Original_Exam_Administration__r.Year__c, RPT_Exam_Program__c, RPT_Exam_Part__c from  Exam_Attempt__c where Cloned_From__c in :ea Order By Exam_Date__c ASC];
       list<Exam_Attempt__c> eaAll = new list<Exam_Attempt__c>();
       
       eaAll.addAll(ea);
       eaAll.addAll(eaCloned);
       
       Exam_Attempt__c lastEA = null;
       Exam_Attempt__c otherEA = null;       
       if (!eaAll.isEmpty() && eaAll.size() > 0) {
       
           for(Exam_Attempt__c e :eaAll ) {
               if(lastEA == null) {
                   lastEA = e;
               } else if(otherEA == null) {
                   otherEA = e;
               }
           }
           exam = new ExamAttemptWrapper(lastEA);
           if(otherEA != NULL) {
               otherExam = new ExamAttemptWrapper(otherEA );
           }
       }

        system.debug('lastEA:' + lastEA );
        system.debug('otherEA:' + otherEA );

        system.debug('Exam?:' + exam);
        
        
       //Get event data
       Map<Id,Id> mapEventtoReg = new Map<Id,Id>();
       
       list<Event_Registration__c> eventreg = [
           SELECT Id, Name, CreatedDate, Contact__c, Event__c, Event__r.Online_Meeting_URL__c, Event__r.Online_Meeting_Notes__c, Event__r.ON24_Event_Id__c, Event__r.Name, Event__r.Event_Date__c, Event__r.Cancellation_Policy__c, Event__r.Payment_Policy__c, Event__r.Event_Location__c, Event__r.Event_Cancellation_Days__c, Event__r.Event_Cancellation_Date__c, Last_Date_For_Rate_Effectiveness__c, Event__r.Start_Date__c, Event__r.Grace_Period__c, Status__c, Opportunity__r.Id, Member_Email__c, Substitute_Attendant__c, Event_Paid_Date__c, RPT_Event_Date__c 
           FROM Event_Registration__c 
           WHERE Opportunity__r.Id = :oppID
       ];
       
       system.debug('Event:' + eventreg);
       
       if (!eventreg.isEmpty() && eventreg.size() > 0) {
           
           for(Event_Registration__c ev :eventreg ) {
               EventRegWrapper eventcancel = new EventRegWrapper(ev);  
               
               eventLstWrapper.add(eventcancel);
               mapEventtoReg.put(ev.Event__c, ev.Id);
           } 
           
       }
       
       list<Chapter_Meeting_Registration__c> lstCMR = [select id, name, Chapter_Meeting__r.ON24_Event_Id__c, Chapter_Meeting__r.Payment_Policy__c, Chapter_Meeting__r.Cancellation_Policy__c from Chapter_Meeting_Registration__c where Opportunity__c = :oppId];
       system.debug('lstCMR:'+ lstCMR);
       if(lstCMR != null && lstCMR.size() > 0) {
           chaptMeetReg = new ChaptMeetingRegWrapper(lstCMR[0]);
           ChaptMeeting = true;
           system.debug('chaptMeetReg:' +chaptMeetReg);
       }

              
       Decimal total = oppty.Amount;
       String payType = '';
       
       if(oppty.ampMethod != null)
        type = oppty.ampMethod;
       
      
       //Get payment data
       payments = new List<PaymentWrapper>();
       List<ChargentSFA__Transaction__c> transactions =  [Select id ,Name, ChargentSFA__Amount__c, ChargentSFA__Opportunity__r.CloseDate , ChargentSFA__Opportunity__c,ChargentSFA__Opportunity__r.GARP_Member_ID__c,
              ChargentSFA__Opportunity__r.StageName , ChargentSFA__Type__c, ChargentSFA__Payment_Method__c, ChargentSFA__Response_Status__c, ChargentSFA__Gateway_Date__c, ChargentSFA__Reason_Text__c, Fee__c,Accounting_Notes__c,CreatedDate
              FROM ChargentSFA__Transaction__c  where ChargentSFA__Amount__c!= NULL and ChargentSFA__Opportunity__c = :oppId and ChargentSFA__Opportunity__r.StageName != 'Recurring Intent' AND ((ChargentSFA__Type__c = 'Void' OR ChargentSFA__Type__c = 'Debit' OR ChargentSFA__Type__c = 'Charge' OR ChargentSFA__Type__c = 'Credit' or ChargentSFA__Type__c = 'Refund' or ChargentSFA__Type__c = 'Charge Back Accepted' or ChargentSFA__Type__c = 'Charge Back Loss') AND (ChargentSFA__Response_Status__c = 'Approved' OR ChargentSFA__Response_Status__c = '' OR ChargentSFA__Response_Status__c = NULL)) ORDER BY ChargentSFA__Gateway_Date__c ASC];
       
       List<ID> ids = new List<ID>();
       for (ChargentSFA__Transaction__c payment :transactions){
           ids.add(payment.Id);
       }
       List<Product_Refunds__c> prf = [select Id, Name, Payment_Transaction__c, Reason__c, Show_Reason__c from Product_Refunds__c where Payment_Transaction__c in :ids];
       
       Map<ID,Product_Refunds__c> mapReason = new Map<ID,Product_Refunds__c>();
       for (Product_Refunds__c pr :prf){
           mapReason.put(pr.Payment_Transaction__c, pr);
       }
       
       date tempDate = date.newInstance(2022, 1, 1);
       for (ChargentSFA__Transaction__c payment :transactions){
           
           Product_Refunds__c fndPR = mapReason.get(payment.Id);
           String reason = '';
           Boolean show = false;
           //if(fndPR != null) {
           //    if(fndPR.Reason__c != null)
           //        reason = fndPR.Reason__c;
           //    if(fndPR.Show_Reason__c != null)
           //        show = fndPR.Show_Reason__c;               
           //}
           payments.add(new PaymentWrapper(payment, reason, show));

           system.debug('pay?:' + payment);
           
           
           if (payment.ChargentSFA__Type__c!=null && payment.ChargentSFA__Amount__c!=null) {
               if(payment.ChargentSFA__Type__c == 'Charge' || payment.ChargentSFA__Type__c == 'Credit' || payment.ChargentSFA__Type__c == 'Debit' || payment.ChargentSFA__Type__c=='Refund' || payment.ChargentSFA__Type__c=='Charge Back Accepted' || payment.ChargentSFA__Type__c=='Charge Back Loss' || payment.ChargentSFA__Type__c=='Void') {
                   
                   system.debug('pay:' + payment.ChargentSFA__Amount__c);
                   
                   OrderNet+=payment.ChargentSFA__Amount__c;
                   if(payment.Fee__c != null) {
                       OrderNet+=(payment.Fee__c * -1);
                   }
                   
                   if(payment.ChargentSFA__Payment_Method__c!=null) {
                       if(payment.ChargentSFA__Payment_Method__c == 'Credit Card') {
                           CC=true;
                           Wire=false;
                           Check=false;
                           CreditByFax=false;                    
                       }
                   }
                   if(payment.ChargentSFA__Type__c == 'Charge' ) {
                       
                       system.debug('Charge:' + payment.ChargentSFA__Type__c);
                       
                       if (payType == null || payType == '') {
                           payType = payment.ChargentSFA__Payment_Method__c;
                       } else if (payment.ChargentSFA__Payment_Method__c != null && payment.ChargentSFA__Payment_Method__c != '') {
                           if (!payType.containsIgnoreCase(payment.ChargentSFA__Payment_Method__c)) {
                               payType = payType + ', ' + payment.ChargentSFA__Payment_Method__c;
                           }
                       }
                   }
                   
                   if(String.isNotBlank(payment.Accounting_Notes__c) && payment.CreatedDate >= tempDate &&
                      (payment.ChargentSFA__Type__c == 'Charge Back Loss' || payment.ChargentSFA__Type__c == 'Charge Back Accepted'
                       || payment.ChargentSFA__Payment_Method__c == 'Wire Transfer' || payment.ChargentSFA__Payment_Method__c == 'Check' 
                       || payment.ChargentSFA__Payment_Method__c == 'Credit Card by Fax' || payment.ChargentSFA__Payment_Method__c == 'ACH')){
                       specialNotes.add(payment.Accounting_Notes__c);
                       showSpecialNotes = true;
                   }
               }          
           }   
       }
       
       system.debug('payments:' + payments);
       
       if(payType != NULL && payType != '')
           type = payType;
       
       if(type.containsIgnoreCase('wire')) {
           CC=false;
           Wire=true;
       } else if(type.containsIgnoreCase('check')) {
           CC=false;
           Check=true;
       } else if(type.containsIgnoreCase('fax')) {
           CC=false;
           CreditByFax=true;
       } else if(oppty != null && oppty.chrgAmpMethod != null && oppty.chrgAmpMethod.containsIgnoreCase('wire')) {              
           CC=false;
           Wire=true;
       }
       
       if(oppty.instSale && oppty.instStageName == 'Closed') {
           status = 'Paid'; 
           isPaid = true;                      
       } else if(!oppty.instSale && oppty.stage == 'Closed') {
           status = 'Paid'; 
           isPaid = true;           
       }
       
       //if (total != null && countTotal > 0 && countTotal >= total) {
       //    status = 'Paid'; 
       //    isPaid = true;
       //}  else if(total != null && countTotal > 0 && countTotal < total) {
       //    status = 'Partially Paid'; 
       //    isPaid = true;
       //}
                      
       //Get line item data                 
       lineItems = new List<LineItemWrapper>();
       for(OpportunityLineItem oProd : [Select Product2.Name, Exam_Date__c, Product2.ProductCode, Product2.GL_Code__c, Product2.Weight__c, Product2.Electronic_Delivery__c, UnitPrice, OpportunityId, Description, TotalPrice, Quantity from OpportunityLineItem where OpportunityId=:oppID order by TotalPrice DESC ,Product2.Display_Sort_Order__c DESC] ) {
           lineItems.add(new LineItemWrapper(oProd, oppty));

             if(oProd.Product2.Electronic_Delivery__c)
                 hasElectronicDelivery = true;

           String prodName = oProd.Product2.Name; 
           String description = oProd.Description;
           Decimal totAmt = oProd.UnitPrice;
           String prodCode = oProd.Product2.ProductCode;
           String GLCode = oProd.Product2.GL_Code__c; 
           Decimal weight = oProd.Product2.Weight__c;
           
           Date examDate = oProd.Exam_Date__c;
           
           system.debug('GLCode:' + GLCode);
           
           if(weight == 0)
               hasNoWeightProducts=true;

           
           if (GLCode !=null && prodCode != null) {
                   if (GLCode == IND_GL) {
                   Membership = true;
               } 
               if (GLCODE == AUG_EXAM_REG_GL || GLCode == NOV_EXAM_REG_GL || GLCode == MAY_EXAM_REG_GL || GLCode == JUL_EXAM_REG_GL || GLCode == DEC_EXAM_REG_GL || GLCode == APR_EXAM_REG_GL) {
                   if (prodCode.containsIgnoreCase('frm')) {
                       FRM=true; 
                   }
                   if (prodCode.containsIgnoreCase('frm1')) {
                       FRM1=true; 
                   }
                   if (prodCode.containsIgnoreCase('frm2')) {
                       FRM2=true; 
                   }
                   
                   if (prodCode.containsIgnoreCase('enc')) {
                       ERP=true; 
                   }
                   if (prodCode.containsIgnoreCase('scr')) {
                       SCR=true; 
                   }
                   examRegistrationType = getExamType(prodCode);
                   if(GLCode == MAY_EXAM_REG_GL) {
                       examAdminType = 'MAY';
                   } else if(GLCode == JUL_EXAM_REG_GL) {
                       examAdminType = 'JUL';
                   } else if(GLCode == NOV_EXAM_REG_GL) {
                       examAdminType = 'NOV';
                   } else if(GLCode == DEC_EXAM_REG_GL) {
                       examAdminType = 'DEC';
                   } else if(GLCode == APR_EXAM_REG_GL) {
                       examAdminType = 'APR';
                   } else if(GLCode == AUG_EXAM_REG_GL) {
                       examAdminType = 'AUG';
                   }
               }
               
               else if (GLCode == FBR_GL) {
                   if (prodCode.startsWithIgnoreCase('cbr')) {
                       ICBRR=true; 
                   }
                   if (prodCode =='FBRA') {
                       FBRA=true; 
                   }
                   else if (prodCode.containsIgnoreCase('fcbr') || prodCode.containsIgnoreCase('fbr')) {
                       FBR=true; 
                   }
               }
               else if(prodCode == FRM_PARCTICE_1_PROD_CODE || prodCode == FRM_PARCTICE_2_PROD_CODE || prodCode == ERP_PARCTICE_1_PROD_CODE || prodCode == ERP_PARCTICE_2_PROD_CODE) {
                   Practice = True;
               }
               
               else if (!eventreg.isEmpty() && eventreg.size() > 0) {
                   Event = true;
           
           }
           } else {
               if (prodName != null) {
                   if (prodName.containsIgnoreCase('exam') && prodName.containsIgnoreCase('erp'))
                       ERP=true; 
                   if (prodName.containsIgnoreCase('exam') && prodName.containsIgnoreCase('frm'))
                       FRM=true;
                   if (prodName.containsIgnoreCase('exam') && prodName.containsIgnoreCase('scr'))
                       SCR=true; 
                   if (prodName.containsIgnoreCase('icbrr'))
                       ICBRR=true; 
                     if (prodName.containsIgnoreCase('wire'))
                       Wire=true; 
                   if (prodName.containsIgnoreCase('check') || prodName.containsIgnoreCase('fax'))
                       CreditByFax=true; 
                   If(prodName.containsIgnoreCase('practice'))
                       Practice = True;
               }          
           }         
       }
       //lineItems.sort();
       
        if(otherEA != NULL && (FRM1==False || FRM2==False)) {
            otherExam = NULL;
        }
        
       
       return null;
     }
     
     global class OpportunityWrapper {
         global String id {get; set;}
         global String company {get; set;}
         global String stage {get; set;}
         global String ampMethod {get;set;}
         global String deferExamAttemptId {get;set;}    
         global String undeferExamAttemptId {get;set;}             
         global String chrgAmpMethod {get;set;}
         global String chargentSFAPaymentMethod {get;set;}
         global String chargentSFABillingFirst {get; set;}
         global String chargentSFABillingLast {get; set;}
         global String chargentSFABillingCompany {get; set;}
         global String chargentSFABillingAddress {get; set;}
         global String chargentSFABillingCity {get; set;}
         global String chargentSFABillingState {get; set;}
         global String chargentSFABillingZip {get; set;}
         global String chargentSFABillingCountry {get; set;}
         global String chargentSFABillingPhone {get; set;}
         global String chargentSFABillingEmail {get; set;}
         global String shippingFirstName {get; set;} 
         global String shippingState {get; set;}
         global String shippingPostalCode {get; set;}
         global String shippingLastName {get; set;}
         global String shippingPhoneNo {get; set;}
         global String shippingCompanyName {get; set;}
         global String shippingCountry {get; set;} 
         global String garpInvoiceNumber {get; set;}
         global String garpMemberId {get; set;}
         global String productName {get; set;}
         global String shippingCity {get; set;}
         global String shippingStreet {get; set;}
         global String shippingEmail {get; set;}
         global Decimal chargentSFAChargeAmount {get; set;}
         global Decimal amount {get; set;}
         global String createdDateFormatted {get; set;}
         global Boolean hasBillingAddress {get; set;}
         global Boolean hasShippingAddress {get; set;}
         
         global String additionalInfo {get; set;}

         global String programName {get; set;}
         global String programAbbrev {get; set;}
         global DateTime createdDate {get; set;}
         
         global Boolean instSale {get; set;}
         global String instCompany {get; set;}
         global String instStageName {get; set;}
         global String instCloseDate {get; set;}
         global String instInvoiceNumber {get; set;}
         
         global Boolean isTeamRegistration {get; set;}
         global String teamRegCompany {get; set;}
         global String teamRegInvoiceNumber {get; set;}
         global String teamRegPaidDate {get; set;}
         global String teamRegCloseDate {get; set;}
             
         global OpportunityWrapper(Opportunity opp) {
             id = opp.id;
             company = opp.Company__c;  
             stage = opp.StageName;
             ampMethod = opp.Alternate_Method_of_Payment__c; 
             deferExamAttemptId = opp.EA_Id__c;
             undeferExamAttemptId = opp.Undefred_EA_Id__c;             
             chrgAmpMethod = opp.ChargentSFA__Payment_Method__c;
             chargentSFABillingFirst = opp.ChargentSFA__Billing_First__c;
             chargentSFABillingLast = opp.ChargentSFA__Billing_Last__c;
             chargentSFABillingCompany = opp.ChargentSFA__Billing_Company__c;
             chargentSFABillingAddress = opp.ChargentSFA__Billing_Address__c;
             chargentSFABillingCity = opp.ChargentSFA__Billing_City__c;
             chargentSFABillingState = opp.ChargentSFA__Billing_State__c;
             chargentSFABillingZip = opp.ChargentSFA__Billing_Zip__c;
             chargentSFABillingCountry = opp.ChargentSFA__Billing_Country__c;
             chargentSFABillingPhone = opp.ChargentSFA__Billing_Phone__c;
             chargentSFABillingEmail = opp.ChargentSFA__Billing_Email__c;
             shippingFirstName = opp.Shipping_First_Name__c; 
             shippingLastName = opp.Shipping_Last_Name__c;
             shippingCompanyName = opp.Shipping_Company_Name__c;
             shippingStreet = opp.Shipping_Street__c;
             shippingCity = opp.Shipping_City__c;
             shippingState = opp.Shipping_State__c;
             shippingPostalCode = opp.Shipping_Postal_Code__c;
             shippingCountry = opp.Shipping_Country__c;
             shippingPhoneNo = opp.Shipping_Phone_No__c;
             shippingEmail = opp.Shipping_E_mail__c;             
             garpInvoiceNumber = opp.Display_Invoice_Number__c;
             garpMemberId = opp.GARP_Member_ID__c;
             productName = opp.Product_Name__c;           
             chargentSFAChargeAmount = opp.ChargentSFA__Charge_Amount__c;
             amount = opp.Amount;

             additionalInfo = opp.Additional_Invoice_Information__c;
            
             programName = opp.Program_Name__c;
             programAbbrev = opp.Program_Abbrev__c;
             
             instSale = opp.Institutional_Sale__c;             
             
             if(opp.Inst_Sale_Opp__c != null) {
                 instCompany = opp.Inst_Sale_Opp__r.ChargentSFA__Billing_Company__c;
                 instStageName = opp.Inst_Sale_Opp__r.StageName;
                 instCloseDate = datetime.newInstance(opp.Inst_Sale_Opp__r.CloseDate.year(), opp.Inst_Sale_Opp__r.CloseDate.month(),opp.Inst_Sale_Opp__r.CloseDate.day()).format('MM/dd/yyyy');
                 // Xiang: Replaced Display_Invoice_Number__c with Inst_Sale_Display_Invoice_Number__c as Invoice format is different for Master Order
                 instInvoiceNumber = opp.Inst_Sale_Opp__r.Inst_Sale_Display_Invoice_Number__c;
             }
                        
             isTeamRegistration = False;
             if(opp.Team_Registration__c != NULL) {
                 isTeamRegistration = True;
                 teamRegCompany = opp.Team_Registration__r.Account__r.Name;
                 teamRegInvoiceNumber = opp.Team_Registration__r.Manual_Invoice_Number__c;
				 teamRegPaidDate = datetime.newInstance(opp.Team_Registration__r.Manual_Invoice_Payment_Date__c.year(), opp.Team_Registration__r.Manual_Invoice_Payment_Date__c.month(), opp.Team_Registration__r.Manual_Invoice_Payment_Date__c.day()).format('MM/dd/yyyy');
                 teamRegCloseDate = datetime.newInstance(opp.CloseDate.year(), opp.CloseDate.month(), opp.CloseDate.day()).format('MM/dd/yyyy');
             }
             createdDate = opp.CreatedDate;
             
             if(opp.LEGACY_Purchase_Date__c != null)
                createdDateFormatted = opp.LEGACY_Purchase_Date__c.format(SHORT_TIME_FORMAT );
             else 
                 createdDateFormatted = opp.CreatedDate.format(SHORT_TIME_FORMAT );
   
             hasBillingAddress = opp.ChargentSFA__Billing_First__c!=null||opp.ChargentSFA__Billing_Last__c!=null||opp.ChargentSFA__Billing_Company__c!=null||
                                 opp.ChargentSFA__Billing_Address__c!=null||opp.ChargentSFA__Billing_City__c!=null||opp.ChargentSFA__Billing_Company__c!=null||
                                 opp.ChargentSFA__Billing_Zip__c!=null||opp.ChargentSFA__Billing_Country__c!=null||opp.ChargentSFA__Billing_Phone__c!=null||
                                 opp.ChargentSFA__Billing_Email__c!=null;
             hasShippingAddress = opp.Shipping_First_Name__c!=null||opp.Shipping_Last_Name__c!=null||opp.Shipping_Company_Name__c!=null||
                                 opp.Shipping_Street__c!=null||opp.Shipping_City__c!=null||opp.Shipping_State__c!=null||
                                 opp.Shipping_Postal_Code__c!=null||opp.Shipping_Country__c!=null||opp.Shipping_Phone_No__c!=null||
                                 opp.Shipping_E_mail__c!=null;
         }
     }
     
     global class ExamAttemptWrapper {
         
         global String examSiteName {get; set;}
         global String examDateFormatted {get; set;}
         global String examPart {get; set;}
         global Boolean isERP {get; set;}
         
         global ExamAttemptWrapper(Exam_Attempt__c ea) {
             if(ea.Original_Exam_Site__c != null){
                examSiteName = ea.Original_Exam_Site__c;
             }else{
                 examSiteName = ea.Exam_Site__r.Site__r.Name;
             }
             
             if(ea.Original_Exam_Administration__r != NULL) {
                 examDateFormatted = ea.Original_Exam_Administration__r.Month__c + ' ' + ea.Original_Exam_Administration__r.Year__c;
             } else {
                 examDateFormatted = ea.RPT_Administration_Month__c + ' ' + ea.RPT_Administration_Year__c;
             }
             if(ea.Section__c.indexOf('ERP Exam Part') > -1){
                isERP=true;
             }else{
                isERP=false;
             }
             
             if(ea.RPT_Exam_Program__c != NULL && ea.RPT_Exam_Part__c != NULL) {
                 examPart = ea.RPT_Exam_Program__c + ' Exam Part ' + ea.RPT_Exam_Part__c;
             }
         }
         
     }
     
     global class EventRegWrapper {
         
         global string cancellationPolicy { get; set; }
         global string cancellationDate {get; set;}
         global string paymentPolicy {get; set;}
         global string eventName {get; set;}
         global string eventId {get; set;}
         global decimal eventCancelDays {get; set;}
         global decimal rateGraceDays {get; set;}
         global string eventDate {get; set;}
         global string lastRateDate {get; set;}
         global string eventLocation {get; set;}
                  
         global EventRegWrapper(Event_Registration__c eve) {
             eventLocation = eve.Event__r.Event_Location__c;
             
             if(eve.Event__r.Online_Meeting_URL__c != NULL || eve.Event__r.Online_Meeting_Notes__c != NULL || eve.Event__r.ON24_Event_Id__c != NULL) {
                 eventLocation = 'Online';
             }
             
             cancellationPolicy = eve.Event__r.Cancellation_Policy__c;
             cancellationDate = datetime.newInstance(eve.Event__r.Event_Cancellation_Date__c.year(), eve.Event__r.Event_Cancellation_Date__c.month(), eve.Event__r.Event_Cancellation_Date__c.day()).format(SHORT_TIME_FORMAT );
             paymentPolicy = eve.Event__r.Payment_Policy__c;
             eventName = eve.Event__r.Name;
             eventId = eve.Event__c;
             eventCancelDays = eve.Event__r.Event_Cancellation_Days__c;
             rateGraceDays = eve.Event__r.Grace_Period__c;
             eventDate = datetime.newInstance(eve.Event__r.Start_Date__c.year(), eve.Event__r.Start_Date__c.month(), eve.Event__r.Start_Date__c.day()).format(SHORT_TIME_FORMAT );
             if(eve.Last_Date_For_Rate_Effectiveness__c != null) {
                 lastRateDate = datetime.newInstance(eve.Last_Date_For_Rate_Effectiveness__c.year(), eve.Last_Date_For_Rate_Effectiveness__c.month(), eve.Last_Date_For_Rate_Effectiveness__c.day()).format(SHORT_TIME_FORMAT );
             }else{ 
                 lastRateDate = date.today().format();
             }
         }
         
     }     
    
    global class ChaptMeetingRegWrapper {
        global string paymentPolicy {get; set;}
        global string cancellationPolicy {get; set;}
        
        global ChaptMeetingRegWrapper(Chapter_Meeting_Registration__c cmr) {
            paymentPolicy = cmr.Chapter_Meeting__r.Payment_Policy__c;
            cancellationPolicy = cmr.Chapter_Meeting__r.Cancellation_Policy__c;
        }
    }

         
     global class PaymentWrapper {
         global String chargentSFAType {get;set;}
         global String chargentSFAPaymentMethod {get;set;}
         global String chargentSFAResponseStatus {get;set;}
         global String chargentSFAGatewayDateFormatted {get;set;}
         global Decimal chargentSFAAmount {get; set;}
         global String refundReason {get;set;}
         global Boolean showReason {get;set;}
         global Decimal fee {get;set;}
         
         global PaymentWrapper(ChargentSFA__Transaction__c payment, String inRefundReason, Boolean inShowReason) {
             chargentSFAType = payment.ChargentSFA__Type__c;
             chargentSFAPaymentMethod = payment.ChargentSFA__Payment_Method__c;
             chargentSFAResponseStatus = payment.ChargentSFA__Response_Status__c;
             chargentSFAGatewayDateFormatted = payment.ChargentSFA__Gateway_Date__c!=null?payment.ChargentSFA__Gateway_Date__c.format(LONG_TIME_FORMAT):null;
             chargentSFAAmount = payment.ChargentSFA__Amount__c;
             refundReason = payment.ChargentSFA__Reason_Text__c;
             if(payment.Fee__c != null)
                fee = (payment.Fee__c * -1);
             else fee =null;
             showReason = inShowReason;
         }
     } 
 
     
     global class LineItemWrapper {
         global String productName {get;set;}
         global String description {get;set;}
         global Integer quantity {get;set;}
         global String productCode {get;set;}
         global Decimal totalPrice {get;set;}
         global Decimal unitPrice {get;set;}         
         global Decimal weight {get;set;}         
         global Boolean electronicDelivery {get;set;}  
         
         global string examDate {get;set;}       
         
         global LineItemWrapper(OpportunityLineItem oli, OpportunityWrapper oppty) {
             
             if(oli.Product2.Name.indexOf('Risk & Regulations')> -1 && (oppty.programAbbrev == 'FRR' || (oppty.programAbbrev == null && oppty.createdDate.year() >= 2016))){
                 productName = oli.Product2.Name;
             }else {
                 productName = oli.Product2.Name.replace('Risk & Regulations', 'ICBRR');
             }
             
             // Added (Complimentary) to the OLI name for comped eBook
             if((oli.Product2.ProductCode == 'FRM1X' || oli.Product2.ProductCode == 'SCRX' || oli.Product2.ProductCode == 'FRMC1' || oli.Product2.ProductCode == 'FRMC2' || 
                 oli.Product2.ProductCode == 'ENCC1' || oli.Product2.ProductCode == 'ENCC2' || oli.Product2.ProductCode == 'SCRCN') && oli.UnitPrice == 0){
                 productName = oli.Product2.Name + ' (Complimentary)';
             }
             
             system.debug('oppty:' + oppty);
             
             productCode = oli.Product2.ProductCode;
             
             description = oli.Description;
             quantity = Integer.ValueOf(oli.Quantity);
             totalPrice = oli.TotalPrice;
             unitPrice = oli.UnitPrice;
             weight = oli.Product2.Weight__c;        
             electronicDelivery = oli.Product2.Electronic_Delivery__c;
       
             if(oli.exam_Date__C != null) 
                 
       //      examDate = oli.exam_Date__C;
             examDate = datetime.newInstance(oli.exam_Date__C.year(), oli.exam_Date__C.month(), oli.exam_Date__C.day()).format(SHORT_TIME_FORMAT );
      
         }         
     }
     
    
    private static String getExamType(String code) {
        if(code == FRMExamPart1Early || code == FRMExamPart2Early || code == ERPExamEarly || code == ERPExamPart1Early || code == ERPExamPart2Early || code == SCRMemberEarly || code == SCRNonMemberEarly || code == SCRCertifiedEarly)
            return 'early';
        if(code == FRMExamPart1Standard || code == FRMExamPart2Standard || code == ERPExamStandard || code == ERPExamPart1Standard || code == ERPExamPart2Standard || code == SCRMemberStandard || code == SCRNonMemberStandard || code == SCRRetake || code == SCRCertifiedStandard)
            return 'standard';
        if(code == FRMExamPart1Late || code == FRMExamPart2Late || code == ERPExamLate || code == ERPExamPart1Late || code == ERPExamPart2Late)
            return 'late';
        return '';
    }

         
    @TestVisible private static final String DEFERAL_FRM_PROD_CODE = 'FRM1';
    @TestVisible private static final String ERP_PROD_KEY = 'ENC';
    @TestVisible private static final String ICBRR_NONMEM_PROD_CODE = 'CBRNM';
    @TestVisible private static final String ICBRR_MEM_PROD_CODE = 'CBR';
    @TestVisible private static final String ICBRR_RETAKE_PROD_CODE = 'CBR2A';
    @TestVisible private static final String FBR_MEM_PROD_CODE = 'FCBR';
    @TestVisible private static final String FBR_NONMEM_PROD_CODE = 'FBRNM';
    @TestVisible private static final String MEMBER_PROD_CODE = 'MEMI';
    @TestVisible private static final String MEMBER_STUDENT_PROD_CODE = 'MEMS';
    @TestVisible private static final String MEMBER_FREE_PROD_CODE = 'MEMF';
    
    @TestVisible private static final String SCRMemberEarly = 'SCRME';
    @TestVisible private static final String SCRMemberStandard = 'SCRMS';
    @TestVisible private static final String SCRNonMemberEarly = 'SCRNME';
    @TestVisible private static final String SCRNonMemberStandard = 'SCRNMS';
    @TestVisible private static final String SCRCertifiedEarly = 'SCRCME';
    @TestVisible private static final String SCRCertifiedStandard = 'SCRCMS';
    @TestVisible private static final String SCRRetake = 'SCR2A';
    
    @TestVisible private static final String FRMExamPart1Late = 'FRM1L';
    @TestVisible private static final String FRMExamPart1Standard = 'FRM1S';
    @TestVisible private static final String FRMExamPart1Early = 'FRM1E';
    @TestVisible private static final String FRMExamPart2Late = 'FRM2L';
    @TestVisible private static final String FRMExamPart2Standard = 'FRM2S';
    @TestVisible private static final String FRMExamPart2Early = 'FRM2E';

    @TestVisible private static final String ERPExamPart1Late = 'ENC1L';
    @TestVisible private static final String ERPExamPart1Standard = 'ENC1S';
    @TestVisible private static final String ERPExamPart1Early = 'ENC1E';
    @TestVisible private static final String ERPExamPart2Late = 'ENC2L';
    @TestVisible private static final String ERPExamPart2Standard = 'ENC2S';
    @TestVisible private static final String ERPExamPart2Early = 'ENC2E';
    
    @TestVisible private static final String ERPExamLate = 'ENCL';
    @TestVisible private static final String ERPExamStandard = 'ENCS';
    @TestVisible private static final String ERPExamEarly = 'ENCE';
    @TestVisible private static final String FRMPart2BooksNonCandidate = 'FRM2N';
    @TestVisible private static final String FRMPracticeExamsCandidate = 'FRMCP';
    @TestVisible private static final String EnergyCertificateCoursePackCandidate = 'ENCCP';
    @TestVisible private static final String FRMPart2BooksCandidate = 'FRM2H';
    @TestVisible private static final String FRMPart1BooksCandidate = 'FRM1H';
    @TestVisible private static final String FoundationHandbook = 'FBRHB';
    @TestVisible private static final String ICBRRHandBooks = 'CBRHB';
    @TestVisible private static final String ICBRRHandBooksIndividual = 'CBRHI';
    @TestVisible private static final String FRMPart1BooksNonCandidate = 'FRM1N';
    @TestVisible private static final String FRMPracticeExamsNonCandidate = 'FRMCN';
    @TestVisible private static final String EnergyCertificateCoursePackNonCandidate = 'ENCBN';
    @TestVisible private static final String SHIP_PROD_CODE = 'SHIP';
    @TestVisible private static final String PAY_DEFERRED_PROD_CODE = 'PRFEE';
    @TestVisible private static final String TAX_PROD_CODE = 'SLSTX';
    @TestVisible private static final String MISC_PROD_CODE = 'MISC';
    
  
}