@isTest
public class LibysnClass_Test {
    Public testMethod static void testAll(){
        Test.startTest();
        scheduleLibsynRSS RSS = new scheduleLibsynRSS();
        String sch = '0 0 0 * * ?';
        system.schedule('Test status Check', sch, RSS );
        Test.stopTest();

    }
}