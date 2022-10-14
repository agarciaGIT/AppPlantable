public class GARP_BC_Courses {

    public static GARP_MS_Courses.getFRRRegistrationInfo GetFRRRegistrationInfo() {
        GARP_MS_Courses.getFRRRegistrationInfo regInfo = new GARP_MS_Courses.getFRRRegistrationInfo();
        
        List<PricebookEntry> lstPricebookEntry = [
                    SELECT Product2.Id, Product2.FRM_Exam__c, Product2.ERP_Exam__c, Product2.Name, Product2.ProductCode, 
            		Product2.GL_Code__c, Product2.Description, Product2.Image__c, Product2.IsActive, Product2.Weight__c, Pricebook2.IsActive, UnitPrice, UseStandardPrice 
                    FROM PriceBookEntry 
                    WHERE Product2.ProductCode in ('MEMI','MEMC','CBRNM','CBR','CBRHB','SHIP')
                ];
        regInfo.Products = new List<GARP_Common.productInfo>();
        for(PricebookEntry pbe :lstPricebookEntry) {
            GARP_Common.productInfo prod = new GARP_Common.productInfo();
            prod.Amount = pbe.UnitPrice;
            prod.GLCode = pbe.Product2.GL_Code__c;
            prod.ProductCode = pbe.Product2.ProductCode;
            prod.ProductName = pbe.Product2.Name;
            regInfo.Products.add(prod);
        }
        
        regInfo.ScreenInfo = new GARP_Common.screenInfo();
        regInfo.ScreenInfo.Locations = [select id, Country__c, LetterCode__c, (select id, name, code__c from Provinces__r Order by Name) from Country_Code__c Order By Country__c];

        GARP_Common.checkAuthentication checkAuth = GARP_Common.CheckAuthentication();
        regInfo.ScreenInfo.IsAuthenticated = checkAuth.isAuthenticated;
        
        if(regInfo.ScreenInfo.IsAuthenticated) {
        	regInfo.existingContactInfo = GARP_Common.getExistingContactInfo(checkAuth.user.ContactId);    
        }
        
        
        return regInfo;
    }
    
    public static GARP_MS_Courses.getFFRRegistrationInfo GetFFRRegistrationInfo() {
        GARP_MS_Courses.getFFRRegistrationInfo regInfo = new GARP_MS_Courses.getFFRRegistrationInfo();
        
        List<PricebookEntry> lstPricebookEntry = [
                    SELECT Product2.Id, Product2.FRM_Exam__c, Product2.ERP_Exam__c, Product2.Name, Product2.ProductCode, 
            		Product2.GL_Code__c, Product2.Description, Product2.Image__c, Product2.IsActive, Product2.Weight__c, Pricebook2.IsActive, UnitPrice, UseStandardPrice 
                    FROM PriceBookEntry 
                    WHERE Pricebook2.Name = 'GARP 2015/2016' AND IsActive = TRUE AND Product2.ProductCode in ('MEMI','MEMC','FCBR','FBRNM','CBRHB','SHIP','PRFEE')
                ];
        regInfo.Products = new List<GARP_Common.productInfo>();
        for(PricebookEntry pbe :lstPricebookEntry) {
            GARP_Common.productInfo prod = new GARP_Common.productInfo();
            prod.Amount = pbe.UnitPrice;
            prod.GLCode = pbe.Product2.GL_Code__c;
            prod.ProductCode = pbe.Product2.ProductCode;
            prod.ProductName = pbe.Product2.Name;
            regInfo.Products.add(prod);
        }
        
        regInfo.ScreenInfo = new GARP_Common.screenInfo();
        regInfo.ScreenInfo.Locations = [select id, Country__c, LetterCode__c, (select id, name, code__c from Provinces__r Order by Name) from Country_Code__c Order By Country__c];

        GARP_Common.checkAuthentication checkAuth = GARP_Common.CheckAuthentication();
        regInfo.ScreenInfo.IsAuthenticated = checkAuth.isAuthenticated;
        
        if(regInfo.ScreenInfo.IsAuthenticated) {
        	regInfo.existingContactInfo = GARP_Common.getExistingContactInfo(checkAuth.user.ContactId);    
        }
        
        regInfo.ScreenInfo.FAQInfo = GARP_Common.getFaqsByCategory('FFR Registration');
        
        return regInfo;
    }
    
}