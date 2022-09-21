/*
*   @Desciption     :   Plantable DiscountCodes Business class, execute request in sf and return result
*   @Create date    :   07-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/

public class Plant_DiscountCodes_BC {
    
    // Default constructor
    public Plant_DiscountCodes_BC() {

    }

     // @Method 0
    // desc:  Return list of available methods for this class
    public static Map<String,String> getClassDetail(){
        Map<String,String> metodsMap = new Map<String,String>();
        metodsMap.put('updateDiscountCodeToOrder',Plant_Utility.setMethodEntry('updateDiscountCodeToOrder', 'set', 'Plant_Utility.responseWrapper','dcReqWrapper wrapper object', 'Validate Discount code for Order type and if Valid then add '));
        metodsMap.put('removeDiscountCode',Plant_Utility.setMethodEntry('removeDiscountCode', 'set', 'Plant_Utility.responseWrapper','dcReqWrapper wrapper object', 'Remove Discount code for Order property'));
        return metodsMap;
    }

    // ------------------------------------------------------------------------------------------------------------------------ // ** Default


    // @ Method 1
    // @ Desc:  Verify and Add discount Codes on Order
    public Plant_Utility.responseWrapper updateDiscountCodeToOrder(dcReqWrapper reqWrap){
        String status='';
        String statusCode='';
        String msg='';
        
        Boolean cart_AlradyInUsed =false;
        String orderType = '';
        Set<String> exst_rltdDiscountCode_Set = new Set<String>();
        Set<String> nw_rltdDiscountCode_Set = new Set<String>();
        Plant_Order_Properties__c temp_ProcOdrRec = new Plant_Order_Properties__c();
        
        // response
        dcResWrapper response = new dcResWrapper();
        calculatedPriceWrap default_Price = new calculatedPriceWrap();
        
        try{
            // System.debug('@@@@@# AA1 => '+reqWrap);
            if(!String.isBlank(reqWrap.cartId)){

                // ~~ Parse JSON ~~            
                // GET LIST OF ALREADY EXISTING DISCOUNT CODE 
                for(Plant_Order_Properties__c procOdrRec : [SELECT Id, RecordType.Name,plan_discountedAmount__c,(SELECT id FROM Orders__r LIMIT 1),(SELECT id,Plant_Discount_Code__c,Plant_Discount_Code__r.Name,Plant_Discount_Code__r.Plant_Code__c,Plant_Discount_Code__r.Plant_Amount__c,Plant_Discount_Code__r.Plant_Type__c FROM Discount_Selection__r) FROM Plant_Order_Properties__c WHERE Id=:reqWrap.cartId]){      
                    temp_ProcOdrRec = procOdrRec;
                    if(procOdrRec.Discount_Selection__r.size()!=0){
                        for(Plant_Discount_Selection__c disCod : procOdrRec.Discount_Selection__r){
                            exst_rltdDiscountCode_Set.add(disCod.Plant_Discount_Code__r.Plant_Code__c);
                        }
                    }
                    
                    // Validation: check if Process order already called
                    if(procOdrRec.Orders__r.size()>0){
                        cart_AlradyInUsed= true;
                    }    
                    if(orderType=='')
                        orderType = procOdrRec.RecordType.Name;
                }

                
                if(cart_AlradyInUsed){
                    status = 'error';
                    statusCode='503';
                    msg='Service Unavailable: Cart already in used';
                }
                else{
                    // get product default price
                    if(orderType!=''){
                        PricebookEntry pbEntry = [SELECT Id, Product2Id,UnitPrice FROM PricebookEntry WHERE product2Id IN (SELECT id FROM product2 where Name=:orderType)];
                        default_Price.price = pbEntry.UnitPrice;
                        default_Price.total = pbEntry.UnitPrice;

                        if(temp_ProcOdrRec.plan_discountedAmount__c!=null && temp_ProcOdrRec.plan_discountedAmount__c>0){
                            default_Price.discount = temp_ProcOdrRec.plan_discountedAmount__c;
                            default_Price.total = default_Price.price - temp_ProcOdrRec.plan_discountedAmount__c;
                        }
                    }

                    // IF: new DC supported for order type
                    if(reqWrap.DisCode!='' && reqWrap.DisCode!=null && reqWrap.Product!=null && reqWrap.Product!='' && orderType==reqWrap.Product){

                        // VALIDATION 1: CHECK IF NEW DISCOUND CODE(DC) EXIST
                        List<Plant_Discount_Code__c> nw_discRecord = [SELECT Id,Plant_Amount__c,Plant_Type__c,Plant_Status__c,Plant_Supported_Products__c,Plant_Code__c,(SELECT id,Plant_Discount_Code_Related__r.Plant_Code__c FROM Related_Codes1__r LIMIT 200) FROM Plant_Discount_Code__c WHERE Plant_Code__c=:reqWrap.DisCode AND  Plant_Status__c='Active' AND Plant_Supported_Products__c=:orderType LIMIT 1];
                        // System.debug('####@@ disc => '+nw_discRecord);

                    if(!exst_rltdDiscountCode_Set.isEmpty() && exst_rltdDiscountCode_Set.contains(reqWrap.DisCode)){
                        System.debug('####@@ disc =>0');
                        status = 'error';
                        statusCode='503';
                        msg='Service Unavailable: Code already available';
                    }
                    else{
                        // System.debug('####@@ disc =>1 ');
                            // IF NEW DISCOUNT CODE valid
                            if(!nw_discRecord.isEmpty()){
                                // System.debug('####@@ disc =>2 ');
                                //LIST RELATED CODE OF NEW DISCOUNT CODE(DC)
                                if(nw_discRecord[0].Related_Codes1__r.size()>0){
                                    for(Plant_Related_Code__c rltdCd : nw_discRecord[0].Related_Codes1__r){
                                        nw_rltdDiscountCode_Set.add(rltdCd.Plant_Discount_Code_Related__r.Plant_Code__c);
                                    }
                                }
                                
                                // System.debug('####@@ nw_rltdDiscountCode_Set => '+nw_rltdDiscountCode_Set);
                                if(!nw_rltdDiscountCode_Set.isEmpty()){
                                    // System.debug('####@@ disc =>3 ');
                                        // if no relative code found
                                        if(exst_rltdDiscountCode_Set.isEmpty()){
                                            response.priceDetail = default_Price;
                                            status = 'error';
                                            statusCode='501';
                                            msg='Not Implemented: Dependent code missing';
                                        }
                                        else{
                                            // System.debug('####@@ disc =>4 ');
                                            // if relative code are exact match
                                            if((exst_rltdDiscountCode_Set.size()==nw_rltdDiscountCode_Set.size()) && exst_rltdDiscountCode_Set.containsAll(nw_rltdDiscountCode_Set)){
                                                
                                                // CALCULATED DISCOUNTED PRICE**
                                                System.debug('####@@ disc =>5.1 ');
                                                calculatedPriceWrap discountResult_obj = getCalculatePrice(reqWrap.cartId, nw_discRecord[0].Id, nw_discRecord[0].Plant_Amount__c, nw_discRecord[0].Plant_Type__c, orderType, 'Add');
                                                response.priceDetail = discountResult_obj;
                                                System.debug('####@@ disc => '+discountResult_obj);
                                                if(!discountResult_obj.errmMg.startsWith('Error')){
                                                    //  System.debug('####@@ disc =>5 ');
                                                    Plant_Discount_Selection__c nwCode = new Plant_Discount_Selection__c();
                                                    nwCode.Plant_Discount_Code__c = nw_discRecord[0].Id;
                                                    nwCode.Plant_Order_Properties__c = reqWrap.cartId;
                                                    insert nwCode;

                                                    status = 'success';
                                                    statusCode='200';
                                                    msg='Discount Code added succcesfully!';
                                                    exst_rltdDiscountCode_Set.add(reqWrap.DisCode);
                                                }
                                                else {
                                                    // System.debug('####@@ disc =>5.2 ');
                                                    response.priceDetail = default_Price;
                                                    status = 'error';
                                                    statusCode='501';
                                                    msg='Not Implemented: Fail to add discount code - '+discountResult_obj.errmMg;
                                                }
                                            
                                                
                                            }
                                            else { // if relative code are not exact match
                                                response.priceDetail = default_Price;
                                                status = 'error';
                                                statusCode='501';
                                                msg='Not Implemented: Fail to add discount code. Dependent code do not match.';
                                            }
                                        }
                                    
                                }
                                else{
                                    // no relative dc** Good to add

                                    // CALCULATED DISCOUNTED PRICE**
                                    //  System.debug('####@@ disc =>A.1 ');
                                    calculatedPriceWrap discountResult_obj = getCalculatePrice(reqWrap.cartId, nw_discRecord[0].Id, nw_discRecord[0].Plant_Amount__c, nw_discRecord[0].Plant_Type__c, orderType, 'Add');
                                    response.priceDetail = discountResult_obj;
                                    if(!discountResult_obj.errmMg.startsWith('Error')){
                                        //   System.debug('####@@ disc =>A ');
                                        Plant_Discount_Selection__c nwCode = new Plant_Discount_Selection__c();
                                        nwCode.Plant_Discount_Code__c = nw_discRecord[0].Id;
                                        nwCode.Plant_Order_Properties__c = reqWrap.cartId;
                                        insert nwCode;
        
                                        status = 'success';
                                        statusCode='200';
                                        msg='Discount Code added succcesfully!';
                                        exst_rltdDiscountCode_Set.add(reqWrap.DisCode);
                                    }
                                    else {
                                        //  System.debug('####@@ disc =>A.2 ');
                                        status = 'error';
                                        statusCode='501';
                                        msg='Not Implemented: Fail to add discount code - '+discountResult_obj.errmMg;
                                    }

                                }

                            }
                            else{
                                System.debug('@@@@ 123 '+default_Price);
                                response.priceDetail = default_Price;
                                //  NEW DISCOUNT CODE DOES NOT EXIST
                                status = 'error';
                                statusCode='501';
                                msg='Not Implemented: Invalid Discount Code, Please check again!';
                                
                            }
                        }

                    }
                    else{
                        response.priceDetail = default_Price;
                        // System.debug('####@@ disc =>10');
                        status = 'success';
                        statusCode='200';
                        msg='No discount code to add';
                    }
                }
            }
            else{
                // System.debug('####@@ disc =>11');
                    status = 'error';
                    statusCode='503';
                    msg='Service Unavailable: Cart Id not found';
            }
            
        }
        catch(Exception ex){
            // System.debug('@@@@@@@@@ EXCEPTION ENCOUNTERD DC: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            // System.debug('####@@ disc =>12');
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }

        System.debug('@@@@ response => ');
        System.debug('@@@@ response 1  => '+response);

        // return 
        List<String> extngCodeList = new List<String>();
        if(!exst_rltdDiscountCode_Set.isEmpty()){
            extngCodeList.addAll(exst_rltdDiscountCode_Set);
        }
        response.discountCodes = extngCodeList;
        response.cartId = reqWrap.cartId;
        List<dcResWrapper> response_list = new List<dcResWrapper>();
        response_list.add(response);
        System.debug('@@@@ response 2  => '+response);
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(response_list));
        System.debug('@@@@ responseWrap '+JSON.serializePretty(responseWrap));
        return responseWrap;
    }

    // @ Method 2
    // @ desc   :   remove a discount code from orderProperty
    public Plant_Utility.responseWrapper removeDiscountCode(dcReqWrapper reqWrap){
       
        String status='';
        String statusCode='';
        String msg='';
        
        Boolean cart_AlradyInUsed =false;
        String orderType = '';
        Set<String> exst_rltdDiscountCode_Set_Copy = new Set<String>();
        List<Plant_Discount_Selection__c> dc_ToRemove_List = new List<Plant_Discount_Selection__c>();//Plant_Discount_Selection__c: Junction obj b/w Dc and OPr
        Map<String,Plant_Discount_Selection__c> exst_rltdDiscountCode_Map = new Map<String,Plant_Discount_Selection__c>();

        // response body
        dcResWrapper response = new dcResWrapper();
        
        try{
            System.debug('@@@@@# remove AA1 => '+reqWrap);
            
            //VALIDATION: check order property ID
            if(!String.isBlank(reqWrap.cartId) && !String.isBlank(reqWrap.DisCode)  && !String.isBlank(reqWrap.Product) ){   
                // GET 
                // @desc: list of existing discount code for Order Property record(OPr)
                for(Plant_Order_Properties__c procOdrRec : [SELECT Id, RecordType.Name,(SELECT id FROM Orders__r LIMIT 1),(SELECT id,Plant_Discount_Code__c,Plant_Discount_Code__r.Id, Plant_Discount_Code__r.Name,Plant_Discount_Code__r.Plant_Code__c,
                                                            Plant_Discount_Code__r.Plant_Amount__c,Plant_Discount_Code__r.Plant_Type__c,Plant_Discount_Code__r.Plant_Status__c FROM Discount_Selection__r) FROM Plant_Order_Properties__c WHERE Id=:reqWrap.cartId]){      
                    if(procOdrRec.Discount_Selection__r.size()!=0){
                        for(Plant_Discount_Selection__c dc_SelectorRcd : procOdrRec.Discount_Selection__r){
                            exst_rltdDiscountCode_Map.put(dc_SelectorRcd.Plant_Discount_Code__r.Plant_Code__c,dc_SelectorRcd);
                        }
                    }
                    
                    // Validation: check if Process order already called
                    if(procOdrRec.Orders__r.size()>0){
                        cart_AlradyInUsed= true;
                    }  

                    if(orderType=='')
                        orderType = procOdrRec.RecordType.Name;
                }

                if(cart_AlradyInUsed){
                    status = 'error';
                    statusCode='503';
                    msg='Service Unavailable: Cart already in used';
                }
                else{
                        // VALIDATION: check if userinput is for same product as of (OPr)type
                        if(orderType=='' || orderType!=reqWrap.Product){
                            status='error';
                            statusCode='503';
                            msg='Service Unavailable! cartId not correct';
                        }
                        else{
                            //DC list empty at OPr
                            if(exst_rltdDiscountCode_Map.isEmpty()){
                                // RETURN NO CODE TO REMOVE
                                status='success';
                                statusCode='200';
                                msg='No discount code to remove';
                            }// client Dc not available in DCList at OPr
                            else if(!exst_rltdDiscountCode_Map.keySet().contains(reqWrap.DisCode)){
                                // RETURN NO CODE TO REMOVE
                                status='success';
                                statusCode='200';
                                msg='No discount code to remove';
                            }
                            else{// client Dc available in DCList at OPr
                                exst_rltdDiscountCode_Set_Copy = exst_rltdDiscountCode_Map.keySet();
                                dc_ToRemove_List.add(exst_rltdDiscountCode_Map.get(reqWrap.DisCode));//add discount code(to remove) from Opr available DC to remove list
                                exst_rltdDiscountCode_Set_Copy.remove(reqWrap.DisCode);

                                // dc_ToRemove_List[0] is never empty
                                // Calculate updated price
                                calculatedPriceWrap discountResult_obj = getCalculatePrice(reqWrap.cartId, dc_ToRemove_List[0].Plant_Discount_Code__r.Id, dc_ToRemove_List[0].Plant_Discount_Code__r.Plant_Amount__c, dc_ToRemove_List[0].Plant_Discount_Code__r.Plant_Type__c, orderType, 'Remove');
                                response.priceDetail = discountResult_obj;
                                if(!discountResult_obj.errmMg.startsWith('Error')){
                                    // System.debug('####@@ disc Rem =>A ');
                                    
                                    //check dependent code to remove
                                    List<Plant_Discount_Code__c> dc_ToRemove = [SELECT Id,Plant_Amount__c,Plant_Type__c,Plant_Status__c,Plant_Supported_Products__c,Plant_Code__c,(SELECT id,Plant_Discount_Code_Related__r.Plant_Code__c FROM Related_Codes1__r LIMIT 200) FROM Plant_Discount_Code__c WHERE Plant_Code__c=:reqWrap.DisCode AND  Plant_Status__c='Active' AND Plant_Supported_Products__c=:orderType LIMIT 1];
                                    for(Plant_Related_Code__c rltdCd : dc_ToRemove[0].Related_Codes1__r){
                                        if(exst_rltdDiscountCode_Map.keySet().contains(rltdCd.Plant_Discount_Code_Related__r.Plant_Code__c)){
                                            dc_ToRemove_List.add(exst_rltdDiscountCode_Map.get(rltdCd.Plant_Discount_Code_Related__r.Plant_Code__c));
                                            exst_rltdDiscountCode_Set_Copy.remove(rltdCd.Plant_Discount_Code_Related__r.Plant_Code__c);
                                        }
                                    }

                                    // delete(Remove) DC form order property
                                    // System.debug('###@ DC to remove => '+dc_ToRemove_List);
                                    delete dc_ToRemove_List;

                                    // update: Order Property record with new amount
                                    status = 'successful';
                                    statusCode='200';
                                    msg='Discount code removed successfully';
                                }
                                else {
                                    //  System.debug('####@@ disc  Rem =>A.2 ');
                                    status = 'error';
                                    statusCode='501';
                                    msg='Not Implemented: Fail to Remove discount code - '+discountResult_obj.errmMg;
                                }                        
                            }
                        }
                }

            }
            else{
                    status = 'error';
                    statusCode='503';
                    msg='Service Unavailable: Request body incorrect';
            }
            
        }
        catch(Exception ex){
            System.debug('@@@@@@@@@ remove EXCEPTION ENCOUNTERD DC: line: '+ex.getLineNumber()+' msg: '+ex.getCause()+' '+ex.getMessage());
            status = 'error';
            statusCode='500';
            msg='Internal Server Error: '+ex.getMessage();
        }

        // return 
        response.cartId = reqWrap.cartId;
        List<String> extngCodeList = new List<String>();
        if(!exst_rltdDiscountCode_Set_Copy.isEmpty()){
            extngCodeList.addAll(exst_rltdDiscountCode_Set_Copy);
            response.discountCodes = extngCodeList;
        }
        List<dcResWrapper> response_list = new List<dcResWrapper>();
        response_list.add(response);

        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(response_list));
        return responseWrap; 
    }

    // Mehtod 3:
    // @desc: calculate discounted price
    public static calculatedPriceWrap getCalculatePrice(String cartId, String discountCodeId, Decimal amount,String discType, String prodName, String OperationType){
        System.debug('@@@@@@@# getCalculatePrice METHOD ');
       
        Decimal original_price =0.0;
        Decimal nw_discount =0.0;
        Decimal nw_total =0.0;
        String errMsg = 'None';

        try {
            Plant_Order_Properties__c temp_OrdrProp =  [SELECT id,plan_discountedAmount__c FROM Plant_Order_Properties__c WHERE Id=:cartId];
            PricebookEntry pbEntry = [SELECT Id, Product2Id,UnitPrice FROM PricebookEntry WHERE product2Id IN (SELECT id FROM product2 where Name=:prodName)];
            if(pbEntry!=null){
                // System.debug('===> 1');
                switch on discType {
                    when 'Percent Off' {	
                        // System.debug('===> 2');
                        original_price = pbEntry.UnitPrice;
                        
                        if(temp_OrdrProp.plan_discountedAmount__c!=null && temp_OrdrProp.plan_discountedAmount__c!=0){
                            if(OperationType=='Add')
                                nw_discount = (((amount!=null?amount:0)*pbEntry.UnitPrice)/100) + temp_OrdrProp.plan_discountedAmount__c;// total discount
                            else //Remove DC
                                nw_discount = temp_OrdrProp.plan_discountedAmount__c - (((amount!=null?amount:0)*pbEntry.UnitPrice)/100);
                        }	
                        else {
                            // System.debug('===> 2.1');
                            if(OperationType=='Add')
                                nw_discount = ((amount!=null?amount:0)*pbEntry.UnitPrice)/100;
                            else //Remove DC
                                nw_discount = 0.0;
                        }    
                        nw_total = original_price - nw_discount;
                        
                    }	
                    when 'Fixed Amount Off' {		
                        // System.debug('===> 3');
                        original_price = pbEntry.UnitPrice;

                        if(temp_OrdrProp.plan_discountedAmount__c!=null && temp_OrdrProp.plan_discountedAmount__c!=0){
                            if(OperationType=='Add')
                                nw_discount = (amount!=null?amount:0)+temp_OrdrProp.plan_discountedAmount__c;
                            else //Remove DC
                                nw_discount = temp_OrdrProp.plan_discountedAmount__c -  (amount!=null?amount:0);
                        }	
                        else {
                            if(OperationType=='Add')
                                nw_discount = amount!=null?amount:0;
                            else //Remove DC
                                nw_discount = 0.0;
                        }
                        nw_total = original_price - nw_discount;
                        
                    }
                    when 'Fixed Amount' {	
                        // System.debug('===> 4');	
                        original_price = pbEntry.UnitPrice;
                        if(OperationType=='Add'){
                            nw_discount = original_price - (amount!=null?amount:0);
                            nw_total = (amount!=null?amount:0);
                        }
                        else {
                            nw_discount = 0.0;
                            nw_total = original_price;
                        }
                        
                    }
                    when else {		  
                        // System.debug('===> 5');
                        errMsg = 'Error: Discount code not correct';
                    }
                }
            }
            else{
                System.debug('DISCOUNT CODE AMOUNT CALCULATION FAIL: no pricebook entry found '+pbEntry);
            }

            if(errMsg=='None'){
                // System.debug('===> 6');
                // UPDATE ORDER PROPERTY ghost field: plan_discountedAmount__c                
                temp_OrdrProp.plan_discountedAmount__c = nw_discount;
               

                update temp_OrdrProp;
            }
        } 
        catch(Exception ex){
            System.debug('###@@@ EXCEPTION ENCOUNTERED: discount calculation line: '+ex.getLineNumber()+' Msg: '+ex.getCause());
            original_price = 0.0;
            nw_discount = 0.0;
            nw_total = 0.0;
            errMsg='Error: discount calculation line: '+ex.getLineNumber()+' Msg: '+ex.getCause();
        }
        
        System.debug('@@@@ =>original_price '+original_price);
        System.debug('@@@@ =>nw_discount '+nw_discount);
        System.debug('@@@@ =>nw_total '+nw_total);
        System.debug('@@@@ =>errMsg '+errMsg);
        calculatedPriceWrap newPrice =  new calculatedPriceWrap(original_price, nw_discount, nw_total, errMsg);
        return newPrice;
    }

    // wrapper class 1:
    public class dcReqWrapper{
        public String cartId;// Order Property Id
        public String Product; // Order Property Record type 
        public String DisCode;

        public dcReqWrapper parse(String json_dc){
            return (dcReqWrapper)JSON.deserialize(json_dc, dcReqWrapper.class);
        }
    }

    // wrapper class 2:
    // discount wrapper response class
    public class dcResWrapper{
        public String cartId;// Order Property Id
        public List<String> discountCodes;  
        public calculatedPriceWrap priceDetail;
    }

    // wrapper class: 3
    // @desc: hold calculated result after adding/removing discount code
    public class calculatedPriceWrap{
        public Decimal price;
        public Decimal discount;
        public Decimal total;
        public String errmMg;

        public calculatedPriceWrap(Decimal original_price,Decimal nw_discount,Decimal nw_total, String errmMg){
            this.price = original_price;
            this.discount = nw_discount;
            this.total = nw_total;
            this.errmMg = errmMg;
        }

        public calculatedPriceWrap(){
            this.price = 0.0;
            this.discount = 0.0;
            this.total = 0.0;
            this.errmMg = 'none';
        }
    }
}