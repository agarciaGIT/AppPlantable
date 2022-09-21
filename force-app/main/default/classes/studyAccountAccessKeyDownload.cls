public class studyAccountAccessKeyDownload {
    
    public String csvString {get;set;}
    
    public studyAccountAccessKeyDownload () {
        
        csvString='';
        String userID = UserInfo.getUserId();
        string sall = ApexPages.currentPage().getParameters().get('all');
        
        if(sall != NULL && sall.length() > 0) {
            List<Account> lstAcct = [select Id, Name, First_Name__c, Last_Name__c, Email__c, Study_ID__c, Study_Access_Key__c from Account where Study_Account_Owner_ID__c = :userID AND Study_Access_Key__c != NULL];                    
            for(Account ar :lstAcct) {
                csvString+= ar.Study_ID__c + ',' + ar.First_Name__c + ',' + ar.Last_Name__c + ',' + ar.Email__c + ',' + ar.Study_Access_Key__c + '\n';
            }            
        } else {
            List<API_Request__c> lstAPIReq = [select Id, Study_ID__c, First_Name__c, Last_Name__c, Customer_Email__c, Study_Access_Key__c from API_Request__c where Account__r.Study_Account_Owner_ID__c = :userID AND Study_Access_Key__c != NULL and CreatedDate = TODAY];
            for(API_Request__c ar :lstAPIReq) {
                csvString+= ar.Study_ID__c + ',' + ar.First_Name__c + ',' + ar.Last_Name__c + ',' + ar.Customer_Email__c + ',' + ar.Study_Access_Key__c + '\n';
            }            
        }
        
        
        
    }

}