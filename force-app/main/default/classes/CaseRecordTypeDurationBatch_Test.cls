@isTest
public class CaseRecordTypeDurationBatch_Test {
   
    @testSetup static void createObjects(){
    
     
        
      RecordType rTypeTech = [Select Name, id from RecordType where SObjectType='Case' and isActive = true and Name = 'Tech Request'];
       RecordType rTypeCust = [Select Name, id from RecordType where SObjectType='Case' and isActive = true and Name = 'Customer'];
        datetime useThis = system.now();
        integer hour = useThis.hour() - 2;
        
        case case1 = new case();
        case1.RecordTypeId = rTypeCust.id;
        case1.Status = 'New';
        case1.Origin = 'Email';
       // case1.createddate =system.today()-1;
        insert case1;
        System.debug(case1.LastModifiedDate);
      //  test.setcreatedDate(case1.id,DateTime.newinstance(useThis.year(),useThis.month(),useThis.day(), hour,useThis.minute(),useThis.second()));
        case1.RecordTypeId = rTypeTech.id;
        update case1;
        System.debug(case1.LastModifiedDate);
        System.debug(case1.CreatedDate);
        
    }
    @isTest static  void testAll(){

     
         test.startTest();
        Database.executeBatch(new CaseRecordTypeDurationBatch());
         test.stopTest();

    }
}