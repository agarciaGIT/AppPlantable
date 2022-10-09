trigger onContentUpdateInsert on Content__c (before update, before insert) {
    
    if(!Executed.once){
        
        Executed.once = true;
        
        List<Id> updateContentIds = new List<Id>();
        List<Id> updateStoryContentIds = new List<Id>();
        
        Map<Id, List<Content__c>> contentsByWebcastId = new Map<Id, List<Content__c>>();
        for(Content__c c: [SELECT Id, Name, Webcast__c FROM Content__c WHERE Webcast__c != null]){
            if(contentsByWebcastId.containsKey(c.Webcast__c)) contentsByWebcastId.get(c.Webcast__c).add(c);
            else contentsByWebcastId.put(c.Webcast__c, new List<Content__c>{c});
        }
        
        if (Trigger.isInsert) {
            
            for(Content__c c : trigger.New) {
                if(c.Webcast__c != null && contentsByWebcastId.containsKey(c.Webcast__c)){
                    c.addError('You can only associate one Content record with one Webcast.  The Content record currently associated is: ' + contentsByWebcastId.get(c.Webcast__c)[0].Name + ' (' + contentsByWebcastId.get(c.Webcast__c)[0].Id + ').');
                }
                if(c.Published_Date__c == null) {
                    c.Published_Date__c = Date.today();
                }
                if(c.Raw_HTML__c != null) {
                    updateStoryContentIds.add(c.Id);
                    c.Story__c = c.Raw_HTML__c;
                }
            }
            
        } else if(Trigger.isUpdate) {
            
            Map<Id, Content__c> contentOldMap = new Map<Id, Content__c>(Trigger.oldMap);
            
            for(Content__c c : trigger.New) {
                if(contentOldMap.get(c.Id).Webcast__c == null && c.Webcast__c != null && contentsByWebcastId.containsKey(c.Webcast__c)){
                    c.addError('You can only associate one Content record with one Webcast.  The Content record currently associated is: ' + contentsByWebcastId.get(c.Webcast__c)[0].Name + ' (' + contentsByWebcastId.get(c.Webcast__c)[0].Id + ').');
                }
                if(c.Raw_HTML__c != null) {
                    updateStoryContentIds.add(c.Id);
                    c.Story__c = c.Raw_HTML__c;
                }
            }
            
        }
        
    }
    
}