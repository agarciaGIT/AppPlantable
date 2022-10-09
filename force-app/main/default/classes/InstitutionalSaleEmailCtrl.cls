/* For sending out emails with Institutional Sale invoice as a public link in Chargent site
 * Example Prod URL: https://checkout.garp.org/chargent/Public_InstitutionalSalesInvoice?id=0060R0000096BuAQAU
 * Example Sandbox URL: https://devjun2019-altest.cs94.force.com/chargent/Public_InstitutionalSalesInvoice?id=0060R0000096BuAQAU
 * 04/26/2019 Xiang: [US-21245] Created.
 * 05/23/2019 Xiang: Added Payment Request creation when inst sale approved
 * 07/01/2019 Xiang: Switched to Custom Label for community URL
 */
public without sharing class InstitutionalSaleEmailCtrl {
    
    private static Set<String> noCreditCountry = new Set<String>{'Ghana', 'Nigeria'};
        
    private static String paymentLinkStatement = Label.Inst_Sale_Pay_Link_Statement;
        
    public static Boolean sendInstEmail {
        get {
            if(null == sendInstEmail) {
                Default_Settings__c setting = Default_Settings__c.getAll().get('SendInstSaleEmail');
                sendInstEmail = setting != null;
            }
            
            return sendInstEmail;
        }
        set;
    }
    
    @testVisible private static Map<Id, User> getSalesUserEmails(List<Opportunity> opptyList) {
        Set<Id> salesUserIds = new Set<Id>();
        for(Opportunity oppty: opptyList) {
            salesUserIds.add(oppty.GARP_Sales_Contact__c);
        }

        return new Map<Id, User>([SELECT Id, Name, Email FROM User WHERE Id IN :salesUserIds]);
    }

    @testVisible private static String baseUrl {
        get {
            if(null == baseUrl) {
                // Connect API always runs in user context and community is not found if user is not in the community
                /* Network n = [SELECT Id FROM Network WHERE Name = 'My GARP'];
                ConnectApi.Community comm = ConnectApi.Communities.getCommunity(n.Id); */

                baseUrl = Label.Chargent_Site + '/Public_InstitutionalSalesInvoice';
            }
            return baseUrl;
        }
        set;
    }
    
    @testVisible private static List<String> acctCCEmails {
        get {
            if(null == acctCCEmails) {
                String emailStr = Label.Inst_Sale_Acct_Email;
                if(String.isNotEmpty(emailStr)) {
                    acctCCEmails = emailStr.split(';');
                }else {
                    acctCCEmails = new List<String>();
                }
            }
            return acctCCEmails;
        }
        set;
    }

    // Entry method called in Process Builder
    @InvocableMethod(label='Email Inst Sale Invoice' description='Method for sending out emails with Institutional Sale invoice as attachment')
    public static void sendInvoiceEmail(List<Opportunity> opptyList) {
        List<Opportunity> approveOpptyList = new List<Opportunity>();
        List<Opportunity> rejectetOpptyList = new List<Opportunity>();
        List<Opportunity> closeOpptyList = new List<Opportunity>();
        List<Opportunity> cancelOpptyList = new List<Opportunity>();
        
        List<Opportunity> allTargetOpps = new List<Opportunity>();

        for(Opportunity oppty : opptyList) {
            if(oppty.IsClosed) {
                switch on oppty.StageName {
                    when 'Closed' {
                        closeOpptyList.add(oppty);
                        allTargetOpps.add(oppty);
                    }
                    when 'Closed Lost' {
                        cancelOpptyList.add(oppty);
                        allTargetOpps.add(oppty);
                    }
                }
            }else if(oppty.Institutional_Sale_Stage__c == 'Approved') {
                approveOpptyList.add(oppty);
                allTargetOpps.add(oppty);
            }else if(oppty.Institutional_Sale_Stage__c == 'Rejected') {
                rejectetOpptyList.add(oppty);
                allTargetOpps.add(oppty);
            }
        }
        
        // Initiate Opportunity to sales person email map
        Map<Id, User> userMap = getSalesUserEmails(allTargetOpps);

        if(approveOpptyList.size() > 0) {
            createPaymentRequest(approveOpptyList);
            processInstSalesOpptyEmail(approveOpptyList, 'approved', userMap);
        }
        
        if(rejectetOpptyList.size() > 0) {
            processInstSalesRejectEmail(rejectetOpptyList, userMap);
        }

        if(closeOpptyList.size() > 0) {
            processInstSalesOpptyEmail(closeOpptyList, 'paid', userMap);
        }
        
        if(cancelOpptyList.size() > 0) {
            processInstSalesOpptyEmail(cancelOpptyList, 'cancelled', userMap);
        }
    }
    
    public static void createPaymentRequest(List<Opportunity> approveOpps) {
        List<ChargentSFA__Payment_Request__c> payReqList = new List<ChargentSFA__Payment_Request__c>();
        
        for(Opportunity oppty : approveOpps) {
            ChargentSFA__Payment_Request__c payReq = new ChargentSFA__Payment_Request__c(ChargentSFA__Opportunity__c=oppty.Id);
            payReqList.add(payReq);
        }
        
        insert payReqList;
    }
    
    public static void processInstSalesOpptyEmail(List<Opportunity> opptyList, String type, Map<Id, User> userMap) {
        
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
		        
        // Query for associated payment requests
        List<ChargentSFA__Payment_Request__c> paymentReqList = [
            SELECT Id, ChargentSFA__Opportunity__c, B2B_Payment_Link_for_Template__c 
            FROM ChargentSFA__Payment_Request__c 
            WHERE ChargentSFA__Opportunity__c IN :opptyList
        ];
        
        Map<Id, String> oppId2PaymentLink = new Map<Id, String>();
        for(ChargentSFA__Payment_Request__c payReq : paymentReqList) {
            oppId2PaymentLink.put(payReq.ChargentSFA__Opportunity__c, payReq.B2B_Payment_Link_for_Template__c);
        }

        for(Opportunity oppty : opptyList) {
            
            // Inst_Sale_Attention__c - Attention Person's name, Inst_Sale_Billing_Email__c - Attention Person's email
            if(String.isNotEmpty(oppty.Inst_Sale_Billing_Email__c)) {
                
                List<String> to = new List<String>();
                to.add(oppty.Inst_Sale_Billing_Email__c.trim());    
                
                List<String> cc = new List<String>();
                // CC BD Sales
                User salesUser = userMap.get(oppty.GARP_Sales_Contact__c);
                if(null != salesUser) {
                    cc.add(salesUser.Email.trim());
                }
                // CC Accounting when Approved, Paid or Cancelled
                for(String acctEml : acctCCEmails) {
                    if(String.isNotEmpty(acctEml)) {
                        cc.add(acctEml.trim());
                    }
                }
                
                String product = null;
                switch on oppty.Inst_Sale_Product_URL_Parameter__c{
                    when 'frm'{
                        product = 'FRM';
                    }
                    when 'erp'{
                        product = 'ERP';
                    }
                    when 'fbr'{
                        product = 'FFR';
                    }
                    when 'icbrr'{
                        product = 'FRR';
                    }
                }
                
                String invoiceUrl = baseUrl + '?Id=' + oppty.Id;
                String invoiceNumber = oppty.Inst_Sale_Display_Invoice_Number__c;
                String attentionName = String.isEmpty(oppty.Inst_Sale_Attention__c) ? '' : oppty.Inst_Sale_Attention__c;

                String body;
                String subject;
                
                if(type == 'approved') {
                    
                    String baseTemp = [SELECT Id, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Inst_Sale_Approved_Email'].HtmlValue;
                    
                    subject = 'GARP Invoice ' + invoiceNumber + ' - Approved';
                    
                    String publicRegiUrl = oppty.Inst_Sale_Public_Registration_URL__c;

                    String paymentUrl = (!noCreditCountry.contains(oppty.ChargentSFA__Billing_Country__c)) ? paymentLinkStatement + ' ' + oppId2PaymentLink.get(oppty.Id) : '' ;
                    
                    body = String.format(baseTemp, new String[] { attentionName, invoiceNumber, invoiceUrl, type, product, publicRegiUrl, paymentUrl });
                    
                }else if(type == 'cancelled'){
                    
                    String baseTemp = [SELECT Id, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Inst_Sale_Cancelled_Email'].HtmlValue;
                    
                    subject = 'GARP Invoice ' + invoiceNumber + ' - Invoice Cancelled';
                    
                    body = String.format(baseTemp, new String[] { attentionName, invoiceNumber, invoiceUrl, type, product});
                    
                }else if(type == 'paid'){
                    
                    String baseTemp = [SELECT Id, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Inst_Sale_Paid_Email'].HtmlValue;
                    
                    subject = 'GARP Invoice ' + invoiceNumber + ' - Payment Confirmation';
                    
                    body = String.format(baseTemp, new String[] { attentionName, invoiceNumber, invoiceUrl, type, product});
                    
                }
                
                emailList.add(getInstSaleEmail(oppty, to, cc, subject, body, null));
            }
        }
        
        if(emailList.size() > 0) {
            if(!Test.isRunningTest() && sendInstEmail) {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList);
                processResults(results, 'processInstSalesOpptyEmail');
            }
        }
    }
    
    public static void processInstSalesRejectEmail(List<Opportunity> opptyList, Map<Id, User> userMap) {
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

        String baseTemp = [SELECT Id, HtmlValue FROM EmailTemplate WHERE DeveloperName = 'Inst_Sale_Reject_Email'].HtmlValue;

        for(Opportunity oppty : opptyList) {
        	User salesUser = userMap.get(oppty.GARP_Sales_Contact__c);
            
            if(null != salesUser) {
                List<String> to = new List<String>();
                to.add(salesUser.Email.trim());
                
                String opptyUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + '/' + oppty.Id;
                String invoiceNumber = oppty.Inst_Sale_Display_Invoice_Number__c;
                
                String subject = 'GARP Sales Order ' + invoiceNumber + ' - Rejected';
                String body = String.format(baseTemp, new String[] {salesUser.Name, invoiceNumber, opptyUrl});
                
                emailList.add(getInstSaleEmail(oppty, to, null, subject, body, null));
            }
        }
        
        if(emailList.size() > 0) {
            if(!Test.isRunningTest() && sendInstEmail) {
                List<Messaging.SendEmailResult> results = Messaging.sendEmail(emailList);
                processResults(results, 'processInstSalesRejectEmail');
            }
        }
    }

    private static Messaging.SingleEmailMessage getInstSaleEmail(Opportunity oppty, List<String> toList, List<String> ccList, String subject, String body, String attachName) {        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        email.setSubject(subject);
        email.setHtmlBody(body);
        email.setToAddresses(toList);
        if(null != ccList) email.setCcAddresses(ccList);
        email.setSenderDisplayName('GARP System');
        
        // Send Invoice as attachment - currently not in use
        if(null != attachName) {
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {getPdfAttach(oppty.Id, attachName)});
        }

        return email;
    }
    
    // Get Attachment for Institutional Sale Opportunity
    @testVisible private static Messaging.EmailFileAttachment getPdfAttach(Id instSaleId, String attachName) {
        PageReference instSalePage = Page.InstitutionalSalesInvoice;
        instSalePage.getParameters().put('id', instSaleId);
        instSalePage.setRedirect(true);
        
        Blob instSaleInvoice = instSalePage.getContent();
        
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setFileName(attachName + '.pdf');
        attach.setBody(instSaleInvoice);
        
        return attach;
    }
    
    // Handle Send Email Results if errors occured
    public static void processResults(List<Messaging.SendEmailResult> results, String methodName) {
        Integer errCount = 0;
        List<String> errMsgs = new List<String>();
        
        for(Messaging.SendEmailResult ser : results) {
            if(!ser.isSuccess()) {
                errCount++;
                
                for(Messaging.SendEmailError err : ser.getErrors()) {
                    System.debug(err);
                    errMsgs.add(err.getMessage());
                }
            }
        }
        
        String resultSummary = 'Result for ' + methodName + ': ' + errCount + ' errors out of ' +  results.size();
        System.debug(resultSummary);
        
        if(errCount > 0) {
            AppError__c appErr = new AppError__c(Message_Short__c = resultSummary, Method__c = methodName, Error__c = String.join(errMsgs, '; '));
            insert appErr;
        }
    }
}