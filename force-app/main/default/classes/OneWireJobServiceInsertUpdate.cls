@RestResource(urlMapping='/onewire/insert/jobs')
global without sharing class OneWireJobServiceInsertUpdate {
    
    public class Wrapper{
        public Boolean success 		{ get; set; }
        public Integer totalCount  	{ get; set; }
        public Integer updateCount 	{ get; set; }
        public Integer insertCount 	{ get; set; }
        public Integer deleteCount	{ get; set; }
        public String messages 		{ get; set; }
    }
    
    @HttpPost
    global static void doPost(){
        
        Wrapper w = new Wrapper();
        
        String requestBody = RestContext.request.requestBody.toString();
        
        try{
            
        	Map<String, Job__c> externalData = OneWireUtil.parseJobsJSON(requestBody);
            Map<String, Integer> results = OneWireUtil.processJobs(externalData);
            
            w.success = true;
            w.totalCount = externalData.size();
            
            w.updateCount = (results.containsKey('updateCount')) ? results.get('updateCount') : null;
            w.insertCount = (results.containsKey('insertCount')) ? results.get('insertCount') : null;
                
        }catch(Exception e){
			
            w.success = false;
            w.messages = e.getMessage();
            
        }
        
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(w));
        
    }
    
}