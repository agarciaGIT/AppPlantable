public class ExamSelectionOptions {

    public List<Exam> exams { get; set; }
    public List<Exam> options { get; set; }

    // Members defined as transient so they are not included in JSON serialization
    private transient Map<Id, Exam_Part__c> examPartsMap { get; set; }
    private transient Map<Id, Exam_Administration__c> examAdministrationMap { get; set; }
    private transient Map<Id, Exam__c> examMap { get; set; }    
    private transient Map<Id, Map<Id, Map<Id, Exam_Sites__c>>> examSiteByExamPartByExamMap { get; set; }
    private transient Map<Id, ExamPricebookEntry> examPriceBookEntriesMap { get; set; }

    public class Site{
        public String id									{ get; set; }
        public String label									{ get; set; }
        public Site__c site 								{ get; set; }
        public Exam_Sites__c examSite                       { get; set; }
    }

    public class ExamPart {
        public String id									{ get; set; }
        public String labelNoPrice							{ get; set; }
        public String label									{ get; set; }
        public Exam_Part__c examPart       	                { get; set; }                   
        public ExamPricebookEntry examPricebookEntry        { get; set; }
        public List<Site> sites                             { get; set; } 
    }

    public class ExamPricebookEntry{
        public String id									        { get; set; }
        public Exam__c exam 								        { get; set; }
        public String examAdminID							        { get; set; }
        public PricebookEntry pricebookEntry 				        { get; set; }
        public String rateType				 				        { get; set; }
        public List<ExamPricebookEntry> otherRates					{ get; set; }
    }

    public class Exam{
        public String id									    { get; set; }
        public String label									    { get; set; }  
        //public String labelNoPrice							    { get; set; }  
        public Integer numberOfCombinedExamParts                { get; set; }
        public Exam__c exam 								    { get; set; }
        public ExamPricebookEntry examPricebookEntry            { get; set; }
        public List<ExamPart> examParts                         { get; set; }
    }

    private void createHierarchy(Map<Id, Exam_Sites__c> examSitesMap){
                
        // Map of Exam Parts by Id
        this.examPartsMap = new Map<Id, Exam_Part__c>();
        for(Exam_Sites__c es: examSitesMap.values()){
            this.examPartsMap.put(es.Exam_Part__c, es.Exam_Part__r);
        }

        // Map of Exams by Id
        this.examMap = new Map<Id, Exam__c>();
        for(Exam_Sites__c es: examSitesMap.values()){
            this.examMap.put(es.Exam__c, es.Exam__r);
        }

        // Data structure used create exam selection hierarchy 
        this.examSiteByExamPartByExamMap = new Map<Id, Map<Id, Map<Id, Exam_Sites__c>>>();

        // Group By Exam
        for(Exam_Part__c ep: this.examPartsMap.values()){
            this.examSiteByExamPartByExamMap.put(ep.Exam__c, new Map<Id, Map<Id, Exam_Sites__c>>());
        }

        // Group by Exam Part
        for(Exam_Part__c ep: examPartsMap.values()){
            if(this.examSiteByExamPartByExamMap.containsKey(ep.Exam__c)){
                Map<Id, Map<Id, Exam_Sites__c>> examSiteByExamAdministration = this.examSiteByExamPartByExamMap.get(ep.Exam__c);
                examSiteByExamAdministration.put(ep.Id, new Map<Id, Exam_Sites__c>());
            }
        }

        // Group By Exam Site
        for(Exam_Sites__c es: examSitesMap.values()){
            if(this.examSiteByExamPartByExamMap.containsKey(es.Exam__c)){
                Map<Id, Map<Id, Exam_Sites__c>> examSiteByExamAdministrationMap = this.examSiteByExamPartByExamMap.get(es.Exam__c);
                if(examSiteByExamAdministrationMap.containsKey(es.Exam_Part__c)){
                    Map<Id, Exam_Sites__c> examSiteMap = examSiteByExamAdministrationMap.get(es.Exam_Part__c);
                    examSiteMap.put(es.Id, es);
                }
            }
        }

    }

    public void createExamsArray(){

        this.exams = new List<Exam>();

        //if(!this.examMap.isEmpty() && !this.examPriceBookEntriesMap.isEmpty()){
        if(!this.examMap.isEmpty()){

            // Creates exams array
            for(Integer i = 0; i < examMap.values().size(); i++){          
   
                Id examId = new List<Id>(examMap.keySet())[i];
                Exam__c examObject = examMap.get(examId);
                //ExamPricebookEntry examPricebookEntry = this.examPriceBookEntriesMap.get(examId);

                Exam exam = new Exam(); 

                if(i == 0){

                    // AG 10/18/2022 - Exams 2023
                    //Decimal totalPrice = examPricebookEntry.pricebookEntry.UnitPrice;
                    exam.id     = examObject.Id;
                    exam.label  = examObject.Name;    
                    //exam.label  = examObject.Name + ' - USD ' + totalPrice;    
                    //exam.labelNoPrice = examObject.Name;

                }else if(i == 1){

                    Id lastExamId = (i == 1) ? new List<Id>(examMap.keySet())[i - 1] : null;
                    Exam__c lastExamObject = examMap.get(lastExamId);
                    ExamPricebookEntry lastExamPricebookEntry = this.examPriceBookEntriesMap.get(lastExamId);

                    //Decimal totalPrice = lastExamPricebookEntry.pricebookEntry.UnitPrice + examPricebookEntry.pricebookEntry.UnitPrice;
                    exam.id     = examObject.Id;
                    //exam.label  = lastExamObject.Name + ' and ' + examObject.Name + ' - USD ' + totalPrice;    
                    exam.label  = lastExamObject.Name + ' and ' + examObject.Name;    

                }

                exam.numberOfCombinedExamParts = i + 1;
                exam.exam = examObject;
                //exam.examPricebookEntry = examPricebookEntry;

                this.exams.add(exam);   

            }

        }

    }

    public void createOptionsArray(){

        this.options = new List<Exam>();

        if(!this.examMap.isEmpty() && !this.examPriceBookEntriesMap.isEmpty()){

            // Creates options array
            for(Id key: examMap.keySet()){
                
                Exam exam = new Exam();
                Exam__c examObject = examMap.get(key);
                    
                exam.id     = examObject.Id;
                exam.label  = examObject.Name;
                exam.exam   = examObject;
                //exam.examPricebookEntry = this.examPriceBookEntriesMap.get(key);
                exam.examParts = new List<ExamPart>();              

                Map<Id, Map<Id, Exam_Sites__c>> examSiteByExamPartMap = this.examSiteByExamPartByExamMap.get(examObject.Id);
                if(examSiteByExamPartMap != NULL) {
                    
                    for(Id examPartId: examSiteByExamPartMap.keySet()){
    
                        ExamPart examPart = new ExamPart();
                        examPart.id = examPartId;
                    
                        Exam_Part__c ep = this.examPartsMap.get(examPartId);
                        
                        // Lookup Price
                        examPart.examPricebookEntry = this.examPriceBookEntriesMap.get(examPartId);
    
                        if(ep.Exam_Date__c != null){
                            Date d = ep.Exam_Date__c;
                            Time t = Time.newInstance(0, 0, 0, 0);
                            DateTime dt = DateTime.newInstance(d, t);
                            examPart.label = dt.format('MMMM dd, yyyy')  + ' - USD ' + examPart.examPricebookEntry.pricebookEntry.UnitPrice;
                            examPart.labelNoPrice = dt.format('MMMM dd, yyyy');
                        }else if(ep.Exam_Start_Date__c != null && ep.Exam_End_Date__c != null){
                            Date startDate = ep.Exam_Start_Date__c;
                            Date endDate = ep.Exam_End_Date__c;
                            Time t = Time.newInstance(0, 0, 0, 0);
                            DateTime startDateTime = DateTime.newInstance(startDate, t);
                            DateTime endDateTime = DateTime.newInstance(endDate, t);
                            examPart.label = startDateTime.format('MMMM dd, yyyy') + ' - ' + endDateTime.format('MMMM dd, yyyy')  + ' - USD ' + examPart.examPricebookEntry.pricebookEntry.UnitPrice;
                            examPart.labelNoPrice = startDateTime.format('MMMM dd, yyyy') + ' - ' + endDateTime.format('MMMM dd, yyyy');
                        }else{
                            examPart.label = 'Configure Exam_Administration__c Exam_Date__c or Exam_Start_Date__c and Exam_End_Date__c.';
                        }
                        
                        examPart.examPart = ep;
                        examPart.sites = new List<Site>();
    
                        Map<Id, Exam_Sites__c> examSiteMap = examSiteByExamPartMap.get(examPartId);
                        for(Exam_Sites__c examSite: examSiteMap.values()){
                            Site site = new Site();
                            site.id = examSite.Id;
                            site.label = examSite.Name;
                            site.site = examSite.Site__r;
                            site.examSite = examSite;
                            examPart.sites.add(site);
                        }
    					
                        exam.examParts.add(examPart);
    
                    }
                    
                	this.options.add(exam);
                }
                                
            }

        }

    }

    public ExamSelectionOptions(Map<Id, Exam_Sites__c> examSitesMap, Map<Id, ExamPricebookEntry> examPriceBookEntriesMap) {
        this.examPriceBookEntriesMap = examPriceBookEntriesMap;
        this.createHierarchy(examSitesMap);
    }

}