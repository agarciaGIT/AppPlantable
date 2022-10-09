@isTest
Public class scheduleexpireScholarship_Test
{
Public static testMethod void MyUnitTest()
{
test.starttest();

scheduleexpireScholarship s1= new scheduleexpireScholarship();
system.schedule('Test Schedule','0 0 0 * * ?',s1);
Test.stoptest();
}

}