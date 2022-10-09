public class OneWireBlogPostServiceQueueable implements Queueable, Database.AllowsCallouts{
    
    public Integer batchSize;
    public Integer offsetSize;
    public Integer postCount;
    public Map<String, Content__c> contentMap;

    public void execute(QueueableContext qc){
        
        String json = OneWireBlogPostService.getOneWireBlogPosts(batchSize, offsetSize);
        
        for(Content__c content: OneWireBlogPostService.convertJsonToContentMap(json).values()){
            contentMap.put(content.External_ID__c, content);
        }
        
        offsetSize = offsetSize + batchSize;
        
        if(offsetSize <= postCount){
			System.enqueueJob(new OneWireBlogPostServiceQueueable(batchSize, offsetSize, postCount, contentMap));  
        }else{
            OneWireBlogPostService.performCrudOperations(contentMap);
        }
    
    }
        
    public OneWireBlogPostServiceQueueable(Integer batchSize, Integer offsetSize, Integer postCount, Map<String, Content__c> contentMap){
		this.batchSize  = batchSize;
        this.offsetSize = offsetSize;
        this.postCount  = postCount;
      	this.contentMap = contentMap;
    }
    
}