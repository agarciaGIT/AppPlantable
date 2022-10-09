@RestResource(urlMapping='/onewire/delete/jobs')
global without sharing class OneWireJobServiceDelete {
    
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
            
        	Map<String, Integer> results = OneWireUtil.deleteJobs(requestBody);
            
            w.success = true;
            
            w.totalCount = (results.containsKey('totalCount')) ? results.get('totalCount') : null;
            w.deleteCount = (results.containsKey('deleteCount')) ? results.get('deleteCount') : null;
                
        }catch(Exception e){
			
            w.success = false;
            w.messages = e.getMessage();
            
        }
        
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(w));
        
    }
    
}