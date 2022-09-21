public class studyShipmentDownloadPicker {
    
    public Date x_date    {get;set;}
    public String sdate    {get;set;}
    public String msg  {get;set;}
    public String lastMealUpdatedDate {get;set;}
    
    public studyShipmentDownloadPicker () {        
        List<IntegrationDateTimes__c> lstCust = [select LastDateTime__c from IntegrationDateTimes__c where Name = 'MealLastUpdated'];
        if(lstCust != NULL && lstCust.size() > 0) {
            lastMealUpdatedDate = lstCust[0].LastDateTime__c.format('MM/dd/yyyy h:mm aaa','America/New_York');
        }
    }
    
    public void setDateString() {
        DateTime dt = DateTime.newInstance(x_date.year(), x_date.month(), x_date.day());
        sdate = dt.format('yyyy-MM-dd');
    }
    
    public PageReference shipmentDownload() {
        PageReference pageRef = new PageReference('/apex/studyShipmentsDownload?dt=' + x_date);
        return pageRef;
    }

    public PageReference mealsDownload() {
        PageReference pageRef = new PageReference('/apex/studyMealsByOrderDownload?dt=' + x_date);
        return pageRef;
    }

}