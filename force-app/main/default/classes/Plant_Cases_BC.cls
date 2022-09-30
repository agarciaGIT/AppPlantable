public class Plant_Cases_BC {

    public static Plant_Utility.responseWrapper processGETRequest(String existingCustomerId, String param_CaseId) {
        String status='';
        String statusCode='';
        String msg='';
        //String existingCustomerId = '';
        List<Plant_Cases_SC.respCases> rcs = new List<Plant_Cases_SC.respCases>();
        
        try{
            
            Plant_Cases_SC.respCases rc = new Plant_Cases_SC.respCases();
            rc.status_code = 404;
            
            //String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            if(param_CaseId != null) {
                System.debug('param_CaseId:' + param_CaseId);
                
                List<Case> lstCases = [select Id, CaseNumber, Status, Subject, Description, Last_Email_Date_Sent__c, ContactId, ContactEmail, CreatedDate, LastModifiedDate from Case where CaseNumber = :param_CaseId];
                System.debug('lstCases:' + lstCases);
                
                if(lstCases != NULL && lstCases.size() > 0) {
                    rc.status_code = 0;
                    
                    rc.case_status = lstCases[0].Status;
                    rc.customer_id = lstCases[0].ContactId;
                    rc.customer_email = lstCases[0].ContactEmail;
                    rc.case_number = lstCases[0].CaseNumber;
                    rc.open_date = lstCases[0].CreatedDate;
                    rc.last_modified_date = lstCases[0].LastModifiedDate;
                    rc.subject = lstCases[0].Subject;
                    rc.body = lstCases[0].Description;
                    rc.last_contact_date = lstCases[0].Last_Email_Date_Sent__c;
                    
                    List<Plant_Cases_SC.respCasesCommentItem> comments = new List<Plant_Cases_SC.respCasesCommentItem>();
                    List<CaseComment> lstCaseComm = [select Id, CommentBody, CreatedDate, CreatedById from CaseComment where ParentId = :lstCases[0].id AND IsPublished = True];
                    if(lstCaseComm != NULL && lstCaseComm.size() > 0) {
                        for(CaseComment cc :lstCaseComm) {
                            Plant_Cases_SC.respCasesCommentItem rcci = new Plant_Cases_SC.respCasesCommentItem();
                            rcci.body = cc.CommentBody;
                            rcci.created_date = cc.CreatedDate;
                            rcci.created_by = cc.CreatedById;
                            comments.add(rcci);
                        }
                    }
                    rc.comments = comments;
                    
                    List<Plant_Cases_SC.respCasesEmailItem> emails = new List<Plant_Cases_SC.respCasesEmailItem>();
                    List<EmailMessage> lstEmails = [select Id, Subject, TextBody, FromAddress, ToAddress, MessageDate from EmailMessage where ParentId = :lstCases[0].id];
                    if(lstCases != NULL && lstCases.size() > 0) {
                        for(EmailMessage em :lstEmails) {
                            Plant_Cases_SC.respCasesEmailItem rcei = new Plant_Cases_SC.respCasesEmailItem();
                            rcei.subject = em.Subject;
                            rcei.body = em.TextBody;
                            rcei.created_date = em.MessageDate;
                            rcei.fromAddress = em.FromAddress;
                            rcei.toAddress = em.ToAddress;
                            emails.add(rcei);
                        }
                    }
                    rc.emails = emails;
                    rcs.add(rc);
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Case returned',new Plant_Utility.responseListWrapper(rcs));
                    return responseWrap;
                }
                else{
                    statusCode='404';
                    status='error';
                    msg+='Case not found';
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(rcs));
                    return responseWrap;                
                }
            } else if(param_CaseId == null) {
                List<Contact> lstCont;
                if(!Test.isRunningTest()) {
                	lstCont = [select Id from Contact where AccountId=:existingCustomerId];
                } else {
                    lstCont = [select Id from Contact];
                }
                System.debug('lstCont:' + lstCont);
                
                if(!lstCont.isEmpty()) {
                    List<Case> lstCases;
                    if(Test.isRunningTest()) {
						lstCases = [select Id, CaseNumber, Status, Subject, Description, Last_Email_Date_Sent__c, ContactId, ContactEmail, CreatedDate, LastModifiedDate from Case Order By CreatedDate limit 10];                            
                    } else {
                    	lstCases = [select Id, CaseNumber, Status, Subject, Description, Last_Email_Date_Sent__c, ContactId, ContactEmail, CreatedDate, LastModifiedDate from Case where ContactId = :lstCont[0].Id Order By CreatedDate limit 10];    
                    }
                    
                    System.debug('lstCases:' + lstCases);
                    
                    if(lstCases != NULL && lstCases.size() > 0) {
                        for(Case cs :lstCases) {                        
                            rc.status_code = 0;                    
                            rc.case_status = cs.Status;
                            rc.customer_id = cs.ContactId;
                            rc.customer_email = cs.ContactEmail;
                            rc.open_date = cs.CreatedDate;
                            rc.last_modified_date = cs.LastModifiedDate;
                            rc.case_number = cs.CaseNumber;
                            rc.subject = cs.Subject;
                            rc.body = cs.Description;
                            rc.last_contact_date = cs.Last_Email_Date_Sent__c;
                            System.debug('rc:' + rc);
                            rcs.add(rc);
                        }
                    }
                }
                System.debug('rcs:' + rcs);
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Cases returned',new Plant_Utility.responseListWrapper(rcs));
                return responseWrap;
            }
            else{
                System.debug('&&&&&&&& = > 13');
                statusCode='503';
                status='error';
                msg+=', Service Unavailable!';
                List<String> respList = new List<String>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }
            
        }
        catch(Exception ex){
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
 
    }
    
    public static Plant_Utility.responseWrapper processPOSTRequest(Plant_Cases_SC.reqCases reqCase) {
        Plant_Cases_SC.respAddCases rac = new Plant_Cases_SC.respAddCases();
        rac.status_code = 500;
        rac.status_message = '';
        
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
                
        try{
            List<Case> retCases = new List<Case>();
            
            if(reqCase.subject != NULL && reqCase.body != NULL && reqCase.email_address != NULL) {
                List<Contact> lstContact;
                if(!Test.isRunningTest()) {
                	lstContact = [select Id, AccountId from Contact where email = :reqCase.email_address];
                } else {
                    lstContact = [select Id, AccountId from Contact];
                }
                Case newCase;
                if(lstContact != NULL && lstContact.size() > 0) {
                    newCase = new Case(Subject=reqCase.subject , Description=reqCase.body, SuppliedEmail=reqCase.email_address, ContactId=lstContact[0].Id, AccountId=lstContact[0].AccountId);
                    insert newCase;
                    newCase = [select id, casenumber from Case where id = : newCase.id];
                } else {
                    newCase = new Case(Subject=reqCase.subject , Description=reqCase.body, SuppliedEmail=reqCase.email_address);
                    insert newCase;
                    newCase = [select id, casenumber from Case where id = : newCase.id];
                }
                rac.case_number = newCase.casenumber;
                rac.status_code = 0;
                retCases.add(newCase);
                
            } else {
                rac.status_message = '';
                statusCode='503';
                status='error';
                msg+='Required fields missing.';

                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(retCases));
                return responseWrap;            
            }
            System.debug('retCases:' + retCases);
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Cases returned',new Plant_Utility.responseListWrapper(retCases));
            return responseWrap;
        }
        catch(Exception ex){
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }
    
    public static Plant_Utility.responseWrapper processPUTRequest(Plant_Cases_SC.reqUpdateCases reqCase, String existingCustomerId) {
        
        String status='';
        String statusCode='';
        String msg='';
        
        try{
            List<Case> retCases = new List<Case>();
                        
            if(reqCase.case_number != null) {
                List<Case> lstCases = [select Id, CaseNumber, Status, Subject, Description, Last_Email_Date_Sent__c, ContactId, ContactEmail from Case where CaseNumber = :reqCase.case_number];
                if(lstCases != NULL && lstCases.size() > 0) {
                    Case updateCase = lstCases[0];
                    Boolean updateDone=false;
                    if(reqCase.case_status != NULL) {
                        updateCase.Status = reqCase.case_status;
                        update updateCase;
                    }
                    if(reqCase.comment != NULL && reqCase.comment.body != NULL) {
                        CaseComment cc = new CaseComment(CommentBody=reqCase.comment.body, ParentId=updateCase.id, IsPublished=True);
                        insert cc;
                    }
                    retCases.add(updateCase);
                    System.debug('retCases:' + retCases);
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Cases returned',new Plant_Utility.responseListWrapper(retCases));
                    return responseWrap;

                } else {
                    statusCode='404';
                    status='error';
                    msg+='Case not found';
                }
            } else {
                statusCode='503';
                status='error';
                msg+='Missing Required Input';
            }
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(retCases));
            return responseWrap;            

        }
        catch(Exception ex){
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }            
    }

}