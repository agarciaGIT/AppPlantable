/* Scheduler/Batch for automating PTO Balance for all employees.
 * 06/05/2019 Xiang - [US-22726] Created.
 * Usage: 
 * System.debug('Job Id: ' + System.schedule('PTO Balance Automation Job', '0 30 22 30 12 ?', new PTOBalanceBatch(50, true)));
 */
public without sharing class PTOBalanceBatch implements System.Schedulable, Database.Batchable<SObject>, Database.Stateful {
    
    // As a Schedule Job
    public Integer size {get;private set;}
    public Boolean forUpcomingYear {get;private set;}
    public String testUser {get;private set;}
    public Boolean readOnly {get;private set;}
    
    public PTOBalanceBatch(Integer size, Boolean forUpcomingYear, String testUser, Boolean readOnly) {
        this.size = size;
        this.forUpcomingYear = forUpcomingYear;
        this.testUser = testUser;
        this.readOnly = readOnly;
    }
    
    public void execute(SchedulableContext sc) {
        Database.executeBatch(new PTOBalanceBatch(1, false, NULL, false), this.size);
    }
    
    // As a Batch Job
    public PTOBalanceBatch(Boolean forUpcomingYear) {
        this.forUpcomingYear = forUpcomingYear;
    }
    
    // Get all Active Internal Users (GARP Employees)
    public Database.QueryLocator start(Database.BatchableContext bc) {
    
      if(this.testUser == NULL) {
        return Database.getQueryLocator([SELECT Id, email, Start_Date_with_Company__c, SVP_and_Above__c 
                                         FROM User 
                                         WHERE IsActive = true AND Is_VayKay_User__c = true AND
                                         Start_Date_with_Company__c <> NULL]);
       } else {
        return Database.getQueryLocator([SELECT Id, email, Start_Date_with_Company__c, SVP_and_Above__c 
                                         FROM User 
                                         WHERE IsActive = true AND Id = :this.testUser AND
                                         Start_Date_with_Company__c <> NULL]);       
       
       }
    }
    
    public void execute(Database.BatchableContext BC, List<Sobject> scope) {
        List<User> users = (List<User>)scope;
        Date tdy = system.today();
        System.debug('tdy:' + tdy);
        Date annDateThisYear;
                    
        Integer targetYear = this.forUpcomingYear ? System.today().year() + 1 : System.today().year();
        Date targetDate = this.forUpcomingYear ? Date.newInstance(targetYear, 1, 1) : System.today();
        
        // Setup User Id to Balance Map
        Map<Id, Integer> userIdToBalance = new Map<Id, Integer>();
        
        for(User u : users) {
        
            
            System.debug('user:' + u.email);
            
            Integer balanceDays;
        
            
            if(this.forUpcomingYear) {
                Decimal yearsInCompany = getYearsBetween(u.Start_Date_with_Company__c, targetDate);
                balanceDays = getBalanceDays(yearsInCompany, u.SVP_and_Above__c);
                userIdToBalance.put(u.Id, balanceDays);
                
            } else {
            
                // Only do user who ann is today
                if(u.Start_Date_with_Company__c != NULL) {
                    System.Debug('Start_Date_with_Company__c :' + u.Start_Date_with_Company__c );
                    
                    annDateThisYear = Date.newInstance(tdy.year(), u.Start_Date_with_Company__c.Month(), u.Start_Date_with_Company__c.Day());
                    System.Debug('annDateThisYear :' + annDateThisYear );
                    
                    if(annDateThisYear == tdy) {
                        //Decimal yearsInCompany = getYearsBetween(u.Start_Date_with_Company__c, annDateThisYear);
                        Decimal yearsInCompany = tdy.year() - u.Start_Date_with_Company__c.year();
                        System.Debug('yearsInCompany :' + yearsInCompany );
                        
                        balanceDays = getBalanceDays(yearsInCompany, u.SVP_and_Above__c);
                        System.Debug('balanceDays :' + balanceDays);
                        userIdToBalance.put(u.Id, balanceDays);
                    }
                }
            }
            
        }
        
        System.Debug('userIdToBalance:' + userIdToBalance);
        
        // Gather all Balance for this year and upsert records
        List<Vaykay__Time_Off_Balance__c> newBalanceList = new List<Vaykay__Time_Off_Balance__c>();
        
        List<User> uList = [SELECT Id, Name, Email, Start_Date_with_Company__c,
                            (SELECT Id, Vaykay__Vacation_Days_Allotted__c FROM Vaykay__Time_Off_Balances__r WHERE CALENDAR_YEAR(Vaykay__Balance_Start_Date__c) = :targetYear) 
                            FROM User WHERE Id IN :userIdToBalance.keySet() AND CALENDAR_YEAR(Start_Date_with_Company__c) < :targetYear AND
                            Start_Date_with_Company__c <> NULL];
        
        
        System.Debug('uList :' + uList );
                
        for(User u : uList) {
        
            System.debug('user:' + u.email);            
            
            List<Vaykay__Time_Off_Balance__c> existBalance = u.Vaykay__Time_Off_Balances__r;
            System.Debug('existBalance :' + existBalance );
            
            Vaykay__Time_Off_Balance__c balance = existBalance.size() > 0 ? existBalance[0] : newPTOBalance(u, targetYear);
            System.Debug('new/existing record balance :' + balance);
            
            Decimal userBalance = userIdToBalance.get(u.Id);
            System.Debug('userBalance  :' + userBalance );
            
            annDateThisYear = Date.newInstance(tdy.year(), u.Start_Date_with_Company__c.Month(), u.Start_Date_with_Company__c.Day());
            System.debug('annDateThisYear:' + annDateThisYear);
            
            if(existBalance.size() > 0) {
            
                // If Ann is today and Balance Difference 
                if(existBalance[0].Vaykay__Vacation_Days_Allotted__c == NULL) {
                    existBalance[0].Vaykay__Vacation_Days_Allotted__c = 0;
                }
                if(annDateThisYear == tdy && userBalance != NULL && existBalance[0].Vaykay__Vacation_Days_Allotted__c < userBalance) {
                    Decimal diff = userBalance - existBalance[0].Vaykay__Vacation_Days_Allotted__c;
                    System.debug('diff:' + diff);
                                        
                    Decimal daysLeftInYear = annDateThisYear.daysBetween(Date.newInstance(tdy.year(), 12, 31));
                    System.debug('daysLeftInYear:' + daysLeftInYear );
                    
                    // Prorate the Balance Diff
                    Decimal proDays = (diff / 365) * daysLeftInYear;
                    System.debug('proDays:' + proDays);
                    
                    balance.Vaykay__Vacation_Days_Allotted__c = existBalance[0].Vaykay__Vacation_Days_Allotted__c + proDays;
                    System.Debug('balance update/add:' + balance);
                    newBalanceList.add(balance);
                }
            } else {
                balance.Vaykay__Vacation_Days_Allotted__c = userIdToBalance.get(u.Id);                
                if(this.forUpcomingYear) {
                    balance.Vaykay__Sick_Days_Allotted__c = 6;
                }
                System.Debug('balance update/add:' + balance);
                newBalanceList.add(balance);
            }
            
        }
        
        if(!this.readOnly) {
            upsert newBalanceList;
        }
    }
    
    public void finish(Database.BatchableContext BC) {}
    
    // Utility Methods
    public static Vaykay__Time_Off_Balance__c newPTOBalance(User u, Integer year) {
        Vaykay__Time_Off_Balance__c newPTO = new Vaykay__Time_Off_Balance__c(
            Vaykay__Employee_Name__c = u.Id,
            Name = u.Name + ': 1/1/' + year + ' to 12/31/' + year,
            OwnerId = u.Id,
            Vaykay__Balance_Start_Date__c = Date.newInstance(year, 1, 1),
            Vaykay__Balance_End_Date__c = Date.newInstance(year, 12, 31),
            Vaykay__Year__c = String.valueOf(year),
            Vaykay__Time_Off_Units__c = 'days');
        
        return newPTO;
    }
    
    public static Decimal getYearsBetween(Date startDate, Date targetDate) {
        if(null == startDate) {
            return 0;
        }else {
            Integer daysDiff = startDate.daysBetween(targetDate);
            Decimal yearsInCompany = ((Decimal)daysDiff / 365);
            
            return yearsInCompany;
        }
    }
    
    public static Integer getBalanceDays(Decimal years, Boolean isSVPAbove) {
        Integer balanceDays;
        
        if(years < 3) {
            balanceDays = isSVPAbove ? 20 : 15;
        }else if(3 <= years && years < 8) {
            balanceDays = isSVPAbove ? 25 : 20;
        }else if(8 <= years && years < 13) {
            balanceDays = isSVPAbove ? 30 : 25;
        }else if(13 <= years) {
            balanceDays = 30;
        }
        
        return balanceDays;
    }
}