/*
* VaykayTriiger : Trigger to avoid duplicate requests. 
**/
trigger VaykayTrigger on Vaykay__Time_Off_Request__c (before insert) {
    List<Id> userTimeOffBalanceIds = new List<Id>();
    
    // Get the creating user time off blances.
    for(Vaykay__Time_Off_Request__c timeOffBalance :trigger.New){
        userTimeOffBalanceIds.add(timeOffBalance.Vaykay__Time_Off_Balance__c);
    }
    
    // Query all the time of request related to time off balance.
    List<Vaykay__Time_Off_Request__c> newRequestData = [SELECT id, Vaykay__First_Day_Off__c, Vaykay__Last_Day_Off__c, Vaykay__Time_Off_Balance__c
                                                        FROM Vaykay__Time_Off_Request__c
                                                        WHERE Vaykay__Time_Off_Balance__c IN :userTimeOffBalanceIds]; 
    for(Vaykay__Time_Off_Request__c newRequest : trigger.New) {
        Date requestedFirstDate = newRequest.Vaykay__First_Day_Off__c;
        Date requestedLastDate = newRequest.Vaykay__Last_Day_Off__c;
        if(newRequestData != null){
            for(Vaykay__Time_Off_Request__c previousRequest :newRequestData ){
                if(previousRequest.Vaykay__Time_Off_Balance__c == newRequest.Vaykay__Time_Off_Balance__c){
                    
                    // Check if the user creating the same request.
                    if(((previousRequest.Vaykay__First_Day_Off__c == requestedFirstDate && previousRequest.Vaykay__Last_Day_Off__c == requestedLastDate) || 
                        (requestedLastDate >= previousRequest.Vaykay__First_Day_Off__c && requestedLastDate <= previousRequest.Vaykay__Last_Day_Off__c) ||
                        (requestedFirstDate >= previousRequest.Vaykay__First_Day_Off__c && requestedFirstDate <= previousRequest.Vaykay__Last_Day_Off__c ) ||
                        (requestedFirstDate < previousRequest.Vaykay__First_Day_Off__c && requestedLastDate > previousRequest.Vaykay__Last_Day_Off__c ))){
                            newRequest.adderror('You already have created a request within the date range.');
                        }
                }
            }
        }
    }
    
}