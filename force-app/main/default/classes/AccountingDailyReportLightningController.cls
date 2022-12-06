public class AccountingDailyReportLightningController {
   
    @auraEnabled public List<Order_Transaction_Item_Map__c> orderTransMap {get;set;}
    @auraEnabled public List<Order_Transaction_Item__c> lstOrderTransItems {get;set;}
    @auraEnabled public List<Order_Transaction_Item__c> selectedRows {get;set;}
    
    @auraEnabled public Date startDate {get;set;}
    @auraEnabled public Date endDate {get;set;}
    @auraEnabled public Boolean filter_garp {get;set;}
    @auraEnabled public Boolean filter_gra {get;set;}
    @auraEnabled public Boolean filter_nj {get;set;}
    @auraEnabled public Boolean filter_charge {get;set;}
    @auraEnabled public Boolean filter_refund {get;set;}
    @auraEnabled public Boolean filter_debit {get;set;}
    @auraEnabled public Boolean filter_credit {get;set;}
    @auraEnabled public Boolean filter_cba {get;set;}
    @auraEnabled public Boolean filter_cbl {get;set;}
    @auraEnabled public Boolean filter_cc {get;set;}
    @auraEnabled public Boolean filter_ccfax {get;set;}
    @auraEnabled public Boolean filter_wire {get;set;}
    @auraEnabled public Boolean filter_check {get;set;}
    @auraEnabled public Boolean filter_ach {get;set;}
    @auraEnabled public Boolean filter_free {get;set;}
    
    @auraEnabled public Integer pageNumber {get;set;}
    @auraEnabled public Integer pageSize {get;set;}
    @auraEnabled public Integer totalSize {get;set;}


    @AuraEnabled
    public static List<Order_Transaction_Item_Map__c> getOrderTransactionMap() {
        List<Order_Transaction_Item_Map__c> orderTransMap = [select Name, Company__c, Field_Name__c, GL_Code__c, Is_Shipping__c, Product_Code__c, Sort_Order__c, 
                                                             Source_GL_Codes__c, Source_Product_Codes__c, Weight__c from Order_Transaction_Item_Map__c 
                                                             order by Sort_Order__c];
        System.debug('orderTransMap:' + orderTransMap);        
        return orderTransMap;
    }
    

    @AuraEnabled
    public static AccountingDailyReportLightningController approveAllRowItems(AccountingDailyReportLightningController obj) {
        
        AccountingDailyReportLightningController hldObj = getOrderTransactions(obj,false);
        
        Set<String> orderTransItemIds = new Set<String>();
        if(hldObj.lstOrderTransItems != NULL && hldObj.lstOrderTransItems.size() > 0) {
            for(Order_Transaction_Item__c oti :hldObj.lstOrderTransItems) {
                orderTransItemIds.add(oti.id);
            }
        }
        System.debug('orderTransItemIds' + orderTransItemIds);
        
        Boolean ret = OrderTransactionLineItemsClass.onSetStatus(orderTransItemIds);
        System.debug('ret' + ret);
        
        // Set rows as approved
        if(ret) {
            for(Order_Transaction_Item__c oti :hldObj.lstOrderTransItems) {
                oti.Status__c = 'Approved';
            }
            update hldObj.lstOrderTransItems;
        }
        
        return getOrderTransactions(obj,true);
    }


    @AuraEnabled
    public static AccountingDailyReportLightningController approveSelectedRows(AccountingDailyReportLightningController obj) {
        
        System.debug('obj.selectedRows' + obj.selectedRows);
        
        Set<String> orderTransItemIds = new Set<String>();
        if(obj.selectedRows != NULL && obj.selectedRows.size() > 0) {
            for(Order_Transaction_Item__c oti :obj.selectedRows) {
                orderTransItemIds.add(oti.id);
            }
        }
        System.debug('orderTransItemIds' + orderTransItemIds);
        
        Boolean ret = OrderTransactionLineItemsClass.onSetStatus(orderTransItemIds);
        System.debug('ret' + ret);
        
        // Set rows as approved
        if(ret && obj.selectedRows != NULL && obj.selectedRows.size() > 0) {
            for(Order_Transaction_Item__c oti :obj.selectedRows) {
                oti.Status__c = 'Approved';
            }
            update obj.selectedRows;
        }
        
        return getOrderTransactions(obj,true);
    }

    
    @AuraEnabled
    public static AccountingDailyReportLightningController initClass() {
        AccountingDailyReportLightningController obj = new AccountingDailyReportLightningController(); 
        
        obj.orderTransMap = [select Name, Company__c, Field_Name__c, GL_Code__c, Is_Shipping__c, Product_Code__c, Sort_Order__c, 
                                                             Source_GL_Codes__c, Source_Product_Codes__c, Weight__c from Order_Transaction_Item_Map__c 
                                                             order by Sort_Order__c];
        System.debug('orderTransMap:' + obj.orderTransMap); 
        
        return obj;
    }
    
    
    
    @AuraEnabled
    public static AccountingDailyReportLightningController getOrderTransactions(AccountingDailyReportLightningController obj, Boolean usePaging){
                                                                    
        List<Order_Transaction_Item_Map__c> omap = getOrderTransactionMap();
                                                                           
        String queryCount = 'select count() from Order_Transaction_Item__c where';

        String queryData = 'select Id, Company__c, Transaction_Type__c, Total_Amount__c, Invoice_Number__c, GARP_ID__c, First_Name__c, ' +
                       'Last_Name__c, Country__c, State__c, Exam_Site__c, Payment_Method__c, Paid_Date_Time__c, Gateway_ID__c, ' + 
                       'Status__c, Opportunity__c, Opportunity__r.AccountID, Transaction__c';

               
        String queryFields='';
        for(Order_Transaction_Item_Map__c oi :omap) {
            queryFields = queryFields + ', ' + oi.Field_Name__c;                                                                 
        }
        queryData = queryData + queryFields + ' from Order_Transaction_Item__c where';
        
        String queryFilters='';
                                                                           
        System.debug('startDate:' + obj.startDate);                                      
        if(obj.startDate != NULL) {
            DateTime dt = DateTime.newInstance(obj.startDate.Year(), obj.startDate.month(), obj.startDate.day());
            queryFilters = queryFilters + ' Paid_Date_Time__c >= ' + dt.format('yyyy-MM-dd') + 'T00:00:00Z';
        }                                                                   
        if(obj.endDate != NULL) {
            DateTime dt = DateTime.newInstance(obj.endDate.Year(), obj.endDate.month(), obj.endDate.day());
            queryFilters = queryFilters + ' AND Paid_Date_Time__c <= ' + dt.format('yyyy-MM-dd') + 'T11:59:59Z';
        }
        if(obj.filter_garp != NULL && obj.filter_garp == True || obj.filter_gra != NULL && obj.filter_gra == True) {
            queryFilters = queryFilters + ' AND (';
            Boolean first=False;
            if(obj.filter_garp != NULL && obj.filter_garp == True) {
                queryFilters = queryFilters + 'Company__c = \'GARP\'';
                first=True;
            }
            if(obj.filter_gra != NULL && obj.filter_gra == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Company__c = \'GRA\'';
            }
            queryFilters = queryFilters + ')';
        }
        
        if(obj.filter_nj != NULL && obj.filter_nj == True) {
            queryFilters = queryFilters + ' AND Is_NJ__c = TRUE';
        }

        if(obj.filter_charge != NULL && obj.filter_charge == True || obj.filter_refund != NULL && obj.filter_refund == True || obj.filter_debit != NULL && obj.filter_debit == True || obj.filter_credit != NULL && obj.filter_credit == True || obj.filter_cba != NULL && obj.filter_cba == True || obj.filter_cbl != NULL && obj.filter_cbl == True) {
            queryFilters = queryFilters + ' AND (';
            Boolean first=False;
            if(obj.filter_charge != NULL && obj.filter_charge == True) {
                queryFilters = queryFilters + 'Transaction_Type__c = \'Charge\'';
                first=True;
            }
            if(obj.filter_refund != NULL && obj.filter_refund == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Transaction_Type__c = \'Refund\'';
                first=True;
            }
            if(obj.filter_debit != NULL && obj.filter_debit == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Transaction_Type__c = \'Debit\'';
                first=True;
            }
            if(obj.filter_credit != NULL && obj.filter_credit == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Transaction_Type__c = \'Credit\'';
                first=True;
            }
            if(obj.filter_cba != NULL && obj.filter_cba == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Charge_Back_Status__c = \'Accepted\'';
                first=True;
            }
            if(obj.filter_cbl != NULL && obj.filter_cbl == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Charge_Back_Status__c = \'Loss\'';
            }
            queryFilters = queryFilters + ')';
        }
                           
        if(obj.filter_cc != NULL && obj.filter_cc == True || obj.filter_ccfax != NULL && obj.filter_ccfax == True || obj.filter_wire != NULL && obj.filter_wire == True || obj.filter_check != NULL && obj.filter_check == True || obj.filter_ach != NULL && obj.filter_ach == True || obj.filter_free != NULL && obj.filter_free == True) {
            queryFilters = queryFilters + ' AND (';
            Boolean first=False;
            if(obj.filter_cc != NULL && obj.filter_cc == True) {
                queryFilters = queryFilters + 'Payment_Method__c = \'Credit Card\'';
                first=True;
            }
            if(obj.filter_ccfax != NULL && obj.filter_ccfax == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Payment_Method__c = \'CCFax\'';
                first=True;
            }
            if(obj.filter_wire != NULL && obj.filter_wire == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Payment_Method__c = \'Wire\'';
                first=True;
            }
            if(obj.filter_check != NULL && obj.filter_check == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Payment_Method__c = \'Check\'';
                first=True;
            }
            if(obj.filter_ach != NULL && obj.filter_ach == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Payment_Method__c = \'ACH\'';
                first=True;
            }
            if(obj.filter_free != NULL && obj.filter_free == True) {
                if(first) {
                    queryFilters = queryFilters + ' OR ';
                }
                queryFilters = queryFilters + 'Payment_Method__c = \'Free\'';
            }
            queryFilters = queryFilters + ')';
        }                              
        System.debug('queryFilters:' + queryFilters);
        
        String queryPage='';
        queryPage = queryPage + ' LIMIT ' + obj.pageSize + ' OFFSET ' + (obj.pageSize*(obj.pageNumber-1));

        if(usePaging) {
            obj.lstOrderTransItems = Database.query(queryData + queryFilters + queryPage);    
            
            // Totals
            Order_Transaction_Item__c tot = new Order_Transaction_Item__c(
                Total_Amount__c = 0
            );
            List<Order_Transaction_Item__c> lstOrderTransItemsTotals = Database.query(queryData + queryFilters);
            for(Order_Transaction_Item__c oti :lstOrderTransItemsTotals) {
                
                System.debug('oti:' + oti);
                
                tot.Total_Amount__c += oti.Total_Amount__c;
                
                for(Order_Transaction_Item_Map__c oi :omap) {
                    
                    System.debug('oi:' + oi.Field_Name__c);
                    
                    Decimal curAmt = (Decimal)oti.get(oi.Field_Name__c);
                    Decimal totAmt = (Decimal)tot.get(oi.Field_Name__c);
                    
                    System.debug('curAmt:' + curAmt);
                    System.debug('totAmt:' + totAmt);
                    
                    if(curAmt != NULL) {
                        if(totAmt == null) {
                            tot.put(oi.Field_Name__c, curAmt);    
                        } else {
                            tot.put(oi.Field_Name__c, curAmt + totAmt);
                        }
                    }                                                      
                }
            }
            obj.lstOrderTransItems.add(tot);
        } else {
            obj.lstOrderTransItems = Database.query(queryData + queryFilters);
        }
                                           
        obj.totalSize = Database.countQuery(queryCount + queryFilters);
        
        //List<Order_Transaction_Item__c> lstOrderTransItems = [select Id,Company__c,Transaction_Type__c,Total_Amount__c,
        //                                                      Invoice_Number__c, GARP_ID__c, First_Name__c, Last_Name__c,
        //                                                      Country__c, State__c, Exam_Site__c, Payment_Method__c, 
        //                                                      Paid_Date_Time__c, Gateway_ID__c, Status__c,
        //                                                      Opportunity__c, Opportunity__r.AccountID, Transaction__c from Order_Transaction_Item__c limit 10];
        
        return obj;
    }
    
}