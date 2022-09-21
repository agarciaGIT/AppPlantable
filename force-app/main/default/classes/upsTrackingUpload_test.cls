@isTest 
public class upsTrackingUpload_test {
    Static Shipment__c ship;

    public static void setup(){
        ship = new Shipment__c(Name='Ship', Delivery_Date__c=Date.newInstance(2018, 8, 1),Scheduled_Date__c=Date.newInstance(2018, 8, 1), Type__c = 'UPS', Status__c = 'Pending');
        insert ship;

    }
    
    @isTest
    private static void testMethods1(){
        setup();
        Test.startTest();    

		upsTrackingUpload utu = new upsTrackingUpload();
        utu.contentFile = BLob.valueOf('"A","B","C","D","E","F","G"\n"1Z30075A0397726106","" , "Delivered", "' + ship.Id + '", "8/6/18", "ALISON HELLMAN", "LARCHMONT, NY, US", "UPS Ground"');
        utu.shipment = new Shipment__c();
        utu.shipment.Scheduled_Date__c=Date.newInstance(2018, 8, 1);
	    utu.ReadFile();
        
        Test.stopTest();        

    }    
}