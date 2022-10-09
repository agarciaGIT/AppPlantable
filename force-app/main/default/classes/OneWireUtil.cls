global class OneWireUtil implements Database.AllowsCallouts{
    
    public static String contentVideoRecordTypeId 	= RecordTypeHelper.getRecordTypeId('Content__c', 'Video');
    public static String jobRecordTypeId 			= RecordTypeHelper.getRecordTypeId('Job__c', 'OneWire Jobs');
    
    public static Integer getMonthNumberByName(String month){
        
        month = month.toUpperCase();
        
        Map<String, Integer> monthMap = new Map<String, Integer>();
        
        monthMap.put('JAN', 1);
        monthMap.put('FEB', 2);
        monthMap.put('MAR', 3);
        monthMap.put('APR', 4);
        monthMap.put('MAY', 5);
        monthMap.put('JUN', 6);
        monthMap.put('JUL', 7);
        monthMap.put('AUG', 8);
        monthMap.put('SEP', 9);
        monthMap.put('OCT', 10);
        monthMap.put('NOV', 11);
        monthMap.put('DEC', 12);
        
        return (monthMap.containsKey(month)) ? monthMap.get(month) : 0;
        
    }
    
    public static Map<String, Job__c> parseJobsJSON(String input){
        
        Map<String, Job__c> jobs = new Map<String, Job__c>();
        
        for(Object o :(List<Object>)JSON.deserializeUntyped(input)){
            
            Map<String, Object> keyValueMap = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(o));
            
            List<String> dtArr = String.valueOf(keyValueMap.get('Published_Date__c')).split('(\\,\\s)|(\\s)');
            
            Integer yyyy	= Integer.valueOf(dtArr[3]);
            Integer mm		= Integer.valueOf(getMonthNumberByName(dtArr[2]));
            Integer dd		= Integer.valueOf(dtArr[1]);
            
            Date dt = Date.newInstance(yyyy, mm, dd);
            
            Job__c job = new Job__c();
            
            job.Country__c				= String.valueOf(keyValueMap.get('Country__c')); 
            job.City__c 				= String.valueOf(keyValueMap.get('City__c')); 
            job.State__c				= String.valueOf(keyValueMap.get('State__c'));
            job.Postal_Code__c			= String.valueOf(keyValueMap.get('Postal_Code__c'));
            job.Salary__c				= String.valueOf(keyValueMap.get('Salary__c'));
            job.Experience__c			= String.valueOf(keyValueMap.get('Experience__c'));
            job.Company__c				= String.valueOf(keyValueMap.get('Company__c'));
            job.Job_Type__c				= String.valueOf(keyValueMap.get('Job_Type__c'));
            job.Category__c				= String.valueOf(keyValueMap.get('Category__c'));
            job.Sponsored__c			= String.valueOf(keyValueMap.get('Sponsored__c'));
            job.Title__c				= String.valueOf(keyValueMap.get('Title__c'));
            job.URL__c					= String.valueOf(keyValueMap.get('URL__c'));
            job.Reference_Number__c		= String.valueOf(keyValueMap.get('Reference_Number__c'));
            job.Description__c			= String.valueOf(keyValueMap.get('Description__c'));
            job.Published_Date__c		= dt;
            job.RecordTypeId			= jobRecordTypeId;
            
			jobs.put(job.Reference_Number__c, job);
            
        }
        
        return jobs;
        
    }
    
    public static Map<String, Content__c> parseVideoXML(String input){
        
        Dom.Document xml = new Dom.Document();
        
        xml.load(input);
        
        List<Dom.XmlNode> channels = new List<Dom.XmlNode>();
        for(Dom.XmlNode node: xml.getRootElement().getChildElements()){
            if(node.getName() == 'channel'){
                channels.add(node);
            }
        }
        
        Map<String, Content__c> videos = new Map<String, Content__c>();
        for(Dom.XmlNode channel: channels){
            for(Dom.XmlNode channelProp: channel.getChildElements()){
                if(channelProp.getName() == 'item'){
                    
                    List<String> dtArr = channelProp
                        .getChildElement('pubdate', null)
                        .getText()
                        .trim()
                        .split('(\\,\\s)|(\\s)');
                    
                    Integer yyyy	= Integer.valueOf(dtArr[3]);
                    Integer mm		= Integer.valueOf(getMonthNumberByName(dtArr[2]));
                    Integer dd		= Integer.valueOf(dtArr[1]);
                    
                    Date dt = Date.newInstance(yyyy, mm, dd);
                    
                    Content__c video = new Content__c();
                    
                    video.Content_Name__c		= channelProp.getChildElement('title', null).getText().trim();
                    video.Third_Party_URL__c	= channelProp.getChildElement('link', null).getText().trim();
                    video.External_ID__c		= channelProp.getChildElement('guid', null).getText().trim();
                    video.Description__c		= channelProp.getChildElement('description', null).getText().trim();
                    video.recordTypeId			= contentVideoRecordTypeId;
                    video.Published_Date__c		= dt;
                    
                    videos.put(video.External_ID__c, video);
                    
                }
            }
        }
        
        return videos;
        
    }
    
    public static Map<String, Integer> processJobs(Map<String, Job__c> external){
        
        Map<String, Integer> results 	= new Map<String, Integer>();
        Map<String, Job__c> toInsertMap = new Map<String, Job__c>();        
        Map<String, Job__c> toUpdateMap = new Map<String, Job__c>();
        
        //RETRIEVE RECORDS TO UPDATE
        for(Job__c j: [
            SELECT 
            	Id, 
            	City__c, 
            	State__c, 
            	Postal_Code__c, 
            	Salary__c, 
            	Experience__c, 
            	Company__c, 
            	Job_Type__c, 
            	Category__c, 
            	Sponsored__c, 
            	Title__c, 
            	URL__c, 
            	Reference_Number__c, 
            	Description__c, 
            	Published_Date__c,
            	RecordTypeId
            FROM Job__c 
            WHERE Reference_Number__c IN :external.keySet() AND RecordTypeId = :jobRecordTypeId
        ]){
            
            Job__c job = external.get(j.Reference_Number__c);
            
            j.City__c 				= job.City__c;
            j.State__c 				= job.State__c;
            j.Postal_Code__c 		= job.Postal_Code__c;
            j.Salary__c				= job.Salary__c;
            j.Experience__c			= job.Experience__c;
            j.Company__c			= job.Company__c;
            j.Job_Type__c			= job.Job_Type__c;
            j.Category__c  			= job.Category__c;
            j.Sponsored__c			= job.Sponsored__c;
            j.Title__c				= job.Title__c;
            j.URL__c  				= job.URL__c;
            j.Reference_Number__c	= job.Reference_Number__c;
            j.Description__c		= job.Description__c;
            j.Published_Date__c		= job.Published_Date__c;
            j.RecordTypeId			= jobRecordTypeId;
            
            toUpdateMap.put(j.Reference_Number__c, j);
            
        }
        
        //RETRIEVE RECORDS TO INSERT
        for(Job__c j: external.values()){
            if(toUpdateMap.containsKey(j.Reference_Number__c)) continue;
            toInsertMap.put(j.Reference_Number__c, j);
        }
        
        if(!toInsertMap.values().isEmpty()){
            INSERT toInsertMap.values();
            results.put('insertCount', toInsertMap.size());
        }
        
        if(!toUpdateMap.values().isEmpty()){
            UPDATE toUpdateMap.values();
            results.put('updateCount', toUpdateMap.size());
        }
        
        return results;
       
    }
    
    public static Map<String, Integer> deleteJobs(String jsonString){

        Map<String, Integer> results = new Map<String, Integer>();
        
        Set<String> referenceNumbers = new Set<String>();
        for(Object o: (List<Object>)JSON.deserializeUntyped(jsonString)){
            referenceNumbers.add(String.valueOf(o));
        }
        
        List<Job__c> toDelete = [SELECT Id, RecordTypeId, Reference_Number__c FROM Job__c WHERE Reference_Number__c NOT IN :referenceNumbers AND RecordTypeId = :jobRecordTypeId];
        
        if(!toDelete.isEmpty()){
            DELETE toDelete;
            results.put('deleteCount', toDelete.size());
        }
        
        results.put('totalCount', referenceNumbers.size());
        
        return results;
        
    }
    
    public static void processVideos(Map<String, Content__c> external){
        
        List<Content__c> toInsertContent = new List<Content__c>();
        
        Set<Id> toUpdateIds					= new Set<Id>();
        Set<Id> toDeleteContentIds			= new Set<Id>();
        Set<Id> toDeleteContentFoldersIds	= new Set<Id>();
        
        //DEFINE INTERNAL DATA MAP
        Map<String, Content_Folders__c> internal 	= new Map<String, Content_Folders__c>();
        
        //CREATE MAP OF EXISTING TARGET RECORDS
        for(Content_Folders__c cf: [
            SELECT 
            	Id, 
            	Name, 
            	Folder__r.Name, 
            	Content__c, 
            	Content__r.External_ID__c
            FROM 
            	Content_Folders__c
            WHERE Folder__r.Name = 'OneWire Videos Repository' OR Folder__r.Name = 'OneWire Videos Highlighted'
        ]){
            if(internal.containsKey(cf.Content__r.External_ID__c)) continue;
            internal.put(cf.Content__r.External_ID__c, cf);
        }
        
        //UPDATE RECORDS IF THEY EXIST IN THE EXTERNAL DATA SOURCE AND EXIST IN THE INTERNAL DATA SOURCE ELSE INSERT NEW RECORDS
        for(String key: external.keySet()){
            if(internal.containsKey(key)){
                toUpdateIds.add(internal.get(key).Content__c);
            }else{
                toInsertContent.add(external.get(key));
            }
        }
        
        //DELETE RECORDS IF THEY DO NOT EXIST IN EXTERNAL DATA SOURCE
        for(String key: internal.keySet()){
            if(!external.containsKey(key)){
                toDeleteContentIds.add(internal.get(key).Content__c);
                toDeleteContentFoldersIds.add(internal.get(key).Id);
            }
        }
        
        //DELETE CONTENT
        if(!toDeleteContentIds.isEmpty()){
            
            List<Content__c> toDeleteContent = [
                SELECT Id
                FROM Content__c 
                WHERE Id IN :toDeleteContentIds
            ];
            
            DELETE toDeleteContent;
            
        }
        
        //DELETE CONTENT FOLDERS
        if(!toDeleteContentFoldersIds.isEmpty()){
            
            List<Content_Folders__c> toDeleteContentFolders	= [
                SELECT Id 
                FROM Content_Folders__c 
                WHERE Id IN :toDeleteContentFoldersIds
            ];
            
            DELETE toDeleteContentFolders;
            
        }
        
        //INSERT NEW RECORDS
        if(!toInsertContent.isEmpty()){
            
            INSERT toInsertContent;
            
            Id folderId = [SELECT Id, Name FROM Folder__c WHERE Name = 'OneWire Videos Repository' LIMIT 1].Id;
            
            List<Content_Folders__c> toInsertContentFolders = new List<Content_Folders__c>();
            for(Content__c c: toInsertContent){
                
                Content_Folders__c contentFolder = new Content_Folders__c();
                
                contentFolder.Content__c = c.Id;
                contentFolder.Folder__c = folderId;
                
                toInsertContentFolders.add(contentFolder);
                
            }
            
            INSERT toInsertContentFolders;
            
        }
        
        //UPDATE RECORDS
        if(!toUpdateIds.isEmpty()){
            
            List<Content__c> toUpdate = new List<Content__c>();
            
            for(Content__c c: [
                SELECT Id, Content_Name__c, External_ID__c, Third_Party_URL__c, Published_Date__c, Description__c
                FROM Content__c 
                WHERE Id IN : toUpdateIds
            ]){                
                if(external.containsKey(c.External_ID__c)){
                    
                    Content__c content = external.get(c.External_ID__c);
                    
                    c.Content_Name__c		= content.Content_Name__c;
                    c.Third_Party_URL__c	= content.Third_Party_URL__c;
                    c.Published_Date__c		= content.Published_Date__c;
                    c.Description__c		= content.Description__c;
                    
                    toUpdate.add(c);
                    
                }
            }

            UPDATE toUpdate;
            
        }
        
    }
    
}