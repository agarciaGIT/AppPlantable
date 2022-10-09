public class OneWireVideoService implements Schedulable {
    
    @future(callout=true)
    public static void getVideos(){
                
        Http http = new Http();
        
        HttpRequest req = new HttpRequest();
        
        req.setMethod('GET');
        req.setEndpoint('https://www.onewire.com/videosrss');
        
        HttpResponse res = http.send(req);

        Map<String, Content__c>	data = OneWireUtil.parseVideoXML(res.getBody().trim());
        OneWireUtil.processVideos(data);
        
    }
    
    public static void execute(SchedulableContext sc){
        getVideos();
    }
    
}