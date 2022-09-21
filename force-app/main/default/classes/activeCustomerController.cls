public class activeCustomerController {
    
    public List<Account> activeCustomers  {get; set;}
    public List<Account> inactiveCustomers  {get; set;}
    public List<Account> lapsedCustomers  {get; set;}
    
	public class accountLists {
		@AuraEnabled public List<Account> activeCustomers;
		@AuraEnabled public Integer activeCustomersCnt;
    	@AuraEnabled public List<Account> inactiveCustomers;
		@AuraEnabled public Integer inactiveCustomersCnt;
    	@AuraEnabled public List<Account> lapsedCustomers;
		@AuraEnabled public Integer lapsedCustomersCnt;
        @AuraEnabled public Date selectDate;
    }
    
    public String selectDate {get; set;}
    
    @AuraEnabled
    public static accountLists getData(String inSelectDate) {
        
        accountLists la = new accountLists();
        
		String strStartDate;
		String strEndDate;
        
        Integer sixWeeks = (7*6);
        Integer tweleveMonths = 365;
        
        Date calcDate = Date.parse(inSelectDate);
        la.selectDate = calcDate;
        
        Date startDate = calcDate;
        Date endDate = calcDate.addDays(-sixWeeks);         
        
        system.debug('startDate:' + startDate);
        system.debug('endDate:' + endDate);
            
        List<Opportunity> lstOppActive = [select Id, AccountID from Opportunity where StageName = 'Closed Won' AND closeDate <= :startDate AND closeDate >= :endDate];
        system.debug('lstOppActive:' + lstOppActive);
        
		Set<Id> setAcctAll = new Set<Id>();
        for(Opportunity opp :lstOppActive) {
            setAcctAll.add(opp.AccountID);
        }
        system.debug('setAcctAll:' + setAcctAll);
        
		la.activeCustomers = [select Id, Email__c, First_Name__c, Last_Name__c from Account where Is_Test__c = FALSE AND Id in :setAcctAll];
        la.activeCustomersCnt = la.activeCustomers.size();
        system.debug('activeCustomers:' + la.activeCustomers);
        
        startDate = endDate;
        endDate = calcDate.addDays(-tweleveMonths);
        
        system.debug('startDate:' + startDate);
        system.debug('endDate:' + endDate);
        
        List<Opportunity> lstOppInActive = [select Id, AccountID from Opportunity where StageName = 'Closed Won' AND  AccountID Not In :setAcctAll and closeDate < :startDate AND closeDate >= :endDate];
        system.debug('lstOppInActive:' + lstOppInActive);
        
        Set<Id> setAcctInActive = new Set<Id>();
        for(Opportunity opp :lstOppInActive) {
            setAcctAll.add(opp.AccountID);
            setAcctInActive.add(opp.AccountID);
        }
        system.debug('setAcctAll:' + setAcctAll);
        system.debug('setAcctInActive:' + setAcctAll);
        
        la.inactiveCustomers = [select Id, Email__c, First_Name__c, Last_Name__c from Account where Is_Test__c = FALSE AND  Id in :setAcctInActive];
        la.inactiveCustomersCnt = la.inactiveCustomers.size();
        
        List<Opportunity> lstOppLapsed = [select Id, AccountID from Opportunity where StageName = 'Closed Won' AND  AccountID Not In :setAcctAll and closeDate < :endDate];
		system.debug('lstOppInActive:' + lstOppInActive);
        
        Set<Id> setAcctLapsed = new Set<Id>();
        for(Opportunity opp :lstOppLapsed) {
            setAcctLapsed.add(opp.AccountID);
        }
        system.debug('setAcctLapsed:' + setAcctLapsed);
        
        la.lapsedCustomers = [select Id, Email__c, First_Name__c, Last_Name__c from Account where Is_Test__c = FALSE AND  Id in :setAcctLapsed];        
        la.lapsedCustomersCnt = la.lapsedCustomers.size();
    
        return la;
    }
    
    public activeCustomerController() {  
		selectDate = '11/02/2017';
        
        String inDate = ApexPages.currentPage().getParameters().get('selectDate');
        if(inDate != null) {
            selectDate = inDate.unescapeHtml4();
        }
        
        system.debug('selectDate:' + selectDate);
        
        accountLists la = getData(selectDate);
        
        activeCustomers = la.activeCustomers;
        inactiveCustomers = la.inactiveCustomers;
        lapsedCustomers = la.lapsedCustomers;        
    }

}