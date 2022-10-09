public without sharing class DigitalBadgeSCR {
    
    public Contact userCont { get; set; }
    public string Name {get; set;}
    public string GARPID {get; set;}    
    public string SCRYearCertified {get; set;}
 
    public DigitalBadgeSCR() {
        SCRYearCertified = '';
        List<Contact> lstCont = [select  Id, Name, GARP_ID__c, Fax, KPI_SCR_Holder__c, KPI_SCR_Completion_Date__c, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c from Contact 
                 where id = :ApexPages.currentPage().getParameters().get('id') AND KPI_SCR_Holder__c = True]; 
        if(lstCont != null && lstCont.size() > 0) {
            userCont = lstCont[0];
            Name = lstCont[0].name;         
            GARPID  = lstCont[0].GARP_ID__c; 
            SCRYearCertified = String.valueOf(lstCont[0].KPI_SCR_Completion_Date__c.year());        
        }
    }
    
    public PageReference urlRedirection() {
        //Considering the user as not certified if the year is null or empty
        if(userCont == null || String.isBlank(SCRYearCertified)){
            string url = 'https://www.garp.org/';
            PageReference page = new PageReference(url);
            page.setRedirect(true);
            return page;
        }
        else{
            return null;   
        }
    }
}