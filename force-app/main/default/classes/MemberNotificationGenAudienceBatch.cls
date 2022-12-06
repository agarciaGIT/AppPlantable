global class MemberNotificationGenAudienceBatch implements Database.Batchable<sObject>{
    
    public String RPT_Administration_Year;  
    public String RPT_Administration_Month;  
    public String RPT_Exam_Program;  
    public String RPT_Exam_Part;  
    public String Integration_Data_Status;  
    public String siteId;      
    public String notificationId;    
    
    global MemberNotificationGenAudienceBatch(String notificationIdIn, String examYear, String examMonth, String examProgram, String examPart, String integrationStatus, String siteIdIn) {
        System.debug('RPT_Administration_Year:' + examYear);
        System.debug('RPT_Administration_Month:' + examMonth);
        System.debug('RPT_Exam_Program:' + examProgram);
        System.debug('RPT_Exam_Part:' + examPart);
        System.debug('Integration_Data_Status:' + integrationStatus);
        System.debug('siteId:' + siteIdIn);
        System.debug('notificationId:' + notificationIdIn);
        
        this.RPT_Administration_Year= examYear;   
        this.RPT_Administration_Month = examMonth;
        this.RPT_Exam_Program = examProgram;
        this.RPT_Exam_Part = examPart;
        this.Integration_Data_Status = integrationStatus;
        this.siteId = siteIdIn;
        this.notificationId = notificationIdIn;

    }
    global Database.QueryLocator start(Database.BatchableContext BC){ 
        
        String query = 'SELECT Id, Member_Email__c, Garp_Id__c FROM Exam_Attempt__c WHERE Is_Test__c = FALSE AND Reg_Status__c not in (\'Cancelled\',\'Unpaid\',\'Deferred Out\') AND RPT_Administration_Year__c = :RPT_Administration_Year AND RPT_Administration_Month__c = :RPT_Administration_Month AND RPT_Exam_Program__c = :RPT_Exam_Program AND RPT_Exam_Part__c = :RPT_Exam_Part';
        System.debug('query:' + query);
        
        if(Integration_Data_Status != '') {
            query = query + ' AND Integration_Data_Status__c = :Integration_Data_Status';
        }
        if(siteId != NULL && siteId.length() > 0) {
            query = query + ' AND Exam_Site__r.Site_code__c = :siteId';
        }
        query = query + ' LIMIT 9999';
        System.debug('query final:' + query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Exam_Attempt__c> scope){
        MAP<String,Exam_Attempt__c> mapExamAttempt = new MAP<String,Exam_Attempt__c>();
        for(Exam_Attempt__c ea :scope) {
            mapExamAttempt.put(ea.Member_Email__c, ea);
        }
        
        List<Member_Notification_Recipient__c> addMemNotifys = new List<Member_Notification_Recipient__c>();
        for(Exam_Attempt__c ea :mapExamAttempt.values()) {
            Member_Notification_Recipient__c newMemNot = new Member_Notification_Recipient__c(
            	Member_Notification__c = this.notificationId,
                Email__c = ea.Member_Email__c,
                GARP_ID__c = ea.Garp_Id__c,
                Sending_Status__c = NULL
            );
            System.debug('newMemNot:' + newMemNot);
            addMemNotifys.add(newMemNot);
        }
        System.debug('addMemNotifys:' + addMemNotifys.size());
        insert addMemNotifys;
    }
    
    global void finish(Database.BatchableContext BC){
    }
    
}