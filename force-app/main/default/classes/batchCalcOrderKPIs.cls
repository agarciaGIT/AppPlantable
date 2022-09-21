global class batchCalcOrderKPIs implements Database.Batchable<sObject>{
        
    public String testID;  
    public DateTime batchLastKPI;

    global batchCalcOrderKPIs(DateTime inBatchLastKPI, String inTestID){
        this.batchLastKPI = inBatchLastKPI;
        this.testID = inTestID;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){  

        System.debug('batchLastKPI:' + batchLastKPI);
        System.debug('testID:' + testID);
        
        if(testID != NULL) {
            return Database.getQueryLocator('select Id, Reboot_Start_Date__c, Reboot_End_Date__c, Has_Completed_Starter_Survey__c, Has_Completed_Finisher_Survey__c, Reboot_Completed_Date__c, Days_Since_Reboot_Ended__c, Starter_Survey_Completed_Date__c, Finisher_Survey_Completed_Date__c, Batch_Last_KPI__c, First_Purchase_Date__c, Last_Purchase_Date__c, Initial_Channel__c, Last_Sub_Channel_long__c, Sub_Channel_Long__c, Initial_Product__c, Initial_Spend__c, X3_Month_Spend__c, X6_Month_Spend__c, X12_Month_Spend__c, X18_Month_Spend__c, X24_Month_Spend__c, Total_Spend_YTD__c, Total_Revenue__c, Total_Orders__c, Total_Shipment__c, Product_Revenue_ReUp__c, Product_Revenue_A_La_Carte__c, Product_Revenue_E1_2__c, Product_Revenue_E28__c, Product_Revenue_E28_Finish_Me__c, Product_Revenue_E7__c, Product_Count_ReUp__c, Product_Count_A_La_Carte__c, Product_Count_E1_2__c, Product_Count_E28__c, Product_Count_E28_Finish_Me__c, Product_Count_E7__c, Purchase_Duration__c, Purchase_Last_Date__c, Purchase_Start_Date__c, Second_Product__c, First_Shipment_Date__c,Number_of_Purchases_Since_Miniboot__c, Number_of_Purchases_Since_Miniboot_Date__c,Primary_Goal__c,Initial_Weight__c, Reboot_Week__c from Account Where Id = :testID');
        } else {
            return Database.getQueryLocator('select Id, Reboot_Start_Date__c, Reboot_End_Date__c, Has_Completed_Starter_Survey__c, Has_Completed_Finisher_Survey__c, Reboot_Completed_Date__c, Days_Since_Reboot_Ended__c, Starter_Survey_Completed_Date__c, Finisher_Survey_Completed_Date__c, Batch_Last_KPI__c, First_Purchase_Date__c, Last_Purchase_Date__c, Initial_Channel__c, Last_Sub_Channel_long__c, Sub_Channel_Long__c, Initial_Product__c, Initial_Spend__c, X3_Month_Spend__c, X6_Month_Spend__c, X12_Month_Spend__c, X18_Month_Spend__c, X24_Month_Spend__c, Total_Spend_YTD__c, Total_Revenue__c, Total_Orders__c, Total_Shipment__c, Product_Revenue_ReUp__c, Product_Revenue_A_La_Carte__c, Product_Revenue_E1_2__c, Product_Revenue_E28__c, Product_Revenue_E28_Finish_Me__c, Product_Revenue_E7__c, Product_Count_ReUp__c, Product_Count_A_La_Carte__c, Product_Count_E1_2__c, Product_Count_E28__c, Product_Count_E28_Finish_Me__c, Product_Count_E7__c, Purchase_Duration__c, Purchase_Last_Date__c, Purchase_Start_Date__c, Second_Product__c, First_Shipment_Date__c,Number_of_Purchases_Since_Miniboot__c, Number_of_Purchases_Since_Miniboot_Date__c,Primary_Goal__c,Initial_Weight__c, Reboot_Week__c from Account Where Batch_Last_KPI__c != :batchLastKPI');    
        }
        
    }    
    
    global static void runKPI(List<Account> scope, DateTime batchLastKPI) {
        MAP<String,Account> mapAcct = new MAP<String,Account>();
        MAP<String,Opportunity> mapOpp = new MAP<String,Opportunity>();
        MAP<String,Opportunity> mapInitialOpp = new MAP<String,Opportunity>();
        
        MAP<String,Opportunity> mapInitialZJE28Opp = new MAP<String,Opportunity>();
        MAP<String,Opportunity> mapSecondZJE28Opp = new MAP<String,Opportunity>();
        Date tdy = Date.today();
        
        List<Account> updateAcct = new List<Account>();
        for(Account acct :scope) {
            acct.Automated_Update__c = true;
            acct.Batch_Last_KPI__c = batchLastKPI;
            
            acct.Total_Revenue__c=0;
            acct.Total_Orders__c=0;
            acct.Total_Shipment__c=0;
            acct.Purchase_Start_Date__c=null;
            acct.Purchase_Last_Date__c=null;
            acct.Product_Count_A_La_Carte__c=0;
            acct.Product_Revenue_A_La_Carte__c=0;
            acct.Product_Count_E1_2__c=0;
            acct.Product_Revenue_E1_2__c=0;
            acct.Product_Count_E28__c=0;
            acct.Product_Revenue_E28__c=0;
            acct.Product_Count_E28_Finish_Me__c=0;
            acct.Product_Revenue_E28_Finish_Me__c=0;
            acct.Product_Count_E7__c=0;
            acct.Product_Revenue_E7__c=0;
            acct.Product_Count_ReUp__c=0;
            acct.Product_Revenue_ReUp__c=0;

            acct.Product_Revenue_ZJ_Reboot__c=0;
            acct.Product_Revenue_Quickstart__c=0;
            acct.Product_Revenue_Members_Only__c=0;
            acct.Product_Count_ZJ_Reboot__c=0;
            acct.Product_Count_Quickstart__c=0;
            acct.Product_Count_Members_Only__c=0;
            
            acct.Days_Since_First_Reboot_Purchase__c=null;

            
            acct.First_Purchase_Date__c=null;
            acct.Last_Purchase_Date__c=null;
            acct.First_Renewal_Date__c=null;
            acct.First_Shipment_Date__c=null;
            //acct.Initial_Channel__c=null;
            acct.Sub_Channel_Long__c=null;
            acct.Initial_Product__c=null;
            acct.Second_Product__c=null;
            acct.Initial_Spend__c=null;
            acct.X3_Month_Spend__c=0;
            acct.X6_Month_Spend__c=0;
            acct.X12_Month_Spend__c=0;
            acct.X18_Month_Spend__c=0;
            acct.X24_Month_Spend__c=0;
            acct.Total_Spend_YTD__c=0;
            acct.Number_of_Purchases_Since_Miniboot__c=-1;
            acct.Number_of_Purchases_Since_Miniboot_Date__c= null;
            
            acct.Reboot_Start_Date__c=null;
            acct.Reboot_End_Date__c=null;
            acct.Has_Completed_Starter_Survey__c=false;
            acct.Has_Completed_Finisher_Survey__c=false;
            
            acct.Finisher_Survey_Completed_Date__c=null;
            acct.Starter_Survey_Completed_Date__c=null;
            acct.Days_Since_Reboot_Ended__c=null;
            acct.Reboot_Completed_Date__c=null;
            acct.Primary_Goal__c=null;
            acct.Initial_Weight__c=null;
            acct.Reboot_Week__c=null;
              
            mapAcct.put(acct.Id, acct);
        }
        List<Opportunity> lstOpp = [select Id, CloseDate, AccountId, Amount, Total_Shipment__c, Shipment_Date__c, How_did_you_hear_Long__c, Main_Product__r.ProductCode, Main_Product__r.Family, First_Shipment_Date__c from Opportunity where StageName = 'Closed Won' AND AccountId in :mapAcct.keySet() Order by CloseDate Asc];
        for(Opportunity opp :lstOpp) {
            
            opp.Total_Shipment__c=0;
            opp.First_Shipment_Date__c=null;
            System.debug('opp:' + opp);
            
            mapOpp.put(opp.Id, opp);
            Account fndAcct = mapAcct.get(opp.AccountId);
            
            System.debug('fndAcct:' + fndAcct);
            if(fndAcct != NULL) {
                
                // Set to 0 on MiniBoot
                if(opp.Main_Product__r.ProductCode == 'E7MB' && fndAcct.Number_of_Purchases_Since_Miniboot__c == -1) {
                    fndAcct.Number_of_Purchases_Since_Miniboot__c = 0;
                    System.debug('~minifndAcct:' + fndAcct);
                } else if(fndAcct.Number_of_Purchases_Since_Miniboot__c >= 0 && fndAcct.Number_of_Purchases_Since_Miniboot__c <= 3) {
                    fndAcct.Number_of_Purchases_Since_Miniboot__c += 1;
                    fndAcct.Number_of_Purchases_Since_Miniboot_Date__c = opp.CloseDate;
                    System.debug('~minifndAcct:' + fndAcct);
                    mapAcct.put(fndAcct.Id,fndAcct); 
                }
                
                // Calc Days_Since_First_Reboot_Purchase
                // If 2 or more set to null
                Opportunity fndFirstOpp = mapInitialZJE28Opp.get(opp.AccountId);
                if(opp.Main_Product__r.ProductCode == 'E28ZJ' || opp.Main_Product__r.Family == 'Reboot') {
                    if(fndFirstOpp == null) {
                        mapInitialZJE28Opp.put(opp.AccountId, opp);
                        fndAcct.Days_Since_First_Reboot_Purchase__c =  opp.CloseDate.daysBetween(tdy);
                    } else {
                        fndAcct.Days_Since_First_Reboot_Purchase__c = null;
                    }
                }
                
                if(opp.How_did_you_hear_Long__c != null) {
                    if(fndAcct.Sub_Channel_Long__c == null)
                        fndAcct.Sub_Channel_Long__c = opp.How_did_you_hear_Long__c;
                    fndAcct.Last_Sub_Channel_long__c = opp.How_did_you_hear_Long__c;
                }
                
                if(fndAcct.First_Purchase_Date__c == null) {
                    fndAcct.First_Purchase_Date__c = opp.CloseDate;
                    fndAcct.Initial_Spend__c = opp.Amount;
                    fndAcct.Initial_Product__c = opp.Main_Product__r.ProductCode;
                    mapInitialOpp.put(opp.Id, opp);
                    System.debug('mapInitialOpp:' + opp.CloseDate);
                    
                    // These are Cumulative
                    fndAcct.X3_Month_Spend__c=opp.Amount;
                    fndAcct.X6_Month_Spend__c=opp.Amount;
                    fndAcct.X12_Month_Spend__c=opp.Amount;
                    fndAcct.X18_Month_Spend__c=opp.Amount;
                    fndAcct.X24_Month_Spend__c=opp.Amount;
                    
                } else {
                           
                    if(fndAcct.Second_Product__c == NULL) {
                        fndAcct.Second_Product__c = opp.Main_Product__r.ProductCode;
                    }
                    
                    // Bought Something within the first week
                    Integer numberDays = fndAcct.First_Purchase_Date__c.daysBetween(opp.CloseDate);
                    if(numberDays <= 7) {
                        fndAcct.Initial_Spend__c += opp.Amount;
                        fndAcct.X3_Month_Spend__c +=opp.Amount;
                        fndAcct.X6_Month_Spend__c +=opp.Amount;
                        fndAcct.X12_Month_Spend__c +=opp.Amount;
                        fndAcct.X18_Month_Spend__c +=opp.Amount;
                        fndAcct.X24_Month_Spend__c +=opp.Amount;
                    } else {

                        Date x = Date.valueOf(opp.CloseDate);
                        
                        if(fndAcct.First_Renewal_Date__c == NULL)
                            fndAcct.First_Renewal_Date__c=x;
                        
                        Integer dateDiff = fndAcct.First_Purchase_Date__c.monthsBetween(x);
                        System.debug('dateDiff:' + dateDiff);
                        
                        if(dateDiff < 3) {
                            fndAcct.X3_Month_Spend__c+=opp.Amount;
                        }
                        if(dateDiff < 6) {
                            fndAcct.X6_Month_Spend__c+=opp.Amount;
                        }
                        if(dateDiff < 12) {
                            fndAcct.X12_Month_Spend__c+=opp.Amount;
                        }
                        if(dateDiff < 18) {
                            fndAcct.X18_Month_Spend__c+=opp.Amount;
                        }
                        if(dateDiff < 24) {
                            fndAcct.X24_Month_Spend__c+=opp.Amount;
                        }
                            
                    }
                }

                Integer tdYear = system.today().year();
                if(opp.CloseDate.year() == tdYear) {
                    fndAcct.Total_Spend_YTD__c+=opp.Amount;
                }

                fndAcct.Last_Purchase_Date__c=opp.CloseDate;
                fndAcct.Total_Revenue__c += opp.Amount;
                fndAcct.Total_Orders__c++;
                if(fndAcct.Purchase_Start_Date__c == NULL) {
                    System.debug('No Start Date');
                    
                    // Set first date as this Opp Close date
                    fndAcct.Purchase_Start_Date__c = opp.CloseDate;
                    
                } else {
                    Integer monthDiff = opp.CloseDate.monthsBetween(fndAcct.Purchase_Start_Date__c);
                    System.debug('Yes Start Date' + monthDiff);
                    
                    // 6 months between orders - Reset the start date
                    if(monthDiff > 6) {
                        fndAcct.Purchase_Start_Date__c = opp.CloseDate;
                    }                    
                }
                System.debug('fndAcct startdate update:' + fndAcct);
                
                // Calc Duration
                Integer monthDiff = tdy.monthsBetween(opp.CloseDate);
                
                // Max 6 months after first purchase
                if(monthDiff <= 6) {
                    fndAcct.Purchase_Last_Date__c = tdy;
                } else {
                    fndAcct.Purchase_Last_Date__c = opp.CloseDate.addMonths(6);
                }                        
                System.debug('fndAcct lastdate update:' + fndAcct);
                mapAcct.put(fndAcct.Id,fndAcct);                        
            }
        }
        
        MAP<String,Product2> mapProd = new MAP<String,Product2>();
        List<Product2> lstProd = [select Id, Name, ProductCode, Family from Product2 where IsActive = True];                    
        System.debug('lstProd:' + lstProd);
        for(Product2 p :lstProd) {
            mapProd.put(p.ProductCode, p);
        }
        
        List<OpportunityLineItem> lstOppLine = [select Id,  OpportunityId,  ProductCode, Quantity, TotalPrice from OpportunityLineItem where OpportunityId in :mapOpp.keySet()];
        for(OpportunityLineItem oppLine :lstOppLine) {
            System.debug('oppLine:' + oppLine);
            Opportunity fndOpp = mapOpp.get(oppLine.OpportunityId);
            System.debug('fndOpp:' + fndOpp);
            if(fndOpp != NULL) {                 
                fndOpp.Total_Shipment__c=0;
                Account fndAcct = mapAcct.get(fndOpp.AccountId);
                System.debug('fndAcct:' + fndAcct);
                if(fndAcct != NULL) {              
                    Product2 fndProd = mapProd.get(oppLine.ProductCode);
                    if(fndProd != NULL) {
                        if(oppLine.ProductCode == 'EALC' || oppLine.ProductCode == 'OTALC') {
                            fndAcct.Product_Count_A_La_Carte__c++;
                            fndAcct.Product_Revenue_A_La_Carte__c+=oppLine.TotalPrice;
                        } else if(oppLine.ProductCode == 'EHF') {
                            fndAcct.Product_Count_E1_2__c++;
                            fndAcct.Product_Revenue_E1_2__c+=oppLine.TotalPrice;
                        } else if(oppLine.ProductCode == 'E28') {
                            fndAcct.Product_Count_E28__c++;
                            fndAcct.Product_Revenue_E28__c+=oppLine.TotalPrice;
                        } else if(oppLine.ProductCode == 'E28FM') {
                            fndAcct.Product_Count_E28_Finish_Me__c++;
                            fndAcct.Product_Revenue_E28_Finish_Me__c+=oppLine.TotalPrice;
                        } else if(oppLine.ProductCode == 'E7MB') {
                            fndAcct.Product_Count_E7__c++;
                            fndAcct.Product_Revenue_E7__c+=oppLine.TotalPrice;
                        } else if(oppLine.ProductCode == 'ERU') {
                            fndAcct.Product_Count_ReUp__c++;
                            fndAcct.Product_Revenue_ReUp__c+=oppLine.TotalPrice;
                            
                        } else if(oppLine.ProductCode == 'E28ZJ' || fndProd.Family == 'Reboot') {
                            
                            System.debug('oppLine.ProductCode:' + oppLine.ProductCode);
                            System.debug('fndOpp.Shipment_Date__c:' + fndOpp.Shipment_Date__c);
                            
                            fndAcct.Product_Count_ZJ_Reboot__c++;    
                            fndAcct.Product_Revenue_ZJ_Reboot__c+=oppLine.TotalPrice;
                            
                            if(fndOpp.Shipment_Date__c <= Date.today()) {
                                
                                System.debug('fndAcct.Reboot_Week__c:' + fndAcct.Reboot_Week__c);
                                
                                if(fndAcct.Reboot_Week__c == 4) {
                                    fndAcct.Reboot_Week__c=1;
                                    fndAcct.Reboot_Start_Date__c = fndOpp.Shipment_Date__c;
                                } else {
                                    if(fndAcct.Reboot_Week__c == NULL) {
                                        fndAcct.Reboot_Week__c=1;    
                                    } else {
                                        fndAcct.Reboot_Week__c++;        
                                    }
                                }
                                
                                System.debug('Update Reboot_Week__c:' + fndAcct.Reboot_Week__c);
                                
                                if(fndAcct.Reboot_Start_Date__c == NULL) {
                                    fndAcct.Reboot_Start_Date__c = fndOpp.Shipment_Date__c;
                                }
                                if(fndAcct.Reboot_Week__c==4) {
                                    fndAcct.Reboot_End_Date__c = fndOpp.Shipment_Date__c;    
                                }
                                
                            }
 
                        } else if(oppLine.ProductCode == 'QSZJ') {
                            fndAcct.Product_Count_Quickstart__c++;
                            fndAcct.Product_Revenue_Quickstart__c+=oppLine.TotalPrice;
                        } else if(oppLine.ProductCode == 'MOZJ') {
                            fndAcct.Product_Count_Members_Only__c++;
                            fndAcct.Product_Revenue_Members_Only__c+=oppLine.TotalPrice;
                        }                         
                        System.debug('fndAcct prod update:' + fndAcct);
                    }
                 }
             }
         }
         List<Shipment__c> lstShip = [select Id, Opportunity__c, Product__r.ProductCode, Scheduled_Date__c, Cycle__c, Delivery_Date__c   from Shipment__c where Opportunity__c in :mapOpp.keySet() Order by Scheduled_Date__c ASC];
         Map<string,decimal> cycleMap = new Map<string,decimal>();
        for(Shipment__c ship :lstShip) {
            
            System.debug('ship:' + ship);
            
            Opportunity fndOpp = mapOpp.get(ship.Opportunity__c);
            System.debug('fndOpp:' + fndOpp);
             if(fndOpp != NULL) {
                 Account fndAcct = mapAcct.get(fndOpp.AccountId);
                 System.debug('fndAcct:' + fndAcct);
                 if(fndAcct != NULL) {                     
                     
                     Product2 fndProd = mapProd.get(ship.Product__r.ProductCode);
                     if(fndProd != NULL) {
                        
                         Opportunity fndInitialOpp = mapInitialOpp.get(ship.Opportunity__c);
                         if(fndInitialOpp != null && fndAcct.First_Shipment_Date__c == null) {
                             fndAcct.First_Shipment_Date__c = ship.Scheduled_Date__c;
                         }
                         
                         fndAcct.Total_Shipment__c++;
                         System.debug('fndAcct ship update:' + fndAcct);
                         
                         /* if((ship.Product__r.ProductCode == 'E28ZJ' || fndProd.Family == 'Reboot') && ship.Cycle__c == 4) {
                             fndAcct.Reboot_Completed_Date__c = ship.Delivery_Date__c;
                             fndAcct.Days_Since_Reboot_Ended__c = ship.Delivery_Date__c.daysBetween(tdy );
                         } */
                        if(ship.Product__r.ProductCode == 'E28ZJ' || fndProd.Family == 'Reboot') {
                            
                            if(ship.Cycle__c !=null){
                                if(cycleMap.containsKey(fndAcct.Id)){
                                    if(cycleMap.get(fndAcct.Id) < ship.Cycle__c){ 
                                        cycleMap.put(fndAcct.Id,ship.Cycle__c);
                                    }
                                }else{
                                    cycleMap.put(fndAcct.Id,ship.Cycle__c); 
                                } 
                                //if(cycleMap.containsKey(fndAcct.Id)){
                                //    fndAcct.Reboot_Week__c = cycleMap.get(fndAcct.Id);
                                //}
                            }
                            
                            if(ship.Cycle__c == 4){
                                fndAcct.Reboot_Completed_Date__c = ship.Delivery_Date__c;
                                fndAcct.Days_Since_Reboot_Ended__c = ship.Delivery_Date__c.daysBetween(tdy);
                            }
                        }
                     }
                 }
                 
                 System.debug('fndOpp.First_Shipment_Date__c:' + fndOpp.First_Shipment_Date__c);
                 if(fndOpp.First_Shipment_Date__c == null) {
                     fndOpp.First_Shipment_Date__c = ship.Scheduled_Date__c;
                     System.debug('Set fndOpp.First_Shipment_Date__c:' + fndOpp.First_Shipment_Date__c);
                 }

                 fndOpp.Total_Shipment__c++;
             }
        }
        
        
        // Health Survey
        List< Health_Survey__c > lstHS = [select Id, Account__c, Is_App__c, Is_Finisher_Survey__c, CreatedDate,Weight_Text__c,Primary_Goal__c from Health_Survey__c WHERE Account__c in :mapAcct.keySet() ORDER BY CreatedDate DESC];
        for(Health_Survey__c hs :lstHS) {
        
            Account fndAcct = mapAcct.get(hs.Account__c);
            
            System.debug('fndAcct:' + fndAcct);
            if(fndAcct != NULL) {
                if(hs.Is_Finisher_Survey__c == True && !fndAcct.Has_Completed_Finisher_Survey__c) {
                    fndAcct.Has_Completed_Finisher_Survey__c = True;
                    fndAcct.Finisher_Survey_Completed_Date__c = Date.newInstance(hs.CreatedDate.year(), hs.CreatedDate.month(), hs.CreatedDate.day());
                }
                
                if(!hs.Is_Finisher_Survey__c == True && !fndAcct.Has_Completed_Starter_Survey__c) {
                    fndAcct.Has_Completed_Starter_Survey__c = True;
                    fndAcct.Starter_Survey_Completed_Date__c = Date.newInstance(hs.CreatedDate.year(), hs.CreatedDate.month(), hs.CreatedDate.day());
                }
                
                if(hs.Primary_Goal__c!= null && hs.Primary_Goal__c!='' && fndAcct.Primary_Goal__c == NULL){
                    fndAcct.Primary_Goal__c = hs.Primary_Goal__c;
                }
                
                if(hs.Weight_Text__c!=null && hs.Weight_Text__c!='' && fndAcct.Initial_Weight__c == NULL){
                    fndAcct.Initial_Weight__c = hs.Weight_Text__c;
                }
            }
            
        }

        
        // Update KPI
        update scope; 
        List<Opportunity> updateOpp = new List<Opportunity>();
        for(Opportunity opp :mapOpp.values()) {
            opp.Enable_Automation__c = False;
            updateOpp.add(opp);
        }
        update updateOpp;
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        runKPI(scope, batchLastKPI);
    }
    
    global void finish(Database.BatchableContext BC){
    }     
    
    @InvocableMethod(label='batchKPIs' description='KPI Update')
    public static void batchCalcOrderKPIFlow(List<List<String>> inputParams) {  
        System.debug('inputParams:' + inputParams);
        
        if(!inputParams.isEmpty() && !Test.isRunningTest()) {
            List<String> ids = inputParams[0];
            if(!ids.isEmpty()){
                String acctId = ids[0];
                System.debug('acctId:' + inputParams);
                List<Account> accts = [select Id, Batch_Last_KPI__c, First_Purchase_Date__c, Last_Purchase_Date__c, Initial_Channel__c, Last_Sub_Channel_long__c, Sub_Channel_Long__c, Initial_Product__c, Initial_Spend__c, X3_Month_Spend__c, X6_Month_Spend__c, X12_Month_Spend__c, Total_Spend_YTD__c, Total_Revenue__c, Total_Orders__c, Total_Shipment__c, Product_Revenue_ReUp__c, Product_Revenue_A_La_Carte__c, Product_Revenue_E1_2__c, Product_Revenue_E28__c, Product_Revenue_E28_Finish_Me__c, Product_Revenue_E7__c, Product_Count_ReUp__c, Product_Count_A_La_Carte__c, Product_Count_E1_2__c, Product_Count_E28__c, Product_Count_E28_Finish_Me__c, Product_Count_E7__c, Purchase_Duration__c, Purchase_Last_Date__c, Purchase_Start_Date__c from Account Where Id = :acctId];
                System.debug('accts:' + accts);
                DateTime batchLastKPI = system.now();
                runKPI(accts, batchLastKPI);
           }
       }
    }

    
}