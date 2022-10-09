global without sharing class PerformanceAnalysisPDFController{
    
    private static final String SYS_DATE_FORMAT = 'MM/dd/yyyy h:mm a';
    
    global Exam_Attempt__c ea { get; set; }  
    global List<ExamResult> results { get; set; }
    
    global String sName { get; set; }
    global String sGARPID { get; set; }
      
    global PerformanceAnalysisPDFController() {
        results = new List<ExamResult>();
    }
    
    public class ExamResult {
    
        public ExamResult(String cat, Integer quart) {
            Category = cat;
            Quartile = quart;    
        }
        
        public String Category { get; set; }
        public Integer Quartile { get; set; } 
    }    
       
    global String getNow() {
       return System.now().format(SYS_DATE_FORMAT);
   }   
       
   global String getExamDate() {
       //Date examDate = ea.Exam_Date__c;
       //DateTime examDateTime = DateTime.newInstance(examDate.year(), examDate.month(), examDate.day());
       //return examDateTime.format('MMMMM dd, yyyy');
       return ea.RPT_Administration_Month__c + ' ' + ea.RPT_Administration_Year__c;
   }
       
       
    global void fetchData() {
        String eaId = ApexPages.currentPage().getParameters().get('id');     
        fetchDataForExamAttempt(eaId);
    }
     
    public void fetchDataForExamAttempt(Id examAttemptId) {
        ea = [
            select Id, Name, Section__c, CreatedDate,Exam_Date__c, RPT_Administration_Month__c, RPT_Administration_Year__c,
            Garp_Id__c, Member__r.Name, Category_1__c, Category_2__c, Category_3__c, Category_4__c, Category_5__c, Category_6__c, 
            Category_7__c, Category_8__c, Quartile_1__c, Quartile_2__c, Quartile_3__c, Quartile_4__c, Quartile_5__c, Quartile_6__c, Quartile_7__c, Quartile_8__c
            from Exam_Attempt__c 
            where Id = :examAttemptId AND Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c = FALSE
        ];
        
        if(ea != null) {
            sName = ea.Member__r.Name;
            sGARPID = ea.GARP_Id__c;
        }
        
        for (Integer i = 1; i <= 8; i++) {
            
            String quartileKey = 'Quartile_' + i + '__c';
            String categoryKey = 'Category_' + i + '__c';
            
            String category = (String) ea.get(categoryKey);
            if (String.isNotBlank(category)) {
                Decimal quartile = (Decimal) ea.get(quartileKey); 
                   
                ExamResult result = new ExamResult(category, quartile.intValue());
                results.add(result);
            }
        }
    }
     
    global Boolean getIsFRM1() {
        return ea.Section__c.equals('FRM Part 1');
    }
    
    global Boolean getIsFRM2() {
        return ea.Section__c.equals('FRM Part 2');
    }
    
    global Boolean getIsERP() {
        return ea.Section__c.equals('ERP');
    } 

    global Boolean getIsERP1() {
        return ea.Section__c.equals('ERP Exam Part I');
    } 

    global Boolean getIsERP2() {
        return ea.Section__c.equals('ERP Exam Part II');
    } 

    global Boolean getIsSCR() {
        return ea.Section__c.equals('SCR');
    } 

}