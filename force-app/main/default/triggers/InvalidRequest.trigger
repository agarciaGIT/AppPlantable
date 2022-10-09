trigger InvalidRequest on Vaykay__Time_Off_Request__c (before update,before insert) {

    for(Vaykay__Time_Off_Request__c cn : trigger.New)
    {
        if(cn.Invalid_Request__c == true && cn.Vaykay__Status__c =='Approved' ) {
           cn.addError('Cannot approve more than remaining in budget.');
       }
    }}