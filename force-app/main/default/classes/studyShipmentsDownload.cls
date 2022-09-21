public class studyShipmentsDownload {
    
    public List<Shipment__c> lstShipments{get;set;}
    public String csvString {get;set;}
    
    public studyShipmentsDownload () {
        string sdate = ApexPages.currentPage().getParameters().get('dt');
        if(Test.isRunningTest()){
            sdate = '2020-03-02';      
        }        
        Date dt = date.valueOf(sdate);
        String userID = UserInfo.getUserId();
        
        csvString='Name,Order Number,Status,Shiment Date, Type\n';
        lstShipments = [select Id, Name, Status__c, Scheduled_Date__c, Shipping_Service_Type__c, Box_Type__c, Opportunity__r.Name, Opportunity__r.External_Order_Number_Display__c, Opportunity__r.Account.Name  from Shipment__c where Opportunity__r.Account.Study_Account_Owner_ID__c = :userID AND Study_Order__c = TRUE AND Scheduled_Date__c = :dt];
        for(Shipment__c ship :lstShipments) {
            csvString+= ship.Opportunity__r.Account.Name + ',' + 'MSK'+ ship.Opportunity__r.External_Order_Number_Display__c + ',' + ship.Status__c  + ',' + ship.Scheduled_Date__c + ',' + ship.Box_Type__c + '\n';
        }
        
    }
    
}