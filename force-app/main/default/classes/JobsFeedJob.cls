global class JobsFeedJob implements Schedulable {
    
	public class jobListClass
    {
        public Integer count;
        public List<jobClass> jobs;
    }
                
    public class jobClass
    {
        public String name;
        public String location;
        public String company;
        public String description;
        public String url;
    }    
    
	@future(callout=true)
    public static Void getJobTargetJobs() {

        HttpResponse res;
        if ( !Test.isRunningTest() ) {
            HttpRequest req = new HttpRequest();      
            req.setEndpoint('http://www.garp.org/sfdc/jobtarget/jobs');
            req.setMethod('GET');
            Http h=new Http();
            res = h.send(req);
            system.debug('res == '+res.getBody());
            
            jobListClass lstJobs = (jobListClass)JSON.deserialize(res.getBody(), jobListClass.class);
            system.debug('lstJobs:' + lstJobs);
            List<Content__c> lstCont = new List<Content__c>();
            for(jobClass job :lstJobs.jobs) {
                Content__c cont = new Content__c(Name=job.name, Location__c=job.location, Third_Party_URL__c=job.url, Description__c=job.description, Third_Party_Author__c=job.company, RecordTypeID=RecordTypeHelper.GetRecordTypeId('Content__c','Job'));
				lstCont.add(cont);           
            }
            insert lstCont;
        } else {
            res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('[{"name":" Risk Manager - Oil & Gas  ","location":"Geneva, Switzerland","description":"For one of our clien...","url":"https://www.careerwebsite.com/c/job.cfm?site_id=9349&jb=27037655"},{"name":" Risk Analyst  ","location":"San Francisco, CA","description":" Risk Analyst Fundin...","url":"https://www.careerwebsite.com/c/job.cfm?site_id=9349&jb=26650772"},{"name":" Market Risk Quant Analyst - Fixed Income  ","location":"St. Petersburg, FL","description":"Job Summary:   ...","url":"https://www.careerwebsite.com/c/job.cfm?site_id=9349&jb=26634941"},{"name":" Director, Credit Policy & Analytics  ","location":"Atlanta, GA","description":"Based in Atlanta, ou...","url":"https://www.careerwebsite.com/c/job.cfm?site_id=9349&jb=26499262"}]');
        }

        
    }	
	
    global void execute(SchedulableContext SC) {
        Id recId = RecordTypeHelper.GetRecordTypeId('Content__c','Job');
        List<Content__c> lstJobs = [select Id, Name, Description__c, Third_Party_URL__c, Location__c, Third_Party_Author__c from Content__c where RecordTypeID = :recId];
		delete lstJobs;
		getJobTargetJobs();
    }
    
    global void finish(Database.BatchableContext SC){
         
       
    }
}