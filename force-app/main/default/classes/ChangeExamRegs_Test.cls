@isTest

private class ChangeExamRegs_Test{
    private static testmethod void setupData(){
        Site__c siteObj = new Site__c();
        siteObj.Name = 'Test Site';
        //siteObj.Exam_Date__c = Date.valueOf('2016-11-19');
        siteObj.Site_Code__c = 'ABC';
        siteObj.Exam_Date__c = system.today();
        insert siteObj;
        Exam__c exm = new Exam__c(name='test', Exam__c='ERP Exam Part I', Exam_Date__c=system.today());
        insert exm;
        Exam_Sites__c exSite = new Exam_Sites__c();
        exSite.name = 'test exam';
        exSite.Site__c = siteObj.Id;
        exSite.Exam_Date__c = system.today();
        exSite.Exam__c = exm.Id;
        insert exSite;
    
    }

    private static testmethod void testChangeExamRegsERP(){
        setupData();
        ChangeExamRegs obj = new ChangeExamRegs();
        obj.fromSite = 'ABC';
        obj.fromExamDate = system.today();
        obj.toExamDate =  system.today();
        obj.toSite = 'ABC';
        obj.isErp1 = true;
        obj.noOfrecords = '5';
        obj.ChangeExamRegs();
        obj = new ChangeExamRegs();
        obj.fromSite = 'ABC';
        obj.fromExamDate = system.today();
        obj.toExamDate =  system.today();
        obj.toSite = 'ABC';
        obj.isErp1 = false;
        obj.isErp2 = true;
        obj.noOfrecords = '5';
        obj.ChangeExamRegs();
    }
    private static testmethod void testChangeExamRegsFRM(){
        setupData();
        ChangeExamRegs obj = new ChangeExamRegs();
        obj.fromSite = 'ABC';
        obj.fromExamDate = system.today();
        obj.toExamDate =  system.today();
        obj.toSite = 'ABC';
        obj.isErp1 = false;
        obj.isErp2 = false;
        obj.isFRM1 = false;
        obj.isFRM2 = true;
        obj.noOfrecords = '5';
        obj.ChangeExamRegs();
        obj = new ChangeExamRegs();
        obj.fromSite = 'ABC';
        obj.fromExamDate = system.today();
        obj.toExamDate =  system.today();
        obj.toSite = 'ABC';
        obj.isErp1 = false;
        obj.isErp2 = false;
        obj.isFRM2 = false;
        obj.isFRM1 = true;
        obj.noOfrecords = '5';
        obj.ChangeExamRegs();
    }
    
    
}