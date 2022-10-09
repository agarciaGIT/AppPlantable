trigger onTasksInsertUpdate on Story_Task__c (after update, after insert) {
    
    system.debug('onTasksIssertUpdate');
    
    MAP<ID,Story_Task__c> mapTasks = new MAP<ID,Story_Task__c>();
    MAP<ID,ID> mapStory = new MAP<ID,ID>();
    for(Story_Task__c obj : trigger.New)
    {
        if(obj.Story__c != null||obj.Story__c !='')
            mapStory.put(obj.Story__c, obj.Story__c);
    }
    
    system.debug('mapStory:' + mapStory);
    
    List<ID> ids = new List<ID>();

    List<Story_Task__c> lstTasks = [select Id, Name, Story__c, Status__c from Story_Task__c where Story__c in :mapStory.values() order by Story__c]; 
    
    
    system.debug('lstTasks:' + lstTasks);
    
    ID lastStory = null;
    String newStatus = '';
    Boolean allCompleted = true;
    MAP<ID,String> newStatusMap = new MAP<ID,String>();
    Story_Task__c lastStoryTask;
    for(Story_Task__c st :lstTasks) {
        
        system.debug('st:' + st);
        lastStoryTask=st;
        
        if(lastStory != NULL && st.id != lastStory) {
            if(allCompleted == true)
                newStatusMap.put(st.Story__c, 'Completed');
            else if(newStatus != '')
                newStatusMap.put(st.Story__c, newStatus);

            lastStory = st.Id;
            
        }
        
        if(st.Status__c == 'Blocked')
            newStatus = 'Blocked';
        else if(st.Status__c == 'In Progress' && newStatus != 'Blocked')
            newStatus = 'In Progress';
        
        if(st.Status__c != 'Completed')
            allCompleted=False;
        
        
        system.debug('update:' + newStatus + ':' + allCompleted);
        
    }
    
    if(allCompleted == true)
        newStatusMap.put(lastStoryTask.Story__c, 'Completed');
    else if(newStatus != '')
        newStatusMap.put(lastStoryTask.Story__c, newStatus);
    
    
    system.debug('newStatusMap:' + newStatusMap);
    
    List<Story__c> lstStory = [select Id, Name, Status__c from Story__c where id in :newStatusMap.keySet()];
    
    system.debug('lstStory before:' + lstStory);
    
    for(Story__c s :lstStory) {
        String status = newStatusMap.get(s.Id);
        if(status != null) {
            s.Status__c = status;
        }
    }
    
    system.debug('lstStory after:' + lstStory);
    
    update lstStory;
}