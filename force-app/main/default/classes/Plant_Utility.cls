/*
*   @Desciption     :   Plantable repetitive item and constant handler
*   @Create date    :   04-04-2022
*   @Author         :   Bhagwan S
_________________________________________________________________________________________________________________________________________________________
    @Test class     :   
*/
public class Plant_Utility {
    
    public Static String gatwayName = 'Stripe Test (1)';
    public Static String default_recurrenceProductName = 'Reboot';// IF MULTIPLE- please use (,) as separator
    public Static String default_Shipping_Day = 'Monday';
    
    // Default constructor
    public Plant_Utility() {

    }
    
    // AG
    public static Id GetRecordTypeId(String sobjectType, String name){
        String recordTypeId = Schema.getGlobalDescribe().get(sobjectType).getDescribe().getRecordTypeInfosByName().get(name).getRecordTypeId();
        return recordTypeId;
    }

    // Method**
    // create method detail entry and return record
    public static string setMethodEntry(string Name, String Type, String rtnType, String param, String detail){
        classStructureDetail csd_Obj = new classStructureDetail(Name,Type,rtnType,param,detail);
        return JSON.serialize(csd_Obj);
    }

     // Method**
     // verify email format
    public static Boolean checkEmail (String sEmail) {
        Boolean returnValue = true;
        String InputEmail = sEmail;
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern emailPattern = Pattern.compile(emailRegex);
    
        Matcher MyMatcher = emailPattern.matcher(InputEmail);
    
        if (!MyMatcher.matches()) {
            returnValue = false;
            }
        return returnValue;
    }

    // Method**
     // verify email format
     public static Boolean checkDateFormat (String sDate) {
        Boolean returnValue = true;
        String InputDate = sDate;
        // SF accept 2022-06-22
        Pattern datePattern = Pattern.compile('\\d{4}-\\d{2}-\\d{2}');//('\\d{4}-\\d{2}-\\d{2}');
    
        Matcher MyMatcher = datePattern.matcher(InputDate);
    
        if (!MyMatcher.matches()) {
            returnValue = false;
            }
        return returnValue;
    }

    // Method**
    // check address is valid
    public static boolean checkAddress(Plant_Utility.addressCapsule addrs){
        if(addrs!=null && !String.isBlank(addrs.country)){
            if(addrs.country.toUpperCase()=='US' || addrs.country.toUpperCase()=='USA' || addrs.country.toUpperCase()=='UNITED STATE'|| addrs.country.toUpperCase()=='UNITED STATE OF AMERICA'|| addrs.country.toUpperCase()=='CANADA' || addrs.country.toUpperCase()=='CA'){
                return true;
            }
            else {
                return false;
            }
        }
        return false;
    }

    // Method**
    // check all order property type and record type Id
    public static Map<String,String> getAvailableOrderType(){
        Map<String,String> returnMap = new Map<String,String>();
        for(recordType rcdTyp: [SELECT id,name from recordType WHERE sObjectType='Plant_Order_Properties__c']){
            returnMap.put(rcdTyp.Name,rcdTyp.Id);
        }
        return returnMap;
    }

    // Method**
    // check is string is number type
    public static Boolean CheckValidInteger(String numbr) {
        return Pattern.matches('^[0-9]+$',numbr);
    }


    // Method**
    // iterate DML result
    public static dmlResultWrap checkDML_Result(List<Database.SaveResult> srList){
        dmlResultWrap result = new dmlResultWrap();
        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
                result.status='success';
                result.messg=''+sr.getId();
            }
            else {
                // Operation failed, so get all errors    
                result.status='error';          
                for(Database.Error err : sr.getErrors()) {
                    System.debug('#### ERROR ');                    
                    result.messg=''+err.getFields()+': '+ err.getMessage();
                }
             } 
        }

        return result;
    }

    // Method**
    // @desc:   Calculate rendom 160 digit text
    public Static String generateRendom(Integer tokenLength){
        final String charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String tempToken = '';
        while (tempToken.length() < tokenLength) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), charset.length());
        tempToken += charset.substring(idx, idx+1);
        }
        return tempToken; 
    }

    // Method**
    // @desc:   Calculate rendom password text
    public Static String rendomPassword(Integer tokenLength){
        final String passSet = '0123456789abcdefghijklmnopqrstuvwxyz@._';
        String tempPass = '';
        while (tempPass.length() < tokenLength) {
        Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), passSet.length());
        tempPass += passSet.substring(idx, idx+1);
        }
        return tempPass; 
    }

    // @wrapper class 0 : 
    // DML result wrapper
    public class dmlResultWrap{
        public string status;
        public string messg;
    }


    // @wrapper class 1 : 
    // wrap method details
    public class classStructureDetail{
        public String methodName;
        public String methodType;
        public String returnType;
        public String parameter;
        public String descripiton;

        // constructor**
        public classStructureDetail(string Name, String Type, String rtnType, String param, String detail){
            this.methodName = Name;
            this.methodType = Type;
            this.returnType = rtnType;
            this.parameter = param;
            this.descripiton = detail;
        }
    }

    // @wrapper class 2 : 
    // wrap response details
    public class responseWrapper{
        public String status;
        public String statusCode;
        public String msg;
        public Plant_Utility.responseListWrapper result;

        // default constructor
        public responseWrapper(){

        }

        // constructor**
        public responseWrapper(String status, String statusCode, String msg, Plant_Utility.responseListWrapper resultPram){
            this.status = status;
            this.statusCode = statusCode;
            this.msg = msg;
            this.result = resultPram;
        }
    }
    

    // @wrapper class 2.1 : 
    // wrap response list 
    public class responseListWrapper{
        public list<Object> resultArr;
        public Map<String,String> resultMap;

        // constructor1**
        public responseListWrapper(list<Object> resultAr){
            this.resultArr = resultAr;
        }

        // constructor2**
        public responseListWrapper(Map<String,String> resultMap){
            this.resultMap = resultMap;
        }
    }

      // @wrapper class 3 :
    // wrap address
    public class addressCapsule{
        public String firstName;
        public String LastName;
        public String street1;
        public String street2;
        public String street3;
        public String city;
        public String state;
        public String zip;
        public String country;
        public String phone;
        public Boolean canSMS;
    }

     // @wrapper class 4:
    // wrap meal json record
    public class wrapMeal{
        public String mealId;
        public String quantity;
        public String mealSelectionMealId; // optional
    }

    // @wrapper class 4.1:
    // wrap sf meal record for response
    public class wrapMeal_RespBody{
        public String meal;
        public String mealId;
        public Integer quantity;
    }

}