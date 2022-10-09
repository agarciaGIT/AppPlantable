public class ON24EngagementHubSSO {

    Pagereference page = new pagereference('https://www.garp.org/#!/404');

    public pagereference redirect() {
    
        List<User> users = [SELECT Id, ContactId, Email FROM User WHERE Id = :UserInfo.getUserId()];
        System.Debug('users:' + users);
        
        if(!users.isEmpty()) {           
            List<Contact> contacts = [SELECT Id, Name, KPI_Membership_Payment_Status__c ,Email, AccountID FROM Contact WHERE Id = :users[0].ContactId];
            System.Debug('contacts:' + contacts);
            
            if( contacts != null && contacts.size() > 0 ) {            
            
                String memberId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
                List<Contract> lstCont = [select Id, Name, Status from Contract where AccountID = :contacts[0].AccountID  and RecordTypeId = :memberId AND Status like 'Activated%'];
                System.Debug('lstCont:' + lstCont);
                
                if(lstCont != NULL && lstCont.size() > 0 && lstCont[0].Status.subString(0,9) == 'Activated') {
            
                    String accountEmail = contacts[0].Email;
                    String sredir = 'https://gateway.on24.com/wcc/login?eventId=2960348&sessionid=1&key=67B583B1ACBD79DE9C7AC600CA57A098&email=' + accountEmail + '&targetUrl=';
                    System.Debug('sredir:' + sredir);
                        
                    page = new pagereference(sredir);
                }
            }
        }    
        return page;
    }
    
}