@RestResource(urlMapping='/CustomerCommunityUser/password/*')
global with sharing class CustomerCommunityManagementService {
    
    public class Wrapper{
        public Boolean success { get; set; }
        public Object messages { get; set; }
        public Object response { get; set; }
    }

    @HttpDelete
    global static void resetPasswordByEmailAddress(){
        
        Wrapper w = new Wrapper();
        
        String email = RestContext.request.params.get('email');
        
        List<User> users = [SELECT Id, Email, IsPortalEnabled FROM User WHERE Email = :email AND IsPortalEnabled = TRUE];
             
        if(!users.isEmpty()){      
            
            User user = users[0];
            
            try{
                
                System.ResetPasswordResult result = System.resetPassword(user.Id, true);
            
                if(result != null){
                    
                    w.success   = true;
                    w.messages  = 'Your password has been reset.  An email has been sent to ' + email;    
                    w.response  = user;
                    
                }else{
                    
                    w.success   = false;
                    w.messages  = 'Your password was not reset.  Please contact a GARP Customer Service representative.';
                    w.response  = user;
                    
                }
                
            }catch(Exception e){
   
                w.success   = false;
                w.messages  = e.getMessage();
                
            }
           
        }else{
            
            w.success   = false;
            w.messages  = 'The email address you provided is invalid.';
            
        }
        
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(w));
        
    }
    
}