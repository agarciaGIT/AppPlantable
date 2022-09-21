@RestResource(urlMapping='/cases/*')
global class RESTCasesController {
    
    public class respCasesCommentItem {
        String body;
        DateTime created_date;
        String created_by;
    }

    public class respCasesEmailItem {
     	String subject;
        String body;
        DateTime created_date;
        String fromAddress;
        String toAddress;
    }
    
    public class respCases {
        Integer status_code;
        String status_message;
        String customer_id;
		String customer_email;
		String subject;
		String body;
		String case_status;
		DateTime last_contact_date;
        List<respCasesCommentItem> comments;
        List<respCasesEmailItem> emails;
    }
    
	public class reqCases {
     	String subject;
        String body;
        String email_address;
    }    
    
    public class respAddCases {
        Integer status_code;
        String status_message;
        String case_number;
    }
    
    public class reqUpdateCases {
     	String case_status;
        respCasesCommentItem comment;
        respCasesEmailItem email;
    }    

    public class respUpdateCases {
        Integer status_code;
        String status_message;
    }
    
    public static respCases processGETRequest(RestRequest req) {
        respCases rc = new respCases();
        rc.status_code = 404;
        
        String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(id != null) {
            List<Case> lstCases = [select Id, CaseNumber, Status, Subject, Description, Last_Email_Date_Sent__c, ContactId, ContactEmail from Case where CaseNumber = :id];
            if(lstCases != NULL && lstCases.size() > 0) {
                rc.status_code = 0;
                
                rc.case_status = lstCases[0].Status;
                rc.customer_id = lstCases[0].ContactId;
                rc.customer_email = lstCases[0].ContactEmail;
                rc.subject = lstCases[0].Subject;
                rc.body = lstCases[0].Description;
                rc.last_contact_date = lstCases[0].Last_Email_Date_Sent__c;
                
				List<respCasesCommentItem> comments = new List<respCasesCommentItem>();
                List<CaseComment> lstCaseComm = [select Id, CommentBody, CreatedDate, CreatedById from CaseComment where ParentId = :lstCases[0].id];
                if(lstCaseComm != NULL && lstCaseComm.size() > 0) {
                    for(CaseComment cc :lstCaseComm) {
                        respCasesCommentItem rcci = new respCasesCommentItem();
                        rcci.body = cc.CommentBody;
                        rcci.created_date = cc.CreatedDate;
                        rcci.created_by = cc.CreatedById;
						comments.add(rcci);
                    }
                }
                rc.comments = comments;
                
                List<respCasesEmailItem> emails = new List<respCasesEmailItem>();
                List<EmailMessage> lstEmails = [select Id, Subject, TextBody, FromAddress, ToAddress, MessageDate from EmailMessage where ParentId = :lstCases[0].id];
                if(lstCases != NULL && lstCases.size() > 0) {
                    for(EmailMessage em :lstEmails) {
                        respCasesEmailItem rcei = new respCasesEmailItem();
						rcei.subject = em.Subject;
                        rcei.body = em.TextBody;
                        rcei.created_date = em.MessageDate;
                        rcei.fromAddress = em.FromAddress;
                        rcei.toAddress = em.ToAddress;
                        emails.add(rcei);
                    }
                }
                rc.emails = emails;
            }
        }
        return rc;
    }
    
    public static respAddCases processPOSTRequest(RestRequest req) {
        respAddCases rac = new respAddCases();
        rac.status_code = 500;
        rac.status_message = '';
        
        String rawJson = req.requestBody.toString();
        reqCases rec = (reqCases)JSON.deserialize(rawJson, reqCases.class);
        if(rec.subject != NULL && rec.body != NULL && rec.email_address != NULL) {
            
            List<Contact> lstContact = [select Id, AccountId from Contact where email = :rec.email_address];
            Case newCase;
            if(lstContact != NULL && lstContact.size() > 0) {
                newCase = new Case(Subject=rec.subject , Description=rec.body, SuppliedEmail=rec.email_address, ContactId=lstContact[0].Id, AccountId=lstContact[0].AccountId);
                insert newCase;
                newCase = [select id, casenumber from Case where id = : newCase.id];
            } else {
                newCase = new Case(Subject=rec.subject , Description=rec.body, SuppliedEmail=rec.email_address);
                insert newCase;
                newCase = [select id, casenumber from Case where id = : newCase.id];
            }
            rac.case_number = newCase.casenumber;
            rac.status_code = 0;
            
        } else {
            rac.status_message = 'Required fields missing.';
        }
        return rac;
    }
    
    public static respUpdateCases processPUTRequest(RestRequest req) {
        respUpdateCases ruc = new respUpdateCases();
        ruc.status_code = 404;
        
        String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(id != null) {
            List<Case> lstCases = [select Id, CaseNumber, Status, Subject, Description, Last_Email_Date_Sent__c, ContactId, ContactEmail from Case where CaseNumber = :id];
            if(lstCases != NULL && lstCases.size() > 0) {
                ruc.status_code = 0;
                String rawJson = req.requestBody.toString();
                reqUpdateCases requc = (reqUpdateCases)JSON.deserialize(rawJson, reqUpdateCases.class);
                Boolean updateDone=false;
                if(requc.case_status != NULL) {
                    lstCases[0].Status = requc.case_status;
                    update lstCases;
                }
                if(requc.comment != NULL && requc.comment.body != NULL) {
                    CaseComment cc = new CaseComment(CommentBody=requc.comment.body, ParentId=lstCases[0].id);
                    insert cc;
                }
                if(requc.email != NULL && requc.email.subject != NULL && requc.email.body != NULL && requc.email.fromAddress != NULL && requc.email.toAddress != NULL) {
                    EmailMessage em = new EmailMessage(Subject=requc.email.subject, TextBody=requc.email.body, FromAddress=requc.email.fromAddress, ToAddress=requc.email.toAddress, ParentId=lstCases[0].id);
                    insert em;
                }
            }
        }
        return ruc;
    }
    
    @HttpPut
    global static void updateCases() {
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
		String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
            
			respUpdateCases ruc = processPUTRequest(req);
            String jsonBody = JSON.serialize(ruc); 
            if(ruc.status_code != 0) {
                 res.statusCode = ruc.status_code;
            } else {
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(jsonBody);
	            res.statusCode = 200;            
            }            
            
        } else {
            res.statusCode = 401;
        }        
        
    }
    
    @HttpPost
    global static void setCases() {
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
		String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
			respAddCases rac = processPOSTRequest(req);
            String jsonBody = JSON.serialize(rac); 
            if(rac.status_code != 0) {
                 res.statusCode = rac.status_code;
            } else {
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(jsonBody);
	            res.statusCode = 200;            
            }
        } else {
            res.statusCode = 401;
        }
    }
    
    @HttpGet  
    global static Void getCases() {      

        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
		String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
            respCases rc = processGETRequest(req);
            String jsonBody = JSON.serialize(rc); 
            if(rc.status_code != 0) {
                 res.statusCode = rc.status_code;
            } else {
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(jsonBody);
	            res.statusCode = 200;            
            }
        } else {
            res.statusCode = 401;
        }
    }        


}