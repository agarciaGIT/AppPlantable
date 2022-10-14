public class CommunityUtils {
    
    public static boolean bIsRecusrsive = false;
    public class MyException extends Exception {}

    public static void createCommunityUser(List < Contact > lstCon) {
        
        String strPostFix = '.Garp';
        bIsRecusrsive = true;
        List < User > userList = new List < User > ();
        MAP < String, String > mapEmailGARPID = new MAP < String, String > ();
        set < id > contactIDs = new set < id > ();
        set < id > usersContactIDs = new set < id > ();
        set < string > contactEmails = new set < string > ();
        User mockUser;
        Profile pf = [SELECT Id FROM profile WHERE name = 'Customer Community' limit 1];
       
        for (Contact c: lstCon) {
            system.debug('Contact :' + c);
            system.debug('Contact Fire Flag:' + c.do_not_fire__c);
            if (c.do_not_fire__c == false){
                contactIDs.add(c.id);
            }
        }
        
        if (contactIDs.isEmpty()){
            return;
        }
        
        Map<Id, String> contactid2AccountUserRole = new Map<Id, String>();
        Id memberRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
        Id businessRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Business Relationship');

        Set < String > setEmails = new Set < String > ();
        for (User u: [select id, username, ContactId from User where ContactId IN: contactIDs]) {
            setEmails.add(u.username);
            usersContactIDs.add(u.ContactId);
        }
        
        Set < Id > setAccountIds = new Set < Id > ();
        for (Contact con: lstCon) {

            system.debug('con.Email == ' + con.Email);
            system.debug('con.recordTypeId == ' + con.recordTypeId);
            system.debug('con.Created_From_Flow__c == ' + con.Created_From_Flow__c);
            system.debug('con.Event_Contributor__c == ' + con.Event_Contributor__c);
            system.debug('con.Event_Participant__c == ' + con.Event_Participant__c);
            system.debug('usersContactIDs == ' + usersContactIDs);
            system.debug('contactEmails == ' + contactEmails);
           
            if(
                !usersContactIDs.contains(con.id) && 
                !contactEmails.contains(con.Email) && 
                con.Email != null && 
                con.Email.indexOf('garpautoqaqatesting') == -1 && 
                con.recordTypeId != null
            ) {
                
                if(
                    con.recordTypeId == memberRecordTypeId ||
                    (
                        con.recordTypeId == businessRecordTypeId && 
                        (con.Created_From_Flow__c == true || con.Event_Contributor__c == true || con.Event_Participant__c == true)
                    )
                ) {
                    
                    mockUser = new User();
                    mockUser.contactId = con.Id;

                    if (Test.isrunningtest()){
                        mockUser.username = con.Email + '.' + string.valueof(Math.random()).substring(4, 9);
                    }else{
                        mockUser.username = con.Email;
                    }
                    
                    mockUser.firstname = con.FirstName;
                    mockUser.lastname = con.LastName;
                    mockUser.email = con.Email;
                    mockUser.FederationIdentifier = con.GARP_Member_ID__c;
                    if (Test.isrunningtest()) {
                        mockUser.communityNickname = con.LastName.substring(0, 1) + string.valueof(Math.random()).substring(4, 9);
                    } else {
                        mockUser.communityNickname = generateNickName(con);
                    }
                    
                    if (Test.isrunningtest()) {
                        mockUser.alias = con.LastName.substring(0, 1) + string.valueof(Math.random()).substring(4, 9);
                    } else {
                        mockUser.alias = con.GARP_ID_New__c ;
                    }
                       
                    mockUser.Password__c = con.Password__c; 
                    mapEmailGARPID.put(con.Email, con.GARP_Member_ID__c);
                    mockUser.profileid = pf.Id;
                    mockUser.emailencodingkey = 'UTF-8';
                    mockUser.languagelocalekey = 'en_US';
                    mockUser.localesidkey = 'en_US';
                    mockUser.timezonesidkey = 'America/New_York';

                    Database.DMLOptions dlo = new Database.DMLOptions();
                    dlo.EmailHeader.triggerUserEmail = true;
                    dlo.EmailHeader.triggerAutoResponseEmail = true;
                    mockUser.setOptions(dlo);
                    userList.add(mockUser);
                    system.debug('mockUser == ' + mockUser);
                    contactEmails.add(con.Email);
                    
                }
            }
        }

        if (userList.size() > 0) {
            system.debug('userList == ' + userList);
            
            try {
                
                INSERT userList;
            
                if(Test.isRunningTest()){
                    throw new myexception('DUPLICATE_USERNAME, Duplicate Username.<br>The username already exists in this or another Salesforce ');                
                }
                
            } catch (Exception e) {

                System.debug(e.getStackTraceString());

                AppError__c appErr = new AppError__c();
                appErr.Name = 'Failed to create Comm User';
                appErr.Message_Short__c = 'Failed to create Comm User 1st try';
                appErr.Error__c = e.getMessage() + '\n\n' + String.valueOf(userList);
                INSERT appErr;       
                
                if(
                    (e.getMessage().contains('DUPLICATE_USERNAME, Duplicate Username.<br>The username already exists in this or another Salesforce ')) || 
                    ((e.getMessage().contains('DUPLICATE_COMM_NICKNAME, Duplicate Nickname.<br>Another user has already selected this nickname.<br>Please select another.')))
                ) {
                    
                    List<Database.SaveResult> res = Database.insert(userList, false);
                    
                    for (Integer i = 0; i < userList.size(); i++) {
                        Database.SaveResult s = res[i];
                        user origRecord = userList[i];
                        if (!s.isSuccess()) {
                            system.debug(s.getId()); // I get null here
                            system.debug(origRecord.username); //This should be the Id you're looking for
                            origRecord.username = origRecord.username+strPostFix;
                            origRecord.communityNickname = origRecord.communityNickname+ string.valueof(Math.random()).substring(4, 9);
                            system.debug('$$$$$$:'+origRecord.communityNickname);
                            try {
                                INSERT origRecord;
                                system.debug('$$$$$$:'+origRecord.communityNickname);
                            } catch (Exception e1) {
                                AppError__c appErr1 = new AppError__c();
                                appErr1.Name = 'Failed to create Comm User';
                                appErr1.Message_Short__c = 'Failed to create Comm User 1st try';
                                appErr1.Error__c = e1.getMessage() + '\n\n' + String.valueOf(userList);
                                INSERT appErr1;                
                            }
                        } 
                    }   
                }           
            }

        } else {
            bIsRecusrsive = false;
        }
    
    }
 
    public static String generateNickName(Contact con) {
        if(con.Email.length() <= 40) {
            return con.Email;
        } else {
            String nick = '';
            for(Integer i = 0; i < 13; i++) {
                nick = nick + string.valueof(Math.round(Math.random()*1000));
            }
            return nick;
        }
    }

}