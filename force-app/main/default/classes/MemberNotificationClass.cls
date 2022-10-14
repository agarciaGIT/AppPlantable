Global class MemberNotificationClass {
    
    public static PageReference emailTracker() {
                
        PageReference pg = null;
        
        // Get the Notification Recipient ID
        String recid = ApexPages.currentPage().getParameters().get('recid');
        system.debug('recid:' + recid);

        String url = ApexPages.currentPage().getParameters().get('url');
        system.debug('url:' + url);
        
        List<Member_Notification_Recipient__c> lstRec = [select Id, Is_Opened__c from Member_Notification_Recipient__c where id = :recid];
        system.debug('lstRec:' + lstRec);
        if(!lstRec.isEmpty()) {
            lstRec[0].Is_Opened__c = True;
            lstRec[0].Opened_Date_Time__c =  DateTime.now();
            if(url != NULL) {
                lstRec[0].Is_Clicked__c = True;
                lstRec[0].Clicked_Date_Time__c =  DateTime.now();
                pg = new PageReference('/Login?start=' + url);
                pg.setRedirect(true);
            }
            update lstRec;
        }
        
        return pg;
    }
    
    public static Boolean setMemberNotificationAsViewed(String recNotId) {
        Boolean ret=True;
        
        System.Debug('recNotId:' + recNotId);
        
        List<Member_Notification_Recipient__c> lstRec = [select Id, Is_Viewed_In_Portal__c, Viewed_Date_Time__c from Member_Notification_Recipient__c where id = :recNotId];
        if(!lstRec.isEmpty()) {
            lstRec[0].Is_Viewed_In_Portal__c = True;
            lstRec[0].Viewed_Date_Time__c = DateTime.Now();
            Update lstRec;
        }
        
        return ret;
    }
        
    public static List<Member_Notification_Recipient__c> getMemberNotifications(String contactId) {
        
        List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Sent_Date_Time__c, Sent_Message__c, Is_Viewed_In_Portal__c,
                                                         Member_Notification__r.Subject__c from Member_Notification_Recipient__c 
                                                         where Contact__c = :contactId AND Member_Notification__r.Status__c = 'Sent'];
        System.debug('lstRec:' + lstRec);
        return lstRec;
    }

    public static List<Member_Notification_Recipient__c> getMemberNotificationsExamAlerts(String contactId) {
        
        List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Sent_Date_Time__c, Sent_Message__c, Is_Viewed_In_Portal__c,
                                                         Member_Notification__r.Subject__c from Member_Notification_Recipient__c where 
                                                         Contact__c = :contactId AND Member_Notification__r.Type__c = 'Exam' AND Member_Notification__r.Status__c = 'Sent'];
        System.debug('lstRec:' + lstRec);
        return lstRec;
    }

    
    @AuraEnabled
    public static Boolean sendNotificationButtonAura(String notificationId) {
        
        list<Member_Notification__c> lstNotif = [select Id, Name, Custom_Message__c, Status__c, Template__c 
                                                 from Member_Notification__c where id = :notificationId and Status__c='Approved'];
        system.debug('lstNotif:' + lstNotif);
        if(lstNotif.isEmpty()) {
            return False;
        } else {

            sendNotification(notificationId);
            return True;
        }        
    }
    
    @AuraEnabled
    public static Boolean resendNotificationButtonAura(String notificationId) {
        
        list<Member_Notification__c> lstNotif = [select Id, Name, Custom_Message__c, Status__c, Template__c 
                                                 from Member_Notification__c where id = :notificationId and Status__c='Sent'];
        system.debug('lstNotif:' + lstNotif);
        if(lstNotif.isEmpty()) {
            return False;
        } else {

            resendNotification(notificationId,null);
            return True;
        }
    }
    
    
    @AuraEnabled
    public static Boolean resendNotificationRecipientButtonAura(String recpientId) {
        
        List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Member_Notification__c, Member_Notification__r.Status__c 
                                                         from Member_Notification_Recipient__c where Id = :recpientId AND Sending_Status__c = 'Sent' AND Member_Notification__r.Status__c = 'Sent'];
        system.debug('lstRec:' + lstRec);

        if(lstRec.isEmpty()) {
            return False;
        } else {            
            resendNotification(lstRec[0].Member_Notification__c,recpientId);
            return True;
        }
    }

    webservice static void sendNotificationButton(String notificationId) {
        sendNotification(notificationId);
    }

    webservice static void resendNotificationButton(String notificationId, String recpientId) {
        resendNotification(notificationId, recpientId);
    }
    
    public static void resendNotification(String notificationId, String recpientId) {
        
        system.debug('resendNotification:' + notificationId);
        system.debug('recpientId:' + recpientId);
        
        list<Member_Notification__c> lstNotif = [select Id, Name, Custom_Message__c, Status__c, Template__c 
                                                 from Member_Notification__c where id = :notificationId and Status__c='Sent'];
        
        system.debug('lstNotif:' + lstNotif);
        
        if(!lstNotif.isEmpty()) {
            List<Member_Notification_Recipient__c> lstRec;
            if(recpientId == NULL) {
                lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Member_Notification__r.Custom_Message__c 
                                                                 from Member_Notification_Recipient__c where Member_Notification__c = :notificationId];
            } else {
                lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Member_Notification__r.Custom_Message__c 
                                                                 from Member_Notification_Recipient__c where Member_Notification__c = :notificationId AND Id = :recpientId];
                
            }
            system.debug('lstRec:' + lstRec);
            
            for(Member_Notification_Recipient__c rec :lstRec) {
                rec.Sending_Status__c = 'Pending';
                rec.Custom_Message__c = rec.Member_Notification__r.Custom_Message__c;
            }
            update lstRec;
            
            MemberNotificationSendBatch batch = new MemberNotificationSendBatch(notificationId);
            Database.executebatch(batch,1);
        }
    }
    
    public static void sendNotification(String notificationId) {
        
        system.debug('sendNotification:' + notificationId);
        
        list<Member_Notification__c> lstNotif = [select Id, Name, Custom_Message__c, Status__c, Template__c 
                                                 from Member_Notification__c where id = :notificationId and Status__c='Approved'];
        
        system.debug('lstNotif:' + lstNotif);
        
        if(!lstNotif.isEmpty()) {
            List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Member_Notification__r.Custom_Message__c 
                                                             from Member_Notification_Recipient__c where Member_Notification__c = :notificationId];
            system.debug('lstRec:' + lstRec);
            
            for(Member_Notification_Recipient__c rec :lstRec) {
                rec.Sending_Status__c = 'Pending';
                rec.Custom_Message__c = rec.Member_Notification__r.Custom_Message__c;
            }
            update lstRec;
            
            MemberNotificationSendBatch batch = new MemberNotificationSendBatch(notificationId);
            Database.executebatch(batch,1);
        }
    }
    
    public static void notifyLoggedInUsers() {
        List<MemberNotification__e> noteEvents = new List<MemberNotification__e>();
        MemberNotification__e noteEvent = new MemberNotification__e(Type__c = 'Send');
        noteEvents.add(noteEvent);
        
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(noteEvents);        
    }
    
    public static void sendSalesforceEmail(String emailTemplate, String notificationRecipientId, String emailAddress) {

        String findTemplateName = 'CustomerNotification - ' + emailTemplate;
        String orgWideId = Label.Member_Notification_Org_Wide_Id;
        
        system.debug('emailTemplate:' + emailTemplate);
        system.debug('findTemplateName:' + findTemplateName);
        system.debug('notificationRecipientId:' + notificationRecipientId);
        system.debug('emailAddress:' + emailAddress);
        system.debug('orgWideId:' + orgWideId);

        List<Contact> lstCont = [SELECT Id, Email from Contact where Email = :emailAddress];
        List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c,
                                                         Member_Notification__r.Require_Portal_Login__c, Number_Of_Sends__c
                                                         from Member_Notification_Recipient__c where Id = :notificationRecipientId];
        
        List<EmailTemplate> lstEmailTemplates = [SELECT Id, Body, Subject, HtmlValue  from EmailTemplate where Name = :findTemplateName];
        List<OrgWideEmailAddress> lstOrgWide = [select Id, Address, DisplayName from OrgWideEmailAddress where Id = :orgWideId];
        
        system.debug('lstCont:' + lstCont);
        system.debug('lstRec:' + lstRec);
        system.debug('lstEmailTemplates:' + lstEmailTemplates);
        system.debug('lstOrgWide:' + lstOrgWide);
                
        if(!lstRec.isEmpty() && !lstCont.isEmpty() && lstEmailTemplates != null && lstEmailTemplates.size() > 0 && lstOrgWide != null && lstOrgWide.size() > 0) {
            
            List<String> bodies = new List<String>();
            bodies.add(lstEmailTemplates[0].HtmlValue);
            
            List<Messaging.RenderEmailTemplateBodyResult> resList = 
                Messaging.renderEmailTemplate(lstCont[0].Id, notificationRecipientId, bodies);
            
            String msg = resList[0].getMergedBody();
            system.debug('msg:' + msg);
            
            if(lstRec[0].Member_Notification__r.Require_Portal_Login__c == true) {
                lstEmailTemplates = [SELECT Id, Body, Subject, HtmlValue  from EmailTemplate where Name = 'CustomerNotification - General'];    
            }

            String ret = sendEmail(lstEmailTemplates[0].Id, lstCont[0].Id, lstOrgWide[0].Address, notificationRecipientId, orgWideId);            
            if(ret == NULL) {
                lstRec[0].Sending_Status__c =  'Sent';
                lstRec[0].Sent_Date_Time__c =  DateTime.now();
                lstRec[0].Sent_Message__c = msg;
                lstRec[0].Number_Of_Sends__c = lstRec[0].Number_Of_Sends__c + 1;
            } else {
                lstRec[0].Sending_Status__c =  'Error';
            }
            lstRec[0].Contact__c = lstCont[0].Id;
            update lstRec;
        }
    }
 
    public static String sendEmail(String templateId, String targetId, String replyTo, String whatObj, String ogrWideID) {

        system.debug('sendEmail');
        system.debug('templateId:' + templateId);
        system.debug('targetId:' + targetId);
        system.debug('replyTo:' + replyTo);
        system.debug('whatObj:' + whatObj);
        system.debug('ogrWideID:' + ogrWideID);
        
        String ret=null;
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId(templateId);
        mail.setSaveAsActivity(false);
        mail.setTargetObjectId(targetId);        
        mail.setReplyTo(replyTo);
        mail.setWhatId(whatObj);
        mail.setOrgWideEmailAddressId(ogrWideID);
        
        try {
            Messaging.SendEmailResult[] resultMail = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
            system.debug('resultMail:' + resultMail);
            if(!resultMail[0].isSuccess()) {
                List<Messaging.SendEmailError> errors = resultMail[0].getErrors(); 
                if(!errors.isEmpty()) {
                    ret = errors[0].getMessage();
                }
            }
        } catch(System.EmailException e) {
            System.debug('EmailException error: '+ e);
            ret = e.getMessage();
        }
        
        return ret;
    }
}