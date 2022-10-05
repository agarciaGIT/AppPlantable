@RestResource(urlMapping='/plant_sswebhooks/*')
global class Plant_RESTShipStationWebhooks {

    @TestVisible
    public class respHook {
        String resource_url;
        String resource_type;
    }
    
    public static void processWebhook(RestRequest req) {
        
        String reqJson;
        if(Test.isRunningTest()){
            reqJson = '{"resource_url":"https://ssapi13.shipstation.com/shipments?storeID=392054&batchId=31917939&includeShipmentItems=False","resource_type":"SHIP_NOTIFY"}';
        } else {
            reqJson = req.requestBody.toString();
        }
        System.debug('reqJson:' + reqJson);
        
        respHook respHK = (respHook)JSON.deserialize(reqJson, respHook.class);
        if(respHK.resource_type == 'SHIP_NOTIFY') {
            Plant_ShipStation_BC.ss_shipments shipments = Plant_ShipStation_BC.getWebHookData(respHK.resource_url);
            System.debug('shipments:' + shipments);
            
            if(shipments != NULL && shipments.shipments != NULL && shipments.shipments.size() > 0) {
                MAP<String,Plant_ShipStation_BC.ss_shipment> mapShipments = new MAP<String,Plant_ShipStation_BC.ss_shipment>();
                for(Plant_ShipStation_BC.ss_shipment ss :shipments.shipments) {
                    mapShipments.put(ss.orderKey, ss);
                }
                Plant_ShipStation_BC.processShipmentShipped(mapShipments);
            }
        }
        
        API_Request__c apir = new API_Request__c(
            Request_Type__c = 'ShipStation',
            Response__c = 'Webhook',
            Raw_Request__c = reqJson
        );
        insert apir;              
        
    }
    
    @HttpPost
    global static void postWebHook() {
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        processWebhook(req);            
        
    }
}