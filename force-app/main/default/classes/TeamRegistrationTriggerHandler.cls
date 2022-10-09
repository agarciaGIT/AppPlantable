public class TeamRegistrationTriggerHandler {
    public static void checkAccessCode(List<Team_Registration__c> regList){
        Set<String> accessCodeSet = new Set<String>();
        Id teamregRecTypeid = RecordTypehelper.getRecordTypeIdFromSchema('Team_Registration__c', 'Team_Registration');
        List<Team_Registration__c> fullRegList = [Select Id,Access_Code__c from Team_Registration__c];
        for(Team_Registration__c reg : fullRegList){
            accessCodeSet.add(reg.Access_Code__c);
        }
        for(Team_Registration__c reg : regList){
            if(string.isBlank(reg.Access_Code__c) && reg.RecordTypeId == teamregRecTypeid){
                string uniqueCode;
                do{
                    uniqueCode = Utilities.getRandomCode();
                }while(accessCodeSet.contains(uniqueCode));
                reg.Access_Code__c = uniqueCode;
            }
        }
        
    }
}