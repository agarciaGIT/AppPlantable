@isTest

public with sharing class Plant_Utility_Test {
    // @ Default Constructor
    public Plant_Utility_Test() {
        
    }
    // @ Method 1
    public testMethod static void UtilityTest1(){
        
        Plant_Utility.addressCapsule aCapsule = new Plant_Utility.addressCapsule();
        aCapsule.street1 = '200 Park Avenue';
        aCapsule.street2 = 'Midtown'; 
        aCapsule.street3 = 'Manhattan'; 
        aCapsule.city = 'New York';
        aCapsule.state = 'New York'; 
        aCapsule.zip = '54321';
        aCapsule.country = 'USA';
        aCapsule.phone = '+6543749578';
        aCapsule.canSMS = True;

		Plant_Utility.addressCapsule aCapsule1 = new Plant_Utility.addressCapsule();
        aCapsule1.street1 = '200 Park Avenue';
        aCapsule1.street2 = 'Midtown'; 
        aCapsule1.street3 = 'Manhattan'; 
        aCapsule1.city = 'New York';
        aCapsule1.state = 'New York'; 
        aCapsule1.zip = '54321';
        aCapsule1.country = 'India';
        aCapsule1.phone = '+6543749578';
        aCapsule1.canSMS = True;
        
        Plant_Utility.addressCapsule aCapsule2 = new Plant_Utility.addressCapsule();
        
        List<String> l =new List<String>();
        l.add('USA');
        map<String, String> m=new Map<String, String>();
        m.put('abc', 'efg');
        
        Plant_Utility.responseListWrapper pListWrapper= new Plant_Utility.responseListWrapper(l);
        //pListWrapper.resultArr = new Plant_Utility.responseListWrapper(l);
        Plant_Utility.responseListWrapper pListWrapper1 = new Plant_Utility.responseListWrapper(m);
        
        
        String dates=String.valueOf(System.Today());
        
        test.startTest();
        Plant_Utility pUtility = new Plant_Utility();
        Plant_Utility.setMethodEntry('Name', 'Type', 'rtnType', 'param', 'detail');
        Plant_Utility.checkEmail('deshpandey@formail.com');
        Plant_Utility.checkEmail('deshpandeyformail');
        Plant_Utility.checkDateFormat('deshpandey');
        Plant_Utility.checkDateFormat(dates);
        Plant_Utility.checkAddress(aCapsule);
        Plant_Utility.checkAddress(aCapsule1);
        Plant_Utility.checkAddress(aCapsule2);
        Plant_Utility.getAvailableOrderType();
        Plant_Utility.responseWrapper presponseWrapper = new Plant_Utility.responseWrapper('status', 'statusCode', 'msg', pListWrapper); 
        
        //Plant_Utility.responseWrapper('status', 'statusCode', 'msg', pListWrapper1);
        test.stopTest();
    }
}