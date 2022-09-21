/*
*   @Desciption     :   Plantable Discount API class
*   @Create date    :   21-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
@RestResource(urlMapping='/v1/discount/*')
global class Plant_RESTDiscountCodes {

    // @ Constructor
    global Plant_RESTDiscountCodes() {

    }

    // @ set: 1
    @HttpPut
    global static void setDcode(){
        RestRequest req = RestContext.request;
        RestResponse res =  RestContext.response;

        res.addHeader('Content-Type','application/json');

        System.debug('#### check=> '+req.requestURI.lastIndexOf('/')+1);
        System.debug('#### check substring => '+req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
        
        if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('add')){
            String jsonReq = req.requestBody.toString();
            Plant_DiscountCodes_BC.dcReqWrapper reqWrap = new Plant_DiscountCodes_BC.dcReqWrapper().parse(jsonReq);

            // call add service class
            Plant_Utility.responseWrapper dc_resultWrap = Plant_DiscountCodes_SC.setDiscountCode(reqWrap);
            if(dc_resultWrap.statusCode.trim()=='200'){
                res.statusCode = Integer.valueOf(dc_resultWrap.statusCode.trim());
                System.debug('@@@@## success dc add');
            }
            else{
                res.statusCode = Integer.valueOf(dc_resultWrap.statusCode.trim());
                System.debug('@@@@## error dc add');
            }   

            String jsonRespBody = JSON.serialize(dc_resultWrap); 
            res.responseBody = Blob.valueOf(jsonRespBody);  
        }
        else if(req.requestURI.substring(req.requestURI.lastIndexOf('/')+1).equalsIgnoreCase('remove')){
            String jsonReq = req.requestBody.toString();
            Plant_DiscountCodes_BC.dcReqWrapper reqWrap = new Plant_DiscountCodes_BC.dcReqWrapper().parse(jsonReq);

            // call Remove service class
            Plant_Utility.responseWrapper dc_resultWrap = Plant_DiscountCodes_SC.removeDiscountCode(reqWrap);
            if(dc_resultWrap.statusCode.trim()=='200'){
                res.statusCode = Integer.valueOf(dc_resultWrap.statusCode.trim());
                System.debug('@@@@## success dc remove');
            }
            else{
                res.statusCode = Integer.valueOf(dc_resultWrap.statusCode.trim());
                System.debug('@@@@## error dc remove');
            }   

            String jsonRespBody = JSON.serialize(dc_resultWrap); 
            res.responseBody = Blob.valueOf(jsonRespBody);  
        }
        else{
            // RETURN ERROR
            String status='error';
            String statusCode='501';
            String msg='Not Implemented';

            List<String> response_List = new List<String>();
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper(status,statusCode,msg,new Plant_Utility.responseListWrapper(response_List));
            String jsonResponse =  JSON.serialize(responseWrap);
            res.responseBody = Blob.valueOf(jsonResponse);
        }
        
    }
}