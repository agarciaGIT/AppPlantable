@RestResource(urlMapping='/inventory/*')
global class RESTInventoryController {

    public class respInventoryAvailableItem {
        String Month;
        String Day;
        Integer Menu;
        String shipDate;
        String skipDate;
        Boolean soldOut;
    }

    public static Date parseShippingDate(String sdate) {
        //String sdate = 'February 18, 2019';
        Date finalDate = null;
        //sdate = sdate.replaceAll('\\n', '');
        //sdate = sdate.replaceAll('\\s{2,}', '');
        
        //system.assert(false, 'BOOM!setOrderNew:'+ sdate + ':');
        
        if(sdate != null) {
            String[] sParts = sdate.split(' ');
            
            //system.assert(false, 'BOOM!setOrderNew:'+ sParts + ':');
            
            if(sParts.size() > 1) {
                List<String> dateParts = new List<String>();
                for(String p :sParts) {
                    dateParts.add(p.replace(',',''));
                }
                system.debug('dateParts: ' + dateParts); 
                String sMonth = dateParts[0];
                Integer m;
                if(sMonth == 'January')
                    m=1;
                else if(sMonth == 'February')
                    m=2;
                else if(sMonth == 'March')
                    m=3;
                else if(sMonth == 'April')
                    m=4;
                else if(sMonth == 'May')
                    m=5;
                else if(sMonth == 'June')
                    m=6;
                else if(sMonth == 'July')
                    m=7;
                else if(sMonth == 'August')
                    m=8;
                else if(sMonth == 'September')
                    m=9;
                else if(sMonth == 'October')
                    m=10;
                else if(sMonth == 'November')
                    m=11;
                else if(sMonth == 'December')
                    m=12;
                system.debug('m: ' + m);
                
                finalDate = date.newInstance(Integer.valueOf(dateParts[2]), m, Integer.valueOf(dateParts[1]));
                system.debug('finalDate: ' + finalDate);
            }
        }
        //system.assert(false, 'BOOM!setOrderNew:'+ finalDate + ':');
        return finalDate;
        
    }
    
    public static respInventoryAvailableItem processGetDate(String sdate, String prod) {
    
        respInventoryAvailableItem riai = new respInventoryAvailableItem ();
        Date dtShipDate = parseShippingDate(sdate);
        riai.Month = String.ValueOf(dtShipDate.month() + 1);
        riai.Day = String.ValueOf(dtShipDate.day());
        riai.Menu = 4;
        
        riai.shipDate = null;
        riai.soldOut = true;
        
        riai.skipDate = String.ValueOf(dtShipDate - 3);
        List<Inventory_Projection__c> lstInvProj = [select Id, Name, Shipping_Date__c, Computed_Left__c, QuickStart_Left__c, Reboot_Left__c, Subscription_Left__c from Inventory_Projection__c where Shipping_Date__c = :dtShipDate];
        System.debug('lstInvProj:' + lstInvProj + ':');
        
        prod = prod.toLowerCase();
        
        if(lstInvProj != null && lstInvProj.size() > 0) {
            riai.shipDate = sdate;
            
            if(prod=='reboot') {
                if(lstInvProj[0].Reboot_Left__c  <= 0) {
                    riai.soldOut = True;    
                } else {
                    riai.soldOut = False;
                }
                
            } else if(prod=='quickstart') {
                if(lstInvProj[0].QuickStart_Left__c  <= 0) {
                    riai.soldOut = True;    
                } else {
                    riai.soldOut = False;
                }
                
            } else if(prod.indexOf('subscription') > -1) {
                if(lstInvProj[0].Subscription_Left__c  <= 0) {
                    riai.soldOut = True;    
                } else {
                    riai.soldOut = False;
                }

            } else {
                if(lstInvProj[0].Computed_Left__c  <= 0) {
                    riai.soldOut = True;    
                } else {
                    riai.soldOut = False;
                }
            }
            
        }
        
        return riai;
        
    }
    
    @HttpGet  
    global static Void getIventory() {   
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        String strDate = req.params.get('date');
        String prod = req.params.get('product');
        if(strDate != NULL) {
            respInventoryAvailableItem pgd =processGetDate(strDate,prod);
            
            String jsonBody = JSON.serialize(pgd); 
            res.addHeader('Content-Type', 'application/json');
            res.addHeader('Access-Control-Allow-Origin', '*');
            res.responseBody = Blob.valueOf(jsonBody);
            res.statusCode = 200;
            
        }
        
    }
    
}