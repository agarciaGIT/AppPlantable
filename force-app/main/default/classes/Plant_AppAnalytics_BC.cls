/*
*   @Desciption     :   Plantable OnBoarding Business class, execute request in sf and return result
*   @Create date    :   09-16-2022
*   @Author         :   Alberto Garcia
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class Plant_AppAnalytics_BC {
	// TO DO
    public static Map<String,String> getClassDetail(){
        Map<String,String> metodsMap = new Map<String,String>();
        //string Name, String Type, String rtnType, String param, String detail
        metodsMap.put('getAllActiveMeals',Plant_Utility.setMethodEntry('getAvailableDates', 'get', 'Plant_Utility.responseWrapper','NONE', 'Return all active Meals records'));
        metodsMap.put('updateMealSelection',Plant_Utility.setMethodEntry('updateMealSelection', 'set', 'Plant_Utility.responseWrapper','MealSelectionReq_Wrapper wrapper object', 'Ad new meal list from Meal selection'));
        return metodsMap;
    }

    public Plant_Utility.responseWrapper setLastLogin(autorize_AccountReq reqWrap){
        
        if(reqWrap.accountId == NULL || reqWrap.lastLogin == NULL) {
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','500','Missing required info for this call',new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;
        }
        List<Account> lstAcct = [select Id, Plant_Last_Login_Date_Time__c from Account where id = :reqWrap.accountId];
        if(lstAcct.isEmpty()) {
            Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('error','404','No Account found for this Account: ' + reqWrap.accountId,new Plant_Utility.responseListWrapper(new List<String>()));
            return responseWrap;            
        }
        //DateTime dt = (DateTime) JSON.deserialize('"2016-03-03T01:09:36.933"', DateTime.class);
		DateTime dt = (DateTime) JSON.deserialize('"' + reqWrap.lastLogin + '"', DateTime.class);
        dt.addHours(4);
        lstAcct[0].Plant_Last_Login_Date_Time__c = DateTime.valueOf(dt);
        update lstAcct;
        
        Plant_Utility.responseWrapper responseWrap = new Plant_Utility.responseWrapper('Success','200','Last Login updated for this Account: ' + reqWrap.accountId,new Plant_Utility.responseListWrapper(new List<String>()));
        return responseWrap;            
    }
    
    public class autorize_AccountReq{
        public String accountId; // account Id
        public String lastLogin; 

        public autorize_AccountReq parse(String json_po){
            return (autorize_AccountReq)JSON.deserialize(json_po, autorize_AccountReq.class);
        }
    }
    
}