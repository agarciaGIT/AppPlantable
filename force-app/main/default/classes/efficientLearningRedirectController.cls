public class efficientLearningRedirectController {
    
    public String Custom_Content_GUID {get;set;}
    public String Custom_Course_GUID {get;set;}
    public String OAuth_Consumer_Key {get;set;}
    public String OAuth_Secret {get;set;}
    public String Context_ID {get;set;}
    
    public String eBookId {get;set;}
    public Boolean submitForm {get;set;}
    
    
    public String user_id {get;set;}
    public String lis_person_contact_email_primary {get;set;}
    public String lis_person_name_full {get;set;}
    public String lis_person_name_family {get;set;}
    public String lis_person_name_given {get;set;}
        
    @future(callout=true)
    public static void updateStatus(String eBookKeyId) {
        List<eBook_Key__c> listEBookKeys = [select Id, Last_Access_DateTime__c from eBook_Key__c where Id = :eBookKeyId];
        if( listEBookKeys != null && listEBookKeys.size() > 0 ) {
            
            system.debug('listEBookKeys Update:' + listEBookKeys);
            
            listEBookKeys[0].Last_Access_DateTime__c = system.now();
            update listEBookKeys;
        }
    }
    
    public void callUpdateStatus() {
        updateStatus(eBookId);
        submitForm=true;
    }
    
     public efficientLearningRedirectController() {
         
         submitForm = false;
         
         Map<String,Wiley_Efficient_Learning_Settings__c> rSites = 	Wiley_Efficient_Learning_Settings__c.getall();
         Custom_Content_GUID = rSites.get('Custom_Content_GUID').Value__c;
         Custom_Course_GUID = rSites.get('Custom_Course_GUID').Value__c;
         OAuth_Consumer_Key = rSites.get('OAuth_Consumer_Key').Value__c;
         OAuth_Secret = rSites.get('OAuth_Secret').Value__c;
         Context_ID = rSites.get('Context_ID').Value__c;
         
         
        String userId = UserInfo.getUserId();            
        List<User> lstUser = [Select u.Id,u.ContactId,Email from User u where u.Id = :userId];
        
        if( lstUser != null && lstUser.size() > 0 ) {
            
            List<Contact> lstContact = [select Id, Name, GARP_Member_ID__c, Email, FullName__c, LastName, FirstName from Contact where Id = :lstUser[0].ContactId];
            if( lstContact != null && lstContact.size() > 0 ) {            
                
                system.debug('lstContact:' + lstContact);
                
                List<eBook_Key__c> listEBookKeys = [select Id, Last_Access_DateTime__c from eBook_Key__c where Contact__c = :lstUser[0].ContactId AND Type__c = 'Wiley Efficient Learning' AND Status__c = 'Taken'];
                
                system.debug('listEBookKeys:' + listEBookKeys);
                
                if( listEBookKeys != null && listEBookKeys.size() > 0 ) {
                
                    user_id = lstContact[0].GARP_Member_ID__c;
                    lis_person_contact_email_primary = lstContact[0].Email;
                    lis_person_name_full = lstContact[0].FullName__c;
                    lis_person_name_family = lstContact[0].LastName;
                    lis_person_name_given = lstContact[0].FirstName;
                    eBookId = listEBookKeys[0].Id;
                }
            }
        }        
     }
   
}