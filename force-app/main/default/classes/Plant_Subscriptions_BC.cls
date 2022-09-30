/*
*   @Desciption     :   Plantable (Subscription Business class)
*                       

*   @Create date    :   12-09-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/

public class Plant_Subscriptions_BC {
    
    //Default Constructor
    public Plant_Subscriptions_BC() {

    }

    // @ Method 1~~~~~~~~~~~~~~~~~~~~~~~~
    // @ Desc:  get list of Subscriptions of a Customer
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper getSubscriptionInformation(String authenticationToken){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
        String response='';
        List<Account> Plant_Account=new List<Account>();
        List<SubscriptionInfo_Wrap> SubscriptionInfo_List = new List<SubscriptionInfo_Wrap>();
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
                    
                    for(Plant_Subscription__c subscription:[SELECT Id, Plant_Account__c, Plant_Status__c,Plant_Next_Charge_Date__c,Plant_Start_Date__c,
                                                            Plant_Next_Shipment_Date__c, Plant_Next_Delivery_Date__c,Order_Count__c, Recordtype.Name 
                                                            FROM Plant_Subscription__c WHERE Plant_Account__c=:existingCustomerId LIMIT 49999]){
                                                                
                                                                SubscriptionInfo_Wrap SubscriptionInfo=new SubscriptionInfo_Wrap();
                                                                SubscriptionInfo.status=subscription.Plant_Status__c;
                                                                SubscriptionInfo.SubscriptionId=subscription.Id;
                                                                SubscriptionInfo.recordType = subscription.Recordtype.Name;
                                                                //SubscriptionInfo.SfOrderNumber=subscription.Plant_Next_Pending_Order__r.OrderNumber;
                                                                SubscriptionInfo.StartDate=subscription.Plant_Start_Date__c;
                                                                SubscriptionInfo.nextscheduledCharge=subscription.Plant_Next_Charge_Date__c;
                                                                SubscriptionInfo.nextShipmentDate=subscription.Plant_Next_Shipment_Date__c;
                                                                SubscriptionInfo.nextDeliveryDate=subscription.Plant_Next_Delivery_Date__c;
                                                                SubscriptionInfo.Order_Count = Integer.valueOf(subscription.Order_Count__c);
                                                                SubscriptionInfo_List.add(SubscriptionInfo);
                                                            }
                    
                    if(!SubscriptionInfo_List.isEmpty()){
                        statusCode='200';
                        status='Sucess';
                        msg+='Subscriptions fetched Sucessfully';
                    }
                    else{
                        statusCode='200';
                        status='Success';
                        msg+='No Subscription available';
                    }
                    
                }
                else{
                    System.debug('&&&&&&&& = > 13');
                    statusCode='503';
                    status='error';
                    msg+=', Service Unavailable!';
                    
                }
            }
            
        }
        catch(Exception ex){
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            // Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
            // return responseWrap;
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(SubscriptionInfo_List));
        return responseWrap;
    }

    // Method 2: 
    // @ desc: update Subscription Payment Method Setp 1
    public Plant_Utility.responseWrapper setSubscription_PaymentDetails(subsption_PaymentUpdate_Wrap reqWrp){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';        
        String paymentMethod_Id ='';
        Plant_Payment_Method__c newPaymentMethod = new Plant_Payment_Method__c();
        plantable_Constants__c custSettin = plantable_Constants__c.getValues('DevConstant'); // custom setting : constants
        List<cardUpdateResp> cardUpdate_List=new List<cardUpdateResp>();
        
        // SET: Savepoint for rollback if bad data
        Savepoint initial_SavePointState = Database.setSavepoint();
        try{
            if(reqWrp!=null){
                
                // VALIDATION 1: valid authorization token
                if(!String.isBlank(reqWrp.authenticationToken)){
                    // check Authorize token
                    String validationResult = plant_AuthorizeController.validate_ByAccessToken(reqWrp.authenticationToken);
                    System.debug('### auth result=> '+validationResult);
                    if(validationResult.startsWith('Success')){
                        existingCustomerId =  validationResult.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Account : '+validationResult;
                    }
                    
                    
                    // get subscription
                    if(status!='error' && !String.isBlank(reqWrp.subscriptionId)){ 
                        List<Plant_Subscription__c> subscriptionList = [SELECT id,Plant_Chargent_Order__c , Plant_Account__c, Plant_Status__c, RecordType.Name, Plant_Shipping_Address__c, Plant_Payment_Method__c, Plant_Next_Shipment_Date__c, 
                        Plant_Next_Charge_Date__c,Plant_Next_Delivery_Date__c FROM Plant_Subscription__c WHERE Id=:reqWrp.subscriptionId  AND Plant_Account__c=:existingCustomerId];
                        
                        if(!subscriptionList.isEmpty()){
                            // subscription avaialble
                            if(subscriptionList[0].Plant_Status__c!='Canceled' || 
                               subscriptionList[0].Plant_Status__c!='Expired'){
                                   
                                   if(subscriptionList[0].Plant_Chargent_Order__c!=null){
                                       
                                    // CHECK CARD INFORMATION
                                        if(String.isBlank(reqWrp.paymentMethodId) && reqWrp.cardInformation!=null){

                                            System.debug('NEW PAYMENT METHOD:' + reqWrp.cardInformation +'~'+ subscriptionList[0].Plant_Payment_Method__c);
                                            
                                            // create new Payment method
                                            newPaymentMethod.Plant_Customer_Name__c=reqWrp.cardInformation.name;
                                            if(!String.isBlank(reqWrp.cardInformation.expDate)){
                                                if(Plant_Utility.checkDateFormat(reqWrp.cardInformation.expDate)){
                                                    newPaymentMethod.Plant_Expiration_Date__c = Date.valueOf(reqWrp.cardInformation.expDate );
                                                }
                                                else {
                                                    statusCode='503';
                                                    status='error';
                                                    msg += ', expDate format incorrect';
                                                }
                                            }
                                            if(!String.isBlank(reqWrp.cardInformation.card_Last_4_Digits)){
                                                if (Plant_Utility.CheckValidInteger(reqWrp.cardInformation.card_Last_4_Digits)) {
                                                    newPaymentMethod.Plant_Card_Last_4_Digits__c = reqWrp.cardInformation.card_Last_4_Digits ;
                                                }else{
                                                    statusCode='503';
                                                    status='error';
                                                    msg += ', card_Last_4_Digits format incorrect';
                                                }
                                            }
                                            if(!String.isBlank(reqWrp.cardInformation.cardnumber)){
                                                if (Plant_Utility.CheckValidInteger(reqWrp.cardInformation.cardnumber)) {
                                                    newPaymentMethod.Plant_Card_Number__c = reqWrp.cardInformation.cardnumber ;
                                                }else{
                                                    statusCode='503';
                                                    status='error';
                                                    msg += ', cardnumber format incorrect';
                                                }
                                            }
                                            if(!String.isBlank(reqWrp.cardInformation.card_Type)){
                                                newPaymentMethod.Plant_Card_Type__c = reqWrp.cardInformation.card_Type ;
                                            }
                                            if(!String.isBlank(reqWrp.cardInformation.cvv)){
                                                if (Plant_Utility.CheckValidInteger(reqWrp.cardInformation.cvv)) {
                                                    newPaymentMethod.CCV__c = reqWrp.cardInformation.cvv ;
                                                }else{
                                                    statusCode='503';
                                                    status='error';
                                                    msg += ', cvv format incorrect';
                                                }
                                            }
                                            
                                            boolean addressFlag = false;
                                            //  only update billing address 
                                            if(!String.isBlank(reqWrp.cardInformation.billingAddress.street1)){ 
                                                newPaymentMethod.Plant_street1__c = reqWrp.cardInformation.billingAddress.street1 ;
                                            }
                                            else{
                                                addressFlag = true;
                                            }
                                            /*if(!String.isBlank(reqWrp.cardInformation.billingAddress.street2)){
                                                newPaymentMethod.Plant_street2__c = reqWrp.cardInformation.billingAddress.street2 ;
                                            }
                                            else {
                                                addressFlag = true;
                                            }
                                            
                                            if(!String.isBlank(reqWrp.cardInformation.billingAddress.street3)){
                                                newPaymentMethod.Plant_street3__c = reqWrp.cardInformation.billingAddress.street3 ;
                                            }
                                            else {
                                                addressFlag = true;
                                            }*/
                                            
                                            if(!String.isBlank(reqWrp.cardInformation.billingAddress.city)){
                                                newPaymentMethod.Plant_City__c = reqWrp.cardInformation.billingAddress.city ;
                                            }
                                            else {
                                                addressFlag = true;
                                            }
                                            if(!String.isBlank(reqWrp.cardInformation.billingAddress.state)){
                                                newPaymentMethod.Plant_Province_State__c = reqWrp.cardInformation.billingAddress.state ;
                                            }
                                            else{
                                                addressFlag = true;
                                            }
                                            
                                            if(!String.isBlank(reqWrp.cardInformation.billingAddress.zip)){
                                                newPaymentMethod.Plant_Postal_Code__c = reqWrp.cardInformation.billingAddress.zip ;
                                            }else {
                                                addressFlag = true;
                                            }
                                            if(!String.isBlank(reqWrp.cardInformation.billingAddress.country)){
                                                newPaymentMethod.Plant_Country__c = reqWrp.cardInformation.billingAddress.country ;
                                            }
                                            else {
                                                addressFlag = true;
                                            }
                                            if(!String.isBlank(reqWrp.cardInformation.billingAddress.phone) && Plant_Utility.CheckValidInteger(reqWrp.cardInformation.billingAddress.phone)){
                                                newPaymentMethod.Plant_Phone__c = reqWrp.cardInformation.billingAddress.phone ;
                                            }
                                            else{
                                                addressFlag = true;
                                            }
                                            newPaymentMethod.Plant_Account__c = subscriptionList[0].Plant_Account__c;
                                            
                                            // billing address check:
                                            if(addressFlag){
                                                statusCode='503';
                                                status='error';
                                                msg += ' ,Incomplete Billing address.';
                                            }
                                            
                                            if(statusCode!='503'){
                                                // AG - Update Payment Method Info on Subscription
                                                Plant_Payment_Method__c paymentRec = Plant_Orders_BC.clonePaymentMethod(newPaymentMethod, subscriptionList[0].Plant_Payment_Method__c, False);
                                                System.debug('clone paymentRec:' + paymentRec);
                                                update paymentRec;
                                                paymentMethod_Id = paymentRec.Id;
                                            }                                      
                                        }
                                        else if(!String.isBlank(reqWrp.paymentMethodId)){
                                            
                                            System.debug('EXISTING PAYMENT ID:' + reqWrp.paymentMethodId);
                                            
                                            // EXISTING PAYMENT ID
                                            List<Plant_Payment_Method__c> existPaymentMethodList = [SELECT id,Plant_Account__c,Plant_Customer_Name__c, Plant_Card_Type__c, Plant_Card_Number__c,CCV__c, Plant_Card_Last_4_Digits__c,
                                                                                                    Plant_Expiration_Date__c, Plant_Street1__c, Plant_Street2__c, Plant_Street3__c, Plant_City__c, Plant_Country__c, Plant_Province_State__c, Plant_Postal_Code__c, Plant_Can_SMS__c, Plant_Phone__c FROM Plant_Payment_Method__c WHERE Plant_Is_Account_Record__c = true AND id=:reqWrp.paymentMethodId AND Plant_Account__c=:existingCustomerId];
                                            if(existPaymentMethodList.isEmpty()){
                                                statusCode='503';
                                                status='error';
                                                msg += ', Service Unavailable! Invalid PaymentMethod Id';
                                            }
                                            else{
                                                // AG - Clone "account" payment record
                                                Plant_Payment_Method__c paymentRec = Plant_Orders_BC.clonePaymentMethod(existPaymentMethodList[0], subscriptionList[0].Plant_Payment_Method__c, False);
                                                update paymentRec;
                                                //insert paymentRec;
                                                paymentMethod_Id = paymentRec.Id;
                                            }
                                            
                                        }
                                        else{
                                            statusCode='503';
                                            status='error';
                                            msg += 'Payment information not found : ';
                                        }
                                       
                                       if(!String.isBlank(paymentMethod_Id)){
                                           
                                           System.debug('CLONE EXISTING cORDER:' + paymentMethod_Id);
                                           
                                           // CLONE EXISTING cORDER 
                                           List<ChargentOrders__ChargentOrder__c> toClone_Chargent = [SELECT id,ChargentOrders__Account__c,ChargentOrders__Transaction_Count_Recurring__c, ChargentOrders__Payment_Method__c, ChargentOrders__Card_Type__c, 
                                                                                                      ChargentOrders__Charge_Amount__c, ChargentOrders__Subtotal__c, ChargentOrders__Payment_Status__c, 
                                                                                                      ChargentOrders__Payment_Start_Date__c, ChargentOrders__Payment_Frequency__c, ChargentOrders__Payment_Stop__c, 
                                                                                                      ChargentOrders__Payment_Count__c, ChargentOrders__Gateway__c  FROM ChargentOrders__ChargentOrder__c 
                                                                                                    WHERE id=:subscriptionList[0].Plant_Chargent_Order__c];
                                         
                                            
                                           System.debug('toClone_Chargent:' + toClone_Chargent);
                                           
                                           if(toClone_Chargent.isEmpty()){
                                                statusCode='503';
                                                status='error';
                                                msg += 'Service Unavailable! Bad Record cOrder, Contact System Admin!';
                                            }
                                            else{
                                                ChargentOrders__ChargentOrder__c new_cOrder = toClone_Chargent[0].clone(false, true, false, false);
                                                new_cOrder.ChargentOrders__Card_Type__c = newPaymentMethod.Plant_Card_Type__c;
                                                new_cOrder.ChargentOrders__Payment_Start_Date__c = System.today().addDays(7); 
                                                //new_cOrder.ChargentOrders__Payment_End_Date__c = System.today().addDays(7); 
                                                // INSERT new cOrder
                                                insert new_cOrder;

                                                // UPDATE SUBSCRIPTION
                                                subscriptionList[0].Plant_New_Chargent_Order_Id__c = new_cOrder.Id;
                                                subscriptionList[0].Plant_New_Payment_Method_Id__c = paymentMethod_Id;

                                                update subscriptionList[0];

                                                cardUpdateResp cResp=new cardUpdateResp();
                                                cResp.cOrderId = new_cOrder.id;
                                                cResp.subscriptionId = subscriptionList[0].id;
                                                cResp.paymentId = paymentMethod_Id;
                                                //cResp.orderPropId = ;
                                                
                                                cardUpdate_List.add(cResp);
                                                
                                                statusCode='200';
                                                status='Success';
                                                msg+='Payment Information Saved! Please Authorize your card';
                                                
                                            }
                                        }
                                       
                                   }
                                   else{
                                       statusCode='503';
                                       status='error';
                                       msg+=', Service Unavailable! Bad record Subscription: cOrder. Contact System Admin';
                                   }
                                   
                               }
                            else{
                                statusCode='503';
                                status='error';
                                msg+=', Service Unavailable! No Active Subscription Found';
                            }
                            
                        }
                        else{
                            // IncorrectId
                            statusCode='503';
                            status='error';
                            msg+=', Service Unavailable! No Subscription Found';
                        }
                    }   
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Invalid Subscription Id';
                    }                       
                    
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Service Unavailable! Unknown Token';
                }
            }
            else{
                statusCode='503';
                status='error';
                msg+='Service Unavailable! Request Incorrect';
            }
            
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD payment update step 1: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            // ROLLBACK TO PREVIOUS STATE
            Database.rollback(initial_SavePointState);
        }
        
        //List<String> responseList = new List<String>();
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(cardUpdate_List));
        return responseWrap;
        
    }

    // Method 2.1: 
    // @ desc: update Subscription Payment Method (Authorize card) Setp 2
    public Plant_Utility.responseWrapper setSubscription_PaymentDetailsSetp2(CardAuthorize_ReqWrap reqWrap){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        String sfOrder_Var = '';
        //Savepoint initial_SavePointState1 = Database.setSavepoint();
         try{   
                // VALIDATE: AuthenticationToken
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

            // Validation If Values are empty
            if(!String.isBlank(existingCustomerId)){
                if(String.isBlank(reqWrap.cOrderId) || String.isBlank(reqWrap.paymentId)){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Required value missing';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                }
                else{

                    // Creating Variables for the Objects:::
                    ChargentOrders__ChargentOrder__c cOrder_Var = new ChargentOrders__ChargentOrder__c();
                    Plant_Payment_Method__c payment_Var = new Plant_Payment_Method__c();
                    plantable_Constants__c custSettin = plantable_Constants__c.getValues('DevConstant'); // custom setting : constants
                    ChargentOrders__ChargentOrder__c old_cOdr = new ChargentOrders__ChargentOrder__c();
                    Plant_Order_Properties__c orderProp_Var = new Plant_Order_Properties__c();
                    Order odr=new Order();
                    // Validation if Record Ids are working Id is Wrong
                    
                    List<ChargentOrders__ChargentOrder__c> cOrder_List = [SELECT id, ChargentOrders__Charge_Amount__c, ChargentOrders__Billing_Address__c, ChargentOrders__Payment_Count__c, ChargentOrders__Billing_City__c, ChargentOrders__Billing_State__c, ChargentOrders__Transaction_Count_Recurring__c, 
                                                                        ChargentOrders__Billing_Zip_Postal__c,ChargentOrders__Payment_Stop__c,ChargentOrders__Subtotal__c, ChargentOrders__Billing_Country__c  FROM ChargentOrders__ChargentOrder__c WHERE id=:reqWrap.cOrderId AND ChargentOrders__Account__c=:existingCustomerId LIMIT 1 ];
                    
                    List<Plant_Payment_Method__c> paymentMethodList = [SELECT Id,Plant_Expiration_Date__c, Plant_Card_Type__c, Plant_Card_Number__c, Plant_Customer_Name__c, CCV__c,Plant_Card_Last_4_Digits__c,
                                                                        Plant_Account__c FROM Plant_Payment_Method__c WHERE Id=: reqWrap.paymentId AND Plant_Account__c=:existingCustomerId AND (Plant_Expiration_Date__c!=null AND Plant_Card_Type__c!=null AND  Plant_Card_Number__c!=null AND  Plant_Customer_Name__c!=null AND  CCV__c!=null AND Plant_Card_Last_4_Digits__c!=null AND Plant_Account__c!=null) LIMIT 1];
                    
                    List<Plant_Subscription__c> subscription = [SELECT Id, Plant_Start_Date__c, Plant_Status__c, Plant_Cadence__c, Plant_Charge_Day__c, Plant_Shipping_Address__c, Plant_Payment_Method__c, Plant_Account__c, 
                                                                     Plant_Chargent_Order__c, Order_Count__c,Plant_New_Chargent_Order_Id__c, Plant_Next_Charge_Date__c, (Select id, name, comty_Chargent_Order__c from Orders__r Order by createdDate DESC Limit 1),
                                                                    Plant_New_Payment_Method_Id__c FROM Plant_Subscription__c where id=:reqWrap.subscriptionID AND Plant_Account__c=:existingCustomerId Limit 1];
					

                    if(cOrder_List.isEmpty() || paymentMethodList.isEmpty() || subscription.isEmpty()){
                        statusCode='503';
                        status='error';
                        msg='Service Unavailable! Invalid RecordIDs';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    } else if(subscription[0].Plant_Status__c == 'Canceled' || subscription[0].Plant_Status__c == 'Expired'){
                        statusCode='503';
                        status='error';
                        msg='Subscription is not Active! can not update payment method';
                        List<String> respList = new List<String>();
                        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                        return responseWrap;
                    }
                    else{
                        payment_Var = paymentMethodList[0];
                        cOrder_Var  = cOrder_List[0];
                        odr.id = subscription[0].Orders__r[0].id;
                        String  charg_jsonBody =  JSON.serialize(new Plant_Orders_BC.chargentAuthorizeReq_class(cOrder_Var.id,''+payment_Var.Plant_Expiration_Date__c.Month(),''+payment_Var.Plant_Expiration_Date__c.Year(),custSettin.chargentOrderPaymentMethod__c,payment_Var.Plant_Card_Type__c, payment_Var.CCV__c,payment_Var.Plant_Card_Number__c,cOrder_Var.ChargentOrders__Subtotal__c,false, payment_Var.Plant_Customer_Name__c!=null?payment_Var.Plant_Customer_Name__c:'',payment_Var.Plant_Customer_Name__c!=null?payment_Var.Plant_Customer_Name__c:'',cOrder_Var.ChargentOrders__Billing_Address__c,cOrder_Var.ChargentOrders__Billing_City__c,cOrder_Var.ChargentOrders__Billing_State__c,cOrder_Var.ChargentOrders__Billing_Zip_Postal__c,cOrder_Var.ChargentOrders__Billing_Country__c));// BS**
                        ChargentBase__Gateway__c cgateway = [SELECT id,name FROM ChargentBase__Gateway__c WHERE id IN (SELECT ChargentOrders__Gateway__c FROM ChargentOrders__ChargentOrder__c WHERE id =: cOrder_Var.id)]; // BS**
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
                                if(subscription[0].Plant_Chargent_Order__c!=null){
                                  List<ChargentOrders__ChargentOrder__c> old_cOdrList=[SELECT id, ChargentOrders__Charge_Amount__c, ChargentOrders__Billing_Address__c, ChargentOrders__Billing_City__c, ChargentOrders__Billing_State__c, ChargentOrders__Transaction_Count_Recurring__c,
                                    ChargentOrders__Billing_Zip_Postal__c,ChargentOrders__Payment_Stop__c,ChargentOrders__Subtotal__c, ChargentOrders__Billing_Country__c, ChargentOrders__Payment_Count__c  FROM ChargentOrders__ChargentOrder__c WHERE id=:reqWrap.cOrderId AND ChargentOrders__Account__c=:existingCustomerId LIMIT 1 ];
                                    old_cOdr = old_cOdrList[0];
                                }
                                // UPDATE new CHARGENT ORDER(start)
                                cOrder_Var.ChargentOrders__Payment_Start_Date__c = subscription[0].Plant_Next_Charge_Date__c;
                                cOrder_Var.ChargentOrders__Payment_End_Date__c = null;
                                //cOrder_Var.ChargentOrders__Payment_Stop__c='Count';
                                // cOrder_Var.ChargentOrders__Payment_Count__c = old_cOdr.ChargentOrders__Payment_Count__c;
                                if(cOrder_Var.ChargentOrders__Payment_Stop__c=='Count'){
                                     if(cOrder_Var.ChargentOrders__Payment_Count__c > cOrder_Var.ChargentOrders__Transaction_Count_Recurring__c){
                                          cOrder_Var.ChargentOrders__Payment_Count__c = cOrder_Var.ChargentOrders__Payment_Count__c - cOrder_Var.ChargentOrders__Transaction_Count_Recurring__c;
                                          cOrder_Var.ChargentOrders__Payment_End_Date__c = subscription[0].Plant_Next_Charge_Date__c.addDays((Integer)cOrder_Var.ChargentOrders__Payment_Count__c);

                                        }
                                    
                                  }else{
                                    cOrder_Var.ChargentOrders__Payment_End_Date__c=system.today().addDays(90);
                                  }
                                  
                                //Savepoint initial_SavePointState1 = Database.setSavepoint();
                                System.debug('Tag 1 : ');
                                update cOrder_Var;
                                System.debug('Tag 2 : ');
                                //nw_cOdr.ChargentOrders__Payment_Count__c
                                

                                // UPDATE old CHARGENT ORDER(STOP)
                                //old_cOdr.ChargentOrders__Payment_End_Date__c = System.today();
                                System.debug('Tag 3 : ');
                                old_cOdr.ChargentOrders__Payment_Status__c = 'Complete';
                                update old_cOdr;
                                System.debug('Tag 4 : ');
                                  // Updating Order
                                  odr.comty_Chargent_Order__c=cOrder_Var.id;
                                  update odr;

                                // UPDATE SUBSCRIPTION
                                System.debug('Tag b: '+subscription[0].Plant_New_Chargent_Order_Id__c);
                                subscription[0].Plant_Chargent_Order__c = subscription[0].Plant_New_Chargent_Order_Id__c;
                                System.debug('Tag a: '+subscription[0].Plant_New_Chargent_Order_Id__c);
                                System.debug('Tag b: '+subscription[0].Plant_New_Payment_Method_Id__c);
                                subscription[0].Plant_Payment_Method__c = subscription[0].Plant_New_Payment_Method_Id__c;
                                System.debug('Tag a: '+subscription[0].Plant_New_Payment_Method_Id__c);
                                subscription[0].Plant_New_Chargent_Order_Id__c ='';
                                subscription[0].Plant_New_Payment_Method_Id__c ='';
                                System.debug('Tag 5 : ');
                                update subscription;
                                
                                // AG - Add post Subscription Event
                                Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Payment Change',subscription[0].Plant_Account__c,null,subscription[0].Id));
                                
                                System.debug('Tag 6 : ');
                                //Database.rollback(initial_SavePointState1);
                                System.debug('Tag 7 : ');
                                System.debug('###### Transaction authorization OK');
                                statusCode='200';
                                status='successful!';
                                msg='Card updated, Transaction authorize successfully';

                            }
                            else {
                                System.debug('Tag 8 : ');
                                subscription[0].Plant_New_Chargent_Order_Id__c ='';
                                subscription[0].Plant_New_Payment_Method_Id__c ='';
                                update subscription;
                                System.debug('Tag 9 : ');
                                statusCode='501';
                                status='error!';
                                msg='Transaction Authorize error!'+auth_result.Message;

                            }
                        }
                        else{   
                                System.debug('Tag 10 : ');
                                subscription[0].Plant_New_Chargent_Order_Id__c ='';
                                subscription[0].Plant_New_Payment_Method_Id__c ='';
                                update subscription;
                                System.debug('Tag 11 : ');
                            // NO SUCCESS CALLOUT
                            statusCode='501';
                            status='error!';
                            msg='Transaction Authorize error!\n'+auth_result.Message;
                        }
                    }
                }
            }
        }
         catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Authorizing new card : '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            // ROLLBACK TO PREVIOUS STATE
            //Database.rollback(initial_SavePointState1);
        }
        List<String> responseList = new List<String>();
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(responseList));
        return responseWrap;
    }


    // Method 3: (depreciation)
    // @ desc: To Void Existing Transaction
    public Plant_Utility.responseWrapper voidTransaction(voidTransaction_Wrap reqWrp){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        Map<Id, ChargentOrders__Transaction__c> chargentPendingTrens_Map = new Map<Id, ChargentOrders__Transaction__c>();
        plantable_Constants__c custSettin = plantable_Constants__c.getValues('DevConstant'); // custom setting : constants
        
        try{
            if(reqWrp!=null){
                
                // VALIDATION 1: valid authorization token
                if(!String.isBlank(reqWrp.authenticationToken)){
                    // check Authorize token
                    String validationResult = plant_AuthorizeController.validate_ByAccessToken(reqWrp.authenticationToken);
                    System.debug('### auth result=> '+validationResult);
                    if(validationResult.startsWith('Success')){
                        existingCustomerId =  validationResult.split(',')[1];
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Account : '+validationResult;
                    }
                    
                    
                    // get subscription
                    if(!String.isBlank(reqWrp.subscriptionId)){ 
                        List<Plant_Subscription__c> subscriptionList = [SELECT id, Plant_Chargent_Order__r.ChargentOrders__Subtotal__c, Plant_Account__c, Plant_Status__c, RecordType.Name, Plant_Shipping_Address__c, Plant_Payment_Method__c,Plant_Chargent_Order__c, 
                                                                         Plant_Next_Shipment_Date__c, Plant_Next_Charge_Date__c,Plant_Next_Delivery_Date__c FROM Plant_Subscription__c WHERE Id=:reqWrp.subscriptionId  AND Plant_Account__c=:existingCustomerId];
                        
                        if(!subscriptionList.isEmpty()){
                            // subscription avaialble
                            if(subscriptionList[0].Plant_Status__c!='Canceled' || 
                               subscriptionList[0].Plant_Status__c!='Expired'){
                                   
                                   if(subscriptionList[0].Plant_Chargent_Order__c!=null){
                                       
                                       //---------------
                                       
                                       // GET EXISTING TRANSACTIONS
                                       Map<Id, ChargentOrders__Transaction__c> temp_chargentPendingTrens_Map = new Map<Id, ChargentOrders__Transaction__c>([SELECT Id, ChargentOrders__Type__c FROM ChargentOrders__Transaction__c WHERE ChargentOrders__Order__c=:subscriptionList[0].Plant_Chargent_Order__c AND ChargentOrders__Type__c='Authorization']);
                                       if(!temp_chargentPendingTrens_Map.isEmpty())
                                           chargentPendingTrens_Map= temp_chargentPendingTrens_Map;
                                       
                                       System.debug('@@@ existing transaction => '+chargentPendingTrens_Map);
                                       // CHECK CHARGENT REMAINING TRANSACTION AND VOID
                                       if(!chargentPendingTrens_Map.isEmpty()){
                                           for(String trnasctionId : chargentPendingTrens_Map.keySet()){
                                               
                                               // call chargent : authorize order 
                                               ChargentOrders.TChargentOperations.TChargentResult auth_result = ChargentOrders.TChargentOperations.VoidTransaction_Click(trnasctionId);
                                               
                                               if(auth_result.responseData!=null){
                                                   // SUCCESSFULL void CALLOUT
                                                   Map<String,Object> responseDta = (Map<String,Object>)JSON.deserializeUntyped(auth_result.responseData);
                                                   System.debug('#### key set==> '+responseDta.keySet());
                                                   // complete transaction
                                                   if(String.valueOf(responseDta.get('responseCode'))=='200'){
                                                       
                                                       System.debug('###### Transaction authorization OK');
                                                       statusCode='200';
                                                       status='successful!';
                                                       msg+=', Transaction Void successfully';
                                                       
                                                   }
                                                   else {
                                                       statusCode='501';
                                                       status='error!';
                                                       msg+=', Transaction void error!'+auth_result.Message;
                                                       
                                                   }
                                               }
                                               else{
                                                   // NO SUCCESS CALLOUT
                                                   statusCode='501';
                                                   status='error!';
                                                   msg+=', Transaction void error!\n'+auth_result.Message;
                                               }
                                           }
                                       }
                                       else{
                                           // NO PENDING TRANSACTIONS
                                           
                                       }
                                       
                                   }
                                   else{
                                       statusCode='503';
                                       status='error';
                                       msg+=', Service Unavailable! Incorrect Subscription record. Contact System Admin';
                                   }
                                   
                               }
                            else{
                                statusCode='503';
                                status='error';
                                msg+=', Service Unavailable! No Active Subscription Found';
                            }
                            
                        }
                        else{
                            // IncorrectId
                            statusCode='503';
                            status='error';
                            msg+=', Service Unavailable! No Subscription Found';
                        }
                    }   
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Invalid Subscription Id';
                    }                       
                    
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Service Unavailable! No Token found';
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
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
        
    }
    
    // Method 4: 
    // @ desc: update Subscription Address record for Account Id
    public Plant_Utility.responseWrapper setSubscription_Address(subsption_AddressUpdate_Wrap reqWrp){
        
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        
        Savepoint sp = Database.setSavepoint();
        try{
            
            if(reqWrp!=null){
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(reqWrp.authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(reqWrp.authenticationToken);
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
                    
                    // Validation: Customer Subscription Id
                    if(!String.isBlank(reqWrp.subscriptionId)){
                        List<Plant_Subscription__c> subscriptionList = [SELECT id,Plant_Meal_Selection__c, Plant_Chargent_Order__r.ChargentOrders__Subtotal__c, Plant_Account__c, Plant_Status__c, RecordType.Name, Plant_Shipping_Address__c, Plant_Payment_Method__c,Plant_Chargent_Order__c,
                                                                        Plant_Next_Shipment_Date__c, Plant_Next_Charge_Date__c,Plant_Next_Delivery_Date__c FROM Plant_Subscription__c WHERE Id=:reqWrp.subscriptionId AND Plant_Account__c=:existingCustomerId];
                        
                        System.debug('subscriptionList:'+subscriptionList);
                        if(!subscriptionList.isEmpty()){
                            
                            Plant_Subscription__c tempSub = subscriptionList[0];
                            
                            // VALIDATE: existing shipping address id, if valid
                            if(!String.isBlank(reqWrp.shipmentAddressId)){
                                List<Plant_Shipping_Address__c> shipAddress=[Select id, Plant_Account__c,Plant_Is_Account_Record__c,Plant_First_Name__c,Plant_Last_Name__c,Plant_Can_SMS__c,Plant_Phone__c,Plant_Street1__c,Plant_Street2__c,Plant_Street3__c,Plant_City__c,Plant_Province_State__c,Plant_Postal_Code__c,Plant_Country__c from Plant_Shipping_Address__c where Plant_Is_Account_Record__c = True AND id=:reqWrp.shipmentAddressId Limit 1];
                                // shipping id valid:
                                if(!shipAddress.isEmpty()){
                                    Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                                    tempAddrsWrap.state=shipAddress[0].Plant_Province_State__c;
                                    tempAddrsWrap.zip=shipAddress[0].Plant_Postal_Code__c;
                                    // check: Available delivery date for the address
                                    Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                                    if(availableDates_List.status=='success'){
                                        if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                            if(availableDates_List.result.resultMap.keySet().size()==0){
                                                statusCode='503';
                                                status='error';
                                                msg+='Shipping date not available for this address, ';
                                            }
                                            // VALIDATION: check selivery format if exist
                                            if(Plant_Utility.checkDateFormat(reqWrp.deliveryDate)){
                                                Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                                if(avail_DeliveryDaye_Map.keySet().contains(reqWrp.deliveryDate)){
                                                                                                        
                                                    // AG - Update Address
                                                    Plant_Shipping_Address__c cloneSA = Plant_Shipping_BC.cloneShippingAddress(shipAddress[0], tempSub.Plant_Shipping_Address__c, False);
                                                    System.debug('Clone ShipAddr:'+cloneSA);
                                                    update cloneSA;
                                                                                                        
                                                    // UPDATE shipping address
                                                    //tempSub.Plant_Shipping_Address__c = cloneSA.Id;
                                                    tempSub.Plant_Next_Delivery_Date__c = Date.valueOf(reqWrp.deliveryDate);
                                                    update tempSub;
                                                    
                                                    // AG - Add post Subscription Event
                                                    Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Address Change',tempSub.Plant_Account__c,null,tempSub.Id));

                                                    // update next pending order
                                                    // Order next_Odr = new Order();
                                                    // next_Odr.Id = tempSub.Plant_Next_Pending_Order__c;
                                                    // next_Odr.Plant_Delivery_Date__c = Date.valueOf(reqWrp.deliveryDate);
                                                    // next_Odr.Plant_Shipping_Date__c= avail_DeliveryDaye_Map.get(reqWrp.deliveryDate).split(':')[0];
                                                    // update next_Odr;
                                                    
                                                    
                                                    Status = 'Success';
                                                    StatusCode='200';
                                                    msg='Shipping Address updated successfully';
                                                    
                                                }
                                                else {
                                                    // NOT AVAILABLE
                                                    statusCode='503';
                                                    status='error';
                                                    msg+='Shipping date not available for address, ';
                                                }
                                            }
                                            else {
                                                statusCode='503';
                                                status='error';
                                                msg+='Incorrect Date format please try (yyyy-mm-dd), ';
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
                                else{ // invalid subscription Id
                                    statusCode='503';
                                    status='error';
                                    msg+='No shipping Address found for this ShippingId, ';
                                }
                            }
                            else{// check for new shipping address detailes
                                if(Plant_Utility.checkAddress(reqWrp.shippingAddress)){
                                    
                                    Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                                    tempAddrsWrap.state=reqWrp.shippingAddress.state;
                                    tempAddrsWrap.zip=reqWrp.shippingAddress.zip;
                                    Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                                    System.debug('&&&&&&&&# Sub Date check = >'+availableDates_List);
                                    
                                    if(availableDates_List.status=='success'){
                                        if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                            if(availableDates_List.result.resultMap.keySet().size()==0){
                                                statusCode='503';
                                                status='error';
                                                msg+='Shipping date not available for this address, ';
                                            }
                                            else{
                                                // CHECKING: available shipping date from sf Delivery schedule records
                                                System.debug('@@@@ check date => '+reqWrp.deliveryDate);
                                                
                                                if(Plant_Utility.checkDateFormat(reqWrp.deliveryDate)){
                                                    Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                                    if(avail_DeliveryDaye_Map.keySet().contains(reqWrp.deliveryDate)){
                                                        // SUCCESSFUL Delivery date
                                                        
                                                        msg+='Success: Shipping date updated successfully, ';
                                                        
                                                        // UPDATE shipping address
                                                        Plant_Shipping_Address__c shipAdd_rec = new Plant_Shipping_Address__c();
                                                        shipAdd_rec.Plant_Can_SMS__c = reqWrp.shippingAddress.canSMS?true:false;
                                                        if(!String.isBlank(reqWrp.shippingAddress.firstName)){
                                                            shipAdd_rec.Plant_First_Name__c = reqWrp.shippingAddress.firstName;
                                                        }if(!String.isBlank(reqWrp.shippingAddress.LastName)){
                                                            shipAdd_rec.Plant_Last_Name__c = reqWrp.shippingAddress.LastName;
                                                        }if(!String.isBlank(reqWrp.shippingAddress.street1)){
                                                            shipAdd_rec.Plant_street1__c = reqWrp.shippingAddress.street1;
                                                        }
                                                        if(!String.isBlank(reqWrp.shippingAddress.street2)){
                                                            shipAdd_rec.Plant_street2__c = reqWrp.shippingAddress.street2;
                                                        }
                                                        if(!String.isBlank(reqWrp.shippingAddress.street3)){
                                                            shipAdd_rec.Plant_street3__c = reqWrp.shippingAddress.street3;
                                                        }
                                                        if(!String.isBlank(reqWrp.shippingAddress.city))
                                                            shipAdd_rec.Plant_City__c = reqWrp.shippingAddress.city;
                                                        if(!String.isBlank(reqWrp.shippingAddress.country))
                                                            shipAdd_rec.Plant_Country__c = reqWrp.shippingAddress.country; 
                                                        if(!String.isBlank(reqWrp.shippingAddress.phone))     
                                                            shipAdd_rec.Plant_Phone__c = reqWrp.shippingAddress.phone;
                                                        if(!String.isBlank(reqWrp.shippingAddress.zip))      
                                                            shipAdd_rec.Plant_Postal_Code__c = reqWrp.shippingAddress.zip;
                                                        if(!String.isBlank(reqWrp.shippingAddress.state))      
                                                            shipAdd_rec.Plant_Province_State__c = reqWrp.shippingAddress.state;
                                                            shipAdd_rec.Plant_Account__c=existingCustomerId;
                                                        
                                                        // AG - Update instead of insert new ones
                                                        shipAdd_rec.Plant_Save_Shipping_Address__c = True;
                                                        //insert shipAdd_rec;
                                                        
                                                        // Update Address                                                      
                                                        List<Plant_Shipping_Address__c> oldSAs = [select id, Plant_Account__c,Plant_Is_Account_Record__c,Plant_First_Name__c,Plant_Last_Name__c,Plant_Can_SMS__c,Plant_Phone__c,Plant_Street1__c,Plant_Street2__c,Plant_Street3__c,Plant_City__c,Plant_Province_State__c,Plant_Postal_Code__c,Plant_Country__c from Plant_Shipping_Address__c where id = :tempSub.Plant_Shipping_Address__c];
                                                        System.debug('oldSAs:'+oldSAs);
                                                        if(!oldSAs.isEmpty()) {
                                                            Plant_Shipping_Address__c cloneSA = Plant_Shipping_BC.cloneShippingAddress(shipAdd_rec, oldSAs[0].Id, False);
                                                            update cloneSA;    
                                                        }                    
                                                        
                                                        // AG Remove - UPDATE SHIPPING ADDRESS
                                                        // tempSub.Plant_Shipping_Address__c = shipAdd_rec.Id;
                                                        tempSub.Plant_Next_Delivery_Date__c=Date.valueof(reqWrp.deliveryDate);
                                                        update tempSub;
                                                        
                                                        // AG - Add post Subscription Event
                                                        Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Address Change',tempSub.Plant_Account__c,null,tempSub.Id));

                                                        // // update next pending order
                                                        // Order next_Odr = new Order();
                                                        // next_Odr.Id = tempSub.Plant_Next_Pending_Order__c;
                                                        // next_Odr.Plant_Delivery_Date__c = Date.valueOf(reqWrp.deliveryDate);
                                                        // next_Odr.Plant_Shipping_Date__c= avail_DeliveryDaye_Map.get(reqWrp.deliveryDate);
                                                        // update next_Odr;
                                                        
                                                        Status = 'Success';
                                                        StatusCode='200';
                                                        msg='Shipping Address updated successfully';
                                                        
                                                    }
                                                    else {
                                                        // NOT AVAILABLE
                                                        statusCode='503';
                                                        status='error';
                                                        msg+='Shipping date not available for address, ';
                                                    }
                                                }
                                                else {
                                                    statusCode='503';
                                                    status='error';
                                                    msg+='Incorrect Date format please try (yyyy-mm-dd), ';
                                                }
                                            }
                                        }
                                        else{
                                            statusCode='503';
                                            status='error';
                                            msg+='Shipping date not available for this address*,';
                                        }
                                    }
                                    else{
                                        statusCode='503';
                                        status='error';
                                        msg+='Shipping date Not available for this address, ';
                                    }    
                                }
                                else{
                                    StatusCode='503';
                                    Status='error';
                                    msg='Service Unavailable! Shipping address not inserted must be US or Canada';
                                }                            
                            }
                        }
                        else{// Subscription Id not valid
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable! Subscription Id Invalid ';
                        }
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+='Service Unavailable! Subscription Id required';
                    }             
                    
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Invalid Input Json';
                }
            }
            else{
                statusCode='501';
                status='error';
                msg+='Service Unavailable! Incorrect request body';
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Subscription address Update: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=', Internal Server Error: '+ex.getMessage();
            Database.rollback(sp);
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

    // Method 5:
    // @ desc: update Delivery Date
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper update_CustmrSubs_DeliveryDate(Ddate_UpdateWrap delvryAdd_req){
        
        Date newNextDate=null;
        String statusCode = '';
        String status = '';
        String msg = '';
        String existingCustomerId = '';
        
        Savepoint initalState = Database.setSavepoint();
        try{
            // VALIDATION 1: check if body not null
            if(delvryAdd_req!=null){
                List<Order> sfOrder_List = new List<Order>();
                
                // Validation 2: CHECK ACCOUNT TOKEN
                if(!String.isBlank(delvryAdd_req.authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(delvryAdd_req.authenticationToken);
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
                    msg+='Service Unavailable! Authentication Token Missing';
                }
                
                if(!String.isBlank(existingCustomerId)){
                    
                    // VALIDATION: new_Delivery_Date format
                    if(Plant_Utility.checkDateFormat(delvryAdd_req.new_Delivery_Date)){
                        
                        List<Plant_Subscription__c> subscriptionList = [SELECT id, Plant_Account__c, Plant_Status__c, RecordType.Name, Plant_Shipping_Address__c, Plant_Shipping_Address__r.Plant_Province_State__c,Plant_Shipping_Address__r.Plant_Postal_Code__c, Plant_Payment_Method__c, 
                                                                         Plant_Next_Shipment_Date__c, Plant_Next_Charge_Date__c,Plant_Next_Delivery_Date__c FROM Plant_Subscription__c WHERE Id=:delvryAdd_req.subscriptionId AND Plant_Account__c=:existingCustomerId];
                        
                        //check: delvryAdd_req.subscriptionId
                        if(subscriptionList.isEmpty()){
                            // NOT AVAILABLE
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable! Invalid Subscription Id';
                        }
                        else if(!String.isBlank(subscriptionList[0].Plant_Shipping_Address__c)){
                            
                            Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                            tempAddrsWrap.state=subscriptionList[0].Plant_Shipping_Address__r.Plant_Province_State__c;
                            tempAddrsWrap.zip=subscriptionList[0].Plant_Shipping_Address__r.Plant_Postal_Code__c;
                            
                            // check: Available delivery date for the address
                            Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                            if(availableDates_List.status=='success'){
                                if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                    if(availableDates_List.result.resultMap.keySet().size()==0){
                                        statusCode='503';
                                        status='error';
                                        msg+=delvryAdd_req.new_Delivery_Date+' delivery date not available for this address,';
                                    }
                                    else{
                                        Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                        if(avail_DeliveryDaye_Map.keySet().contains(delvryAdd_req.new_Delivery_Date)){
                                            Plant_Shipping_Date__c sAddress = new Plant_Shipping_BC().getShipDateRecord(avail_DeliveryDaye_Map.get(delvryAdd_req.new_Delivery_Date).split(':')[0]);
                                            // UPDATE shipping address
                                            Plant_Subscription__c tempSub  = new Plant_Subscription__c();
                                            tempSub.Id = subscriptionList[0].Id;
                                            tempSub.Plant_Next_Delivery_Date__c = Date.valueOf(delvryAdd_req.new_Delivery_Date);
                                            tempSub.Plant_Next_Shipment_Date__c = sAddress.Plant_Shipping_Date__c;
                                            tempSub.Plant_Delivery_Schedule__c = (id)avail_DeliveryDaye_Map.get(delvryAdd_req.new_Delivery_Date).split(':')[1];
                                            update tempSub;
                                            
                                            // // update next pending order
                                            // Order next_Odr = new Order();
                                            // next_Odr.Id = subscriptionList[0].Plant_Next_Pending_Order__c;
                                            // next_Odr.Plant_Delivery_Date__c = Date.valueOf(delvryAdd_req.new_Delivery_Date);
                                            // next_Odr.Plant_Shipping_Date__c = sAddress.id;
                                            // update next_Odr;
                                            
                                            // AG - Add post Subscription Event
                                            Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Date Change',subscriptionList[0].Plant_Account__c,null,subscriptionList[0].Id));

                                            Status = 'Success';
                                            StatusCode='200';
                                            
                                            msg='Delivery date updated successfully.\nNew Shipping date:  '+sAddress.Plant_Shipping_Date__c;
                                            
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
                        else{ // invalid subscription Id
                            statusCode='503';
                            status='error';
                            msg+='No shipping Address found for this ShippingId, ';
                        }
                    }
                    else {
                        statusCode='503';
                        status='error';
                        msg+='Incorrect Date format please try (yyyy-mm-dd), ';
                    }
                }
            }
            else{
                statusCode='503';
                status='error';
                msg+='Service unavailable! Bad request body ';
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD DD: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=', Internal Server Error: '+ex.getMessage();
            Database.rollback(initalState);
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

    // Method 6:
    // Call to change status of subscription(Active/Pause/Cancel)
    public Plant_Utility.responseWrapper updateSubscruptionStatus(SubscrptionWrap subsRequestWrap){
        String statusCode='';
        String status='';
        String msg='';
        //Validate if subscription correct
        try{
            //Plant_Account__c
            List<Plant_Subscription__c> pt_Subs_List = [SELECT Id,Plant_Account__c,Plant_Status__c,Plant_Chargent_Order__c,Plant_Chargent_Order__r.ChargentOrders__Payment_Status__c,Plant_Account__r.plant_TokenCreatedDateTime__c FROM Plant_Subscription__c WHERE id=:subsRequestWrap.subscriptionId LIMIT 1];
            
            // AG - Protect pt_Subs_List[0]
            if(!pt_Subs_List.isEmpty()){
                	Plant_Subscription__c pt_Subs = pt_Subs_List[0];
                
                 // VALIDATE: AuthenticationToken
                    String validationResult = plant_AuthorizeController.validateAccessToken('',pt_Subs.Plant_Account__c, subsRequestWrap.authenticationToken);
                    if(validationResult.startsWith('Success')){
                
                    boolean isUpdate=false;
                    ChargentOrders__ChargentOrder__c chg_odr = new ChargentOrders__ChargentOrder__c();

                    // GET CHARGENT ORDER RECORD
                    if(pt_Subs.Plant_Chargent_Order__c!=null){
                        chg_odr = [SELECT id, ChargentOrders__Status__c, ChargentOrders__Payment_Status__c FROM  ChargentOrders__ChargentOrder__c WHERE id=:pt_Subs.Plant_Chargent_Order__c LIMIT 1];
                        
                        // check if already cancled
                        if(pt_Subs.Plant_Status__c == 'Canceled' && (chg_odr.ChargentOrders__Status__c=='Canceled' && chg_odr.ChargentOrders__Payment_Status__c=='Stopped')){
                            // ALREADY CANCELED
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable: Subscription Already Canceled';
                        }
                        else if(pt_Subs.Plant_Status__c == 'Expired' && (chg_odr.ChargentOrders__Status__c=='Complete' && chg_odr.ChargentOrders__Payment_Status__c=='Complete')){
                            // ALREADY CANCELED
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable: Subscription Already Expired';
                        }
                        else{

                            if(subsRequestWrap.newStatus=='Paused'){
                                if(pt_Subs.Plant_Status__c!=subsRequestWrap.newStatus){
                                    pt_Subs.Plant_Status__c = subsRequestWrap.newStatus;
                                    chg_odr.ChargentOrders__Payment_Status__c ='Stopped';
                                    isUpdate = True;
                                }
                                else{
                                    statusCode='200';
                                    status='Success';
                                    msg+='Subscription Already Paused';
                                }
                            }
                            else if(subsRequestWrap.newStatus=='Expired'){
                                if(pt_Subs.Plant_Status__c!=subsRequestWrap.newStatus){
                                    pt_Subs.Plant_Status__c = subsRequestWrap.newStatus;
                                    chg_odr.ChargentOrders__Payment_Status__c ='Complete';
                                    chg_odr.ChargentOrders__Status__c ='Complete';
                                    isUpdate = True;
                                }
                                else{
                                    statusCode='200';
                                    status='Success';
                                    msg+='Subscription Already Expired';
                                }
                            }
                            else if(subsRequestWrap.newStatus=='Active'){
                                if(pt_Subs.Plant_Status__c!=subsRequestWrap.newStatus){
                                    pt_Subs.Plant_Status__c = subsRequestWrap.newStatus;
                                    chg_odr.ChargentOrders__Payment_Status__c ='Recurring';
                                    chg_odr.ChargentOrders__Payment_Start_Date__c = System.today();
                                    isUpdate = True;
                                }
                                else{
                                    statusCode='200';
                                    status='Success';
                                    msg+='Subscription Already Active';
                                }
                            }
                            else if(subsRequestWrap.newStatus=='Canceled'){
                                if(pt_Subs.Plant_Status__c!=subsRequestWrap.newStatus){
                                    pt_Subs.Plant_Status__c = subsRequestWrap.newStatus;
                                    chg_odr.ChargentOrders__Payment_Status__c ='Stopped';
                                    chg_odr.ChargentOrders__Status__c ='Canceled';
                                    isUpdate = True;
                                }
                                else{
                                    statusCode='200';
                                    status='Success';
                                    msg+='Subscription Already Canceled';
                                }
                            }
                            else{
                                statusCode='503';
                                status='error';
                                msg+='Service Unavailable: Unable to update to requested status';
                            }
        
                            if(isUpdate){
                                // System.debug('@@@@@ updating SUBSCRIPTION '+pt_Subs);
                                // System.debug('@@@@@ updating Chargent order '+chg_odr);
                                
                                //Subscription update
                                update pt_Subs;
                                // chargent update
                                update chg_odr;
                                
                                // AG - Add post Subscription Event
                                if(subsRequestWrap.newStatus=='Paused') {
                                	Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Paused',pt_Subs.Plant_Account__c,null,pt_Subs.Id));    
                                } else if(subsRequestWrap.newStatus=='Active') {
                                    Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Resumed',pt_Subs.Plant_Account__c,null,pt_Subs.Id));    
                                } else if(subsRequestWrap.newStatus=='Canceled') {
                                    Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Cancelled',pt_Subs.Plant_Account__c,null,pt_Subs.Id));    
                                }
                                
                                statusCode='200';
                                status='Success';
                                msg+='Subscription successfully updated!';
                            }
                        }
                    }    
                    else{
                        // ERROR: NO CHARGENT RECORD
                        // incorrect record: reach system admin
                        statusCode='500';
                        status='error';
                        msg+='Internal server error: incorrect record: reach system admin';
                    }

                    List<String> respList = new List<String>();
                    Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
                    return responseWrap;
                }
                else{
                    // TOKEN NOT VALID
                    statusCode='501';
                    status='error!';
                    msg='Transaction Authorize error!\n'+validationResult;

                }
           
            }
            else {
                statusCode='500';
                status='error';
                msg+=' Internal Server Error: Invalid SubscriptionId';
            }
            
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }   
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Subscription status update : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: Subscription - '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }

    // Method 7: 
    // @ desc: update Subscription Meals record for Account Id
    public Plant_Utility.responseWrapper setSubscription_Meals(subsption_MealUpdate_Wrap reqWrp){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        List<subscription_MealUpdate_Resp> subscriptionMeal_List= new List<subscription_MealUpdate_Resp>();
        try{
            
            if(reqWrp!=null){
                // VALIDATION 1: check Authorize token
                String validationResult = plant_AuthorizeController.validate_ByAccessToken(reqWrp.authenticationToken);
                System.debug('### auth result=> '+validationResult);
                if(validationResult.startsWith('Success')){
                    existingCustomerId =  validationResult.split(',')[1];
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Service Unavailable! Account : '+validationResult;
                }
                
                // get subscription
                if(!String.isBlank(reqWrp.subscriptionId)){ 
                    
                    List<Plant_Meal_Selection__c> existingMealSelectionList = new List<Plant_Meal_Selection__c>();
                    List<Plant_Subscription__c> subscriptionList = [SELECT id,Plant_Meal_Selection__c, Plant_Chargent_Order__r.ChargentOrders__Subtotal__c, Plant_Account__c, Plant_Status__c, RecordType.Name, Plant_Shipping_Address__c, Plant_Payment_Method__c,Plant_Chargent_Order__c,
                                                                     Plant_Next_Shipment_Date__c, Plant_Next_Charge_Date__c,Plant_Next_Delivery_Date__c FROM Plant_Subscription__c WHERE Id=:reqWrp.subscriptionId AND Plant_Account__c=:existingCustomerId];
                    
                    if(!subscriptionList.isEmpty()){
                        String new_MealSelection_RecId = '';
                        Boolean oldMeal = false;
                        Boolean newMeal = false;
                        
                        // CHECK MEAL 
                        //if(String.isBlank(reqWrp.mealSelectionId)){
                        if(reqWrp.meals!=null){
                            // INSERT MEAL SELECTION
                            Plant_Meal_Selection__c new_MealSelection_Rec = new Plant_Meal_Selection__c();
                            // new_MealSelection_Rec.recordTypeId = Schema.SObjectType.Plant_Meal_Selection__c.getRecordTypeInfosByName().get(subscriptionList[0].RecordType.Name).getRecordTypeId();
                            insert new_MealSelection_Rec; 
                            
                            new_MealSelection_RecId = new_MealSelection_Rec.Id;
                            
                            newMeal = true;
                        }
                        else{
                            // ERROR No Meal
                            statusCode='503';
                            status='error';
                            msg+=', Incorrect request body : No meal to add';
                        }
                        //}
                        //else{
                        //if()msg+=', meal selection Id can not be recognised'
                        // CHECK MEAL SELECTION ID
                        //   existingMealSelectionList = [SELECT Id FROM Plant_Meal_Selection__c WHERE id=:reqWrp.mealSelectionId];
                        //oldMeal = true;
                        // }
                        
                        // add meals
                        if(newMeal){
                            
                            Plant_Utility.wrapMeal[] tempMealListWrap = new List<Plant_Utility.wrapMeal>();
                            tempMealListWrap = reqWrp.meals;
                            
                            Integer mealCount = 0;
                            for(Plant_Utility.wrapMeal mel : tempMealListWrap){
                                Integer quant=Integer.Valueof(mel.quantity);
                                mealCount+=quant;
                            }
                            
                            
                            
                            if(mealCount==12){
                                System.debug('&&&&&&&& = > ');
                                
                                // remove all selected list and add new meal list
                                Plant_Utility.wrapMeal[] tempMealList = new List<Plant_Utility.wrapMeal>();
                                tempMealList = reqWrp.meals;
                                
                                Plant_Meals_BC.MealSelectionReq_Wrapper reqWp = new Plant_Meals_BC.MealSelectionReq_Wrapper();
                                reqWp.mealSelectionId = new_MealSelection_RecId;
                                reqWp.mealList = tempMealList;
                                
                                // UPDATE MEAL IN subscription:MEAL SELECTION
                                Plant_Utility.responseWrapper setMeals_Response  = new Plant_Meals_BC().updateMealSelection(reqWp);
                                
                                if(setMeals_Response.statusCode=='200'){
                                    // SUCCESS
                                    statusCode='200';
                                    status='Success';
                                    msg+=', Meals has been Updated';
                                    
                                    
                                    // UPDATE SUBSCRIPTION
                                    Plant_Subscription__c subs =  new Plant_Subscription__c();
                                    subs.Id = subscriptionList[0].Id;
                                    subs.Plant_Meal_Selection__c = new_MealSelection_RecId;
                                    update subs;
                                    
                                    // AG - Add post Subscription Event
                                    Plant_TransComm_BC.publishTransactionEvent(Plant_TransComm_BC.setTransactionEvent('Subscription Meal Change',subscriptionList[0].Plant_Account__c,null,subscriptionList[0].Id));

                                }
                                else{
                                    // return error
                                    statusCode='503';
                                    status='error';
                                    msg+=', Meals are not Insertd: '+setMeals_Response.result;
                                }
                                
                            }
                            else {
                                System.debug('&&&&&&&&');
                                statusCode='503';
                                status='error';
                                msg+=', Please add 12 meal items';
                            }
                            
                        }
                        
                        
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! Incorrect Subscription Id';
                    }
                } 
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Subscription Id required';
                }   
            }
            else{
                // ERROR : incorrect request body
                statusCode='503';
                status='error';
                msg+='Incorrect request body : No SubscriptionId';
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD customer meal Update: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=', Internal Server Error: '+ex.getMessage();
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(subscriptionMeal_List));
        return responseWrap;
    }

    // @ Method 8:
    // @ Desc:  get Subscription Details for a Customer
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper getSubscriptionDetails(String authenticationToken, String subscriptionId){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
        String response='';
        List<Account> Plant_Account=new List<Account>();
        List<SubscriptionDetails_Wrap> SubscriptionInfo_List = new List<SubscriptionDetails_Wrap>();
        try{
            
                
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
                
                for(Plant_Subscription__c subscription:[SELECT Id, Name, Plant_Account__c, Plant_Status__c, Plant_Next_Charge_Date__c, Plant_Start_Date__c,
                                                        Plant_Next_Shipment_Date__c, Plant_Next_Delivery_Date__c, Plant_Cadence__c, Order_Count__c,Plant_Delivery_Schedule__c,
                                                        Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c, Plant_Payment_Method__r.Plant_Card_Type__c,
                                                        Plant_Shipping_Address__r.Plant_Street1__c, Plant_Shipping_Address__r.Plant_Street2__c, Plant_Shipping_Address__r.Plant_Street3__c,
                                                        Plant_Shipping_Address__r.Plant_City__c,Plant_Shipping_Address__r.Plant_Province_State__c, 
                                                        Plant_Shipping_Address__r.Plant_Country__c,Plant_Shipping_Address__r.Plant_Postal_Code__c,
                                                        Plant_Shipping_Address__r.Plant_First_Name__c, Plant_Shipping_Address__r.Plant_Last_Name__c,
                                                        Plant_Shipping_Address__r.Plant_Phone__c,
                                                        Plant_Shipping_Address__c, Plant_Payment_Method__c, Plant_Chargent_Order__c, Plant_Meal_Selection__c, RecordTypeId
                                                        FROM Plant_Subscription__c WHERE id=:subscriptionId AND Plant_Account__c=:existingCustomerId LIMIT 49999]){
                                                            
                                                            SubscriptionDetails_Wrap SubscriptionInfo=new SubscriptionDetails_Wrap();
                                                            if(!String.isBlank(subscription.Plant_Status__c)){
                                                                SubscriptionInfo.status=subscription.Plant_Status__c;
                                                            }
                                                            if(!String.isBlank(subscription.Name)){
                                                                SubscriptionInfo.name=subscription.Name;
                                                            }
                                                            if(!String.isBlank(subscription.Plant_Cadence__c)){
                                                                SubscriptionInfo.cadence=subscription.Plant_Cadence__c;
                                                            }
                                                            if(subscription.Plant_Account__c!=null){
                                                                SubscriptionInfo.accountId=subscription.Plant_Account__c;
                                                            }
                                                            if(subscription.Plant_Chargent_Order__c!=null){
                                                                SubscriptionInfo.plantChargentOrder=subscription.Plant_Chargent_Order__c;
                                                            }
                                                            if(subscription.Order_Count__c!=null){
                                                                SubscriptionInfo.ordersCompleted=subscription.Order_Count__c;
                                                            }
                                                            if(subscription.Plant_Delivery_Schedule__c!=null){
                                                                SubscriptionInfo.plantDeliverySchedule=subscription.Plant_Delivery_Schedule__c;
                                                            }
                                                            if(subscription.Plant_Shipping_Address__c!=null){
                                                                SubscriptionInfo.shippingAddress=subscription.Plant_Shipping_Address__c;
                                                                SubscriptionInfo.street1=subscription.Plant_Shipping_Address__r.Plant_Street1__c;
                                                                SubscriptionInfo.street2=subscription.Plant_Shipping_Address__r.Plant_Street2__c;
                                                                SubscriptionInfo.street3=subscription.Plant_Shipping_Address__r.Plant_Street3__c;
                                                                SubscriptionInfo.state=subscription.Plant_Shipping_Address__r.Plant_Province_State__c;
                                                                SubscriptionInfo.country=subscription.Plant_Shipping_Address__r.Plant_Country__c;
                                                                SubscriptionInfo.city=subscription.Plant_Shipping_Address__r.Plant_City__c;
                                                                SubscriptionInfo.postalCode=subscription.Plant_Shipping_Address__r.Plant_Postal_Code__c;
                                                                SubscriptionInfo.firstName=subscription.Plant_Shipping_Address__r.Plant_First_Name__c;
                                                                SubscriptionInfo.lastName=subscription.Plant_Shipping_Address__r.Plant_Last_Name__c;
                                                                SubscriptionInfo.Phone=subscription.Plant_Shipping_Address__r.Plant_Phone__c;
                                                            }
                                                            if(subscription.Plant_Payment_Method__c!=null){
                                                                SubscriptionInfo.paymentMethod=subscription.Plant_Payment_Method__c;
                                                                SubscriptionInfo.cardLastFourDigits=subscription.Plant_Payment_Method__r.Plant_Card_Last_4_Digits__c;
                                                                SubscriptionInfo.cardType=subscription.Plant_Payment_Method__r.Plant_Card_Type__c;
                                                            }
                                                            if(subscription.Plant_Meal_Selection__c!=null){
                                                                SubscriptionInfo.mealSelection=subscription.Plant_Meal_Selection__c;
                                                            }
                                                            if(subscription.Plant_Start_Date__c!=null){
                                                                SubscriptionInfo.StartDate=subscription.Plant_Start_Date__c;
                                                            }
                                                            if(subscription.Plant_Next_Charge_Date__c!=null){
                                                                SubscriptionInfo.nextscheduledCharge=subscription.Plant_Next_Charge_Date__c;
                                                            }
                                                            if(subscription.Plant_Next_Shipment_Date__c!=null){
                                                                SubscriptionInfo.nextShipmentDate=subscription.Plant_Next_Shipment_Date__c;
                                                            }
                                                            if(subscription.Plant_Next_Delivery_Date__c!=null){
                                                                SubscriptionInfo.nextDeliveryDate=subscription.Plant_Next_Delivery_Date__c;
                                                            }
                                                            if(subscription.recordtypeid!=null){
                                                                SubscriptionInfo.SubscriptionType=Schema.SObjectType.Plant_Subscription__c.getRecordTypeInfosById().get(subscription.recordtypeid).getname();
                                                            }
                                                            SubscriptionInfo.SubscriptionId=subscription.id;
                                                            SubscriptionInfo_List.add(SubscriptionInfo);
                                                        }
                
                if(!SubscriptionInfo_List.isEmpty()){
                    statusCode='200';
                    status='Sucess';
                    msg+='Subscriptions fetched Sucessfully';
                }
                else{
                    statusCode='200';
                    status='Success';
                    msg+='No Subscription available';
                }
                
            }
            else{
                System.debug('&&&&&&&& = > 13');
                statusCode='503';
                status='error';
                msg+=', Service Unavailable!';
                
            }
        }
        catch(Exception ex){
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD OP: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(SubscriptionInfo_List));
        return responseWrap;
    }

    // Method 6:
    // Call to change status of subscription(Active/Pause/Cancel)
    public Plant_Utility.responseWrapper cancelSubscription(cancelSubscrptionWrap subsRequestWrap){
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId='';
        try{
            if(subsRequestWrap!=null){
                // VALIDATION 1: check Authorize token
                String validationResult = plant_AuthorizeController.validate_ByAccessToken(subsRequestWrap.authenticationToken);
                System.debug('### auth result=> '+validationResult);
                if(validationResult.startsWith('Success')){
                    existingCustomerId =  validationResult.split(',')[1];
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Service Unavailable! Account : '+validationResult;
                }
                if(!String.isBlank(existingCustomerId)){
                    //Plant_Account__c
                    List<Plant_Subscription__c> pt_Subs_List = [SELECT Id,Plant_Start_Date__c, recordtype.Name, Plant_Status__c, Plant_Cadence__c, Plant_Charge_Day__c,Plant_Shipping_Address__c, Plant_Payment_Method__c, Plant_Account__c, 
                                                                     Plant_Chargent_Order__c, Order_Count__c,Plant_New_Chargent_Order_Id__c, Plant_Next_Charge_Date__c,
                                                                     (Select id, name, comty_Chargent_Order__c from Orders__r Order by createdDate DESC Limit 1),
                                                                    Plant_New_Payment_Method_Id__c, Plant_Chargent_Order__r.ChargentOrders__Payment_Status__c, Plant_Account__r.plant_TokenCreatedDateTime__c
                     FROM Plant_Subscription__c WHERE id=:subsRequestWrap.subscriptionId AND Plant_Account__c=:existingCustomerId LIMIT 1];
            
                    if(!pt_Subs_List.isEmpty()){


                       List<ChargentOrders__ChargentOrder__c> chg_odr = [SELECT id, ChargentOrders__Status__c, 
                        ChargentOrders__Account__c,ChargentOrders__Transaction_Count_Recurring__c, ChargentOrders__Payment_Method__c, ChargentOrders__Card_Type__c, 
                       ChargentOrders__Charge_Amount__c, ChargentOrders__Subtotal__c, ChargentOrders__Payment_Status__c, 
                       ChargentOrders__Payment_Start_Date__c, ChargentOrders__Payment_Frequency__c, ChargentOrders__Payment_Stop__c, 
                       ChargentOrders__Payment_Count__c, ChargentOrders__Gateway__c FROM  ChargentOrders__ChargentOrder__c WHERE id=:pt_Subs_List[0].Plant_Chargent_Order__c LIMIT 1];
                        
                        // check if already cancled
                        if(pt_Subs_List[0].Plant_Status__c == 'Canceled' && (chg_odr[0].ChargentOrders__Status__c=='Canceled' && chg_odr[0].ChargentOrders__Payment_Status__c=='Stopped')){
                            // ALREADY CANCELED
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable: Subscription Already Canceled';
                        }
                        else if(pt_Subs_List[0].Plant_Status__c == 'Expired' && (chg_odr[0].ChargentOrders__Status__c=='Complete' && chg_odr[0].ChargentOrders__Payment_Status__c=='Complete')){
                            // ALREADY CANCELED
                            statusCode='503';
                            status='error';
                            msg+='Service Unavailable: Subscription Already Expired';
                        }
                        else{
                            ChargentOrders__ChargentOrder__c new_cOrder = chg_odr[0].clone(false, true, false, false);
                            //new_cOrder.ChargentOrders__Card_Type__c = newPaymentMethod.Plant_Card_Type__c;
                            new_cOrder.ChargentOrders__Payment_Start_Date__c = System.today(); 
                            insert new_cOrder;

                            pt_Subs_List[0].Plant_New_Chargent_Order_Id__c = new_cOrder.Id;
                            update pt_Subs_List[0];
                                // Code to clone and add new order.
                            Order odr=new Order();
                            odr.AccountId = pt_Subs_List[0].Plant_Account__c;
                            odr.Status = 'Draft';
                            odr.Plant_Subscription__c = pt_Subs_List[0].id;
                            odr.comty_Chargent_Order__c = new_cOrder.id;
                            odr.EffectiveDate = System.Today();
                            //odr.Plant_Is_Subscription__c = true;
                            Pricebook2 std_Pbook    = [select id, name from Pricebook2 where isStandard = true limit 1];
                            odr.Pricebook2Id=std_Pbook.id;
                            
                            insert odr;
                            
                            
                            
                            PricebookEntry priceBookEntry = Plant_Orders_BC.getPriceBookEntryByProduct(pt_Subs_List[0].recordType.Name,null);
                            
                            if(priceBookEntry != NULL) {
                                OrderItem newLine = new OrderItem();
                                newLine.OrderId = odr.id;
                                newLine.PricebookEntryId = priceBookEntry.id;
                                newLine.Quantity=1;
                                newLine.UnitPrice = 50;
                                //newLine.UnitPrice = priceBookEntry.UnitPrice;
                                insert newLine;
                                statusCode='200';
                                status='Success';
                                msg+=', Request for Cancel Subscription has been made';
                            }
                            
                        }
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Service Unavailable! No Subscription Found';
                    }
                }
            }
        }   
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Subscription status update : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: Subscription - '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
        List<String> respList = new List<String>();
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
        return responseWrap;
    }
    
    // AG - Internal Methods
    
    // Post Transaction Handler - After an Order Payment or Change is made this method will handle any remaining non-criitical work
    // This is to remove load from the actual transaction
    // Thigs we do here:
    // 1. Update Account Lookups
    // 2. Stage scheduled communications (future charges)
    public static void postTransactionOrderHandler(List<Plant_Transaction__e> lstSubscriptionEvents) {
        
        // Setup ID Lists
        MAP<String,String> mapAcctSubs = new MAP<String,String>();
        for(Plant_Transaction__e pte :lstSubscriptionEvents) {
            mapAcctSubs.put(pte.Plant_AccountId__c, pte.Plant_SubscriptionId__c);
        }
        System.debug('postTransactionOrderHandler mapAcctSubs:' + mapAcctSubs);

        List<Account> lstAccount = [select Id, Plant_Reboot_Subscription__c, Plant_Meal_Subscription__c from Account where id in :mapAcctSubs.keySet()];
        System.debug('lstAccount:' + lstAccount);
        MAP<String,Account> mapAccts = new MAP<String,Account>();
        for(Account a :lstAccount) {
			mapAccts.put(a.id, a);
        }
        System.debug('mapAccts:' + mapAccts);
        
        List<Plant_Subscription__c> lstSub = [select Id, RecordType.Name, Plant_Next_Charge_Date__c from Plant_Subscription__c where id in :mapAcctSubs.values()];
        System.debug('lstSub:' + lstSub);
        MAP<String,Plant_Subscription__c> mapSubs = new MAP<String,Plant_Subscription__c>();
        for(Plant_Subscription__c ps :lstSub) {
			mapSubs.put(ps.id, ps);
        }
        System.debug('mapSubs:' + mapSubs);
        
        List<Account> updateAtts = new List<Account>();
        for(Plant_Transaction__e pte :lstSubscriptionEvents) {
            
            System.debug('pte:' + pte);
                
            Plant_Subscription__c fndSub = mapSubs.get(pte.Plant_SubscriptionId__c);
            System.debug('fndSub:' + fndSub);
                
            Account fndAcct = mapAccts.get(pte.Plant_AccountId__c);
            System.debug('fndAcct:' + fndAcct);
                                
            if(pte.Plant_Type__c == 'Subscription Created') {
            
                // Update Account subscription lookups
                if(fndSub != NULL && fndAcct != NULL) {
                    if(fndSub.RecordType.Name == 'Reboot') {
                        fndAcct.Plant_Reboot_Subscription__c = fndSub.Id;
                    } else {
                        fndAcct.Plant_Meal_Subscription__c = fndSub.Id;
                    }
                    System.debug('Add updateAtts:' + fndAcct);
                    updateAtts.add(fndAcct);
                }
                
                // Stage Scheduled Emails
                Plant_TransComm_BC.stageScheduledTransComm('Subscription Payment Upcoming', fndAcct.Id, null, fndSub.Id, fndSub.Plant_Next_Charge_Date__c);
                
            } else if(pte.Plant_Type__c == 'Subscription Cancelled' || pte.Plant_Type__c == 'Subscription Paused') {
                
                // Cancel Staged Scheduled Emails
                Plant_TransComm_BC.cancelStagedScheduledTransComm('Subscription Payment Upcoming', fndAcct.Id, null, fndSub.Id);
             
                
            } else if(pte.Plant_Type__c == 'Subscription Date Change' || pte.Plant_Type__c == 'Subscription Address Change' || pte.Plant_Type__c == 'Subscription Resumed') {

                // Stage Scheduled Emails
                // This is cancel the old one, and create a new one on the correct date
                Plant_TransComm_BC.stageScheduledTransComm('Subscription Payment Upcoming', fndAcct.Id, null, fndSub.Id, fndSub.Plant_Next_Charge_Date__c);
                
            }
        }
        System.debug('updateAtts:' + updateAtts);
        if(!updateAtts.isEmpty()) {
            update updateAtts;
        }
    }
    
    //########################################  WRAPPER CLASSES   ##################################################################
    
    // wrap 1
    // to give response of Subscription Information
    public class SubscriptionInfo_Wrap{
        public String status;
        //public String SfOrderNumber;
        public String SubscriptionId;
        public date StartDate;
        public date nextscheduledCharge;
        public date nextShipmentDate;
        public date nextDeliveryDate;
        public Integer Order_Count;
        public String recordType;
        
    }

    // wrap 2
    // to give response of Subscription Information
    public class SubscriptionDetails_Wrap{
        public String status;
        public String name;
        public String accountId;
        public String cadence;
        public String plantChargentOrder;
        public Decimal ordersCompleted;
        public String plantDeliverySchedule;
        public String SubscriptionId;
        public String shippingAddress;
        public String paymentMethod;
        public String mealSelection;
        public date StartDate;
        public date nextscheduledCharge;
        public date nextShipmentDate;
        public date nextDeliveryDate;
        public String SubscriptionType;
        public String cardLastFourDigits;
        public String cardType;
        public String street1;
        public String street2;
        public String street3;
        public String state;
        public String country;
        public String city;
        public String postalCode;
        public String firstName;
        public String lastName;
        public String Phone;
        
    }

    // wrap 3:
    // desc: Wrapper to update subscription Address
    public class subsption_AddressUpdate_Wrap{
        public String authenticationToken;
        public String subscriptionId;
        public String deliveryDate;
        public Plant_Utility.addressCapsule shippingAddress;
        public String shipmentAddressId;
        
        //desc:   parse and return wrapper object
        public subsption_AddressUpdate_Wrap parse(String json){
            return (subsption_AddressUpdate_Wrap)System.JSON.deserialize(json, subsption_AddressUpdate_Wrap.class);
        }
    }
    
    // wrap 4:
    // wrapper to authorizecard
    public class CardAuthorize_ReqWrap{
        public String cOrderId;
        public String subscriptionId;
        public String authenticationToken; // #new
        public String paymentId;
        //public String orderPropId;

        public CardAuthorize_ReqWrap parse(String json_op){
            return (CardAuthorize_ReqWrap)JSON.deserialize(json_op, CardAuthorize_ReqWrap.class);
        }
    }
    
    // Wrap 5
    // wrapper to get responce of card
    public class cardUpdateResp{
        public String cOrderId;
        public String subscriptionId;
        public String paymentId;
        //public String orderPropId;
    }

    // wrap 6:
    // delivery date update wrapper
    public class Ddate_UpdateWrap{
        public String new_Delivery_Date; // newDay
        public string authenticationToken; 
        public String subscriptionId; 
        
        //desc:   parse and return wrapper object
        public Ddate_UpdateWrap parse(String json){
            return (Ddate_UpdateWrap)System.JSON.deserialize(json, Ddate_UpdateWrap.class);
        }
    }

    // wrapper 7:
    // wrap Subscription status change request
    public class SubscrptionWrap{
        public String subscriptionId;
        public String newStatus;
        public String authenticationToken; // #new

        public SubscrptionWrap parse(String sub_Json){
            return (SubscrptionWrap)JSON.deserialize(sub_Json, SubscrptionWrap.class);
        }
    }

    // wrapper 7.1:
    // wrap Subscription status change request
    public class cancelSubscrptionWrap{
        public String subscriptionId;
        public String authenticationToken; // #new

        public cancelSubscrptionWrap parse(String sub_Json){
            return (cancelSubscrptionWrap)JSON.deserialize(sub_Json, cancelSubscrptionWrap.class);
        }
    }

    // wrap 8:
    // desc: Wrapper to create Account
    public class subsption_PaymentUpdate_Wrap{
        public String authenticationToken;
        public String subscriptionId;
        public String paymentMethodId;//(optional)
        public Plant_Orders_BC.cardWrapper cardInformation;
        
        //desc:   parse and return wrapper object
        public subsption_PaymentUpdate_Wrap parse(String json){
            return (subsption_PaymentUpdate_Wrap)System.JSON.deserialize(json, subsption_PaymentUpdate_Wrap.class);
        }
    }

    // wrap 9:
    // desc: Wrapper to update subscription meal
    public class voidTransaction_Wrap{
        public String authenticationToken;
        public String subscriptionId;
        
        //desc:   parse and return wrapper object
        public voidTransaction_Wrap parse(String json){
            return (voidTransaction_Wrap)System.JSON.deserialize(json, voidTransaction_Wrap.class);
        }
    }

    // wrap 10:
    // desc: Wrapper to update subscription meal
    public class subsption_MealUpdate_Wrap{
        public String authenticationToken;
        public String subscriptionId;
        
        public Plant_Utility.wrapMeal[] meals;
        //public String mealSelectionId;
        
        //desc:   parse and return wrapper object
        public subsption_MealUpdate_Wrap parse(String json){
            return (subsption_MealUpdate_Wrap)System.JSON.deserialize(json, subsption_MealUpdate_Wrap.class);
        }
    }
    // wrap 11:
    // desc: Wrapper to update subscription meal
    public class subscription_MealUpdate_Resp{
        public String SubscriptionId;
        public String mealSelectionId;
        public Plant_Utility.wrapMeal[] meals;
    }
}