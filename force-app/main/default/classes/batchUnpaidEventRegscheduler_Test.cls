@isTest
Public class batchUnpaidEventRegscheduler_Test
{
Public static testMethod void MyUnitTest()
{
test.starttest();

batchUnpaidEventRegscheduler s1= new batchUnpaidEventRegscheduler();
system.schedule('Test Schedule','0 0 0 * * ?',s1);
Test.stoptest();
}

}