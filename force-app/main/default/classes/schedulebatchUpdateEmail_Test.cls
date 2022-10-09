@isTest
Public class schedulebatchUpdateEmail_Test
{
Public static testMethod void MyUnitTest()
{
test.starttest();

schedulebatchUpdateEmail s1= new schedulebatchUpdateEmail();
system.schedule('Test Schedule','0 0 0 * * ?',s1);
Test.stoptest();
}

}