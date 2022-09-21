public class onFleetLabelsAsPDF {
    
    public List<shipmentPageWrapper> lstAllShipments  {get; set;}
    public String marginTopBottom {get; set;}
    public String boxheight {get; set;}
    public String inProvider {get; set;}
    
    public onFleetLabelsAsPDF() {        
        
        String strShipdate = '11/02/2017';
        String provider;
        String type;
        String boxtype;
        if(Test.isRunningTest()){
            strShipdate = '11/02/2017';
            provider = 'OnFleet';
            boxtype = 'E28';
        } else {
            strShipdate = ApexPages.currentPage().getParameters().get('shipdate');
            provider = ApexPages.currentPage().getParameters().get('provider');            
            type = ApexPages.currentPage().getParameters().get('type');            
            boxtype = ApexPages.currentPage().getParameters().get('boxtype');            
        }
        
        inProvider = provider;
        
        Date shipDate;
        if(strShipdate == NULL) {
            date myDate = date.today();
            date weekStart = myDate.toStartofWeek();
            weekStart = weekStart.addDays(1);
            Integer daySince = myDate.daysBetween(weekStart);
            if(daySince == 0)
                shipDate = weekStart;
            else shipDate = weekStart.addDays(7); 
        } else {
            shipDate = Date.parse(strShipdate);            
        }
            
        
        System.debug('strShipdate: ' + strShipdate);
        System.debug('provider: ' + provider);
        System.debug('type: ' + type);
        System.debug('boxtype: ' + boxtype);
        System.debug('shipDate: ' + shipDate);
        
        if(provider == null && type.toLowerCase() == 'brooklyn')
            provider = 'Brooklyn Sort';
        else if(provider == null && type.toLowerCase() == 'manhattan')
            provider = 'Manhattan Sort';
        
        List<Shipment__c> ships;
        String status = 'Cancelled';
        
        
        System.debug('shipDate: ' + shipDate);
        System.debug('provider: ' + provider);
        System.debug('boxtype: ' + boxtype);
        System.debug('status: ' + status);
        
        if(provider.toLowerCase() == 'ups') {

            ships = [select Id, Name, First_Name__c, Last_Name__c, Street1__c, Street2__c, City__c, State__c, Zip__c, Status__c, Account_Shopify_Customer_Id__c, Tracking_Number__c  from Shipment__c where Scheduled_Date__c = :shipDate and Shipping_Type__c = :provider and Status__c != :status and Is_Test__c = False];

        } else {
            
            if(boxtype.toLowerCase() == 'new') {
                ships = [select Id, Name, First_Name__c, Last_Name__c, Street1__c, Street2__c, City__c, State__c, Zip__c, Status__c, Account_Shopify_Customer_Id__c, Tracking_Number__c  from Shipment__c where Scheduled_Date__c = :shipDate and Shipping_Type__c = :provider and Status__c != :status AND Is_New__c = True AND Is_Test__c = False];
            } else if(boxtype != Null) {
                ships = [select Id, Name, First_Name__c, Last_Name__c, Street1__c, Street2__c, City__c, State__c, Zip__c, Status__c, Account_Shopify_Customer_Id__c, Tracking_Number__c  from Shipment__c where Scheduled_Date__c = :shipDate and Shipping_Type__c = :provider and Status__c != :status AND Box_Type__c = :boxtype AND Is_New__c = False AND Is_Test__c = False];
            } else {
                ships = [select Id, Name, First_Name__c, Last_Name__c, Street1__c, Street2__c, City__c, State__c, Zip__c, Status__c, Account_Shopify_Customer_Id__c, Tracking_Number__c  from Shipment__c where Scheduled_Date__c = :shipDate and Shipping_Type__c = :provider and Status__c != :status AND Is_Test__c = False];
            }
        }
        Boolean odd = true;
        Integer cnt=1;
        Integer perPage = 10;
        marginTopBottom = '70';
        boxheight = '110';
        lstAllShipments = new List<shipmentPageWrapper>();
        List<shipmentWrapper> lstShipmentWrapper = new List<shipmentWrapper>();
        if(ships != null && ships.size() > 0) {
            for(Shipment__c ship :ships) {
                
                System.debug('ship: ' + ship); 
                shipmentWrapper sw;
                if(odd)                
                    sw = new shipmentWrapper(ship, 'odd');
                else sw = new shipmentWrapper(ship, 'even');
                    
                lstShipmentWrapper.add(sw);
                odd=!odd;
    
                if(math.mod(cnt,perPage) == 0 && cnt > 0) {
                    system.debug('Mod' + cnt);
                    system.debug('lstShipmentWrapper' + lstShipmentWrapper);
                    shipmentPageWrapper spw = new shipmentPageWrapper(lstShipmentWrapper);
                    lstAllShipments.add(spw);
                    
                    List<shipmentWrapper> newLstShipmentWrapper = new List<shipmentWrapper>();              
                    lstShipmentWrapper = newLstShipmentWrapper;
                }
                cnt++;
            }
            
            system.debug('lstShipmentWrapper size: ' + lstShipmentWrapper.size());
            
            system.debug('Done Left Over' + cnt);
            system.debug('Go until' + cnt);
            cnt--;
            while(math.mod(cnt,perPage) != 0) {
                shipmentWrapper sw;
                Shipment__c ship = new Shipment__c();
                ship.name = 'xxx';
                if(odd)                
                    sw = new shipmentWrapper(ship, 'odd');
                else sw = new shipmentWrapper(ship, 'even'); 
                
                lstShipmentWrapper.add(sw);
                odd=!odd;
                
                cnt++;
            }
            
            system.debug('lstShipmentWrapper size: ' + lstShipmentWrapper.size());
            
            if(lstAllShipments.size() >= 0) {
                system.debug('Left Over' + cnt);
                system.debug('lstShipmentWrapper' + lstShipmentWrapper);
                shipmentPageWrapper spw = new shipmentPageWrapper(lstShipmentWrapper);
                lstAllShipments.add(spw);
            }
        }
    } 

    public class shipmentPageWrapper
    {
        public List<shipmentWrapper> shipPage {get; set;}

        public shipmentPageWrapper(List<shipmentWrapper> sws) {
            shipPage = sws;
        }
    }
    
    public class shipmentWrapper
    {
        public string category {get; set;}
        public string fname {get; set;}
        public string lname {get; set;}
        public string street1 {get; set;}
        public string street2 {get; set;}
        public string city {get; set;}
        public string state {get; set;}
        public string zip {get; set;}
        public string col {get; set;}
        public string trackingNumber {get; set;}
        public string trackingImage {get; set;}
        
        public shipmentWrapper(Shipment__c s, String colIn)
        {
            category = s.Name;   
            fname = s.First_Name__c;
            lname = s.Last_Name__c;
            street1 = s.Street1__c;
            street2 = s.Street2__c;
            city = s.City__c;
            state = s.State__c;
            zip = s.Zip__c;
            col = colIn;
            trackingNumber = s.Tracking_Number__c;
            trackingImage = 'https://www.barcodesinc.com/generator_files/image.php?code=' + s.Tracking_Number__c + '&style=325&type=C128B&width=200&height=50';
        }
    }
}