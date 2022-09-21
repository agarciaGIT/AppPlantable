public class AccountSuggesticLastSeenbatch implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String query;
    public AccountSuggesticLastSeenbatch(String accQuery){
        this.query = accQuery;
    }
    public AccountSuggesticLastSeenbatch(){
        
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(query == null){
            query = 'SELECT Id,Email__c FROM Account Where Suggestic_ID__c != NULL';
        } 
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext bc, List<Account> records){
        List<Account> updateAccountList = new List<Account>();
        for(Account acc:records){
            if(acc.Email__c != null){
                try{
                    IntercomClass.responseSearchCustomer rsc= new IntercomClass.responseSearchCustomer();
                    rsc = IntercomClass.getCustomer(acc.Email__c);
                    if(rsc.data != null && rsc.data.size() > 0){
                        Account ac = new Account();
                        ac.Id = acc.Id;
                        if(rsc.data[0].ios_last_seen_at != null){
                            Long lastActivityDate = Long.valueOf(String.ValueOf(rsc.data[0].ios_last_seen_at));
                            ac.Suggestic_iOS_Last_Seen__c = DateTime.newInstance(lastActivityDate * 1000); 
                        }
                        if(rsc.data[0].android_last_seen_at!=null){
							Long androidLastseen = Long.valueOf(String.ValueOf(rsc.data[0].android_last_seen_at));
							ac.Suggestic_Android_Last_Seen__c = DateTime.newInstance(androidLastseen * 1000); 
						}
						if(rsc.data[0].last_replied_at!=null){
							Long lastRepliedat = Long.valueOf(String.ValueOf(rsc.data[0].last_replied_at));
							ac.Suggestic_Last_Heard_From__c = DateTime.newInstance(lastRepliedat * 1000);	
						}
                        if(ac.Suggestic_iOS_Last_Seen__c!=null || ac.Suggestic_Android_Last_Seen__c!=null){
                            if(ac.Suggestic_iOS_Last_Seen__c<ac.Suggestic_Android_Last_Seen__c){
                                 ac.Suggestic_Last_Seen__c = ac.Suggestic_Android_Last_Seen__c;
                            }else{
                                 ac.Suggestic_Last_Seen__c =ac.Suggestic_iOS_Last_Seen__c;
                            }
                        }
                         updateAccountList.add(ac);
                    }
                }catch(Exception ex){
                    system.debug('Error: '+ex.getMessage());
                }
            }
        }  
        
        if(updateAccountList.size()>0){
             update updateAccountList;
        }
    }
    public void finish(Database.BatchableContext bc){
        
    }
}