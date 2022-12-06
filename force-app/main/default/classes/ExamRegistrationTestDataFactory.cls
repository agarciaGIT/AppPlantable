@isTest
public class ExamRegistrationTestDataFactory {
    
    @TestVisible private static Id pricebookId = null;
    
    @TestVisible private static void setupCaptcha(){
        
        CAPTCHA_Configuration__c captchaConfigurations = new CAPTCHA_Configuration__c(
            Name = 'Exam Registration',
            Enabled__c = true,
            Submission_Speed_Threshold__c = 0
        );
        
        INSERT captchaConfigurations;
        
    }
    
    @TestVisible private static void setupChargent(){
        
        //CHARGENT
        ChargentBase__Gateway__c chargentGateway = new ChargentBase__Gateway__c(
            Name = 'Test',
            //ChargentBase__Merchant_ID__c = 'dasghjtru548709-4',
            ChargentBase__Active__c = true,
            ChargentBase__Available_Payment_Methods__c = 'Credit Card'
        );
        
        INSERT chargentGateway;
        INSERT new UpdateIds__c(Name = 'GARP', Record_Id__c = chargentGateway.Id);
        
    }
    
    @TestVisible private static void setupAccountOwner(){
        
        //ACCOUNT OWNER
        INSERT new UpdateIds__c(Name='User', Record_Id__c='00540000001y7OX'); 
        
    }
    
    @TestVisible private static void setupActivePricebook(){
        
        Pricebook2 activePricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = TRUE
        );
        
        UPDATE activePricebook;
        
        pricebookId = activePricebook.Id;
        
    }
    
    @TestVisible private static void setupFeeProducts(){
        
        //FEES
        Product2 AFREE = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'AFREE', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 FRM1 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'FRM1', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 ENC = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'ENC', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);        
        Product2 CHLF = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'CHLF', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 MEMF = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'MEMF', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 PRFEE = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'PRFEE', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 SLSTX = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'SLSTX', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 CDNTAX = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'CDNTAX', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 CHNDF = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'CHNDF', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);  
        Product2 SHIP = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'SHIP', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);        
        Product2 SAFRM1 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'SAFRM1', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 SAFRM2 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'SAFRM2', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 SAERP1 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'SAERP1', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);
        Product2 SAERP2 = new Product2(Company__c = 'GARP', Name = 'Laptop X200', ProductCode = 'SAERP2', GL_Code__c = '4999', Family = 'Hardware', IsActive = true);        
        
        INSERT new List<Product2>{
            AFREE, 
            FRM1, 
            ENC, 
            CHLF, 
            MEMF, 
            PRFEE, 
            SLSTX, 
            CDNTAX, 
            CHNDF, 
            SHIP, 
            SAFRM1, 
            SAFRM2, 
            SAERP1, 
            SAERP2
        };
        
        PricebookEntry AFREEPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = AFREE.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry FRM1PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRM1.Id, UnitPrice = 400, IsActive = true);
        PricebookEntry ENCPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = ENC.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry CHLFPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = CHLF.Id, UnitPrice = 40, IsActive = true);
        PricebookEntry MEMFPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = MEMF.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry PRFEEPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = PRFEE.Id, UnitPrice = 50, IsActive = true);
        PricebookEntry SLSTXPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SLSTX.Id, UnitPrice = 15.23, IsActive = true);
        PricebookEntry CDNTAXPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = CDNTAX.Id, UnitPrice = 22, IsActive = true);
        PricebookEntry CHNDFPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = CHNDF.Id, UnitPrice = 10, IsActive = true);
        PricebookEntry SHIPPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SHIP.Id, UnitPrice = 21.34, IsActive = true);
        PricebookEntry SAFRM1PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SAFRM1.Id, UnitPrice = 0, IsActive = true);
        PricebookEntry SAFRM2PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SAFRM2.Id, UnitPrice = 0, IsActive = true);
        PricebookEntry SAERP1PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SAERP1.Id, UnitPrice = 0, IsActive = true);
        PricebookEntry SAERP2PBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SAERP2.Id, UnitPrice = 0, IsActive = true);        

        INSERT new List<PricebookEntry>{
            AFREEPBE,
            FRM1PBE,
            ENCPBE,
            CHLFPBE,
            MEMFPBE,
            PRFEEPBE,
            SLSTXPBE,
            CDNTAXPBE,
            CHNDFPBE,
            SHIPPBE,        
            SAFRM1PBE,
            SAFRM2PBE,
            SAERP1PBE,
            SAERP2PBE
        };
        
    }
    
    @TestVisible private static void setupBookProducts(){
        
        //EBOOKS
        Product2 FRM1X = new Product2(Company__c = 'GARP', Taxable__c = true, Name = 'Laptop X200', productCode = 'FRM1X', GL_Code__c = '4999', Family = 'Books', isActive = true);
        Product2 FRM2X = new Product2(Company__c = 'GARP', Taxable__c = true, Name = 'Laptop X200', productCode = 'FRM2X', GL_Code__c = '4999', Family = 'Books', isActive = true);
        Product2 ERP1X = new Product2(Company__c = 'GARP', Taxable__c = true, Name = 'Laptop X200', productCode = 'ERP1X', GL_Code__c = '4999', Family = 'Books', isActive = true);
        Product2 ERP2X = new Product2(Company__c = 'GARP', Taxable__c = true, Name = 'Laptop X200', productCode = 'ERP2X', GL_Code__c = '4999', Family = 'Books', isActive = true);

        Product2 SCRX = new Product2(Company__c = 'GARP', Taxable__c = true, Name = 'Laptop X200', productCode = 'SCRX', GL_Code__c = '4999', Family = 'Books', isActive = true);

        
        //BOOKS
        Product2 FRM1H = new Product2(Company__c = 'GARP', Weight__c = 1.0, Taxable__c = true, Name = 'Laptop X200', productCode = 'FRM1H', GL_Code__c = '4999', Family = 'Books', isActive = true);

        INSERT new List<Product2>{ FRM1X, FRM2X, ERP1X, ERP2X, SCRX, FRM1H };
        
        //EBOOKS
        PricebookEntry FRM1XPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRM1X.Id, UnitPrice = 10000, IsActive = true);        
        PricebookEntry FRM2XPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRM2X.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry ERP1XPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = ERP1X.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry ERP2XPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = ERP2X.Id, UnitPrice = 10000, IsActive = true);
        PricebookEntry SCRXPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = SCRX.Id, UnitPrice = 10000, IsActive = true);
        
        //BOOKS
        PricebookEntry FRM1HPBE = new PricebookEntry(Pricebook2Id = pricebookId, Product2Id = FRM1H.Id, UnitPrice = 10000, IsActive = true);     

        INSERT new List<PricebookEntry>{ FRM1XPBE, FRM2XPBE, ERP1XPBE, ERP2XPBE, FRM1HPBE };
        
    }
    
    @TestVisible private static void setupExamRegistrationDependencyObjects(){
        
        //SITES AND EXAMS
        Site__c chinaHongKong = new Site__c(
            name = 'China, Hong Kong',
            Display_Address__c = 'China, Hong Kong',
            Active__c = true,
            Non_selectable__c = false,
            Is_OSTA_Information_Required__c = false,
            AM_Exam_Max_Capacity__c = 10,
            PM_Exam_Max_Capacity__c = 10
        );
        
        Site__c chinaNanjing = new Site__c(
            name = 'China, Nanjing',
            Display_Address__c = 'China, Nanjing',
            Active__c = true,
            Non_selectable__c = false,
            Is_OSTA_Information_Required__c = true,
            AM_Exam_Max_Capacity__c = 10,
            PM_Exam_Max_Capacity__c = 10
        );        
        
        INSERT new List<Site__c>{chinaHongKong, chinaNanjing}; 
        
        Exam_Group__c examGroup = new Exam_Group__c(
            Active__c = TRUE,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Exam_Group__c', 'FRM/ERP'),
            Exam_Date__c = System.today().addDays(60),
            Registration_Start_Date__c = System.today().addDays(-10),
            Last_Date_For_Early_Registration__c = System.today().addDays(10),
            Last_Date_For_Standard_Registration__c = System.today().addDays(20),
            Last_Date_For_Late_Registration__c = System.today().addDays(30)
        );
        INSERT examGroup;
        
        Exam_Registration_Window__c examRegistrationWindow = new Exam_Registration_Window__c(
            Exam_Group__c = examGroup.Id,
            Type__c = 'Early',
            Exam_Registration_Window_Open__c = system.today().addDays(-30), 
            Exam_Registration_Window_Close__c = system.today().addDays(30)        
        );
        INSERT examRegistrationWindow;
        
        //FRM
        Exam__c frmExamPart1 = new Exam__c(
            Exam_Group__c = examGroup.Id,
            Exam_Date__c = System.today().addDays(60),
            Exam__c = 'FRM Part 1',
            Name = 'FRM Exam Part I'
        );
        INSERT frmExamPart1;
        
        Product2 frmExamPart1StandardProduct = new Product2(
            Name = 'FRM PART 1 STANDARD REGISTRATION',
            Company__c = 'GARP', 
            ProductCode = 'FRM1S',
            GL_Code__c = '4999',
            Family = 'Exams',
            isActive = true
        );        
        INSERT frmExamPart1StandardProduct; 
        
        PricebookEntry frmExamPart1StandardPricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = frmExamPart1StandardProduct.Id, 
            UnitPrice = 350, 
            UseStandardPrice = FALSE,
            IsActive = true
        );
        INSERT frmExamPart1StandardPricebookEntry;
        
        Exam_Administration__c examAdmin = new Exam_Administration__c();
        examAdmin.Exam_Group__c = examGroup.id;
        examAdmin.Exam_Date__c = system.today();
        insert examAdmin;
        
        Exam_Part__c examPart = new Exam_Part__c();
        examPart.Exam__c = frmExamPart1.id;
        examPart.Exam_Administration__c = examAdmin.id;
        examPart.Exam_Date__c = system.today();
        examPart.Delivery_Method__c = 'CBT';
        insert examPart;
        
        Exam_Rate__c frmExamPart1ExamRate = new Exam_Rate__c(
            Exam_Registration_Window__c = examRegistrationWindow.Id,
            Exam__c = frmExamPart1.Id,
            Product__c = frmExamPart1StandardProduct.Id,
            Exam_Administration__c = examAdmin.id
        );
        INSERT frmExamPart1ExamRate;
        
        Exam_Sites__c frmExamPart1SiteChinaHongKong = new Exam_Sites__c(
            Site__c = chinaHongKong.Id, 
            Exam__c = frmExamPart1.Id,
            Exam_Part__c = examPart.id
        );     
        
        Exam_Sites__c frmExamPart1SiteChinaNanjing = new Exam_Sites__c(
            Site__c = chinaNanjing.Id, 
            Exam__c = frmExamPart1.Id,
            Exam_Part__c = examPart.id
        );        
        
        //INSERT new List<Exam_Sites__c>{frmExamPart1SiteChinaHongKong, frmExamPart1SiteChinaNanjing};
        
        Exam__c frmExamPart2 = new Exam__c(
            Exam_Group__c = examGroup.Id,
            Exam_Date__c = System.today().addDays(60),
            Exam__c = 'FRM Part 2',
            Name = 'FRM Exam Part II'
        );
        INSERT frmExamPart2;
        
        Product2 frmExamPart2StandardProduct = new Product2(
            Name = 'FRM PART 2 STANDARD REGISTRATION',
            Company__c = 'GARP',
            ProductCode = 'FRM2S',
            GL_Code__c = '4999',
            Family = 'Exams',
            isActive = true
        );        
        INSERT frmExamPart2StandardProduct; 
        
        PricebookEntry frmExamPart2StandardPricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = frmExamPart2StandardProduct.Id, 
            UnitPrice = 350, 
            UseStandardPrice = FALSE,
            IsActive = true
        );
        INSERT frmExamPart2StandardPricebookEntry;
        
        Exam_Part__c examPart2 = new Exam_Part__c();
        examPart2.Exam__c = frmExamPart2.id;
        examPart2.Exam_Administration__c = examAdmin.id;
        examPart2.Exam_Date__c = system.today();
        examPart2.Delivery_Method__c = 'CBT';
        insert examPart2;
        
        Exam_Rate__c frmExamPart2ExamRate = new Exam_Rate__c(
            Exam_Registration_Window__c = examRegistrationWindow.Id,
            Exam__c = frmExamPart2.Id,
            Product__c = frmExamPart2StandardProduct.Id,
            Exam_Administration__c = examAdmin.id
            
        );
        INSERT frmExamPart2ExamRate;
        
        Exam_Sites__c frmExamPart2SiteChinaHongKong = new Exam_Sites__c(
            Site__c = chinaHongKong.Id, 
            Exam__c = frmExamPart2.Id,
            Exam_Part__c = examPart2.id
            
        );    
        
        Exam_Sites__c frmExamPart2SiteChinaNanjing = new Exam_Sites__c(
            Site__c = chinaNanjing.Id, 
            Exam__c = frmExamPart2.Id,
            Exam_Part__c = examPart2.id
        );        
        
        //INSERT new List<Exam_Sites__c>{frmExamPart2SiteChinaHongKong, frmExamPart2SiteChinaNanjing};
        
        //ERP
        Exam__c erpExamPart1 = new Exam__c(
            Exam_Group__c = examGroup.Id,
            Exam_Date__c = System.today().addDays(60),
            Exam__c = 'ERP Exam Part I',
            Name = 'ERP Exam Part I' 
        );
        INSERT erpExamPart1;
        
        Product2 erpExamPart1StandardProduct = new Product2(
            Name = 'ERP PART 1 STANDARD REGISTRATION',
            Company__c = 'GARP', 
            ProductCode = 'ENC1S',
            GL_Code__c = '4999',
            Family = 'Exams',
            isActive = true
        );        
        INSERT erpExamPart1StandardProduct; 
        
        PricebookEntry erpExamPart1StandardPricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = erpExamPart1StandardProduct.Id, 
            UnitPrice = 12000, 
            UseStandardPrice = FALSE,
            IsActive = true
        );
        INSERT erpExamPart1StandardPricebookEntry;
        
        Exam_Part__c examPart3 = new Exam_Part__c();
        examPart3.Exam__c = erpExamPart1.id;
        examPart3.Exam_Administration__c = examAdmin.id;
        examPart3.Exam_Date__c = system.today();
        examPart3.Delivery_Method__c = 'CBT';
        insert examPart3;
        
        Exam_Rate__c erpExamPart1ExamRate = new Exam_Rate__c(
            Exam_Registration_Window__c = examRegistrationWindow.Id,
            Exam__c = erpExamPart1.Id,
            Product__c = erpExamPart1StandardProduct.Id,
            Exam_Administration__c = examAdmin.id
        );
        INSERT erpExamPart1ExamRate;
        
        Exam_Sites__c erpExamPart1SiteChinaHingKong = new Exam_Sites__c(
            Site__c = chinaHongKong.Id, 
            Exam__c = erpExamPart1.Id,
            Exam_Part__c = examPart3.id
        );       
        
        Exam_Sites__c erpExamPart1SiteChinaNanjing = new Exam_Sites__c(
            Site__c = chinaNanjing.Id, 
            Exam__c = erpExamPart1.Id,
            Exam_Part__c = examPart3.id
        );          
        
        //INSERT new List<Exam_Sites__c>{erpExamPart1SiteChinaHingKong, erpExamPart1SiteChinaNanjing};
        
        Exam__c erpExamPart2 = new Exam__c(
            Exam_Group__c = examGroup.Id,
            Exam_Date__c = System.today().addDays(60),
            Exam__c = 'ERP Exam Part II',
            Name = 'ERP Exam Part II' 
        );
        INSERT erpExamPart2;
        
        Product2 erpExamPart2StandardProduct = new Product2(
            Name = 'ERP PART 2 STANDARD REGISTRATION',
            Company__c = 'GARP',
            ProductCode = 'ENC2S',
            GL_Code__c = '4999',
            Family = 'Exams',
            isActive = true
        );        
        INSERT erpExamPart2StandardProduct; 
        
        PricebookEntry erpExamPart2StandardPricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = erpExamPart2StandardProduct.Id, 
            UnitPrice = 12000, 
            UseStandardPrice = FALSE,
            IsActive = true
        );
        INSERT erpExamPart2StandardPricebookEntry;
        
        Exam_Rate__c erpExamPart2ExamRate = new Exam_Rate__c(
            Exam_Registration_Window__c = examRegistrationWindow.Id,
            Exam__c = erpExamPart2.Id,
            Product__c = erpExamPart2StandardProduct.Id
        );
        INSERT erpExamPart2ExamRate;
        
        Exam_Sites__c erpExamPart2SiteChinaHongKong = new Exam_Sites__c(
            Site__c = chinaHongKong.Id, 
            Exam__c = erpExamPart2.Id
        );       
        
        Exam_Sites__c erpExamPart2SiteChinaNanjing = new Exam_Sites__c(
            Site__c = chinaNanjing.Id, 
            Exam__c = erpExamPart2.Id
        );   
        
        // SCR
        Exam_Group__c examGroupSCR = new Exam_Group__c(
            SCR_Active__c = TRUE,
            RecordTypeId = RecordTypeHelper.GetRecordTypeId('Exam_Group__c', 'SCR'),
            Exam_Date__c = System.today().addDays(60),
            Registration_Start_Date__c = System.today().addDays(-10),
            Last_Date_For_Early_Registration__c = System.today().addDays(10),
            Last_Date_For_Standard_Registration__c = System.today().addDays(20),
            Last_Date_For_Late_Registration__c = System.today().addDays(30)
        );
        INSERT examGroupSCR;
        
        Exam_Registration_Window__c examRegistrationWindowSCR = new Exam_Registration_Window__c(
            Exam_Group__c = examGroupSCR.Id,
            Type__c = 'Early',
            Exam_Registration_Window_Open__c = system.today().addDays(-30), 
            Exam_Registration_Window_Close__c = system.today().addDays(30)        
        );
        INSERT examRegistrationWindowSCR;
        
        Exam__c scrExam = new Exam__c(
            Exam_Group__c = examGroupSCR.Id,
            Exam_Date__c = System.today().addDays(60),
            Exam__c = 'SCR',
            Name = 'SCR'
        );
        INSERT scrExam;
        
        Product2 scrExamStandardProduct = new Product2(
            Name = 'SCR STANDARD REGISTRATION',
            Company__c = 'GARP', 
            ProductCode = 'SCRNMS',
            GL_Code__c = '4005',
            Family = 'Exams',
            isActive = true
        );        
        INSERT scrExamStandardProduct; 
        
        PricebookEntry scrExamStandardPricebookEntry = new PricebookEntry(
            Pricebook2Id = pricebookId, 
            Product2Id = scrExamStandardProduct.Id, 
            UnitPrice = 350, 
            UseStandardPrice = FALSE,
            IsActive = true
        );
        INSERT scrExamStandardPricebookEntry;
        
        Exam_Administration__c examAdminSCR = new Exam_Administration__c();
        examAdminSCR.Exam_Group__c = examGroupSCR.id;
        examAdminSCR.Exam_Date__c = system.today();
        insert examAdminSCR;
        
        Exam_Part__c examPartSCR = new Exam_Part__c();
        examPartSCR.Exam__c = scrExam.id;
        examPartSCR.Exam_Administration__c = examAdminSCR.id;
        examPartSCR.Exam_Date__c = system.today();
        examPartSCR.Delivery_Method__c = 'CBT';
        insert examPartSCR;
        
        Exam_Rate__c scrExamPartExamRate = new Exam_Rate__c(
            Exam_Registration_Window__c = examRegistrationWindowSCR.Id,
            Exam__c = scrExam.Id,
            Product__c = scrExamStandardProduct.Id,
            Exam_Administration__c = examAdminSCR.id,
            Rate_Type__c = 'Non-Member'
        );
        INSERT scrExamPartExamRate;

        Exam_Rate__c scrExamPartExamRateMember = new Exam_Rate__c(
            Exam_Registration_Window__c = examRegistrationWindowSCR.Id,
            Exam__c = scrExam.Id,
            Product__c = scrExamStandardProduct.Id,
            Exam_Administration__c = examAdminSCR.id,
            Rate_Type__c = 'Member'
        );
        INSERT scrExamPartExamRateMember;
        
        Exam_Sites__c scrExamPartSiteChinaHongKong = new Exam_Sites__c(
            Site__c = chinaHongKong.Id, 
            Exam__c = scrExam.Id,
            Exam_Part__c = examPartSCR.id
        );     
        
        Exam_Sites__c scrExamPartSiteChinaNanjing = new Exam_Sites__c(
            Site__c = chinaNanjing.Id, 
            Exam__c = scrExam.Id,
            Exam_Part__c = examPartSCR.id
        );                
        
        
        INSERT new List<Exam_Sites__c>{scrExamPartSiteChinaHongKong, scrExamPartSiteChinaNanjing, frmExamPart1SiteChinaHongKong, frmExamPart1SiteChinaNanjing, frmExamPart2SiteChinaHongKong, frmExamPart2SiteChinaNanjing, erpExamPart1SiteChinaHingKong, erpExamPart1SiteChinaNanjing, erpExamPart2SiteChinaHongKong, erpExamPart2SiteChinaNanjing};
          
        List<Team_Registration_Products__c> prodCodes = new List<Team_Registration_Products__c>();
        Team_Registration_Products__c prod1 = new Team_Registration_Products__c();
        prod1.Name = 'SCRNMS';
        prod1.Product_Code__c = 'SCRNMS';
        prod1.GL_Code__c = '4005';
        prod1.Replacement_Product_Id__c = scrExamStandardProduct.id;
        prod1.Replacement_Product_Price_Id__c = scrExamStandardPricebookEntry.id;
        prodCodes.add(prod1);
        insert prodCodes;
            
        
    }

    @TestVisible private static User createAffiliateContact(){

        Account account = new Account();
        account.Name = 'TEST';
        account.OwnerId = [SELECT Id, Record_id__c FROM updateids__c WHERE name = 'User' LIMIT 1].Record_id__c;
        account.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Account', 'Individual');
        INSERT account;

        Opportunity opportunity = new Opportunity(
            Name = 'Affiliate Membership',
            AccountId = account.Id,
            Eligible_for_Membership_Extension__c = TRUE,
            CloseDate = Date.today(),
            StageName = 'New Lead',
            RecordTypeID = RecordTypeHelper.GetRecordTypeId('Opportunity', 'Automated')
        );

        INSERT opportunity;

        PricebookEntry pbe = [SELECT Id, Product2Id FROM PricebookEntry WHERE ProductCode = 'AFREE' LIMIT 1];

        OpportunityLineItem affiliateMembershipOpportunityOli = new OpportunityLineItem( 
            OpportunityId       = opportunity.Id,                          
            PricebookEntryId    = pbe.Id,
            Product2Id          = pbe.Product2Id,
            UnitPrice           = 0,
            Quantity            = 1,
            Description         = 'Affiliate Membership'
        );

        INSERT affiliateMembershipOpportunityOli;

        Contact contact = new Contact();
        contact.AccountId = account.Id;
        contact.Email = 'test.user.1234@garpqa.com';
        contact.FirstName = 'TEST';
        contact.LastName = 'TEST';
        contact.RecordTypeId = RecordTypeHelper.GetRecordTypeId('Contact', 'Member');
        INSERT contact;

        Contract membershipContract = new Contract(
            Name = 'Affiliate Membership',
            AccountId = account.Id,
            Opportunity__c = opportunity.Id,
            CustomerSignedId = contact.Id,
            StartDate = System.Today(),
            ContractTerm = 12,
            Membership_Type__c = 'Affiliate',
            RecordTypeID = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership')
        );
        
        INSERT membershipContract;

        opportunity.StageName = 'Closed';

        UPDATE opportunity;
        
        List<User> users =  [
            SELECT Id, ContactId, AccountId
            FROM User 
            WHERE ContactId = :contact.Id LIMIT 1
        ];
        
        System.debug(users);
        
        if(users.isEmpty()){
            return null;
        }else{
            return users[0];
        }

    }
    

    @TestVisible private static User createExamRegistration(String examType, String paymentMethod, String username, Boolean isCombinedPartIAndPartII, Boolean isChinaExamSite){
        //Exam_Sites__c examSite = [Select Id,Exam_Part__c,Site__c,Exam__c from Exam_Sites__c where Exam_Part__c != null Limit 1];
        //Exam_Part__c examPart = [Select Id,Exam__c,Exam_Administration__c from Exam_Part__c where Id =: examSite.Exam_Part__c Limit 1];
        Exam__c exam = [Select Id,(Select Id,Name,Exam_Part__c,Site__c,Site__r.Name,Exam__c,Exam__r.Administration_Time_of_Day__c,Site__r.AM_Exam_Capacity_Available__c,Site__r.PM_Exam_Capacity_Available__c from Exam_Events__r where Exam_Part__c != null),(Select Id,Exam__c,Exam_Administration__c from Exam_Parts__r) from Exam__c where Exam__c Like :('%'+examType+'%') Limit 1];
        List<PricebookEntry> pbeList = [Select Id,Pricebook2Id,Product2Id,Product2.Name,UnitPrice,Product_ID__c,ProductCode,IsActive from PricebookEntry where Product2.Family = 'Exams'];
        
        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());

        Response.Detail res = ExamRegistrationFormRemoter.fetchExamRegistrationFormData(examType,null);
        
        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());

        System.debug(res);
        System.debug(res.data);
        ExamRegistrationForm.ViewModel vm = (ExamRegistrationForm.ViewModel)res.data;
        
        Lead lead = new Lead();
        
        lead.FirstName = username;
        lead.LastName = username;
        lead.Email = username + '@test.com';
        
        Response.Detail upsertLeadRes = RegistrationFormLeadRemoter.upsertLead(JSON.serialize(lead), 'test-form-key');

        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        System.debug('Lead'+upsertLeadRes.data);
        Lead createdLead = (Lead)upsertLeadRes.data;
        
        createdLead.Phone = '1234567890';
        createdLead.ID_Type__c = 'Passport';
        createdLead.ID_Number__c = '1234567890';
        createdLead.Name_as_it_Appears_on_ID__c = username;
        createdLead.Billing_Address_1__c = '123 SAMPLE STREET';
        createdLead.Billing_City__c = 'SAMPLE CITY';
        createdLead.Billing_State__c = 'NJ';
        createdLead.Billing_Company__c = 'TEST CO';
        createdLead.Billing_Phone_Number__c = '1234567890';
        createdLead.Billing_Country__c = 'United StatesS';
        createdLead.Billing_Postal_Code__c = '07310';
        createdLead.Shipping_Address_1__c = '123 SAMPLE STREET';
        createdLead.Shipping_City__c = 'SAMPLE CITY';
        createdLead.Shipping_State__c = 'NJ';
        createdLead.Shipping_Company__c = 'TEST CO';
        createdLead.Shipping_Phone_Number__c = '1234567890';
        createdLead.Shipping_Country__c = 'United States';
        createdLead.Shipping_Postal_Code__c = '07310';
        createdLead.Payment_Type__c = paymentMethod;
        createdLead.Shipping_Address_Same_as_Billing_Address__c = FALSE;
        
        ExamRegistrationForm.RegistrationRequest registrationRequest = new ExamRegistrationForm.RegistrationRequest();
        
        registrationRequest.token = vm.token;
        registrationRequest.lead = createdLead;
        registrationRequest.registrationType = examType;
        registrationRequest.products = new Map<String, ExamRegistrationForm.Item>();
        
        ExamSelectionOptions.Site esoSite = new ExamSelectionOptions.Site();
        esoSite.id = exam.Exam_Events__r[0].Id;
        esoSite.label = 'Exam Site';
        esoSite.examSite = exam.Exam_Events__r[0];
        
        ExamSelectionOptions.ExamPart part = new ExamSelectionOptions.ExamPart();
        part.id = exam.Exam_Parts__r[0].Id;
        part.label = 'Exam Part';
        part.examPart = exam.Exam_Parts__r[0];
        
        ExamSelectionOptions.ExamPricebookEntry pbe = new ExamSelectionOptions.ExamPricebookEntry();
        pbe.id = pbeList[0].Id;
        pbe.exam = exam;
        pbe.examAdminID = exam.Exam_Parts__r[0].Exam_Administration__c;
        pbe.pricebookEntry = pbeList[0];
        pbe.rateType = 'Member';
        
        ExamSelectionOptions.Exam esoExam = new ExamSelectionOptions.Exam();
        esoExam.id = exam.Id;
        esoExam.label = 'FRM';
        esoExam.exam = exam;
        esoExam.examParts = new List<ExamSelectionOptions.ExamPart>{part};
        esoExam.examPricebookEntry = pbe;
        
        ExamRegistrationForm.Selection selection = new ExamRegistrationForm.Selection();
        selection.site = esoSite;
        selection.examPart = part;
        selection.exam = esoExam;
        
        registrationRequest.selections = new List<ExamRegistrationForm.Selection>{selection};
        
        String registrationRequestJSON = JSON.serialize(registrationRequest);
        
        Response.Detail responseDetailObject = ExamRegistrationFormRemoter.createExamRegistrationOrder(examType, registrationRequestJSON);

        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        
        System.debug(responseDetailObject); 
        
        ExamRegistrationForm.RegistrationResponse registrationResponse = (ExamRegistrationForm.RegistrationResponse)responseDetailObject.data;
        
        System.debug(registrationResponse);
        
        Lead convertedLead = (Lead)registrationResponse.lead;
        convertedLead.Payment_Type__c = paymentMethod;
        
        System.debug(convertedLead);
        
        ExamRegistrationForm.ChargeRequest chargeRequest = new ExamRegistrationForm.ChargeRequest();
        
        ExamRegistrationForm.Card card = new ExamRegistrationForm.Card();
        
        card.expirationMonth = '01';
        card.expirationYear = '2025';
        card.fullName = username;
        card.cardNumber = '4111111111111111';
        card.securityCode = '123';
        
        chargeRequest.token = vm.token;
        chargeRequest.card = card;
        chargeRequest.lead = convertedLead;
        chargeRequest.registrationType = examType;
        
        String chargeRequestJSON = JSON.serialize(chargeRequest);
        
        ContactTriggerHandler.stopRecurssion = false;
        Response.Detail chargeResponse = ExamRegistrationFormRemoter.payExamRegistrationOrder(examType, chargeRequestJSON); 
        
        System.debug(chargeResponse);

        System.debug(convertedLead);
        
        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());

        List<User> users =  [
            SELECT Id, ContactId, AccountId
            FROM User 
            WHERE ContactId = :convertedLead.ConvertedContactId LIMIT 1
        ];

        System.debug('SOQL queries: ' + Limits.getQueries() + '/' + Limits.getLimitQueries());
        
        System.debug(users);
        
        if(users.isEmpty()){
            return null;
        }else{
            return users[0];
        }
        
    }
    
}