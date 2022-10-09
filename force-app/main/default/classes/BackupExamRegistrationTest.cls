@isTest
public class BackupExamRegistrationTest {
    
    public static List<MongoDbExamRegistration> getMongoDbExamRegistration(){
               
        MongoDbExamRegistration mdber = new MongoDbExamRegistration();
        
        MongoDbExamRegistration.MongoDbExamRegistrationId mdberid = new MongoDbExamRegistration.MongoDbExamRegistrationId();
        
        mdberid.oid = '5cdf2e24d7f80d74fe436fa2';
        
        mdber.id = mdberid;
        mdber.exam = 'FRM Exam Part I'; 
        mdber.examDate = 'November 16; 2019'; 
        mdber.examsite = 'China, Hong Kong'; 
        mdber.examCost = '350';  
        mdber.purchaseDate = '1558130165'; 
        mdber.enrollFee = '400'; 
        mdber.chinaLocationFee = ''; 
        mdber.chinaDataFee = ''; 
        mdber.totalCost = '800'; 
        mdber.fname = 'test'; 
        mdber.lname = 'user'; 
        mdber.email = 'let.me.upgrade.ya@test.com'; 
        mdber.company = 'Test Company'; 
        mdber.addr1 = '111 Town Square Place'; 
        mdber.addr2 = '14th Floor'; 
        mdber.addr3 = 'Jersey City'; 
        mdber.country = 'US'; 
        mdber.city = 'Jersey City'; 
        mdber.state = 'New Jersey'; 
        mdber.zip = '07310'; 
        mdber.phone = '2017197210'; 
        mdber.payment = 'wire'; 
        mdber.regType = 'frm'; 
        mdber.idname = 'test'; 
        mdber.idnum = '123456789'; 
        mdber.idtype = 'Passport'; 
        mdber.idexpr = '2019-05-18T04:00:00.000Z'; 
        mdber.isworking = null; 
        mdber.inschool = null; 
        mdber.school = ''; 
        mdber.degree = ''; 
        mdber.chinesename = ''; 
        mdber.gender = ''; 
        mdber.birthdate = ''; 
        mdber.candidateResponsibility = true;
        
        List<MongoDbExamRegistration> mdbers = new List<MongoDbExamRegistration>{mdber};
            
        return mdbers;
        
    }
    
    @TestSetup
    public static void setup(){
        
       	INSERT new Exam_Date__c(Name = 'Exam Date', Date_String__c = String.valueOf(System.today().addDays(60)));
        
        ExamRegistrationTestDataFactory.setupCaptcha();
        ExamRegistrationTestDataFactory.setupChargent();
		ExamRegistrationTestDataFactory.setupAccountOwner();     
		ExamRegistrationTestDataFactory.setupActivePricebook();
        ExamRegistrationTestDataFactory.setupFeeProducts();
		ExamRegistrationTestDataFactory.setupBookProducts();
		ExamRegistrationTestDataFactory.setupExamRegistrationDependencyObjects();
        
    }
    
    @isTest
    public static void createExamRegistrationFromBackupData(){
                
        BackupExamRegistrationBatch berb = new BackupExamRegistrationBatch(getMongoDbExamRegistration());
        
        database.executeBatch(berb);
        
    }
    
}