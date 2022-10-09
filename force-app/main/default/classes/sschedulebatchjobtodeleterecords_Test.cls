@isTest
Public class sschedulebatchjobtodeleterecords_Test
{
Public static testMethod void MyUnitTest()
{
test.starttest();

schedulebatchjobtodeleterecords s1= new schedulebatchjobtodeleterecords();
system.schedule('Test Schedule','0 0 0 * * ?',s1);
Test.stoptest();
}

}