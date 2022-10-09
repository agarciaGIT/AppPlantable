public class ProjectManagerDashBoard {
    public String neededIteration{get;set;}
    public string[] velocities {get;set;}
    public Integer currentPoints{get;set;}
    public List<SelectOption> Items{get;set;}
    public Map<Integer,String> iterationMap {get;set;}
    public List<Story__c> allRelevantStories{get;set;}
    public Integer velocity {get;set;}
    public List<Story__c> qaRelevantStories {get;set;}
    public List<Story__c> qaRelevantBlockedStories {get;set;}
    public List<Story__c> storiesReadyForQa {get;set;}
    public List<Case> blockedCases{get;set;}
    public List<Case> urgentCases{get;set;}
    public List<Case> oldestCases{get;set;}
    public String baseUrl {get;set;}
    public List<Case> missingDeployments{get;set;} 
    public List<Story__c> missingStories{get;set;}
    
    public ProjectManagerDashBoard(){
        constructorSetup1();
        baseUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        allCases();
        System.debug(iterationMap);
    }
    public void constructorSetup1(){
        Integer currentYear = System.today().Year();
        String currentYearString = String.valueof(currentYear);
        velocities = new list<String>();
        List<String> getItinString = new List<String>();
        Schema.DescribeFieldResult fieldResult = Story__c.Iteration__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry a : ple){
            string check = a.getValue();
            if(check.contains(currentYearString)){
                getItInString.add(check);    
            }
            Items = new List<SelectOption>();
            for(String thisString : getItinString){
                Items.add(new SelectOption(thisString,thisString));
            }  
        }
        iterationMap = new Map<Integer,String>();
        for(Integer x=0; x< getItInString.size();x++){
            Integer useThis = x + 1;
            iterationMap.put(useThis,getItInString[x]);
        }
        
        System.debug(fieldResult);
        System.debug(ple);
        System.debug(getItinString);
    }
    
    public void Velocity(){
        String neededNumberDirty = neededIteration.substring(15,18);
        String neededNumberClean = neededNumberDirty.replace(':','');
        String neededNumberTrim = neededNumberClean.trim();
        System.debug(neededNumberTrim);
        integer startingNumber = Integer.valueof(neededNumberTrim);
        system.debug(startingNumber);
        System.debug(neededNumberTrim);
        List<String> searchStatements = new List<String>();
        searchStatements.add(iterationMap.get(startingNumber -1));
        System.debug('@@@@@@'+iterationMap.get(startingNumber -1));
        searchStatements.add(iterationMap.get(startingNumber -2));
        System.debug('@@@@@@'+iterationMap.get( startingNumber -2));
        searchStatements.add(iterationMap.get(startingNumber -3));
        System.debug('@@@@@@'+iterationMap.get(startingNumber -3));
        
        allRelevantStories = new list<Story__c>();
        allRelevantStories = [Select id, name, Iteration__c, Points__c from Story__c where Iteration__c in:searchStatements and Points__c != null And Type__c='Operational' and (Status__c = 'Completed'
                                                                                                                                                                                 or Status__c = 'Closed')];
        Integer total = 0;
        
        for(Story__c thisStory : allRelevantStories){
            total += (Integer)thisStory.Points__c;
        }
        velocity = total/3;
        List<Story__c> currentPointStories = [Select id, name, Iteration__c, Points__c from Story__c where Iteration__c = :neededIteration and
                                           Points__c != null And Type__c='Operational' and (Status__c = 'Completed' or Status__c = 'Closed')];
        currentPoints=0;
        
        for(Story__c thisStory : currentPointStories){
            
            currentPoints += (Integer)thisStory.Points__c;
        }
        
        allStories();
        System.debug(total);
        System.debug(searchStatements);
        System.debug(allRelevantStories.size());  
        
    }
    
    public void allStories(){
        storiesReadyForQa = new List<Story__c>();
        
        List<Story__c> qaRelevantStoriesdirty = [Select id, name, Code_Review_Items__c,
                                                 Code_Reviews__c, QA_Plan__c, Points__c, Story_Leads__c from Story__c where iteration__c = :neededIteration And Status__c = 'Completed' And Type__c = 'Operational'];
        
        qaRelevantStories = new List<Story__c>();
        
        for(Story__c thisStory: qaRelevantStoriesdirty){
            if(thisStory.Code_Review_Items__c== null){
                thisStory.Code_Review_Items__c = 'Empty';
            } else{
                thisStory.Code_Review_Items__c = 'Done';
            }
            
            if(thisStory.Code_Reviews__c == null){
                thisStory.Code_Reviews__c = 'Empty';
            }else{
                thisStory.Code_Reviews__c = 'Done';
            }
            
            if(thisStory.QA_Plan__c == null){
                thisStory.QA_Plan__c = 'Empty';
            }else{
                thisStory.QA_Plan__c = 'Done';
            }
            if(thisStory.Code_Review_Items__c == 'Done' && thisStory.Code_Reviews__c == 'Done' && thisStory.QA_Plan__c == 'Done'){
                storiesReadyForQa.add(thisStory);
            }
            if(thisStory.Code_Review_Items__c != 'Done' || thisStory.Code_Reviews__c != 'Done' || thisStory.QA_Plan__c != 'Done'){
                qaRelevantStories.add(thisStory);
            }
            qaRelevantBlockedStories = new List<Story__c>();
            qaRelevantBlockedStories = [Select id, name, Blocked_Reason__c, Story_Leads__c from Story__c where iteration__c = :neededIteration and Status__c = 'Blocked' And Type__c ='Operational'];
            
            
            
        }
        missingStories = new List<Story__c>();
        missingStories = [Select id, name, Points__c,Code_Reviews__c,
                          Code_Review_Items__c,QA_Plan__c,QA_Results__c,Story_Leads__c
                          from Story__c where Deployment__c = null and iteration__c =:neededIteration and Type__c = 'Operational'];
        System.debug(qaRelevantStories);
        System.debug(neededIteration);
        System.debug(qaRelevantStories);
        
    }
    
    public void allCases(){
        oldestCases = new List<Case>();
        blockedCases = new List<Case>();
        urgentCases = new List<Case>();
        missingDeployments = new List<Case>();
        List<Case> allCasesDirty = [Select id, Status, Age__c, Priority, CaseNumber, subject from Case where Type != 'Feature Request' And RecordType.name ='Tech Request' And (status != 'Closed' And status != 'Completed'
                                                                                                                                                                                And status != 'Requested'
                                                                                                                                                                                And status != 'Declined') Order By Age__c Desc];
        
        for(Case thisCase : allCasesDirty){
            if(thisCase.Status == 'Blocked'){
                blockedCases.add(thisCase);
            }
        }
        
        System.debug(blockedCases.size());
        
        for(Case thisCase : allCasesDirty){
            if(thisCase.Priority == 'Urgent'){
                urgentCases.add(thisCase);
                
            }
        }
        Integer breakOutOfUrgent = 0;
        for(Case thisCase : allCasesDirty){
            
            if(thisCase.status !='Blocked' && thisCase.Priority != 'Urgent'){
                oldestCases.add(thisCase);
                breakOutOfUrgent++;
            }
            if(breakOutOfUrgent>5){
                break;
            }
        }
        
        missingDeployments = [Select id, subject,CaseNumber,Status from Case where Deployment__c = null and Requires_QA__c= true and Status ='Completed' and
                              RecordType.name = 'Tech Request'];
        
        
        System.debug(baseUrl);
        System.debug(urgentCases.size());
        System.debug(allCasesDirty.size());
    }
    
}