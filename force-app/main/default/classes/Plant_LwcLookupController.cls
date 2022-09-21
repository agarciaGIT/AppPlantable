public class Plant_LwcLookupController {
@AuraEnabled(cacheable=true)  
    public static List<sobject> findRecords(String searchKey, String objectName, boolean userRoleWise,string accountId) {  
      string searchText = '\'' + String.escapeSingleQuotes(searchKey) + '%\'';  
      string searchAccountId = (accountId != null ? '\'' + String.escapeSingleQuotes(accountId) + '\'' : '');
      string query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' LIMIT 6';

      if(objectName == 'Order'){
        searchText = '\'' + '%' + String.escapeSingleQuotes(searchKey) + '%\'';
        query = 'SELECT Id, Name FROM ' +objectName+ ' WHERE OrderNumber LIKE '+searchText+' LIMIT 6';
      }
      
      if(userRoleWise){
        Id currentUserRoleId = UserInfo.getUserRoleId();
        Set<Id> allUsers = getRoleSubordinateUsers(currentUserRoleId);
        if(objectName == 'Plant_Payment_Method__c'){
          return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' AND Plant_Account__c='+searchAccountId+' LIMIT 6');  
        }
        else{
        return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' LIMIT 6');  
        }
      }

      if(objectName == 'Plant_Payment_Method__c'){
        if(searchAccountId != null && searchAccountId != ''){
          system.debug('query:::::::::::::'+'SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' AND Plant_Account__c='+searchAccountId+' LIMIT 6');
        return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' AND Plant_Account__c='+searchAccountId+' LIMIT 6');  
        }
        else{
          return null;
        }
      }

      else if(objectName == 'Order'){
        if(searchAccountId != null && searchAccountId != ''){
          system.debug('query:::::::::::::'+'SELECT Id, OrderNumber FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' AND AccountId='+searchAccountId+' LIMIT 6');
        return Database.query('SELECT Id, OrderNumber FROM ' +objectName+ ' WHERE OrderNumber LIKE '+searchText+' AND AccountId='+searchAccountId+' LIMIT 6');  
        }
        else{
          return null;
        }
      }

      else if(objectName == 'Plant_Subscription__c'){
        if(searchAccountId != null && searchAccountId != ''){
          //system.debug('query:::::::::::::'+'SELECT Id, OrderNumber FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' AND Plant_Account__c='+searchAccountId+' LIMIT 6');
          return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' AND Plant_Account__c='+searchAccountId+' LIMIT 6');  
        }
        else{
          return null;
        }
      }

      else{
      return Database.query('SELECT Id, Name FROM ' +objectName+ ' WHERE Name LIKE '+searchText+' LIMIT 6');  
      }
          
    }
    
    public static Set<ID> getRoleSubordinateUsers(Id roleId) {
      // To get all sub roles.
      Set<Id> allSubRoleIds = getAllSubRoleIds(new Set<ID>{roleId});
      Map<Id,User> users = new Map<Id, User>([Select Id, Name From User where IsActive = True AND UserRoleId IN :allSubRoleIds]);
      return users.keySet();
    }
  
    public static Set<ID> getAllSubRoleIds(Set<ID> roleIds) {
        Set<ID> currentRoleIds = new Set<ID>();
        // Get all the roles underneath the passed roles.
        for(UserRole userRole :[select Id from UserRole where ParentRoleId IN :roleIds AND ParentRoleID != null])
            currentRoleIds.add(userRole.Id);
        if(currentRoleIds.size() > 0){
            currentRoleIds.addAll(getAllSubRoleIds(currentRoleIds));
        }
        return currentRoleIds;
    }
}