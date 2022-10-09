global without sharing class JobController  {

    // Job Wrapper for sorting
    global class JobWrapper implements Comparable {
        public Job__c job;
       
        public JobWrapper(Job__c j) {
            job = j;
        }
        
        // Compare jobs based on Display Sort Order Value
        global Integer compareTo(Object compareTo) {
            // Cast argument to JobWrapper
            JobWrapper compareToJob = (JobWrapper)compareTo;
            Integer displaySortOrderA = Integer.valueOf(job.Display_Sort_Order__c);
            Integer displaySortOrderB = Integer.valueOf(compareToJob.job.Display_Sort_Order__c);
            // 0 means they are equal
            Integer returnValue = 0;
            if (displaySortOrderA > displaySortOrderB) {
                returnValue = 1;
            } else if (displaySortOrderA > displaySortOrderB) {
                returnValue = -1;
            }
                
            return returnValue;
        }
    }
    
    @RemoteAction    
    public static List<Job__c> getHighlightedJobs() {
        List<Job__c> unsortedJobs = [SELECT Id, Title__c, Company__c, City__c, State__c, URL__c, Display_Sort_Order__c FROM Job__c WHERE Display_Sort_Order__c != null LIMIT 6];
        List<Job__c> sortedJobs = new List<Job__c>();
        
        JobWrapper[] jobWrapperList = new List<JobWrapper>();
        for (Job__c job : unsortedJobs) {
            jobWrapperList.add(new JobWrapper(job));
        }
        jobWrapperList.sort();
        for (JobWrapper sortedJob : jobWrapperList) {
            sortedJobs.add(sortedJob.job);
        }
        return sortedJobs;
    }

    public JobController(sfdcAppRemoter ctrl){}

}