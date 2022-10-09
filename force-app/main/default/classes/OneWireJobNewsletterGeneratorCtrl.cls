public class OneWireJobNewsletterGeneratorCtrl {
    
    public String searchType					{ get; set; }
    
    public String jobId							{ get; set; }
    public Job__c selectedJob					{ get; set; }
    public List<Job__c> jobs 					{ get; set; }
    public List<Job__c> selectedJobs			{ get; set; }
            
    public Integer offset						{ get; set; }
    public Integer pageNumber					{ get; set; }
    public Integer pages						{ get; set; }
    public Integer limitTo						{ get; set; }
    public String  searchString					{ get; set; }
    
    public Content_Selector__c contentSelector 	{ get; set; }
    
 	public Job__c   jobSObjectStartDate  		{ get; set; }
  	public Job__c 	jobSObjectEndDate         	{ get; set; }
    public String 	region              		{ get; set; }
    public String 	company             		{ get; set; }
    public String 	category            		{ get; set; }
    public String 	title						{ get; set; }
    public String	description					{ get; set; }
        
    public List<SelectOption> metadataLists 	{ get; set; }
    public String metadataListName      		{ get; set; }
    public String metadataListId        		{ get; set; }
    
    public String htmlTemplate					{ get; set; }
    
    public Date startDate						{ get; set; }
    public Date endDate							{ get; set; }
         
    public List<Id> convertCommaDelimitedListToList(String commaDelimitedList){
        List<Id> jobIds = new List<Id>();
        if(commaDelimitedList != null){
            for(String cdl: commaDelimitedList.split(',')){
                jobIds.add(cdl.trim());
            }
            return jobIds;
        }else{
            return null;
        }
    }
    
    public Integer getPageCount(Integer count){
        System.debug(count);
        return (math.mod(count, limitTo) == 0) ? (count / limitTo) : (count / limitTo) + 1;
    }
    
    public String convertListToCommaDelimitedList(List<Id> ids){ 
        return String.join(ids, ', ');
    }
    
    public List<Job__c> getSelectedJobsByIds(List<Id> ids){
        
        List<Job__c> ordered = new List<Job__c>();
        
        if(ids != null && !ids.isEmpty()){
        
            Map<Id, Job__c> jobs = new Map<Id, Job__c>([SELECT Id, Name, Company__c, Title__c, URL__c, Country__c, State__c, City__c FROM Job__c WHERE Id IN :ids]);
                        
            for(Id id: ids){
                if(jobs.containsKey(id)) ordered.add(jobs.get(id));
            }
                       
        }
        
        return ordered;
        
    }
    
    public Integer getSOQLRecordCount(List<Id> selectedJobs){
        
        String query = 'SELECT COUNT() FROM Job__c';
                                
        if(startDate != null || endDate != null || (region != null && region != '') || (company != null && company != '') || (category != null && category != '') || (selectedJobs != null && !selectedJobs.isEmpty()) || (title != null && title != '')){
            
            query += ' WHERE ';
            
            List<String> criteria = new List<String>();
                
            if(startDate	!= null) criteria.add('Published_Date__c >= :startDate');
            if(endDate 		!= null) criteria.add('Published_Date__c <= :endDate');
            
            if(region 		!= null && region 	!= '') criteria.add('(City__c LIKE \'%' + region + '%\' OR State__c LIKE \'%' + region + '%\' OR Country__c LIKE \'%' + region + '%\' OR Postal_Code__c LIKE \'%' + region + '%\')');
            
            if(company 		!= null && company 		!= '') criteria.add('Company__c 	LIKE \'%' + company + 		'%\'');
            if(category		!= null && category 	!= '') criteria.add('Category__c 	LIKE \'%' + category + 		'%\'');
            if(title		!= null && title 		!= '') criteria.add('Title__c 		LIKE \'%' + title + 		'%\'');
            
            if(selectedJobs != null && !selectedJobs.isEmpty()) criteria.add('Id NOT IN :selectedJobs');

            query += String.join(criteria, ' AND ');
            
        }

        return Database.countQuery(query);

    }
    
    public String getSOSLQueryString(List<Id> selectedJobs, String searchString, Integer limitTo, Integer offset){
        
        String query = 'FIND :searchString IN ALL FIELDS RETURNING Job__c(Id, Name, Category__c, City__c, Company__c, Country__c, Job_Type__c, Postal_Code__c, Published_Date__c, Reference_Number__c, Salary__c, Sponsored__c, State__c, Title__c, URL__c';
                        
        if(startDate != null || endDate != null || (region != null && region != '') || (company != null && company != '') || (category != null && category != '') || (selectedJobs != null && !selectedJobs.isEmpty()) || (title != null && title != '')){
            
            query += ' WHERE ';
            
            List<String> criteria = new List<String>();
                           
            if(startDate	!= null) criteria.add('Published_Date__c >= :startDate');
            if(endDate 		!= null) criteria.add('Published_Date__c <= :endDate');
            
            if(region 		!= null && region 		!= '') criteria.add('(City__c LIKE \'%' + region + '%\' OR State__c LIKE \'%' + region + '%\' OR Country__c LIKE \'%' + region + '%\' OR Postal_Code__c LIKE \'%' + region + '%\')');
            
            if(company 		!= null && company 		!= '') criteria.add('Company__c 	LIKE \'%' + company + 		'%\'');
            if(category		!= null && category 	!= '') criteria.add('Category__c 	LIKE \'%' + category + 		'%\'');
            if(title		!= null && title 		!= '') criteria.add('Title__c 		LIKE \'%' + title + 		'%\'');
            
            if(selectedJobs != null && !selectedJobs.isEmpty()) criteria.add('Id NOT IN :selectedJobs');

            query += String.join(criteria, ' AND ');
            
        }
        
        query += ' ORDER BY Title__c ASC';
        if(limitTo 	!= null) query += ' LIMIT ' + limitTo;
        if(offset 	!= null) query += ' OFFSET ' + offset;
        
        
        query += ')';
        System.debug(selectedJobs);
		System.debug(query);
		return query;
        
    }
        
    public Integer getSOSLRecordCount(List<Id> selectedJobs, String searchString){
       
		return Search.query(getSOSLQueryString(selectedJobs, searchString, null, null))[0].size();     
        
    }
    
    public List<Job__c> quickSearch(List<Id> selectedJobs, String searchString, Integer limitTo, Integer offset){
               
        pages = getPageCount(getSOSLRecordCount(selectedJobs, searchString));
              
        return Search.query(getSOSLQueryString(selectedJobs, searchString, limitTo, offset))[0];
        
    }
           
    public List<Job__c> filterBy(List<Id> selectedJobs, Integer limitTo, Integer offset){
        
        String query = 'SELECT Id, Name, Category__c, City__c, Company__c, Country__c, Description__c, Experience__c, Job_Type__c, Postal_Code__c, Published_Date__c, Reference_Number__c, Salary__c, Sponsored__c, State__c, Title__c, URL__c';
        
       	query += ' FROM Job__c';
                        
        if(startDate != null || endDate != null || (region != null && region != '') || (company != null && company != '') || (category != null && category != '') || (selectedJobs != null && !selectedJobs.isEmpty()) || (title != null && title != '')){
            
            query += ' WHERE ';
            
            List<String> criteria = new List<String>();
                
            if(startDate	!= null) criteria.add('Published_Date__c >= :startDate');
            if(endDate 		!= null) criteria.add('Published_Date__c <= :endDate');
            
            
            if(region 		!= null && region 		!= '') criteria.add('(City__c LIKE \'%' + region + '%\' OR State__c LIKE \'%' + region + '%\' OR Country__c LIKE \'%' + region + '%\' OR Postal_Code__c LIKE \'%' + region + '%\')');
            
            if(company 		!= null && company 		!= '') criteria.add('Company__c 	LIKE \'%' + company + 		'%\'');
            if(category		!= null && category 	!= '') criteria.add('Category__c 	LIKE \'%' + category + 		'%\'');
            if(title		!= null && title 		!= '') criteria.add('Title__c 		LIKE \'%' + title + 		'%\'');
            
            if(selectedJobs != null && !selectedJobs.isEmpty()) criteria.add('Id NOT IN :selectedJobs');

            query += String.join(criteria, ' AND ');
            
        }
        
        if(limitTo 	!= null) query += ' LIMIT ' + limitTo;
        if(offset 	!= null) query += ' OFFSET ' + offset;
                
        pages = getPageCount(getSOQLRecordCount(selectedJobs));
                
        return Database.query(query);

    }
    
    public void next(){
	
        if(pageNumber < pages){
            this.pageNumber++;
            this.offset = (this.pageNumber - 1) * this.limitTo;
            this.jobs = performActions();
        }
        
    }
    
    public void prev(){

        if(pageNumber > 1){
            this.pageNumber--;
            this.offset = (this.pageNumber - 1) * this.limitTo;
            this.jobs = performActions();
        }
        
    }
    
    public void moveDn(){
        
        Integer index = null;
        for(Integer i = 0; i < selectedJobs.size(); i++){
            if(selectedJobs[i].Id != jobId) continue;
            index = i;
        }
        
        if(index < selectedJobs.size() - 1){
            
            Job__c adj = selectedJobs[index + 1];
            selectedJobs[index + 1] = selectedJobs[index];
			selectedJobs[index] = adj;

        }
        
    }
    
    public void moveUp(){
        
        Integer index = null;
        for(Integer i = 0; i < selectedJobs.size(); i++){
            if(selectedJobs[i].Id != jobId) continue;
            index = i;
        }
        
        if(index > 0){
            
            Job__c adj = selectedJobs[index - 1];
            selectedJobs[index - 1] = selectedJobs[index];
			selectedJobs[index] = adj;

        }     
        
    }
    
    public void doSearch(){
        
        startDate 	= jobSObjectStartDate.Published_Date__c;
    	endDate		= jobSObjectEndDate.Published_Date__c;
        
        System.debug(startDate);
        System.debug(endDate);
        
        offset = 0;
        
        if(searchString != null && searchString != ''){
            searchType = 'SOSL';
            jobs = quickSearch(convertCommaDelimitedListToList(contentSelector.Content_IDs__c), searchString, limitTo, offset);                    
        }else{
            searchType = 'SOQL';
            jobs = filterBy(convertCommaDelimitedListToList(contentSelector.Content_IDs__c), limitTo, offset);          
        }
        
        pageNumber = (pages == 0) ? 0 : 1;   
        
    }
        
    public List<Job__c> performActions(){
        
        if(searchType == 'SOQL'){
			return filterBy(convertCommaDelimitedListToList(contentSelector.Content_IDs__c), limitTo, offset);           
        }else{
            return quickSearch(convertCommaDelimitedListToList(contentSelector.Content_IDs__c), searchString, limitTo, offset);
        }
        
    }
    
    public void doSelect(){

        if(jobId != null && jobId != ''){
        
            List<Id> selectedIds = new List<Id>();
            
            if(contentSelector.Content_IDs__c != null) selectedIds.addAll(convertCommaDelimitedListToList(contentSelector.Content_IDs__c));
            
            selectedIds.add(jobId);
            
            contentSelector.Content_IDs__c = convertListToCommaDelimitedList(selectedIds);
            
            UPDATE contentSelector;
            
            contentSelector = [SELECT Id, Name, Content_IDs__c FROM  Content_Selector__c WHERE Id = :contentSelector.Id LIMIT 1];
            
            selectedJobs = getSelectedJobsByIds(selectedIds);    
            jobs = filterBy(convertCommaDelimitedListToList(contentSelector.Content_IDs__c), limitTo, offset);
        
        }
        
    }
    
    public void doRemove(){
        
        if(jobId != null && jobId != ''){
        
            List<Id> selectedIds = new List<Id>();
            
            if(contentSelector.Content_IDs__c != null) selectedIds.addAll(convertCommaDelimitedListToList(contentSelector.Content_IDs__c));
            
            for(Integer i = 0; i < selectedIds.size(); i++){
                if(selectedIds[i] == jobId) selectedIds.remove(i);
            }
            
            contentSelector.Content_IDs__c = convertListToCommaDelimitedList(selectedIds);
            
            UPDATE contentSelector;
            
            contentSelector = [SELECT Id, Content_IDs__c FROM  Content_Selector__c WHERE Id = :contentSelector.Id LIMIT 1];
            
            selectedJobs = getSelectedJobsByIds(selectedIds);    
            
            jobs = filterBy(convertCommaDelimitedListToList(contentSelector.Content_IDs__c), limitTo, offset);
            
        }
        
    }
        
    public PageReference doOpen(){
       
        PageReference ref = ApexPages.currentPage();
        ref.setRedirect(true);
        ref.getParameters().put('metadataListId', this.metadataListId);
              
        return ref;
        
    }
    
    public PageReference doSaveAs(){
               
        if(this.metadataListName != '' && this.metadataListName != null){

            List<Content_Selector__c> existingMetadataLists = [SELECT Name FROM Content_Selector__c WHERE Name = :this.metadataListName];
        
            if(existingMetadataLists.isEmpty()){
                
                Content_Selector__c cs = new Content_Selector__c(
                    Name = this.metadataListName,
                    Application_Reference__c = 'OneWire Job Newsletter Generator'
                );
                
                INSERT cs;
                
                PageReference ref = ApexPages.currentPage();
                ref.setRedirect(true);
                ref.getParameters().put('metadataListId', cs.Id);
                      
                return ref;
                
            }else{
                
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'This job list name already exists, please select a different name.'));
                return null;
                
            }
                                  

        }else{
            
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.WARNING,'You must provide a name for this job list.'));
            return null;
            
        }
        
    }
        
    public PageReference doNew(){
        
        PageReference ref = new PageReference('/apex/OneWireJobNewsletterGenerator');
        ref.setRedirect(true);
        return ref;     
        
    }
        
    public void doGenerateHTML(){
        
		String html = '';
        
        for(Job__c job: selectedJobs){
            
            String company = (job.Company__c != null) ? job.Company__c.replaceAll('\\s', '').toLowerCase() : '';
            
            String url = job.URL__c;

			if(url.indexOf('?') >= 0){   
                url = url.substringBefore('?');
            }
               
            url += '?utm_content=garp&utm_source=' + company + '&utm_medium=emaill&utm_campaign=garpcareer';               
            
            html+= '<tr style="mso-yfti-irow:4">';
            html+= '    <td style="padding:5px 5px 5px 5px" valign="top">';
            html+= '        <span style="mso-fareast-font-family:\'Times New Roman\'">';
            html+= '        <img alt="Arrow" border="0" height="12" id="_x0000_i1031" src="http://go.pardot.com/l/39542/2014-10-23/4q15y/39542/39118/Arrow_167.gif" width="8"></span>';
            html+= '    </td>';
            html+= '    <td style="padding:5px 5px 5px 5px" valign="top">';
            html+= '    	<span style="font-size:10.0pt;font-family:\'Arial\',\'sans-serif\'; mso-fareast-font-family:\'Times New Roman\';color:black">';
            html+= '        	<a href="' + url + '" target="_blank">';
            html+= '         	   <b><span style="color:#006699">' + job.Title__c + '</span></b>';
            html+= '        	</a>,'; 
            html+= '        	' + job.Company__c + ', ' + job.City__c + ', ' + job.State__c + ', ' + job.Country__c;
            html+= '		</span>';
            html+= '    </td>';
            html+= '</tr>';                     

        }        
               
        htmlTemplate = html;
        
    }
        
    public void doSave(){
        
        List<Id> selectedIds =  new List<Id>();
        
        for(Job__c job: selectedJobs){
            selectedIds.add(job.Id);
        }
        
        contentSelector.Content_IDs__c = String.join(selectedIds, ', ');
        
        UPDATE contentSelector;
        
    }

    public PageReference doDelete(){
        
        DELETE contentSelector;
        
        PageReference ref = new PageReference('/apex/OneWireJobNewsletterGenerator');
        metadataListId = null;
        metadataListName = null;
        ref.setRedirect(true);
        return ref;
        
    }
    
    public OneWireJobNewsletterGeneratorCtrl(){
        
        PageReference ref = ApexPages.currentPage();
        
        this.offset = 0;
        this.pageNumber = 1;
        this.limitTo = 10;
        this.searchType = 'SOQL';
        
        this.jobSObjectStartDate = new Job__c();
        this.jobSObjectEndDate	= new Job__c();
        
        if(ref.getParameters().get('metadataListId') != null){
            
            this.metadataListId = ref.getParameters().get('metadataListId');
            
            this.contentSelector = [SELECT Id, Name, Content_IDs__c FROM Content_Selector__c WHERE Id = :this.metadataListId LIMIT 1];
            
            if(this.contentSelector != null){
                this.metadataListName = this.contentSelector.Name;
                this.jobs = filterBy(convertCommaDelimitedListToList(this.contentSelector.Content_IDs__c), limitTo, offset);
                this.selectedJobs = getSelectedJobsByIds(convertCommaDelimitedListToList(this.contentSelector.Content_IDs__c)); 
            }
         
        }
                
        this.metadataLists = new List<SelectOption>();
        this.metadataLists.add(new SelectOption('', '- Please Select -'));
        for(Content_Selector__c cs: [SELECT Id, Name, Application_Reference__c, Content_IDs__c FROM Content_Selector__c WHERE Application_Reference__c = 'OneWire Job Newsletter Generator']){
            this.metadataLists.add(new SelectOption(cs.Id, cs.Name));
        }
               
  }
    
}