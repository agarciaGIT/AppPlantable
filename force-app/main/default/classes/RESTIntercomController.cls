@RestResource(urlMapping='/intercom/*')
global class RESTIntercomController {
    
    public class replyMessageDataItemUser {
        String type;
        String id;
        String name;
        string email;
    }
    
    public class replyMessageDataItemConvMsgParts {
        String type;
        String body;
        String subject;
    }
    
    public class replyMessageDataItemConvMsg {
        String type;
        List<replyMessageDataItemConvMsgParts> conversation_parts;
    }

    public class replyMessageDataItemConv {
        String type;
        String id;
    }
    
    public class replyMessageDataItem {
        String type;
        String id;
        replyMessageDataItemUser user;
        replyMessageDataItemConvMsg conversation_parts;
        replyMessageDataItemConv conversation_message;
    }
    
    public class replyMessageData {
        replyMessageDataItem item;
    }
    
    public class replyMessage {
        String id;
        String topic;
        replyMessageData data;
    }

    public class newMessageDataItem {
        String type;
        String id;
        replyMessageDataItemUser user;
        replyMessageDataItemConvMsgParts conversation_message;
    }
    
    public class newMessageData {
        newMessageDataItem item;
    }
    
    public class newMessage {
        String id;
        String topic;
        newMessageData data;
    }
    
    public static RestResponse processPOSTRequest(RestRequest req, RestResponse res, String reqJson) {
        
        res.statusCode = 200;
        
        //String reqJson = req.requestBody.toString();
        System.debug('reqJson:' + reqJson);
        
        replyMessage rm = (replyMessage)JSON.deserialize(reqJson, replyMessage.class);
        System.debug('rm:' + rm);
        
        String subject;
        String msg;
        String email;
        String convId;
        String convMsgId;
        String msgType;
        
        
        // if new Admin Conversation
        if(rm.topic != NULL && rm.topic == 'conversation.admin.single.created') {            
            newMessage nm = (newMessage)JSON.deserialize(reqJson, newMessage.class);
            
            if(nm.data != NULL && nm.data.item != NULL &&
               nm.data.item.conversation_message != NULL &&
               nm.data.item.user != NULL
              ) {
                  subject = nm.data.item.conversation_message.subject;
                  msg = nm.data.item.conversation_message.body;
                  email = nm.data.item.user.email;
                  convId = nm.data.item.id;
                  msgType = 'Admin Start Conversation';
              } 
        }
        
        // If new Customer Conversation
        if(rm.topic != NULL && rm.topic == 'conversation.user.created') {
            newMessage nm = (newMessage)JSON.deserialize(reqJson, newMessage.class);
            if(nm.data != NULL && nm.data.item != NULL &&
               nm.data.item.conversation_message != NULL && nm.data.item.conversation_message != NULL &&
               nm.data.item.user != NULL
              ) {
                  subject = nm.data.item.conversation_message.subject;
                  msg = nm.data.item.conversation_message.body;
                  email = nm.data.item.user.email;
                  convId = nm.data.item.id;
                  msgType = 'Customer Reply';
              } 
        }
        
        // Is Conversation Reply
        if(rm.topic != NULL && (rm.topic == 'conversation.user.replied' || rm.topic == 'conversation.admin.replied') && 
           rm.data != NULL && rm.data.item != NULL && 
           rm.data.item.conversation_parts != NULL && rm.data.item.conversation_parts.conversation_parts != NULL &&
           rm.data.item.user != NULL
          ) {
              subject = rm.data.item.conversation_parts.conversation_parts[0].subject;
              msg = rm.data.item.conversation_parts.conversation_parts[0].body;
              email = rm.data.item.user.email;
              convId = rm.data.item.id;
              convMsgId = rm.data.item.conversation_message.id;
              msgType = (rm.topic == 'conversation.user.replied' || rm.topic == 'conversation.user.created') ? 'Customer Reply' : 'Admin Reply';
        }
        
        System.debug('subject:' + subject);
        System.debug('msg:' + msg);
        System.debug('email:' + email);
        System.debug('convId:' + convId);
        System.debug('msgType:' + msgType);
        
        
        System.debug('convMsgId:' + convMsgId);
        
        if(msg != NULL && email != NULL && convId != NULL) {
        
            Integer startImg = msg.indexOf('img src=\"');
            System.Debug('startImg:' + startImg);
            if(startImg > -1) {
                msg = msg.substring(startImg+9, msg.length());
                System.Debug('msg:' + msg);
                Integer endImg = msg.indexOf('\">');
                msg = msg.substring(0, endImg);
                System.Debug('msg:' + msg);
            } else {
                msg= msg.replaceAll('\\<.*?\\>', '');
                System.Debug('msg:' + msg);
            }
        
        
            In_App_Message__c newMsg = new In_App_Message__c(
                Name = rm.id,
                Type__c = msgType,
                Message__c = msg
            );
            
            List<Contact> lstCont = [select Id from Contact where email = :email];
            if(lstCont != NULL && lstCont.size() > 0) {
                newMsg.Contact__c = lstCont[0].Id;
                
                // If Admin Start Conv
                if(rm.topic == 'conversation.admin.single.created') {
                    newMsg.Case__c = IntercomClass.IntercomAdminStart(lstCont[0].Id, email, newMsg.Message__c, convId, subject);
                }
                
                // If Admin Reply send SMS to customer it needed
                if(rm.topic == 'conversation.admin.replied') {
                    newMsg.Case__c = IntercomClass.IntercomAdminMsg(lstCont[0].Id, email, newMsg.Message__c, convId, subject);
                }
                
                // If Customer Reply 
                if(rm.topic == 'conversation.user.replied' || rm.topic == 'conversation.user.created') {
                    // Check profile for health survey and update cases
                    newMsg.Case__c = IntercomClass.IntercomCustomerMsg(lstCont[0].Id, email, newMsg.Message__c, convId, convMsgId);                       
                }
            }
            insert newMsg;
        }
        
        // Conversation Closed
        if(rm.topic != NULL && rm.topic == 'conversation.admin.closed' &&
           rm.data != NULL && rm.data.item != NULL && rm.data.item.id != NULL && rm.data.item.user != NULL) {
               
               IntercomClass.IntercomConversationClosed(rm.data.item.user.id, rm.data.item.id);
               
        }
        
        if(rm.topic != NULL && rm.topic == 'user.created') {
            IntercomClass.IntercomUpdateUserActivity('');
        }        
        
        API_Request__c apiReq = new API_Request__c(Request_Type__c='Intercom Inbound',Raw_Request__c=reqJson,Response__c=String.valueOf(res.responseBody));
        insert apiReq;
        
        return res;
    }
    
    @HttpPost  
    global static void postIntercom() {      

        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String reqJson = req.requestBody.toString();
        
        res = processPOSTRequest(req, res, reqJson);
    }
}