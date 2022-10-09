global class batchMembershipHistory implements Database.Batchable<sObject>{
    
    public Integer year;  
    public String mode;  
    
    global batchMembershipHistory(Integer year, String mode){
        this.year = year;
        this.mode= mode;        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  
        Integer inYear = this.year;

        // Setup Rollup Data
        //List<Reporting_Snapshot_Membership__c> lstMemRollups = [select Id, Name, Year__c from Reporting_Snapshot_Membership__c where Year__c != null];
        //delete lstMemRollups;       
        //
        String mtype = 'Individual';
        if(mode == 'batch') {        
            return Database.getQueryLocator('select Id, Name, AccountID, MailingCountry, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c != null AND batch__c = true');
        } else if(mode != NULL) {   
            return Database.getQueryLocator('select Id, Name, AccountID, MailingCountry, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c != null AND id = :mode');
        } else {
            return Database.getQueryLocator('select Id, Name, AccountID, MailingCountry, Membership_Status_By_Year__c, Membership_Duration__c, Membership_2015_Status__c, Membership_2016_Status__c, Membership_2017_Status__c, Membership_2018_Status__c from Contact where Membership_Type__c = :mtype AND Membership_Status_By_Year__c != null');
        }
    }    
    
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        
        MAP<String,Integer> mapContCtry = new MAP<String,Integer>();
        MAP<String,String> mapCountryCodes = new MAP<String,String>();
        List<Country_Code__c> lstCC = [select Id, Country__c, LetterCode__c from Country_Code__c];
        for(Country_Code__c cc :lstCC) {
            mapCountryCodes.put(cc.LetterCode__c, cc.Country__c);
        }
                
        for(Contact c :scope) {
            
            String acctCountry = c.MailingCountry;
            if(acctCountry == NULL || acctCountry == '&nbsp;' || acctCountry == 'null' || acctCountry == '208')
                acctCountry = 'Unknown';
            
            String counrtyMap = mapCountryCodes.get(acctCountry);
            if(counrtyMap != NULL) {
                acctCountry = counrtyMap;
            }

            if(acctCountry == 'USA' || acctCountry == 'United States' || acctCountry.toLowerCase() == 'united states of america') {
                acctCountry = 'United States of America';
            }
            
            if( c.Membership_2015_Status__c != NULL) {
                String key = '2015~' + acctCountry + '~' + c.Membership_2015_Status__c;
                Integer fnd = mapContCtry.get(key);
                if(fnd == NULL) {
                    mapContCtry.put(key, 1);
                } else {
                    fnd++;
                    mapContCtry.put(key, fnd);
                }
            }
            if( c.Membership_2016_Status__c != NULL) {
                String key = '2016~' + acctCountry + '~' + c.Membership_2016_Status__c;
                Integer fnd = mapContCtry.get(key);
                if(fnd == NULL) {
                    mapContCtry.put(key, 1);
                } else {
                    fnd++;
                    mapContCtry.put(key, fnd);
                }
            }
            if( c.Membership_2017_Status__c != NULL) {
                String key = '2017~' + acctCountry + '~' + c.Membership_2017_Status__c;
                Integer fnd = mapContCtry.get(key);
                if(fnd == NULL) {
                    mapContCtry.put(key, 1);
                } else {
                    fnd++;
                    mapContCtry.put(key, fnd);
                }
            }
            if( c.Membership_2018_Status__c != NULL) {
                String key = '2018~' + acctCountry + '~' + c.Membership_2018_Status__c;
                Integer fnd = mapContCtry.get(key);
                if(fnd == NULL) {
                    mapContCtry.put(key, 1);
                } else {
                    fnd++;
                    mapContCtry.put(key, fnd);
                }
            }
        }
        
        List<Reporting_Snapshot_Membership__c> newLapsedRollups = new List<Reporting_Snapshot_Membership__c>();
        for(String k :mapContCtry.keySet()) {
            Integer cnt = mapContCtry.get(k);
            string[] arrText = k.split('~');                    
            if(arrText.size() > 2) {
                Integer year = Integer.ValueOf(arrText[0]);
                String country = arrText[1];
                String status = arrText[2];
                
                System.debug('status:' + status);
                
                String busType = 'unknown';
                String memType = 'unknown';
                String payStat = 'unknown';
                String certStat = 'unknown';

                Integer intIndex = status.indexOf('^');
                if(intIndex > -1) {
                    string[] arrText1 = status.split('\\^');   
                    System.debug('busType split:' + arrText1);
                    if(arrText1.size() > 2) {
                        // Bus Type
                        String busMemType = arrText1[0];
                        intIndex = busMemType.indexOf(' ');
                        if(intIndex > -1) {
                            busType = busMemType.substring(intIndex+1,busMemType.length()); 
                            memType = busMemType.left(intIndex);
                            payStat = 'In Good Standing';
                            if(arrText1[1] == 'Lapsed') {
                                payStat = 'Lapsed';
                            }
                            certStat = arrText1[2];
                            
                            System.debug('busType: ' + busType);
                            System.debug('memType: ' + memType);
                            System.debug('payStat: ' + payStat);
                            System.debug('certStat: ' + certStat);
                                            
                            Reporting_Snapshot_Membership__c newSnap = new Reporting_Snapshot_Membership__c();
                            newSnap.Year__c = year;
                            newSnap.Member_Count__c = cnt;
                            newSnap.Membership_Type__c = memType;
                            newSnap.Membership_Payment_Status__c = payStat;
                            newSnap.Country__c = country;
                            newSnap.Member_Type_Description__c = status;
                            newSnap.Membership_Business_Type__c = busType;
                            newSnap.Certification_Status__c = certStat;
                            
                            System.debug('newSnap:' + newSnap);
                            
                            newLapsedRollups.add(newSnap);                            
                        } else {
                            system.debug('Bad busMemType3: ' + busMemType);
                        }
                    } else {
                    	system.debug('Bad Status2: ' + status);
                	}
                } else {
                    system.debug('Bad Status1: ' + status);
                }
            
            }
        }
        insert newLapsedRollups;

    }
    
    global void finish(Database.BatchableContext BC){
        
    }
    
}