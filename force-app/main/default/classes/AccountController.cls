public with sharing class AccountController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountList() {
        System.debug('@@@ accoutn wire via property called');
        return [SELECT id, name,website FROM Account WHERE website!=null WITH SECURITY_ENFORCED LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static Account getSingleAccount() {
        System.debug('@@@@@@ controller called');
        return [
            SELECT Id, Name, Phone, Type
            FROM Account
            WITH SECURITY_ENFORCED
            LIMIT 1
        ];
    }

    //GET 10 CONTACTS
    @AuraEnabled(cacheable=true)
    public static list<Contact> get10Contacts(string accId){
        return [SELECT id,lastName,FirstName,email from Contact where accountId=:accId WITH SECURITY_ENFORCED LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static list<Contact> fatchAllContach(){
        return [SELECT id,Name,email,phone from Contact];
    }

    // SEARCH ACCOUNT BASED ON NAME
    @AuraEnabled(cacheable=true)
    public static list<Account> showMatching(String userKey){
        if(userKey=='' || userKey==null || userKey=='%' || userKey=='undefined')
            return null;

        string query = 'SELECT Id, Name from Account where Name Like \''+userkey+'%\'  WITH SECURITY_ENFORCED Limit 5';
        return database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static List<sObject> search(String searchTerm, string myObject, String filter) {
        String myQuery = null;
        if(filter != null && filter != ''){
            myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' AND '+filter+' LIMIT  5';
        }
        else {
            if(searchTerm == null || searchTerm == ''){
                myQuery = 'Select Id, Name from '+myObject+' Where LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT  5';
            }
            else {
                myQuery = 'Select Id, Name from '+myObject+' Where Name Like  \'%' + searchTerm + '%\' LIMIT  5';
            }
        }
        List<sObject> lookUpList = database.query(myQuery);
        return lookUpList;
    }
}