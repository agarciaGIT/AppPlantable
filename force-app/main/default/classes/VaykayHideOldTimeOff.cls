public class VaykayHideOldTimeOff {
    public static void UpdateVaykayOwner() {

        string year = String.valueOf(Date.Today().Year()-1);
        string fmonth = '01';
        string fday = '01';
        string lmonth = '12';
        string lday = '31';
        string fDate = year + '-' + fmonth + '-' + fday;
        string lDate = year + '-' + lmonth + '-' + lday;
        Date firstDate = date.valueOf(fDate);
        Date LastDate = date.valueOf(lDate);
        List<Vaykay__Time_Off_Balance__c> lst = [select Id, Name, OwnerId,Vaykay__Vacation_Days_Remaining__c 
                                                 from Vaykay__Time_Off_Balance__c 
                                                 where Vaykay__Balance_Start_Date__c >= :firstDate 
                                                 AND Vaykay__Balance_End_Date__c <= :LastDate];
        for(Vaykay__Time_Off_Balance__c vt :lst) {
        	vt.OwnerId = System.Label.VaykayTimeoffUserAssign;
        }
		update lst;
        //return lst;
    }
}