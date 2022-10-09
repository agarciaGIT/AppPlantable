public class TriggerUtilities {
	public static List<Integration_Stream_Event__e> getIntgEvents(Set<Id> recordIds,string objName,string methodName){
        List<Integration_Stream_Event__e> eventList = new List<Integration_Stream_Event__e>();
        for(Id recordId : recordIds){
            Integration_Stream_Event__e evt = new Integration_Stream_Event__e();
            evt.Record_Id__c = recordId;
            evt.Integration_Type__c = methodName;
            evt.Object_Name__c = objName;
            eventList.add(evt);
        }
        
        return eventList;
    }
    
    public static Contact_Update_Event__e getContactEvents(Id recordId,string updType,string newRecord,string oldRecord,string examRegPrgId){
        system.debug('getContactEvents called::>>  '+updType+'  ::   '+recordId);
        Contact_Update_Event__e evt = new Contact_Update_Event__e();
        evt.Record_Id__c = recordId;
        evt.Update_type__c = updType;
        evt.New_Record__c = newRecord;
        evt.Old_Record__c = oldRecord;
        evt.Exam_Reg_Contract_Id__c = examRegPrgId;
        return evt;
    }
}