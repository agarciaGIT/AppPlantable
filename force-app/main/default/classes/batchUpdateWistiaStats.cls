global class batchUpdateWistiaStats implements Database.Batchable<sObject>,Database.StateFul, Database.AllowsCallouts{
    
    global void execute(SchedulableContext sc) {
        Database.executebatch(new batchUpdateWistiaStats(),10);
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        String year = '2016';
        String RecordTypeId = recordtypehelper.getRecordtypeID('Content__c','Video');
         if ( !Test.isRunningTest() )
			return Database.getQueryLocator('select id, name, View_Count__c, Share_Count__c, Content_Name__c, Duration_in_Minutes__c, External_ID__c, Description__c, Image__c, RecordTypeId, SKU__c from Content__c where RecordTypeId = :RecordTypeId and SKU__c != null and SystemModStamp != TODAY');             
        	else return Database.getQueryLocator('select id, name, View_Count__c, Share_Count__c, Content_Name__c, Duration_in_Minutes__c, External_ID__c, Description__c, Image__c, RecordTypeId, SKU__c from Content__c where RecordTypeId = :RecordTypeId and SKU__c != null and SystemModStamp != YESTERDAY');
    }

    public class wistiaStatsActionClass {
        public String type;
        public Integer action_count;
        public Integer impression_count;
        public Double rate;
    }
    
    public class wistiaStatsClass {
        public Integer load_count;
        public Integer play_count;
        public Double play_rate;
        public Double hours_watched;
        public Double engagement;
        public Integer visitors;
        public List<wistiaStatsActionClass> actions;
    }
    
    public static wistiaStatsClass getVideoStats(String videoID) {

        String response;
        if ( !Test.isRunningTest() ) {
            HttpResponse res;
            HttpRequest req = new HttpRequest();      
            req.setEndpoint('https://api.wistia.com/v1/stats/medias/' + videoID + '.json?api_password=e3799e5757e935546bb68ddd768a1323ea4bb830a3019df150642f658e620ec9');
            req.setMethod('GET');
            Http h=new Http();
            res = h.send(req);
            response = res.getBody();
            system.debug('res == '+response);
        } else {
            response = '{"load_count":640,"play_count":136,"play_rate":0.20735785953177258,"hours_watched":6.295812100155556,"engagement":0.656795,"visitors":598}';
        }    
	        
        
        wistiaStatsClass vidStats;
        JSONParser parser = JSON.createParser(response);
        while (parser.nextToken() != null) {
	        if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                vidStats = (wistiaStatsClass)parser.readValueAs(wistiaStatsClass.class);
            }
        }
        return vidStats;
    }
    
    
    global void execute(Database.BatchableContext BC, List<Content__c> scope){ 
        List<Content__c> lstUpdate = new List<Content__c>();
        for(Content__c cont :scope) {
            wistiaStatsClass vidStats = getVideoStats(cont.SKU__c);
            if(vidStats != null) {
                cont.View_Count__c = vidStats.play_count;
                //update cont;
                lstUpdate.add(cont);
            }
        } 
        update lstUpdate;
    }
    
    
    global void finish(Database.BatchableContext BC){
    }
                
}