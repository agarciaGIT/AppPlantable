/*
*   @Desciption     :   Plantable customer authorization controller
*   @Create date    :   19-06-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class plant_AuthorizeController {
    
    //Constructor: default
    public plant_AuthorizeController() {

    }


    // METHOD: 1 (acces via REST)
    // @desc: get access token
    public plant_Utility.responseWrapper generateAccessToken(accessTokenReqWrap reqst){
        String status='';
        String statusCode='';
        String msg='';
        List<userAuth_ResponseWrap> authResp_List = new List<userAuth_ResponseWrap>();
        try {
            if(String.isBlank(reqst.email) || String.isBlank(reqst.email)){
                status = 'error';
                statusCode='503';
                msg='Service Unavailable';
            }
            
            String emailLowerCase = reqst.email.toLowerCase();
            List<Account> customer_RecdList = [SELECT Id, Plant_temp_authorization_token_Expire__c, Email__c, plant_UserPasswaord__c, plant_Authentication_Token__c, plant_TokenLife__c FROM Account WHERE Email__c=:emailLowerCase];
            if(!customer_RecdList.isEmpty()){
                // if Multiple Account of same email
                if(customer_RecdList.size()>1){
                    status = 'error';
                    statusCode='501';
                    msg='Internal server error: Please contact Support';
                }
                else if(customer_RecdList.size()==0){
                    status = 'error';
                    statusCode='501';
                    msg='Internal server error: No Customer Record Found';
                }else{

                    String userPaswd = customer_RecdList[0].plant_UserPasswaord__c;
                    // validation: check password
                    if(userPaswd.equals(reqst.password)){

                        // GET new TOKEN
                        String tempToken = Plant_Utility.generateRendom(64);
                        System.debug('@@@ A New  Token => '+tempToken);

                        // Update Custome Info record(Account)
                        Account acct = new Account();
                        acct.Id = customer_RecdList[0].Id;
                        acct.plant_Authentication_Token__c = tempToken;
                        acct.plant_TokenCreatedDateTime__c = System.now();
                        acct.Plant_temp_authorization_token_Expire__c=false;
                        update acct;
                        
                        authResp_List.add(new userAuth_ResponseWrap(tempToken));
                        status = 'Success';
                        statusCode='200';
                        msg= 'New Authentication Token Generated';
                    }
                    else{
                        // RETURN WRONG PASSWORD
                        status = 'error';
                        statusCode='401';
                        msg='Unauthorized: Incorrect password';
                    }
                }
            }
            else{
                // RETURN WRONG PASSWORD
                status = 'error';
                statusCode='401';
                msg='Unauthorized: No Customer record found wiht this email';
            }    
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ get token EXCEPTION ENCOUNTERD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }

        // FinResponse: generate token 
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(authResp_List));
        return responseWrap;
    }


    // METHOD:2 (acces via REST)
    // @desc: get authorize/refresh token
    public Plant_Utility.responseWrapper getAuthenticationToken(userInfoReqWrap reqst){
        String status='';
        String statusCode='';
        String msg='';
        List<userAuth_ResponseWrap> authResp_List = new List<userAuth_ResponseWrap>();

        try {
            if(String.isBlank(reqst.email) || String.isBlank(reqst.email) || reqst.refreshReq==null){
                status = 'error';
                statusCode='503';
                msg='Service Unavailable';
            }
            else{
                String emailLowerCase = reqst.email.toLowerCase();
                List<Account> customer_RecdList = [SELECT Id, Email__c, plant_UserPasswaord__c, plant_Authentication_Token__c, plant_TokenLife__c FROM Account WHERE Email__c=:emailLowerCase];
                if(!customer_RecdList.isEmpty()){
                    // if Multiple Account of same email
                    if(customer_RecdList.size()>1){
                        status = 'error';
                        statusCode='501';
                        msg='Internal server error: Please contact Support';
                    }
                    
                    // Validation1: Password check
                    if(!String.isBlank(customer_RecdList[0].plant_UserPasswaord__c) && customer_RecdList[0].plant_UserPasswaord__c.equals(reqst.password)){

                        //Authentication token
                        System.debug('#### Auh => '+customer_RecdList[0].plant_Authentication_Token__c);
                        System.debug('#### reqst.refreshReq => '+reqst.refreshReq);

                        System.debug('@@@ token valid --> ');
                        if(reqst.refreshReq){

                            // GENERATE REFRESH TOKEN
                            String tempToken = Plant_Utility.generateRendom(64);
                            System.debug('@@@ New  Token => '+tempToken);

                            // Update Custome Info record(Account)
                            Account acct = new Account();
                            acct.Id = customer_RecdList[0].Id;
                            acct.plant_Authentication_Token__c = tempToken;
                            acct.plant_TokenCreatedDateTime__c = System.now();
                            acct.Plant_temp_authorization_token_Expire__c=false;
                            update acct;

                            authResp_List.add(new userAuth_ResponseWrap(tempToken));
                            status = 'Success';
                            statusCode='200';
                            msg= reqst.refreshReq==true?'New Authentication Token Received': 'Authentication Token Received';
                        }
                        else{
                            // GET OLD TOKEN
                            if(!String.isBlank(customer_RecdList[0].plant_Authentication_Token__c)){
                                // Validation: check token life plant_TokenLife
                                if(customer_RecdList[0].plant_TokenLife__c!=null || Integer.valueOf(customer_RecdList[0].plant_TokenLife__c)<24){
                                    String tempAuth = customer_RecdList[0].plant_Authentication_Token__c;
                                    System.debug('@@@ auth 1 => '+tempAuth);
                                    authResp_List.add(new userAuth_ResponseWrap(tempAuth));   
                                    status = 'Success';
                                    statusCode='200';
                                    msg='Authentication Token Received'; 
                                }
                                else {
    
                                    System.debug('@@@ token Expire --> ');
                                    status = 'error';
                                    statusCode='401';
                                    msg='Token Expired';
                                }                           
                            }
                        }                        
                        
                    }
                    else{
                        // RETURN WRONG PASSWORD
                        status = 'error';
                        statusCode='401';
                        msg='Unauthorized: Wrong cred';
                    }
                    
                }
                else {
                    status = 'error';
                    statusCode='401';
                    msg='Unauthorized';
                }
            }

        }catch(Exception ex){
            System.debug('@@@@@@@@@ Authorization EXCEPTION ENCOUNTERD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }

        // Final Result
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(authResp_List));
        return responseWrap;
    }

    // METHOD: 3 (internal user only)
    // @desc:   validate Access Token by cartId OR AccountId 
    public Static String validateAccessToken(String cartId, String acctId, String inputToken){
        if(acctId!=''){
            List<Account> accRecd_List = [SELECT id,plant_Authentication_Token__c,plant_TokenLife__c FROM Account where id=:acctId LIMIT 1];
            System.debug('@@@@ accRecd_List : '+accRecd_List);
            if(accRecd_List.isEmpty()){
                return 'Account does not exist';
            }
            else if(accRecd_List[0].plant_Authentication_Token__c!=''){
                String tempTOken = accRecd_List[0].plant_Authentication_Token__c;
                if(accRecd_List[0].plant_TokenLife__c!=null || Integer.valueOf(accRecd_List[0].plant_TokenLife__c)<24){
                    if(tempTOken==inputToken)
                        return 'Success,'+accRecd_List[0].Id;
                    else 
                        return 'Authentication Token Unidentified';
                }
                else 
                    return 'Token Expired';
                
            }
            else {
                return 'Authentication Token Missing';
            }
        }
        else{
            system.debug('@@@@ cartId: '+cartId);
            List<Plant_Order_Properties__c> order_Prop_RecdList = [SELECT id,Plant_Account__c, Plant_Account__r.plant_Authentication_Token__c,Plant_Account__r.plant_TokenLife__c FROM Plant_Order_Properties__c where id=:cartId AND Plant_Account__c!=null LIMIT 1];
            if(order_Prop_RecdList.isEmpty()){
                return 'cartId does not exist';
            }
            else if(order_Prop_RecdList[0].Plant_Account__r.plant_Authentication_Token__c!=''){
                
                String tempTOken = order_Prop_RecdList[0].Plant_Account__r.plant_Authentication_Token__c;
                System.debug('@@@@ test 1 '+tempTOken);
                System.debug('@@@@ test 2 '+order_Prop_RecdList[0].Plant_Account__r.plant_TokenLife__c);
                System.debug('@@@@ test 3 '+inputToken);
                if(order_Prop_RecdList[0].Plant_Account__r.plant_TokenLife__c!=null && order_Prop_RecdList[0].Plant_Account__r.plant_TokenLife__c!='' && Integer.valueOf(order_Prop_RecdList[0].Plant_Account__r.plant_TokenLife__c)<24){
                    if(tempTOken==inputToken)
                        return 'Success,'+order_Prop_RecdList[0].Plant_Account__c;
                    else 
                        return 'Authentication Token Unidentified';
                }
                else 
                    return 'Token Expired';
                
            }
            else {
                return 'Authentication Token Missing';
            }
        }
        
    }

    // METHOD: 3.1  (internal user only)
    // @desc:   validate Access Token and return accountId
    public Static String validate_ByAccessToken(String inputToken){
        List<Account> accRecd_List = [SELECT id,plant_Authentication_Token__c,plant_TokenLife__c FROM Account where plant_Authentication_Token__c=:inputToken LIMIT 1];
        if(!accRecd_List.isEmpty()){
            String tempToken = accRecd_List[0].plant_Authentication_Token__c;
            if(accRecd_List[0].plant_TokenLife__c!=null && Integer.valueOf(accRecd_List[0].plant_TokenLife__c)<24){
                return 'Success,'+accRecd_List[0].Id;
            }
            else 
                return 'Token Expired';
        }
        else{
            return 'Account does not exist';
        }        
    }

    // METHOD: 4 (acces via REST)
    // @desc: change Password of an Account
    public plant_Utility.responseWrapper changePassword(changePassword_wrap reqst){
        String status='';
        String statusCode='';
        String msg='';
        List<Account> acc=new List<Account>();
        try {
            if(reqst!=null && !String.isBlank(reqst.email) && !String.isBlank(reqst.temporaryPassword) && !String.isBlank(reqst.newPassword))
            {   
                String emailLower=reqst.email;
                emailLower=emailLower.toLowerCase();
                acc=[Select id, name, Plant_Temporary_Password_Deadline__c, Plant_Change_Password__c,
                plant_UserPasswaord__c, Email__c from Account where Email__c=:emailLower limit 1];
                if(!acc.isEmpty() && acc[0].plant_UserPasswaord__c==reqst.temporaryPassword){
                    if(acc[0].Plant_Temporary_Password_Deadline__c==false || acc[0].Plant_Change_Password__c==true){
                        acc[0].Plant_Change_Password__c=true;
                        acc[0].plant_UserPasswaord__c=reqst.newPassword;
                        acc[0].Plant_Send_Reset_Password__c = false;
                        update acc;
                        status='Success';
                        statusCode='200';
                        msg+='Password is updated Sucessfully';
                    }
                    else{
                        status='Error';
                        statusCode='503';
                        msg+='You can not update Password, Temporary Password is expired';
                    }
                }
                else{
                    status='Error';
                    statusCode='503';
                    msg+='either email Id or Password is Wrong!';
                }
            }
            else{
                status='Error';
                statusCode='503';
                msg+='Incorrect Request Body';
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ get token EXCEPTION ENCOUNTERD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }

        // FinResponse: generate token 
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

    // METHOD: 5 (acces via REST)
    // @desc: To Temporary Expire the Authorization Token
    public plant_Utility.responseWrapper expireAuthorizationToken(ExpireToken_wrap reqst){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId='';
        List<Account> acc=new List<Account>();
        try {
            if(reqst!=null && !String.isBlank(reqst.email) && !String.isBlank(reqst.AuthorizationToken)){
                if(!String.isBlank(reqst.AuthorizationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(reqst.AuthorizationToken);
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Account : '+accAuthResut;
                    }
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Invalid Authentication Token';
                }
                if(existingCustomerId!=null){
                    acc=[Select id, Plant_temp_authorization_token_Expire__c, email__c from Account where email__c=:reqst.email.toLowerCase() AND id=:existingCustomerId Limit 1];
                    acc[0].Plant_temp_authorization_token_Expire__c=true;
                    database.update(acc, false);
                    statusCode='200';
                    status='Success';
                    msg+=', Authorization token for this Account is Expired';
                }
                
            }
            else{
                status = 'error';
            statusCode='500';
            msg='Incorrect Request body ';
            }
            
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ get token EXCEPTION ENCOUNTERD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;
        }

        // FinResponse: generate token 
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

    // METHOD: 6 (Login via HIC dev "sessionId")
    // @desc: authorize via HIC Dev user for chargent transaction records
    public /*plant_Utility.responseWrapper*/ static void systemAdminSession(String uEndpoint, String methodType,String JsonBody){
        System.debug('@@@ system admin session method started');
        String finnalEndpoint = System.URL.getSalesforceBaseUrl().toExternalForm()+uEndpoint+'?Action=SystemAdmin_Session';

        plantable_Constants__c constants = plantable_Constants__c.getValues('DevConstant');
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod(methodType);
        req.setEndpoint(finnalEndpoint);
        req.setBody(JsonBody);
        req.setHeader('Content-Type','application/json');
        req.setHeader('Authorization', 'Bearer '+constants.plant_UserSession__c);
        //req.addParameter('Action','SystemAdmin_Session');
        HttpResponse response =  http.send(req);
        System.debug('@@@ callout done => '+response);
    }

    // METHOD: 7 (acces via REST)
    // @desc: To generate Temporary Password at the time of Forget Password.
    public plant_Utility.responseWrapper forgotPasswordRequest(String emailId){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId='';
        List<tempPasswordResponse> tempPassword_List=new List<tempPasswordResponse>();
        try {
            if(!String.isBlank(emailId)){
                List<Account> accList = [Select id, Plant_Temporary_Password_Deadline__c, 
                Plant_Send_Reset_Password__c, Plant_Change_Password__c, plant_UserPasswaord__c from Account where Email__c=:emailId Limit 1];
                if(!accList.isEmpty()){
                    tempPasswordResponse tempPaswrd_Resp = new tempPasswordResponse();
                    // create a temp 8 digit password
                    String tempPass = Plant_Utility.rendomPassword(8);
                    if(!String.isBlank(tempPass)){
                        Account acc = new Account();
                        acc.id = accList[0].id;
                        acc.plant_UserPasswaord__c = tempPass;
                        acc.Plant_Change_Password__c = true;
                        acc.Plant_Send_Reset_Password__c = true;
                        update acc;
                        
                        // AG - Add Comm Event
                        Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Profile Forget Password',acc.id,null,null));
                        
                        // AG - Dont return it via API not safe
                        //tempPaswrd_Resp.tempPassword=tempPass;
                        tempPassword_List.add(tempPaswrd_Resp);
                        status = 'Success';
                        statusCode='200';
                        msg+='Temporary Password generated Successfull, Please change your Password within 30 Minutes ';
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(tempPassword_List));
                        return responseWrap;
                    }
                }
                else{
                    status = 'error';
                    statusCode='500';
                    msg+='No account found with this Email ';
                }
                
            }
            else{
                status = 'error';
                statusCode='500';
                msg+='Incorrect Request body ';
            }
            
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ get token EXCEPTION ENCOUNTERD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
            // FinResponse: generate token 
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(tempPassword_List));
            return responseWrap;
        }

        // FinResponse: generate token 
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(tempPassword_List));
        return responseWrap;
    }

    // wrapper 1:
    // @desc: authorization request
    public class accessTokenReqWrap{
        public String email;
        public String password;

        public accessTokenReqWrap parse(String json){
            return (accessTokenReqWrap)System.JSON.deserialize(json, accessTokenReqWrap.class);
        }
    }

    // wrapper 1.1:
    // @desc: authorization request
    public class userInfoReqWrap{
        public String email;
        public String password;
        public Boolean refreshReq; // TRUE: to generate a new token

        public userInfoReqWrap parse(String json){
            return (userInfoReqWrap)System.JSON.deserialize(json, userInfoReqWrap.class);
        }
    }

    // wrapper 2:
    // @desc: authorization request
    public class userAuth_ResponseWrap{
        public String authorizationToken;

        public userAuth_ResponseWrap(String userAuth){
            this.authorizationToken = userAuth;
        }
        // public String refreshToken;
    }

    // wrapper 3:
    // @desc: authorization request
    public class changePassword_wrap{
        public String email;
        public String temporaryPassword;
        public String newPassword;

        public changePassword_wrap parse(String json){
            return (changePassword_wrap)System.JSON.deserialize(json, changePassword_wrap.class);
        }
    }

    // wrapper 4:
    // @desc: To Expire authorization request
    public class ExpireToken_wrap{
        public String email;
        public String AuthorizationToken;
        
        public ExpireToken_wrap parse(String json){
            return (ExpireToken_wrap)System.JSON.deserialize(json, ExpireToken_wrap.class);
        }
    }

    // wrapper 5:
    // @desc: To return Temporary Password for forgot PAssword APIs.
    public class tempPasswordResponse{
        public String tempPassword; 
    }
}