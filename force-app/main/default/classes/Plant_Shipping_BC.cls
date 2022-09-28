/*
*   @Desciption     :   Plantable Shipping and delivery date get, set handler
*   @Create date    :   05-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   Plant_Shipping_BC_Test
*/

public class Plant_Shipping_BC {
    
    // Default constructor
    public Plant_Shipping_BC() {
        
    }
    
    // @ Method 0 
    // @ desc:  Return list of available methods for this class
    public static Map<String,String> getClassDetail(){
        Map<String,String> metodsMap = new Map<String,String>();
        metodsMap.put('getAvailableDeliveryDates',Plant_Utility.setMethodEntry('getAvailableDeliveryDates', 'get', 'Plant_Utility.responseWrapper','deliveryDateWrapper wrapper object', 'Returns all available delivery dates from org'));
        return metodsMap;
    }
    
    // ------------------------------------------------------------------------------------------------------------------------ // ** Default
    
    // AG Methods
    // Get All Available States we ship to
    public Plant_Utility.responseWrapper getAvailableShippingStates(){
        
        String tempStatus='';
        String tempStatusCode='';
        String tempMsg='';
        
        List<Plant_Delivery_Schedule__c>  existing_DScheduleRecord = [SELECT Id,Plant_State_Code__c FROM Plant_Delivery_Schedule__c order by Plant_State_Code__c];
        List<String> responseDate_List = new List<String>();
        Set<String> respList = new Set<String>();
        for(Plant_Delivery_Schedule__c pds :existing_DScheduleRecord) {
            respList.add(pds.Plant_State_Code__c);
        }
        for(String s :respList) {
            responseDate_List.add(s);
        }
        
        tempStatus = 'success';
        tempStatusCode='200';
        tempMsg='Available delivery dates present';
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
        return responseWrap;
    }
    
    // @ Method 1
    //  @ desc: Return all available delivery dates from org
    public Plant_Utility.responseWrapper getAvailableDeliveryDates(deliveryDateWrapper wrapRequest){
        
        String tempStatus='';
        String tempStatusCode='';
        String tempMsg='';
        Integer Shipping_Duration = 0;
        Set<Date> availableDate_set = new Set<Date>();
        Map<String,String> availableDatVsId_Map = new Map<String,String>();
        List<date> responseDate_List = new List<date>();
        
        try{
            if(wrapRequest==null || String.isBlank(wrapRequest.state) || String.isBlank(wrapRequest.zip) ){
                // request parameter not correct
                tempStatus = 'error';
                tempStatusCode='501';
                tempMsg='Not Implemented: request JSON not correct';
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
                return responseWrap;
            }
            
            // @desc:  get Plant_Delivery_Schedule record based on json address        
            // AG - Chnaged this query, we allow state records with NO postal codes as well
            List<Plant_Delivery_Schedule__c>  existing_DScheduleRecord = [SELECT Id,Plant_Shipping_Duration__c FROM Plant_Delivery_Schedule__c WHERE Plant_Zip_Code__c=:wrapRequest.zip OR (Plant_State_Code__c=:wrapRequest.state AND Plant_Zip_Code__c = NULL) LIMIT 1];
            if(!existing_DScheduleRecord.isEmpty()){
                
                // @desc: get all future shipping date for delivery schedule
                for(Plant_Shipping_Date__c shpAddObj : [SELECT Id, Name, Plant_Shipping_Date__c, Plant_Total_Orders__c, Max_Orders_Allowed__c, Plant_One_Day_Shipping_Delivery_Date__c, Plant_2_Day_Shipping_Delivery_Date__c, X3_Day_Shipping_Delivery_Date__c, Is_Shipping_Date_Available__c FROM Plant_Shipping_Date__c WHERE /*Plant_Shipping_Date__c=:tempShipDate AND*/ Is_Shipping_Date_Available__c=True AND Plant_Shipping_Date__c>TODAY ORDER BY Plant_Shipping_Date__c ASC LIMIT 10]){
                    
                    //Validation: check max order limit on shipping date
                    // AG - Changed this logic to add any Delivery date where the duration is euqal or greater than
                    if(shpAddObj.Plant_Total_Orders__c == NULL || shpAddObj.Plant_Total_Orders__c < shpAddObj.Max_Orders_Allowed__c){
                        if(existing_DScheduleRecord[0].Plant_Shipping_Duration__c==1 && shpAddObj.Plant_One_Day_Shipping_Delivery_Date__c>System.today()){
                            availableDatVsId_Map.put(String.valueOf(shpAddObj.Plant_One_Day_Shipping_Delivery_Date__c), shpAddObj.Id+':'+existing_DScheduleRecord[0].Id);
                        }
                        if((existing_DScheduleRecord[0].Plant_Shipping_Duration__c==1 || existing_DScheduleRecord[0].Plant_Shipping_Duration__c==2) && shpAddObj.Plant_2_Day_Shipping_Delivery_Date__c>System.today()){
                            availableDatVsId_Map.put(String.valueOf(shpAddObj.Plant_2_Day_Shipping_Delivery_Date__c), shpAddObj.Id+':'+existing_DScheduleRecord[0].Id);
                        }
                        if((existing_DScheduleRecord[0].Plant_Shipping_Duration__c==1 || existing_DScheduleRecord[0].Plant_Shipping_Duration__c==2 || existing_DScheduleRecord[0].Plant_Shipping_Duration__c==3) && shpAddObj.X3_Day_Shipping_Delivery_Date__c>System.today()){
                           availableDatVsId_Map.put(String.valueOf(shpAddObj.X3_Day_Shipping_Delivery_Date__c), shpAddObj.Id+':'+existing_DScheduleRecord[0].Id);
                        }
                    }
                    else{
                        system.debug('No more Orders can be taken on this date Try another date');
                    }
                }
                
                tempStatus = 'success';
                tempStatusCode='200';
                tempMsg='Available delivery dates present';
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(availableDatVsId_Map));
                return responseWrap;
            }
            else{
                tempStatus = 'success';
                tempStatusCode='200';
                tempMsg='No record found for this area';
            }
            // }
            
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
            return responseWrap;
            
        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: Deliver date: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            tempStatus = 'error';
            tempStatusCode='500';
            tempMsg='Internal Server Error: '+ex.getMessage();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
            return responseWrap;
        }
        
    }
    
	// AG -- Methods for Internal Use Only
	
    // AG - Get the next closest shipment date to the one given
    public static Date getClosestShipmentDate(Date shippingDate, String shippingAddressId,MAP<String,Plant_Shipping_Address__c> mapShipAddr, MAP<String,Plant_Delivery_Schedule__c> mapDelivSched, List<Plant_Shipping_Date__c> lstShippingDate){
        Date ret;
        
        System.debug('getClosestShipmentDate shippingDate:' + shippingDate);
        System.debug('getClosestShipmentDate shippingAddressId:' + shippingAddressId);
        
        if(shippingDate == NULL || shippingAddressId == NULL) {
            return null;
        }
        
        Plant_Shipping_BC.deliveryDateWrapper jsonWrapper = new Plant_Shipping_BC.deliveryDateWrapper();
        jsonWrapper.shippingDate = String.valueOf(shippingDate);
        jsonWrapper.shippingAddressId = shippingAddressId;
        System.debug('getClosestShipmentDate jsonWrapper:' + jsonWrapper);

        Plant_Utility.responseWrapper dd_resultList = new Plant_Shipping_BC().getAvailableShippingDates(jsonWrapper,mapShipAddr,mapDelivSched,lstShippingDate);
        System.debug('getClosestShipmentDate dd_resultList:' + dd_resultList);
        
        if(dd_resultList.result != NULL && dd_resultList.result.resultMap != NULL) {
            for(String dts :dd_resultList.result.resultMap.keyset()) {
                Date dt = date.valueOf(dts);
                
                System.debug('getClosestShipmentDate dt:' + dt + '>=' + shippingDate);
                
                if(dt >= shippingDate) {
                    System.debug('getClosestShipmentDate return:' + dt);
                    return dt;
                }
            }
        }
        System.debug('getClosestShipmentDate return:' + ret);
        return ret;
    }

     // Method AG 1.2:
     public Plant_Utility.responseWrapper getAvailableShippingDates(deliveryDateWrapper wrapRequest,MAP<String,Plant_Shipping_Address__c> mapShipAddr, MAP<String,Plant_Delivery_Schedule__c> mapDelivSched, List<Plant_Shipping_Date__c> lstShippingDate) {
        
        String tempStatus='';
        String tempStatusCode='';
        String tempMsg='';
        Integer Shipping_Duration = 0;
        Set<Date> availableDate_set = new Set<Date>();
        Map<String,String> availableDatVsId_Map = new Map<String,String>();
        List<date> responseDate_List = new List<date>();
        
        try{
            if(wrapRequest==null || (wrapRequest.shippingAddressId == NULL && (String.isBlank(wrapRequest.state) || String.isBlank(wrapRequest.zip))) || (wrapRequest.shippingAddressId == NULL && String.isBlank(wrapRequest.state) && String.isBlank(wrapRequest.zip))){
                // request parameter not correct
                tempStatus = 'error';
                tempStatusCode='501';
                tempMsg='Not Implemented: request JSON not correct';
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
                return responseWrap;
            }

            if(wrapRequest.shippingAddressId != NULL) {
                
                if(mapShipAddr != NULL) {
                    Plant_Shipping_Address__c fndAddr = mapShipAddr.get(wrapRequest.shippingAddressId);
                    if(fndAddr != NULL) {
                        wrapRequest.state = fndAddr.Plant_Province_State__c;
                        wrapRequest.zip = fndAddr.Plant_Postal_Code__c;                        
                    }
                } else {
                    List<Plant_Shipping_Address__c> lstShipAdddrs = [select id, Plant_Postal_Code__c, Plant_Province_State__c from Plant_Shipping_Address__c where id = :wrapRequest.shippingAddressId];
                    System.debug('>> lstShipAdddrs: ' + lstShipAdddrs);
                    
                    if(!lstShipAdddrs.isEmpty()) {
                        wrapRequest.state = lstShipAdddrs[0].Plant_Province_State__c;
                        wrapRequest.zip = lstShipAdddrs[0].Plant_Postal_Code__c;
                    }
                }
            }
            System.debug('>> wrapRequest.state: ' + wrapRequest.state);
            System.debug('>> wrapRequest.zip: ' + wrapRequest.zip);
            
			            
            // @desc:  get Plant_Delivery_Schedule record based on json address 
            Decimal duration;
            if(mapDelivSched != NULL) {
                Plant_Delivery_Schedule__c fndDelivSched = mapDelivSched.get(wrapRequest.zip+':');
                if(fndDelivSched != NULL) {
                    duration = fndDelivSched.Plant_Shipping_Duration__c;
                } else {
					fndDelivSched = mapDelivSched.get(wrapRequest.zip+':'+wrapRequest.state);                    
                    if(fndDelivSched != NULL) {
	                    duration = fndDelivSched.Plant_Shipping_Duration__c;
                    }
                }
            } else {
                List<Plant_Delivery_Schedule__c> lstSched = [SELECT Id,Plant_Shipping_Duration__c FROM Plant_Delivery_Schedule__c WHERE Plant_Zip_Code__c=:wrapRequest.zip OR (Plant_State_Code__c=:wrapRequest.state AND Plant_Zip_Code__c = NULL) LIMIT 1];
                if(!lstSched.isEmpty()) {
                    duration = lstSched[0].Plant_Shipping_Duration__c;
                }
            }
            System.debug('>> duration: ' + duration);
            
            if(duration != NULL){
                
                // If shipping Date is passed in get next next 10 from there
                Date startDate = Date.TODAY();
                if(wrapRequest.shippingDate != NULL) {
                    startDate = Date.valueOf(wrapRequest.shippingDate).addDays(-1);
                }
                
                List<Plant_Shipping_Date__c> lstSD;
                if(lstShippingDate != NULL) {
                    lstSD = lstShippingDate;
                } else {
                    lstSD = [SELECT Id, Name, Plant_Shipping_Date__c, Plant_Total_Orders__c, Max_Orders_Allowed__c, Plant_One_Day_Shipping_Delivery_Date__c, Plant_2_Day_Shipping_Delivery_Date__c, X3_Day_Shipping_Delivery_Date__c, Is_Shipping_Date_Available__c FROM Plant_Shipping_Date__c WHERE Is_Shipping_Date_Available__c=True AND Plant_Shipping_Date__c>:startDate ORDER BY Plant_Shipping_Date__c ASC LIMIT 10];
                }
                // @desc: get all future shipping date for delivery schedule
                for(Plant_Shipping_Date__c shpAddObj :lstSD){
                    
                    //Validation: check max order limit on shipping date
                    if(shpAddObj.Plant_Total_Orders__c == NULL || shpAddObj.Plant_Total_Orders__c < shpAddObj.Max_Orders_Allowed__c){
                        if(duration==1 && shpAddObj.Plant_One_Day_Shipping_Delivery_Date__c>System.today()){
                            availableDatVsId_Map.put(String.valueOf(shpAddObj.Plant_Shipping_Date__c), shpAddObj.Id);
                        }
                        if((duration==1 || duration==2) && shpAddObj.Plant_2_Day_Shipping_Delivery_Date__c>System.today()){
                            availableDatVsId_Map.put(String.valueOf(shpAddObj.Plant_Shipping_Date__c), shpAddObj.Id);
                        }
                        if((duration==1 || duration==2 || duration==3) && shpAddObj.X3_Day_Shipping_Delivery_Date__c>System.today()){
                           availableDatVsId_Map.put(String.valueOf(shpAddObj.Plant_Shipping_Date__c), shpAddObj.Id);
                        }
                    }
                    else{
                        system.debug('No more Orders can be taken on this date Try another date');
                    }
                }
                
                tempStatus = 'success';
                tempStatusCode='200';
                tempMsg='Available delivery dates present';
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(availableDatVsId_Map));
                return responseWrap;
            }
            else{
                tempStatus = 'success';
                tempStatusCode='200';
                tempMsg='No record found for this area';
            }
            // }
            
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
            return responseWrap;
            
        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: Deliver date: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            tempStatus = 'error';
            tempStatusCode='500';
            tempMsg='Internal Server Error: '+ex.getMessage();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
            return responseWrap;
        }
        
    }
    
    // Merhod AG 1.3: (string, map, map)
    public static Decimal getShippingDuration(String shippingAddressId,MAP<String,Plant_Shipping_Address__c> mapShipAddr, MAP<String,Plant_Delivery_Schedule__c> mapDelivSched){
        Decimal ret;
        
        System.debug('getShippingDuration shippingAddressId:' + shippingAddressId);
        
        if(shippingAddressId == NULL) {
            return null;
        }
        
        Plant_Shipping_BC.deliveryDateWrapper jsonWrapper = new Plant_Shipping_BC.deliveryDateWrapper();
        jsonWrapper.shippingAddressId = shippingAddressId;
        System.debug('getShippingDuration jsonWrapper:' + jsonWrapper);
        
        Plant_Utility.responseWrapper dd_resultList = new Plant_Shipping_BC().getShippingDuration(jsonWrapper,mapShipAddr,mapDelivSched);
        System.debug('getShippingDuration dd_resultList:' + dd_resultList);
        
        if(dd_resultList.result != NULL && dd_resultList.result.resultArr != NULL) {      
            List<Decimal> decList=(List<Decimal>)dd_resultList.result.resultArr;  
            for(Decimal dur :decList) {
                System.debug('getShippingDuration return:' + dur);
                return dur;
            }
        }
        System.debug('getShippingDuration return:' + ret);
        return ret;
    }     
    
    // Method AG 1.4: (wrapper, map, map)
    public Plant_Utility.responseWrapper getShippingDuration(deliveryDateWrapper wrapRequest,MAP<String,Plant_Shipping_Address__c> mapShipAddr, MAP<String,Plant_Delivery_Schedule__c> mapDelivSched){
        String tempStatus='';
        String tempStatusCode='';
        String tempMsg='';
        List<Decimal> responseDate_List = new List<Decimal>();
        
        try{
            if(wrapRequest==null || (wrapRequest.shippingAddressId == NULL && (String.isBlank(wrapRequest.state) || String.isBlank(wrapRequest.zip))) || (wrapRequest.shippingAddressId == NULL && String.isBlank(wrapRequest.state) && String.isBlank(wrapRequest.zip))){
                // request parameter not correct
                tempStatus = 'error';
                tempStatusCode='501';
                tempMsg='Not Implemented: request JSON not correct';
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
                return responseWrap;
            }

            if(mapShipAddr != NULL) {
                Plant_Shipping_Address__c fndAddr = mapShipAddr.get(wrapRequest.shippingAddressId);
                if(fndAddr != NULL) {
                    wrapRequest.state = fndAddr.Plant_Province_State__c;
                    wrapRequest.zip = fndAddr.Plant_Postal_Code__c;                        
                }
            } else {
                List<Plant_Shipping_Address__c> lstShipAdddrs = [select id, Plant_Postal_Code__c, Plant_Province_State__c from Plant_Shipping_Address__c where id = :wrapRequest.shippingAddressId];
                System.debug('>> lstShipAdddrs: ' + lstShipAdddrs);
                
                if(!lstShipAdddrs.isEmpty()) {
                    wrapRequest.state = lstShipAdddrs[0].Plant_Province_State__c;
                    wrapRequest.zip = lstShipAdddrs[0].Plant_Postal_Code__c;
                }
            }

            System.debug('>> wrapRequest.state: ' + wrapRequest.state);
            System.debug('>> wrapRequest.zip: ' + wrapRequest.zip);
            
            Decimal duration;
            if(mapDelivSched != NULL) {
                Plant_Delivery_Schedule__c fndDelivSched = mapDelivSched.get(wrapRequest.zip+':');
                if(fndDelivSched != NULL) {
                    duration = fndDelivSched.Plant_Shipping_Duration__c;
                } else {
					fndDelivSched = mapDelivSched.get(wrapRequest.zip+':'+wrapRequest.state);                    
                    if(fndDelivSched != NULL) {
	                    duration = fndDelivSched.Plant_Shipping_Duration__c;
                    }
                }
            } else {
                List<Plant_Delivery_Schedule__c> lstSched = [SELECT Id,Plant_Shipping_Duration__c FROM Plant_Delivery_Schedule__c WHERE Plant_Zip_Code__c=:wrapRequest.zip OR (Plant_State_Code__c=:wrapRequest.state AND Plant_Zip_Code__c = NULL) LIMIT 1];
                if(!lstSched.isEmpty()) {
                    duration = lstSched[0].Plant_Shipping_Duration__c;
                }
            }

            responseDate_List.add(duration);
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
            return responseWrap;
        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: Deliver date: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            tempStatus = 'error';
            tempStatusCode='500';
            tempMsg='Internal Server Error: '+ex.getMessage();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseDate_List));
            return responseWrap;
        }
    }
    
    // Method 2
    // @ desc: get shipping address for Cart
    public Plant_Utility.responseWrapper getShippingAddress(String orderPropId){
        String tempStatus ='';
        String tempStatusCode ='';
        String tempMsg ='';
        List<Plant_Order_Properties__c> responseList = new List<Plant_Order_Properties__c>();
        try{
            
            Boolean cartIdValid = false;
            Boolean addressOk = false;
            Plant_Order_Properties__c ordrPropert = [SELECT Id,Shipping_Address__c,Shipping_Address__r.Plant_City__c,Shipping_Address__r.Plant_Province_State__c,Shipping_Address__r.Plant_Country__c,Shipping_Address__r.Plant_Postal_Code__c,Shipping_Address__r.Plant_Phone__c,Shipping_Address__r.Plant_Can_SMS__c,Shipping_Address__r.Plant_Account__c,Shipping_Address__r.Plant_First_Name__c,Shipping_Address__r.Plant_Last_Name__c  FROM Plant_Order_Properties__c WHERE Id=:orderPropId LIMIT 1];
            if(ordrPropert!=null){
                cartIdValid= true;
                if(ordrPropert.Shipping_Address__c!=null){
                    addressOk= true;
                    responseList.add(ordrPropert);
                    tempStatus = 'Success';
                    tempStatusCode='200';
                    tempMsg='Shipping Address details received';
                }
                else {
                    tempStatus = 'error';
                    tempStatusCode='500';
                    tempMsg='501 Not Implemented! No Shipping Address found ';
                }
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: view SA: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            tempStatus = 'error';
            tempStatusCode='500';
            tempMsg='Internal Server Error: '+ex.getMessage();
        }
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseList));
        return responseWrap;
    }
    
   // METHOD 6:
    // @ desc: return shippind date record based on Id
    public Plant_Shipping_Date__c getShipDateRecord(String sId){
        return [SELECT Id, Name, Plant_Shipping_Date__c, Plant_Total_Orders__c, Plant_One_Day_Shipping_Delivery_Date__c, Plant_2_Day_Shipping_Delivery_Date__c, X3_Day_Shipping_Delivery_Date__c, Is_Shipping_Date_Available__c FROM Plant_Shipping_Date__c WHERE id=:sId LIMIT 1];
    }
    
    // Internal Methods
    public static void shippingAddressTriggerHandler(List<Plant_Shipping_Address__c> lstShipAddrs) {
        MAP<String,Plant_Shipping_Address__c> mapShipAddrs = new MAP<String,Plant_Shipping_Address__c>();
        Set<String> accountIDs = new Set<String>();
        for(Plant_Shipping_Address__c sa :lstShipAddrs) {     
            if(sa.Plant_Save_Shipping_Address__c == True) {
                mapShipAddrs.put(sa.Plant_Account__c +':'+ sa.Plant_Street1__c,sa);
                accountIDs.add(sa.Plant_Account__c);
            }
        }
        System.debug('mapShipAddrs:' + mapShipAddrs);
        System.debug('accountIDs:' + accountIDs);
        
        List<Plant_Shipping_Address__c> lstExistingShippingAddrs = [select id, Plant_Account__c,
                                                               Plant_City__c,
                                                               Plant_Country__c,
                                                               Plant_Phone__c,
                                                               Plant_Postal_Code__c,
                                                               Plant_Province_State__c,
                                                               Plant_Street1__c,
                                                               Plant_Street2__c,
                                                               Plant_Street3__c,
															   Plant_First_Name__c,
															   Plant_Last_Name__c,
															   Plant_Can_SMS__c
                                                               from Plant_Shipping_Address__c 
                                                               where Plant_Is_Account_Record__c = True AND
                                                               Plant_Account__c in :accountIDs
                                                              ];
        System.debug('lstExistingShippingAddrs:' + lstExistingShippingAddrs);
        
        Map<String,Plant_Shipping_Address__c> mapExistingShippingAddrs = new Map<String,Plant_Shipping_Address__c>();
        if(!lstExistingShippingAddrs.isEmpty()) {
            for(Plant_Shipping_Address__c sa :lstExistingShippingAddrs){
                mapExistingShippingAddrs.put(sa.Plant_Account__c +':'+ sa.Plant_Street1__c,sa);
            }
        }
        System.debug('mapExistingShippingAddrs:' + mapExistingShippingAddrs);
        
        List<Plant_Shipping_Address__c> lstUpdateSA = new List<Plant_Shipping_Address__c>();
        List<Plant_Shipping_Address__c> lstInsertSA = new List<Plant_Shipping_Address__c>();
        for(String sa :mapShipAddrs.KeySet()) {
            
            System.debug('sa:' + sa);
            
            Plant_Shipping_Address__c fndPay = mapShipAddrs.get(sa);
            Plant_Shipping_Address__c fndExistingPay = mapExistingShippingAddrs.get(sa);
            System.debug('fndPay:' + fndPay);
            System.debug('fndExistingPay:' + fndExistingPay);
            
            if(fndPay != NULL && fndExistingPay != NULL) {
                Plant_Shipping_Address__c updatePM = cloneShippingAddress(fndPay, fndExistingPay.Id, True);
                System.debug('lstUpdateSA add:' + updatePM);
                lstUpdateSA.add(updatePM);
            } else if(fndPay != NULL) {
                Plant_Shipping_Address__c insertPM = cloneShippingAddress(fndPay, null, True);
                System.debug('lstInsertSA add:' + insertPM);
                lstInsertSA.add(insertPM);
            }
        }
        if(!lstInsertSA.isEmpty())
	        insert lstInsertSA;
        if(!lstUpdateSA.isEmpty())
	        update lstUpdateSA;
    }
    
    public static Plant_Shipping_Address__c cloneShippingAddress(Plant_Shipping_Address__c shipAddr, String shipId, Boolean isAccount) {
        Plant_Shipping_Address__c clonedSA = new Plant_Shipping_Address__c(
                    Plant_Account__c = shipAddr.Plant_Account__c,
                    Plant_Is_Account_Record__c = isAccount,
            		Plant_First_Name__c = shipAddr.Plant_First_Name__c,
            		Plant_Last_Name__c = shipAddr.Plant_Last_Name__c,
            		Plant_Can_SMS__c = shipAddr.Plant_Can_SMS__c,
                    Plant_Phone__c = shipAddr.Plant_Phone__c,
                    Plant_Street1__c = shipAddr.Plant_Street1__c,
                    Plant_Street2__c = shipAddr.Plant_Street2__c,
                    Plant_Street3__c = shipAddr.Plant_Street3__c,
                    Plant_City__c = shipAddr.Plant_City__c,
                    Plant_Province_State__c = shipAddr.Plant_Province_State__c,
                    Plant_Postal_Code__c = shipAddr.Plant_Postal_Code__c,
                    Plant_Country__c = shipAddr.Plant_Country__c
                );
        if(shipId != NULL) {
            clonedSA.Id = shipId;
        }
        return clonedSA;
    } 
    
    
    // @ Wrapper class : 1
    public class deliveryDateWrapper{
        public String street1;
        public String street2; 
        public String street3;
        public String city;
        public String state; 
        public String zip;
        public String country;
        public String phone;
        public boolean canSMS;
        public String shippingDate;
        public String shippingAddressId;
        
        //w Mehod 1
        //w desc:   parse and return wrapper object
        public deliveryDateWrapper parse(String json){
            return (deliveryDateWrapper)System.JSON.deserialize(json, deliveryDateWrapper.class);
        }
    }
    
    // @ Wrapper class : 2
    public class manageShipAddress_wrap{
        public String cartId;
        public boolean isCustomer;
        public Plant_Utility.addressCapsule shippingAddress;
        public String deliveryDate; //YYYY-MM-DD format
        
        //w desc:   parse and return wrapper object
        public manageShipAddress_wrap parse(String json){
            return (manageShipAddress_wrap)System.JSON.deserialize(json, manageShipAddress_wrap.class);
        }
    }
    
    // @ Wrapper class : 3
    public class wrapReq_class{
        // public String cartId;
        public String shippingAddressId;
        public String authenticationToken;
        
        // default constructor
        public wrapReq_class(){
            
        }
        
        // constructor 2
        public wrapReq_class(String shippingAddressId){
            this.shippingAddressId = shippingAddressId;
        }
        
        public wrapReq_class parse(String json){
            return (wrapReq_class)System.JSON.deserialize(json, wrapReq_class.class);
        }
    }
    
    // @wrapper class : 4
    public class wrapResponse{
        public String cartId;
        public List<Object> shippingAddress;
    }
    
    // wrapper 5: (# new)
    // wrap Account: Shipping Address response wrapper
    public class ShippngAddressDtlWrap{
        public String AccountId;
        // public List<Plant_Utility.addressCapsule> shippingAddress_List;
        public List<ShippngAddressDtl> shippingAddress_List;
    }
    
    // wrapper 5.1: (# new)
    // wrap Account: Shipping Address
    public class ShippngAddressDtl{
        public String shippingAddressId;
        public Plant_Utility.addressCapsule shippingAddress;
    }
    
    // wrapper 2:
    // @desc: authorization request
    public class userAuth_ResponseWrap{
        public String authorizationToken;
        
        public userAuth_ResponseWrap parse(String json){
            return (userAuth_ResponseWrap)System.JSON.deserialize(json, userAuth_ResponseWrap.class);
        }
    }
    
}