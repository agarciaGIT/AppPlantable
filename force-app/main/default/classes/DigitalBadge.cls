public without sharing class DigitalBadge{
    
    public Contact userCont { get; set; }
    public string Name {get; set;}
    public string FRMYearCertified {get; set;}
    public string ERPYearCertified {get; set;}
 
    public DigitalBadge() {
        List<Contact> lstCont = [select  Id, Name, GARP_ID__c, Fax, KPI_ERP_Certified_Date__c, KPI_FRM_Certified_Date__c, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c from Contact 
                                 where id = :ApexPages.currentPage().getParameters().get('id')]; 
                 
        System.Debug('lstCont:'+ lstCont );

        if(lstCont != null && lstCont.size() > 0) {
            userCont = lstCont[0];
            Name = lstCont[0].name;
            if(lstCont[0].KPI_FRM_Certified_Date__c != NULL)
                FRMYearCertified = String.ValueOf( lstCont[0].KPI_FRM_Certified_Date__c.year() );
            if(lstCont[0].KPI_ERP_Certified_Date__c!= NULL)
                ERPYearCertified = String.ValueOf( lstCont[0].KPI_ERP_Certified_Date__c.year() );
         
        } else {
            lstCont = [select  Id, Name, GARP_ID__c, Fax, KPI_ERP_Certified_Date__c, KPI_FRM_Certified_Date__c, KPI_CPE_Current_Cycle__c, KPI_CPE_Last_Completed_Cycle__c from Contact 
                         where GARP_Member_ID__c = :ApexPages.currentPage().getParameters().get('id')]; 
            if(lstCont != null && lstCont.size() > 0) {
                userCont = lstCont[0];
                Name = lstCont[0].name;
            if(lstCont[0].KPI_FRM_Certified_Date__c != NULL)
                FRMYearCertified = String.ValueOf( lstCont[0].KPI_FRM_Certified_Date__c.year() );
            if(lstCont[0].KPI_ERP_Certified_Date__c!= NULL)
                ERPYearCertified = String.ValueOf( lstCont[0].KPI_ERP_Certified_Date__c.year() );
            }                         
        }     
        System.Debug('userCont :'+ userCont );  
        System.Debug('Name:'+ Name );  
        System.Debug('FRMYearCertified :'+ FRMYearCertified );  
        System.Debug('ERPYearCertified :'+ ERPYearCertified  );  
    }
    
    public PageReference urlRedirection() {
        string url = ApexPages.currentPage().getUrl();
        System.Debug('url :'+ url );  
        
            if(userCont != null && ((String.isNotBlank(FRMYearCertified) && url.indexOf('DigitalBadgeFRM') != -1) || (String.isNotBlank(ERPYearCertified) && url.indexOf('DigitalBadgeERP') != -1)))
            {
                return null;
            }
            else
            {
                PageReference page = new PageReference('https://www.garp.org/');
                page.setRedirect(true);
                return page;
            }
    }
}