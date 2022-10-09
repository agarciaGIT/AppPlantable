global class BankBulkOrderBatchclass implements Database.Batchable<sObject>,Database.Stateful{
 
     global boolean bHasBooks = true;
     global boolean instsale = true;
     global List<GTList__c> gtIds = GTList__c.getall().values();
    Set<String> productids = new Set<String>();
       
     global string strUPS = 'New Order';
     global string stageName = 'Closed';
     global Date today = system.today();
     String strId = '00629000002RwKN';
     global List<Opportunity> lstDomesticOpps;
     global List<Opportunity> lstInternationalOpps;
     global List<Opportunity> lstInvoiceLessOpps;
     global String strInternationalXML = '';
     global String strDomesticXML = '';
     global String strInvoiceLessXML = '';
     global string strInvoiceLessExcelBodyString = '';
     global string strDomesticExcelBodyString = '';
     global string strInternationalExcelBodyString = '';
     global string strEmailBody = '';
     global string strExcelHeader = 'SNO,CompanyName,Attention,AddressLine1,AddressLine2,AddressLine3,City,State,Country,PostalCode,WorkPhone,FaxNumber,EmailAddress,ServiceType,16FRM1H,16FRM2H,16ERP1B,16ERP2B,16FRRHB,3210,Invoice Number,length,TotalQuantity';
     global set<String> setInvoiceLessCountries = new set<String>{'AS', 'AU', 'AT', 'AZ', 'BE', 'KH', 'CA', 'IC', 'CN', 'CK', 'HR', 'CY', 'CZ', 'DK','DO', 'EN', 'EE', 'FJ', 'FI', 'FR', 'PF', 'DE', 'GU', 'GG', 'HO', 'HK', 'HU', 'IN','ID', 'IE', 'IT', 'JP', 'JE', 'KI', 'KO', 'LV', 'LI', 'LT', 'LU', 'MO', 'M3', 'MY','MV', 'MT', 'MH', 'MX', 'FM', 'MC', 'MN', 'NP', 'NL', 'NC', 'NZ', 'NB', 'MP', 'NO','PW', 'PG', 'PH', 'PL', 'PO', 'PT', 'PR', 'RO', 'RT', 'SP', 'SF', 'SG', 'SK', 'SI','SB', 'ZA', 'KR', 'ES', 'SX', 'UV', 'VL', 'SE', 'CH', 'SY', 'TA', 'TW', 'TH', 'TL','TI', 'TO', 'TU', 'TV', 'GB', 'VI', 'VU', 'VA', 'VN', 'WL', 'WF', 'WS', 'YA'};
     global BankBulkOrderBatchclass(){
        
     }
     
     // Start Method
     global Database.QueryLocator start(Database.BatchableContext BC){
    // for(GTList__c examSite : gtIds)
     // {
     //   productids.add(examSite.Name);
     // }
             string strQuery = 'select Country_Code_for_UPS__c, Duty_Tax_to_Garp__c,id,Shipping_Street__c,Product_Ids__c,Cancel_Books__c,Display_Invoice_Number__c,Shipping_Address1__c,Shipping_Address2__c,Shipping_Address3__c,Product_Names__c,Ups_Stage__c,Customs_Cost__c,GARP_Member_ID__c,Shipping_Company_Name__c,Shipping_Serive_Selected__c,Total_Package_Weight__c,Shipping_First_Name__c,Shipping_Last_Name__c,Ship_Street__c,Shipping_Country__c,Shipping_Postal_Code__c,Shipping_City__c,Shipping_State__c,Shipping_Phone_No__c,Shipping_E_mail__c,UPS_Service_Code_For_Xml__c from opportunity where (Stagename =: stageName or Inst_Sale_Allow_Books_Without_Pay__c =:instsale)and Ups_Stage__c =: strUPS and Has_Books__c =: bHasBooks and Cancel_Books__c =false';

        if(test.isRunningTest()){
     strQuery = 'select Country_Code_for_UPS__c, Duty_Tax_to_Garp__c,id,Shipping_Street__c,Product_Ids__c,Cancel_Books__c,Display_Invoice_Number__c,Shipping_Address1__c,Shipping_Address2__c,Shipping_Address3__c,Product_Names__c,Ups_Stage__c,Customs_Cost__c,GARP_Member_ID__c,Shipping_Company_Name__c,Shipping_Serive_Selected__c,Total_Package_Weight__c,Shipping_First_Name__c,Shipping_Last_Name__c,Ship_Street__c,Shipping_Country__c,Shipping_Postal_Code__c,Shipping_City__c,Shipping_State__c,Shipping_Phone_No__c,Shipping_E_mail__c,UPS_Service_Code_For_Xml__c from opportunity where Stagename =: stageName and Ups_Stage__c =: strUPS and Has_Books__c =: bHasBooks and Cancel_Books__c =false ';
}
        system.debug('strQuery == '+strQuery);
        return Database.getQueryLocator(strQuery);
     }
    
    // Execute Logic
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
        
        system.debug('scope == '+scope);
        lstDomesticOpps = new list<Opportunity>();
        lstInternationalOpps = new list<Opportunity>();
        List<Opportunity> lstUpdateOpps = new List<Opportunity>();
        lstInvoiceLessOpps = new list<Opportunity>();
        for(Opportunity obj : scope)   
        {
            if(obj.Institutional_Sale__c = true){
            system.debug('Obj == '+obj);
            if(setInvoiceLessCountries.contains(obj.Country_Code_for_UPS__c)) lstInvoiceLessOpps.add(obj);
            else if(obj.Country_Code_for_UPS__c == 'US') lstDomesticOpps.add(obj);
            else lstInternationalOpps.add(obj);
            
            obj.Ups_Stage__c = 'Sent to GT';
            lstUpdateOpps.add(obj);
            
           } 
             
        }
        
        system.debug('lstInvoiceLessOpps == '+lstInvoiceLessOpps);
        system.debug('lstInternationalOpps == '+lstInternationalOpps);
        system.debug('lstDomesticOpps == '+lstDomesticOpps);
        if(lstDomesticOpps.size() > 0)
        {
                strDomesticXML += XMLGeneratorNew.domesticShipping(lstDomesticOpps);
                strDomesticExcelBodyString += XMLGeneratorNew.writeExcelBody(lstDomesticOpps);
        }
        if(lstInternationalOpps.size() > 0)
        {
                strInternationalXML += XMLGeneratorNew.internationalShipping(lstInternationalOpps);
                strInternationalExcelBodyString += XMLGeneratorNew.writeExcelBody(lstInternationalOpps);
        }
        if(lstInvoiceLessOpps.size() > 0)
        {
                strInvoiceLessXML += XMLGeneratorNew.invoicelessXML(lstInvoiceLessOpps);
                strInvoiceLessExcelBodyString += XMLGeneratorNew.writeExcelBody(lstInvoiceLessOpps);
        }
        strEmailBody = XMLGeneratorNew.PrepareBodyTable(scope);
        update lstUpdateOpps;
   
    }
   
    global void finish(Database.BatchableContext BC){
        system.debug('strDomesticXML == '+strDomesticXML);
        system.debug('strInternationalXML == '+strInternationalXML);
        system.debug('strInvoiceLessXML == '+strInvoiceLessXML);
        system.debug('strInvoiceLessExcelBodyString == '+strInvoiceLessExcelBodyString);
        system.debug('strDomesticExcelBodyString == '+strDomesticExcelBodyString);
        system.debug('strInternationalExcelBodyString == '+strInternationalExcelBodyString);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String myString = 'StringToBlob';
        String strXMLHeder = '<?xml version="1.0" encoding="windows-1252"?>';
        string strShipMentsStart = '<OpenShipments xmlns="x-schema:OpenShipments.xdr">';
        string strShipMentsClosingTag = '</OpenShipments>';
        List<Messaging.EmailFileAttachment> lstEmailAttachments = new List<Messaging.EmailFileAttachment>();
        String strDateValue = String.valueOf(System.today().Month())+String.valueOf(System.today().Day())+String.valueOf(System.today().Year());
        if(strDomesticXML != '')
        {
            
            strDomesticXML =  strXMLHeder + strShipMentsStart + strDomesticXML +strShipMentsClosingTag;
            Blob domesticBlob = Blob.valueof(strDomesticXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            String strFieName = 'domestic'+'_'+strDateValue+'.xml';
            attachment.setFileName(strFieName);
            system.debug('domesticBlob == '+domesticBlob.toString());
            attachment.setBody(domesticBlob);
            lstEmailAttachments.add(attachment);
            
        }
        if(strInternationalXML != '')
        {
            
            strInternationalXML =  strXMLHeder + strShipMentsStart + strInternationalXML +strShipMentsClosingTag;
            Blob internationalBlob = Blob.valueof(strInternationalXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
             String strFieName = 'international'+'_'+strDateValue+'.xml';
            attachment.setFileName(strFieName);
            attachment.setBody(internationalBlob);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInvoiceLessXML != '')
        {
            strInvoiceLessXML =  strXMLHeder + strShipMentsStart + strInvoiceLessXML +strShipMentsClosingTag;
            Blob invoicelessBlob = Blob.valueof(strInvoiceLessXML);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
           
             String strFieName = 'invoiceless'+'_'+strDateValue+'.xml';
            attachment.setFileName(strFieName);
            system.debug('invoicelessBlob == '+invoicelessBlob.toString());
            attachment.setBody(invoicelessBlob);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInvoiceLessExcelBodyString != '')
        {
            strInvoiceLessExcelBodyString =  strExcelHeader + '\r\n' + strInvoiceLessExcelBodyString;
            Blob InvoiceLessExcellBlob = Blob.valueof(strInvoiceLessExcelBodyString);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            
            String strFieName = 'invoiceless'+'_'+strDateValue+'.csv';
            attachment.setFileName(strFieName);
            system.debug('Invoice excellBlob == '+InvoiceLessExcellBlob.toString());
            attachment.setBody(InvoiceLessExcellBlob);
            lstEmailAttachments.add(attachment);
        
        }
        if(strDomesticExcelBodyString != '')
        {
            strDomesticExcelBodyString =  strExcelHeader + '\r\n' + strDomesticExcelBodyString;
            Blob DomesticExcellBlob = Blob.valueof(strDomesticExcelBodyString);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            String strFieName = 'domestic'+'_'+strDateValue+'.csv';
            attachment.setFileName(strFieName);
            system.debug('DomesticExcellBlob == '+DomesticExcellBlob.toString());
            attachment.setBody(DomesticExcellBlob);
            lstEmailAttachments.add(attachment);
        
        }
        if(strInternationalExcelBodyString != '')
        {
            strInternationalExcelBodyString =  strExcelHeader + '\r\n' +strInternationalExcelBodyString;
            Blob InternationalExcellBlob = Blob.valueof(strInternationalExcelBodyString);
            Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
            String strFieName = 'international'+'_'+strDateValue+'.csv';
            attachment.setFileName(strFieName);
            attachment.setBody(InternationalExcellBlob);
            lstEmailAttachments.add(attachment);
        
        }
        
          List<String> toAddresses = new List<String>();
       list< BankBulkOrders__c > selector = BankBulkOrders__c.getall().values();
       Set<String> emailids = new Set<String>();
       //System.debug(selector.Recipient_Emil__c);
       for(BankBulkOrders__c email : selector)
     {
       emailids.add(email.Name);
     }
      for(string s :emailids)
       if (s != null) {
           toAddresses.add(s);
       }
       
       
        system.debug('lstEmailAttachments == '+lstEmailAttachments);
        mail.setFileAttachments(lstEmailAttachments);
        mail.setToAddresses(toAddresses);
        mail.setReplyTo('vivek.reddy@garp.com');
        mail.setSenderDisplayName('Batch XML Files');
        mail.setSubject('XML Files');
        mail.setHTMLBody(strEmailBody);
        try {
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        }catch(Exception e){
                    System.Debug(e);
                } 
       
    }
    }