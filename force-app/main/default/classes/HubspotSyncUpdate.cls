public class HubspotSyncUpdate {
    
    @InvocableMethod(label='HubSpotSync' description='Sync HubSpot')
    public static List<string> syncMethod(){
        
        //Hubspot_Auth__mdt hb = Hubspot_Auth__mdt.getInstance('Hubspot_API');
        // Hubspot_Auth__mdt hb = Hubspot_Auth__mdt.getAll().values;
         //Map<String, Hubspot_Auth__mdt> hb = Hubspot_Auth__mdt.getAll();
         //for(String nameEmailDomain : mapEd.keySet()){
  

        
        Hubspot_Auth__mdt hb = [SELECT Id,MasterLabel,Authorization__c,EndPoint__c, River_Id__c from Hubspot_Auth__mdt WHERE MasterLabel ='Hubspot API'];
        System.debug('hb'+hb);

        System.Debug('hb.EndPoint__c:' + hb.EndPoint__c);
        System.Debug('hb.River_Id__c:' + hb.River_Id__c);
        System.Debug('hb.Authorization__c:' + hb.Authorization__c);    
        System.Debug('hb.Authorization__c len:' + hb.Authorization__c.length());             


        HubSpotRequest request = new HubSpotRequest();
        request.river_id = hb.River_Id__c;
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(hb.EndPoint__c);        
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        
        //req.setHeader('accept', 'application/json');
        
        req.setBody(JSON.serialize(request));
        
        System.Debug('Body:' + req.getBody()); 
        
        //String auth = 'eyJhbGciOiJIUzI1NiIsImV4cCI6MTk2ODY3MjgxMiwiaWF0IjoxNjUzMzEyODEyfQ.eyJhY2MiOiI1ZmI4MTQyZWY1NjgyYzY1NDgyM2MxMTMiLCJzY29wZXMiOnsiNjAxYzM4ZmRmNTY4MmMyYWZlZTU0OWViIjpbInJpdmVyOmV4ZWN1dGUiXX0sInRva2VuX25hbWUiOiJSaXZlcnlFeGVjIiwiaXNzIjoiNjBhZmMyYzNmNTY4MmMzNWIzMmNjNmI2IiwianRpIjoiYTc1M2I2ZTlkYWQ1NDQzYWI1NzBjZTc5NjNkZDNlNzciLCJlbnYiOiI2MDFjMzhmZGY1NjgyYzJhZmVlNTQ5ZWIiLCJzdWIiOiJSaXZlcnkgQVBJIn0.s1g-iFdOAncC-uf56_rosVi0WqJsPUCuFSZJp7HSrO8';
        
        //req.setHeader('Authorization','Bearer '+auth);
         req.setHeader('Authorization','Bearer '+hb.Authorization__c);
        system.debug(request);
        HttpResponse response = http.send(req);
        
        system.debug('response == '+response);
        String result = '';
        
        if (response.getStatusCode() == 200 || response.getStatusCode() == 201) // 200 or 201
        {
            result = 'Sync Request Succeeded';
        } else{
            result = 'Sync Request Failed with Error:' + response.getStatusCode() + ':' + response.getStatus();
        }
        return new List<String>{result}; 
    }
    
    public class HubSpotRequest{
        public string river_id;
    }

}