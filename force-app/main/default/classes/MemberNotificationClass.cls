Global class MemberNotificationClass {


    public static void updateSendingStatus(String notificationId) {
        
        List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Sent_Date_Time__c, 
                                                         Sending_Message__c, Delivery_Confirmed__c,
                                                         Member_Notification__r.Name from Member_Notification_Recipient__c where Member_Notification__c = :notificationId];

        system.debug('lstRec:' + lstRec);
        if(!lstRec.isEmpty()) {
            
            MAP<String, Member_Notification_Recipient__c> mapNotif = new MAP<String, Member_Notification_Recipient__c>();
            for(Member_Notification_Recipient__c mnr :lstRec) {
                mapNotif.put(mnr.Email__c, mnr);
            }
            system.debug('mapNotif:' + mapNotif);
            
            List<Member_Notification_Email_Log_Entry__c> mnele = [select id, Email_Address__c, Log_Action__c, Log_Date_Time__c, Message__c, Retry_Count__c, Sender__c 
                                                                  from Member_Notification_Email_Log_Entry__c
                                                                  where Email_Address__c in :mapNotif.keySet() order by Log_Date_Time__c];
            system.debug('mnele:' + mnele);
            
            if(!mnele.isEmpty()) {
                
                List<Member_Notification_Recipient__c> lstUpdateRec = new List<Member_Notification_Recipient__c>();
                Set<String> emailsToUpdate = new Set<String>();
                
                for(Member_Notification_Email_Log_Entry__c le :mnele) {
                    
                    system.debug('le:' + le);
                    
                    Member_Notification_Recipient__c fndNotif = mapNotif.get(le.Email_Address__c);
                    
                    system.debug('fndNotif:' + fndNotif);
                    
                    
                    DateTime notedt = fndNotif.Sent_Date_Time__c;
                    DateTime GMTNoteDate = Datetime.newInstanceGmt(
                            notedt .year(),
                            notedt .month(),
                            notedt .day(),
                            notedt .hour(),
                            notedt .minute(),
                            notedt .second());
                    
                    system.debug('GMTNoteDate :' + GMTNoteDate );
                    
                    DateTime logdt = le.Log_Date_Time__c;
                    Datetime GMTLogDate = Datetime.newInstanceGmt(
                            logdt.year(),
                            logdt.month(),
                            logdt.day(),
                            logdt.hour(),
                            logdt.minute(),
                            logdt.second());
                    String userId = UserInfo.getName();
                    String userTimeZone = UserInfo.getTimeZone().getID();
                    String logDate = GMTLogDate.format('MM/dd/yyyy HH',userTimeZone);

                    system.debug('logDate :' + logDate);
                    
                    system.debug('NoteDay :' + GMTNoteDate.dayGmt());
                    system.debug('LogDay :' + Integer.ValueOf(GMTLogDate.format('dd',userTimeZone)));

                    system.debug('Notemonth :' + GMTNoteDate.monthGmt());
                    system.debug('Logmonth :' + Integer.ValueOf(GMTLogDate.format('MM',userTimeZone)));

                    system.debug('Noteyear :' + GMTNoteDate.yearGmt());
                    system.debug('Logyear :' + Integer.ValueOf(GMTLogDate.format('yyyy',userTimeZone)));

                    system.debug('Notehour :' + GMTNoteDate.hourGmt());
                    system.debug('Loghour :' + Integer.ValueOf(GMTLogDate.format('HH',userTimeZone)));
                    
                    
                    if(fndNotif != NULL && fndNotif.Sent_Date_Time__c != NULL &&
                       GMTNoteDate.dayGmt() == Integer.ValueOf(GMTLogDate.format('dd',userTimeZone)) &&
                       GMTNoteDate.monthGmt() == Integer.ValueOf(GMTLogDate.format('MM',userTimeZone)) &&
                       GMTNoteDate.yearGmt() == Integer.ValueOf(GMTLogDate.format('yyyy',userTimeZone)) &&
                       GMTNoteDate.hourGmt() == Integer.ValueOf(GMTLogDate.format('HH',userTimeZone))
                      ) {
                          Boolean updateRec = false;
                          
                          system.debug('check fndNotif:' + fndNotif);
                          
                          if(le.Log_Action__c == 'P') {
                              fndNotif.Sending_Status__c = 'Error';
                              updateRec = true;
                          }
                          if(le.Log_Action__c == 'D') {
                              fndNotif.Delivery_Confirmed__c = True;    
                              updateRec = true;
                          }
                          if(le.Message__c != NULL) {
                              fndNotif.Sending_Message__c = le.Message__c;    
                              updateRec = true;
                          }
                          if(updateRec) {
                              system.debug('update fndNotif:' + fndNotif);
                              emailsToUpdate.add(le.Email_Address__c);
                          }
                      }
                }
                system.debug('update emailsToUpdate:' + emailsToUpdate);
                
                for(String em :emailsToUpdate) {
                    Member_Notification_Recipient__c fndNotif = mapNotif.get(em);
                    if(fndNotif != NULL) {
                        lstUpdateRec.add(fndNotif);
                    }
                }
                system.debug('update lstUpdateRec:' + lstUpdateRec);
                update lstUpdateRec;
            }
        }
    }
    
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
                if(url.indexOf('http') > -1) {
                    pg = new PageReference(url);
                } else {
                    pg = new PageReference('/Login?start=' + url);
                }
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
                                                         where Sending_Status__c = 'Sent' AND Contact__c = :contactId AND Member_Notification__r.Status__c = 'Sent' ORDER BY Sent_Date_Time__c DESC];
        System.debug('lstRec:' + lstRec);
        return lstRec;
    }
    
    public static List<Member_Notification_Recipient__c> getMemberNotificationsExamAlerts(String contactId) {
        
        List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Sent_Date_Time__c, Sent_Message__c, Is_Viewed_In_Portal__c,
                                                         Member_Notification__r.Subject__c from Member_Notification_Recipient__c where 
                                                         Sending_Status__c = 'Sent' AND
                                                         Contact__c = :contactId AND Member_Notification__r.Type__c = 'Exam' AND Member_Notification__r.Status__c = 'Sent' ORDER BY Sent_Date_Time__c DESC];
        System.debug('lstRec:' + lstRec);
        return lstRec;
    }
    
    public static void notifyLoggedInUsers() {
        List<MemberNotification__e> noteEvents = new List<MemberNotification__e>();
        MemberNotification__e noteEvent = new MemberNotification__e(Type__c = 'Send');
        noteEvents.add(noteEvent);
        
        // Call method to publish events
        List<Database.SaveResult> results = EventBus.publish(noteEvents);        
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
    
    webservice static void sendNotificationTestButton(String notificationId, String emailAddress) {
        sendNotificationtest(notificationId, emailAddress);
    }
    
    public static void sendNotificationTest(String notificationId, String emailAddress) {
        
        list<Member_Notification__c> lstNotif = [select Id, Name, Custom_Message__c, Status__c, Template__c 
                                                 from Member_Notification__c where id = :notificationId];
        
        system.debug('lstNotif:' + lstNotif);
        
        if(!lstNotif.isEmpty()) {
                
            String templateName = lstNotif[0].Template__c;
            system.debug('templateName:' + templateName);
            
            List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Member_Notification__r.Custom_Message__c 
                                                             from Member_Notification_Recipient__c 
                                                             where Member_Notification__c = :notificationId AND Email__c = :emailAddress];            
            
            system.debug('lstRec:' + lstRec);
            
            Member_Notification_Recipient__c memrec;
            if(!lstRec.isEmpty()) {
                memrec = lstRec[0];
            } else {
                memrec = new Member_Notification_Recipient__c(
                    Name='TEST',
                    Email__c=emailAddress,
                    GARP_ID__c='123456',
                    Member_Notification__c = notificationId
                );
                insert memrec;
            }
            system.debug('memrec:' + memrec);
            
            sendSalesforceEmail(templateName, memrec.id, emailAddress);
            
        }
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
                lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Custom_Message__c, Notification_Exam_New_Address__c, Notification_Exam_Requirement__c,
                          Member_Notification__r.Custom_Message__c, Member_Notification__r.Exam_New_Address__c, Member_Notification__r.Exam_Requirement__c
                          from Member_Notification_Recipient__c 
                          where Member_Notification__c = :notificationId];
            } else {
                lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Custom_Message__c, Notification_Exam_New_Address__c, Notification_Exam_Requirement__c,
                          Member_Notification__r.Custom_Message__c, Member_Notification__r.Exam_New_Address__c, Member_Notification__r.Exam_Requirement__c
                          from Member_Notification_Recipient__c 
                          where Member_Notification__c = :notificationId AND Id = :recpientId];
                
            }
            system.debug('lstRec:' + lstRec);
            
            for(Member_Notification_Recipient__c rec :lstRec) {
                rec.Sending_Status__c = 'Pending';
                rec.Custom_Message__c = rec.Member_Notification__r.Custom_Message__c;
                rec.Notification_Exam_New_Address__c = rec.Member_Notification__r.Exam_New_Address__c;
                rec.Notification_Exam_Requirement__c = rec.Member_Notification__r.Exam_Requirement__c;
            }
            update lstRec;
            
            MemberNotificationSendBatch batch = new MemberNotificationSendBatch(notificationId, recpientId);
            Database.executebatch(batch,1);
        }
    }
    
    public static void sendNotification(String notificationId) {
        
        system.debug('sendNotification:' + notificationId);
        
        list<Member_Notification__c> lstNotif = [select Id, Name, Custom_Message__c, Status__c, Template__c
                                                 from Member_Notification__c where id = :notificationId and Status__c='Approved'];
        
        system.debug('lstNotif:' + lstNotif);
        
        if(!lstNotif.isEmpty()) {
            List<Member_Notification_Recipient__c> lstRec = [select Id, Name, Email__c, GARP_ID__c, Sending_Status__c, Member_Notification__r.Custom_Message__c,
                                                             Notification_Exam_New_Address__c, Notification_Exam_Requirement__c,
                                                             Member_Notification__r.Exam_New_Address__c, Member_Notification__r.Exam_Requirement__c
                                                             from Member_Notification_Recipient__c where Member_Notification__c = :notificationId];
            system.debug('lstRec:' + lstRec);
            
            for(Member_Notification_Recipient__c rec :lstRec) {
                rec.Sending_Status__c = 'Pending';
                rec.Custom_Message__c = rec.Member_Notification__r.Custom_Message__c;
                rec.Notification_Exam_New_Address__c = rec.Member_Notification__r.Exam_New_Address__c;
                rec.Notification_Exam_Requirement__c = rec.Member_Notification__r.Exam_Requirement__c;                
            }
            update lstRec;
            
            MemberNotificationSendBatch batch = new MemberNotificationSendBatch(notificationId,NULL);
            Database.executebatch(batch,1);
        }
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
            
            String msg;
            if(!resList.IsEmpty()) {
                msg = resList[0].getMergedBody();
                msg = msg.replace('MemberNotificationEmailTracker', 'XXX');
                system.debug('msg:' + msg);
            }
            
            if(lstRec[0].Member_Notification__r.Require_Portal_Login__c == true) {
                lstEmailTemplates = [SELECT Id, Body, Subject, HtmlValue  from EmailTemplate where Name = 'CustomerNotification - General'];    
            }

            //String ret = sendEmail(lstEmailTemplates[0].Id, lstCont[0].Id, lstOrgWide[0].Address, notificationRecipientId, orgWideId);            
            //if(ret == NULL) {
                //lstRec[0].Sending_Status__c =  'Sent';
                //lstRec[0].Sent_Date_Time__c =  DateTime.now();
                lstRec[0].Sent_Message__c = msg;
                lstRec[0].Send_Email__c = True;
                //lstRec[0].Number_Of_Sends__c = lstRec[0].Number_Of_Sends__c + 1;
            //} else {
                lstRec[0].Sending_Status__c =  'Error';
            //}
            lstRec[0].Contact__c = lstCont[0].Id;
            update lstRec;
        }
    }
    
    /*
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
    */
    
     @InvocableMethod(label='MemberNotificationClass' description='Call MemberNotificationClass Methods.')
    public static void MemberNotificationInvocable(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
        String method;
        String param1;
        String param2;
        String param3;
        String param4;
        String param5;
        List<String> ids = inputParams[0];
        
        if(!ids.isEmpty()){
            Integer cnt=0;
            for(String idVal :ids) {
                if(cnt==0)
                    method = idVal;
                else if(cnt==1)
                    param1 = idVal;
                else if(cnt==2)
                    param2 = idVal;
                else if(cnt==3)
                    param3 = idVal;
                else if(cnt==4)
                    param4 = idVal;
                else if(cnt==5)
                    param5 = idVal;
                cnt++;
            }
            System.debug('method:' + method);
            System.debug('param1:' + param1);
            System.debug('param2:' + param2);
            System.debug('param3:' + param3);
            System.debug('param4:' + param4);
            System.debug('param5:' + param5);
            
            if(method == 'sendNotificationTest') {
                sendNotificationTest(param1, param2);
            } else if(method == 'updateSendingStatus') {
                updateSendingStatus(param1);
            }
        }
   
    }
}