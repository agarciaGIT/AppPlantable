/*
*   @Desciption     :   Plantable (Order Business class)
*                       Pre-Process Order, 

*   @Create date    :   11-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class Plant_Orders_BC {
    
    // Constructor**
    public Plant_Orders_BC() {

    }

    // @ Method 1~~~~~~~~~~~~~~~~~~~~~~~~
    // @ Desc:  pre-process Order // Cart
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper preProcessOrder(opReqWrapper reqWrapper ){
        String status='';
        String statusCode='';
        String msg='';
        String validItems = '';
        boolean isUpdate=false;
        String existingCustomerId = '';
        Plant_Payment_Method__c paymentRec =  new  Plant_Payment_Method__c();
        Plant_Order_Properties__c opRecord = new Plant_Order_Properties__c(); // existing Order Property container

        opResponseWrap response = new opResponseWrap(); // hold RESPONSE body

        try{
            if(reqWrapper!=null){

                // Validation: Check Account Token (for existing customer)
                if(!String.isBlank(reqWrapper.authorizeToken)){
                    System.debug('### auth token => '+reqWrapper.authorizeToken);
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(reqWrapper.authorizeToken);
                    System.debug('### auth result=> '+accAuthResut);
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Account : '+accAuthResut;
                    }
                }
                else{
                    existingCustomerId='No';
                }
                

                // Check cartId for Updating Existing Order Property
                // @ desc: Allow update : only if the cart is not processed as order
                    // Note: also update not allowed for existing customer "new order" property
                if(!String.isBlank(reqWrapper.cartId)){
                    List<Plant_Order_Properties__c> ordrPropert_List = [SELECT id,Plant_Payment_Method__c,Shipping_Address__c,Plant_Account__c,Plant_Shipping_Date__c,
                                                                        Plant_Meal_Selection__c FROM Plant_Order_Properties__c WHERE Id=:reqWrapper.cartId];
                    if(!ordrPropert_List.isEmpty()){
                        opRecord = ordrPropert_List[0];
                        System.debug('####@ order property record => '+ordrPropert_List);
                        if(opRecord.Plant_Account__c!=null){
                            statusCode='501';
                            status='error';
                            msg+='Not Implemented! Cart already in progress. Unable to update';
                        }
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! No cart found';
                    }
                }
                
                if(!statusCode.startsWith('50')){

                    // New Customer: New Cart(ORDER PROPERTY): insert, update
                    //product name validation
                    if(!String.isBlank(reqWrapper.product)){
                        Map<String,String> oTypeMap = Plant_Utility.getAvailableOrderType();
                            if(oTypeMap.keySet().contains(reqWrapper.product)){

                                opRecord.recordTypeId = oTypeMap.get(reqWrapper.product);
                                response.product = reqWrapper.product;
                                opRecord.Plant_Status__c = 'Abandoned';

                                // AG - Add Price to Return
                                PricebookEntry pbe = getPriceBookEntryByProduct(reqWrapper.product,null);
                                response.listPrice = String.valueOf(pbe.UnitPrice);
                                
                                // Fill Recurrence value
                                // AG - change 9/24/2022
                                if(reqWrapper.product=='Reboot') {
                                    opRecord.Plant_Recurrence__c = 'Weekly'; // 4 - week default recurring
                                    response.recurrence = 'Weekly';
                                } else if(reqWrapper.product=='A-la-carte' && !String.isBlank(reqWrapper.recurrence) && (reqWrapper.recurrence=='Weekly' || reqWrapper.recurrence=='Once')){
                                    opRecord.Plant_Recurrence__c = reqWrapper.recurrence.trim();
                                    response.recurrence = opRecord.Plant_Recurrence__c;
                                } else if(reqWrapper.product=='Quickstart' || reqWrapper.product=='A-la-carte'){
                                    opRecord.Plant_Recurrence__c = 'Once';
                                    response.recurrence = 'Once';
                                }
                                else {
                                    msg+=', recurrence type is not valid';
                                }
                                
                            }
                            else{
                                status='error';
                                statusCode='503';
                                msg='Service Unavailable: Product is not a valid type';

                                List<String> response_List = new List<String>();
                                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(response_List));
                                return responseWrap;
                            }
                    }
                    else{
                        status='error';
                        statusCode='503';
                        msg='Service Unavailable: Required value missing. Please insert Product type';

                        List<String> response_List = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(response_List));
                        return responseWrap;
                    }

                    // System.debug('@@@@ this existing customer id => '+existingCustomerId);
                    // System.debug('@@@@ this existing reqWrapper.paymentMethodId => '+reqWrapper.paymentMethodId);

                    // Validation: Payment method Id's of existing customer 
                    if(!String.isBlank(reqWrapper.paymentMethodId) && existingCustomerId!='No' && existingCustomerId!=''){
                        List<Plant_Payment_Method__c> list_ExistingPaymentMtd = [SELECT Id, Name, Plant_Account__c, Plant_Card_Type__c, Plant_Customer_Name__c, Plant_Card_Number__c, Plant_Card_Last_4_Digits__c, Plant_Expiration_Date__c, CCV__c, Plant_Street1__c, Plant_Street2__c, Plant_Street3__c, 
                                                                                 Plant_Province_State__c, Plant_Postal_Code__c, Plant_City__c, Plant_Can_SMS__c, Plant_Country__c, Plant_Phone__c FROM Plant_Payment_Method__c WHERE Plant_Is_Account_Record__c = TRUE AND id=:reqWrapper.paymentMethodId];
                        
                        if(!list_ExistingPaymentMtd.isEmpty()){                            
                            // AG - Clone "account" payment record
                            paymentRec = clonePaymentMethod(list_ExistingPaymentMtd[0], null, False);
                            
                            // Insert new paymentRec(for: new user)
                            list<Plant_Payment_Method__c> newPaymentMtod = new list<Plant_Payment_Method__c>();
                            newPaymentMtod.add(paymentRec);
                            System.debug('#### pay method => '+paymentRec);
                            String newPymtMtdId ='';
                            Database.SaveResult[] srList = Database.insert(newPaymentMtod, false);
                            Plant_Utility.dmlResultWrap dmlReslt = Plant_Utility.checkDML_Result(srList);
                            if(dmlReslt.status=='error')
                                msg += '\n Payment Method insert fail: '+dmlReslt.messg;
                            else 
                                newPymtMtdId = dmlReslt.messg;
                            
                            if(newPymtMtdId!=''){
                                response.paymentMethod= paymentRec;
                                opRecord.Plant_Payment_Method__c=newPymtMtdId;   
                            }
                        }
                        else{
                            msg+=', Invalid Payment Id';
                        }
                    }// Validation: New Card Information 
                    else if(reqWrapper.cardInformation!=null){

                        System.debug('@@@@# prepare card ');
                        if(!String.isBlank(reqWrapper.cardInformation.expDate) && Plant_Utility.checkDateFormat(reqWrapper.cardInformation.expDate))
                            paymentRec.Plant_Expiration_Date__c = Date.valueOf( reqWrapper.cardInformation.expDate );
                        else
                            msg+=', wrong card input: expire date';
                        if(!String.isBlank(reqWrapper.cardInformation.name))     
                            paymentRec.Plant_Customer_Name__c = reqWrapper.cardInformation.name;
                        else
                            msg+=', wrong card input: card name';
                        if(!String.isBlank(reqWrapper.cardInformation.cvv) && Plant_Utility.CheckValidInteger(reqWrapper.cardInformation.cvv))
                            paymentRec.CCV__c = reqWrapper.cardInformation.cvv.trim();
                        else
                            msg+=', wrong card input: card cvv';
                        
                        if(!String.isBlank(reqWrapper.cardInformation.cardnumber) && Plant_Utility.CheckValidInteger(reqWrapper.cardInformation.cardnumber))
                            paymentRec.Plant_Card_Number__c = reqWrapper.cardInformation.cardnumber;
                        else
                            msg+=', wrong card input: card number';
                            if(!String.isBlank(reqWrapper.cardInformation.card_Last_4_Digits) && Plant_Utility.CheckValidInteger(reqWrapper.cardInformation.card_Last_4_Digits))
                            paymentRec.Plant_Card_Last_4_Digits__c = reqWrapper.cardInformation.card_Last_4_Digits;
                        else
                            msg+=', wrong card input: card last 4 digits';
                            if(!String.isBlank(reqWrapper.cardInformation.card_Type))
                            paymentRec.Plant_Card_Type__c = reqWrapper.cardInformation.card_Type;
                        else
                            msg+=', wrong card input: card_Type';

                        if(reqWrapper.cardInformation.billingAddress!=null){
                            Plant_Utility.addressCapsule billAdd = (Plant_Utility.addressCapsule)reqWrapper.cardInformation.billingAddress;
                            System.debug('@@@@###  pre process billAdd => '+billAdd);                            
                            paymentRec.Plant_Can_SMS__c = billAdd.canSMS?true:false;
                            if(!String.isBlank(billAdd.street1) || !String.isBlank(billAdd.street2) || !String.isBlank(billAdd.street3)){
                                paymentRec.Plant_street1__c = billAdd.street1;
                                paymentRec.Plant_street2__c = billAdd.street2;
                                paymentRec.Plant_street3__c = billAdd.street3;
                            }
                            else
                                msg+=', billing street missing';
                            if(!String.isBlank(billAdd.city))
                                paymentRec.Plant_City__c = billAdd.city;
                            else
                                msg+=', billing city missing';
                            if(!String.isBlank(billAdd.country))
                                paymentRec.Plant_Country__c = billAdd.country; 
                            else
                                msg+=', billing country missing';
                            if(!String.isBlank(billAdd.phone))     
                                paymentRec.Plant_Phone__c = billAdd.phone;
                            else
                                msg+=', billing Phone missing';
                            if(!String.isBlank(billAdd.zip))      
                                paymentRec.Plant_Postal_Code__c = billAdd.zip;
                            else
                                msg+=', billing zip code missing';
                            if(!String.isBlank(billAdd.state))      
                                paymentRec.Plant_Province_State__c = billAdd.state;
                            else
                                msg+=', billing State missing';
                        }
                        else {
                            msg+=', card missing billing details';
                        }
                        // AG - Add save payment param, if true will create an "account" record for future payments
                        if(reqWrapper.cardInformation.savePayment != NULL && reqWrapper.cardInformation.savePayment == True) {
                            paymentRec.Plant_Save_Payment_Method__c = True;
                        } else {
                            paymentRec.Plant_Save_Payment_Method__c = False;
                        }

                        // delete previous payment method: 
                        // @desc: if existing payment method record on cart(for: new user)
                        if(opRecord.Plant_Payment_Method__c!=null && existingCustomerId!='No'){
                            Plant_Payment_Method__c existPayment = new Plant_Payment_Method__c();
                            existPayment.id = opRecord.Plant_Payment_Method__c;

                            System.debug('###@ existing payment emthod => '+opRecord.Plant_Payment_Method__c);
                            // Delete payment method
                            delete existPayment;
                        }

                        // Insert new paymentRec(for: new user)
                        list<Plant_Payment_Method__c> newPaymentMtod = new list<Plant_Payment_Method__c>();
                        newPaymentMtod.add(paymentRec);
                        System.debug('#### pay method => '+paymentRec);
                        String newPymtMtdId ='';
                        Database.SaveResult[] srList = Database.insert(newPaymentMtod, false);
                        Plant_Utility.dmlResultWrap dmlReslt = Plant_Utility.checkDML_Result(srList);
                        if(dmlReslt.status=='error')
                            msg += '\n Payment Method insert fail: '+dmlReslt.messg;
                        else 
                            newPymtMtdId = dmlReslt.messg;
                        
                        if(newPymtMtdId!=''){
                            response.paymentMethod= paymentRec;
                            opRecord.Plant_Payment_Method__c=newPymtMtdId;   
                        }
                    }
                    else {
                        msg+=', card information missing';
                    } 

                    // firstName validation    
                    if(!String.isBlank(reqWrapper.firstName)){
                        opRecord.Plant_First_Name__c = reqWrapper.firstName;
                        response.firstName= reqWrapper.firstName;
                    }
                    else {
                        msg+=', firstName Name';
                    } 
                    // lastName validation
                    if(!String.isBlank(reqWrapper.lastName)){
                        opRecord.Plant_Last_Name__c = reqWrapper.lastName;
                        response.lastName= reqWrapper.lastName;
                    }
                    else {
                        msg+=', lastName Name';
                    }   
                    // EMAIL validation
                    if(Plant_Utility.checkEmail(reqWrapper.email)){
                        opRecord.Plant_Email__c = reqWrapper.email.toLowerCase();
                        response.email= reqWrapper.email.toLowerCase();
                    }
                    else {
                        msg+=', Incorrect email';
                    }
                    // Phone validation
                    if(!String.isBlank(reqWrapper.phone)){
                        opRecord.Plant_Phone__c = reqWrapper.phone;
                        response.phone= reqWrapper.phone;
                    }
                    else {
                        msg+=', Incorrect phone';
                    }

                    // can SMS 
                    opRecord.Plant_Can_SMS__c = reqWrapper.canSMS?true:false;
                    response.canSMS= reqWrapper.canSMS;

                    
                    // Validation : Shipping Address Id's of (existing customer)
                    System.debug('@@@@@ Prep Shipping Addres:' + reqWrapper.ShippingAddressId +':'+ reqWrapper.shippingAddress);
                     
                    if(!String.isBlank(reqWrapper.ShippingAddressId)  && existingCustomerId!='No' && existingCustomerId!=''){
                        System.debug('@@@@@ shipping id ');
                        // existing Shipping address
                        List<Plant_Shipping_Address__c> exstShippngAddrs = [SELECT Id, Name, Plant_Account__c, Plant_First_Name__c, Plant_Last_Name__c, Plant_Street1__c, Plant_Province_State__c, Plant_City__c, Plant_Country__c, Plant_Postal_Code__c, 
                                                    Plant_Phone__c, Plant_Can_SMS__c, Plant_Street2__c, Plant_Street3__c FROM Plant_Shipping_Address__c WHERE Id=:reqWrapper.ShippingAddressId];
                        
                        if(!exstShippngAddrs.isEmpty()){
                            opRecord.Shipping_Address__c = reqWrapper.ShippingAddressId;
                            opRecord.Plant_Shipping_Date__c = null;
                            response.shippingAddress = exstShippngAddrs[0];
                        }
                        else{
                            msg+=', Incorrect Shipping Address Id';
                        }
                    }//Validation: New Shipping address record
                    else if(Plant_Utility.checkAddress(reqWrapper.shippingAddress)){
                        
                        System.debug('&&&&&&&&  shp address ');
                        Plant_Shipping_Address__c shipAdd_rec = new Plant_Shipping_Address__c();
                        shipAdd_rec.Plant_Can_SMS__c = reqWrapper.shippingAddress.canSMS?true:false;
                        if(!String.isBlank(reqWrapper.shippingAddress.street1) || !String.isBlank(reqWrapper.shippingAddress.street2) || !String.isBlank(reqWrapper.shippingAddress.street3)){
                            shipAdd_rec.Plant_street1__c = reqWrapper.shippingAddress.street1;
                            shipAdd_rec.Plant_street2__c = reqWrapper.shippingAddress.street2;
                            shipAdd_rec.Plant_street3__c = reqWrapper.shippingAddress.street3;
                        }
                        else 
                            msg+=', empty shipping street';

                        if(!String.isBlank(reqWrapper.shippingAddress.city))
                            shipAdd_rec.Plant_City__c = reqWrapper.shippingAddress.city;
                        else 
                            msg+=', empty shipping city';
                        if(!String.isBlank(reqWrapper.shippingAddress.country))
                            shipAdd_rec.Plant_Country__c = reqWrapper.shippingAddress.country;
                        else 
                           msg+=', empty shipping country';   
                        if(!String.isBlank(reqWrapper.shippingAddress.phone))     
                            shipAdd_rec.Plant_Phone__c = reqWrapper.shippingAddress.phone;
                        else 
                            msg+=', wrong shipping phone';   
                        if(!String.isBlank(reqWrapper.shippingAddress.zip))      
                            shipAdd_rec.Plant_Postal_Code__c = reqWrapper.shippingAddress.zip;
                        else 
                            msg+=',empty shipping postalCode';   
                        if(!String.isBlank(reqWrapper.shippingAddress.state))      
                            shipAdd_rec.Plant_Province_State__c = reqWrapper.shippingAddress.state;
                        else 
                            msg+=', empty shipping state';   
                            
                        // check first name and last name for address (New C req*)
                        if(!String.isBlank(reqWrapper.shippingAddress.firstName))      
                            shipAdd_rec.Plant_First_Name__c = reqWrapper.shippingAddress.firstName;
                        else 
                            msg+=', firstname not available in shipping address';   
                        if(!String.isBlank(reqWrapper.shippingAddress.lastname))      
                            shipAdd_rec.Plant_Last_Name__c = reqWrapper.shippingAddress.LastName;
                        else 
                            msg+=', lastname not available in shipping address';   

                        list<Plant_Shipping_Address__c> newShipAddress = new list<Plant_Shipping_Address__c>();
                        newShipAddress.add(shipAdd_rec);

                        // delete existing shipping address 
                        // @desc: for "new user cart" only
                        if(opRecord.Shipping_Address__c!=null && existingCustomerId!='No'){
                            System.debug('###@ existing shipping address '+opRecord.Shipping_Address__c);
                            Plant_Shipping_Address__c existingShippAdd = new Plant_Shipping_Address__c();
                            existingShippAdd.Id = opRecord.Shipping_Address__c;
                            delete existingShippAdd;
                            
                            System.debug('-- delete completed --');
                            opRecord.Plant_Shipping_Date__c = null;
                        }
                        
                        // inser new shipping address record
                        String newShipAddId ='';
                        System.debug('@@@@ TO Insert shipping address  => '+newShipAddress);
                        Database.SaveResult[] srList = Database.insert(newShipAddress, false);
                        Plant_Utility.dmlResultWrap dmlReslt = Plant_Utility.checkDML_Result(srList);
                        if(dmlReslt.status=='error'){
                            msg += '\n Shipping address insert Fail: '+dmlReslt.messg;
                            System.debug('@@@@ errorrs => '+dmlReslt);
                        }
                        else {
                            newShipAddId = dmlReslt.messg;
                            opRecord.Shipping_Address__c=newShipAddId;
                        }
                        response.shippingAddress= shipAdd_rec;
                    }
                    else{
                        System.debug('&&&&&&&& = > 2');
                        msg+=', Shipping address not inserted must be US or Canada';
                    }

                    response.shipASAP = reqWrapper.shipASAP;
                    // (New C req**)

                    // Validate & Automate "delivery date, Shipping Date"
                    // @desc: Check Shipping address, Delivery Schedule, Shipping Date and delivery date from Address
                    if(!String.isBlank(reqWrapper.shippingAddress.state) && !String.isBlank(reqWrapper.shippingAddress.zip)){
                        System.debug('&&&&&&&& country validated');

                        // check available "Delivery_Schedule" shipping Date for shipping address 
                        // give Map <Delivery Date, Plant_Shipping_Date__c> records
                        Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                        tempAddrsWrap.state=reqWrapper.shippingAddress.state;
                        tempAddrsWrap.zip=reqWrapper.shippingAddress.zip;

                        Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                        System.debug('&&&&&&&&# 1 = >'+availableDates_List);

                        if(availableDates_List.status=='success'){
                            if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                if(availableDates_List.result.resultMap.keySet().size()==0){
                                    msg+=', Shipping date not available for this address*';
                                }
                                else{
                                    // Validation: check delivery date
                                    System.debug('@@@@ check delivery date => '+reqWrapper.DeliveryDate);
                                    
                                    Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                    System.debug('@@@@ is Delivery Date Available '+avail_DeliveryDaye_Map.keySet().contains(reqWrapper.DeliveryDate));
                                    
                                    if(reqWrapper.shipASAP==True){
                                        System.debug('@@@ Ship ASAP is True '+reqWrapper.shipASAP);
                                        List<String> DeliveryDateList =new List<String>(avail_DeliveryDaye_Map.Keyset());
                                        //DeliveryDateList.addAll(Date.valueOf(avail_DeliveryDaye_Map.Keyset()));
                                        DeliveryDateList.sort();
                                        opRecord.Plant_Delivery_Date__c = Date.valueOf(DeliveryDateList[0]);
                                        opRecord.Plant_Shipping_Date__c=avail_DeliveryDaye_Map.get(DeliveryDateList[0]).split(':')[0];
                                        opRecord.Delivery_Schedule__c=avail_DeliveryDaye_Map.get(DeliveryDateList[0]).split(':')[1];
                                        //response.shipDate = String.valueOf(new Plant_Shipping_BC().getShipDateRecord(avail_DeliveryDaye_Map.get(String.valueOf(DeliveryDateList[0]))).Plant_Shipping_Date__c);
                                        response.shipDate = opRecord.Plant_Shipping_Date__c;
                                        response.deliveryDate =  DeliveryDateList[0];
                                        System.debug('@@@ Ship ASAP is true '+opRecord.Plant_Delivery_Date__c);
                                        msg+=', Success: Shipping date available ';
                                        
                                    } else if(Plant_Utility.checkDateFormat(reqWrapper.DeliveryDate)){
                                        		
                                        if(avail_DeliveryDaye_Map.keySet().contains(reqWrapper.DeliveryDate)){
                                            System.debug('@@@ Ship ASAP is False '+reqWrapper.shipASAP);
                                            
                                            String ids = avail_DeliveryDaye_Map.get(reqWrapper.DeliveryDate);
                                            List<String> res = ids.split(':');
                                            
                                            opRecord.Plant_Shipping_Date__c=res[0];
                                            opRecord.Delivery_Schedule__c=res[1];

                                            opRecord.Plant_Delivery_Date__c = Date.valueOf(reqWrapper.DeliveryDate);
                                            //response.shipDate = String.valueOf(new Plant_Shipping_BC().getShipDateRecord(avail_DeliveryDaye_Map.get(reqWrapper.DeliveryDate)).Plant_Shipping_Date__c);
                                            response.shipDate = opRecord.Plant_Shipping_Date__c;
                                            response.deliveryDate = String.valueOf(opRecord.Plant_Delivery_Date__c);
                                            
                                            msg+=', Success: Shipping date available ';

                                        } else {
                                            msg+=', Delivery date not available for address**';
                                        }
                                    } else {
                                        msg+=', Incorrect Delivery Date format(must be YYYY-MM-DD)';
                                    }
                                }
                            }
                            else{
                                msg+=', Shipping date not available for this address';
                            }
                        }
                        else{
                            msg+=', Shipping date Not available for this address';
                        }
                    }
                    else {
                        System.debug('&&&&&&&& = > 4');
                        // ADDRESS IS NOT VALID 
                        msg+=', Shipping address must be only US and Canada';
                    }
                    
                    // CREATE/update MEAL SELECTION RECORD
                    Plant_Meal_Selection__c new_MealSelection_Rec = new Plant_Meal_Selection__c();
                    
                    Boolean isMsOld = false;
                    if(reqWrapper.useChefMenu == true){
                        //Custom Settings Planatable Internal Account...
                        Map<string, plantable_Constants__c> mapCustomSettings=plantable_Constants__c.getall();
                        plantable_Constants__c CustomSetting=mapCustomSettings.get('DevConstant');
                        insert new_MealSelection_Rec;
                        List<Plant_Meal_Selection__c> chefMeal_List=[Select id,(SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Plant_Meal_Selection__c, Plant_Meal__c, Plant_Quantity__c FROM Meal_Selection_Meals__r Limit 200), 
                        OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Plant_Description__c, Plant_Owner__c from Plant_Meal_Selection__c where Plant_Owner__c=:CustomSetting.Plantable_Internal_Account__c Limit 1];
                        // Cloning Meal Selection Meal Item for the related Opportunity Meal
                        if(!chefMeal_List[0].Meal_Selection_Meals__r.isEmpty()){
                                
                            List<Plant_Meal_Selection_Meal__c> mealSelectionMeal_List=new List<Plant_Meal_Selection_Meal__c>();
                            for(Plant_Meal_Selection_Meal__c mealSelectionMeal:chefMeal_List[0].Meal_Selection_Meals__r){
                                Plant_Meal_Selection_Meal__c SelectionMeal=new Plant_Meal_Selection_Meal__c();
                                SelectionMeal = mealSelectionMeal.clone(false, true, false, false);
                                SelectionMeal.Plant_Meal_Selection__c=new_MealSelection_Rec.id;
                                mealSelectionMeal_List.add(SelectionMeal);
                            }

                            // Insert Meal in subscripiton Meal selection 
                            if(!mealSelectionMeal_List.isEmpty()){
                                insert mealSelectionMeal_List;
                            }
                        }
                        // INSERT or UPDATE ORDER PROPERTY(op) **
                        if(!String.isBlank(reqWrapper.cartId) || opRecord.id!=null){
                            System.debug('&&&&&&&& = > 8');
                            opRecord.Id = reqWrapper.cartId;
                            // ADD ACCOUNT TO new  order propery: for existing customer
                                opRecord.Plant_Meal_Selection__c = new_MealSelection_Rec.Id;
                                if(existingCustomerId!='No' && existingCustomerId!=''){
                                    opRecord.Plant_Account__c = existingCustomerId;
                                    System.debug('###@ already account : order property update');
                                }
                            update opRecord;

                            string tempMsg = msg;
                            msg = (tempMsg=='')?'Operation encounter NONE exception':'Operation encounter exception: '+tempMsg;
                            msg= 'Cart updated successfully:\n'+tempMsg;
                            response.cartId = opRecord.id;
                        }
                        else {
                            //INSERT
                            System.debug('&&&&&&&& = > 9');
                            
                            opRecord.Plant_Meal_Selection__c = new_MealSelection_Rec.Id;
                            // ADD ACCOUNT TO new  order propery: for existing customer
                            if(existingCustomerId!='No' && existingCustomerId!=''){
                                opRecord.Plant_Account__c = existingCustomerId;    
                                System.debug('###@ order property insert: already account ');
                            }
                                
                            insert opRecord;
                            string tempMsg = msg;
                            msg = (tempMsg=='')?'Operation encounter NONE exception':'Operation encounter exception: '+tempMsg;
                            msg= 'Cart inserted successfully:\n'+tempMsg;
                            response.cartId = opRecord.id;
                        }
                        
                    }
                    else{
                        // update meal selection
                        if(!String.isBlank(reqWrapper.mealSelectionId) || opRecord.Plant_Meal_Selection__c!=null){
                            System.debug('&&&&&&&& = > 5');
                            new_MealSelection_Rec.Id = reqWrapper.mealSelectionId==''?opRecord.Plant_Meal_Selection__c:reqWrapper.mealSelectionId;
                            isMsOld = true;
                        }
                        else{
                            // insert meal selection
                            System.debug('&&&&&&&& = > 6');
                            new_MealSelection_Rec.recordTypeId = Schema.SObjectType.Plant_Meal_Selection__c.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

                            List<Plant_Meal_Selection__c> mealSelctRecdList = new List<Plant_Meal_Selection__c>();
                            mealSelctRecdList.add(new_MealSelection_Rec);

                            Database.SaveResult[] srList = Database.insert(mealSelctRecdList, false);
                            Plant_Utility.dmlResultWrap dmlReslt = Plant_Utility.checkDML_Result(srList);
                            if(dmlReslt.status=='error')
                                msg += '\n Error Meal Selection: '+dmlReslt.messg;
                            else 
                                new_MealSelection_Rec.Id = dmlReslt.messg;
                        }
                        
                        mealSelectionResp mealSel_Resp = new mealSelectionResp();
                        mealSel_Resp.mealSelectionId = new_MealSelection_Rec.Id;
                        
                        
                        // MEAL LIST VALIDATION**
                        if(new_MealSelection_Rec!=null ){

                            // CHECK existing MEAL SELECTION MEALS(records) & delete
                            List<Plant_Meal_Selection_Meal__c> mealSlectionMeal_ExistingList = [SELECT id FROM Plant_Meal_Selection_Meal__c WHERE Plant_Meal_Selection__c=:new_MealSelection_Rec.Id];
                            if(!mealSlectionMeal_ExistingList.isEmpty()){
                                delete mealSlectionMeal_ExistingList;
                            }

                            if(reqWrapper.meals.size()!=0){
                                System.debug('&&&&&&&& = > 7.1');
                                // remove all selected list and add new meal list
                                Plant_Utility.wrapMeal[] tempMealList = new List<Plant_Utility.wrapMeal>();
                                tempMealList = reqWrapper.meals;

                                // (New C req*)
                                // check size by quantity
                                Integer mealCount = 0;
                                for(Plant_Utility.wrapMeal mel : tempMealList){
                                    if(mel.quantity.isNumeric()){
                                        mealCount+=Integer.valueOf(mel.quantity);
                                    }
                                }

                                if(mealCount!=12){
                                    System.debug('&&&&&&&& = > 7');
                                    msg+=', Please add 12 meal items';
                                }
                                else{   

                                    Plant_Meals_BC.MealSelectionReq_Wrapper reqWp = new Plant_Meals_BC.MealSelectionReq_Wrapper();
                                    reqWp.mealSelectionId = new_MealSelection_Rec.Id;
                                    reqWp.mealList = tempMealList;
            
                                    Plant_Utility.responseWrapper setMeals_Response  = new Plant_Meals_BC().updateMealSelection(reqWp);
            
                                    if(setMeals_Response.statusCode!='200'){
                                        msg+=','+setMeals_Response.msg;
                                    }
                                    else{
                                        mealSel_Resp.mealSelectionList = setMeals_Response.result;
                                    }

                                }
                                
                            }
                            else {
                                System.debug('&&&&&&&& = > 7');
                                msg+=', Please add 12 meal items';
                            }
                            response.mealSelection = mealSel_Resp;
                        }
                        else {
                            msg+=', Unable to create MealSelection';
                        }
                        // INSERT or UPDATE ORDER PROPERTY(op) **
                        if(!String.isBlank(reqWrapper.cartId) || opRecord.id!=null){
                            System.debug('&&&&&&&& = > 8');
                            opRecord.Id = reqWrapper.cartId;
                            if(mealSel_Resp.mealSelectionId!=''&& mealSel_Resp.mealSelectionId!=null)
                                opRecord.Plant_Meal_Selection__c = mealSel_Resp.mealSelectionId;
                            // ADD ACCOUNT TO new  order propery: for existing customer
                                if(existingCustomerId!='No' && existingCustomerId!=''){
                                    opRecord.Plant_Account__c = existingCustomerId;
                                    System.debug('###@ already account : order property update');
                                }
                            update opRecord;

                            string tempMsg = msg;
                            msg = (tempMsg=='')?'Operation encounter NONE exception':'Operation encounter exception: '+tempMsg;
                            msg= 'Cart updated successfully:\n'+tempMsg;
                            response.cartId = opRecord.id;
                        }
                        else {
                            //INSERT
                            System.debug('&&&&&&&& = > 9');
                            if(mealSel_Resp.mealSelectionId!=''&& mealSel_Resp.mealSelectionId!=null)
                                opRecord.Plant_Meal_Selection__c = mealSel_Resp.mealSelectionId;
                            // ADD ACCOUNT TO new  order propery: for existing customer
                            if(existingCustomerId!='No' && existingCustomerId!=''){
                                opRecord.Plant_Account__c = existingCustomerId;    
                                System.debug('###@ order property insert: already account ');
                            }
                                
                            insert opRecord;
                            string tempMsg = msg;
                            msg = (tempMsg=='')?'Operation encounter NONE exception':'Operation encounter exception: '+tempMsg;
                            msg= 'Cart inserted successfully:\n'+tempMsg;
                            response.cartId = opRecord.id;
                        }
                    }
                    
                    

                    // Remove existing discount code(if any)
                    boolean removeSuccess = true;
                    List<Plant_Discount_Selection__c> existing_DiscountList = [SELECT id, Plant_Discount_Code__c,Plant_Discount_Code__r.Plant_Code__c, Plant_Order_Properties__c FROM Plant_Discount_Selection__c WHERE Plant_Order_Properties__c=:opRecord.id];
                    if(!existing_DiscountList.isEmpty()){
                        // call remove discount code
                        Plant_DiscountCodes_BC.dcReqWrapper reqDisc = new Plant_DiscountCodes_BC.dcReqWrapper();
                        reqDisc.cartId=existing_DiscountList[0].Plant_Order_Properties__c;
                        reqDisc.DisCode=existing_DiscountList[0].Plant_Discount_Code__r.Plant_Code__c;
                        reqDisc.Product=reqWrapper.product;
                        Plant_Utility.responseWrapper existin_discResult = new  Plant_DiscountCodes_BC().updateDiscountCodeToOrder(reqDisc);
                        if(existin_discResult.statusCode=='200'){
                            removeSuccess=true;
                        }
                        else{
                            msg+=', error on updating discount code: '+existin_discResult.msg;
                            removeSuccess=false;
                        }
                    }
                    // CHECK DISCOUNT CODE and add new
                    if(removeSuccess){
                        System.debug('@@@ new DC is adding');
                        Plant_DiscountCodes_BC.dcReqWrapper dsc_WrapObj = new Plant_DiscountCodes_BC.dcReqWrapper();
                        if(!String.isBlank(reqWrapper.discountCode)){
                            dsc_WrapObj.DisCode = reqWrapper.discountCode;
                            dsc_WrapObj.cartId = opRecord.Id;
                            dsc_WrapObj.Product = reqWrapper.product;
                        }
                        else{
                            dsc_WrapObj.DisCode = '';
                            dsc_WrapObj.cartId = opRecord.Id;
                            dsc_WrapObj.Product = reqWrapper.product;
                        }
                            System.debug('&&&&&&&& = > 10');
                        

                        Plant_Utility.responseWrapper discCode_resp =  new Plant_DiscountCodes_BC().updateDiscountCodeToOrder(dsc_WrapObj);
                        System.debug('&&&&&&&&# = >'+discCode_resp);
                        response.discountCodeList = discCode_resp.result;
                        msg+=' , '+discCode_resp.msg+' ';
                    }                   
                
                    
                    // RESPONSE
                    if(opRecord!=null && opRecord.Id!=null){
                        System.debug('&&&&&&&& = > 11');
                        statusCode='200';
                        status='success';
                        List<opResponseWrap> respList = new List<opResponseWrap>();
                        respList.add(response);
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                    else{
                        System.debug('&&&&&&&& = > 12');
                        statusCode='501';
                        status='error';
                        List<opResponseWrap> respList = new List<opResponseWrap>();
                        respList.add(response);
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                }
                else{
                    // invalid cartId
                    List<opResponseWrap> respList = new List<opResponseWrap>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }               
            }
            else{
                System.debug('&&&&&&&& = > 13');
                statusCode='503';
                status='error';
                msg+=', Service Unavailable!';
                List<opResponseWrap> respList = new List<opResponseWrap>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }
        }    
        catch(Exception ex){
            System.debug('&&&&&&&& = > 14');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            List<opResponseWrap> respList = new List<opResponseWrap>();
            respList.add(response);
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }

    // @ Method 2 ~~~~~~~~~~~~~~
    // @ Desc: process Order
    // ~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper processOrder(processOdr_Wrapper processOrder_ReqWrapper){
        // ChargentOrders__Payment_Start_Date__c
        String status='';
        String statusCode='';
        String msg='';
        // String reqType = 'insert';
        String acc_to_Updt = '';
        String existingCustomerId='';
        String temporaryPassword='';
        //ChargentOrders__ChargentOrder__c
        // SET: Savepoint for rollback if bad data
        Savepoint sp1_initialState = Database.setSavepoint();
        List<Plant_Order_Properties__c> processOrderRecList = new List<Plant_Order_Properties__c>();
        try{
            String accountId_cap = '';
            String paymentMethod_cap = '';
            String paymentCardType='';
            Plant_Order_Properties__c opRec = new Plant_Order_Properties__c(); // Order Property RECORD
            Plant_Payment_Method__c pymtMtdRec = new Plant_Payment_Method__c(); // payment method RECORD
            plantable_Constants__c custSettin = plantable_Constants__c.getValues('DevConstant'); // custom setting : constants
        

            // VALIDATE INPUT WRAPPER**
            //validation: 1: check cart id
            if (processOrder_ReqWrapper.cartId==null || processOrder_ReqWrapper.cartId=='') {

                // check if order property exist
                // RETURN ORDER PROPERTY ERROR
                statusCode='503';
                status='error';
                msg='Service Unavailable! Invalid cartId';
                List<String> respList = new List<String>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }
            else{// cartId(Order PropertyId) Not NULL
                
                System.debug('@@# ctId issu 2 '+processOrder_ReqWrapper.cartId);
                processOrderRecList = [SELECT Id,RecordTypeId,Plant_Recurrence__c,RecordType.Name, Plant_Meal_Selection__c, Plant_Payment_Method__c, 
                                        Plant_Status__c, Plant_Delivery_Date__c, Delivery_Schedule__c, Plant_Shipping_Date__c,Plant_Shipping_Date__r.Plant_Shipping_Date__c, 
                                        Shipping_Address__c, Shipping_Address__r.Plant_Province_State__c,Shipping_Address__r.Plant_Postal_Code__c, 
                                        Plant_Account__c, Plant_First_Name__c, Plant_Last_Name__c, Plant_Email__c,Plant_Phone__c, Plant_Can_SMS__c,
                                        Plant_Gift_Recipient__c,plan_discountedAmount__c FROM Plant_Order_Properties__c 
                                        WHERE Id=: processOrder_ReqWrapper.cartId AND Shipping_Address__c!=null AND 
                                        (Shipping_Address__r.Plant_Postal_Code__c!=null OR Shipping_Address__r.Plant_Province_State__c!=null) AND 
                                        Plant_First_Name__c!=null AND Plant_Last_Name__c!=null AND Plant_Recurrence__c!=null  AND 
                                        Plant_Payment_Method__c!=null LIMIT 1];
                
                if(!processOrderRecList.isEmpty() && processOrderRecList[0].Plant_Account__c!=null){
                    
                    //for EXISTING ACCOUNT
                        // - new Order property for Existing customer
                    acc_to_Updt = processOrderRecList[0].Plant_Account__c;
                    System.debug('@@@@ acc to oupdate => '+acc_to_Updt);
                } 
                else if(processOrderRecList[0].Plant_Account__c==null){
                    List<Account> accList=[Select id, name, email__c from Account where email__c=:processOrderRecList[0].Plant_Email__c Limit 1];
                    if(!accList.isEmpty()){
                        statusCode='503';
                        status='error';
                        msg='Account Already Exists with this Email Id : '+accList[0].email__c+'  Please use another cart with different Email Id : ';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                }

                // Validate: not valid cartId
                if(processOrderRecList.isEmpty()){
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! Unable to process: Invalid cartId or required field missing';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                } // Validate: check valid shipping date**
                // else if( processOrderRecList[0].Plant_Shipping_Date__c==null && processOrderRecList[0].Plant_Delivery_Date__c!=null){
                //     System.debug('&&&&&-- check--- &&&&');
                //     statusCode='503';
                //     status='error';
                //     msg='Service Unavailable! Unable to process: Shipment Date unavailable';
                //     List<String> respList = new List<String>();
                //     Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                //     return responseWrap;
                // }
                else{
                    // contain order property for further iteration
                    opRec = processOrderRecList[0];
                }
                
            }

            // validation: 2 - account name field
            if(String.isBlank(acc_to_Updt) && processOrder_ReqWrapper.firstName=='' && processOrder_ReqWrapper.lastName==''){
                statusCode='503';
                status='error';
                msg='Service Unavailable! Account name required';
                List<String> respList = new List<String>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }


            // validation: 3 - Payment Method Id
            if(processOrder_ReqWrapper.paymentMethodId!='' && String.valueOf(processOrder_ReqWrapper.paymentMethodId).substring(0,15)==String.valueOf(opRec.Plant_Payment_Method__c).substring(0,15)){
                
                // check for payment method record in sf
                List<Plant_Payment_Method__c> pymtMtdRec_List = [SELECT Id,Plant_Card_Type__c,Plant_Card_Number__c,CCV__c,Plant_Card_Last_4_Digits__c,Plant_Expiration_Date__c,Plant_Customer_Name__c,
                                Plant_Account__c,Plant_Street1__c,Plant_Street2__c,Plant_Street3__c,Plant_City__c,Plant_Country__c,Plant_Province_State__c,Plant_Postal_Code__c,Plant_Can_SMS__c,Plant_Phone__c FROM Plant_Payment_Method__c WHERE Id=:opRec.Plant_Payment_Method__c AND 
                                Plant_Card_Type__c!=null AND Plant_Card_Number__c!=null AND CCV__c!=null AND Plant_Card_Last_4_Digits__c!=null AND Plant_Expiration_Date__c!=null AND Plant_Customer_Name__c!=null AND  Plant_Street1__c!=null AND Plant_Street2__c!=null AND Plant_City__c!=null AND Plant_Country__c!=null AND Plant_Province_State__c!=null AND Plant_Postal_Code__c!=null AND Plant_Phone__c!=null LIMIT 1];
                
                // System.debug('@@@@ existing paymetn method => '+pymtMtdRec_List);
                if(pymtMtdRec_List.isEmpty()){
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! Payment method is not completed, Complete to proceed';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }
                else {
                    // payment method exist in SF
                    pymtMtdRec = pymtMtdRec_List[0];
                }
            }
            else{
                System.debug('@@@@ NO PM');
                statusCode='503';
                status='error';
                msg='Service Unavailable! Invalid payment method Id';
                List<String> respList = new List<String>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }

            // Validation 4: check shipping date
            if(opRec.Plant_Delivery_Date__c==null && (opRec.Plant_Shipping_Date__c==null || opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c==null)){
                System.debug('@@@@ NO PM shippind date');
                statusCode='503';
                status='error';
                msg='Service Unavailable! No Shipping Date Available For This Address';
                List<String> respList = new List<String>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }

            // validation 5:
            // SUBSCRIPTION VALIDATION**
            if(!String.isBlank(acc_to_Updt)){
                boolean flagAlreadySubscribed =false;
                for(Account acc : [SELECT id,Name,(SELECT id,RecordTypeId,RecordType.Name,Plant_Account__c, Plant_Cadence__c, Plant_Meal_Selection__c, 
                                    Plant_Next_Charge_Date__c,Plant_Next_Delivery_Date__c, Plant_Next_Shipment_Date__c, 
                                    Plant_Payment_Method__c, Plant_Shipping_Address__c, 
									Plant_Charge_Day__c, Plant_Start_Date__c, Plant_Status__c 
                                    FROM Subscriptions__r  where  (Plant_Status__c ='Active' OR Plant_Status__c ='Paused') AND 
                                    RecordType.Name=:opRec.RecordType.Name) FROM Account where Id=:acc_to_Updt]){

                    if(acc.Subscriptions__r.size()>0){
                        // On going subscripiton record existing
                        flagAlreadySubscribed = true;
                        break;
                    }
                }
                if(flagAlreadySubscribed){
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! Subscription already existed';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }
                else
                    System.debug('No Active subscription found for => '+opRec.RecordType.Name);
            }

            // Validation 6:
            // Meal Selection 12 meals
            List<Plant_Meal_Selection__c> MealSelection_List =[SELECT Id, (SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, Plant_Meal_Selection__c, Plant_Meal__c, Plant_Quantity__c FROM Meal_Selection_Meals__r), 
            OwnerId, IsDeleted, Name, RecordTypeId, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastViewedDate, LastReferencedDate, Plant_Description__c, Plant_Owner__c FROM Plant_Meal_Selection__c where id=:opRec.Plant_Meal_Selection__c Limit 1];
            if(!MealSelection_List.isEmpty()){
                if(MealSelection_List[0].Meal_Selection_Meals__r.size()>0){
                    Integer temp_Count = 0 ;
                    for(Plant_Meal_Selection_Meal__c msn : MealSelection_List[0].Meal_Selection_Meals__r){
                        temp_Count+=(Integer)msn.Plant_Quantity__c;
                    }
                    if(temp_Count!=12){
                        // RETURN ERROR 
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Meal list is not completed yet';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                }
                else {
                    // RETURN ERROR
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! Meal list is not completed yet';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap; 
                }
            }
            else {
                // RETURN ERROR 
                statusCode='503';
                status='error';
                msg='Service Unavailable! Meal list is not completed yet';
                List<String> respList = new List<String>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }

            // validation --end

            //ACCOUNT: update
            if(!String.isBlank(acc_to_Updt)){
                Account old_acc = new Account();
                old_acc.Id = acc_to_Updt;

                old_acc.Name = processOrder_ReqWrapper.firstName+' '+processOrder_ReqWrapper.lastName;

                if(!String.isBlank(processOrder_ReqWrapper.firstName))
                    old_acc.First_Name__c = processOrder_ReqWrapper.firstName;
                if(!String.isBlank(processOrder_ReqWrapper.lastName))    
                    old_acc.Last_Name__c = processOrder_ReqWrapper.lastName;
                if(!String.isBlank(processOrder_ReqWrapper.phone))
                old_acc.phone = processOrder_ReqWrapper.phone;

                // update account
                update old_acc;
                accountId_cap = old_acc.id;
            }
            else {// Account : Insert
                Plant_Customer_BC.createAccount_Wrap Account_Wrap =new Plant_Customer_BC.createAccount_Wrap();
                if(!String.isBlank(processOrderRecList[0].Plant_First_Name__c) && !String.isBlank(processOrderRecList[0].Plant_Last_Name__c)){
                    Account_Wrap.firstName=processOrderRecList[0].Plant_First_Name__c;
                    Account_Wrap.lastName=processOrderRecList[0].Plant_Last_Name__c;
                }
                if(!String.isBlank(processOrderRecList[0].Plant_Phone__c)){
                Account_Wrap.Phone = processOrderRecList[0].Plant_Phone__c;
                }
                if(!String.isBlank(processOrderRecList[0].Plant_Email__c)){
                Account_Wrap.Email = processOrderRecList[0].Plant_Email__c;
                }
                
                // call customer BC to create account
                Plant_Utility.responseWrapper createAccResp= new Plant_Customer_BC().createAccount(Account_Wrap);
                System.debug(' @@@@ createAccResp '+createAccResp);
                if(createAccResp.statusCode=='200'){
                    Plant_Customer_BC.createAccount_Resp resultRap=(Plant_Customer_BC.createAccount_Resp)createAccResp.result.resultArr[0];
                    
                    System.debug('@@@ Resultmap of Account Callout  '+resultRap);
                    temporaryPassword=resultRap.temporaryPassword;
                    system.debug('@@@ Temporary Password'+resultRap.temporaryPassword);
                    msg+='Account has been created : '+createAccResp.msg;
                    accountId_cap=resultRap.Account_Id;
                }
                // List<Account> acc = [Select id, plant_UserPasswaord__c, name from Account where Email__c=:processOrderRecList[0].Plant_Email__c Limit 1];
                // if(!acc.isEmpty() &&  acc[0].plant_UserPasswaord__c==temporaryPassword){
                //     System.debug('@@@ Account Id'+acc[0].id);
                //     accountId_cap=acc[0].id;
                //     System.debug('@@@ Tesmp Password'+temporaryPassword);
                // }
            }

            System.debug('@@@@# Account done ');

            // IF ACCOUNT SUCCESS
            if(accountId_cap!=''){
                    
                    // update shipping address Account details
                    Plant_Shipping_Address__c custmr_shipAddRec = new Plant_Shipping_Address__c();
                    custmr_shipAddRec.Id= opRec.Shipping_Address__c;
                    custmr_shipAddRec.Plant_Account__c = accountId_cap;
                    update custmr_shipAddRec;
                    
                    // update Payment method**
                    Plant_Payment_Method__c paymentRec =  new  Plant_Payment_Method__c();
                    paymentRec = pymtMtdRec;
                    System.debug('@@@@# prepare card ');
                    paymentRec.Plant_Account__c = accountId_cap;
                    update paymentRec;

                    paymentMethod_cap = paymentRec.Id;
                    paymentCardType = paymentRec.Plant_Card_Type__c;                            
                    System.debug(' @@@@@ Plant Payment Method '+paymentRec.Plant_Card_Type__c);

                    System.debug('@@@@# update order property  ');

                    // UPDATE: cart(Order Property) with account and payment **
                    Plant_Order_Properties__c old_OpRec =  new Plant_Order_Properties__c();
                    old_OpRec.Id = processOrder_ReqWrapper.cartId;
                    old_OpRec.Plant_Account__c = accountId_cap;
                    old_OpRec.Plant_Payment_Method__c = paymentRec.id;
                    old_OpRec.Plant_Status__c = 'Pending Payment';
                    update old_OpRec;


                    // CREATE SF ORDER **
                    Order sf_order = new Order();
                    sf_order.AccountId= accountId_cap;
                    sf_order.Status='Draft';
                    sf_order.Plant_Order_Properties__c=opRec.id;
                    //sf_order.comty_Chargent_Order__c = chrgnt_OrderRec.id;//chargent order id
                    sf_order.EffectiveDate = System.today();
                    sf_order.Plant_Shipping_Date__c=opRec.Plant_Shipping_Date__c;
                    sf_order.Plant_Delivery_Date__c=opRec.Plant_Delivery_Date__c;
                    Pricebook2 std_Pbook    = [select id, name from Pricebook2 where isStandard = true limit 1];
                    sf_order.Pricebook2Id=std_Pbook.id;
                    insert sf_order;

                    System.debug('@@@@# sf  order created  ');

                    // create order item: GET PRODUCT(pricebook entry) BY ORDER PROPERTY RECORD TYPE
                    // AG - Changed 9/24/2022
                    PricebookEntry priceBookEntry = getPriceBookEntryByProduct(opRec.recordType.Name,null);
                    if(priceBookEntry != NULL) {
                        OrderItem newLine = new OrderItem();
                        newLine.OrderId = sf_order.id;
                        newLine.PricebookEntryId = priceBookEntry.id;
                        newLine.Quantity=1;
                        newLine.UnitPrice = priceBookEntry.UnitPrice;
                        insert newLine;
                        
                        System.debug('@@@@# sf  order Line created  ');
    
                        // QUERY SF OBJECT
                        Order sfOrder = [SELECT id,AccountId,OrderNumber, Status,EffectiveDate,Pricebook2Id, TotalAmount,Plant_Order_Properties__c,Plant_Order_Properties__r.Plant_Recurrence__c,Plant_Order_Properties__r.RecordType.Name FROM Order WHERE id=:sf_order.id LIMIT 1 ];
    
                        // CREATE CHARGENT ORDER RECORD
                        ChargentOrders__ChargentOrder__c chrgnt_OrderRec = new ChargentOrders__ChargentOrder__c();
                        chrgnt_OrderRec.ChargentOrders__Account__c = accountId_cap;
                        chrgnt_OrderRec.ChargentOrders__Payment_Method__c = custSettin.chargentOrderPaymentMethod__c;
                        chrgnt_OrderRec.ChargentOrders__Card_Type__c= paymentRec.Plant_Card_Type__c;
                        System.debug('@@@@# Amount: '+sfOrder.TotalAmount);
                        System.debug('@@@ discount : '+opRec.plan_discountedAmount__c);
    
                        // calculate charge amount: by calculating discount
                        chrgnt_OrderRec.ChargentOrders__Charge_Amount__c = (opRec.plan_discountedAmount__c==null || opRec.plan_discountedAmount__c<=0)?sfOrder.TotalAmount:sfOrder.TotalAmount-opRec.plan_discountedAmount__c;
                        chrgnt_OrderRec.ChargentOrders__Subtotal__c =sfOrder.TotalAmount;
                        
                        // calculate recurring frequency
                        if(sfOrder.Plant_Order_Properties__r.RecordType.Name== Plant_Utility.default_recurrenceProductName || (sfOrder.Plant_Order_Properties__r.RecordType.Name=='A-la-carte' && sfOrder.Plant_Order_Properties__r.Plant_Recurrence__c=='Weekly')){
                            chrgnt_OrderRec.ChargentOrders__Payment_Status__c='Recurring';
                            
                            // new(@)**
                            System.debug('####@@ opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c : '+opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c);
                            chrgnt_OrderRec.ChargentOrders__Payment_Start_Date__c = opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c.addDays(5);
                            chrgnt_OrderRec.ChargentOrders__Payment_Frequency__c='Weekly';
                            if(sfOrder.Plant_Order_Properties__r.RecordType.Name== Plant_Utility.default_recurrenceProductName){
                                chrgnt_OrderRec.ChargentOrders__Payment_Stop__c='Count';
                                chrgnt_OrderRec.ChargentOrders__Payment_Count__c = 3;
                            }
                            else
                                chrgnt_OrderRec.ChargentOrders__Payment_Stop__c='Unending';
    
                            System.debug('@@@@# DDT: '+opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c);
                            
                        }
                        else{
                            chrgnt_OrderRec.ChargentOrders__Payment_Frequency__c='Once';
                        }
    
                        chrgnt_OrderRec.ChargentOrders__Gateway__c = [SELECT id,Name FROM ChargentBase__Gateway__c WHERE Name=:Plant_Utility.gatwayName][0].id;
                        insert chrgnt_OrderRec;
    
                        // UPDATE sfOrder WITH chargent ORDER**
                        sfOrder.comty_Chargent_Order__c = chrgnt_OrderRec.id;
    
                        System.debug('@@@@# chargent  order created  ');
    
                        // CREATE SUBSCRIPTION RECORD
                        String subsptnId_Cap ='';
                        Id reboot_RecordTypeId = Schema.SObjectType.Plant_Subscription__c.getRecordTypeInfosByName().get('Reboot').getRecordTypeId();
                        Id A_la_carte_RecordTypeId = Schema.SObjectType.Plant_Subscription__c.getRecordTypeInfosByName().get('A-la-carte').getRecordTypeId();
    
                        if(chrgnt_OrderRec.ChargentOrders__Payment_Frequency__c!='Once' && (opRec.RecordType.Name=='Reboot' || opRec.RecordType.Name=='A-la-carte')){
                            Plant_Subscription__c subscpt = new Plant_Subscription__c();
                            if(opRec.RecordType.Name=='Reboot')
                                subscpt.recordTypeId=reboot_RecordTypeId;
                            else  
                                subscpt.recordTypeId=A_la_carte_RecordTypeId;
                                
                            subscpt.Plant_Account__c = accountId_cap;
                            subscpt.Plant_Status__c = 'Draft';
                            subscpt.Plant_Start_Date__c= opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c.addDays(5);
                            subscpt.Plant_Cadence__c='Weekly';
                            subscpt.Plant_Shipping_Address__c = opRec.Shipping_Address__c;
                            subscpt.Plant_Payment_Method__c = opRec.Plant_Payment_Method__c;
                            subscpt.Plant_Delivery_Schedule__c=opRec.Delivery_Schedule__c;
                            subscpt.Plant_Shipping_Date__c=opRec.Plant_Shipping_Date__c;
                            subscpt.Plant_Chargent_Order__c = chrgnt_OrderRec.id;
                            //subscpt.Plant_Meal_Selection__c = processOrderRecList[0].Plant_Meal_Selection__c;
                            //Clone of Meal Selection Record Exists On related Opportunity Record.
                            Plant_Meal_Selection__c MealSelection=new Plant_Meal_Selection__c();
                            if(!MealSelection_List.isEmpty()){
                                MealSelection = MealSelection_List[0].clone(false, true, false, false);
                            
                                // Inserting Cloned Meal Selection
                                insert MealSelection;
    
                                // Cloning Meal Selection Meal Item for the related Opportunity Meal
                                if(!MealSelection_List[0].Meal_Selection_Meals__r.isEmpty()){
                                    
                                    List<Plant_Meal_Selection_Meal__c> mealSelectionMeal_List=new List<Plant_Meal_Selection_Meal__c>();
                                    for(Plant_Meal_Selection_Meal__c mealSelectionMeal:MealSelection_List[0].Meal_Selection_Meals__r){
                                        Plant_Meal_Selection_Meal__c SelectionMeal=new Plant_Meal_Selection_Meal__c();
                                        SelectionMeal = mealSelectionMeal.clone(false, true, false, false);
                                        SelectionMeal.Plant_Meal_Selection__c=MealSelection.id;
                                        mealSelectionMeal_List.add(SelectionMeal);
                                    }
    
                                    // Insert Meal in subscripiton Meal selection 
                                    if(!mealSelectionMeal_List.isEmpty()){
                                        insert mealSelectionMeal_List;
                                    }
                                }
                            }
                            
                            
                            subscpt.Plant_Meal_Selection__c=MealSelection.id;
                            // AG: fixed this up
                            subscpt.Plant_Next_Charge_Date__c=opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c.addDays(5);
                            DateTime todaysDateTime = (DateTime)subscpt.Plant_Next_Charge_Date__c;
                            String dayOfWeek = todaysDateTime.format('EEEE');
                            subscpt.Plant_Charge_Day__c = dayOfWeek;
    
                            subscpt.Plant_Next_Shipment_Date__c = Plant_Shipping_BC.getClosestShipmentDate(opRec.Plant_Shipping_Date__r.Plant_Shipping_Date__c.addDays(7), opRec.Shipping_Address__c,NULL,NULL,NULL);
                            Decimal shippingDuration = Plant_Shipping_BC.getShippingDuration(opRec.Shipping_Address__c,NULL,NULL);
                            if(shippingDuration != NULL) {
                                subscpt.Plant_Next_Delivery_Date__c = subscpt.Plant_Next_Shipment_Date__c.addDays(Integer.valueOf(shippingDuration));
                            }
                            subscpt.Order_Count__c = 0;
                            
                            insert subscpt;
                            subsptnId_Cap = subscpt.Id;
                            // System.debug('@@@@@@ subscription inserted successfully: '+subsptnId_Cap);
    
                            // UPDATE SUBSCRIPTION ID IN SF ORDER
                            sfOrder.Plant_Subscription__c = subsptnId_Cap;
                            update sfOrder;
    
                        }
                        else {
                            update sfOrder;
                            System.debug('@@@@@@ No subscription required ');
                        }
    
                        // CALL CHARGENT API METHODS(asyc)**
                        // System.debug('@@@@ '+custSettin.chargentOrderPaymentMethod__c);
                        // String chrgnt_reqBody1 = JSON.serialize(new Plant_Orders_BC.chargentAuthorizeReq_class(chrgnt_OrderRec.id,''+paymentRec.Plant_Expiration_Date__c.Month(),''+paymentRec.Plant_Expiration_Date__c.Year(),custSettin.chargentOrderPaymentMethod__c,paymentRec.Plant_Card_Type__c, paymentRec.CCV__c,paymentRec.Plant_Card_Number__c,chrgnt_OrderRec.ChargentOrders__Charge_Amount__c,false, opRec.Plant_First_Name__c!=null?opRec.Plant_First_Name__c:'',opRec.Plant_Last_Name__c!=null?opRec.Plant_Last_Name__c:'',chrgnt_OrderRec.ChargentOrders__Billing_Address__c,chrgnt_OrderRec.ChargentOrders__Billing_City__c,chrgnt_OrderRec.ChargentOrders__Billing_State__c,chrgnt_OrderRec.ChargentOrders__Billing_Zip_Postal__c,chrgnt_OrderRec.ChargentOrders__Billing_Country__c));
                        //System.debug('@@@ reqst body => '+chrgnt_reqBody1);
    
                        statusCode='200';
                        status='successful';
                        msg+='Account Registered Successfully!';
                        
                        // Success Response body
                        orderFeesWrap orderFeeRec = new orderFeesWrap(0.0,0.0,0.0,0.0);// for test output only
                        orderSumaryWrap orderSummryRec = new orderSumaryWrap( sfOrder.OrderNumber,String.valueOf(opRec.Plant_Delivery_Date__c),chrgnt_OrderRec.Id,sfOrder.Id, opRec.Id , temporaryPassword, paymentRec.Id,subsptnId_Cap,orderFeeRec);
                        List<orderSumaryWrap> responseList = new List<orderSumaryWrap>();
                        responseList.add(orderSummryRec);
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
                        System.debug('########## RESPONSE => '+responseWrap);
                        return responseWrap;
                    } else {
                        // RETURN ERROR 
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Product not found in config';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                }
                else{
                    // ACCOUNT ID NOT AVAILABLE
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Invalid account detail';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }

        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD PO : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            // ROLLBACK TO PREVIOUS STATE
            Database.rollback(sp1_initialState);
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    } 

    // @ Method 3.1 ***(Deprricated)
    // @ D e s c: Create "Plant_Site_ReqBody__c" object record    
    public Plant_Utility.responseWrapper authorizeCard_EnqueueRequest(TransactionReqWrap requestTransactionWrap){
        
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId='';
        Savepoint sp1_initialState = Database.setSavepoint();
        try{
            // VALIDATE: AuthenticationToken
            if(!String.isBlank(requestTransactionWrap.authenticationToken)){
                System.debug('### cancel order: auth token => '+requestTransactionWrap.authenticationToken);
                // check Authorize token
                String validationResult = plant_AuthorizeController.validate_ByAccessToken(requestTransactionWrap.authenticationToken);
                System.debug('### auth result=> '+validationResult);
                if(validationResult.startsWith('Success')){
                    existingCustomerId =  validationResult.split(',')[1];
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Account : '+validationResult;
                }
            }

            //Account found
            if(existingCustomerId!=null){
                System.debug(' ##@ transaction Enqueue ##@ '+requestTransactionWrap);

         
                // VALIDATION 1 : check sf Id's
                if(String.isBlank(requestTransactionWrap.sfOrderId) || String.isBlank(requestTransactionWrap.cOrderId) ||
                   String.isBlank(requestTransactionWrap.orderPropId) || String.isBlank(requestTransactionWrap.paymentId)){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Required value missing';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                   }
                   else{
                        // CREATE: Plant_Site_ReqBody record and return record ID for response
                        Plant_Site_ReqBody__c reqBody = new Plant_Site_ReqBody__c();
                        reqBody.Plant_Request_Body__c = JSON.serialize(requestTransactionWrap);
                        reqBody.endpoint__c = 'ProcessTransaction';
                        reqBody.Plant_Account__c = existingCustomerId;
                        reqBody.Plant_Chargent_Order__c = requestTransactionWrap.cOrderId;
                        insert reqBody;

                        boolean allOk = false;
                        // INSERT Platform event and publish
                        List<CustomerChargeEvent__e> evnt_ToPub = new List<CustomerChargeEvent__e>();
                        evnt_ToPub.add(new CustomerChargeEvent__e(RecordID__c=reqBody.Id));
                        List<Database.SaveResult> srResult = EventBus.publish(evnt_ToPub);  
                        System.debug('@@@@# srResult => '+srResult);
                        if (srResult[0].isSuccess()) {
                            System.debug('@@@ Successfully published event.');
                            allOk = True;
                        } else {
                            for(Database.Error err : srResult[0].getErrors()) {
                                System.debug('@@@ Error in publishing event: ' +err.getStatusCode() +' - ' +err.getMessage());
                                statusCode='501';
                                status='error!';
                                msg='Transaction Authorize error! error on enquing request';
                            }
                        }         

                        if(allOk){
                            statusCode='201';
                            status='success!';
                            msg='Card registration enqueued: \n request Id: '+reqBody.Id;
                        }
                   }
            }
            else{
                // TOKEN NOT VALID
                statusCode='501';
                status='error!';
                msg='Transaction Authorize error! No Account Found\n';
            }
            
            // System.debug('@@@@@@@@@@@ syc RESULT '+auth_result);
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;

        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD TRANSACTION : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            Database.rollback(sp1_initialState);
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
        
    } 
    

    // Method 3.1.1
    // @D e s c : call chargent AuthorizeOrder_ClickJSON Mehtod
    //        called from Plant_ProcessTransaction_SABatch(Batch apex)
    public Plant_Utility.responseWrapper authorizeChargent_Method2(TransactionReqWrap requestTransactionWrap){
        
        String statusCode='';
        String status='';
        String msg='';

        try{
            System.debug(' ##@ transaction ##@ '+requestTransactionWrap);

            // VALIDATE: AuthenticationToken
            String validationResult = plant_AuthorizeController.validateAccessToken(requestTransactionWrap.orderPropId,'', requestTransactionWrap.authenticationToken);
            System.debug('@@@@ validationResult : '+validationResult);
            if(validationResult.startsWith('Success')){
                // TOKEN VALIDATED
                // VALIDATION 1 : check sf order
                
                Order sfOrder_Var = new Order();
                ChargentOrders__ChargentOrder__c cOrder_Var = new ChargentOrders__ChargentOrder__c();
                Plant_Order_Properties__c orderProp_Var = new Plant_Order_Properties__c();
                Plant_Payment_Method__c payment_Var = new Plant_Payment_Method__c();
                plantable_Constants__c custSettin = plantable_Constants__c.getValues('DevConstant'); // custom setting : constants

                if(String.isBlank(requestTransactionWrap.sfOrderId)){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Invalid OrderId';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                }
                else{
                    List<Order> sfOrder_List = [SELECT id,AccountId,OrderNumber, Status,Plant_Order_Properties__c,EffectiveDate,Pricebook2Id, TotalAmount FROM Order WHERE id=:requestTransactionWrap.sfOrderId LIMIT 1 ];
                    if(sfOrder_List.isEmpty()){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Invalid OrderId';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                    else{
                        sfOrder_Var = sfOrder_List[0];
                        
                    }
                }

                // VALIDATION 2: check chargent order(cOrderId)
                if(String.isBlank(requestTransactionWrap.cOrderId)){
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! Invalid cOrderId';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }
                else{
                    List<ChargentOrders__ChargentOrder__c> cOrder_List = [SELECT id, ChargentOrders__Charge_Amount__c, ChargentOrders__Billing_Address__c, ChargentOrders__Billing_City__c, ChargentOrders__Billing_State__c, ChargentOrders__Billing_Zip_Postal__c,ChargentOrders__Subtotal__c, ChargentOrders__Billing_Country__c  FROM ChargentOrders__ChargentOrder__c WHERE id=:requestTransactionWrap.cOrderId LIMIT 1 ];
                    if(cOrder_List.isEmpty()){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Invalid cOrderId';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                    else{
                        cOrder_Var = cOrder_List[0];
                        
                    }
                }

                // VALIDATION 3: Order Property
                if(String.isBlank(requestTransactionWrap.orderPropId)){
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! Invalid orderPropId';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }
                else{
                    List<Plant_Order_Properties__c> processOrderRecList = [SELECT Id,RecordTypeId,RecordType.Name, Plant_Meal_Selection__c, Plant_Payment_Method__c, Plant_Status__c, 
                                                                            Plant_Delivery_Date__c, Plant_Shipping_Date__c, Shipping_Address__c, Shipping_Address__r.Plant_Province_State__c,
                                                                            Shipping_Address__r.Plant_Postal_Code__c, Plant_Account__c, Plant_First_Name__c, Plant_Last_Name__c, Plant_Email__c,
                                                                            Plant_Phone__c, Plant_Can_SMS__c,Plant_Gift_Recipient__c,plan_discountedAmount__c FROM Plant_Order_Properties__c WHERE Id=: requestTransactionWrap.orderPropId LIMIT 1];
                    if(processOrderRecList.isEmpty()){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Invalid orderPropId';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                    else{
                        orderProp_Var = processOrderRecList[0];
                        System.debug('Pass  order Property List');
                    }
                }

                // VALIDATION 4: Payment Method
                if(String.isBlank(requestTransactionWrap.paymentId)){
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! Invalid paymentId';
                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }
                else{
                    List<Plant_Payment_Method__c> paymentMethodList = [SELECT Id,Plant_Expiration_Date__c, Plant_Card_Type__c, Plant_Card_Number__c, Plant_Customer_Name__c, CCV__c,Plant_Card_Last_4_Digits__c,Plant_Account__c FROM Plant_Payment_Method__c WHERE Id=: requestTransactionWrap.paymentId AND (Plant_Expiration_Date__c!=null AND Plant_Card_Type__c!=null AND  Plant_Card_Number__c!=null AND  Plant_Customer_Name__c!=null AND  CCV__c!=null AND Plant_Card_Last_4_Digits__c!=null AND Plant_Account__c!=null) LIMIT 1];
                    if(paymentMethodList.isEmpty()){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Invalid paymentId';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                    else{
                        payment_Var = paymentMethodList[0];
                        System.debug('Pass Payment Method List');
                    }
                }


                String  charg_jsonBody = JSON.serialize(new Plant_Orders_BC.chargentAuthorizeReq_class(cOrder_Var.id,''+payment_Var.Plant_Expiration_Date__c.Month(),''+payment_Var.Plant_Expiration_Date__c.Year(),custSettin.chargentOrderPaymentMethod__c,payment_Var.Plant_Card_Type__c, payment_Var.CCV__c,payment_Var.Plant_Card_Number__c,cOrder_Var.ChargentOrders__Subtotal__c,false, orderProp_Var.Plant_First_Name__c!=null?orderProp_Var.Plant_First_Name__c:'',orderProp_Var.Plant_Last_Name__c!=null?orderProp_Var.Plant_Last_Name__c:'',cOrder_Var.ChargentOrders__Billing_Address__c,cOrder_Var.ChargentOrders__Billing_City__c,cOrder_Var.ChargentOrders__Billing_State__c,cOrder_Var.ChargentOrders__Billing_Zip_Postal__c,cOrder_Var.ChargentOrders__Billing_Country__c));
                ChargentBase__Gateway__c cgateway = [SELECT id,name FROM ChargentBase__Gateway__c WHERE id IN (SELECT ChargentOrders__Gateway__c FROM ChargentOrders__ChargentOrder__c WHERE id =: cOrder_Var.id)];
                System.debug('### gateway => '+cgateway);

                System.debug('@@@@@ Transaction body ==> '+charg_jsonBody);
                // call chargent : authorize order 
                ChargentOrders.TChargentOperations.TChargentResult auth_result = ChargentOrders.TChargentOperations.AuthorizeOrder_ClickJSON(charg_jsonBody);

                System.debug('@@@@## transction Status=> '+auth_result.Status);
                System.debug('@@@@## transction Message=> '+auth_result.Message);
                System.debug('@@@@## transction TransactID=> '+auth_result.TransactID);
                System.debug('@@@@## transction responseData=> '+auth_result.responseData);

                if(auth_result.responseData!=null){
                    // SUCCESSFULL CALLOUT
                    Map<String,Object> responseDta = (Map<String,Object>)JSON.deserializeUntyped(auth_result.responseData);
                    System.debug('#### key set==> '+responseDta.keySet());
                    // complete transaction
                    if(auth_result.Status=='OK' && auth_result.TransactID!=null && String.valueOf(responseDta.get('responseCode'))=='200' && String.valueOf(responseDta.get('isApproved'))=='true'){

                        System.debug('###### Transaction authorization OK');
                        statusCode='200';
                        status='successful!';
                        msg='Transaction authorize successfully';
                        List<TransactionResp_Wrap> responseList = new List<TransactionResp_Wrap>();
                        TransactionResp_Wrap resps = new TransactionResp_Wrap(auth_result.TransactID,cOrder_Var.ChargentOrders__Subtotal__c);
                        responseList.add(resps);
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
                        System.debug('########## RESPONSE Auth Transaction => '+responseWrap);
                        return responseWrap;

                    }
                    else {
                        statusCode='501';
                        status='error!';
                        msg='Transaction Authorize error!'+auth_result.Message;

                    }
                }
                else{
                    // NO SUCCESS CALLOUT
                    statusCode='501';
                    status='error!';
                    msg='Transaction Authorize error!\n'+auth_result.Message;
                }
                
            }
            else{
                // TOKEN NOT VALID
                statusCode='501';
                status='error!';
                msg='Transaction Authorize error!\n'+validationResult;

            }
            
            // System.debug('@@@@@@@@@@@ syc RESULT '+auth_result);
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;

        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD TRANSACTION : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
        
    } 
    

    // Method 3.2.1 ***(Depricated)
    // @ d e s c: Create Plant_Site_ReqBody record for System Admin sessionId Chargent API
    public Plant_Utility.responseWrapper processCard_EnqueueRequest(processPayment_Wrap requestPaymentWrap){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId='';
        try{        
            
            if(!String.isBlank(requestPaymentWrap.authenticationToken)){
                System.debug('### cancel order: auth token => '+requestPaymentWrap.authenticationToken);
                // check Authorize token
                String validationResult = plant_AuthorizeController.validate_ByAccessToken(requestPaymentWrap.authenticationToken);
                System.debug('### auth result=> '+validationResult);
                if(validationResult.startsWith('Success')){
                    existingCustomerId =  validationResult.split(',')[1];
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Account : '+validationResult;
                }
            }

            //Account found
        if(!String.isBlank(existingCustomerId)){
            // get cart Id
            List<ChargentOrders__Transaction__c> trnsRcd = [SELECT id,ChargentOrders__Order__c FROM ChargentOrders__Transaction__c WHERE id=:requestPaymentWrap.cTransactionId LIMIT 1];
            if(!trnsRcd.isEmpty()){
                
                List<Order> sfOrdr = [SELECT id,Plant_Order_Properties__c,comty_Chargent_Order__c FROM Order WHERE comty_Chargent_Order__c=:trnsRcd[0].ChargentOrders__Order__c Order By CreatedDate DESC Limit 1];
                if(!sfOrdr.isEmpty()){
                   
                      List<Plant_Site_ReqBody__c>  siteReq=[Select id, endpoint__c, Plant_Account__c, Plant_Chargent_Order__c, Plant_Request_Body__c, Plant_Done__c, Plant_Response__c, Plant_Status__c FROM Plant_Site_ReqBody__c where Plant_Chargent_Order__c=:trnsRcd[0].ChargentOrders__Order__c AND endpoint__c != 'ProcessPayment' order by createddate DESC Limit 1];
                        // CREATE: Plant_Site_ReqBody record and return record ID for response
                    if(!siteReq.isEmpty() && siteReq[0].Plant_Status__c=='Success'){
                        Plant_Site_ReqBody__c reqBody = new Plant_Site_ReqBody__c();
                        reqBody.Plant_Request_Body__c = JSON.serialize(requestPaymentWrap);
                        reqBody.endpoint__c = 'ProcessPayment';
                        
                        reqBody.Plant_Account__c = existingCustomerId;

                        reqBody.Plant_Chargent_Order__c = trnsRcd[0].ChargentOrders__Order__c;

                        system.debug('@@@@ Existing Customer Id '+existingCustomerId+' Id we entered '+reqBody.Plant_Account__c);
                        insert reqBody;

                        boolean allOk = false;
                        
                        // INSERT Platform event and publish
                        List<CustomerChargeEvent__e> evnt_ToPub = new List<CustomerChargeEvent__e>();
                        evnt_ToPub.add(new CustomerChargeEvent__e(RecordID__c=reqBody.Id));
                        List<Database.SaveResult> srResult = EventBus.publish(evnt_ToPub);  
                        System.debug('@@@@# srResult => '+srResult);
                        if (srResult[0].isSuccess()) {
                            System.debug('@@@ Successfully published event.');
                            allOk = True;
                        } else {
                            for(Database.Error err : srResult[0].getErrors()) {
                                System.debug('@@@ Error in publishing event: ' +err.getStatusCode() +' - ' +err.getMessage());
                                statusCode='501';
                                status='error!';
                                msg='Transaction Authorize error! error on enquing request';
                            }
                        }         

                        if(allOk){
                            statusCode='201';
                            status='success!';
                            msg='Card registration enqueued: \n request Id: '+reqBody.Id;
                        }
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg='Card is still in Authorization Process! Please try after some time...';
                    }
                }
                else{
                    // Order not found
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! No Order Found';

                }
            }
            else{
                // incorrect Transaction Id
                statusCode='501';
                status='error';
                 msg='Not Implemented! Incorrect Id';

            }
        }
        else{
            // incorrect Transaction Id
            statusCode='501';
            status='error';
            msg+=', Authorization Error/ No Account Found with this authentication Token';

        }
            // RETURN RESULT
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
           
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Enqueue payment : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=', Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }


    // Method 3.2.2
    // call chargent ChargeAuthorizedTransaction_ClickJSON Mehtod
    // synchronous : call chargent payment fullfilment
    public Plant_Utility.responseWrapper authorizeChargent_Method3(processPayment_Wrap requestPaymentWrap){
        String statusCode='';
        String status='';
        String msg='';

        try{        
            
            // get cart Id
            List<ChargentOrders__Transaction__c> trnsRcd = [SELECT id,ChargentOrders__Order__c FROM ChargentOrders__Transaction__c WHERE id=:requestPaymentWrap.cTransactionId LIMIT 1];
            if(!trnsRcd.isEmpty()){
                List<Order> sfOrdr = [SELECT id,Plant_Order_Properties__c,comty_Chargent_Order__c FROM Order WHERE comty_Chargent_Order__c=:trnsRcd[0].ChargentOrders__Order__c Order By CreatedDate DESC Limit 1];
                if(!sfOrdr.isEmpty()){
                // VALIDATE: AuthenticationToken
                String validationResult = plant_AuthorizeController.validate_ByAccessToken(requestPaymentWrap.authenticationToken);
                    if(validationResult.startsWith('Success')){

                        // call chargent: fulfull transaction
                        hitChargentPayment jsonhitChargent = new hitChargentPayment();
                        jsonhitChargent.ObjectId=requestPaymentWrap.cTransactionId;
                        jsonhitChargent.ChargeAmount=requestPaymentWrap.ChargeAmount;
                        jsonhitChargent.authenticationToken=requestPaymentWrap.authenticationToken;
                        String jsonBody = JSON.serialize(jsonhitChargent);
                        ChargentOrders.TChargentOperations.TChargentResult final_response = ChargentOrders.tChargentOperations.ChargeAuthorizedTransaction_ClickJSON(jsonBody);
                        System.debug('#####@ final response==> '+final_response);
                        if(final_response.Status=='OK'){
                            System.debug('###### FINAL OK');
                            statusCode='200';
                            status='successful!';
                            msg='Payment fulfill successfully';
                        }
                        else {
                            System.debug('###### FINAL ERROR');
                            statusCode='501';
                            status='error!';
                            msg='Payment error: '+final_response.Message;
                        }
                    }
                    else{
                        // TOKEN NOT VALID
                        statusCode='501';
                        status='error!';
                        msg='Transaction Authorize error!\n'+validationResult;

                    }
                }
                else{
                    // Order not found
                    statusCode='503';
                    status='error';
                    msg='Service Unavailable! No Order Found';

                }
            }
            else{
                // Transaction Id NOT VALID
                statusCode='503';
                status='error';
                msg='Service Unavailable! Incorrect Id';

            }
            // RETURN RESULT
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
           
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD final payment : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }
    // Method 5: 
    // @ desc: get Payment Method record for a cart(non customer)
    public Plant_Utility.responseWrapper getPaymentDetails(String cartId){
        cardWrapper paymtMtd = new cardWrapper();
        Boolean isPaymtRecd = false;
        String statusCode ='';
        String status ='';
        String msg ='';

        for(Plant_Order_Properties__c oprop : [SELECT Id, Plant_Payment_Method__c,Plant_Payment_Method__r.name,Plant_Payment_Method__r.Plant_Card_Type__c,Plant_Payment_Method__r.Plant_Card_Number__c,Plant_Payment_Method__r.CCV__c,Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,Plant_Payment_Method__r.Plant_Expiration_Date__c,
                                                Plant_Payment_Method__r.Plant_Customer_Name__c,Plant_Payment_Method__r.Plant_Account__c,Plant_Payment_Method__r.Plant_Street1__c,Plant_Payment_Method__r.Plant_Street2__c,Plant_Payment_Method__r.Plant_Street3__c,Plant_Payment_Method__r.Plant_City__c,Plant_Payment_Method__r.Plant_Country__c,
                                                Plant_Payment_Method__r.Plant_Province_State__c,Plant_Payment_Method__r.Plant_Postal_Code__c,Plant_Payment_Method__r.Plant_Can_SMS__c,Plant_Payment_Method__r.Plant_Phone__c FROM Plant_Order_Properties__c WHERE Id=:cartId ]){
            if(oprop.Plant_Payment_Method__c!=null){
                isPaymtRecd = true;
                paymtMtd.name = oprop.Plant_Payment_Method__r.name ;
                paymtMtd.cvv = oprop.Plant_Payment_Method__r.CCV__c ;
                paymtMtd.card_Type = oprop.Plant_Payment_Method__r.Plant_Card_Type__c ;
                paymtMtd.cardnumber = oprop.Plant_Payment_Method__r.Plant_Card_Number__c ;
                paymtMtd.card_Last_4_Digits = oprop.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c ;
                paymtMtd.expDate = String.valueOf(oprop.Plant_Payment_Method__r.Plant_Expiration_Date__c );
                
                    // billing address
                    Plant_Utility.addressCapsule billAdd = new Plant_Utility.addressCapsule();
                    billAdd.street1 = oprop.Plant_Payment_Method__r.Plant_street1__c ;
                    billAdd.street2 = oprop.Plant_Payment_Method__r.Plant_street2__c ;
                    billAdd.street3 = oprop.Plant_Payment_Method__r.Plant_street3__c ;
                    billAdd.city = oprop.Plant_Payment_Method__r.Plant_City__c ;
                    billAdd.state = oprop.Plant_Payment_Method__r.Plant_Province_State__c ;
                    billAdd.zip = oprop.Plant_Payment_Method__r.Plant_Postal_Code__c ;
                    billAdd.country = oprop.Plant_Payment_Method__r.Plant_Country__c ;
                    billAdd.phone = oprop.Plant_Payment_Method__r.Plant_Phone__c ;
                    billAdd.canSMS = oprop.Plant_Payment_Method__r.Plant_Can_SMS__c ;
                paymtMtd.billingAddress = billAdd;

            }

        }

        if(!isPaymtRecd){
            statusCode='503';
            status='error';
            msg+='Service Unavailable: No PaymentMethod Exist for Id';
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
        statusCode='200';
        status='success';
        msg+='Payment method detail retrieve';
        List<cardWrapper> respList = new List<cardWrapper>();
        respList.add(paymtMtd);
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
        return responseWrap;
    }


    // Method 6: 
    // @ desc: update Payment Method record  to display based on Account Id
    public Plant_Utility.responseWrapper setPaymentDetails(paymtUpdateWrap reqWrp){
        String statusCode ='';
        String status ='';
        String msg ='';
        boolean ifOrderidCorrect= false;        // true: if ongoing transactions remaining
        Order sfOdr = new Order();

        plantable_Constants__c custSettin = plantable_Constants__c.getValues('DevConstant'); // custom setting : constants
        Plant_Payment_Method__c pm_ToupdateRecd = new Plant_Payment_Method__c(); // to: verify existing payment method Id
        ChargentOrders__ChargentOrder__c temp_cOrder_Recd = new ChargentOrders__ChargentOrder__c(); // for customer
        Map<Id, ChargentOrders__Transaction__c> chargentPendingTrens_Map = new Map<Id, ChargentOrders__Transaction__c>();// for customer
        Plant_Order_Properties__c oprop = new Plant_Order_Properties__c();
        List<Plant_Payment_Method__c> existPaymentMethodList = new List<Plant_Payment_Method__c>();

        try{
            // set savepoint
            // check if wrapReq is null
            if(reqWrp!=null && !String.isBlank(reqWrp.cartId) && (!String.isBlank(reqWrp.paymentMethodId) || reqWrp.cardInformation!=NULL)){
                    
                // CHECK CART ID
                    oprop = [SELECT Id, Plant_Payment_Method__c,Plant_Account__c,Plant_Payment_Method__r.name,Plant_Payment_Method__r.Plant_Card_Type__c,Plant_Payment_Method__r.Plant_Card_Number__c,Plant_Payment_Method__r.CCV__c,Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c,Plant_Payment_Method__r.Plant_Expiration_Date__c,
                                                        Plant_Payment_Method__r.Plant_Customer_Name__c,Plant_Payment_Method__r.Plant_Account__c,Plant_Payment_Method__r.Plant_Street1__c,Plant_Payment_Method__r.Plant_Street2__c,Plant_Payment_Method__r.Plant_Street3__c,Plant_Payment_Method__r.Plant_City__c,Plant_Payment_Method__r.Plant_Country__c,
                                                        Plant_Payment_Method__r.Plant_Province_State__c,Plant_Payment_Method__r.Plant_Postal_Code__c,Plant_Payment_Method__r.Plant_Can_SMS__c,Plant_Payment_Method__r.Plant_Phone__c,Plant_First_Name__c,Plant_Last_Name__c FROM Plant_Order_Properties__c WHERE Id=:reqWrp.cartId LIMIT 1];
                    
                    
                    if(oprop!=null){
                        // for customer: GET sf ORDER (if any)
                        sfOdr = [SELECT id,TotalAmount, Status,Plant_Order_Properties__r.Plant_Payment_Method__c,Plant_Order_Properties__c, comty_Chargent_Order__c,AccountId,ContractId,OrderNumber,
                                 comty_Chargent_Order__r.ChargentOrders__Subtotal__c,comty_Chargent_Order__r.ChargentOrders__Payment_Frequency__c,comty_Chargent_Order__r.ChargentOrders__Billing_Address__c,
                                 comty_Chargent_Order__r.ChargentOrders__Billing_City__c,comty_Chargent_Order__r.ChargentOrders__Billing_State__c,comty_Chargent_Order__r.ChargentOrders__Billing_Zip_Postal__c,
                                 comty_Chargent_Order__r.ChargentOrders__Billing_Country__c,Plant_Subscription__c  FROM Order WHERE Plant_Order_Properties__c =: reqWrp.cartId AND comty_Chargent_Order__c!=null LIMIT 1];
                            if(sfOdr!=null && reqWrp.isCustomer){
                                ifOrderidCorrect= true;

                                // VALIDATE: check if not subscription type
                                if(sfOdr.Plant_Subscription__c!=null){
                                    statusCode='503';
                                    status='error';
                                    msg+=' Service Unavailable: Subscription record does not allow Order API';
                                }
                                else{
                                    // GET PENDING TRANSACTIONS(Authorize type transaction) OF cOrder
                                    Map<Id, ChargentOrders__Transaction__c> temp_chargentPendingTrens_Map = new Map<Id, ChargentOrders__Transaction__c>([SELECT Id, ChargentOrders__Type__c FROM ChargentOrders__Transaction__c WHERE ChargentOrders__Order__c=:sfOdr.comty_Chargent_Order__c AND ChargentOrders__Type__c='Authorization']);
                                    if(!temp_chargentPendingTrens_Map.isEmpty())
                                        chargentPendingTrens_Map= temp_chargentPendingTrens_Map;
                                }

                            }
                        
                        }
                    
                    // cart and Order
                    // CHECK card information(PaymentMethodId)
                    if(oprop!=null && statusCode!='503'){
                        if(oprop.Plant_Payment_Method__c==null){
                            statusCode='503';
                            status='error';
                            msg+=' Service Unavailable: Cart has no paymentMethodId';
                        } 
                        else{
                                                              
                            // check if: request to update card info
                            if(reqWrp.cardInformation!=null){

                                if(oprop.Plant_Payment_Method__c!=null){
                                    
                                    if(!String.isBlank(reqWrp.cardInformation.expDate)){
                                        if(Plant_Utility.checkDateFormat(reqWrp.cardInformation.expDate)){
                                            pm_ToupdateRecd.Plant_Expiration_Date__c = Date.valueOf(reqWrp.cardInformation.expDate );
                                        }
                                        else {
                                            statusCode='503';
                                            status='error';
                                            msg += ', expDate format incorrect';
                                        }
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.card_Last_4_Digits)){
                                        if (Plant_Utility.CheckValidInteger(reqWrp.cardInformation.card_Last_4_Digits)) {
                                            pm_ToupdateRecd.Plant_Card_Last_4_Digits__c = reqWrp.cardInformation.card_Last_4_Digits ;
                                        }else{
                                            statusCode='503';
                                            status='error';
                                            msg += ', card_Last_4_Digits format incorrect';
                                        }
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.cardnumber)){
                                        if (Plant_Utility.CheckValidInteger(reqWrp.cardInformation.cardnumber)) {
                                            pm_ToupdateRecd.Plant_Card_Number__c = reqWrp.cardInformation.cardnumber ;
                                        }else{
                                            statusCode='503';
                                            status='error';
                                            msg += ', cardnumber format incorrect';
                                        }
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.card_Type)){
                                        pm_ToupdateRecd.Plant_Card_Type__c = reqWrp.cardInformation.card_Type ;
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.cvv)){
                                        if (Plant_Utility.CheckValidInteger(reqWrp.cardInformation.cvv)) {
                                            pm_ToupdateRecd.CCV__c = reqWrp.cardInformation.cvv ;
                                        }else{
                                            statusCode='503';
                                            status='error';
                                            msg += ', cvv format incorrect';
                                        }
                                    }

                                    //  only update billing address 
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.street1)){
                                        pm_ToupdateRecd.Plant_street1__c = reqWrp.cardInformation.billingAddress.street1 ;
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.street2)){
                                        pm_ToupdateRecd.Plant_street2__c = reqWrp.cardInformation.billingAddress.street2 ;
                                    }
                                        
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.street3)){
                                        pm_ToupdateRecd.Plant_street3__c = reqWrp.cardInformation.billingAddress.street3 ;
                                    }
                                        
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.city)){
                                        pm_ToupdateRecd.Plant_City__c = reqWrp.cardInformation.billingAddress.city ;
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.state)){
                                        pm_ToupdateRecd.Plant_Province_State__c = reqWrp.cardInformation.billingAddress.state ;
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.zip)){
                                        pm_ToupdateRecd.Plant_Postal_Code__c = reqWrp.cardInformation.billingAddress.zip ;
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.country)){
                                        pm_ToupdateRecd.Plant_Country__c = reqWrp.cardInformation.billingAddress.country ;
                                    }
                                    if(!String.isBlank(reqWrp.cardInformation.billingAddress.phone) && Plant_Utility.CheckValidInteger(reqWrp.cardInformation.billingAddress.phone)){
                                        pm_ToupdateRecd.Plant_Phone__c = reqWrp.cardInformation.billingAddress.phone ;
                                    }
                                    else{
                                        if(String.isBlank(reqWrp.cardInformation.billingAddress.phone))
                                            msg += ' Error: Phone Incorrect';
                                            statusCode='503';
                                            status='error';
                                    }
                                    pm_ToupdateRecd.Plant_Can_SMS__c = reqWrp.cardInformation.billingAddress.canSMS ; 
                                }
                                else{
                                    statusCode='503';
                                    status='error';
                                    msg += ' Cart missing payment detials.';
                                }                                       
                            }// EXISTING PAYMENT ID(only via cOrder API)
                            else if(reqWrp.isCustomer && !String.isBlank(reqWrp.paymentMethodId)  && reqWrp.cardInformation==null){
                                // existPaymentMethodList = [SELECT id,Plant_Expiration_Date__c, Plant_Card_Type__c, CCV__c, Plant_Card_Number__c FROM Plant_Payment_Method__c WHERE id=:reqWrp.paymentMethodId AND Plant_Account__c=:oprop.Plant_Account__c];
                            }
                            else{
                                statusCode='503';
                                status='error';
                                msg += ' Cart Infomation missing';
                            } 

                        }                                                       

                    }
                
                    // UPDATE payment method record
                    if(statusCode!='503'){

                        // if : new card info (cart || Order)
                        // Order API: check sf order: pending transaction
                        if(ifOrderidCorrect){
                            boolean isTranstions = false;

                            // CHECK CHARGENT REMAINING TRANSACTION AND VOID
                            if(!chargentPendingTrens_Map.isEmpty()){
                                for(Id trnasctionId : chargentPendingTrens_Map.keySet()){
                                    
                                    ChargentOrders.TChargentOperations.TChargentResult auth_result = ChargentOrders.TChargentOperations.VoidTransaction_Click(trnasctionId);

                                    // System.debug('@@@@## transction Status=> '+auth_result.Status);
                                    // System.debug('@@@@## transction Message=> '+auth_result.Message);
                                    // System.debug('@@@@## transction TransactID=> '+auth_result.TransactID);
                                    // System.debug('@@@@## transction responseData=> '+auth_result.responseData);

                                    if(auth_result.responseData!=null){
                                        // SUCCESSFULL void CALLOUT
                                        Map<String,Object> responseDta = (Map<String,Object>)JSON.deserializeUntyped(auth_result.responseData);
                                        System.debug('#### key set==> '+responseDta.keySet());
                                        // complete transaction
                                        if(String.valueOf(responseDta.get('responseCode'))=='200'){

                                            System.debug('###### Transaction authorization OK');
                                            statusCode='200';
                                            status='successful!';
                                            msg+=' Transaction Void successfully';
                                            isTranstions= true;
                                        }
                                        else {
                                            statusCode='501';
                                            status='error!';
                                            msg+=' Transaction void error!'+auth_result.Message;

                                        }
                                    }
                                    else{
                                        // NO SUCCESS CALLOUT
                                        statusCode='501';
                                        status='error!';
                                        msg+=' Transaction void error!\n'+auth_result.Message;
                                    }
                                }
                            }
                                
                    
                            // Authorize new card with gateway (successfully void)
                            if(chargentPendingTrens_Map.isEmpty() || isTranstions){
                                String  charg_jsonBody ='';
                                
                                charg_jsonBody = JSON.serialize(new Plant_Orders_BC.chargentAuthorizeReq_class(sfOdr.comty_Chargent_Order__c,''+pm_ToupdateRecd.Plant_Expiration_Date__c.Month(),''+pm_ToupdateRecd.Plant_Expiration_Date__c.Year(),custSettin.chargentOrderPaymentMethod__c,pm_ToupdateRecd.Plant_Card_Type__c, pm_ToupdateRecd.CCV__c,pm_ToupdateRecd.Plant_Card_Number__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Subtotal__c,false, oprop.Plant_First_Name__c!=null?oprop.Plant_First_Name__c:'',oprop.Plant_Last_Name__c!=null?oprop.Plant_Last_Name__c:'',sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_Address__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_City__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_State__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_Zip_Postal__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_Country__c));

                                // charg_jsonBody = JSON.serialize(new Plant_Orders_BC.chargentAuthorizeReq_class(sfOdr.comty_Chargent_Order__c,''+pm_ToupdateRecd.Plant_Expiration_Date__c.Month(),''+pm_ToupdateRecd.Plant_Expiration_Date__c.Year(),custSettin.chargentOrderPaymentMethod__c,pm_ToupdateRecd.Plant_Card_Type__c, pm_ToupdateRecd.CCV__c,pm_ToupdateRecd.Plant_Card_Number__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Subtotal__c,false, oprop.Plant_First_Name__c!=null?oprop.Plant_First_Name__c:'',oprop.Plant_Last_Name__c!=null?oprop.Plant_Last_Name__c:'',sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_Address__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_City__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_State__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_Zip_Postal__c,sfOdr.comty_Chargent_Order__r.ChargentOrders__Billing_Country__c));
                                System.debug('@@@@@ new Transaction body ==> '+charg_jsonBody);
                                // call chargent : authorize order 
                                ChargentOrders.TChargentOperations.TChargentResult new_auth_result = ChargentOrders.TChargentOperations.AuthorizeOrder_ClickJSON(charg_jsonBody);
                                // System.debug('@@@@## new transction Status=> '+new_auth_result.Status);
                                // System.debug('@@@@## transction Message=> '+new_auth_result.Message);
                                // System.debug('@@@@## new transction TransactID=> '+new_auth_result.TransactID);
                                // System.debug('@@@@## transction responseData=> '+new_auth_result.responseData);
                                
                                if(new_auth_result.responseData!=null){
                                    // SUCCESSFULL CALLOUT
                                    Map<String,Object> responseDta = (Map<String,Object>)JSON.deserializeUntyped(new_auth_result.responseData);
                                    System.debug('#### key set==> '+responseDta.keySet());
                                    // complete transaction
                                    if(new_auth_result.Status=='OK' && new_auth_result.TransactID!=null && String.valueOf(responseDta.get('responseCode'))=='200' && String.valueOf(responseDta.get('isApproved'))=='true'){
                
                                        System.debug('###### new Transaction authorization OK');
                                        statusCode='200';
                                        status='successful!';
                                        msg=' , new card authorize successfully';
                                        List<TransactionResp_Wrap> responseList = new List<TransactionResp_Wrap>();
                                        TransactionResp_Wrap resps = new TransactionResp_Wrap(new_auth_result.TransactID,sfOdr.comty_Chargent_Order__r.ChargentOrders__Subtotal__c);
                                        responseList.add(resps);
                                        List<String> respList = new List<String>();
                                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
                                        System.debug('########## new RESPONSE Auth Transaction => '+responseWrap);
                                        System.debug('###@@ payment method insert 1 => '+pm_ToupdateRecd);
                                        
                                            // insert new payment method record
                                            insert pm_ToupdateRecd;

                                            // update order property
                                            oprop.Plant_Payment_Method__c = pm_ToupdateRecd.Id;
                                            update oprop; 
                                    }
                                    else {
                                        statusCode='501';
                                        status='error!';
                                        msg=' , new card Authorize error!'+new_auth_result.Message;
                
                                    }
                                }
                                else{
                                    // NO SUCCESS CALLOUT
                                    statusCode='501';
                                    status='error!';
                                    msg=' , new card  Authorize error!\n'+new_auth_result.Message;
                                }

                            }
                                
                        }
                        else{// no pending transactions
                            System.debug('###@@ payment method updated => '+pm_ToupdateRecd);
                            
                            insert  pm_ToupdateRecd;
                            // update order property
                            oprop.Plant_Payment_Method__c = pm_ToupdateRecd.Id;
                            update oprop; 
                        }
                        
                        statusCode='200';
                        status='successful';
                        msg+=' Update Payment info';  
                    }
            }
            else{
                statusCode='501';
                status='error';
                msg+=' Not Implemented : Requird parameter missing';
            }

            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Payment Update : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: Payment Update - '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }

    //  // Method 6.1: 
    // // @ desc: update Payment Method record on order to display based on Account Id
    // public Plant_Utility.responseWrapper setCustomer_PaymentDetails(customer_PaymtUpdateWrap req_Wrp){
    //     String statusCode='';
    //     String status='';
    //     String msg='';
    //     String existingCustomerId = '';

    //     try{
    //         if(req_Wrp!=null){
                
    //             // VALIDATION 1: valid authorization token
    //             if(!String.isBlank(req_Wrp.authenticationToken)){
    //                 // check Authorize token
    //                 String validationResult = plant_AuthorizeController.validate_ByAccessToken(req_Wrp.authenticationToken);
    //                 System.debug('### auth result=> '+validationResult);
    //                 if(validationResult.startsWith('Success')){
    //                     existingCustomerId =  validationResult.split(',')[1];
    //                 }
    //                 else{
    //                     statusCode='503';
    //                     status='error';
    //                     msg+='Service Unavailable! Account : '+validationResult;
    //                 }

    //                 // VALIDATION 2: Check Order Number If not emptu
    //                 if(!String.isBlank(req_Wrp.OrderNumber) && Plant_Utility.CheckValidInteger(req_Wrp.OrderNumber)){

    //                     // VALIDATION 3: Check Order and Modification Deadline validaiton
    //                     List<Order> OrderList =  [SELECT id, OrderNumber,Modification_Deadline_Exceeded__c,Plant_Order_Properties__c,Plant_Order_Properties__r.Plant_Payment_Method__c FROM Order WHERE OrderNumber=:req_Wrp.OrderNumber AND AccountId=:existingCustomerId ]; 
    //                     if(!OrderList.isEmpty()){

    //                         // VALIDATION 5: check for "Modification Deadline"
    //                         if(!OrderList[0].Modification_Deadline_Exceeded__c){

    //                             // VALIDATION 4 : check if cart record avialable
    //                             if(OrderList[0].Plant_Order_Properties__c!=null){
    //                                 // create wrapper for "setPaymentDetails" method request wrapper method
    //                                  paymtUpdateWrap newReq = new paymtUpdateWrap();
    //                                  newReq.cartId = OrderList[0].Plant_Order_Properties__c;
    //                                 //  newReq.paymentMethodId  = OrderList[0].Plant_Order_Properties__r.Plant_Payment_Method__c;
    //                                  newReq.isCustomer = True;
    //                                  if(req_Wrp.cardInformation!=null)
    //                                     newReq.cardInformation = req_Wrp.cardInformation;
    //                                  newReq.paymentMethodId  = req_Wrp.paymentMethodId;
                                     

    //                                 // call setPaymentDetails
    //                                 Plant_Utility.responseWrapper pymt_Update_Response= setPaymentDetails(newReq);
    //                                 return pymt_Update_Response;
                                    
    //                             }
    //                             else{
    //                                 statusCode='503';
    //                                 status='error';
    //                                 msg+='Service Unavailable! Unable to update, Record Missing required field, Contact Support!';
    //                             }
    //                         }
    //                         else{
    //                             statusCode='503';
    //                             status='error';
    //                             msg+='Service Unavailable! Record is locked, Can not update now';
    //                         }
                            
    //                     }
    //                     else{
    //                         statusCode='503';
    //                         status='error';
    //                         msg+='Service Unavailable! No Order Available';
    //                     }
                        
    //                 }
    //                 else{
    //                     statusCode='503';
    //                     status='error';
    //                     msg+='Service Unavailable! Required field missing. Order Number';
    //                 }

    //             }
    //             else{
    //                 statusCode='503';
    //                 status='error';
    //                 msg+='Service Unavailable! No Token found';
    //             }
    //         }
    //         else{
    //             statusCode='503';
    //             status='error';
    //             msg+='Service Unavailable! Incorrect parameter';
    //         }

    //     }
    //     catch(Exception ex){
    //         System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD customer meal Update: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
    //         statusCode='500';
    //         status='error';
    //         msg+=' Internal Server Error: '+ex.getMessage();
    //     }

    //     List<String> responseList = new List<String>();
    //     Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
    //     return responseWrap;

    // }


    // Method 8:
    // @desc: get meal list and meal selection for an Order
    public  Plant_Utility.responseWrapper getOrder_MealDetails(wrapOrder_MealReq odrM_req){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        wrapOrder_MealResp response = new wrapOrder_MealResp();
        List<wrapOrder_MealResp> responseList = new List<wrapOrder_MealResp>();

        try{

            if(odrM_req!=null){

                //Validate 2: CHECK ACCOUNT TOKEN
                if(!String.isBlank(odrM_req.authenticationToken)){
                    System.debug('### auth token => '+odrM_req.authenticationToken);
                    // check Authorize token
                    String validationResult = plant_AuthorizeController.validate_ByAccessToken(odrM_req.authenticationToken);
                    System.debug('### auth result=> '+validationResult);
                    if(validationResult.startsWith('Success')){
                        existingCustomerId =  validationResult.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Account : '+validationResult;
                    }

                    //Validate 2: check ORDER NO
                    List<Order> orderList = [SELECT id,OrderNumber, AccountId, Plant_Order_Properties__c, Plant_Order_Properties__r.Plant_Meal_Selection__c FROM Order WHERE AccountId=:existingCustomerId AND OrderNumber=:odrM_req.orderNo];
                    if(orderList.isEmpty()){
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Order Not found ';
                    }
                    else if(orderList[0].Plant_Order_Properties__c==null || orderList[0].Plant_Order_Properties__r.Plant_Meal_Selection__c==null){
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Error With Order Details';
                    }
                    else{
                        for(Plant_Meal_Selection__c mealSel : [SELECT id, Plant_Description__c, (SELECT Id,Plant_Quantity__c,Plant_Meal_Selection__c,Plant_Meal__c,Plant_Meal__r.Name FROM Meal_Selection_Meals__r) FROM Plant_Meal_Selection__c WHERE Id=:orderList[0].Plant_Order_Properties__r.Plant_Meal_Selection__c]){
                            List<Plant_Utility.wrapMeal_RespBody> resp_List=new List<Plant_Utility.wrapMeal_RespBody>();
                            System.debug('###########   Meal Selection List '+mealSel);
                            System.debug('###########   Meal Selection Meal id  '+mealSel.Meal_Selection_Meals__r);
                            response.mealSelectionId = mealSel.Id;
                            for(Plant_Meal_Selection_Meal__c selctMeal : mealSel.Meal_Selection_Meals__r){
                                Plant_Utility.wrapMeal_RespBody resp = new Plant_Utility.wrapMeal_RespBody();
                                resp.meal = selctMeal.Plant_Meal__r.Name;
                                resp.quantity = Integer.valueOf(selctMeal.Plant_Quantity__c);
                                resp.mealId = selctMeal.Plant_Meal__c;
                                System.debug('################ resp Meal'+resp);
                                resp_List.add(resp);
                                
                            }
                            response.mealList=resp_List;
                        }
                        
                        responseList.add(response);

                        statusCode='200';
                        status='Success';
                        if(response.mealSelectionId!=null){
                            msg+='Meal List Retreive Successfully';
                        }
                        else{
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable! No Meal Selection Found';
                        }
                    }
                
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! No Token found';
                }
            }
            else{
                System.debug('&&&&&&&& ');
                statusCode='503';
                status='error';
                msg+='Service Unavailable! Incorrect parameter';
            }
        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD customer meal: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
        }

        List<opResponseWrap> respList = new List<opResponseWrap>();
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
        return responseWrap;

    }

    // Method 9:
    // @desc: update meals from Customer order(24 hr from create)
    public  Plant_Utility.responseWrapper updateOrder_Meals(CustomerMeal_UpdateReq_Wrapper odrMeal_WrapObj){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';

        try{
            if(odrMeal_WrapObj!=null){
                
                // VALIDATION 1: valid authorization token
                if(!String.isBlank(odrMeal_WrapObj.authenticationToken)){
                    // check Authorize token
                    String validationResult = plant_AuthorizeController.validate_ByAccessToken(odrMeal_WrapObj.authenticationToken);
                    System.debug('### auth result=> '+validationResult);
                    if(validationResult.startsWith('Success')){
                        existingCustomerId =  validationResult.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Account : '+validationResult;
                    }

                    // VALIDATION 2: Check Order Number If not emptu
                    if(!String.isBlank(odrMeal_WrapObj.OrderNumber) && Plant_Utility.CheckValidInteger(odrMeal_WrapObj.OrderNumber)){
                        // VALIDATION 3: Check Order and Modification Deadline validaiton
                        List<Order> OrderList =  [SELECT id, AccountId, OrderNumber,Modification_Deadline_Exceeded__c, Plant_Order_Properties__c,Plant_Order_Properties__r.Plant_Meal_Selection__c FROM Order WHERE OrderNumber=:odrMeal_WrapObj.OrderNumber AND AccountId=:existingCustomerId ]; 
                        if(!OrderList.isEmpty()){
                            if(!OrderList[0].Modification_Deadline_Exceeded__c){
                                // VALIDATION : check if meal selection record avialable
                                if(OrderList[0].Plant_Order_Properties__c!=null && OrderList[0].Plant_Order_Properties__r.Plant_Meal_Selection__c!=null){
                                    // create wrapper for Meal_BC meal Selection update method
                                    Plant_Meals_BC.MealSelectionReq_Wrapper mealSelectionWrap = new Plant_Meals_BC.MealSelectionReq_Wrapper();
                                    // Inserting new meal selection 
                                    Plant_Meal_Selection__c mselection = new Plant_Meal_Selection__c();
                                    insert mselection;
                                    // Updating Order Property
                                    Plant_Order_Properties__c odrpropty=new Plant_Order_Properties__c();
                                    odrpropty.id=OrderList[0].Plant_Order_Properties__c;
                                    odrpropty.Plant_Meal_Selection__c=mselection.id;
                                    update odrpropty;
                                                                        
                                    mealSelectionWrap.mealSelectionId = mselection.id;
                                    //mealSelectionWrap.mealSelectionId = OrderList[0].Plant_Order_Properties__r.Plant_Meal_Selection__c;
                                    mealSelectionWrap.mealList = odrMeal_WrapObj.mealList;

                                    // call meal_SC
                                    Plant_Utility.responseWrapper mealUpdate_Response= Plant_Meals_SC.setMealSelection(mealSelectionWrap);
                                    
                                    // AG - Add post Order Event
                                    Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Meal Change',OrderList[0].AccountId,OrderList[0].id,null));
                                    
                                    // AG - Update Inventory
                                    Plant_Orders_BC.replaceOrderInventory(OrderList[0].Plant_Order_Properties__r.Plant_Meal_Selection__c, mselection.id);

                                    return mealUpdate_Response;
                                }
                                else{
                                    statusCode='503';
                                    status='error';
                                    msg+='Service Unavailable! No Meal Selection Available';
                                }
                            }
                            else{
                                statusCode='503';
                                status='error';
                                msg+='Service Unavailable! Record is locked, Can not update now';
                            }                            
                        }
                        else{
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable! No Order Available';
                        }
                        
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Required field missing. Order Number';
                    }

                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! No Token found';
                }
            }
            else{
                statusCode='503';
                status='error';
                msg+='Service Unavailable! Incorrect parameter';
            }

        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD customer meal Update: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
        }

        List<String> responseList = new List<String>();
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
        return responseWrap;
    }

     // Method 10:
    // @desc: Cancel Order from Customer (24 hr from create)
    public  Plant_Utility.responseWrapper cancelOrder_method(wrapOrder_MealReq cancelOrderReq){
        
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        
        try{
            //Validate 1: CHECK ACCOUNT TOKEN
            if(!String.isBlank(cancelOrderReq.authenticationToken)){
                System.debug('### cancel order: auth token => '+cancelOrderReq.authenticationToken);
                // check Authorize token
                String validationResult = plant_AuthorizeController.validate_ByAccessToken(cancelOrderReq.authenticationToken);
                System.debug('### auth result=> '+validationResult);
                if(validationResult.startsWith('Success')){
                    existingCustomerId =  validationResult.split(',')[1];
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Account : '+validationResult;
                }
            }

            if(existingCustomerId!=null){
                // check orderNumber valid with Account
                //Validate 2: check ORDER NO
                List<Order> orderList = [SELECT id,OrderNumber,Modification_Deadline_Exceeded__c, status, AccountId,comty_Chargent_Order__c, Plant_Order_Properties__c, Plant_Order_Properties__r.Plant_Meal_Selection__c,Plant_Subscription__c FROM Order WHERE AccountId=:existingCustomerId AND OrderNumber=:cancelOrderReq.orderNo];
                if(orderList.isEmpty()){
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Order Not found ';
                }
                else{

                    // 24 hr modification check
                    if(!OrderList[0].Modification_Deadline_Exceeded__c){

                        // check if any subscription for this order
                        List<Plant_Subscription__c> pt_Subs_List = [SELECT Id,Plant_Account__c,Plant_Status__c,
                        Plant_Account__r.plant_TokenCreatedDateTime__c FROM Plant_Subscription__c WHERE Plant_Account__c=:existingCustomerId AND Id=:OrderList[0].Plant_Subscription__c /* Plant_Next_Pending_Order__c=:orderList[0].id*/ LIMIT 1];

                        if(!pt_Subs_List.isEmpty()){
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable! Order under subscription, can not cancel order.';
                        }
                        else{
                            // Just to update Order Only
                            // update subscription
                            // Plant_Subscription__c subs = pt_Subs_List[0];
                            // subs.Plant_Status__c='Canceled';
                            // update subs;

                            // update chargent Order
                            ChargentOrders__ChargentOrder__c chargnt = new ChargentOrders__ChargentOrder__c();
                            chargnt.id = orderList[0].comty_Chargent_Order__c;
                            chargnt.ChargentOrders__Payment_Stop__c = 'Stopped';
                            update chargnt;

                            //update order
                            Order odrRcd =  orderList[0];
                            odrRcd.status='Canceled';
                            update odrRcd;

                            // cancel shipment
                            List<Plant_Shipment__c> toUpdate_Shipment = new List<Plant_Shipment__c>();
                            for(Plant_Shipment__c shipmt: [SELECT id,Plant_Order__c,Plant_Status__c FROM Plant_Shipment__c WHERE Plant_Order__c=:orderList[0].Id AND (Plant_Status__c='Pending' OR Plant_Status__c='In Progress') ORDER BY CreatedDate DESC]){
                                shipmt.Plant_Status__c = 'Cancelled';
                                toUpdate_Shipment.add(shipmt);
                            }
                            
                            if(!toUpdate_Shipment.isEmpty()){
                                update toUpdate_Shipment;
                            }
                            
                            // AG - Add post Order Event
                            Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Cancelled',OrderList[0].AccountId,OrderList[0].id,null));

                            statusCode='200';
                            status='Success';
                            msg+=' Order: '+odrRcd.OrderNumber+' Cancled Successfully';
                        }
                        
                        
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Record is locked, Can not update now';
                    }                    
                }
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD cancel order : '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
        }

        // RETURN
        List<String> respList = new List<String>();
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
        return responseWrap;
    }
    
    // Method 11
    // @desc: get Result of Trancastion made by a card
    public Plant_Utility.responseWrapper getCardAuthenticationResult(getCardStatus reqWrap){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        List<Object> responseList = new List<Object>();
        try{
            if(!String.isBlank(reqWrap.authenticationToken)){
                System.debug('### cancel order: auth token => '+reqWrap.authenticationToken);
                // check Authorize token
                String validationResult = plant_AuthorizeController.validate_ByAccessToken(reqWrap.authenticationToken);
                System.debug('### auth result=> '+validationResult);
                if(validationResult.startsWith('Success')){
                    existingCustomerId =  validationResult.split(',')[1];
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Account : '+validationResult;
                }
            }
            if(existingCustomerId!=null){
        
                List<Plant_Site_ReqBody__c>  siteReq=[Select id, endpoint__c, Plant_Account__c, Plant_Responces__c, Plant_Chargent_Order__c, Plant_Request_Body__c, Plant_Done__c, Plant_Response__c, Plant_Status__c FROM Plant_Site_ReqBody__c where id=:reqWrap.processId AND Plant_Account__c=:existingCustomerId Limit 1];
                if(!siteReq.isEmpty()){
                    if(siteReq[0].endpoint__c=='ProcessTransaction'){
                        if(siteReq[0].Plant_Status__c == 'Success' && siteReq[0].Plant_Response__c!=null){
                            system.debug('@@@@@ Responce Wrapper '+siteReq[0].Plant_Response__c);
                            Map<String, Object> response = (Map<String, Object>)JSON.deserializeUntyped(siteReq[0].Plant_Response__c);
                            if(response.keyset().contains('result')){
                                Map<String, Object> res =(Map<String, Object>)response.get('result');
                                if(res.keyset().contains('resultArr')){
                                    //res.get('resultArr');
                                    responseList.add((List<Object>)res.get('resultArr'));
                                    statusCode='200';
                                    status='Success';
                                    msg+=' Transaction authorize successfully ';
                                    System.debug('@@@@@ Transaction Map Id  '+responseList);
                        
                                }
                            }
                            
                        }
                        else{
                            statusCode='200';
                            status='Success';
                            msg+=' Your Process Transaction is still in progress, Please try Again... ';
                        }
                    }
                    else{
                        if(siteReq[0].Plant_Status__c == 'Success'){
                            statusCode='200';
                            status='Success';
                            msg+=' Your Process Payment is Successfull';
                        }
                        else{
                            statusCode='200';
                            status='Success';
                            msg+=' Your Process Payment is still in Progress, Please try Agian... ';
                        }

                    }
                    
                } 
                else{
                    statusCode='503';
                    status='error';
                    msg+=' Non card Authentication Process found with this Account and Id';
                }
            }


        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD cancel order : '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
        }

        //List<String> respList = new List<String>();
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
        return responseWrap;
    }

    // Method 12
    // @desc: change Order Delivery Date
    public Plant_Utility.responseWrapper changeOrderDeliveryDate(OrderDeliveryDate_Wrap reqWrap){
        String status = '';
        String msg = '';
        String statusCode = '';
        String existingCustomerId= '';
        SavePoint initialState = Database.setSavePoint();
        try{

            // Verifying the Body of Responce Wrapper
            if(reqWrap !=null){

                //Getting Customer Id from Authentication token
                if(reqWrap.authenticationToken!=null && !String.isBlank(reqWrap.authenticationToken)){
                    String validationResult = plant_AuthorizeController.validate_ByAccessToken(reqWrap.authenticationToken);
                    System.debug('### auth result=> '+validationResult);
                    if(validationResult.startsWith('Success')){
                        existingCustomerId =  validationResult.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Account : '+validationResult;
                    }
                }

                //getting Order  
                if(existingCustomerId!=null && !String.isBlank(reqWrap.orderNumber)){
                    List<Order> odr= [SELECT Id, OwnerId, ContractId, AccountId,  StatusCode, OrderNumber, TotalAmount, CreatedDate, CreatedById, LastModifiedDate, 
                    Recurring_Payment_Order__c, Chargent_Order__c, Plant_Order_Properties__c, Plant_Subscription__c, comty_Chargent_Order__c, 
                    Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c, Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c,
                    Amount_to_Pay__c, Plant_Subscription__r.Plant_Next_Shipment_Date__c, Modification_Deadline_Exceeded__c, Plant_Delivery_Date__c, Plant_Shipping_Date__c FROM Order where OrderNumber=:reqWrap.orderNumber AND AccountId=:existingCustomerId Limit 1];
                    //Checking modification Deadline
                    if(odr[0].Modification_Deadline_Exceeded__c !=true){
                      //Validating Date Format
                      if(Plant_Utility.checkDateFormat(reqWrap.new_Delivery_Date)){
                        if(odr[0].Plant_Order_Properties__c !=null){
                            Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                            tempAddrsWrap.state=odr[0].Plant_Order_Properties__r.Shipping_Address__r.Plant_Province_State__c;
                            tempAddrsWrap.zip=odr[0].Plant_Order_Properties__r.Shipping_Address__r.Plant_Postal_Code__c;
                                // check: Available delivery date for the address
                                Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                                if(availableDates_List.status=='success'){
                                    if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                        if(availableDates_List.result.resultMap.keySet().size()==0){
                                            statusCode='503';
                                            status='error';
                                            msg+=reqWrap.new_Delivery_Date+' delivery date not available for this address,';
                                        }
                                        else{
                                            Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                            if(avail_DeliveryDaye_Map.keySet().contains(reqWrap.new_Delivery_Date)){
                                                System.debug('@@@ Delivery Date Record : '+avail_DeliveryDaye_Map.keySet().contains(reqWrap.new_Delivery_Date));
                                                //System.debug('@@@@ Gertting Values + : for ID of shipping Address '+avail_DeliveryDaye_Map.get(reqWrap.new_Delivery_Date).split(':')[0]);
                                                Plant_Shipping_Date__c sAddress = new Plant_Shipping_BC().getShipDateRecord(avail_DeliveryDaye_Map.get(reqWrap.new_Delivery_Date).split(':')[0]);
                                                System.debug('@@@ Delivery Date Id Plant_Shipping_BC : '+sAddress.id);
                                                // // update order delivery dates
                                                //if(sAddress)
                                                if((odr[0].Plant_Subscription__c != null && odr[0].Plant_Subscription__r.Plant_Next_Shipment_Date__c !=null && Date.valueOf(reqWrap.new_Delivery_Date)<odr[0].Plant_Subscription__r.Plant_Next_Shipment_Date__c)
                                                || (odr[0].Plant_Subscription__c != null && odr[0].Plant_Subscription__r.Plant_Next_Shipment_Date__c ==null)){
                                                    
                                                    Order next_Odr = new Order();
                                                    next_Odr.Id = odr[0].id;
                                                    next_Odr.Plant_Delivery_Date__c = Date.valueOf(reqWrap.new_Delivery_Date);
                                                    next_Odr.Plant_Shipping_Date__c = sAddress.id;
                                                    update next_Odr;
                                                    
                                                    Plant_Order_Properties__c odr_Property=new Plant_Order_Properties__c();
                                                    System.debug('@@@@ orderProperty Id : '+odr[0].Plant_Order_Properties__c);
                                                    odr_Property.id=odr[0].Plant_Order_Properties__c;
                                                    odr_Property.Plant_Delivery_Date__c = Date.valueOf(reqWrap.new_Delivery_Date);
                                                    odr_Property.Plant_Shipping_Date__c = sAddress.id;
                                                    update odr_Property;
                                                    
                                                    // AG - Add post Order Event
                                                    Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Date Change',odr[0].AccountId,odr[0].id,null));
                                                    
                                                    Status = 'Success';
                                                    StatusCode='200';
                                                    msg='Delivery date updated successfully.\nNew Shipping date:  '+sAddress.Plant_Shipping_Date__c;
                                                }
                                                    
                                                else{
                                                    statusCode='503';
                                                    status='error';
                                                    msg+='Delivery dates are after than next order shipping date, ';
                                                    }
                                                
                                            }
                                            else {
                                                // NOT AVAILABLE
                                                statusCode='503';
                                                status='error';
                                                msg+='Delivery date not available for address, ';
                                            }
                                        }
                                        
                                    }
                                    else{
                                        status = availableDates_List.status;
                                        msg    = availableDates_List.msg;
                                        statusCode = availableDates_List.statusCode;
                                    }
                                }
                                else {
                                    status = availableDates_List.status;
                                    msg = availableDates_List.msg;
                                    statusCode = availableDates_List.statusCode;
                                }
                            }
                            // }else{
                            //     statusCode='503';
                            //     status='error';
                            //     msg+='Delivery dates are after than next order shipping date, ';
                            // }
                      } 
                      else{
                        statusCode='503';
                        status='error';
                        msg+='Incorrect Date format please try (yyyy-mm-dd), ';
                      } 
                    }
                    else{
                        msg='Can not update this order Now, Modification Time is over';
                        statusCode='200';
                        status='Success';
                    }
                }
            }else{
                msg='Wrong Wrapper Body';
                statusCode='503';
                status='Error';
                
            }
        }catch(Exception ex){
                System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD DD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
                statusCode='500';
                status='error';
                msg+=', Internal Server Error: '+ex.getMessage();
                Database.rollback(initialState);
        }
        List<String> respList=new List<String>();
        Plant_Utility.responseWrapper responseWrap=new Plant_Utility.responseWrapper(status, StatusCode, msg, new Plant_Utility.responseListWrapper(respList));
        return responseWrap;
    } 

    //@ Method 2~~~~~~~~~~~~~~~~~~~~~~~~~~
    //@ Desc: Get orders related to Account
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper getOrders(String authenticationToken, String subscriptionId){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
        
        List<Order_ResponseWrap> ordr_respList=new List<Order_ResponseWrap>();
        try{
            if(authenticationToken!=null){
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(authenticationToken);
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Account : '+accAuthResut;
                    }
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Invalid Authentication Token';
                }
                
                if(!String.isBlank(existingCustomerId)){
                    
                    List<Order> sfOrder_List=new List<Order>();
                    if(!String.isBlank(subscriptionId)){
                        List<Plant_Subscription__c> checkSubId = [Select id from Plant_Subscription__c where id=:subscriptionId AND Plant_Account__c=:existingCustomerId Limit 1];
                        if(!checkSubId.isEmpty()){
                            sfOrder_List = [SELECT id,(Select Product2.name from OrderItems Limit 1), Status, OrderNumber, EffectiveDate,
                                    comty_Chargent_Order__r.ChargentOrders__Charge_Amount__c,
                                    comty_Chargent_Order__r.ChargentOrders__Invoice_Number__c,
                                    Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c
                                    FROM Order WHERE AccountId=:existingCustomerId AND Plant_Subscription__c=:subscriptionId Limit 49999];
                        }
                        else{
                            statusCode='503';
                            status='error';
                            msg+='Invalid Subscription Id';
                        }
                    }
                    else{
                        sfOrder_List = [SELECT id,(Select Product2.name from OrderItems Limit 1), Status, OrderNumber, EffectiveDate,
                                    comty_Chargent_Order__r.ChargentOrders__Charge_Amount__c,
                                    comty_Chargent_Order__r.ChargentOrders__Invoice_Number__c,
                                    Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c
                                    FROM Order WHERE AccountId=:existingCustomerId Limit 49999];

                    }
                    if(!sfOrder_List.isEmpty()){
                        for(Order ordr:sfOrder_List){
                            Order_ResponseWrap order_res=new Order_ResponseWrap();
                            
                            order_res.DateOrdered=ordr.EffectiveDate;
                            order_res.InvoiceNumber=ordr.comty_Chargent_Order__r.ChargentOrders__Invoice_Number__c;
                            order_res.OrderNumber=ordr.OrderNumber;
                            order_res.ShipmentDate=ordr.Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c;
                            order_res.status=ordr.Status;
                            order_res.AmountPaid=ordr.comty_Chargent_Order__r.ChargentOrders__Charge_Amount__c;
                            if(!ordr.OrderItems.isEmpty()){
                                order_res.product=ordr.OrderItems[0].product2.name;
                            }else{
                                status = 'Sucess';
                                statusCode='200';
                                msg+=', This order does not have any product currently';
                            }
                            ordr_respList.add(order_res);
                        }
                        status = 'Sucess';
                        statusCode='200';
                        msg+='Orders created by this Account extracted Sucessfully';
                    }
                    else{
                        status = 'Sucess';
                        statusCode='200';
                        msg+=', No Order Found for this Account';
                    }
                    
                    
                }
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(ordr_respList));
                return responseWrap;
            }
            else{
                System.debug('&&&&&&&& = > 13');
                statusCode='503';
                status='error';
                msg+=', Service Unavailable!';
                List<String> respList = new List<String>();
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                return responseWrap;
            }
        }
        catch(Exception ex){
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }

    
    //@ Method 3~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //@ Desc: Get order Details using access token and Order Number
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper getOrderDetails(String authenticationToken, String OrderNo){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
        
        List<OrderDetails_Wrap> ordr_respList=new List<OrderDetails_Wrap>();
        try{
            if(authenticationToken!=null && OrderNo!=null){
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(authenticationToken);
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Account : '+accAuthResut;
                    }
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Invalid Authentication Token';
                }
                
                if(!String.isBlank(existingCustomerId)){
                    List<ChargentOrders__Transaction__c> cTransaction=new List<ChargentOrders__Transaction__c>();
                    List <Order> sfOrder_List=new List<Order>();
                    List<Plant_Shipment__c> pshipment=new List<Plant_Shipment__c>();
                    
                    if(!String.isBlank(OrderNo)){
                        sfOrder_List = [SELECT id,(Select Product2.name from OrderItems Limit 1), Status, OrderNumber, EffectiveDate,
                                        comty_Chargent_Order__r.ChargentOrders__Charge_Amount__c,Modification_Deadline_Exceeded__c, Modification_Deadline__c,
                                        Plant_Order_Properties__r.Plant_Recurrence__c, Plant_Order_Properties__r.Plant_Meal_Selection__c,
                                        comty_Chargent_Order__r.ChargentOrders__Invoice_Number__c,Plant_Subscription__c, Plant_Subscription__r.Plant_Meal_Selection__c,
                                        Plant_Order_Properties__r.Plant_Shipping_Date__r.Plant_Shipping_Date__c,
                                        Plant_Order_Properties__r.Plant_Delivery_Date__c, comty_Chargent_Order__c,Plant_Delivery_Date__c,Plant_Shipping_Date__c, Plant_Shipping_Date__r.Plant_Shipping_Date__c
                                        FROM Order WHERE AccountId=:existingCustomerId AND OrderNumber=:OrderNo Limit 1];
                        
                        if(!sfOrder_List.isEmpty()){
                            
                            // CHECK cOrder: if payment mader for order
                            if(sfOrder_List[0].comty_Chargent_Order__c!=null){
                                
                                cTransaction=[Select id, ChargentOrders__Card_Last_4__c,ChargentOrders__Amount__c,ChargentOrders__Payment_Method__c,
                                              ChargentOrders__Gateway_Date__c from ChargentOrders__Transaction__c 
                                              where ChargentOrders__Order__c=:sfOrder_List[0].comty_Chargent_Order__r.id order by createddate DESC Limit 1];
                                
                                if(!cTransaction.isEmpty()){
                                    
                                    pshipment=[Select id, Plant_Status__c, Plant_Tracking_Number__c FROM Plant_Shipment__c WHERE Chargent_Transaction__c=:cTransaction[0].id Limit 1];
                                }
                            }
                            
                            // iterate through sf order 
                            for(Order sfOrder : sfOrder_List){
                                
                                OrderDetails_Wrap order_res=new OrderDetails_Wrap();
                                order_res.DateOrdered=sfOrder.EffectiveDate;
                                order_res.InvoiceNumber = (sfOrder.comty_Chargent_Order__r!=null && sfOrder.comty_Chargent_Order__r.ChargentOrders__Invoice_Number__c!=null) ? sfOrder.comty_Chargent_Order__r.ChargentOrders__Invoice_Number__c : '';
                                order_res.OrderNumber=sfOrder.OrderNumber;
                                order_res.ShipmentDate= sfOrder.Plant_Shipping_Date__r.Plant_Shipping_Date__c;
                                order_res.status=sfOrder.Status;
                                order_res.AmountPaid=(sfOrder.comty_Chargent_Order__r!=null && sfOrder.comty_Chargent_Order__r.ChargentOrders__Charge_Amount__c!=null) ? sfOrder.comty_Chargent_Order__r.ChargentOrders__Charge_Amount__c :0.0;
                                order_res.ModificationDeadlineExceeded=sfOrder.Modification_Deadline_Exceeded__c;
                                order_res.ModificationDeadline=sfOrder.Modification_Deadline__c;
                                order_res.Recurrence=(sfOrder.Plant_Order_Properties__c!=null && sfOrder.Plant_Order_Properties__r.Plant_Recurrence__c!= null) ? sfOrder.Plant_Order_Properties__r.Plant_Recurrence__c:'';
                                if(!String.isBlank(sfOrder.Plant_Subscription__c)){
                                    order_res.MealSelectionId= sfOrder.Plant_Subscription__r.Plant_Meal_Selection__c;
                                }
                                else if(!String.isBlank(sfOrder.Plant_Order_Properties__c)){
                                    order_res.MealSelectionId= sfOrder.Plant_Order_Properties__r.Plant_Meal_Selection__c;
                                }
                                else {
                                    order_res.MealSelectionId= '';
                                }
                                
                                order_res.Subscription=sfOrder.Plant_Subscription__c;
                                order_res.DeliveryDate= sfOrder.Plant_Delivery_Date__c;
                                if(!pshipment.isEmpty()){
                                    order_res.TrackingNumber=pshipment[0].Plant_Tracking_Number__c;
                                    order_res.ShipmentStatus=pshipment[0].Plant_Status__c;
                                }
                                else{
                                    msg+=', No shipment is scheduled for this Order';
                                }
                                
                                if(!sfOrder.OrderItems.isEmpty()){
                                    order_res.product=sfOrder.OrderItems[0].product2.name;
                                }
                                else{
                                    msg+=', No product found for this Order';
                                }

                                if(sfOrder_List[0].comty_Chargent_Order__c!=null){
                                        order_res.OrderMeal = [SELECT Plant_Meal__r.Name, Plant_Meal__r.Id, Plant_Meal__r.Meal_Description__c, 
                                        Plant_Meal__r.Nutritional_Label_Image_URL__c, Plant_Meal__r.Type__c, Plant_Meal__r.Cuisine__c, Plant_Meal__r.Calories_Per_Serving__c,
                                        Plant_Meal__r.Proteins__c, Plant_Meal__r.Image_URL__c, Plant_Meal__r.Allergens__c, Plant_Meal__r.Menu_Name__c, Plant_Meal__r.Inventory__c, 
                                        Plant_Meal__r.Inventory_Sync__c, Plant_Meal__r.API_Enabled__c, Plant_Meal__r.Zipongo_Sampler__c, Plant_Meal__r.Dairy_Free__c, Plant_Meal__r.Gluten_Free__c, 
                                        Plant_Meal__r.Nut_Free__c, Plant_Meal__r.Inventory_Sync_Off_Call__c, Plant_Meal__r.Low_Inventory_Alert_Date_Time__c, 
                                        Plant_Meal__r.Sort_Rank__c, Plant_Meal__r.Soy_Free__c, Plant_Meal__r.Favorites__c, Plant_Meal__r.Status__c, Plant_Meal__r.Affiliate_Gift__c, Plant_Meal__r.Suggestic_ID__c, 
                                        Plant_Meal__r.Shopify_ID__c, Plant_Quantity__c, Plant_Meal_Selection__c, Plant_Meal_Selection__r.Name, 
                                         Id FROM Plant_Meal_Selection_Meal__c where Plant_Meal_Selection__c=:sfOrder_List[0].Plant_Order_Properties__r.Plant_Meal_Selection__c Limit 49999];
                                    }

                                // if(!MealSelectionList.isEmpty()){
                                //     order_res.OrderMeal.addAll(MealSelectionList);
                                // }
                                
                                if(!cTransaction.isEmpty()){
                                    order_res.PaymentDate=cTransaction[0].ChargentOrders__Gateway_Date__c;
                                    order_res.TransactionAmount=cTransaction[0].ChargentOrders__Amount__c;
                                    order_res.cardLastFourDigits=cTransaction[0].ChargentOrders__Card_Last_4__c;
                                    order_res.PaymentMethod=cTransaction[0].ChargentOrders__Payment_Method__c;
                                }
                                else{
                                    msg+=', No transaction made yet';
                                }
                                
                                ordr_respList.add(order_res);
                                status = 'Sucess';
                                statusCode='200';
                                string tempMsg =msg;
                                msg='Orders Detail Extracted Sucessfully! '+tempMsg;
                            }
                        }
                        else{
                            status = 'Error';
                            statusCode='501';
                            msg+='Service Unavailable! No Order Found : Please check Order Number';
                        }
                    }
                    else{
                        status = 'Error';
                        statusCode='501';
                        msg+='Service Unavailable! Please Provide Order Number';
                    }
                    
                }
                
            }
            else{
                System.debug('&&&&&&&');
                statusCode='503';
                status='error';
                msg+=', Service Unavailable! Incorrect Request';
            }
            
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(ordr_respList));
            return responseWrap;
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=', Internal Server Error: '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }

    // Method 4~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // @ desc: update shipping address
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper update_CustomerOdr_ShipAddress(manageShipAddress updateShipReqBody){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
        Savepoint sp1_initialState = Database.setSavepoint();
        List<Plant_Customer_BC.Order_ResponseWrap> ordr_respList=new List<Plant_Customer_BC.Order_ResponseWrap>();
        try{
            if(updateShipReqBody!=null){
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(updateShipReqBody.authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(updateShipReqBody.authenticationToken);
                    if(accAuthResut.startsWith('Success')){
                        existingCustomerId =  accAuthResut.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Account : '+accAuthResut;
                    }
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Invalid Authentication Token';
                }
                
                // CUSTOMER EXIST
                if(!String.isBlank(existingCustomerId)){
                    
                    List<Order> sfOrder_List=new List<Order>();
                    sfOrder_List = [SELECT id,Status, AccountId, OrderNumber,Modification_Deadline_Exceeded__c,Plant_Order_Properties__c,Plant_Shipping_Date__c, Plant_Delivery_Date__c,
                                    Plant_Order_Properties__r.Shipping_Address__c, Plant_Subscription__c, Plant_Order_Properties__r.Plant_Delivery_Date__c, Plant_Subscription__r.Plant_Next_Shipment_Date__c
                                    FROM Order WHERE AccountId=:existingCustomerId AND OrderNumber=:updateShipReqBody.orderNumber Limit 1];
                    
                    // Customer Order iteration
                    if(!sfOrder_List.isEmpty()){
                        
                        for(order sforder:sfOrder_List){
                            
                                                     
                            // VALIDATION: 24hr update only
                            if(sforder.Modification_Deadline_Exceeded__c!=true){
                                
                                // FOR EXISTING SHIPPING ADDRESS
                                if(!String.isBlank(updateShipReqBody.shippingAddressId)){        
                                    
                                    List<Plant_Shipping_Address__c> existingShippingAddress_List  = [ SELECT id,Plant_Province_State__c,Plant_Country__c,Plant_Postal_Code__c FROM Plant_Shipping_Address__c WHERE Id=:updateShipReqBody.shippingAddressId AND Plant_Account__c=:existingCustomerId ];
                                    if(!existingShippingAddress_List.isEmpty()){
                                        // VALIDATE SHIPPING ADDRESS
                                        Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                                        tempAddrsWrap.state=existingShippingAddress_List[0].Plant_Province_State__c;
                                        tempAddrsWrap.zip=existingShippingAddress_List[0].Plant_Postal_Code__c;
                                        
                                        Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                                        System.debug('&&&&&&&&#  = >'+availableDates_List);
                                        
                                        if(availableDates_List.status=='success'){
                                            if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                                if(availableDates_List.result.resultMap.keySet().size()==0){
                                                    msg+='Shipping date not available for this address, ';
                                                }
                                                else{
                                                    // check: available shipping date 
                                                    System.debug('@@@@ check date => '+sfOrder.Plant_Order_Properties__r.Plant_Delivery_Date__c);
                                                    
                                                    Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                                    if(avail_DeliveryDaye_Map.keySet().contains(updateShipReqBody.deliveryDate)){
                                                        if(sforder.Plant_Subscription__r.Plant_Next_Shipment_Date__c>Date.valueOf(updateShipReqBody.deliveryDate)){
                                                        // UPDATE ORDER PROPERTY
                                                            Plant_Order_Properties__c odr_Prop_recd = new Plant_Order_Properties__c();
                                                            odr_Prop_recd.Id = sfOrder.Plant_Order_Properties__c;
                                                            odr_Prop_recd.Plant_Shipping_Date__c=avail_DeliveryDaye_Map.get(String.valueOf(sfOrder.Plant_Order_Properties__r.Plant_Delivery_Date__c)).split(':')[0];
                                                            odr_Prop_recd.Plant_Delivery_Date__c = Date.valueOf(updateShipReqBody.deliveryDate);
                                                            odr_Prop_recd.Shipping_Address__c = updateShipReqBody.shippingAddressId;
                                                            update odr_Prop_recd;


                                                            // Updating Sf ORder
                                                            sfOrder.Plant_Shipping_Date__c = odr_Prop_recd.Plant_Shipping_Date__c;
                                                            sfOrder.Plant_Delivery_Date__c = Date.valueOf(updateShipReqBody.deliveryDate);
                                                            update sfOrder;

                                                            // AG - Add post Order Event
                                                            Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Address Change',sfOrder.AccountId,sfOrder.id,null));
                                                            
                                                            status = 'Success';
                                                            statusCode='200';
                                                            msg+='Success: Shipping date updated successfully, ';
                                                        }else{
                                                            status = 'error';
                                                            statusCode='501';
                                                            msg+=', Delivery date is more than next order Shipping date:';
                                                        }
                                                    }
                                                    else {
                                                        status = 'error';
                                                        statusCode='501';
                                                        msg+=', Record not updated. Shipping date not available for address';
                                                    }
                                                    
                                                }
                                            }
                                            else{
                                                status = 'error';
                                                statusCode='501';
                                                msg+='Shipping date not available for this address*,';
                                            }
                                        }
                                        else{
                                            status = 'error';
                                            statusCode='501';
                                            msg+='Shipping date Not available for this address, ';
                                        }
                                        
                                        //---------
                                    }   
                                    else{
                                        status = 'error';
                                        statusCode='501';
                                        msg+='Service Unavailable! Shipping id not exist';
                                    }
                                }
                                else{ // FOR NEW SHIPPING ADDRESS
                                    if(updateShipReqBody.shippingAddress!=null ){
                                        if(sforder.Plant_Order_Properties__c!=null){
                                            
                                            Boolean newDateAvailabel = false;
                
                                                Plant_Order_Properties__c ordrPropert=new Plant_Order_Properties__c();
                                                
                                                // VALIDATE: address US or Caneda
                                                if(Plant_Utility.checkAddress(updateShipReqBody.shippingAddress)){
                                                    // Check: Delivery Date address
                                                    
                                                    Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                                                    tempAddrsWrap.state=updateShipReqBody.shippingAddress.state;
                                                    tempAddrsWrap.zip=updateShipReqBody.shippingAddress.zip;
                                                    
                                                    Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                                                    System.debug('&&&&&&&&#  = >'+availableDates_List);
                                                    
                                                    if(availableDates_List.status=='success'){
                                                        if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                                            if(availableDates_List.result.resultMap.keySet().size()==0){
                                                                Msg+='Shipping date not available for this address, ';
                                                            }
                                                            else{
                                                                // check available shipping date from sf Delivery schedule records
                                                                System.debug('@@@@ check date => '+updateShipReqBody.deliveryDate);
                                                                
                                                                if(Plant_Utility.checkDateFormat(updateShipReqBody.deliveryDate)){
                                                                    Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                                                    if(avail_DeliveryDaye_Map.keySet().contains(updateShipReqBody.deliveryDate)){
                                                                        if(sforder.Plant_Subscription__r.Plant_Next_Shipment_Date__c>Date.valueOf(updateShipReqBody.deliveryDate)){
                                                                            ordrPropert.id=sforder.Plant_Order_Properties__c;
                                                                            ordrPropert.Plant_Shipping_Date__c=avail_DeliveryDaye_Map.get(updateShipReqBody.deliveryDate).split(':')[0];
                                                                            ordrPropert.Plant_Delivery_Date__c=Date.valueOf(updateShipReqBody.deliveryDate);
                                                                            sfOrder.Plant_Shipping_Date__c = ordrPropert.Plant_Shipping_Date__c;
                                                                            sfOrder.Plant_Delivery_Date__c = Date.valueOf(updateShipReqBody.deliveryDate);
                                                                            
                                                                            newDateAvailabel= true;
                                                                            Msg+='Success: Shipping date updated successfully, ';
                                                                        }else{
                                                                            status = 'error';
                                                                            statusCode='501';
                                                                            msg+=', Delivery date is more than next order Shipping date:';
                                                                        }
                                                                    }
                                                                    else {
                                                                        ordrPropert.Plant_Shipping_Date__c = null;
                                                                        Msg+='Shipping date not available for address, ';
                                                                    }
                                                                }
                                                                else {
                                                                    Msg+='No Shipping date for this address, ';
                                                                }
                                                            }
                                                        }
                                                        else{
                                                            Msg+='Shipping date not available for this address*,';
                                                        }
                                                    }
                                                    else{
                                                        Msg+='Shipping date Not available for this address, ';
                                                    }
                                                    
                                                    if(newDateAvailabel){
                                                                                                                    
                                                        Plant_Shipping_Address__c shipAdd_rec = new Plant_Shipping_Address__c();
                                                        
                                                        shipAdd_rec.Plant_Can_SMS__c = updateShipReqBody.shippingAddress.canSMS?true:false;
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.street1)){
                                                            shipAdd_rec.Plant_First_Name__c = updateShipReqBody.shippingAddress.firstName;
                                                        }if(!String.isBlank(updateShipReqBody.shippingAddress.street1)){
                                                            shipAdd_rec.Plant_Last_Name__c = updateShipReqBody.shippingAddress.LastName;
                                                        }
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.street1)){
                                                            shipAdd_rec.Plant_street1__c = updateShipReqBody.shippingAddress.street1;
                                                        }
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.street2)){
                                                            shipAdd_rec.Plant_street2__c = updateShipReqBody.shippingAddress.street2;
                                                        }
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.street3)){
                                                            shipAdd_rec.Plant_street3__c = updateShipReqBody.shippingAddress.street3;
                                                        }
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.city))
                                                            shipAdd_rec.Plant_City__c = updateShipReqBody.shippingAddress.city;
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.country))
                                                            shipAdd_rec.Plant_Country__c = updateShipReqBody.shippingAddress.country; 
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.phone))     
                                                            shipAdd_rec.Plant_Phone__c = updateShipReqBody.shippingAddress.phone;
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.zip))      
                                                            shipAdd_rec.Plant_Postal_Code__c = updateShipReqBody.shippingAddress.zip;
                                                        if(!String.isBlank(updateShipReqBody.shippingAddress.state))      
                                                            shipAdd_rec.Plant_Province_State__c = updateShipReqBody.shippingAddress.state;
                                                        
                                                        shipAdd_rec.Plant_Account__c=sforder.AccountId;
                                                        insert shipAdd_rec;
                                                        
                                                        // Updating Order Property
                                                        ordrPropert.Shipping_Address__c=shipAdd_rec.id;
                                                        update ordrPropert;

                                                        // Updating Salesforce Order
                                                        update sfOrder;
                                                        // responseList.add(ordrPropert);

                                                        // AG - Add post Order Event
                                                        Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Order Address Change',sfOrder.AccountId,sfOrder.id,null));
                                                        
                                                         
                                                        Status = 'Success';
                                                        StatusCode='200';
                                                        Msg='Shipping Address updated successfully';
                                                    }
                                                    else {
                                                        Status = 'Success';
                                                        StatusCode='200';
                                                        Msg='Shipping date not available for this address';
                                                    }
                                                    
                                                    
                                                }
                                                else{
                                                    StatusCode='503';
                                                    Status='error';
                                                    Msg='Service Unavailable! Shipping address not inserted must be US or Canada';
                                                }
                                            

                                        }
                                        else{
                                            status = 'Sucess';
                                            statusCode='200';
                                            msg+=', No Order property for this order. coordinate with System Admin';
                                        }
                                    }
                                    else{
                                        status = 'error';
                                        statusCode='501';
                                        msg+='Service Unavailable! Incorrect shipping address body';
                                    }
                                }
                                
                            }
                            else{
                                status = 'Sucess';
                                statusCode='200';
                                msg+=', Time for Updating this order is Over';
                            }
                        
                        }
                    }
                    else{
                        status = 'Sucess';
                        statusCode='200';
                        msg+=', No Order Found for this Account';
                    }
                    
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Invalid Input Json';
                }
            }
        }catch(Exception ex){
            
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            Database.rollback(sp1_initialState);
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(ordr_respList));
        return responseWrap;
    }

    // AG -- Methods for Internal Use Only
    
    public static void paymentMethodTriggerHandler(List<Plant_Payment_Method__c> lstPayMethods) {
        MAP<String,Plant_Payment_Method__c> mapPayMethods = new MAP<String,Plant_Payment_Method__c>();
        Set<String> accountIDs = new Set<String>();
        for(Plant_Payment_Method__c pm :lstPayMethods) {
            if(pm.Plant_Save_Payment_Method__c == True) {
	            mapPayMethods.put(pm.Plant_Account__c +':'+ pm.Plant_Card_Last_4_Digits__c,pm);
                accountIDs.add(pm.Plant_Account__c);
            }
        }
        System.debug('mapPayMethods:' + mapPayMethods);
        System.debug('accountIDs:' + accountIDs);
        
        List<Plant_Payment_Method__c> lstExistingPayMethods = [select id, Plant_Account__c,
                                                               Plant_Card_Number__c,
                                                               Plant_Card_Last_4_Digits__c,
                                                               Plant_Card_Type__c,
                                                               CCV__c,
                                                               Plant_City__c,
                                                               Plant_Country__c,
                                                               Plant_Customer_Name__c,
                                                               Plant_Expiration_Date__c,
                                                               Plant_Phone__c,
                                                               Plant_Postal_Code__c,
                                                               Plant_Province_State__c,
                                                               Plant_Street1__c,
                                                               Plant_Street2__c,
                                                               Plant_Street3__c
                                                               from Plant_Payment_Method__c 
                                                               where Plant_Is_Account_Record__c = True AND
                                                               Plant_Account__c in :accountIDs
                                                              ];
        System.debug('lstExistingPayMethods:' + lstExistingPayMethods);
        
        Map<String,Plant_Payment_Method__c> mapExistingPM = new Map<String,Plant_Payment_Method__c>();
        if(!lstExistingPayMethods.isEmpty()) {
            for(Plant_Payment_Method__c pm :lstExistingPayMethods){
                mapExistingPM.put(pm.Plant_Account__c +':'+ pm.Plant_Card_Last_4_Digits__c,pm);
            }
        }
        System.debug('mapExistingPM:' + mapExistingPM);
        
        List<Plant_Payment_Method__c> lstUpdatePM = new List<Plant_Payment_Method__c>();
        List<Plant_Payment_Method__c> lstInsertPM = new List<Plant_Payment_Method__c>();
        for(String pm :mapPayMethods.KeySet()) {
            
            System.debug('pm:' + pm);
            
            Plant_Payment_Method__c fndPay = mapPayMethods.get(pm);
            Plant_Payment_Method__c fndExistingPay = mapExistingPM.get(pm);
            System.debug('fndPay:' + fndPay);
            System.debug('fndExistingPay:' + fndExistingPay);
            
            if(fndPay != NULL && fndExistingPay != NULL) {
                Plant_Payment_Method__c updatePM = clonePaymentMethod(fndPay, fndExistingPay.Id, True);
                System.debug('lstUpdatePM add:' + updatePM);
                lstUpdatePM.add(updatePM);
            } else if(fndPay != NULL) {
                Plant_Payment_Method__c insertPM = clonePaymentMethod(fndPay, null, True);
                System.debug('lstInsertPM add:' + insertPM);
                lstInsertPM.add(insertPM);
            }
        }
        if(!lstInsertPM.isEmpty())
	        insert lstInsertPM;
        if(!lstUpdatePM.isEmpty())
	        update lstUpdatePM;
    }
    
    public static Plant_Payment_Method__c clonePaymentMethod(Plant_Payment_Method__c payRec, String payId, Boolean isAccount) {
        Plant_Payment_Method__c clonedPM = new Plant_Payment_Method__c(
                    Plant_Account__c = payRec.Plant_Account__c,
                    Plant_Is_Account_Record__c = isAccount,
                    Plant_Card_Number__c = payRec.Plant_Card_Number__c,
                    Plant_Card_Type__c = payRec.Plant_Card_Type__c,
                    CCV__c = payRec.CCV__c,
                    Plant_Card_Last_4_Digits__c = payRec.Plant_Card_Last_4_Digits__c,
                    Plant_City__c = payRec.Plant_City__c,
                    Plant_Country__c = payRec.Plant_Country__c,
                    Plant_Customer_Name__c = payRec.Plant_Customer_Name__c,
                    Plant_Expiration_Date__c = payRec.Plant_Expiration_Date__c,
                    Plant_Phone__c = payRec.Plant_Phone__c,
                    Plant_Postal_Code__c = payRec.Plant_Postal_Code__c,
                    Plant_Province_State__c = payRec.Plant_Province_State__c,
                    Plant_Street1__c = payRec.Plant_Street1__c,
                    Plant_Street2__c = payRec.Plant_Street2__c,
                    Plant_Street3__c = payRec.Plant_Street3__c
                );
        if(payId != NULL) {
            clonedPM.Id = payId;
        }
        return clonedPM;
    }
    
    public static PricebookEntry getPriceBookEntryByProduct(String prod, List<PricebookEntry> allPrices) {
        
        // Use Custom Settings to get product
        Map<String, PlantProducts__c> plantProdSettings = PlantProducts__c.getAll();
        System.debug('plantProdSettings:' + plantProdSettings);
        
        PlantProducts__c fndProdCode = plantProdSettings.get(prod);
        System.debug('fndProdCode:' + fndProdCode);
        
        String prodCode = '';
        if(fndProdCode != NULL) {
            prodCode = fndProdCode.ProductCode__c;
        }
        if(Test.isRunningTest()) {
            prodCode='PLANTALC';
        }
        System.debug('prodCode:' + prodCode);
        
        PricebookEntry priceBookEntry;
        if(allPrices != NULL) {
            for(PricebookEntry pbe :allPrices) {
                System.debug('pbe:' + pbe);
                    
                if(pbe.ProductCode == prodCode) {
                    priceBookEntry = pbe;
                    break;
                }
            }
        } else {
            List<PricebookEntry> product_PricebookEntry_List = [SELECT Id, Product2Id,UnitPrice FROM PricebookEntry WHERE product2Id IN (SELECT id FROM product2 where ProductCode=:prodCode)];
            if(!product_PricebookEntry_List.isEmpty()) {
                priceBookEntry = product_PricebookEntry_List[0];
            }                
        }
        return priceBookEntry;
    }
        
    // Update Meal Inventory when order's Meals are updated
    public static void replaceOrderInventory(String orgMealSelectionId, String newMealSelectionId) {
        
        System.debug('orgMealSelectionId:' + orgMealSelectionId);
        System.debug('newMealSelectionId:' + newMealSelectionId);
        
        List<Plant_Meal_Selection_Meal__c> lstMealSels = [select Id, Plant_Meal__c, Plant_Quantity__c, Plant_Meal_Selection__c
														  FROM Plant_Meal_Selection_Meal__c WHERE Plant_Meal_Selection__c = :orgMealSelectionId OR
                                                          Plant_Meal_Selection__c = :newMealSelectionId];
        System.debug('lstMealSels:' + lstMealSels);
        
        MAP<String,Plant_Meal_Selection_Meal__c> mapOrgMealSelMeals = new MAP<String,Plant_Meal_Selection_Meal__c>();
        MAP<String,Plant_Meal_Selection_Meal__c> mapNewMealSelMeals = new MAP<String,Plant_Meal_Selection_Meal__c>();
        SET<String> mealIDs = new SET<String>();
        for(Plant_Meal_Selection_Meal__c msm :lstMealSels) {
            if(msm.Plant_Meal_Selection__c == orgMealSelectionId) {
                mapOrgMealSelMeals.put(msm.Plant_Meal__c, msm);
            } else {
                mapNewMealSelMeals.put(msm.Plant_Meal__c, msm);
            }
            mealIDs.add(msm.Plant_Meal__c);
        }
        System.debug('mapOrgMealSelMeals:' + mapOrgMealSelMeals);
        System.debug('mapNewMealSelMeals:' + mapNewMealSelMeals);
        System.debug('mealIDs:' + mealIDs);
        
        
        List<Meal__c> lstMeals = [select Id, Number_of_Servings__c, Inventory__c from Meal__c where Id in :mealIDs];
        System.debug('lstMeals:' + lstMeals);
        
		MAP<String,Meal__c> mapMeals = new MAP<String,Meal__c>();
        for(Meal__c m :lstMeals) {
            mapMeals.put(m.Id,m);
        }
        System.debug('mapMeals:' + mapMeals);
        
        List<Meal__c> updateMeals = new List<Meal__c>();
        for(Plant_Meal_Selection_Meal__c msm :mapOrgMealSelMeals.values()) {
            
            System.debug('Org msm:' + msm);            
            Meal__c fndMeal = mapMeals.get(msm.Plant_Meal__c); 
            Integer numServ = 1;
            if(fndMeal.Number_of_Servings__c != NULL) {
            	numServ = Integer.valueOf(fndMeal.Number_of_Servings__c);    
            }
            System.debug('fndMeal:' + fndMeal);
            System.debug('numServ:' + numServ);
            
            Plant_Meal_Selection_Meal__c fndNewMealSel = mapNewMealSelMeals.get(msm.Plant_Meal__c);             
            System.debug('fndNewMealSel:' + fndNewMealSel);
            
            // New Meal not found, put old meal back in inventory
            if(fndNewMealSel == NULL) {
                fndMeal.Inventory__c = fndMeal.Inventory__c + (msm.Plant_Quantity__c * numServ);
                System.debug('Not Found Update Meal Inv:' + fndMeal.Inventory__c);
                updateMeals.add(fndMeal);
            } else if(fndNewMealSel.Plant_Quantity__c != msm.Plant_Quantity__c) {
                // New Meal found, diff quantity and update inventory
                Decimal diff = msm.Plant_Quantity__c - fndNewMealSel.Plant_Quantity__c;
                System.debug('diff:' + diff);
                
                fndMeal.Inventory__c = fndMeal.Inventory__c + (diff * numServ);
                System.debug('Found Update Meal Inv:' + fndMeal.Inventory__c);
                updateMeals.add(fndMeal);
            }
        }
        
        // Find any new meals and remove from inventory
       	for(Plant_Meal_Selection_Meal__c msm :mapNewMealSelMeals.values()) {
            System.debug('New msm:' + msm); 
                       
            Plant_Meal_Selection_Meal__c fndOrgMealSel = mapOrgMealSelMeals.get(msm.Plant_Meal__c); 
            System.debug('fndOrgMealSel:' + fndOrgMealSel);
            
            // If not found, must be new meal, remove from inventory
            if(fndOrgMealSel == NULL) {
                
                System.debug('Org msm:' + msm);            
                Meal__c fndMeal = mapMeals.get(msm.Plant_Meal__c); 
                Integer numServ = 1;
                if(fndMeal.Number_of_Servings__c != NULL) {
                    numServ = Integer.valueOf(fndMeal.Number_of_Servings__c);    
                }
                System.debug('fndMeal:' + fndMeal);
                System.debug('numServ:' + numServ);
                
                fndMeal.Inventory__c = fndMeal.Inventory__c - (msm.Plant_Quantity__c * numServ);
                System.debug('Found New Meal Update Inv:' + fndMeal.Inventory__c);
                updateMeals.add(fndMeal);
            }
        }
        
        System.debug('updateMeals:' + updateMeals);
        update updateMeals;
        
    }
    
    // Update Meal Inventory when orders are purchased or cancelled
    // Restock, means put them back in stock
    // TO DO - On Packing Slips we need to also Multiply Quantity Order x Number of Servings
    public static void updateOrderInventory(List<String> mealSelectionIDs, Boolean isRestock) {
    	List<Plant_Meal_Selection_Meal__c> lstMealSels = [select Id, Plant_Meal__c, Plant_Quantity__c
														  FROM Plant_Meal_Selection_Meal__c WHERE Plant_Meal_Selection__c in :mealSelectionIDs];

        System.debug('lstMealSels:' + lstMealSels);
        
        SET<String> mealIDs = new SET<String>();
        for(Plant_Meal_Selection_Meal__c msm :lstMealSels) {
            mealIDs.add(msm.Plant_Meal__c);
        }
        System.debug('mealIDs:' + mealIDs);
        
        List<Meal__c> lstMeals = [select Id, Number_of_Servings__c, Inventory__c from Meal__c where Id in :mealIDs];
		MAP<String,Meal__c> mapMeals = new MAP<String,Meal__c>();
        for(Meal__c m :lstMeals) {
            mapMeals.put(m.Id,m);
        }
        System.debug('mapMeals:' + mapMeals);
        
		List<Meal__c> updateMeals = new List<Meal__c>();
        for(Plant_Meal_Selection_Meal__c msm :lstMealSels) {
            System.debug('msm:' + msm);
            
			Meal__c fndMeal = mapMeals.get(msm.Plant_Meal__c);
            System.debug('fndMeal:' + fndMeal);
            
            Integer numServ = 1;
            if(fndMeal.Number_of_Servings__c != NULL) {
            	numServ = Integer.valueOf(fndMeal.Number_of_Servings__c);    
            }
            
            if(fndMeal != NULL) {
                if(isRestock == TRUE) {
                	fndMeal.Inventory__c = fndMeal.Inventory__c + (msm.Plant_Quantity__c * numServ);
                } else {
                	fndMeal.Inventory__c = fndMeal.Inventory__c - (msm.Plant_Quantity__c * numServ);
                }		
                System.debug('updateMeals:' + fndMeal);
				updateMeals.add(fndMeal);                            
            }        
        }
        if(updateMeals.size() > 0) {
            System.debug('update all Meals:' + updateMeals);
        	update updateMeals;
        }
	} 

	
	// AG 9/21/2022
    // Post Transaction Handler - After an Order Payment or Change is made this method will handle any remaining non-criitical work
    // This is to remove load from the actual transaction
    // Things we do here:
    // 1. Set Order Type = New Business v Existsing Business
    // 2. Create OnBoarding record for any new customer
    // 3. Update Account Order KPIs; Total Orders, ...
    // 4. Schedule Shipment Emails
    public static void postTransactionOrderHandler(List<Plant_Transaction__e> lstOrderEvents) {
        Set<String> orderIds = new Set<String>();
        Set<String> accountIds = new Set<String>();
        Set<String> setOrderPropIds = new Set<String>();
        MAP<String,Plant_Transaction__e> mapEvents = new MAP<String,Plant_Transaction__e>();
        MAP<String,Order> mapEventOrder = new MAP<String,Order>();
        
        // Setup ID Lists
        for(Plant_Transaction__e pte :lstOrderEvents) {
            orderIds.add(pte.Plant_OrderId__c);
            accountIds.add(pte.Plant_AccountId__c);
            mapEvents.put(pte.Plant_OrderId__c, pte);
        }
        System.debug('postTransactionOrderHandler orderIds:' + orderIds);
        System.debug('accountIds:' + accountIds);
        System.debug('mapEvents:' + mapEvents);

		// Get ALL orders related to accounts in play        
        List<Order> lstOrders = [select Id, AccountId, ActivatedDate, TotalAmount, Type, Plant_Main_Product__c,
                                 Plant_Order_Properties__c, Plant_Subscription__c,
                                 Plant_Subscription__r.Order_Count__c,
                                 Discount_Codes_Used__c, Plant_Subscription_Order_Number__c,
                                 Plant_Shipping_Date__r.Plant_Shipping_Date__c
                                 from Order 
                                 where AccountId in :accountIds AND status = 'Activated'
                                ORDER BY ActivatedDate];
        System.debug('lstOrders:' + lstOrders);
        for(Order o :lstOrders) {
            // Is order in play
            if(orderIds.contains(o.Id)) {
                setOrderPropIds.add(o.Plant_Order_Properties__c);
                Plant_Transaction__e fndEvt = mapEvents.get(o.Id);
                if(fndEvt != NULL) {
                	mapEventOrder.put(fndEvt.EventUuid, o);    
                }
            }
        }
		System.debug('setOrderPropIds:' + setOrderPropIds);        
        
        // Get Accounts in play
        List<Account> lstAccount = [select Id, Type, Plant_Total_Orders__c,Plant_Total_Revenue__c, 
                                    Plant_Reboot_Orders__c, Plant_Reboot_Revenue__c, Plant_Reboot_First_Order__c, Plant_Reboot_Last_Order__c,
                                    Plant_A_La_Carte_Orders__c, Plant_A_La_Carte_Revenue__c, Plant_A_La_Carte_First_Order__c, Plant_A_La_Carte_Last_Order__c,
                                    Plant_Quickstart_Orders__c, Plant_Quickstart_Revenue__c, Plant_Quickstart_First_Order__c, Plant_Quickstart_Last_Order__c
                                    from Account where id in :accountIds];
        System.debug('lstAccount:' + lstAccount);
        
        // Get Discount Codes
        List<Plant_Discount_Selection__c> lstDiscSels = [select Id, Plant_Order_Properties__c, Plant_Discount_Code__r.Plant_Code__c 
                                                         FROM Plant_Discount_Selection__c where Plant_Order_Properties__c in:setOrderPropIds ];
        Map<String,String> mapOrderPropDisc = new Map<String,String>();
        for(Plant_Discount_Selection__c ds :lstDiscSels) {
            mapOrderPropDisc.put(ds.Plant_Order_Properties__c,ds.Plant_Discount_Code__r.Plant_Code__c);
        }
        System.debug('mapOrderPropDisc:' + mapOrderPropDisc);  
        
        // Init map
        MAP<String, Account> mapAccts = new MAP<String, Account>();
        for(Account acct :lstAccount) {
            // Reset Counters
            acct.Total_Orders__c = 0;
            acct.Plant_Total_Orders__c = 0;
            acct.Plant_Total_Revenue__c = 0;
            acct.Plant_Reboot_Orders__c = 0;
            acct.Plant_Reboot_Revenue__c = 0;
            acct.Plant_Reboot_First_Order__c = NULL;
            acct.Plant_Reboot_Last_Order__c = NULL;
            acct.Plant_A_La_Carte_Orders__c = 0;
            acct.Plant_A_La_Carte_Revenue__c = 0;
            acct.Plant_A_La_Carte_First_Order__c = NULL;
            acct.Plant_A_La_Carte_Last_Order__c = NULL;
            acct.Plant_Quickstart_Orders__c = 0;
            acct.Plant_Quickstart_Revenue__c = 0;
            acct.Plant_Quickstart_First_Order__c = NULL;
            acct.Plant_Quickstart_Last_Order__c = NULL;
            
            mapAccts.put(acct.Id, acct);
        }
        System.debug('mapAccts:' + mapAccts);
        
        // Count Order KPIs By Account
        MAP<String, Account> mapOrdersAcct = new MAP<String, Account>();
        for(Order o :lstOrders) {
            
            System.debug('Order Loop:' + o);
            
			Account fndAccount = mapAccts.get(o.AccountId);
            System.debug('fndAccount:' + fndAccount);
            
            if(fndAccount!=NULL) {
                fndAccount.Plant_Total_Orders__c++;
                fndAccount.Plant_Total_Revenue__c+=o.TotalAmount;
                if(o.Plant_Main_Product__c == 'Reboot') {
                    fndAccount.Plant_Reboot_Orders__c++;
                    fndAccount.Plant_Reboot_Revenue__c+=o.TotalAmount;
                    if(fndAccount.Plant_Reboot_First_Order__c == NULL) {
                        fndAccount.Plant_Reboot_First_Order__c = Date.ValueOf(o.ActivatedDate);
                    }
                    fndAccount.Plant_Reboot_Last_Order__c = Date.ValueOf(o.ActivatedDate);          
                } else if(o.Plant_Main_Product__c == 'A-la-carte') {
                    fndAccount.Plant_A_La_Carte_Orders__c++;
                    fndAccount.Plant_A_La_Carte_Revenue__c+=o.TotalAmount;
                    if(fndAccount.Plant_A_La_Carte_First_Order__c == NULL) {
                        fndAccount.Plant_A_La_Carte_First_Order__c = Date.ValueOf(o.ActivatedDate);
                    }
                    fndAccount.Plant_A_La_Carte_Last_Order__c = Date.ValueOf(o.ActivatedDate);   
                } else if(o.Plant_Main_Product__c == 'Quickstart') {
                    fndAccount.Plant_Quickstart_Orders__c++;
                    fndAccount.Plant_Quickstart_Revenue__c+=o.TotalAmount;
                    if(fndAccount.Plant_Quickstart_First_Order__c == NULL) {
                        fndAccount.Plant_Quickstart_First_Order__c = Date.ValueOf(o.ActivatedDate);
                    }
                    fndAccount.Plant_Quickstart_Last_Order__c = Date.ValueOf(o.ActivatedDate);   
                }                    
                System.debug('update order count:' + fndAccount);
                mapAccts.put(fndAccount.Id, fndAccount);
            }                
        }
        
        List<Order> updateOrders = new List<Order>();
        List<OnBoarding__c> insertOnBoardings = new List<OnBoarding__c>();
        
        // Process Orders from Trans Event
        for(Plant_Transaction__e pte :lstOrderEvents) {
            System.debug('pte:' + pte);
            
            Order fndOrder = mapEventOrder.get(pte.EventUuid);
            System.debug('fndOrder:' + fndOrder);
            
            if(pte.Plant_Type__c == 'Order Cancelled') {
            	
                // Cancel Staged Scheduled Emails
                Plant_TransComm_BC.cancelStagedScheduledTransComm('Order Shipment Upcoming', fndOrder.AccountId, fndOrder.Id, null);
                Plant_TransComm_BC.cancelStagedScheduledTransComm('Order Shipment Sent', fndOrder.AccountId, fndOrder.Id, null);

            } else if(pte.Plant_Type__c == 'Order Date Change' || pte.Plant_Type__c == 'Order Address Change') {
                            
                // Stage Scheduled Emails
                // This is cancel the old one, and create a new one on the correct date
                Plant_TransComm_BC.stageScheduledTransComm('Order Shipment Upcoming', fndOrder.AccountId, fndOrder.Id, null, fndOrder.Plant_Shipping_Date__r.Plant_Shipping_Date__c);
                Plant_TransComm_BC.stageScheduledTransComm('Order Shipment Sent', fndOrder.AccountId, fndOrder.Id, null, fndOrder.Plant_Shipping_Date__r.Plant_Shipping_Date__c);
                
            } else if(pte.Plant_Type__c == 'Order Paid') {
                
                // Stage Scheduled Emails
                Plant_TransComm_BC.stageScheduledTransComm('Order Shipment Upcoming', fndOrder.AccountId, fndOrder.Id, null, fndOrder.Plant_Shipping_Date__r.Plant_Shipping_Date__c);
                Plant_TransComm_BC.stageScheduledTransComm('Order Shipment Sent', fndOrder.AccountId, fndOrder.Id, null, fndOrder.Plant_Shipping_Date__r.Plant_Shipping_Date__c);

                // Update KPIs & Create Onboardings
                Account fndAccount = mapAccts.get(fndOrder.AccountId);
                System.debug('fndAccount:' + fndAccount);
                
                if(fndAccount!=NULL) {
                    if(fndAccount.Plant_Total_Orders__c == 1) {
                        fndOrder.Type = 'New Business';
                        
                        // Create OnBoarding Record
                        OnBoarding__c newOnBoard = new OnBoarding__c(
                            Account__c = fndOrder.AccountId
                        );
                        insertOnBoardings.add(newOnBoard);
                        
                    } else if(fndAccount.Plant_Total_Orders__c > 1) {
                        fndOrder.Type = 'Existing Business';
                    }
                    System.debug('update order type:' + fndOrder);
                }
                
                String fndDisc = mapOrderPropDisc.get(fndOrder.Plant_Order_Properties__c);
                System.debug('fndDisc:' + fndDisc);
                
                if(fndDisc != NULL) {
                    fndOrder.Discount_Codes_Used__c = fndDisc;
                    System.debug('update order discount:' + fndOrder);
                }
                
                if(fndOrder.Plant_Subscription__c != NULL) {
                    fndOrder.Plant_Subscription_Order_Number__c = fndOrder.Plant_Subscription__r.Order_Count__c;
                }
                
                if(fndAccount!=NULL || fndDisc!=NULL || fndOrder.Plant_Subscription__c != NULL) {
                    System.debug('updateOrders.add:' + updateOrders);
                    updateOrders.add(fndOrder);
                }                
                
            }
            
        }
                
        if(!updateOrders.isEmpty()) {
            System.debug('update updateOrders:' + updateOrders);
        	update updateOrders;    
        }
        
        List<Account> updateAccounts = new List<Account>();
        for(Account a :mapAccts.values()) {
            updateAccounts.add(a);
        }
        if(!updateAccounts.isEmpty()) {
            System.debug('update updateAccounts:' + updateAccounts);
        	update updateAccounts;    
        }
        if(!insertOnBoardings.isEmpty()) {
            System.debug('insert insertOnBoardings:' + insertOnBoardings);
        	insert insertOnBoardings;    
        }
        
    }
    
    // @ wrapper class 1: order property "Request" json
   // modify 1: request json for cart update
   // modify 2: request json for new cart for existing Account
   public class opReqWrapper{

        public String product; // Order Property Record type  
        public String cartId; // OrderProperty Id
        public String mealSelectionId; //(REMOVE)
        public String firstName;  
        public String lastName;
        public String phone;
        public Boolean canSMS;
        public String email;
        public Plant_Utility.addressCapsule shippingAddress;
        public Boolean shipASAP;
        public Boolean useChefMenu;
        // public String shipDate; //YYYY-MM-DD format
        public String DeliveryDate; //YYYY-MM-DD format
        public Plant_Utility.wrapMeal[] meals;
        public String discountCode;
        public String recurrence;
        public cardWrapper cardInformation;

        // To Create New Order Property For Existing Customer
        // public String accountId;
        public String authorizeToken;
        public String paymentMethodId;
        public string ShippingAddressId;

        
        public opReqWrapper parse(String json_op){
            return (opReqWrapper)JSON.deserialize(json_op, opReqWrapper.class);
        }
    }   

    
    // @wrapper class 2 :
    // wrap card Information
    public class cardWrapper{
        public String name;
        public String cardnumber;
        public String card_Last_4_Digits;
        public String card_Type;
        public String cvv;
        public String expDate; // YYYY-MM-DD
        public Plant_Utility.addressCapsule billingAddress;
        public Boolean savePayment;
    }

    // @wrapper class 3 :
    // wrap request for process Order(po)
    public class processOdr_Wrapper{
        public String cartId; // Order Property Id
        // public String accountId;
        // public String authenticationToken; // to update Order
        //public String token;
        public String lastName;
        public String firstName;
        public String phone;
        public String paymentMethodId;
        //public String sfOrderId;      // SF Order id (optional: only if case of update)
        //public String cTransactionId; // chargent Payment id (optional: only if case of update)

        public processOdr_Wrapper parse(String json_po){
            return (processOdr_Wrapper)JSON.deserialize(json_po, processOdr_Wrapper.class);
        }
    }

    // @wrapper class 4
    // wrapper order property(preProcessOrder) "RESPONSE" json
   public class opResponseWrap{
        public String product; // Order Property Record type  
        public String cartId; // "Order PropertiesId"
        public Account accountRecord;
        public Plant_Payment_Method__c paymentMethod;
        public mealSelectionResp mealSelection;
        public String firstName;  
        public String lastName;
        public String phone;
        public Boolean canSMS;
        public String email;
        public Plant_Shipping_Address__c shippingAddress;
        public boolean shipASAP;
        public String shipDate; 
       	public String deliveryDate;
        public Plant_Utility.responseListWrapper discountCodeList;
        public String recurrence;
        public orderFreeWrap orderFees;
        public String listPrice;
    }  

    // wrapper 4.0
    // wrap meal Selection and meal list
    public class mealSelectionResp{
        public String mealSelectionId;
        public Plant_Utility.responseListWrapper  mealSelectionList;
    }

    // wrapper 4.1
    // wrap orderFees
    public class orderFreeWrap{
        public Decimal listPriceAmount;
        public Decimal totalPriceAmount;
        public Decimal shippingAmount;
        public Decimal taxesAmount;
    }

    // wrapper 5
    // chargent Order Authorize request wrapper
    public class chargentAuthorizeReq_class{
        public String ObjectId;
        public String CardMonth;
        public String CardYear;
        public String PaymentMethod;
        public String CardType;
        public String CardSecurity;
        public String CardNumber;
        public Decimal ChargeAmount;
        public boolean TokenOnly;
        public String BillingFirst;
        public String BillingLast;
        public String BillingAddress;
        public String BillingCity;
        public String BillingState;
        public String BillingZip;
        public String BillingCountry;
        
        public chargentAuthorizeReq_class(String ObjectId, String CardMonth, String CardYear, String PaymentMethod, String CardType, String CardSecurity, String CardNumber, Decimal ChargeAmount, boolean TokenOnly, String BillingFirst, String BillingLast, String BillingAddress, String BillingCity, String BillingState, String BillingZip, String BillingCountry){
            this.ObjectId = ObjectId;
            this.CardMonth = CardMonth;
            this.CardYear = CardYear;
            this.PaymentMethod = PaymentMethod;
            this.CardType = CardType;
            this.CardSecurity = CardSecurity;
            this.CardNumber = CardNumber;
            this.ChargeAmount = ChargeAmount;
            this.TokenOnly = TokenOnly;
            this.BillingFirst = BillingFirst;
            this.BillingLast = BillingLast;
            this.BillingAddress = BillingAddress;
            this.BillingCity = BillingCity;
            this.BillingState = BillingState;
            this.BillingZip = BillingZip;
            this.BillingCountry = BillingCountry;
        }
    }

    // wrapper 6:
    // wrap process order Response 
    public class orderSumaryWrap{
        public String orderNumber;
        public String deliveryDate;
        public String cOrderId;
        public String sfOrderId;
        public String orderPropId;
        public String temporaryPassword; // to update Order
        public String paymentId;
        public String subscriptionId;
        public orderFeesWrap orderFees;

        public orderSumaryWrap(String orderNumber, String deliveryDate, String cOrderId, String sfOrderId, String orderPropId, String temporaryPassword, string paymentId,String subscptnId, orderFeesWrap orderFees){
            this.orderNumber = orderNumber;
            this.deliveryDate = deliveryDate;
            this.cOrderId = cOrderId;
            this.sfOrderId = sfOrderId;
            this.orderPropId = orderPropId;
            this.temporaryPassword=temporaryPassword;
            this.paymentId = paymentId;
            this.subscriptionId = subscptnId;
            this.orderFees = orderFees;
        }
    }

    // wrapper 6.1
    // wrap process order Response 
    public class orderFeesWrap{
        public Decimal listPriceAmount;
        public Decimal totalPriceAmount;
        public Decimal shippingAmount;
        public Decimal taxesAmount;

        public orderFeesWrap(Decimal listPriceAmount, Decimal totalPriceAmount, Decimal shippingAmount, Decimal taxesAmount){
            this.listPriceAmount = listPriceAmount;
            this.totalPriceAmount = totalPriceAmount;
            this.shippingAmount = shippingAmount;
            this.taxesAmount = taxesAmount;
        }
    }

    
    // wrapper 7:
    // wrap process Transaction Request 
    public class TransactionReqWrap{
        public String cOrderId;
        public String sfOrderId;
        public String orderPropId;
        public String authenticationToken; // #new
        public String paymentId;

        public TransactionReqWrap parse(String json_op){
            return (TransactionReqWrap)JSON.deserialize(json_op, TransactionReqWrap.class);
        }
    }

    // wrapper 8:
    // wrap process Transaction Response 
    public class TransactionResp_Wrap{
        public String TransactionId;
        public Decimal ChargeAmount;

        public TransactionResp_Wrap(String transcId,Decimal amount){
            this.TransactionId=transcId;
            this.ChargeAmount= amount;
        }
    }

    // wrapper 9: 
    // wrap Process payment request:
    public class processPayment_Wrap{
        public String cTransactionId; // Chargent Transaction Id
        public Decimal ChargeAmount; // amount in decimal 
        public String authenticationToken; // #new

        public processPayment_Wrap parse(String json_Paymnt){
            return (processPayment_Wrap)JSON.deserializeStrict(json_Paymnt, processPayment_Wrap.class);
        }
    }

    // wrapper 9.1: 
    // wrap Process payment wrap to hit chargent:
    public class hitChargentPayment{
        public String ObjectId; // Chargent Transaction Id
        public Decimal ChargeAmount; // amount in decimal 
        public String authenticationToken; // #new
    }

    // wrapper 10:
    // wrap Subscription status change request
    public class SubscrptionWrap{
        public String subscriptionId;
        public String newStatus;
        public String authenticationToken; // #new

        public SubscrptionWrap parse(String sub_Json){
            return (SubscrptionWrap)JSON.deserialize(sub_Json, SubscrptionWrap.class);
        }
    }

    // wrapper 11:
    // wrap payment method update request/ response
    public class paymtUpdateWrap{
        public String paymentMethodId;
        public String cartId; // order property ID
        public cardWrapper cardInformation;
        public Boolean isCustomer;
        

        public paymtUpdateWrap parse(String sub_Json){
            return (paymtUpdateWrap)JSON.deserialize(sub_Json, paymtUpdateWrap.class);
        }
    }

    // wrapper 11.01:
    // wrap customer payment method update request
    public class customer_PaymtUpdateWrap{
        public String orderNumber;
        public String authenticationToken;
        public cardWrapper cardInformation;
        public String paymentMethodId;
        

        public customer_PaymtUpdateWrap parse(String sub_Json){
            return (customer_PaymtUpdateWrap)JSON.deserialize(sub_Json, customer_PaymtUpdateWrap.class);
        }
    }

    // wrapper 13:
    // wrap : customer info req details
    public class customerInfoReq_wrap{
        public String authenticationToken;

        public customerInfoReq_wrap parse(String sub_Json){
            return (customerInfoReq_wrap)JSON.deserialize(sub_Json, customerInfoReq_wrap.class);
        }
    }

    // wrapper 14:
    // wrap: customer order meal details request
    public class wrapOrder_MealReq{
        public String orderNo;
        public String authenticationToken;

        public wrapOrder_MealReq parse(String order_Mealreq){
            return (wrapOrder_MealReq)JSON.deserialize(order_Mealreq, wrapOrder_MealReq.class);
        }
    }

    // wrapper 15:
    // wrap: order mealList RESPONSE
    public class wrapOrder_MealResp{
        public String mealSelectionId;
        public List<Plant_Utility.wrapMeal_RespBody> mealList;
    }

    // wrapper 16:
    // wrap: Customer Order update request
    public class CustomerMeal_UpdateReq_Wrapper{
        public String authenticationToken;
        public String OrderNumber;
        public Plant_Utility.wrapMeal[] mealList;

        public CustomerMeal_UpdateReq_Wrapper parse(String jsonReq){
            return (CustomerMeal_UpdateReq_Wrapper)JSON.deserialize(jsonReq, CustomerMeal_UpdateReq_Wrapper.class);
        }
    }

    // wrapper 17:
    // wrap: to get information about status of transactions made
    public class getCardStatus{
        public String authenticationToken;
        public String processId;
        public getCardStatus parse(String jsonReq){
            return (getCardStatus)JSON.deserialize(jsonReq, getCardStatus.class);
        }
    }

    // wrapper 18:
    // wrap: to change Order Delivery Date
    // delivery date update wrapper
    public class OrderDeliveryDate_Wrap{
        public String new_Delivery_Date; // new Delivery date
        public string authenticationToken; 
        public String OrderNumber; 
        
        //desc:   parse and return wrapper object
        public OrderDeliveryDate_Wrap parse(String json){
            return (OrderDeliveryDate_Wrap)System.JSON.deserialize(json, OrderDeliveryDate_Wrap.class);
        }
    }

    // wrap 3: return orders Details.
    public class Order_ResponseWrap{
        public String OrderNumber;
        public String status;
        public Decimal AmountPaid;
        public String product;
        public Datetime DateOrdered;
        public String InvoiceNumber;
        public date ShipmentDate;
    }

    // wrap 4: response to return Order Details.
    public class OrderDetails_Wrap{
        public String OrderNumber;
        public boolean ModificationDeadlineExceeded;
        public Datetime ModificationDeadline;
        public String status;
        public Decimal AmountPaid;
        public String product;
        public Datetime DateOrdered;
        public String InvoiceNumber;
        public date ShipmentDate;
        public String Recurrence;
        public String MealSelectionId;
        public String Subscription;
        public String ShipmentStatus;
        public Date DeliveryDate;
        public String TrackingNumber;
        public Datetime PaymentDate;
        public String cardLastFourDigits;
        public Decimal TransactionAmount;
        public String PaymentMethod;
        public List<Plant_Meal_Selection_Meal__c> OrderMeal;
        
    }
// wrap 5
    // desc: to manage Shipping Address
    public class manageShipAddress{
        public String orderNumber;
        public String authenticationToken;
        public String deliveryDate;
        public String shippingAddressId; //(Optional)
        public Plant_Utility.addressCapsule shippingAddress;  //(Optional)
        
        //desc:   parse and return wrapper object
        public manageShipAddress parse(String json){
            return (manageShipAddress)System.JSON.deserialize(json, manageShipAddress.class);
        }
    }
    
    
}