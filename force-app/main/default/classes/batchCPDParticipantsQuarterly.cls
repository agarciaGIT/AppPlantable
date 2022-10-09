global class batchCPDParticipantsQuarterly implements Database.Batchable<sobject>,Database.StateFul{

    public String testId;  
    public String cycle;  
    
    global batchCPDParticipantsQuarterly(String cycle, String testId){
        
        this.testId = testId;
        this.cycle = cycle;
        
    }
  
  global Database.Querylocator start (Database.BatchableContext BC) {
    
      String cle = cycle;
      String strId = testId;
      String Paid_Active = 'Paid Active';
      String Lapsed_Active = 'Lapsed Active';
      String Paid_New = 'Paid New';
      String Lapsed_In_Active = 'Lapsed In-Active';
      String Paid_In_Active = 'Paid In-Active';
      
   /*   if(strId != null) {
            return Database.getQueryLocator('Select id, Name, KPI_CPE_Credits__c, CPE_Current_Cycle_Remaining_Credits__c, CPE_Current_Program_Requirement__c From Contact WHERE KPI_CPE_Current_Cycle__c = :cle and KPI_CPE_Participation__c = true and CPD_Last_Quarterly_Sent__c != Today and Id = :strId');
        } else {
            return Database.getQueryLocator('Select id, Name, KPI_CPE_Credits__c, CPE_Current_Cycle_Remaining_Credits__c, CPE_Current_Program_Requirement__c From Contact WHERE KPI_CPE_Current_Cycle__c = :cle and KPI_CPE_Participation__c = true and CPD_Last_Quarterly_Sent__c != Today');
        } */
     
      if(strId == 'clear') {
          return Database.getQueryLocator('Select id, Name, KPI_CPE_Credits__c, CPE_Current_Cycle_Remaining_Credits__c, CPE_Current_Program_Requirement__c From Contact WHERE CPD_Last_Quarterly_Sent__c != null');
      } else if(strId != null) {
          return Database.getQueryLocator('Select id, Name, KPI_CPE_Credits__c, CPE_Current_Cycle_Remaining_Credits__c, CPE_Current_Program_Requirement__c From Contact WHERE KPI_CPE_Current_Cycle__c = :cle and KPI_CPE_Participation__c = true and CPD_Last_Quarterly_Sent__c != Today and Id = :strId and (CPD_User_Type_Name__c = :Paid_Active OR CPD_User_Type_Name__c = :Lapsed_Active OR CPD_User_Type_Name__c = :Paid_New OR CPD_User_Type_Name__c = :Paid_In_Active OR CPD_User_Type_Name__c = :Lapsed_In_Active)');
      } else {
          return Database.getQueryLocator('Select id, Name, KPI_CPE_Credits__c, CPE_Current_Cycle_Remaining_Credits__c, CPE_Current_Program_Requirement__c From Contact WHERE KPI_CPE_Current_Cycle__c = :cle and KPI_CPE_Participation__c = true and CPD_Last_Quarterly_Sent__c != Today and (CPD_User_Type_Name__c = :Paid_Active OR CPD_User_Type_Name__c = :Lapsed_Active OR CPD_User_Type_Name__c = :Paid_New OR CPD_User_Type_Name__c = :Paid_In_Active OR CPD_User_Type_Name__c = :Lapsed_In_Active)');
      } 
      
 }     
   global void execute (Database.BatchableContext BC, List<Contact> scope) {
       
       List<contact> scopecont = new list<contact>();
       
       for (Contact c: scope) 
       { 
        
           if(testId == 'clear') {
               c.CPD_Last_Quarterly_Sent__c = NULL;   
           } else {
               c.CPD_Last_Quarterly_Sent__c = System.today();           
           }
           scopecont.add(c);    
           
       }
      if(!scopecont.isEmpty()) { 
      update scopecont;  
  }
}
  global void finish(Database.BatchableContext BC){}
  
  
}