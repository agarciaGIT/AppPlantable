@isTest 
public class ReportChartControllerTest {
    
    @isTest
    private static void testBatch(){
        Test.startTest();    
        ReportChartController.getreport('00O0x000000G0G6EAK',null, false);
        Test.stopTest(); 
    }

}