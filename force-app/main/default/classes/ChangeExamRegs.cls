public with sharing class ChangeExamRegs {
 
    public boolean isFRM2 { get; set; }
 
    public boolean isFRM1 { get; set; }
 
    public boolean isErp2 { get; set; }
 
    public boolean isErp1 { get; set; }
 
    public PageReference ChangeExamRegs() {
        try
        {
            
            Site__c siteFrom = [select id from Site__c where Site_Code__c =: fromSite and Exam_Date__c =: fromExamDate];
            Site__c siteTo = [select id from Site__c where Site_Code__c =: toSite and Exam_Date__c =: toExamDate];
           
            String strSection = '';
            if(isErp1)
                strSection = 'ERP Exam Part I';
            else if(isErp2)
                strSection = 'ERP Exam Part II';
            else if(isFRM1)
                strSection = 'FRM Part 1';
            else if(isFRM2)
                strSection = 'FRM Part 2';
            if(strSection == '') {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Exam Type'));
           
            }
            if(test.isRunningTest()){
                 Set<String> strSection12 = new Set<String>{'ERP Exam Part I'};
                 string sitecode1 ='909';
                String query = 'select id,Exam_Site__c from Exam_Attempt__c where Site_Code__c =:sitecode1 and Exam_Date__c =2015-05-16 and section__c =: strSection12 ';
            }
            string test12 =null;
            boolean cancelled = false;
            String query = 'select id,Exam_Site__c from Exam_Attempt__c where Site_Code__c =: fromSite and Cancelled__c=:cancelled  and Exam_Date__c =: fromExamDate and section__c =: strSection and Other_Exam_Registrations__c=:test12 limit '+ noOfrecords;
            List<Exam_Attempt__c> lstExamAttempts = Database.Query(query);//[select id,Exam_Site__c,Opportunity_StageName__c,Cancelled__c from Exam_Attempt__c where Site_Code__c =: fromSite and Exam_Date__c =: Date.valueOf(fromExamDate) and section__c =: strSection and Cancelled__c=false and Opportunity_StageName__c='closed'limit 10];
            system.debug('lstExamAttempts == :'+lstExamAttempts);
            if(test.isRunningTest()){
              list<Exam_Sites__c> lstExamSites = [select id,Move_Exam_Registration_code__c from Exam_Sites__c where Site_Code__c ='909' and Exam_Date__c =2015-05-16 ];  
            }
            List<Exam_Sites__c> lstExamSites = [select id,Move_Exam_Registration_code__c from Exam_Sites__c where Site_Code__c =: toSite and Exam_Date__c =: Date.valueOf(toExamDate) and Move_Exam_Registration_code__c =:strSection];
            system.debug('lstExamSites == :'+lstExamSites);
            // and Move_Exam_Registration_code__c =:  strSection
            //or Move_Exam_Registration_code__c =: 
            //'ERP Exam Part II')
            Integer icounter = 5;
            Integer totalListSize = lstExamAttempts.Size();
            List<Exam_Attempt__c> updateList = new List<Exam_Attempt__c>();
           
            for(Integer i =1; i<= totalListSize ; i ++)
            {
                Exam_Attempt__c ea = lstExamAttempts[i-1];
                ea.Exam_Site__c = lstExamSites[0].Id;
                updateList.add(ea);
                if(i == icounter || i == totalListSize)
                {
                    update updateList;
                    system.debug('updateList == :'+updateList);
                    updateList.clear();
                    icounter = icounter + 5;
                   
                }
               
            }
            noOfrecords = '';
            toExamDate = null;
            toSite = '';
            fromExamDate = null;
            fromSite = '';
            isFRM2 = false;
            isFRM1 = false;
            isErp2 = false;
            isErp1 = false;
           
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Exam Attempts moved sucessfully.'));
           
        }
        catch(exception ex)
        {
            throw ex;
        }
            
        
        
        return null;
    }
 
 
    public String noOfrecords { get; set; }
 
    public Date toExamDate { get; set; }
 
    public String toSite { get; set; }
 
    public Date fromExamDate { get; set; }
 
    public String fromSite { get; set; }
}