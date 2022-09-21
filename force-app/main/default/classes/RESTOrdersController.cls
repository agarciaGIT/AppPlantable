@RestResource(urlMapping='/orders/*')
global class RESTOrdersController {
    
    public class processOrderRet {
        API_Request__c apiReq;
        List<API_Request_Line_Item__c> lstApiLines;
        respPOSTOrder rpo;
    }
    
    public class respShipItem {
        String shipping_status;
        String tracking_number;
        Date shipping_date;
        Date delivery_date;        
    }
        
    public class respGETOrder {
        Integer status_code;
        String order_status;
        List<respShipItem> shipments;
    }
    
    public class reqOrderAddress {
        String company;
        String address1;
        String address2;
        String address3;
        String city;
        String state;
        String zip;
        String country;
    }
    
    public class reqOrderItem {
        String type;
        String name;
        String code;
        Integer quantity;
        Decimal price;
    }

    public class reqOrderChargeItem {
        String gateway_token;
        Integer gateway_datetime;
        Decimal amount_charged;
        Decimal user_amount;
        Integer charge_later;
        String source;
        String charge_req;
        String charge_resp;
    }
    
    public class reqOrder {
        String id;
        String order_source;
        String product;
        String provider;
        String order_number;
        String first_name;
        String last_name;
        String email;
        String phone;
        String ship_date;
        String shipping_instructions;
        String financial_status;
        reqOrderAddress billing_address;
        reqOrderAddress shipping_address;
        List<reqOrderItem> items;
        reqOrderChargeItem charge;
    }

    public class respPreOrder {
        Integer status_code;
        String status_message;     
        String order_source;
        String product;        
        String provider;
        String order_number;
        String first_name;
        String last_name;
        String email;
        String phone;
        String shipping_instructions;
        reqOrderAddress billing_address;
        reqOrderAddress shipping_address;
        List<reqOrderItem> items;
        List<String> shipingDates;
    }

    
    public class respPOSTOrder {
        Integer status_code;
        String status_message;
        String id;
    }

    public class reqPUTOrder {
        String order_status;
    }
    
    public class StripeError {
        String code;
        String message;
    }
    
    public class stripeChargeResp {
        String id;
        Long createddate;
        String description;
        String status;
        StripeError error;
    }
    
    //public static String safeSetString(String inStr, String strOpt) {
    //    if(inStr != null) {
    //        return inStr;
    //    } else if(strOpt != NULL) {
    //        return strOpt;
    //    }
    //    else return '';
    //}
    
    
    public static void processAPIOrder(String rawJson) {
        String OrderId;
        try {
            API_Request__c apiReq = new API_Request__c();
            apiReq.Raw_Request__c = rawJson;
            
            // Get Affiliate Info
            apiReq = shopifyClass.checkAffiliateOrder(rawJson, apiReq);
            System.debug('checkAffiliate apiReq:' + apiReq );
            
            
            insert apiReq;
            shopifyClass.returnItems ri = shopifyClass.setOrder(apiReq, rawJson, null);
            OrderId = ri.apiReq.OrderId__c;
            
            ri.apiReq.Request_Key__c = ri.apiReq.Request_Type__c + '~' + ri.apiReq.OrderId__c;

            update ri.apiReq;
            system.debug('returnItems' + ri);     
            shopifyClass.processAPIRequest(ri,false);            
        } catch (Exception e) {
            App_Error__c err = new App_Error__c();
            err.Name = OrderId;
            err.Details__c = e.getMessage();
            insert err;
        }             
    }
    
    public static void processOrderError(RestRequest req, String expMsg) {
        API_Request__c apiReq = new API_Request__c();
        String rawJson = req.requestBody.toString();
        apiReq.Response__c = expMsg;
        if(rawJson != null)
            apiReq.Raw_Request__c = rawJson;
        insert apiReq;    
    }
    
    public static respGETOrder processGETRequest(RestRequest req) {
        respGETOrder ro = new respGETOrder();
        ro.status_code = 404;
        
        String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(id != null) {
            List<Opportunity> lstOpp = [select Id, StageName from Opportunity where External_Order_Number__c = :id];
            if(lstOpp != null && lstOpp.size() > 0) {
                ro.status_code = 0;
                if(lstOpp[0].StageName == 'Closed') {
                    ro.order_status = 'Completed';    
                } else if(lstOpp[0].StageName == 'Closed Lost') {
                    ro.order_status = 'Cancelled'; 
                } else {
                    ro.order_status = 'Pending'; 
                }
                ro.shipments = new List<respShipItem>();
                
                List<Shipment__c> lstShips = [select Id, Status__c, Scheduled_Date__c, Delivery_Date__c, Tracking_Number__c from Shipment__c where Opportunity__c = :lstOpp[0].Id];
                if(lstShips != null && lstShips.size() > 0) {
                    for(Shipment__c ls :lstShips) {
                        respShipItem rsi = new respShipItem();
                        rsi.shipping_status = ls.Status__c;
                        rsi.shipping_date = ls.Scheduled_Date__c;
                        rsi.delivery_date = ls.Delivery_Date__c;
                        rsi.tracking_number = RESTAuthController.getBlankValue(ls.Tracking_Number__c);
                        ro.shipments.add(rsi);
                    }
                }
                
            }
        }
        return ro;
    }
    
    public static respPreOrder preprocessPOSTRequest(RestRequest req, String clientId) {
        respPreOrder rpo = new respPreOrder();
        rpo.status_code = 0;
        
        String rawJson = req.requestBody.toString();
        rpo = (respPreOrder)JSON.deserialize(rawJson, respPreOrder.class);
        
        // Get Alternate Shipping Date
        List<Alternate_Shipping_Days__c> altDays = Alternate_Shipping_Days__c.getall().values();
        map<Date,Date> ampAltDays = new map<Date,Date>();
        for(Alternate_Shipping_Days__c altd :altDays) {
            ampAltDays.put(altd.Alt_Ship_Date__c, altd.Ship_Date__c);
        }

        // Get Black Out Shipping Dates              
        List<Black_Out_API_Shipping_Dates__c> blackDays = Black_Out_API_Shipping_Dates__c.getall().values();
        map<Date,Date> mapBackDays = new map<Date,Date>();
        for(Black_Out_API_Shipping_Dates__c btd :blackDays) {
            mapBackDays.put(btd.Ship_Date__c, btd.Ship_Date__c);
        }

        // Compute Upcoming Mondays
        rpo.shipingDates = shopifyClass.computeUpcomingMondays(rpo.product);
        
        // Set Default
        Decimal shippingPrice = 10;
        if(rpo.product == 'sampler') {
            shippingPrice = 0;
        }  
        
        system.debug('rpo: ' + rpo);
        if(rpo.items != null && rpo.items.size() > 0) {
            
            if(rpo.email == null || rpo.phone == null || rpo.first_name == null ||
               rpo.last_name == null) {
                   rpo = new respPreOrder();
                   rpo.status_code = 501;
                   rpo.status_message = 'Contact information is not complete';                   
            
            } else if(rpo.billing_address == null || rpo.billing_address.address1 == null || rpo.billing_address.city == null ||
               rpo.billing_address.state == null || rpo.billing_address.zip == null) {
                   rpo = new respPreOrder();
                   rpo.status_code = 502;
                   rpo.status_message = 'Not a valid billing address';                   
                   
            } else if(rpo.shipping_address != null && rpo.shipping_address.address1 != null && rpo.shipping_address.city != null &&
               rpo.shipping_address.state != null && rpo.shipping_address.zip != null) {
                
                   String zip = rpo.shipping_address.zip;
                   if(zip.length() > 5) {
                       zip = zip.substring(0,5);
                   }
                   System.debug('zip:' + zip);
                   
                   List<UPS_Zip_Codes__c> listCodes = [select id, Price__c, Zip__c, State__c, State_Code__c, Shipping_Service_Type__c from UPS_Zip_Codes__c where Zip__c = :zip AND State__c = NULL AND State_Code__c = NULL];
                   system.debug('listCodes: ' +listCodes);   
                                      
                   if(listCodes == null || listCodes.size() == 0) {
                       listCodes = [select id, Price__c, Zip__c, State__c, State_Code__c, Shipping_Service_Type__c from UPS_Zip_Codes__c where Zip__c = :zip AND (State__c = :rpo.shipping_address.state OR State_Code__c =:rpo.shipping_address.state)];
                   }
                   
                   if(listCodes == null || listCodes.size() == 0) {
                       listCodes = [select id, Price__c, Zip__c, State__c, State_Code__c, Shipping_Service_Type__c from UPS_Zip_Codes__c where Zip__c = 'All' AND (State__c = :rpo.shipping_address.state OR State_Code__c =:rpo.shipping_address.state)];
                   }
                   
                   if(listCodes != null && listCodes.size() > 0) {
                       
                       reqOrderItem roiShip = new reqOrderItem();
                       roiShip.type = 'Shipping';
                       roiShip.name = listCodes[0].Shipping_Service_Type__c;
                       roiShip.code = 'EShip';
                       roiShip.quantity = 1;
                       roiShip.price = shippingPrice;
                       rpo.items.add(roiShip);
                       
                       if(rpo.product == 'sampler') {
                           roiShip.name = '2 Day Ground';
                       }
                       
                       //if(listCodes[0].Shipping_Service_Type__c == 'Brooklyn Courier' || listCodes[0].Shipping_Service_Type__c == 'Manhattan Courier') {
                       //    roiShip = new reqOrderItem();
                       //    roiShip.type = 'Shipping';
                       //    roiShip.name = '1 Day Ground';
                       //    roiShip.code = 'EShip';
                       //    roiShip.quantity = 1;
                       //    roiShip.price = 15.00;
                       //    rpo.items.add(roiShip);
                       //}
                       
                       reqOrderItem roiTax = new reqOrderItem();
                       roiTax.type = 'Tax';
                       roiTax.name = 'Tax';
                       roiTax.code = 'ETAX';
                       roiTax.quantity = 1;
                       roiTax.price = 0;
                       rpo.items.add(roiTax);
                       
                       rpo.status_code = 0;
                       rpo.status_message = '';
                       
                   } else {
                       rpo = new respPreOrder();
                       rpo.status_code = 503;
                       rpo.status_message = 'Shipping service not found for address given';
                   }
                   
               } else {
                   rpo = new respPreOrder();
                   rpo.status_code = 504;
                   rpo.status_message = 'Not a valid shipping address';
               }
            
                if(rpo.status_code == 0) {
                    
                    // Fetch Product, Prices and Meals
                    String ZPProd = 'ZPEALC';        
                    if(rpo.product == 'sampler') {
                        ZPProd = 'ZPSAM'; 
                    }
                    List<Product2> lstProd = [select Id, Name, Minimum_Meals__c from Product2 where ProductCode = :ZPProd];                    
                    System.debug('lstProd:' + lstProd);
                    
                    List<PricebookEntry> lstPbe = [Select  Id, Name, Unitprice, Product2Id From PricebookEntry Where Product2Id in :lstProd];
                    
                    System.debug('lstPbe:' + lstPbe);
                    
                    MAP<String, Decimal> mapPrice = new MAP<String, Decimal>();
                    for(PricebookEntry pbe :lstPbe) {
                        mapPrice.put(pbe.Product2Id, pbe.UnitPrice);
                    }
                    System.debug('mapPrice:' + mapPrice);
                    
                    Integer minMeals = 14;
                    Decimal totalPrice = 250;
                    if(lstProd != NULL && lstProd.size() > 0) {
                        Product2 prod = lstProd[0];
                        totalPrice = mapPrice.get(prod.Id);
                        if(prod.Minimum_Meals__c != NULL) {
                            minMeals = Integer.ValueOf(prod.Minimum_Meals__c);
                        }
                    } else {
                        rpo = new respPreOrder();
                        rpo.status_code = 511;
                        rpo.status_message = 'Invalid Product Configuration';
                    }
                                        
                    List<Meal__c> lstMeal;
                    if(rpo.product == 'sampler') {
                        lstMeal = [select Id, Name, Inventory__c, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND Zipongo_Sampler__c = True];                        
                    } else {
                        lstMeal = [select Id, Name, Inventory__c, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND API_Enabled__c = True];                        
                    }
                    System.debug('lstMeal:' + lstMeal);
                    
                    MAP<String, Meal__c> mapMeal = new MAP<String, Meal__c>();
                    for(Meal__c m :lstMeal) {
                        mapMeal.put(m.Shopify_ID__c, m);
                    }            
                    
                    // Check Products
                    if(rpo.status_code == 0) {
                        Integer prodCnt=0;
                        
                        for(reqOrderItem roi :rpo.items) {
                            
                            if(roi.type == 'Meal' && rpo.status_code == 0 && rpo.product != 'sampler') {
                                // rpiMeal.code = fndMeal.Shopify_ID__c;
                                if(roi.code != NULL && roi.quantity != NULL && roi.price != NULL) {
                                    
                                    system.debug('roi.code:' + roi.code);
                                    
                                    Meal__c fndMeal = mapMeal.get(roi.code);
                                    system.debug('Find Price fndMeal:' + fndMeal);
                                    
                                    if(fndMeal == NULL) {
                                        rpo = new respPreOrder();
                                        rpo.status_code = 505;
                                        rpo.status_message = 'Invalid product code : ' + roi.code;
                                    } else {
                                        // Check Price
                                        system.debug('Find Price price:' + totalPrice);
                                            
                                        Decimal price = totalPrice / minMeals;
                                        price = price.setScale(2);
                                        system.debug('Find Price prep price:' + price);
                                        
                                        if(roi.price != price) {
                                            rpo = new respPreOrder();
                                            rpo.status_code = 506;
                                            rpo.status_message = 'Invalid price for product code : ' + roi.code;
                                        }
                                        
                                        if(rpo.status_code == 0)  {
                                            if(fndMeal.Inventory__c < roi.quantity) {
                                                rpo = new respPreOrder();
                                                rpo.status_code = 507;
                                                rpo.status_message = 'Product is out of stock : ' + roi.code;
                                            }
                                        }                                                                                
                                    }
                                    prodCnt+=roi.quantity;
                                } else {
                                    rpo = new respPreOrder();
                                    rpo.status_code = 509;
                                    rpo.status_message = 'Invalid Product item';
                                }
                            } else if(roi.type != 'Meal' && roi.type != 'Shipping' && roi.type != 'Tax' && rpo.status_code == 0) {
                                
                                rpo = new respPreOrder();
                                rpo.status_code = 517;
                                rpo.status_message = 'Invalid item type';     
                            }
                        }
                        if(rpo.status_code == 0 && (Math.mod(prodCnt,minMeals) != 0 || prodCnt == 0) && rpo.product != 'sampler') {
                            rpo = new respPreOrder();
                            rpo.status_code = 510;
                            rpo.status_message = 'Invalid number of products';
                        }
                    }
                }

        } else if(rpo.product != 'sampler') {
            rpo = new respPreOrder();
            rpo.status_code = 518;
            rpo.status_message = 'No Items to process';
        }
        
        return rpo;
    }
    
    public static processOrderRet processPOSTRequest(reqOrder ro, String rawJson, String clientId) {
        
        processOrderRet procOrderResp = new processOrderRet();
        procOrderResp.apiReq = new API_Request__c();
        procOrderResp.lstApiLines = new List<API_Request_Line_Item__c>();
        procOrderResp.rpo = new respPOSTOrder();
        
        // Insert Line Items
        List<API_Request_Line_Item__c> lstApiLines = new List<API_Request_Line_Item__c>();
        API_Request__c apiReq = new API_Request__c();

        respPOSTOrder rpo = new respPOSTOrder();
        rpo.status_code = 0;
        rpo.status_message = '';
        
        //String rawJson = req.requestBody.toString();
        //reqOrder ro = (reqOrder)JSON.deserialize(rawJson, reqOrder.class);
        if(ro.email != null && ro.first_name != null && ro.last_name != null && ro.phone != null && ro.billing_address != null &&
          ro.billing_address.address1 != null && ro.billing_address.city != null && ro.billing_address.state != null && ro.billing_address.zip != null && ro.shipping_address != null &&
          ro.shipping_address.address1 != null && ro.shipping_address.city != null && ro.shipping_address.state != null && ro.shipping_address.zip != null &&
          ro.items != null && ro.items.size() > 0 
           
           //&& ro.charge != NULL && ro.charge.gateway_token != null && ro.charge.gateway_datetime != null && ro.charge.amount_charged != null && ro.charge.source != null &&
          //ro.charge.charge_req != NULL && ro.charge.charge_resp != NULL           
          ) {

              // Fetch Product, Prices and Meals
              String ZPProd = 'ZPEALC';        
              if(ro.product == 'sampler') {
                  ZPProd = 'ZPSAM';
              }              
              List<Product2> lstProd = [select Id, Name, Minimum_Meals__c, Shopify_Product_Id__c from Product2 where ProductCode = :ZPProd];                    
              System.debug('lstProd:' + lstProd);
              
              List<PricebookEntry> lstPbe = [Select  Id, Name, Unitprice, Product2Id From PricebookEntry Where Product2Id in :lstProd];
              
              System.debug('lstPbe:' + lstPbe);
              
              MAP<String, Decimal> mapPrice = new MAP<String, Decimal>();
              for(PricebookEntry pbe :lstPbe) {
                  mapPrice.put(pbe.Product2Id, pbe.UnitPrice);
              }
              System.debug('mapPrice:' + mapPrice);
              
              Integer minMeals = 14;
              Decimal totalPrice = 250;
              Decimal shippingPrice = 10;
              if(ro.product == 'sampler') {
                  shippingPrice = 0;
              }              
              Product2 alaProd = null;
              
              if(lstProd != NULL && lstProd.size() > 0) {
                  alaProd = lstProd[0];
                  totalPrice = mapPrice.get(alaProd.Id);
                  if(alaProd.Minimum_Meals__c != NULL) {
                      minMeals = Integer.ValueOf(alaProd.Minimum_Meals__c);
                  }
              } else {
                  rpo = new respPOSTOrder();
                  rpo.status_code = 511;
                  rpo.status_message = 'Invalid Product Configuration';
              }
              
              List<Meal__c> lstMeal;
              if(ro.product == 'sampler') {
                  lstMeal = [select Id, Name, Inventory__c, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND Zipongo_Sampler__c = True];                        
              } else {
                  lstMeal = [select Id, Name, Inventory__c, Shopify_ID__c, Allergens__c, Calories_Per_Serving__c, Cuisine__c, Description__c, Image_URL__c, Proteins__c, Type__c from Meal__c where Status__c = 'Active' AND API_Enabled__c = True];                        
              }
              
              System.debug('lstMeal:' + lstMeal);
              
              MAP<String, Meal__c> mapMeal = new MAP<String, Meal__c>();
              for(Meal__c m :lstMeal) {
                  mapMeal.put(m.Shopify_ID__c, m);
              }            
              
              // Compute Upcoming Mondays
              List<String> mondayDates = shopifyClass.computeUpcomingMondays(ro.product);
              
              MAP<String,Boolean> mondays = new MAP<String,Boolean>();
              for(String md :mondayDates) {
                  mondays.put(md, True);
              }
              
              apiReq.Request_Type__c = 'Create Order';
              apiReq.Created_At__c = system.now();
              apiReq.Provider_Id__c = clientId;
              apiReq.Order_source__c = ro.order_source;
              
              //system.assert(false, 'BOOM!:'+ ro.order_number + ':');
              
              if(ro.order_number != NULL && ro.order_number != 'null') {
                apiReq.Order_Number__c = ro.order_number;  
              }
                
              if(ro.ship_date != NULL) {
                apiReq.Ship_Date__c  = Date.parse(ro.ship_date);  
              }
              
              apiReq.Billing_City__c = ro.billing_address.city;
              apiReq.Billing_Company__c = ro.billing_address.company;
              apiReq.Billing_Country__c = ro.billing_address.country;
              apiReq.Billing_First_Name__c = ro.first_name;
              apiReq.Billing_Last_Name__c = ro.last_name;
              apiReq.Billing_Phone__c = ro.phone;
              apiReq.Billing_State__c = ro.billing_address.state;
              apiReq.Billing_Street1__c = ro.billing_address.address1;
              apiReq.Billing_Street2__c = ro.billing_address.address2;
              apiReq.Billing_Zip__c = ro.billing_address.zip;
              
              apiReq.City__c = ro.shipping_address.city;
              apiReq.Company__c = ro.shipping_address.company;
              apiReq.Country__c = ro.shipping_address.country;
              
              apiReq.Customer_Email__c = ro.email;
              apiReq.First_Name__c = ro.first_name;
              apiReq.Last_Name__c = ro.last_name;
              apiReq.Phone__c = ro.phone;
              apiReq.State__c = ro.shipping_address.state;
              apiReq.Street1__c = ro.shipping_address.address1;
              apiReq.Street2__c = ro.shipping_address.address2;

              String zip = ro.shipping_address.zip;
              if(zip.length() > 5) {
                  zip = zip.substring(0,5);
              }
              System.debug('zip:' + zip);

              apiReq.Zip__c = zip;
              
              apiReq.Shipping_City__c = ro.shipping_address.city;
              apiReq.Shipping_Company__c = ro.shipping_address.company;
              apiReq.Shipping_Country__c = ro.shipping_address.country;
              apiReq.Shipping_First_Name__c = ro.first_name;
              apiReq.Shipping_Last_Name__c = ro.last_name;
              apiReq.Shipping_Phone__c = ro.phone;
              apiReq.Shipping_State__c = ro.shipping_address.state;
              apiReq.Shipping_Street1__c = ro.shipping_address.address1;
              apiReq.Shipping_Street2__c =  ro.shipping_address.address2;
             
              apiReq.Shipping_Zip__c = zip;
              
              apiReq.Shipping_Instructions_long__c = ro.shipping_instructions;
                  
              apiReq.Raw_Request__c = rawJson;
              
              // Add Charge Info
              //apiReq.Charge_Amount__c = ro.charge.amount_charged;
              //apiReq.User_Amount__c = ro.charge.user_amount;
              
              // Convert ephoc
              //Datetime createdDate = Datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
              //createdDate = createdDate.addSeconds(ro.charge.gateway_datetime);
              //System.debug('DateTime: ' + createdDate);
              
              //apiReq.Charge_Token_Creation_Date_Time__c = createdDate;
              //apiReq.Charge_Token__c = ro.charge.gateway_token;
              //apiReq.Charge_Source__c = ro.charge.source;
              
              //apiReq.Charge_Request_Body__c = ro.charge.charge_req;
              //apiReq.Charge_Response_Body__c = ro.charge.charge_resp;
              
              // Use the API Request ID as the Order Number
              if(ro.order_number != NULL) {
                  rpo.id = ro.order_number;  
              }
              
              // Valid Shipping Types
              MAP<String,Boolean> mapShippingTypes = new MAP<String,Boolean>();
              mapShippingTypes.put('2 Day Air', TRUE);
              mapShippingTypes.put('1 Day Ground', TRUE);
              mapShippingTypes.put('2 Day Ground', TRUE);
              mapShippingTypes.put('Brooklyn Courier', TRUE);
              mapShippingTypes.put('Manhattan Courier', TRUE);
              
              List<UPS_Zip_Codes__c> listCodes = [select id, Price__c, Zip__c, State__c, State_Code__c, Shipping_Service_Type__c from UPS_Zip_Codes__c where Zip__c = :zip AND State__c = NULL AND State_Code__c = NULL];
              system.debug('listCodes: ' +listCodes);    
              if(listCodes == null || listCodes.size() == 0) {
                  listCodes = [select id, Price__c, Zip__c, State__c, State_Code__c, Shipping_Service_Type__c from UPS_Zip_Codes__c where Zip__c = :zip AND (State__c = :ro.shipping_address.state OR State_Code__c =:ro.shipping_address.state)];
              }
              if(listCodes == null || listCodes.size() == 0) {
                  listCodes = [select id, Price__c, Zip__c, State__c, State_Code__c, Shipping_Service_Type__c from UPS_Zip_Codes__c where Zip__c = 'ALL' AND (State__c = :ro.shipping_address.state OR State_Code__c =:ro.shipping_address.state)];
              }
              
              if(listCodes == null || listCodes.size() == 0) {
                  rpo.status_code = 503;
                  rpo.status_message = 'Shipping service not found for address given';
              }

              System.debug('processPOSTRequest precheck RPO: ' + rpo);

              if(ro.ship_date != NULL) {
                  Boolean fndShipDate = mondays.get(ro.ship_date);
                  if(fndShipDate == NULL) {
                      rpo.status_code = 512;
                      rpo.status_message = 'Invalid Shipping Date: ' + ro.ship_date;
                  }
              }
              
              
              if(rpo.status_code == 0) {
                                    
                  // Add A-la-Cart Product
                  if(alaProd != null) {
                      
                      API_Request_Line_Item__c ala = new API_Request_Line_Item__c();
                      //ala.API_Request__c = apiReq.Id;
                      ala.Name = alaProd.Name;
                      ala.Amount__c = totalPrice;
                      ala.Code__c = ZPProd;
                      ala.Quantity__c = 1;
                      ala.Type__c ='Product';
                      
                      if(ro.ship_date != NULL) {
                          ala.Ship_Date__c  = Date.parse(ro.ship_date);  
                      }
                      
                      lstApiLines.add(ala);
                      
                      Boolean hasTax=false;
                      Boolean hasShipping=false;
                      Integer prodCnt=0;
                      for(reqOrderItem roi :ro.items) {
                          
                          System.debug('roi: ' + roi);
                          
                          API_Request_Line_Item__c arli = new API_Request_Line_Item__c();
                          
                          arli.API_Request__c = apiReq.Id;
                          arli.Name = roi.name;
                          arli.Amount__c = roi.price;
                          arli.Code__c = roi.code;
                          arli.Quantity__c = 1;
                          
                          if(roi.type.toLowerCase() == 'meal' && ro.product != 'sampler') {
                              
                              if(roi.code != NULL) {
                                  
                                  system.debug('roi.code:' + roi.code);
                                  
                                  Meal__c fndMeal = mapMeal.get(roi.code);
                                  system.debug('Find Price fndMeal:' + fndMeal);
                                  
                                  if(fndMeal == NULL) {
                                      rpo.status_code = 505;
                                      rpo.status_message = 'Invalid product code : ' + roi.code;
                                  } else {

                                      // Check Price
                                      system.debug('Find Price price:' + totalPrice);
                                      
                                      Decimal price = totalPrice / minMeals;
                                      price = price.setScale(2);
                                      system.debug('Find Price prep price:' + price);
                                                      
                                      if(roi.price != price) {
                                          rpo.status_code = 506;
                                          rpo.status_message = 'Invalid price for product code : ' + roi.code;
                                      } else {
                                          // Check Inventory
                                          if(fndMeal.Inventory__c != NULL) {
                                              if(fndMeal.Inventory__c < roi.quantity) {
                                                  rpo.status_code = 507;
                                                  rpo.status_message = 'Product is out of stock : ' + roi.code;
                                              }
                                          } else {
                                              rpo.status_code = 508;
                                              rpo.status_message = 'Invalid Product Inventory';
                                          }
                                      }
                                  }
                              } else {
                                  rpo.status_code = 505;
                                  rpo.status_message = 'Invalid product code';
                              }
                              
                              arli.Quantity__c = roi.quantity;
                              arli.Type__c ='Meal';
                              arli.External_Id__c = roi.code;
                              prodCnt+=roi.quantity;
                              
                          } else if(roi.type.toLowerCase() == 'tax') {
                              arli.Type__c ='Tax';
                              hasTax=True;
                          } else if(roi.type.toLowerCase() == 'shipping') {
                              arli.Type__c ='Shipping';
                              hasShipping=True;
                              
                              Boolean fndShipType = mapShippingTypes.get(roi.name);
                              if(fndShipType == NULL) {
                                  rpo.status_code = 512;
                                  rpo.status_message = 'Invalid Shipping Type';
                              } else if(roi.price != shippingPrice) {
                                  rpo.status_code = 513;
                                  rpo.status_message = 'Shipping price given not correct';                              
                              }
                              
                          } else if(roi.type.toLowerCase() == 'discount') {
                              arli.Type__c ='Discount';
                          } else if(ro.product != 'sampler') {
                              rpo.status_code = 517;
                              rpo.status_message = 'Invalid item type';     
                              
                              //system.assert(false, 'BOOM!'+ roi  + ':');
                              
                          }
                          if(roi.type.toLowerCase() == 'meal' && ro.product == 'sampler') {
                          } else {
                            lstApiLines.add(arli);
                          }
                      }
                      
                      if(hasShipping == False) {
                          rpo.status_code = 514;
                          rpo.status_message = 'Shipping is missing';                              
                      } else if(hasTax == False) {
                          rpo.status_code = 515;
                          rpo.status_message = 'Tax is missing';                              
                      } else if((Math.mod(prodCnt,minMeals) != 0 || prodCnt == 0) && ro.product != 'sampler') {
                          rpo.status_code = 510;
                          rpo.status_message = 'Invalid number of products';                                                        
                      }
                      System.debug('processPOSTRequest check RPO: ' + rpo);
                      
                      // If no errors were found
                      /*
                      if(rpo.status_code == 0) {
                          
                          insert apiReq;
                          LIST<API_Request__c> lstAPIRequest = [select Id, Auto_Order_Number__c from API_Request__c where ID = :apiReq.Id];
                          if(lstAPIRequest != NULL && lstAPIRequest.size() > 0) {
                              
                              for(API_Request_Line_Item__c al :lstApiLines) {
                                  al.API_Request__c = apiReq.Id;
                              }
                              
                              insert lstApiLines;
                              
                              // Fire Automation
                              apiReq.Is_Custom__c = true;
                              apiReq.Enable_Automation__c = true;
                              apiReq.OrderId__c = apiReq.Id;
                              
                              if(ro.order_number == NULL || ro.order_number == 'null') {
                                  apiReq.Order_Number__c = lstAPIRequest[0].Auto_Order_Number__c;  
                                  rpo.id = lstAPIRequest[0].Auto_Order_Number__c;
                              }                          
                              
                              //system.assert(false, 'BOOM!'+ rpo.id  + ':');
                              
                              update apiReq;
                              rpo.status_code = 0;
                              
                              //DateTime now = DateTime.now();
                              //Database.executebatch(new batchCompleteProviderOrders(now,apiReq.Id));
                          } else {
                              rpo.status_code = 513;
                              rpo.status_message = 'Error Processing Order : 1';
                          }
                      }
                        */
                      
                  } else {
                      
                      rpo.status_code = 519;
                      rpo.status_message = 'Invalid Product item';
                  }
              }
        } else {
            rpo.status_code = 516;
            rpo.status_message = 'Missing required fields';
            System.debug('ro: ' + ro);
        }
        
        System.debug('processPOSTRequest Return RPO: ' + rpo);
        procOrderResp.rpo = rpo;
        procOrderResp.apiReq = apiReq;
        procOrderResp.lstApiLines = lstApiLines;
        return procOrderResp;
    }
    
    public static respPOSTOrder processPUTRequest(RestRequest req) {
        respPOSTOrder rpo = new respPOSTOrder();
        rpo.status_code = 500;
        rpo.status_message = '';
        
        String rawJson = req.requestBody.toString();
        reqPUTOrder rto = (reqPUTOrder)JSON.deserialize(rawJson, reqPUTOrder.class);
        if(rto.order_status != NULL && rto.order_status == 'cancelled') {
            String id = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            if(id != null) {
                List<Opportunity> lstOpp = [select Id, StageName from Opportunity where External_Order_Number__c = :id];
                if(lstOpp != null && lstOpp.size() > 0) {
                    lstOpp[0].StageName = 'Closed Lost';
                    update lstOpp;
                    rpo.status_code = 0;
                }
            }
        } else {
            rpo.status_code = 400;
            rpo.status_message = 'Missing required fields';            
        }
        
        return rpo;
    }
    
    @future(callout=true)
    public static void chargeStripe(String chargeID) {
        List<Charge__c> lstCharge = [select Id, Name, Amount__c, Gateway_Token__c, Gateway_Date_Time__c, Opportunity__c, Source__c from Charge__c where Id = :chargeID];
        if(lstCharge != NULL && lstCharge.size() > 0) {
            Charge__c charge = lstCharge[0];
            
            Http httpProtocol = new Http();
            HttpRequest request = new HttpRequest();
            String endpoint = 'https://api.stripe.com/v1/charges';
            
            // Amount is in cents
            Integer amt = Integer.valueOf(charge.Amount__c * 100);
            String cur = 'currency';
            String body = 'amount=' + String.valueOf(amt) + '&source=' + charge.Gateway_Token__c + '&description=' + charge.Id + '&' + cur + '=usd&statement_descriptor=Euphebe Order';
            
            system.debug('body:' + body);
            
            String username = 'sk_test_QofE12BN3so9Nu4EpHmPCTe3';
            //String username = 'sk_live_lFDTLfKCoGEdSZsanCKnwfcj';
            
            List<Stripe_Settings__c> stripeSettings = Stripe_Settings__c.getall().values();
            if(stripeSettings != null && stripeSettings.size() > 0) {
                username = stripeSettings[0].Key__c;
            }
            system.debug('username:' + username);
            
            String password = '';
            Blob headerValue = Blob.valueOf(username + ':' + password);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            request.setHeader('Authorization', authorizationHeader);                 
            
            request.setEndpoint(endpoint);
            request.setMethod('POST');
            request.setHeader('Content-Type','application/x-www-form-urlencoded');
            request.setbody(body);
            
            String  respBody = '';
            Integer statusCode = 400;
            if(!Test.isRunningTest()) {
                HTTPResponse response = httpProtocol.send(request);
                respBody = response.getBody();
                statusCode = response.getStatusCode();
            }
            system.debug('statusCode:' + String.valueOf(statusCode));
            
            charge.Request_Body__c = body;
            charge.Response_Body__c = respBody;
            charge.Response_Status_Code__c = statusCode;
            
            if(statusCode == 200) {
                charge.Status__c = 'Completed_Successfully';
            }
            update charge;
        }
    }

    @HttpPut  
    global static Void putOrder() {

        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != null || Test.isRunningTest()) {
            respPOSTOrder rpo = processPUTRequest(req);
            String jsonBody = JSON.serialize(rpo); 
            res.addHeader('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(jsonBody);
            
            if(rpo.status_code != 0) {
                res.statusCode = rpo.status_code;
            } else {
                res.statusCode = 200;
            }
        } else {
            res.statusCode = 401;
        }
        
    }

    
    @HttpGet  
    global static Void getOrder() {      

        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        String clientId = RESTAuthController.verifyRequest(req);
        
        if(clientId != NULL || Test.isRunningTest()) {
            respGETOrder ro = processGETRequest(req);
            if(ro.status_code != 404) {
                String jsonBody = JSON.serialize(ro); 
                res.addHeader('Content-Type', 'application/json');
                res.responseBody = Blob.valueOf(jsonBody);
                res.statusCode = 200;
            } else {
                res.statusCode = 404;
            }
        } else {
            res.statusCode = 401;
        }
    }            
    
    @HttpPost
    global static void setOrder() {
        
        RestResponse res = RestContext.response;
        RestRequest req = RestContext.request;
        
        String rawJson = req.requestBody.toString();
        reqOrder ro = (reqOrder)JSON.deserialize(rawJson, reqOrder.class);
        if(ro.provider != NULL) {
            try {
                // Zipongo
                String clientId = RESTAuthController.verifyRequest(req);
                            
                if(clientId != NULL || Test.isRunningTest()) {
                    
                    String reqRoute = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
                    String jsonBody;
                    
                    res.statusCode = 200;
                    if(reqRoute == 'preprocess') {
    
                        respPreOrder ppo = preprocessPOSTRequest(req, clientId);                
                        jsonBody = JSON.serialize(ppo); 
                        if(ppo.status_code != 0)
                            res.statusCode = 400;
                        else res.statusCode = 200;
                        
                    } else {
                        respPOSTOrder respPO = new respPOSTOrder();
                        respPOSTOrder rpo;
                       
                        if(ro.charge != NULL && ((ro.charge.charge_later != NULL && ro.charge.charge_later == 1) ||
                           (ro.charge.gateway_token != NULL && ro.charge.amount_charged != NULL))) {
                            processOrderRet por = processPOSTRequest(ro, rawJson, clientId);
                            rpo = por.rpo;                
                            system.debug('Process Order rpo:' + rpo);
                            
                            respPO.id = ro.order_number;
                            respPO.status_message = rpo.status_message;
                            respPO.status_code = rpo.status_code;
                            
                            if(rpo.status_code == 0) {
                                
                                // Check for Dupe Order
                                Boolean dupeOrder = False;
                                List<Opportunity> lstOpp = [select Id, Name, CreatedDate from Opportunity where Email_Address__c = :por.apiReq.Customer_Email__c AND Ship_Date__c = :por.apiReq.Ship_Date__c ORDER BY CreatedDate DESC];
                                system.debug('Dupe Order lstOpp:' + lstOpp);
                                
                                if(lstOpp != NULL && lstOpp.size() > 0) {
                                    DateTime dtnow = DateTime.now();
                                    for(Opportunity opp :lstOpp) {
                                        if(opp.CreatedDate.addMinutes(15) >= dtnow) {
                                            
                                            List<Meal_Line_Item__c> lstMli = [select Id, Name, Shopify_ID__c from Meal_Line_Item__c where EOrder__c = :opp.Id];
                                            system.debug('Dupe Order meals:' + lstMli);
                                            
                                            Boolean sameMeals=true;
                                            Set<String> mealIds = new Set<String>();
                                            if(lstMli != NULL && lstMli.size() > 0) {
                                                
                                                for(Meal_Line_Item__c mli :lstMli) {
                                                    mealIds.add(mli.Shopify_ID__c);
                                                }
                                                system.debug('Dupe Order meals set:' + mealIds);
                                                
                                                for(API_Request_Line_Item__c ali :por.lstApiLines) {
                                                    if(ali.Type__c == 'Meal') {
                                                        Boolean fnd = mealIds.contains(ali.External_Id__c);
                                                        if(!fnd) {
                                                            sameMeals = False;
                                                        }
                                                    }
                                                }
                                            }
                                            dupeOrder = sameMeals;
                                            if(dupeOrder) {
                                                break;
                                            }
                                        }
                                    }
                                }
                                system.debug('Dupe Order dupeOrder:' + dupeOrder);
                                
                                System.debug('ro.charge.charge_later:' + ro.charge.charge_later);
                                Boolean chargeGood = true;
                                Boolean madeCharge = false;
                                if(!dupeOrder && (ro.charge.charge_later == NULL || ro.charge.charge_later != 1)) {
                                    
                                    // Check for duplicate tokens
                                    List<API_Request__c> lstAPIReqCharge = [select Id, Name, Charge_Token__c from API_Request__c where Charge_Token__c = :ro.charge.gateway_token];
                                    if(lstAPIReqCharge == NULL || lstAPIReqCharge.size() < 1 || lstAPIReqCharge[0].Charge_Token__c == 'tok_visa') {
                                        
                                        Http httpProtocol = new Http();
                                        HttpRequest request = new HttpRequest();
                                        String endpoint = 'https://api.stripe.com/v1/charges';
                                        
                                        // Amount is in cents
                                        Integer amt = Integer.valueOf(ro.charge.amount_charged * 100);
                                        String cur = 'currency';
                                        String body = 'amount=' + String.valueOf(amt) + '&source=' + ro.charge.gateway_token + '&description=&' + cur + '=usd&statement_descriptor=Euphebe Order';
                                        
                                        system.debug('body:' + body);
                                        
                                        String username = 'sk_test_QofE12BN3so9Nu4EpHmPCTe3';
                                        //String username = 'sk_live_lFDTLfKCoGEdSZsanCKnwfcj';
                                        
                                        List<Stripe_Settings__c> stripeSettings = Stripe_Settings__c.getall().values();
                                        if(stripeSettings != null && stripeSettings.size() > 0) {
                                            username = stripeSettings[0].Key__c;
                                        }
                                        system.debug('username:' + username);
                                        
                                        String password = '';
                                        Blob headerValue = Blob.valueOf(username + ':' + password);
                                        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
                                        request.setHeader('Authorization', authorizationHeader);                 
                                        
                                        request.setEndpoint(endpoint);
                                        request.setMethod('POST');
                                        request.setHeader('Content-Type','application/x-www-form-urlencoded');
                                        request.setbody(body);
                                        
                                        // Create Charge
                                        //Charge__c ch = new Charge__c();
                                        //ch.Name = 'Zipongo Order';
                                        //ch.Amount__c = ro.charge.amount_charged;
                                        //ch.Gateway_Token__c = ro.charge.gateway_token;
                                        //insert ch;
                                        madeCharge = True;
                                        
                                        Integer statusCode = 400;
                                        String respBody = '{}';
                                        if(!Test.isRunningTest()) {
                                            HTTPResponse response = httpProtocol.send(request);
                                            respBody = response.getBody();
                                            system.debug('Stripe respBody:' + respBody);
                                            
                                            statusCode = response.getStatusCode();
                                        }
                                        system.debug('Stripe statusCode:' + String.valueOf(statusCode));
                                        
                                        if(statusCode == 200) {
                                            stripeChargeResp scr = (stripeChargeResp)JSON.deserialize(respBody, stripeChargeResp.class);
                                            ro.charge.charge_req = body;
                                            ro.charge.charge_resp = respBody;
                                            rawJson = JSON.serialize(ro); 
                                            system.debug('rawJson update:' + rawJson);
                                                                                       
                                        } else if(!Test.isRunningTest()) {
                                            chargeGood = false;
                                            
                                            stripeChargeResp scr = (stripeChargeResp)JSON.deserialize(respBody, stripeChargeResp.class);
                                            ro.charge.charge_req = body;
                                            ro.charge.charge_resp = respBody;
                                            //rawJson = JSON.serialize(ro); 
                                            //system.debug('rawJson update:' + rawJson);
                                            
                                            system.debug('Stripe Error:' + scr);
                                            
                                            respPO.status_message = scr.error.message;
                                            respPO.status_code = 520;
                                        }
                                        
                                    } else { 
                                        chargeGood = false;
                                        respPO.status_message = 'Duplicate Charge';
                                        respPO.status_code = 521;
                                    }  
                                    
                                } else {
                                    ro.charge.charge_req = NULL;
                                    ro.charge.charge_resp = NULL;    
                                }

                                
                                system.debug('chargeGood:' + chargeGood);
                                
                                API_Request__c apiReq = por.apiReq;
                                List<API_Request_Line_Item__c> lstApiLines = por.lstApiLines;

                                apiReq.Charge_Amount__c = ro.charge.amount_charged;
                                apiReq.User_Amount__c = ro.charge.user_amount;
                                if(ro.charge.charge_later != NULL && ro.charge.charge_later == 1) {
                                    apiReq.Charge_Later__c = True;                                
                                }

                                system.debug('madeCharge:' + madeCharge);
                                
                                if(madeCharge) {
                                    //apiReq.Charge_Amount__c = ro.charge.amount_charged;
                                    //apiReq.User_Amount__c = ro.charge.user_amount;
                                    
                                    // Convert ephoc
                                    Datetime createdDate = Datetime.newInstanceGmt(1970, 1, 1, 0, 0, 0);
                                    createdDate = createdDate.addSeconds(ro.charge.gateway_datetime);
                                    System.debug('DateTime: ' + createdDate);
                                    
                                    apiReq.Charge_Token_Creation_Date_Time__c = createdDate;
                                    apiReq.Charge_Token__c = ro.charge.gateway_token;
                                    apiReq.Charge_Source__c = ro.charge.source;
                                    
                                    apiReq.Charge_Request_Body__c = ro.charge.charge_req;
                                    apiReq.Charge_Response_Body__c = ro.charge.charge_resp;
                                }
                                
                                system.debug('Insert apiReq:' + apiReq);
                                insert apiReq;
                                
                                LIST<API_Request__c> lstAPIRequest = [select Id, Auto_Order_Number__c from API_Request__c where ID = :apiReq.Id];
                                system.debug('lstAPIRequest:' + lstAPIRequest);
                                
                                if(lstAPIRequest != NULL && lstAPIRequest.size() > 0) {
                                    
                                    for(API_Request_Line_Item__c al :lstApiLines) {
                                        al.API_Request__c = apiReq.Id;
                                    }
                                    
                                    insert lstApiLines;
                                    
                                    // Fire Automation
                                    apiReq.Is_Custom__c = true;
                                    
                                    system.debug('Enable_Automation__c:' + dupeOrder + ':' + chargeGood);
                                    
                                    if(!dupeOrder && chargeGood) {
                                        apiReq.Enable_Automation__c = true;    
                                    }
                                    
                                    if(chargeGood) {
                                        apiReq.OrderId__c = apiReq.Id;
                                        
                                        if(ro.order_number == NULL || ro.order_number == 'null') {
                                            apiReq.Order_Number__c = lstAPIRequest[0].Auto_Order_Number__c;  
                                            respPO.id = lstAPIRequest[0].Auto_Order_Number__c;
                                        }                          
                                        
                                        //system.assert(false, 'BOOM!'+ rpo.id  + ':');
                                        
                                        update apiReq;
                                        respPO.status_code = 0;
                                        
                                    } else {
                                        respPO.id = '';
                                    }
                                    
                                    //DateTime now = DateTime.now();
                                    //Database.executebatch(new batchCompleteProviderOrders(now,apiReq.Id));
                                } else {
                                    respPO.status_message = 'Error Processing Order : 1';
                                    respPO.status_code = 513;
                                }
                            }

                               
                        } else {
                            
                            respPO.status_message = 'Missing Charge Information';
                            respPO.status_code = 519;
                        }                                
                        
                        if(respPO.status_code != 0) {
                            // If not set custom response HTTP code send 400
                            if(res.statusCode != 400)
                                res.statusCode = 400;
                        }
                            
                        
                        jsonBody = JSON.serialize(respPO); 
                        res.responseBody = Blob.valueOf(jsonBody);
                        
                        if(respPO.status_code != 0) {
                            Api_Request__c apir = new Api_Request__c();
                            apir.Raw_Request__c = rawJson;
                            apir.Response__c = respPO.status_code + ':' + respPO.status_message;
                            insert apir;
                        }
                        
                    }

                    res.addHeader('Content-Type', 'application/json');
                    res.responseBody = Blob.valueOf(jsonBody);
                    
                    system.debug('Process Order res.statusCode:' + res.statusCode);
                   
                } else {
                    res.statusCode = 401;
                }
                
            } catch (Exception e) {
                
                system.debug('Process Order Exception:' + e.getMessage());
                
                if(req != null) {
                    processOrderError(req, e.getMessage());
                }
                //return 'Error';    
                res.statusCode = 500;                
            }  
                
        } else if(ro.id != NULL) {
            // Shopify
            try {           
                //String rawJson = req.requestBody.toString();
                processAPIOrder(rawJson); 
                
                //return 'OK';    
                res.statusCode = 200;
                
            } catch (Exception e) {
                if(req != null) {
                    processOrderError(req, e.getMessage());
                }
                //return 'Error';    
                res.statusCode = 500;                
            }              
        } else {
            res.statusCode = 500;  
        }
    }        
    
    @InvocableMethod(label='orderMethods' description='Operate OrdersController Class Methods.')
    public static void orderMethods(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
        String method;
        String param1;
        String param2;
        String param3;
        String param4;
        List<String> ids = inputParams[0];
        
        if(!ids.isEmpty()){
            Integer cnt=0;
            for(String idVal :ids) {
                if(cnt==0)
                    method = idVal;
                else if(cnt==1)
                    param1 = idVal;
                cnt++;
            }
            System.debug('method:' + method);
            System.debug('param1:' + param1);
            System.debug('param2:' + param2);
            System.debug('param3:' + param3);
            System.debug('param4:' + param4);
            
            if(method == 'chargeStripe') {
                chargeStripe(param1);
            } 
        }
   
    }        
    
    
}