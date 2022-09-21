public class packingSlipPDF {
    
    public String strShipdate {get; set;}
    public String strType {get; set;}
    public String strMark {get; set;}
    public String strMSK {get; set;}
    public List<String> slips {get; set;}
    
    public packingSlipPDF() {   
        strShipdate = ApexPages.currentPage().getParameters().get('shipdate');
        strType = ApexPages.currentPage().getParameters().get('type');
        strMark = ApexPages.currentPage().getParameters().get('mark');
        strMSK = ApexPages.currentPage().getParameters().get('msk');

         if (Test.isRunningTest()) {
             strShipdate = '2020-03-02';
             strMark = 'true';
         }
    }
    
    public void doInit() {
        
        Date shipDate = Date.valueOf(strShipdate);
        
        System.debug('shipDate:' + shipDate);
        System.debug('strType:' + strType);
        
        slips = new List<String>();
        
        if(strType == 'chef') {
            List<Shipment__c> lstShip = new List<Shipment__c>();
            if(strMSK == 'true'){
                lstShip = [select Id, Name, First_name__c, Last_name__c, Phone__c, Street1__c, Street2__c, City__c, State__c, Zip__c from Shipment__c where Scheduled_Date__c = :shipDate AND Opportunity__r.StageName = 'Closed Won' AND Opportunity__r.Is_Custom__c = False AND Is_Test__c = False AND Study_Order__c = True];
            } else{
                lstShip = [select Id, Name, First_name__c, Last_name__c, Phone__c, Street1__c, Street2__c, City__c, State__c, Zip__c from Shipment__c where Scheduled_Date__c = :shipDate AND Opportunity__r.StageName = 'Closed Won' AND Opportunity__r.Is_Custom__c = False AND Is_Test__c = False AND Study_Order__c = False];
            }
            System.debug('lstShip:' + lstShip);
            
            List<Meal__c> lstMeals = shopifyClass.computeChefMeals(shipDate,false);
            System.debug('lstMeals :' + lstMeals );
            
            
            if(lstMeals != NULL && lstMeals.size() > 0 && lstShip != NULL && lstShip.size() > 0) {
                String slip='';
                
                slip+= '<div class="header">Here’s the plant-powered goodness inside your Chef’s Menu box. Feel free to enjoy your lunches and dinners in the order we recommend, or mix-and-match to your desire.</div>';


                String myUrl = PageReference.forResource('PackingSlips').getUrl();
                if(myUrl != NULL && myUrl.length() > 0 && myUrl.indexOf('?') > -1) {
                    myUrl = myUrl.subString(0, myUrl.indexOf('?'));
                } else {
                    myUrl = '';
                }
                String lunchesImg = myUrl + '/images/lunch.png';
                String dinnersImg = myUrl + '/images/dinner.png';
                
                slip+= '<table border=0 style="border-collapse: collapse;"><tr><td class="chefMealTDHeader"></td><td class="chefMealTDHeader">Day 1</td><td class="chefMealTDHeader">Day 2</td><td class="chefMealTDHeader">Day 3</td><td class="chefMealTDHeader">Day 4</td><td class="chefMealTDHeader">Day 5</td><td class="chefMealTDHeader">Day 6</td></tr><tr><td class="chefMealTDMealType "><img src="'+ lunchesImg +'"></td>';
                
                Integer cnt=1;
                Integer rowcnt=1;
                for(Meal__c m :lstMeals) {
                    if(Math.mod(cnt, 2) != 0) {
                        if(rowcnt == 99) { 
                            slip+= '<td class="chefMealTD tblrightborder"><div class="chefMeal">' + m.Name + '</div></td>';                        
                        } else {
                            slip+= '<td class="chefMealTD"><div class="chefMeal">' + m.Name + '</div></td>';
                        }
                        rowcnt++;
                    }
                    cnt++;
                }
                
                slip+= '</tr><tr><td class="chefMealTDMealType"><img src="'+ dinnersImg +'"></td>';
                
                cnt=1;
                rowcnt=1;
                for(Meal__c m :lstMeals) {
                    if(Math.mod(cnt, 2) == 0) {
                        if(rowcnt == 99) { 
                            slip+= '<td class="chefMealTD tblrightborder"><div class="chefMeal">' + m.Name + '</div></td>';                        
                        } else {
                            slip+= '<td class="chefMealTD"><div class="chefMeal">' + m.Name + '</div></td>';
                        }
                        rowcnt++;
                    }
                    cnt++;
                }                
                
                slip+= '</tr></table>';                
                
                cnt=1;
                for(Shipment__c s :lstShip) {
                    if(Math.mod(cnt, 3) == 0) {
                        slips.add('BREAK');
                        cnt++;
                    }
                    slips.add(slip);
                    cnt++;
                }
            }
        } else if(strType == 'cart') {
            
            List<Shipment__c> lstShip = new List<Shipment__c>();
            if(strMSK == 'true'){
                if(strMark !=null) {
                    lstShip  = [select Id, Name, Order_Number__c, Scheduled_Date__c, Shipping_Service_Type__c, Opportunity__c, Phone__c, First_name__c, Last_name__c, Street1__c, Street2__c, City__c, State__c, Zip__c from Shipment__c where Scheduled_Date__c = :shipDate AND Opportunity__r.Fulfilment_Status__c != 'Complete' AND Opportunity__r.StageName = 'Closed Won' AND Opportunity__r.Is_Custom__c = True AND Is_Test__c = False AND Study_Order__c = True];            
                } else {
                    lstShip  = [select Id, Name, Order_Number__c, Scheduled_Date__c, Shipping_Service_Type__c, Opportunity__c, Phone__c, First_name__c, Last_name__c, Street1__c, Street2__c, City__c, State__c, Zip__c from Shipment__c where Scheduled_Date__c = :shipDate AND Opportunity__r.Fulfilment_Status__c = 'Complete' AND Opportunity__r.StageName = 'Closed Won' AND Opportunity__r.Is_Custom__c = True AND Is_Test__c = False AND Study_Order__c = True];        
                }
                
            }else{
                if(strMark !=null) {
                    lstShip  = [select Id, Name, Order_Number__c, Scheduled_Date__c, Shipping_Service_Type__c, Opportunity__c, Phone__c, First_name__c, Last_name__c, Street1__c, Street2__c, City__c, State__c, Zip__c from Shipment__c where Scheduled_Date__c = :shipDate AND Opportunity__r.Fulfilment_Status__c != 'Complete' AND Opportunity__r.StageName = 'Closed Won' AND Opportunity__r.Is_Custom__c = True AND Is_Test__c = False AND Study_Order__c = False];            
                } else {
                    lstShip  = [select Id, Name, Order_Number__c, Scheduled_Date__c, Shipping_Service_Type__c, Opportunity__c, Phone__c, First_name__c, Last_name__c, Street1__c, Street2__c, City__c, State__c, Zip__c from Shipment__c where Scheduled_Date__c = :shipDate AND Opportunity__r.Fulfilment_Status__c = 'Complete' AND Opportunity__r.StageName = 'Closed Won' AND Opportunity__r.Is_Custom__c = True AND Is_Test__c = False AND Study_Order__c = False];        
                }
            }
            System.debug('lstShip:' + lstShip);
            
            Set<ID> setOrders = new Set<ID>();
            for(Shipment__c s :lstShip) {
                setOrders.add(s.Opportunity__c);
            }
            System.debug('setOrders:' + setOrders);
            
            MAP<String,String> mapMeals = new MAP<String,String>();
            MAP<String,Integer> mapMealsCnt = new MAP<String,Integer>();
            
            String meals=''; 
            List<Meal_Line_Item__c> lstMLI = [select Id, Name, EOrder__c, Meal_Name__c, Shopify_ID__c, Quantity__c, Meal__r.Sort_Rank__c from Meal_Line_Item__c where EOrder__c in :setOrders order by EOrder__c, Meal__r.Sort_Rank__c];
            System.debug('lstMLI:' + lstMLI);
            
            if(lstMLI != NULL && lstMLI.size() > 0) {
                String lastOpp = lstMLI[0].EOrder__c;
                String insertMeal = null;
                
                Integer mealCnt=0;
                for(Meal_Line_Item__c mli :lstMLI) {
                    
                    System.debug('mli:' + mli);
                    
                    if(lastOpp != mli.EOrder__c) {
                        System.debug('New Order');
                        
                        if(insertMeal != null) {
                            System.debug('add insertMeal:' + insertMeal);
                            meals+= insertMeal;
                        }
                        insertMeal = null;
                        
                        System.debug('mapMeals.put:' + lastOpp + ':' + meals);
                        mapMeals.put(lastOpp,meals);
                        meals=''; 
                        mapMealsCnt.put(lastOpp,mealCnt);
                        mealCnt=0;
                    }
                    if(mli.Shopify_ID__c == '1000000001' || mli.Shopify_ID__c == '1000000002') {
                        System.debug('found insertMeal!');
                        insertMeal = '<div>___ ' + mli.Quantity__c + ' ' + mli.Meal_Name__c + '</div>';
                        mealCnt++;
                    } else {
                        meals+= '<div>___ ' + mli.Quantity__c + ' ' + mli.Meal_Name__c + '</div>';
                        mealCnt++;
                    }
                    System.debug('meals+:' + meals);

                    System.debug('lastOpp:' + mli.EOrder__c);
                    lastOpp = mli.EOrder__c;
                }
                // Last Meal
                System.debug('Last Order');
                
                if(insertMeal != null) {
                    System.debug('add insertMeal:' + insertMeal);
                    meals+= insertMeal;
                }
                
                System.debug('mapMeals.put:' + lastOpp + ':' + meals);
                mapMeals.put(lastOpp,meals);
                mapMealsCnt.put(lastOpp,mealCnt);
            }
            System.debug('mapMeals:' + mapMeals);
                        
            if(lstShip != NULL && lstShip.size() > 0) {
                integer cnt=1;
                for(Shipment__c s :lstShip) {
                
                    System.debug('ship:' + s);
                
                    if(Math.mod(cnt, 3) == 0) {
                        slips.add('BREAK');
                        cnt++;
                    }
                    String sMeals = mapMeals.get(s.Opportunity__c);
                    System.debug('sMeals:' + sMeals);
                    
                    Integer mealsCnt = mapMealsCnt.get(s.Opportunity__c);
                    System.debug('mealsCnt :' + mealsCnt );
                    
                    
                    String sDate = DateTime.newInstance(s.Scheduled_Date__c.year(), s.Scheduled_Date__c.month(), s.Scheduled_Date__c.day()).format('M/d/yyyy');
                    
                    String slip='';
                    slip+= '<table><tr><td class="metaTableTwoCol1"><div class="metaData">Order Number: ' + s.Order_Number__c + '</div>';
                    slip+= '<div class="metaData">Ship Date: ' + sDate + '</div>';
                    slip+= '<div class="metaData">Shipping Service Type: ' + s.Shipping_Service_Type__c + '</div></td><td class="metaTableTwoCol2">';
                    
                    slip+= '<div class="metaData">' + s.First_name__c + ' ' + s.Last_Name__c + '</div>';
                    slip+= '<div class="metaData">' + s.Street1__c;
                    if(s.Street2__c != NULL) { 
                        slip+= ', ' + s.Street2__c + '</div>'; 
                    } else {
                        slip+= '</div>';
                    }
                    slip+= '<div class="metaData">' + s.City__c + ', ' + s.State__c + ' ' + s.Zip__c + '</div>';
                    if(s.Phone__c != NULL) {
                        slip+=  '<div>' + s.Phone__c + '</div>';
                    }
                    
                    slip+= '</td></tr></table>';
                    
                    
                    slip+= '<div class="header">Your Plantable Meals:</div>';
                    if(mealsCnt <= 13) {
                        slip+= '<div class="mealName">' + sMeals + '</div>';
                    } else {
                        slip+= '<div class="mealNameSmall">' + sMeals + '</div>';
                    }                    
                    
                    
                    
                    System.debug('slip:' + slip);
                    slips.add(slip);

                    cnt++;
                }
            }
            
            if(strMark != NULL && strMark == 'true') {
                //Fulfilment_Status__c
                List<Opportunity> lstOpp = [select Id,Name,Fulfilment_Status__c from Opportunity where Id in :setOrders];
                if(lstOpp!=NULL && lstOpp.size() > 0) {
                    for(Opportunity opp :lstOpp) {
                        opp.Fulfilment_Status__c = 'Complete';
                    }
                }
                update lstOpp;
            }
            
        }
        
    }
}