public class ChargentBackup {
    
    
    public static string paypalcallout(Id oppId,String cardMonth,String cardYear,String cardType,String cardNumber,string cvvnumber,Decimal amount){
        
       
        List<ChargentSFA__Transaction__c> lstTransactions = new List<ChargentSFA__Transaction__c>();
        
        Opportunity opp =[SELECT Id, Display_Invoice_Number__c, Company__c FROM opportunity WHERE Id =: oppId] ;
 
        string displayinvoicenumber =opp.Display_Invoice_Number__c ;
        string company = opp.Company__c;
        
        Paypalsettings__c  payPalSettings = null;
        if(company =='GARP'){
            payPalSettings = Paypalsettings__c.getValues('GARP');
        }else{
            payPalSettings = Paypalsettings__c.getValues('GRA');
        }

        string expiryday = cardYear + cardMonth;
        
        system.debug('&&&&&:'+payPalSettings.UserName__c);
        system.debug('&&&&&:'+payPalSettings.Password__c);
        
        String strBody = '<?xml version="1.0" encoding="UTF-8" ?>';
        strBody += '<XMLPayRequest Timeout="30" version="2.0" xmlns="http://www.paypal.com/XMLPay">';
        
        strBody += '<RequestData>';
        strBody += '<Vendor></Vendor>';
        strBody += '<Partner>'+payPalSettings.Partner__c+'</Partner>';
        strBody += '<Transactions>';
        strBody += '<Transaction>';
        strBody += '<Sale>';
        strBody += '<PayData>';
        strBody += '<Invoice>';
        strBody += '<TotalAmt>'+amount+'</TotalAmt>';
        strBody += '<Comment>'+displayinvoicenumber+'</Comment>';
        strBody += '</Invoice>';
        strBody += '<Tender>';
        strBody += '<Card>';
        strBody += '<CardType>'+cardtype+'</CardType>';
        strBody += '<CardNum>'+cardnumber+'</CardNum>';
        strBody += '<ExpDate>'+expiryday+'</ExpDate>';
        strBody += '<CVV2>'+cvvnumber+'</CVV2>';
        strBody += '</Card>';
        strBody += '</Tender>';
        strBody += '</PayData>';
        strBody += '</Sale>';
        strBody += '</Transaction>';
        strBody += '</Transactions>';
        strBody += '</RequestData>';
        strBody += '<RequestAuth>';
        strBody += '<UserPass>';
        strBody += '<User>'+payPalSettings.UserName__c+'</User>';
        strBody += '<Password>'+payPalSettings.Password__c+'</Password>';
        strBody += '</UserPass>';
        strBody += '</RequestAuth>';
        strBody += '</XMLPayRequest>';
        system.debug('%%%%:'+strBody);
        HttpRequest req = new HttpRequest();
        
        req.setEndpoint(payPalSettings.EndPoint__c);
        req.setMethod('POST');
        
        req.setBody(strBody);
        Http http = new Http();
        HTTPResponse res;
        if(!Test.isRunningTest())
            res = http.send(req);
        else
        {
            res = new HTTPResponse();
            res.setBody('<XMLPayResponse xmlns="http://www.paypal.com/XMLPay"><ResponseData><Vendor>GARPNY</Vendor><Partner>verisign</Partner><RecurringProfileResults><RecurringProfileResult Id="1"><Result>36</Result><Message>Transaction failed: Fail to obtain approval for the online transaction</Message><RPRef>RPX5C0D50AA3</RPRef><TransactionResult><Result>12</Result><AVSResult><StreetMatch>Service Not Available</StreetMatch><ZipMatch>Service Not Available</ZipMatch></AVSResult></TransactionResult><ExtData Name="TRXPNREF" Value="AT1AD3D79954"></ExtData><ExtData Name="TRXRESPMSG" Value="Declined"></ExtData><ExtData Name="IAVS" Value="X"></ExtData></RecurringProfileResult></RecurringProfileResults></ResponseData></XMLPayResponse>');
            
        }
        
        
        //System.debug(res.getBody());
        Dom.Document doc = new Dom.Document();
        doc.load(res.getBody());
        Dom.XMLNode payPalResponse = doc.getRootElement();
        
        String message;
        String txnRef;
        String authCode ;
        String response;
        
        string nameSpace = 'http://www.paypal.com/XMLPay';
        try
        {
            response = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('TransactionResults',nameSpace).getChildElement('TransactionResult',nameSpace).getChildElement('Result',nameSpace).getText());
            system.debug('response:'+response);

            txnRef = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('TransactionResults',nameSpace).getChildElement('TransactionResult',nameSpace).getChildElement('PNRef',nameSpace).getText());
            
            system.debug('txnRef:'+txnRef);    
            
            message = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('TransactionResults',nameSpace).getChildElement('TransactionResult',nameSpace).getChildElement('Message',nameSpace).getText());
            system.debug('message:'+message);
            
            authCode = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('TransactionResults',nameSpace).getChildElement('TransactionResult',nameSpace).getChildElement('AuthCode',nameSpace).getText());
             system.debug('authCode:'+authCode);   
            
        }
        catch(exception ex)
        {
            message = ex.getMessage();
             system.debug('&&&&&vivek:'+response);
             
            
        }
        finally
        {
              if(!Test.isRunningTest()){
            message = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('TransactionResults',nameSpace).getChildElement('TransactionResult',nameSpace).getChildElement('Message',nameSpace).getText());
            system.debug('message:'+message);
              }    
            
            string resBody = res.getBody();
            system.debug('resBody:'+resBody);
            ChargentSFA__Transaction__c newTransaction = new ChargentSFA__Transaction__c();
            newTransaction.ChargentSFA__Gateway_Response__c = (resBody != null && resBody.length() > 32768) ? resBody.substring(0) : resBody;
            newTransaction.ChargentSFA__Opportunity__c = oppid;
            newTransaction.ChargentSFA__Type__c = 'Charge';
            if(Test.isRunningTest()){
              newTransaction.ChargentSFA__Response_Message__c = (message != null && message.length() > 127) ? message.substring(0,125) : message;           
                newTransaction.ChargentSFA__Response_Status__c = (message != null && message.length() > 32) ? message.substring(0,32) : message;   
            }
            if(!Test.isRunningTest()){
            newTransaction.ChargentSFA__Response_Message__c = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('TransactionResults',nameSpace).getChildElement('TransactionResult',nameSpace).getChildElement('Message',nameSpace).getText());           
            newTransaction.ChargentSFA__Response_Status__c = String.valueOf(payPalResponse.getChildElement('ResponseData',nameSpace).getChildElement('TransactionResults',nameSpace).getChildElement('TransactionResult',nameSpace).getChildElement('Message',nameSpace).getText());    }
            newTransaction.ChargentSFA__Amount__c = amount;
            newTransaction.ChargentSFA__Payment_Method__c = 'Credit Card';
            newTransaction.ChargentSFA__Gateway_Date__c = system.now();
            newTransaction.ChargentSFA__Gateway__c = payPalSettings.Paypal_GateWay_ID__c;
            newTransaction.ChargentSFA__Gateway_ID__c = txnRef;
            newTransaction.ChargentSFA__Tokenization__c = txnRef;
             newTransaction.ChargentSFA__Authorization__c = authCode;
            newTransaction.ChargentSFA__Credit_Card_Type__c =cardType;
            newTransaction.ChargentSFA__Response__c = response;
            lstTransactions.add(newTransaction);
            
        }  
        insert  lstTransactions;       
        return message;
    }
    
    
    
    
}