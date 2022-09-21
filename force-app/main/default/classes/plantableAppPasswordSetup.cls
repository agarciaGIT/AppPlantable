public class plantableAppPasswordSetup {

    public String pwdToken {get; set;}
    public String newPwd {get; set;}    
    public String newPwdVerify {get; set;}        
    public String errMsg {get; set;}    
    public String setFocus {get; set;}    
    public Boolean codeInvalid {get; set;}  
    public String gotResp {get; set;}  
    

    public void doInit() {
        pwdToken  = ApexPages.currentPage().getParameters().get('token');
        newPwd = '';
        newPwdVerify = '';
        errMsg = '';
        setFocus = '';
        codeInvalid = FALSE;
        gotResp = 'false';
        
        System.debug('pwdToken:' + pwdToken);
    }
    
    public void clearError() {
        System.debug('errMsg:' + errMsg);
        errMsg = '';
        setFocus = 'true';
    }
    
    public PageReference submitPassword() {
    
        PageReference pageRef;
        errMsg = null;
        setFocus = '';
        
        newPwd  = newPwd.trim();
        newPwdVerify = newPwdVerify.trim();        
        
        System.debug('newPwd :' + newPwd );
        System.debug('newPwdVerify :' + newPwdVerify );        

        if(newPwd.length() == 0) {
            errMsg = 'Password is empty.';
        } else if(newPwd.length() < 8) {
            errMsg = 'Password is too short.';
        } else if(newPwdVerify.length() == 0) {
            errMsg = 'Password confirmation is empty.';            
        } else if(newPwd != newPwdVerify) { 
            errMsg = 'Password and confirmation do not match.';
        }
        
        Pattern pat = Pattern.compile('([0-9]+)');
        Matcher matcher = pat.matcher(newPwd );
        Boolean matches = matcher.find();
        system.debug(logginglevel.error,matches);

        if(errMsg == NULL && matches == FALSE) {
            errMsg = 'The password must contain numbers';
        }

        Pattern pat1 = Pattern.compile('([a-zA-Z]+)');
        Matcher matcher1 = pat1.matcher(newPwd );
        Boolean matches1 = matcher1.find();
        system.debug(logginglevel.error,matches1);

        if(errMsg == NULL && matches1 == FALSE) {
            errMsg = 'The password must contain letters';
        }

        Pattern pat2 = Pattern.compile('([^a-zA-Z0-9]+)');
        Matcher matcher2 = pat2.matcher(newPwd );
        Boolean matches2 = matcher2.find();
        system.debug(logginglevel.error,matches2);
        
        if(errMsg == NULL && matches2 == FALSE) {
            errMsg = 'The password must contain one special character';
        }
        
        if(errMsg == NULL) {
            suggesticClass.resetPasswordResp ret = suggesticClass.setPassword(pwdToken, newPwd);
            if(ret != NULL && ret.data != NULL && ret.data.resetPassword != NULL && ret.data.resetPassword.success != NULL) {
                if(ret.data.resetPassword.success == True) {
                    pageRef = new PageReference('/apex/plantableAppPasswordSuccess');    
                } else {
                    if(ret.data.resetPassword.message != NULL) {
                        String msg = ret.data.resetPassword.message;
                        if(msg.indexOf('[') > -1) {
                            msg = msg.replaceAll('\'','\"');
                            list<String> ls = ( List<String> )JSON.deserialize( msg, List<string>.class ) ;        
                            System.debug('ls:' + ls);
                            msg = ls[0];
                        }
                        errMsg = 'There was an issue resetting your password. ' + msg;
                        
                        if(msg.indexOf('code was invalid') > -1) {
                            codeInvalid = TRUE;
                         }
                                                    
                        newPwd='';
                        newPwdVerify='';
                    } else {
                        errMsg = 'There was an issue resetting your password.';    
                        newPwd='';
                        newPwdVerify='';                        
                    }
                    
                }
                
            } else {
                errMsg = 'There was an issue resetting your password.';
            }
            
        } else {
            newPwd='';
            newPwdVerify='';
        }
        gotResp = 'true';
        return pageRef;
    }

}