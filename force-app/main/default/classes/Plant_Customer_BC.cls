/*In Progress Plant call
*   @Desciption     :   Plantable (Customer Business class)
*                       
*   @Create date    :   29-06-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
@Test class     :   
*/
public class Plant_Customer_BC {
    //Default Constructor

    public Plant_Customer_BC() {
        
    }
    // @ Method 1~~~~~~~~~~~~~~~~~~~~~~~~
    // @ Desc:  Account fields Update (NAME, EMAIL, PHONE) // Cart
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper updateAccountInfo(Plant_Customer_BC.AccountInfo_Wrap Account_Wrap){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
        String response='';
        List<Account> Plant_Account=new List<Account>();
        List<Contact> Plant_Contact=new List<Contact>();
        List<userAuth_ResponseWrap> authResp_List = new List<userAuth_ResponseWrap>();
        try{
            if(Account_Wrap!=null){
                
                // CHECK ACCOUNT TOKEN
                if(!String.isBlank(Account_Wrap.authenticationToken)){
                    String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(Account_Wrap.authenticationToken);
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
                    List<Account> customer_RecdList = [SELECT Id,(Select id from Contacts Limit 200), Name, Email__c, Phone, plant_Authentication_Token__c, plant_TokenLife__c FROM Account WHERE id=:existingCustomerId];
                    if(!customer_RecdList.isEmpty()){
                        // if Multiple Account of same email
                        if(customer_RecdList.size()>1){
                            status = 'error';
                            statusCode='501';
                            msg+='Internal server error: Please contact Support';
                        }
                        else{
                            
                            for(Account acct:customer_RecdList){
                                Account acc=new Account();
                                Contact con = new Contact();
                                acc.id=acct.id;
                                                                
                                if(!String.isBlank(Account_Wrap.firstName) && !String.isBlank(Account_Wrap.lastname)){
                                    acc.name=Account_Wrap.firstname+' '+Account_Wrap.lastname;
                                    con.firstName = Account_Wrap.firstName;
                                    con.lastName = Account_Wrap.lastname;
                                    msg+='Name is Edited';
                                }
                                if(!String.isBlank(Account_Wrap.phone)){
                                    if(Plant_Utility.CheckValidInteger(Account_Wrap.phone)){
                                        acc.Phone=Account_Wrap.phone;
                                        con.Phone = Account_Wrap.phone;
                                        msg+=', Phone is Updated';
                                    }
                                    else{
                                        msg+=', Phone is in incorrect format';
                                    }
                                }
                                
                                if(!String.isBlank(Account_Wrap.email)){
                                    if(Plant_Utility.checkEmail(Account_Wrap.email)){
                                        acc.Email__c=Account_Wrap.email.toLowerCase();
                                        con.Email = Account_Wrap.email.toLowerCase();
                                        msg+=', Email is Updated';
                                    }
                                    else{
                                        msg+=', Email is in incorrect format';
                                    }
                                }
                                
                                Plant_Account.add(acc); 
                                if(!acct.Contacts.isEmpty()){
                                    con.id=acct.Contacts[0].id;
                                    Plant_Contact.add(con);
                                }
                                
                            }
                            // update account
                            update(Plant_Account);
                            if(!Plant_Contact.isEmpty()){
                                update(Plant_Contact);
                            }
                            
                            status = 'Success';
                            statusCode='200';
                            msg+=', Customer Information updated Sucessfully';
                            
                        }
                    }
                }
                
                authResp_List.add(new Plant_Customer_BC.userAuth_ResponseWrap(response));
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(Plant_Account));
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
            
            
            authResp_List.add(new Plant_Customer_BC.userAuth_ResponseWrap(response));
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(authResp_List));
            return responseWrap;
        }
    }
    
    
    // @ Method 5~~~~~~~~~~~~~~~~~~~~~~~~
    // @ Desc:  create New Account
    // ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    public Plant_Utility.responseWrapper createAccount(Plant_Customer_BC.createAccount_Wrap Account_Wrap){
        String status='';
        String statusCode='';
        String msg='';
        String existingCustomerId = '';
        String response='';
        Account acc=new Account();
        Contact con = new Contact();
        List<createAccount_Resp> AccountResp_List = new List<createAccount_Resp>();
        List<String> AccountId_List=new List<String>();
        Savepoint sp1_AccInitialState = Database.setSavepoint();
        try{
            // VALIDATION 1: Check if request wrapper has value
            if(Account_Wrap!=null){
                
                if(!String.isBlank(Account_Wrap.firstName) || !String.isBlank(Account_Wrap.lastName)){

                    if(!String.isBlank(Account_Wrap.firstName)){
                        acc.First_Name__c = Account_Wrap.firstName;
                        con.FirstName = acc.First_Name__c;
                    }
                    if(!String.isBlank(Account_Wrap.lastName)){
                        acc.Last_Name__c = Account_Wrap.lastName;
                        con.LastName = acc.Last_Name__c ;
                    }
                    acc.Name=Account_Wrap.firstName+' '+Account_Wrap.lastName;    
                    
                    
                    // check email
                    if(!String.isBlank(Account_Wrap.email)){
                        if(Plant_Utility.checkEmail(Account_Wrap.email)){
                            acc.Email__c=Account_Wrap.email.toLowerCase();
                            con.email = acc.Email__c;
                        }
                        else{
                            statusCode='503';
                            status='error';
                            msg+=', Invalid Email Format';
                        }
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Email can not be empty';
                    }
                    
                    // check phone
                    if(!String.isBlank(Account_Wrap.phone)){
                        if(Plant_Utility.CheckValidInteger(Account_Wrap.phone)){
                            acc.phone=Account_Wrap.phone;
                            con.phone = acc.phone;
                        }
                        else{
                            statusCode='503';
                            status='error';
                            msg+=', Account phone is in Invalid Format';
                        }
                    }
                    
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Account Name can not be empty';
                }
                
                // create a temp 8 digit password
                String tempPass = Plant_Utility.rendomPassword(8);
                if(!String.isBlank(tempPass)){
                    acc.plant_UserPasswaord__c=tempPass;
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+=', Account Password is Mandatory';
                }
            }
            else{
                statusCode='503';
                status='error';
                msg+=', Service Unavailable! Account details are Empty';
            }
            
            // INSERT ACCOUNT
            insert acc;
            
            if(acc!=null && acc.Id!=null){
                con.AccountId = acc.Id;
                insert con;

                // account create response
                createAccount_Resp Accountresp=new createAccount_Resp(); 
                Accountresp.AccountName=acc.Name;
                Accountresp.temporaryPassword =acc.plant_UserPasswaord__c;
                Accountresp.Account_Id = acc.id;
                
                
                AccountResp_List.add(Accountresp);
                statusCode='200';
                status='Sucess';
                msg+='Account created Successfully!';
                
                Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(AccountResp_List));
                return responseWrap;
                
            }
            
        }
        catch(Exception ex){
            System.debug('&&&&&&&& = > 20');
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Create order account : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: '+ex.getMessage();
            Database.rollback(sp1_AccInitialState);
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

  
    // Method 6: 
    // @ desc: get Customer Info using authentication token.
    public Plant_Utility.responseWrapper getCustomerInfo(String authenticationToken){
        
        String statusCode='';
        String status='';
        String msg='';
        String existingCustomerId = '';
        List<accountInfo_RespWrap> respList=new List<accountInfo_RespWrap>();
        Savepoint sp = Database.setSavepoint();
        try{
            
            if(!String.isBlank(authenticationToken)){
                
                // CHECK ACCOUNT TOKEN
                
                String accAuthResut = plant_AuthorizeController.validate_ByAccessToken(authenticationToken);
                if(accAuthResut.startsWith('Success')){
                    existingCustomerId =  accAuthResut.split(',')[1];
                    
                }
                else{
                    statusCode='503';
                    status='error';
                    msg+='Service Unavailable! Account : '+accAuthResut;
                }
                
                
                if(!String.isBlank(existingCustomerId)){
                    
                    // Validation: Customer Subscription Id
                    List<Account> acc_List=[Select id, name, phone, email__c from account where id=:existingCustomerId];
                    if(!acc_List.isEmpty()){
                        accountInfo_RespWrap AccountInfo=new accountInfo_RespWrap();
                        if(!String.isBlank(acc_List[0].name)){
                            AccountInfo.AccountName = acc_List[0].name;
                        }
                        if(!String.isBlank(acc_List[0].email__c)){
                            AccountInfo.Email = acc_List[0].email__c;
                        }
                        if(!String.isBlank(acc_List[0].phone)){
                            AccountInfo.Phone = acc_List[0].phone;
                        }
                        respList.add(AccountInfo);
                        
                        statusCode='200';
                        status='Success';
                        msg+='Successfully Fetched the Customer Info';
                    }
                }  
                else{
                        statusCode='503';
                        status='error';
                        msg+='Invalid Authentication Token';
                }
            }
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD getting Customer Info : '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=', Internal Server Error: '+ex.getMessage();
            Database.rollback(sp);
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
        return responseWrap;
    }

    
    // Method 7: 
    // @ desc: update Payment Method record  to display based on Account Id
    public Plant_Utility.responseWrapper getAccountPaymentDetails(String authenticationToken){
        PaymtDtlWrap result_paymtMtd = new PaymtDtlWrap();
        List<paymentInfo> paymtMtd_List = new List<paymentInfo>();
        Boolean isPaymtRecd = false;
        String statusCode ='';
        String status ='';
        String msg ='';
        String  AccountId = '';
        try{
            
             // VALIDATE: AuthenticationToken
             String validationResult = plant_AuthorizeController.validate_ByAccessToken(authenticationToken);

             if(validationResult.startsWith('Success')){
                AccountId = validationResult.split(',')[1];
                result_paymtMtd.AccountId = AccountId;

                    for(Plant_Payment_Method__c oprop : [SELECT Id,Plant_Customer_Name__c, Plant_Card_Type__c,Plant_Card_Number__c,CCV__c,Plant_Card_Last_4_Digits__c,Plant_Expiration_Date__c,Plant_Street1__c,Plant_Street2__c,
                                                Plant_Street3__c,Plant_City__c,Plant_Country__c,Plant_Province_State__c,Plant_Postal_Code__c,Plant_Can_SMS__c,Plant_Phone__c FROM Plant_Payment_Method__c WHERE Plant_Account__c=:AccountId ]){
                    
                    paymentInfo paymt_Rcd = new paymentInfo();
                    paymt_Rcd.paymentId = oprop.Id;

                    cardWrapper paymtMtd = new cardWrapper();
                    paymtMtd.name = oprop.Plant_Customer_Name__c ;
                    paymtMtd.cvv = oprop.CCV__c ;
                    paymtMtd.card_Type = oprop.Plant_Card_Type__c ;
                    paymtMtd.cardnumber = oprop.Plant_Card_Number__c ;
                    paymtMtd.card_Last_4_Digits = oprop.Plant_Card_Last_4_Digits__c ;
                    paymtMtd.expDate = String.valueOf(oprop.Plant_Expiration_Date__c );
                    
                    // billing address
                    Plant_Utility.addressCapsule billAdd = new Plant_Utility.addressCapsule();
                    billAdd.street1 = oprop.Plant_street1__c ;
                    billAdd.street2 = oprop.Plant_street2__c ;
                    billAdd.street3 = oprop.Plant_street3__c ;
                    billAdd.city = oprop.Plant_City__c ;
                    billAdd.state = oprop.Plant_Province_State__c ;
                    billAdd.zip = oprop.Plant_Postal_Code__c ;
                    billAdd.country = oprop.Plant_Country__c ;
                    billAdd.phone = oprop.Plant_Phone__c ;
                    billAdd.canSMS = oprop.Plant_Can_SMS__c ;
                    paymtMtd.billingAddress = billAdd;

                    paymt_Rcd.cardInformation = paymtMtd;
                    paymtMtd_List.add(paymt_Rcd);
                }
                
                statusCode='200';
                status='success';
                if(paymtMtd_List.isEmpty()){
                    msg+='No PaymentMethod Exist for this Account Id';
                }
                else{
                    msg+='Payment method detail retrieve';  
                }
                
             }
             else{
                 // TOKEN NOT VALID
                 statusCode='501';
                 status='error!';
                 msg='Transaction Authorize error!\n'+validationResult;
 
             }

            
            //List<cardWrapper> respList = new List<cardWrapper>();
            //respList.add(paymtMtd);
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(paymtMtd_List));
            return responseWrap; 
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Payment List : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: Payment Method error - '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }


     // Method 5: 
    // @ desc: Get all Shipping Address for an Account Id
    public Plant_Utility.responseWrapper getShippingAddresstDetailList(String authenticationToken){
        // authorizationToken
        
        ShippngAddressDtlWrap result_addressWpr_Obj = new ShippngAddressDtlWrap();
        List<ShippngAddressDtl> shipAddress_List = new List<ShippngAddressDtl>();
        Boolean isPaymtRecd = false;
        String statusCode ='';
        String status ='';
        String msg ='';
        String AccountId='';
        
        try{
            
            // VALIDATE: AuthenticationToken
            String validationResult = plant_AuthorizeController.validate_ByAccessToken(authenticationToken);
            System.debug('@@@@@@@@@@ Validation Result  '+validationResult);
            if(validationResult.startsWith('Success')){
                result_addressWpr_Obj.AccountId = validationResult.split(',')[1];
                AccountId = validationResult.split(',')[1];
                System.debug('@@@@@@@@@@ AccountId Result  '+AccountId);
                for(Plant_Shipping_Address__c oprop : [SELECT Id,Plant_Street1__c,Plant_Street2__c,Plant_Street3__c,Plant_City__c,Plant_Province_State__c,Plant_Country__c,Plant_Postal_Code__c,
                                                       Plant_Account__c,Plant_First_Name__c, Plant_Last_Name__c,Plant_Phone__c,Plant_Can_SMS__c  FROM Plant_Shipping_Address__c WHERE Plant_Account__c=:AccountId ]){
                                                           
                                                           ShippngAddressDtl each_ShipRecd = new ShippngAddressDtl();
                                                           each_ShipRecd.shippingAddressId = oprop.Id;
                                                           
                                                           Plant_Utility.addressCapsule shipRecd = new Plant_Utility.addressCapsule();
                                                           shipRecd.street1 = oprop.Plant_street1__c ;
                                                           shipRecd.street2 = oprop.Plant_street2__c ;
                                                           shipRecd.street3 = oprop.Plant_street3__c ;
                                                           shipRecd.city = oprop.Plant_City__c ;
                                                           shipRecd.state = oprop.Plant_Province_State__c ;
                                                           shipRecd.zip = oprop.Plant_Postal_Code__c ;
                                                           shipRecd.country = oprop.Plant_Country__c ;
                                                           shipRecd.phone = oprop.Plant_Phone__c ;
                                                           shipRecd.canSMS = oprop.Plant_Can_SMS__c ;
                                                           each_ShipRecd.shippingAddress = shipRecd;
                                                           
                                                           shipAddress_List.add(each_ShipRecd);
                                                       }
                result_addressWpr_Obj.shippingAddress_List =shipAddress_List;
                
                statusCode='200';
                status='success';
                if(shipAddress_List.isEmpty()){
                    msg+='No Shipping address exist for this Account Id';
                }
                else{
                    msg+='Shipping address detail retrieve';  
                }
            }
            else{
                // TOKEN NOT VALID
                statusCode='501';
                status='error!';
                msg='Transaction Authorize error!\n'+validationResult;
                
            }
            
            //List<cardWrapper> respList = new List<cardWrapper>();
            //respList.add(paymtMtd);
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(shipAddress_List));
            return responseWrap; 
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD Shipping address List : line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            statusCode='500';
            status='error';
            msg+=' Internal Server Error: Shipping address error - '+ex.getMessage();
            List<String> respList = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(respList));
            return responseWrap;
        }
    }

    // Method 3
    // @ desc: update shipping address
    public Plant_Utility.responseWrapper updateShippingAddress(manageShipAddress_wrap managSipAdd_wrapRecd){
        
        // validate if shipping address id correct
        String tempStatus ='';
        String tempStatusCode ='';
        String tempMsg ='';
        boolean ContinueProcess;
        List<Plant_Shipping_Address__c> shipingAdd_updateList = new List<Plant_Shipping_Address__c>();
        Plant_Order_Properties__c ordrPropert = new Plant_Order_Properties__c();
        wrapResponse resp =  new wrapResponse();
        try{
            if(!String.isBlank(managSipAdd_wrapRecd.cartId)){
                ordrPropert = [SELECT Id,Plant_Account__c,Plant_Delivery_Date__c,Plant_Shipping_Date__c,Shipping_Address__c,Shipping_Address__r.Plant_City__c,
                               Shipping_Address__r.Plant_Province_State__c,Shipping_Address__r.Plant_Country__c,
                               Shipping_Address__r.Plant_Postal_Code__c,Shipping_Address__r.Plant_Phone__c,
                               Shipping_Address__r.Plant_Can_SMS__c,Shipping_Address__r.Plant_Account__c,
                               Shipping_Address__r.Plant_First_Name__c,Shipping_Address__r.Plant_Last_Name__c 
                               FROM Plant_Order_Properties__c WHERE Id=:managSipAdd_wrapRecd.cartId LIMIT 1];
                
            }
            
            if(ordrPropert!=null){
                // CART
                if(managSipAdd_wrapRecd.isCustomer==false){
                    if(ordrPropert.Plant_Account__c==null){
                        ContinueProcess=true;
                    }
                    else{
                        ContinueProcess=false;
                        tempMsg+='Cart Already in Progress. Can not update Cart, ';
                    }
                    
                }// CUSTOMER
                else{
                    // CHECK if any subscription record
                    ContinueProcess=true;
                }
                
                if(ContinueProcess){
                    resp.cartId = ordrPropert.Id;
                    Boolean newDateAvailabel = false;
                    
                    if(ordrPropert.Shipping_Address__c!=null){
                        
                        // VALIDATE: address US or Caneda
                        if(Plant_Utility.checkAddress(managSipAdd_wrapRecd.shippingAddress)){
                            // Check: Delivery Date address
                            
                            Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                            tempAddrsWrap.state=managSipAdd_wrapRecd.shippingAddress.state;
                            tempAddrsWrap.zip=managSipAdd_wrapRecd.shippingAddress.zip;
                            
                            Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                            System.debug('&&&&&&&&#  = >'+availableDates_List);
                            
                            if(availableDates_List.status=='success'){
                                if(availableDates_List.result!=null && availableDates_List.result.resultMap!=null){
                                    if(availableDates_List.result.resultMap.keySet().size()==0){
                                        tempMsg+='Shipping date not available for this address, ';
                                    }
                                    else{
                                        // check available shipping date from sf Delivery schedule records
                                        System.debug('@@@@ check date => '+managSipAdd_wrapRecd.deliveryDate);
                                        
                                        if(Plant_Utility.checkDateFormat(managSipAdd_wrapRecd.deliveryDate)){
                                            Map<String,String> avail_DeliveryDaye_Map = (Map<String,String>)availableDates_List.result.resultMap;
                                            if(avail_DeliveryDaye_Map.keySet().contains(managSipAdd_wrapRecd.deliveryDate)){
                                                ordrPropert.Plant_Shipping_Date__c=avail_DeliveryDaye_Map.get(managSipAdd_wrapRecd.deliveryDate).split(':')[0];
                                                ordrPropert.Plant_Delivery_Date__c=Date.valueOf(managSipAdd_wrapRecd.deliveryDate);
                                                newDateAvailabel= true;
                                                tempMsg+='Success: Shipping date updated successfully, ';
                                            }
                                            else {
                                                ordrPropert.Plant_Shipping_Date__c = null;
                                                tempMsg+='Shipping date not available for address, ';
                                            }
                                        }
                                        else {
                                            tempMsg+='No Shipping date for this address, ';
                                        }
                                    }
                                }
                                else{
                                    tempMsg+='Shipping date not available for this address*,';
                                }
                            }
                            else{
                                tempMsg+='Shipping date Not available for this address, ';
                            }
                            
                            if(newDateAvailabel){
                                // update ordrPropert
                                update ordrPropert ; 
                                // (Select id from Orders__r order by createdDate DESC Limit 1),
                                // Order odr=new Order();
                                // odr.id=ordrPropert.Orders__r[0].id;
                                // odr.Plant_Shipping_Date__c=ordrPropert.Plant_Shipping_Date__c;
                                // odr.Plant_Delivery_Date__c=ordrPropert.Plant_Delivery_Date__c;
                                // update odr;

                                // UPDATE shipping address
                                Plant_Shipping_Address__c shipAdd_rec = new Plant_Shipping_Address__c();
                                shipAdd_rec.Id = ordrPropert.Shipping_Address__c;
                                shipAdd_rec.Plant_Can_SMS__c = managSipAdd_wrapRecd.shippingAddress.canSMS?true:false;
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.street1)){
                                    shipAdd_rec.Plant_First_Name__c = managSipAdd_wrapRecd.shippingAddress.firstName;
                                }if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.street1)){
                                    shipAdd_rec.Plant_Last_Name__c = managSipAdd_wrapRecd.shippingAddress.LastName;
                                }
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.street1)){
                                    shipAdd_rec.Plant_street1__c = managSipAdd_wrapRecd.shippingAddress.street1;
                                }
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.street2)){
                                    shipAdd_rec.Plant_street2__c = managSipAdd_wrapRecd.shippingAddress.street2;
                                }
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.street3)){
                                    shipAdd_rec.Plant_street3__c = managSipAdd_wrapRecd.shippingAddress.street3;
                                }
                                
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.city))
                                    shipAdd_rec.Plant_City__c = managSipAdd_wrapRecd.shippingAddress.city;
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.country))
                                    shipAdd_rec.Plant_Country__c = managSipAdd_wrapRecd.shippingAddress.country; 
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.phone))     
                                    shipAdd_rec.Plant_Phone__c = managSipAdd_wrapRecd.shippingAddress.phone;
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.zip))      
                                    shipAdd_rec.Plant_Postal_Code__c = managSipAdd_wrapRecd.shippingAddress.zip;
                                if(!String.isBlank(managSipAdd_wrapRecd.shippingAddress.state))      
                                    shipAdd_rec.Plant_Province_State__c = managSipAdd_wrapRecd.shippingAddress.state;
                                
                                update shipAdd_rec;
                                shipingAdd_updateList.add(shipAdd_rec);
                                
                                // responseList.add(ordrPropert);
                                tempStatus = 'Success';
                                tempStatusCode='200';
                                tempMsg='Shipping Address updated successfully';
                            }
                            else {
                                tempStatus = 'Success';
                                tempStatusCode='200';
                                tempMsg='Shipping date not available for this address';
                            }
                            
                            
                        }
                        else{
                            tempStatusCode='503';
                            tempStatus='error';
                            tempMsg='Service Unavailable! Shipping address not inserted must be US or Canada';
                        }
                    }
                    else {
                        tempStatus = 'error';
                        tempStatusCode='501';
                        tempMsg='Not Implemented! No Shipping Address found to update';
                    }
                }
                else{
                    // SEND ERROR CART API CAN NOT BE USED FOR ACCOUNT
                    tempStatus = 'error';
                    tempStatusCode='503';
                    tempMsg+='Service Unavailable! Can not update Cart now';
                }
            }
            else{
                tempStatus = 'error';
                tempStatusCode='501';
                tempMsg='Not Implemented! CartId incorrect';
            }
        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: update SA: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            tempStatus = 'error';
            tempStatusCode='500';
            tempMsg='Internal Server Error: '+ex.getMessage();
        }
        
        resp.shippingAddress = shipingAdd_updateList ;
        List<wrapResponse> responseList = new List<wrapResponse>();
        responseList.add(resp);
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(tempStatus,tempStatusCode,tempMsg,new Plant_Utility.responseListWrapper(responseList));
        return responseWrap;
        
    }

    // @desc: add Customer shipping address
    public Plant_Utility.responseWrapper addCustomerAddress(addCustomerAddreeeWrap reqWrp){
        // validate if shipping address id correct
        String status ='';
        String statusCode ='';
        String msg ='';
        String existingCustomerId = '';
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
                    if(Plant_Utility.checkAddress(reqWrp.shippingAddress)){
                            
                        Plant_Shipping_BC.deliveryDateWrapper tempAddrsWrap = new Plant_Shipping_BC.deliveryDateWrapper();
                        tempAddrsWrap.state=reqWrp.shippingAddress.state;
                        tempAddrsWrap.zip=reqWrp.shippingAddress.zip;
                        Plant_Utility.responseWrapper availableDates_List = new Plant_Shipping_BC().getAvailableDeliveryDates(tempAddrsWrap);
                        System.debug('&&&&&&&&# Sub Date check = >'+availableDates_List);
                            
                        if(availableDates_List.status=='success'){
                               
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
                            // INSERT NEW SHIPPING ADDRESS**
                            insert shipAdd_rec;
                            
                            StatusCode='200';
                            Status='Success';
                            msg='Address Added Sucessfully Address Id : '+shipAdd_rec.id;
                        }
                        else{
                            StatusCode='503';
                            Status='error';
                            msg='Service Unavailable! No Delivery Schedule is found for this Address';
                        }                            
                    }
                    else{
                        statusCode='503';
                        status='error';
                        msg+=', Shipping Address Must be from Us or canada';
                    }
                }
            }
            else{
                statusCode='501';
                status='error';
                msg+='Service Unavailable! Incorrect request body';
            }

        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: delete SA: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

    // @desc: add Customer Payment Method
    public Plant_Utility.responseWrapper addCustomerPaymentMethod(addCustomerPaymentWrap reqWrp){
        // validate if shipping address id correct
        String status ='';
        String statusCode ='';
        String msg ='';
        String existingCustomerId = '';
        Plant_Payment_Method__c paymentRec =  new  Plant_Payment_Method__c();
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
                    if(reqWrp.cardInformation!=null){
                        if(reqWrp.cardInformation.expDate!=null || reqWrp.cardInformation.name!=null
                        || reqWrp.cardInformation.cvv!=null || reqWrp.cardInformation.cardnumber!=null
                        || reqWrp.cardInformation.card_Last_4_Digits!=null || reqWrp.cardInformation.card_Type!=null){
                            System.debug('@@@@# prepare card ');
                            if(!String.isBlank(reqWrp.cardInformation.expDate) && Plant_Utility.checkDateFormat(reqWrp.cardInformation.expDate))
                                paymentRec.Plant_Expiration_Date__c = Date.valueOf( reqWrp.cardInformation.expDate );
                            else
                                msg+=', wrong card input: expire date';
                            if(!String.isBlank(reqWrp.cardInformation.name))     
                                paymentRec.Plant_Customer_Name__c = reqWrp.cardInformation.name;
                            else
                                msg+=', wrong card input: card name';
                            if(!String.isBlank(reqWrp.cardInformation.cvv) && Plant_Utility.CheckValidInteger(reqWrp.cardInformation.cvv))
                                paymentRec.CCV__c = reqWrp.cardInformation.cvv.trim();
                            else
                                msg+=', wrong card input: card cvv';
                            
                            if(!String.isBlank(reqWrp.cardInformation.cardnumber) && Plant_Utility.CheckValidInteger(reqWrp.cardInformation.cardnumber))
                                paymentRec.Plant_Card_Number__c = reqWrp.cardInformation.cardnumber;
                            else
                                msg+=', wrong card input: card number';
                                if(!String.isBlank(reqWrp.cardInformation.card_Last_4_Digits) && Plant_Utility.CheckValidInteger(reqWrp.cardInformation.card_Last_4_Digits))
                                paymentRec.Plant_Card_Last_4_Digits__c = reqWrp.cardInformation.card_Last_4_Digits;
                            else
                                msg+=', wrong card input: card last 4 digits';
                                if(!String.isBlank(reqWrp.cardInformation.card_Type))
                                paymentRec.Plant_Card_Type__c = reqWrp.cardInformation.card_Type;
                            else
                                msg+=', wrong card input: card_Type';
                            
                                if(reqWrp.cardInformation.billingAddress!=null){
                                    Plant_Utility.addressCapsule billAdd = (Plant_Utility.addressCapsule)reqWrp.cardInformation.billingAddress;
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
                            paymentRec.Plant_Account__c=existingCustomerId;
                            Database.insert(paymentRec, false);
                            statusCode='200';
                            status='Success';
                            msg+='Card Inserted Successfull Id: '+paymentRec.id;
                        }
                        else{
                            statusCode='501';
                            status='error';
                            msg+='Service Unavailable! Missing required Card Details ';
                        }   
                    }
                    else{
                        statusCode='501';
                        status='error';
                        msg+='Service Unavailable! Missing Card Details';
                    }
                }
            }
            else{
                statusCode='501';
                status='error';
                msg+='Service Unavailable! Incorrect request body';
            }

        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: delete SA: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

    //@desc: add Customer Payment Method
    public Plant_Utility.responseWrapper delCustomerPaymentMethod(Plant_Customer_BC.delCustomerPaymentWrap reqWrp){
        // validate if shipping address id correct
        String status ='';
        String statusCode ='';
        String msg ='';
        String existingCustomerId = '';
        Plant_Payment_Method__c paymentRec =  new  Plant_Payment_Method__c();
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
                    List<Plant_Subscription__c> psubscription = [Select id, name from Plant_Subscription__c where Plant_Payment_Method__c=:reqWrp.paymentMethodId AND Plant_Account__c=:existingCustomerId Limit 49999];
                    List<Plant_Order_Properties__c> odrProperties = [Select id, name from Plant_Order_Properties__c where Plant_Payment_Method__c=:reqWrp.paymentMethodId AND Plant_Account__c=:existingCustomerId Limit 49999];
                    System.debug('@@@@ Payment Delete 1 '+psubscription);
                    System.debug('@@@@ Payment Delete 2 '+odrProperties);
                    if(psubscription.isEmpty() && odrProperties.isEmpty()){
                        List<Plant_Payment_Method__c> paymentMethodDelete=[Select id, name from Plant_Payment_Method__c where id=:reqWrp.paymentMethodId AND Plant_Account__c=:existingCustomerId Limit 49999];
                        if(!paymentMethodDelete.isEmpty()){
                            System.debug('@@@@ Payment Delete 3 ');
                            //Database.delete(paymentMethodDelete, false);
                            delete paymentMethodDelete;
                            System.debug('@@@@ Payment Delete 4 ');
                            statusCode='200';
                            status='Success';
                            msg+='Payment Method Deleted Successfully';
                        }
                        else{
                            statusCode='501';
                            status='error';
                            msg+='No Payment Found for this Account with this Payment Id:';
                            System.debug('@@@@ Payment Delete 5 ');
                        }
                    }
                    else{
                        if(!psubscription.isEmpty()){
                            System.debug('@@@@ Payment Delete 6 ');
                            statusCode='501';
                            status='error';
                            msg+='Service Unavailable! this payment is in use for Subscription ID: '+psubscription[0].id+' ';
                        }
                        if(!odrProperties.isEmpty()){
                            System.debug('@@@@ Payment Delete 7 ');
                            statusCode='501';
                            status='error';
                            msg+='Service Unavailable! this payment is used in order cart ID: '+odrProperties[0].id+' ';
                        }
                        
                    }    
                }
            }
            else{
                System.debug('@@@@ Payment Delete 8 ');
                statusCode='501';
                status='error';
                msg+='Service Unavailable! Incorrect request body';
            }
           
        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: delete SA: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
            System.debug('@@@@ Payment Delete 9 ');
            
        }
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
        
    }
       // Method 4
    // @desc: delete shipping address
    public Plant_Utility.responseWrapper deleteShippingAddress(Plant_Customer_BC.wrapReq_class reqWrp){
        // validate if shipping address id correct
        String status ='';
        String statusCode ='';
        String msg ='';
        String existingCustomerId = '';
        Plant_Payment_Method__c paymentRec =  new  Plant_Payment_Method__c();
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
                    List<Plant_Subscription__c> psubscription = [Select id, name from Plant_Subscription__c where Plant_Shipping_Address__c=:reqWrp.shippingAddressId AND Plant_Account__c=:existingCustomerId Limit 49999];
                    List<Plant_Order_Properties__c> odrProperties = [Select id, name from Plant_Order_Properties__c where Shipping_Address__c=:reqWrp.shippingAddressId AND Plant_Account__c=:existingCustomerId Limit 49999];
                    System.debug('@@@@ ship Delete 1 '+psubscription);
                    System.debug('@@@@ ship Delete 2 '+odrProperties);
                    if(psubscription.isEmpty() && odrProperties.isEmpty()){
                        List<Plant_Shipping_Address__c> shipAddressDelete=[Select id, name from Plant_Shipping_Address__c where id=:reqWrp.shippingAddressId AND Plant_Account__c=:existingCustomerId Limit 49999];
                        if(!shipAddressDelete.isEmpty()){
                            System.debug('@@@@ ship Delete 3 ');
                            //Database.delete(paymentMethodDelete, false);
                            delete shipAddressDelete;
                            System.debug('@@@@ ship Delete 4 ');
                            statusCode='200';
                            status='Success';
                            msg+='Shipping Address Deleted Successfully';
                        }
                        else{
                            statusCode='501';
                            status='error';
                            msg+='No shipping Address Found for this Account with this Shipping Address Id Id:';
                            System.debug('@@@@ Shipping Delete 5 ');
                        }
                    }
                    else{
                        if(!psubscription.isEmpty()){
                            System.debug('@@@@ Shipping Delete 6 ');
                            statusCode='501';
                            status='error';
                            msg+='Service Unavailable! this Shipping Address is in use for Subscription ID: '+psubscription[0].id+' ';
                        }
                        if(!odrProperties.isEmpty()){
                            System.debug('@@@@ Shipping Delete 7 ');
                            statusCode='501';
                            status='error';
                            msg+=', Service Unavailable! this Shipping Address is used in order cart ID: '+odrProperties[0].id+' ';
                        }
                        
                    }    
                }
            }
            else{
                System.debug('@@@@ Shipping Delete 8 ');
                statusCode='501';
                status='error';
                msg+='Service Unavailable! Incorrect request body';
            }
           
        }catch(Exception ex){
            System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD: delete SA: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
            System.debug('@@@@ Shipping Delete 9 ');
            
        }
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;
    }

    // wrapper 1:
    // wrap : customer info req details
    public class AccountInfo_Wrap{
        public String authenticationToken;
        public String firstname;
        public String lastname;
        public String email;
        public String phone;
        
        public AccountInfo_Wrap parse(String sub_Json){
            return (AccountInfo_Wrap)JSON.deserialize(sub_Json, AccountInfo_Wrap.class);
        }
    }
    
    
    // wrap 2 : customer info responce Wrapper
    public class userAuth_ResponseWrap{
        public String Response;
        
        public userAuth_ResponseWrap(String userAuth){
            this.Response = userAuth;
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
    
    // wrap 7
    // to give response of Subscription Information
    public class SubscriptionInfo_Wrap{
        public String status;
        //public String SfOrderNumber;
        public String SubscriptionId;
        public date StartDate;
        public date nextscheduledCharge;
        public date nextShipmentDate;
        public date nextDeliveryDate;
        
    }

    // wrap 7.1
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
        
    }
    
    // wrap 8:
    // desc: Wrapper to create Account
    public class createAccount_Wrap{
        public String firstName;
        public String lastName;
        public String Email;
        public String Phone;
        // public String Password;
        
        //desc:   parse and return wrapper object
        public createAccount_Wrap parse(String json){
            return (createAccount_Wrap)System.JSON.deserialize(json, createAccount_Wrap.class);
        }
    }

    // wrap 8.1:
    // desc: Responce Wrapper to get Account information
    public class accountInfo_RespWrap{
        public String AccountName;
        public String Email;
        public String Phone;
    }
    
    // wrap 8:
    // desc: Responce Wrapper for creating Account
    public class createAccount_Resp{
        public String AccountName;
        public String temporaryPassword;
        public String Account_Id;
        //public String AuthorizationToken;
    }
    
    // wrap 9:
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
    
    // wrap 10:
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
    
    // wrap 10:
    // desc: Wrapper to update subscription meal
    public class voidTransaction_Wrap{
        public String authenticationToken;
        public String subscriptionId;
        
        //desc:   parse and return wrapper object
        public voidTransaction_Wrap parse(String json){
            return (voidTransaction_Wrap)System.JSON.deserialize(json, voidTransaction_Wrap.class);
        }
    }
    
    // wrap 11:
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

    // Wrap 12
    // wrapper to get responce of card
    public class cardUpdateResp{
        public String cOrderId;
        public String subscriptionId;
        public String paymentId;
        //public String orderPropId;
    }

    // wrapper 13: (# new)
    // wrap Account: payment methods
    public class PaymtDtlWrap{
        public String AccountId; 
        public String authenticationToken; 
        public List<paymentInfo> paymentMethods_List;
    }

    // wrapper 12.1: (# new)
    public class paymentInfo{
        Public String paymentId;
        public cardWrapper cardInformation;
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
    }
    
    // wrapper 5.1: (# new)
    // wrap Account: Shipping Address
    public class ShippngAddressDtl{
        public String shippingAddressId;
        public Plant_Utility.addressCapsule shippingAddress;
    }

    // wrapper 5: (# new)
    // wrap Account: Shipping Address response wrapper
    public class ShippngAddressDtlWrap{
        public String AccountId;
        // public List<Plant_Utility.addressCapsule> shippingAddress_List;
        public List<ShippngAddressDtl> shippingAddress_List;
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

    // @ Wrapper class : 2
    public class addCustomerAddreeeWrap{
        public String authenticationToken;
        public Plant_Utility.addressCapsule shippingAddress;
        
        //w desc:   parse and return wrapper object
        public addCustomerAddreeeWrap parse(String json){
            return (addCustomerAddreeeWrap)System.JSON.deserialize(json, addCustomerAddreeeWrap.class);
        }
    }

    // @wrapper class : 4
    public class wrapResponse{
        public String cartId;
        public List<Object> shippingAddress;
    }

    // @ Wrapper class : 3
    public class wrapReq_class{
        // public String cartId;
        public String shippingAddressId;
        public String authenticationToken;
        
        public wrapReq_class parse(String json){
            return (wrapReq_class)System.JSON.deserialize(json, wrapReq_class.class);
        }
    }

    // wrap 8:
    // desc: Wrapper to create Account Payment Method
    public class addCustomerPaymentWrap{
        public String authenticationToken;
        public Plant_Orders_BC.cardWrapper cardInformation;
        
        //desc:   parse and return wrapper object
        public addCustomerPaymentWrap parse(String json){
            return (addCustomerPaymentWrap)System.JSON.deserialize(json, addCustomerPaymentWrap.class);
        }
    }

    // wrap 8:
    // desc: Wrapper to delete Account Payment Method
    public class delCustomerPaymentWrap{
        public String authenticationToken;
        public String paymentMethodId;
        
        //desc:   parse and return wrapper object
        public delCustomerPaymentWrap parse(String json){
            return (delCustomerPaymentWrap)System.JSON.deserialize(json, delCustomerPaymentWrap.class);
        }
    }

    // methhod 2:
    // check coming day(on same week or next week) and get date
    public static date nextDayDate(String optedDay){
        optedDay=optedDay.toLowerCase();
        optedDay=optedDay.Capitalize();
        Date todayDate = Date.today();
        Date weekStartDate = todayDate.toStartOfWeek();// sunday
        
        // get sunday of week
        DateTime todayDat = (DateTime)todayDate;
        String paymentDay = todayDat.format('EEEE');
        
        
        if(paymentDay==optedDay){
            return todayDate.addDays(7);
        }
        else{
            Date thisWeekDay = getWeekDateByDay(optedDay, weekStartDate);
            if(todayDate <= thisWeekDay){
                // selected day in this week future 
                return thisWeekDay;
            }
            else{
                // selected day in this week past
                return thisWeekDay.addDays(7);
            }
        }
    }
    
    // method 2.1
    public static date getWeekDateByDay(String dayname, Date weekStartDaye){
        switch on dayname {
            when 'Monday' {		
                return weekStartDaye.addDays(1);
            }	
            when 'Tuesday' {		
                return weekStartDaye.addDays(2);
            }
            when 'Wednesday' {		
                return weekStartDaye.addDays(3);
            }	
            when 'Thursday' {		
                return weekStartDaye.addDays(4);
            }	
            when 'Friday' {		
                return weekStartDaye.addDays(5);
            }	
            when 'Saturday' {		
                return weekStartDaye.addDays(6);
            }	
            when 'Sunday' {		
                return weekStartDaye;
            }		
        }
        return weekStartDaye;
    }
}