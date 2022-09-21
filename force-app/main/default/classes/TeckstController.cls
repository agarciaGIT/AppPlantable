global class TeckstController {
    public Case cse {get; set;}
    public Contact contact { get; private set; }
    public String contactId { get; private set; }
    public String contactName { get; private set; }
    public String contactPhone { get; private set; }
    public String agentName { get; set; }
    public String agentTimeZone { get; private set; }
    public String agentId { get; private set; }
    public String defaultNumber { get; private set; }
    public String clientID { get; private set; }
    public String allowMsgBlockStyle { get; set; }
    public String iFrameUrl { get; private set; }

    public TeckstController(ApexPages.StandardController stdController) {
        if (!Test.isRunningTest()) {
          stdController.addFields(new List<String> { 'Subject', 'OwnerId', 'Id', 'Status', 'CaseNumber', 'Contact.Name', 'Contact.Id', 'Contact.Phone', 'Contact.MobilePhone', 'Contact.FirstName', 'Contact.LastName', 'Is_Teckst_Case__c', 'SuppliedName', 'SuppliedPhone' });
        }

        cse = (Case)stdController.getRecord();

        if (cse.Status == 'Closed') {
            allowMsgBlockStyle = 'none';
        } else {
            allowMsgBlockStyle = 'block';
        }

        contactId = '';
        contactName = '';
        contactPhone = '';
        if (cse.get('SuppliedName') != null) {
            contactName = String.valueOf(cse.get('SuppliedName'));
        }
        if (cse.get('SuppliedPhone') != null) {
            contactPhone = String.valueOf(cse.get('SuppliedPhone'));
        }
        if (cse.Contact != null) {
            try {
              contact = cse.Contact;
              contactPhone = String.valueOf(contact.get('MobilePhone'));
              if (String.isBlank(contactPhone)) {
                contactPhone = String.valueOf(contact.get('Phone'));
              }
              contactId = String.valueOf(contact.get('Id'));
              contactName = String.valueOf(contact.get('Name'));
            } catch (Exception e) {
              contactId = '';
              contactName = '';
              contactPhone = '';
            }
        }

        agentName = UserInfo.getName();
        agentId = UserInfo.getUserId();
        agentTimeZone = UserInfo.getTimeZone().toString();

        Teckst_Settings__c ts = Teckst_Settings__c.getInstance(UserInfo.getProfileId());
        if (ts != null) {
          defaultNumber = ts.Teckst_Default_Number__c;
          clientID = ts.Teckst_Client_ID__c;
        } else {
          try {
            ts = Teckst_Settings__c.getInstance(UserInfo.getOrganizationId());
            defaultNumber = ts.Teckst_Default_Number__c;
            clientID = ts.Teckst_Client_ID__c;
          } catch (Exception e) {
            ts = Teckst_Settings__c.getInstance('Teckst Settings');
            defaultNumber = ts.Teckst_Default_Number__c;
            clientID = ts.Teckst_Client_ID__c;
          }
        }

        iFrameUrl = 'https://crm.teckst.com/teckst-widget?';
        String parameters = '';
        parameters += 'isWidget=true';
        parameters += '&agentID=' + EncodingUtil.urlEncode(String.valueOf(agentId), 'UTF-8');
        parameters += '&ownerID=' + EncodingUtil.urlEncode(String.valueOf(cse.OwnerId), 'UTF-8');
        parameters += '&clientID=' + EncodingUtil.urlEncode(String.valueOf(clientID), 'UTF-8');
        parameters += '&fromIdentifier=' + EncodingUtil.urlEncode(String.valueOf(defaultNumber), 'UTF-8');
        parameters += '&agentName=' + EncodingUtil.urlEncode(String.valueOf(agentName), 'UTF-8');
        parameters += '&customerID=' + EncodingUtil.urlEncode(String.valueOf(contactId), 'UTF-8');
        parameters += '&customerName=' + EncodingUtil.urlEncode(contactName, 'UTF-8');
        parameters += '&toIdentifier=' + EncodingUtil.urlEncode(String.valueOf(contactPhone), 'UTF-8');
        parameters += '&ticketID=' + EncodingUtil.urlEncode(String.valueOf(cse.Id), 'UTF-8');
        parameters += '&ticketStatus=' + EncodingUtil.urlEncode(String.valueOf(cse.Status), 'UTF-8');
        parameters += '&displayID=' + EncodingUtil.urlEncode(String.valueOf(cse.CaseNumber), 'UTF-8');
        if (cse.Subject != null) {
          parameters += '&ticketSubject=' + EncodingUtil.urlEncode(String.valueOf(cse.Subject), 'UTF-8');
        }
        parameters += '&crmType=SFSC';
        iFrameUrl += parameters;
        System.debug(iFrameUrl);
    }

    public static void defensiveChangeCaseStatus(String caseId, String status) {
        if(!System.isFuture() && !System.isBatch()){
            changeCaseStatus(caseId, status);
        }
    }

  @Future(callout=true)
  global static void changeCaseStatus(String caseId, String status) {
    HTTPRequest req = new HTTPRequest();
    req.setMethod('POST');
    req.setHeader('content-type', 'application/json');
    req.setHeader('Accept', 'application/json');


    Teckst_Settings__c ts = Teckst_Settings__c.getInstance();
    String clientID = ts.Teckst_Client_ID__c;

    req.setEndpoint('https://api.teckst.com/v1/crm/webhook');
    req.setBody('{"Id":"' + caseId + '","Status":"' + status + '","clientID":"' + clientID + '","crm":"SFSCAccount"}');
    Http http = new Http();
    HTTPResponse res = http.send(req);
  }

  global class TeckstMessageSender {
    @InvocableVariable(label='Contact Id' required=true)
    global Id PBContactId;

    @InvocableVariable(label='Message Body' required=true)
    global String PBMessageBody;

    @TestVisible private TeckstController.TeckstMessageSender toTeckstMessageSender() {
      TeckstController.TeckstMessageSender teckstMessageSender = new TeckstController.TeckstMessageSender();
      teckstMessageSender.PBContactId = PBContactId;
      teckstMessageSender.PBMessageBody = PBMessageBody;
      return teckstMessageSender;
    }
  }

  @InvocableMethod(
    label='Send Teckst Message'
    description='Sends a text message through Teckst'
  )
    
  global static void sendTeckstMessage(List<TeckstMessageSender> teckstMessageSenders) {
    Contact contact;
    Teckst_Settings__c ts = Teckst_Settings__c.getInstance();
    String defaultNumber = ts.Teckst_Default_Number__c;
    String clientID = ts.Teckst_Client_ID__c;
    String apiToken = ts.Teckst_API_Token__c;
    String contactPhone;

    for(TeckstMessageSender teckstSender : teckstMessageSenders) {
      contact = [SELECT Phone, MobilePhone FROM Contact WHERE Id = :teckstSender.PBContactId LIMIT 1];
      contactPhone = String.valueOf(contact.get('MobilePhone'));
      if (String.isBlank(contactPhone)) {
        contactPhone = String.valueOf(contact.get('Phone'));
      }

      if (String.isBlank(contactPhone)) {
        return;
      }

      String requestBody = '{"fromIdentifier":"' + defaultNumber + '",' +
                      '"toIdentifier":"' + contactPhone + '",' +
                      '"content":"' + teckstSender.PBMessageBody + '"}';

      sendMessage(apiToken, requestBody);
    }
  }

  global static void sendTeckstMessageNoFuture(List<TeckstMessageSender> teckstMessageSenders) {
    Contact contact;
    Teckst_Settings__c ts = Teckst_Settings__c.getInstance();
    String defaultNumber = ts.Teckst_Default_Number__c;
    String clientID = ts.Teckst_Client_ID__c;
    String apiToken = ts.Teckst_API_Token__c;
    String contactPhone;

    for(TeckstMessageSender teckstSender : teckstMessageSenders) {
      contact = [SELECT Phone, MobilePhone FROM Contact WHERE Id = :teckstSender.PBContactId LIMIT 1];
      contactPhone = String.valueOf(contact.get('MobilePhone'));
      if (String.isBlank(contactPhone)) {
        contactPhone = String.valueOf(contact.get('Phone'));
      }

      if (String.isBlank(contactPhone)) {
        return;
      }

      String requestBody = '{"fromIdentifier":"' + defaultNumber + '",' +
                      '"toIdentifier":"' + contactPhone + '",' +
                      '"content":"' + teckstSender.PBMessageBody + '"}';

      sendMessageNoFuture(apiToken, requestBody);
    }
  }
    
  @future(callout=true)
  static void sendMessage(String token, String requestBody) {
    HTTPRequest req = new HTTPRequest();
    req.setMethod('POST');
    req.setHeader('content-type', 'application/json');
    req.setHeader('token', token);
    req.setHeader('Accept', 'application/json');
    req.setEndpoint('https://api.teckst.com/v1/Message');
    req.setBody(requestBody);
    Http http = new Http();
    HTTPResponse res = http.send(req);
  }
    
  static void sendMessageNoFuture(String token, String requestBody) {
    HTTPRequest req = new HTTPRequest();
    req.setMethod('POST');
    req.setHeader('content-type', 'application/json');
    req.setHeader('token', token);
    req.setHeader('Accept', 'application/json');
    req.setEndpoint('https://api.teckst.com/v1/Message');
    req.setBody(requestBody);
    Http http = new Http();
    HTTPResponse res = http.send(req);
  }

}