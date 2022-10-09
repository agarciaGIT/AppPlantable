@isTest
public class scheduleUpdateMemberPrograms_Test {

    Public static testMethod void MyUnitTest()
    {
    test.starttest();
    scheduleUpdateMemberPrograms s1= new scheduleUpdateMemberPrograms();
    system.schedule('Test Schedule','0 0 0 * * ?',s1);
    Test.stoptest();
    }

    
}