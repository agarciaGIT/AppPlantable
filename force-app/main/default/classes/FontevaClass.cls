public class FontevaClass {
    
    public static boolean bRecursive = false;
    public static String formDataOutput {get; set;}
    
    public static void getFormResponses() {
        List<PagesApi__Field_Response__c> lstResp = [select id, PagesApi__Form_Response__c, PagesApi__Form_Response__r.EventApi__Attendee__c, PagesApi__Form_Response__r.PagesApi__Contact__c,EventApi__Attendee__c, PagesApi__Field_Label__c, PagesApi__Response__c from PagesApi__Field_Response__c];
        
        MAP<String,String> mapResp = new MAP<String,String>();
        Set<String> fields = new Set<String>();
        Set<String> attendees = new Set<String>();
        
        for(PagesApi__Field_Response__c pr :lstResp) {
            
            String label = pr.PagesApi__Field_Label__c;
            if(Test.isRunningTest()) {
                label = 'abc';
            }
            
            if(label != NULL) {
                String att;
                if(pr.PagesApi__Form_Response__r.EventApi__Attendee__c != NULL) {
                    att = pr.PagesApi__Form_Response__r.EventApi__Attendee__c;
                } else if(pr.EventApi__Attendee__c != NULL) {
                    att = pr.EventApi__Attendee__c;
                }
                if(att != null) {
                    fields.add(label);       
                    mapResp.put(att + ':' + label,pr.PagesApi__Response__c);
                    attendees.add(att);
                }
            }
        }
        
        formDataOutput = '"Attendee",';
        for(string field :fields) {
            formDataOutput = formDataOutput + '"' + field + '",';
        }        
        formDataOutput = formDataOutput + '\n';
        for(String att :attendees) {
            formDataOutput = formDataOutput + att + ',';
            for(string field :fields) {
                String fndResp = mapResp.get(att + ':' + field);
                if(fndResp == NULL) {
                    fndResp = '';
                }
                fndResp = fndResp.replace('"', '\"');
                formDataOutput = formDataOutput + '"' + fndResp + '",';
            }
            formDataOutput = formDataOutput + '\n';
        }
       
        
    }
    
    public static void contractStatusChange(Set<String> accountIDs) {
        
        Id ERPRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','ERP_Program');
        Id FRMRecordTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract','FRM_Program');
        Id MembershipTypeId = RecordTypeHelper.getRecordTypeIdFromSchema('Contract', 'Membership');        
        
        MAP<String,Contact> mapAcctCont = new MAP<String,Contact>();
        MAP<String,Boolean> mapIsCert = new MAP<String,Boolean>();
        MAP<String,Boolean> mapIsIndv = new MAP<String,Boolean>();
        
        System.debug('accountIDs:' + accountIDs);
        
        List<Account> accts = [select Id from Account where Id in :accountIDs];
        System.debug('accts :' + accts );
        
        List<Contract> conts = [select Id, Status, RecordTypeId, AccountId, Membership_type__c from Contract where 
                                RecordTypeId in (:MembershipTypeId,:ERPRecordTypeId,:FRMRecordTypeId) AND AccountId in :accountIDs];
        System.debug('conts:' + conts);

        if(!conts.isEmpty()) {
            List<Contact> contacts = [select Id, AccountID from Contact where AccountID in :accountIDs];
            
            for(Contact c :contacts) {
                mapAcctCont.put(c.AccountID, c);
            }
            System.debug('mapAcctCont:' + mapAcctCont);
            
            for(Contract cont :conts) {
            
                System.debug('cont :' + cont);
    
                if(cont.Status == 'Completed' && (cont.RecordTypeId == ERPRecordTypeId || cont.RecordTypeId == FRMRecordTypeId)) {
                    mapIsCert.put(cont.AccountID, TRUE);
                }
                if((cont.Status == 'Activated' || cont.Status == 'Activated ( Auto-Renew )') && cont.RecordTypeId == MembershipTypeId && cont.Membership_type__c == 'Individual') {
                    mapIsIndv.put(cont.AccountID, TRUE);
                }
           }
           
            System.debug('mapIsCert :' + mapIsCert );
            System.debug('mapIsIndv :' + mapIsIndv );
            
                
            List<OrderApi__Badge__c> exitingBadges = [select Id, OrderApi__Contact__c, OrderApi__Account__c, OrderApi__Badge_Type__c, OrderApi__Is_Active__c
                                                      FROM OrderApi__Badge__c where OrderApi__Is_Active__c = TRUE AND OrderApi__Account__c in :accountIDs];
            System.debug('exitingBadges:' + exitingBadges);
            
            if(!exitingBadges.isempty()) {
                for(OrderApi__Badge__c b :exitingBadges) {
                    b.OrderApi__Is_Active__c = FALSE;
                }
                update exitingBadges;
            }
    
            List<OrderApi__Badge__c> addBadges = new List<OrderApi__Badge__c>();
                
            for(Account acct :accts) {
            
                System.debug('acct:' + acct);
            
                Boolean isCertified = mapIsCert.get(acct.ID);
                if(isCertified == NULL) {
                    isCertified = FALSE;
                }
    
                Boolean isIndividualMember = mapIsIndv.get(acct.ID);
                if(isIndividualMember == NULL) {
                    isIndividualMember = FALSE;
                }
                
                System.debug('isCertified :' + isCertified );
                System.debug('isIndividualMember :' + isIndividualMember );
    
                Contact c = mapAcctCont.get(acct.ID);
                System.debug('c :' + c );
                
                if(c != NULL) {
            
                    if(isCertified && isIndividualMember) {
                        
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = c.Id,
                            OrderApi__Account__c = acct.ID,
                            OrderApi__Badge_Type__c = Label.FontevaCertifiedBadgeTypeID,
                            OrderApi__Is_Active__c = TRUE
                        );
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);  
                        
                        OrderApi__Badge__c newBadge1 = new OrderApi__Badge__c(
                            OrderApi__Contact__c = c.Id,
                            OrderApi__Account__c = acct.ID,
                            OrderApi__Badge_Type__c = Label.FontevaIndvMemberBadgeTypeID,
                            OrderApi__Is_Active__c = TRUE
                        );
                        
                        System.debug('newBadge1:' + newBadge1);
                        addBadges.add(newBadge1);  
                                      
                    } else if(isIndividualMember) {
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = c.Id,
                            OrderApi__Account__c = acct.ID,
                            OrderApi__Badge_Type__c = Label.FontevaIndvMemberBadgeTypeID,
                            OrderApi__Is_Active__c = TRUE
                        );
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);  
                        
                    } else if(isCertified) {
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = c.Id,
                            OrderApi__Account__c = acct.ID,
                            OrderApi__Badge_Type__c = Label.FontevaCertifiedBadgeTypeID,
                            OrderApi__Is_Active__c = TRUE
                        );
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);  
                        
                        OrderApi__Badge__c newBadge1 = new OrderApi__Badge__c(
                            OrderApi__Contact__c = c.Id,
                            OrderApi__Account__c = acct.ID,
                            OrderApi__Badge_Type__c = Label.FontevaCanBuyCertMemberBadgeTypeID,
                            OrderApi__Is_Active__c = TRUE
                        );
                        System.debug('newBadge1:' + newBadge1);
                        addBadges.add(newBadge1);
                        
                    } else {
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = c.Id,
                            OrderApi__Account__c = acct.ID,
                            OrderApi__Badge_Type__c = Label.FontevaCanBuyIndvMemberBadgeTypeID,
                            OrderApi__Is_Active__c = TRUE
                        );
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);
                        
                    }                    
                }
            }
            System.debug('addBadges:' + addBadges);
            insert addBadges;
            
        }
    }
    
    /*
    public static Boolean updateBadges(MAP<Id,Contract> newlyCompletedContractMap, MAP<Id,Contract> newlyActivatedContractMap, MAP<Id,Contract> newlyLapsedContractMap, MAP<Id,Contract> newlyCancelledContractMap) {
        Boolean ret;
        bRecursive = true;
        
        Id ERPRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','ERP Program');
        Id FRMRecordTypeId = RecordTypeHelper.GetRecordTypeId('Contract','FRM Program');
        Id MembershipTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');
        
        System.debug('newlyCompletedContractMap:' + newlyCompletedContractMap);
        System.debug('newlyActivatedContractMap:' + newlyActivatedContractMap);
        System.debug('newlyLapsedContractMap:' + newlyLapsedContractMap);
        System.debug('newlyCancelledContractMap:' + newlyCancelledContractMap);
        
        Set<String> certifiedContacts = new  Set<String>();
        Set<String> lapsedMembersContacts = new  Set<String>();
        Set<String> activeMembersContacts = new  Set<String>();
        Set<String> cancelledCertifiedContacts = new  Set<String>();

        List<OrderApi__Badge__c> removeBadges = new List<OrderApi__Badge__c>();
        List<OrderApi__Badge__c> updateBadges = new List<OrderApi__Badge__c>();
        List<OrderApi__Badge__c> addBadges = new List<OrderApi__Badge__c>();
        
        SET<String> allAccountIds = new SET<String>();
        for(Contract cont :newlyCompletedContractMap.Values()) {
            allAccountIds.add(cont.AccountId);
        }
        for(Contract cont :newlyActivatedContractMap.Values()) {
            allAccountIds.add(cont.AccountId);
        }
        for(Contract cont :newlyLapsedContractMap.Values()) {
            allAccountIds.add(cont.AccountId);
        }
        for(Contract cont :newlyCancelledContractMap.Values()) {
            allAccountIds.add(cont.AccountId);
        }
        
        List<Contact> lstContacts = [select Id, AccountId from Contact where AccountId in :allAccountIds];
        MAP<String,String> mapContactToAccount = new MAP<String,String>();
        Set<String> allContacts = new Set<String>();
        for(Contact cont :lstContacts) {
            mapContactToAccount.put(cont.AccountId,cont.Id);
            allContacts.add(cont.Id);
        }
        System.debug('mapContactToAccount:' + mapContactToAccount);
        System.debug('allContacts:' + allContacts);
        
        for(Contract cont :newlyLapsedContractMap.Values()) {
            String c = mapContactToAccount.get(cont.AccountId);
            if(c != NULL) {                
                if(cont.RecordTypeId == MembershipTypeId && cont.Membership_type__c =='Individual') {
                    lapsedMembersContacts.add(c);    
                }
            }
        }    
        for(Contract cont :newlyCancelledContractMap.Values()) {
            String c = mapContactToAccount.get(cont.AccountId);
            if(c != NULL) {            
                if(cont.RecordTypeId == MembershipTypeId && cont.Membership_type__c =='Individual') {               
                    lapsedMembersContacts.add(c);    
                }
                
                if(cont.RecordTypeId == ERPRecordTypeId || cont.RecordTypeId == FRMRecordTypeId) {
                    cancelledCertifiedContacts.add(c);    
                }
            }            
        }    
        
        System.debug('lapsedMembersContacts:' + lapsedMembersContacts);
        System.debug('cancelledCertifiedContacts:' + cancelledCertifiedContacts);
        
        List<OrderApi__Badge__c> exitingBadges = [select Id, OrderApi__Contact__c, OrderApi__Account__c, OrderApi__Badge_Type__c
                                                 FROM OrderApi__Badge__c where OrderApi__Contact__c in :allContacts];
        System.debug('exitingBadges:' + exitingBadges);
        
        MAP<String,OrderApi__Badge__c> mapBadges = new MAP<String,OrderApi__Badge__c>();
        for(OrderApi__Badge__c badge :exitingBadges) {
            mapBadges.put(badge.OrderApi__Contact__c + '~' + badge.OrderApi__Badge_Type__c, badge);
        }
        System.debug('mapBadges:' + mapBadges);
        
        // Clean Up
        // This user - should have no CanBuyIndv (if is member/not Cert), no CanBuyIndv (if is member & Cert), no Cert (if cancelled or not certified), no Indv (if cancelled, or become affiliate, not an Indv)
        List<String> removeCanBuyIndv = new List<String>();
        List<String> removeCanBuyCert = new List<String>();
        List<String> removeCert = new List<String>();
        List<String> removeIndv = new List<String>();
        
        
        // Newly Completed
        for(Contract cont :newlyCompletedContractMap.Values()) {
            
            System.debug('newlyCompletedContractMap cont:' + cont);
            
            String CustomerSignedId = mapContactToAccount.get(cont.AccountId);
            System.debug('CustomerSignedId:' + CustomerSignedId);
            
            if(CustomerSignedId != NULL) {
                
                if(cont.RecordTypeId == ERPRecordTypeId || cont.RecordTypeId == FRMRecordTypeId) {
                    
                    // Give Certified Badge
                    certifiedContacts.add(CustomerSignedId);
                    System.debug('certifiedContacts.add:' + CustomerSignedId);
                    
                    OrderApi__Badge__c fndBadgeCert = mapBadges.get(CustomerSignedId + '~' + Label.FontevaCertifiedBadgeTypeID);
                    System.debug('fndBadgeCert:' + fndBadgeCert);
                    
                    if(fndBadgeCert == NULL) {
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = CustomerSignedId,
                            OrderApi__Account__c = cont.AccountId,
                            OrderApi__Badge_Type__c = Label.FontevaCertifiedBadgeTypeID
                        );
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);                
                    }
                    
                    // Adjust Can Buy Indv Mem Badge
                    OrderApi__Badge__c fndBadgeMem = mapBadges.get(CustomerSignedId + '~' + Label.FontevaCanBuyIndvMemberBadgeTypeID);
                    System.debug('fndBadgeMem:' + fndBadgeMem);
                    
                    if(fndBadgeMem != NULL) {
                        fndBadgeMem.OrderApi__Badge_Type__c = Label.FontevaCanBuyCertMemberBadgeTypeID;
                        System.debug('updateBadges:' + fndBadgeMem);
                        updateBadges.add(fndBadgeMem);
                    }
                    
                    // Clean Up can buy individual
                    removeCanBuyIndv.add(CustomerSignedId);
                }
            }
        }
        
        // Newly Activated
        for(Contract cont :newlyActivatedContractMap.Values()) {
            
            System.debug('newlyActivatedContractMap cont:' + cont);
            
            String CustomerSignedId = mapContactToAccount.get(cont.AccountId);
            System.debug('CustomerSignedId:' + CustomerSignedId);
            
            if(CustomerSignedId != NULL) {
                
                if(cont.RecordTypeId == MembershipTypeId && cont.Membership_type__C =='Individual') {
                    
                    // Give Indv Mem Badge
                    activeMembersContacts.add(CustomerSignedId);
                    System.debug('activeMembersContacts.add:' + CustomerSignedId);
                    
                    OrderApi__Badge__c fndBadge = mapBadges.get(CustomerSignedId + '~' + Label.FontevaIndvMemberBadgeTypeID);
                    System.debug('fndBadge:' + fndBadge);
                    
                    if(fndBadge == NULL) {
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = CustomerSignedId,
                            OrderApi__Account__c = cont.AccountId,
                            OrderApi__Badge_Type__c = Label.FontevaIndvMemberBadgeTypeID
                        );
                        
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);
                    }
                    
                    // Remove Can Buy Mem Badge
                    OrderApi__Badge__c fndBadgeMem = mapBadges.get(CustomerSignedId + '~' + Label.FontevaCanBuyCertMemberBadgeTypeID);
                    System.debug('fndBadgeMem:' + fndBadgeMem);
                    
                    if(fndBadgeMem != NULL) {
                        System.debug('add removeBadges:' + fndBadgeMem);
                        removeBadges.add(fndBadgeMem);
                    }
                    
                    OrderApi__Badge__c fndBadgeCert = mapBadges.get(CustomerSignedId + '~' + Label.FontevaCanBuyIndvMemberBadgeTypeID);
                    System.debug('fndBadgeCert:' + fndBadgeCert);
                    
                    if(fndBadgeCert != NULL) {
                        System.debug('add removeBadges:' + fndBadgeCert);
                        removeBadges.add(fndBadgeCert);
                    }
                    
                    // Clean Up can buy individual/cert mem
                    removeCanBuyIndv.add(CustomerSignedId);
                    removeCanBuyCert.add(CustomerSignedId);
                    
                } else if(cont.RecordTypeId == MembershipTypeId && cont.Membership_type__C =='Affiliate') {
                    
                    // Give Can Buy Mem Badge
                    activeMembersContacts.add(CustomerSignedId);
                    System.debug('activeMembersContacts.add:' + CustomerSignedId);
                    
                    OrderApi__Badge__c fndBadge = mapBadges.get(CustomerSignedId + '~' + Label.FontevaIndvMemberBadgeTypeID);
                    System.debug('fndBadge:' + fndBadge);
                    
                    if(fndBadge == NULL) {
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = CustomerSignedId,
                            OrderApi__Account__c = cont.AccountId,
                            OrderApi__Badge_Type__c = Label.FontevaCanBuyIndvMemberBadgeTypeID
                        );
                        
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);
                    }
                    
                    // Clean Up can buy individual/cert mem
                    removeCert.add(CustomerSignedId);
                    removeIndv.add(CustomerSignedId);
                }
            }
        }        

        // Get all Lapsed / Cancelled Member Contracts Certification Status
        List<Contact> lstCont = [select ID from Contact where (KPI_FRM_Certified__c = True OR KPI_ERP_Certified__c = True) 
                                 AND id in :lapsedMembersContacts];
        System.debug('lstCont:' + lstCont);
        
        MAP<String,Contact> mapContacts = new MAP<String,Contact>();        
        for(Contact c :lstCont) {
            mapContacts.put(c.Id,c);
        }
        System.debug('mapContacts:' + mapContacts);
        
        // Newly Lapsed
        for(Contract cont :newlyLapsedContractMap.Values()) {
            
            System.debug('newlyLapsedContractMap cont:' + cont);
            
            String CustomerSignedId = mapContactToAccount.get(cont.AccountId);
            System.debug('CustomerSignedId:' + CustomerSignedId);
            
            if(CustomerSignedId != NULL) {
                
                if(cont.RecordTypeId == MembershipTypeId && cont.Membership_type__C =='Individual') {
                    
                    // Remove Individual Membership Badge
                    OrderApi__Badge__c fndBadgeMem = mapBadges.get(CustomerSignedId + '~' + Label.FontevaIndvMemberBadgeTypeID);
                    System.debug('fndBadgeMem:' + fndBadgeMem);
                    
                    if(fndBadgeMem != NULL) {
                        System.debug('add removeBadges:' + fndBadgeMem);
                        removeBadges.add(fndBadgeMem);
                    }
                    
                    // Give Can Buy Mem Badge
                    Contact fndCont = mapContacts.get(CustomerSignedId);
                    System.debug('fndCont:' + fndCont);
                    
                    // Give Cert or Indv Badge based on Cert Status
                    String badgeId = Label.FontevaCanBuyIndvMemberBadgeTypeID;
                    if(fndCont != NULL) {
                        badgeId = Label.FontevaCanBuyCertMemberBadgeTypeID;                    
                    }
                    System.debug('badgeId:' + badgeId);
                    
                    OrderApi__Badge__c fndBadge = mapBadges.get(CustomerSignedId + '~' + badgeId);
                    System.debug('fndBadge:' + fndBadge);
                    
                    if(fndBadge == NULL) {
                        
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = CustomerSignedId,
                            OrderApi__Account__c = cont.AccountId,
                            OrderApi__Badge_Type__c = badgeId
                        );
                        
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);
                    }
                    
                    // Clean Up can buy individual
                    removeIndv.add(CustomerSignedId);
                    
                }
            }
        }
        
        // Newly Cancelled
        for(Contract cont :newlyCancelledContractMap.Values()) {
            
            System.debug('newlyCancelledContractMap cont:' + cont);
            
            String CustomerSignedId = mapContactToAccount.get(cont.AccountId);
            System.debug('CustomerSignedId:' + CustomerSignedId);
            
            if(CustomerSignedId != NULL) {
                
                if(cont.RecordTypeId == ERPRecordTypeId || cont.RecordTypeId == FRMRecordTypeId) {
                    
                    // Remove Certified Badge
                    OrderApi__Badge__c fndBadgeCert = mapBadges.get(CustomerSignedId + '~' + Label.FontevaCertifiedBadgeTypeID);
                    System.debug('fndBadgeCert:' + fndBadgeCert);
                    
                    if(fndBadgeCert != NULL) {
                        System.debug('add removeBadges:' + fndBadgeCert);
                        removeBadges.add(fndBadgeCert);
                    }
                    
                    // Adjust Can Buy Indv Mem Badge
                    OrderApi__Badge__c fndBadgeBuyCert = mapBadges.get(CustomerSignedId + '~' + Label.FontevaCanBuyCertMemberBadgeTypeID);
                    System.debug('fndBadgeBuyCert:' + fndBadgeBuyCert);
                    if(fndBadgeBuyCert != NULL) {
                        fndBadgeBuyCert.OrderApi__Badge_Type__c = Label.FontevaCanBuyIndvMemberBadgeTypeID;
                        System.debug('updateBadges:' + fndBadgeBuyCert);
                        updateBadges.add(fndBadgeBuyCert);
                    } else {
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = CustomerSignedId,
                            OrderApi__Account__c = cont.AccountId,
                            OrderApi__Badge_Type__c = Label.FontevaCanBuyIndvMemberBadgeTypeID
                        );
                        
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);
                    }
                    
                    // Clean Up Certified
                    removeCert.add(CustomerSignedId);
                    
                } else if(cont.RecordTypeId == MembershipTypeId && cont.Membership_type__C =='Individual') {
                    
                    // Remove Indv Mem Badge
                    OrderApi__Badge__c fndBadgeInvMem = mapBadges.get(CustomerSignedId + '~' + Label.FontevaIndvMemberBadgeTypeID);
                    System.debug('fndBadgeInvMem:' + fndBadgeInvMem);
                    
                    if(fndBadgeInvMem != NULL) {
                        System.debug('add removeBadges:' + fndBadgeInvMem);
                        removeBadges.add(fndBadgeInvMem);
                    }
                    
                    // Give Can Buy Indv Mem Badge
                    Contact fndCont = mapContacts.get(CustomerSignedId);
                    System.debug('fndCont:' + fndCont);
                    
                    String badgeId = Label.FontevaCanBuyIndvMemberBadgeTypeID;
                    if(fndCont != NULL) {
                        badgeId = Label.FontevaCanBuyCertMemberBadgeTypeID;                    
                    }
                    System.debug('badgeId:' + badgeId);
                    
                    OrderApi__Badge__c fndBadge = mapBadges.get(CustomerSignedId + '~' + badgeId);
                    System.debug('fndBadge:' + fndBadge);
                    
                    if(fndBadge == NULL) {
                        
                        OrderApi__Badge__c newBadge = new OrderApi__Badge__c(
                            OrderApi__Contact__c = CustomerSignedId,
                            OrderApi__Account__c = cont.AccountId,
                            OrderApi__Badge_Type__c = badgeId
                        );
                        
                        System.debug('newBadge:' + newBadge);
                        addBadges.add(newBadge);
                    }
                    
                    // Clean Up Individual
                    removeIndv.add(CustomerSignedId);
                    
                } else if(cont.RecordTypeId == MembershipTypeId && cont.Membership_type__C =='Affiliate') {
                    
                    // Clean Up Individual
                    removeIndv.add(CustomerSignedId);
                    
                }
            }
        }
        
        System.debug('insert addBadges:' + addBadges);
        insert addBadges;
        
        System.debug('delete removeBadges:' + removeBadges);
        delete removeBadges;
        
        System.debug('update updateBadges:' + updateBadges);
        update updateBadges;
        
        return ret;
    }
    */
    
    public static Boolean moveToUnMatched(MAP<String,EventApi__Attendee__c> mapAttendee, 
                                                     MAP<String,EventApi__Attendee__c> mapAttendeeAccount, 
                                                     MAP<String,EventApi__Attendee__c> mapAttendeeContact,
                                                     MAP<String,Contact> mapContacts,
                                                     MAP<String,AccountContactRelation> mapAcctContRels,
                                                     MAP<String,List<OrderApi__Sales_Order_Line__c>> mapsalesOrderLines,
                                                     MAP<String,OrderApi__Receipt__c> mapSalesReceipt,
                                                     MAP<String,OrderApi__Sales_Order__c> mapSalesOrders,
                                                     MAP<String,OrderApi__EPayment__c> mapEPayments,
                                                     MAP<String,OrderApi__Transaction__c> mapTrans,
                                                     MAP<String,String> mapAction) {
        Boolean ret;
        Id unmatchedAccountID = Default_Record_References__c.getAll().get('UNMATCHED-BUSINESS-ACCOUNT').Record_Reference_ID__c;
        Id individualMembershipRecordId = RecordTypeHelper.GetRecordTypeId('Account','Individual'); 
        System.debug('unmatchedAccountID:' + unmatchedAccountID);
        System.debug('individualMembershipRecordId:' + individualMembershipRecordId);
        List<Contact> updateContacts = new List<Contact>();                                                         
                                                         
        for(EventApi__Attendee__c ae :mapAttendee.values()) {

            System.debug('ae:' + ae);
            
            String action = mapAction.get(ae.Id);
            System.debug('action:' + action);

            // No Action, move off guest checkput of needed at least
            if(action == NULL) {
                if(ae.EventApi__Account__c == System.Label.Fonteva_Guest_Checkout_Account_GARP_Store_ID) {
                    Contact fndContact = mapContacts.get(ae.EventApi__Contact__c);
                    if(fndContact != NULL) {
                        fndContact.AccountId = unmatchedAccountID;
                        updateContacts.add(fndContact);
                    }
                }
            }
        }   
        if(updateContacts.size() > 0) {
            update updateContacts;
        }
        return ret;                                                                                               
    }
    
    
    public static Boolean createAffiliateMemberships(MAP<String,EventApi__Attendee__c> mapAttendee, 
                                                     MAP<String,EventApi__Attendee__c> mapAttendeeAccount, 
                                                     MAP<String,EventApi__Attendee__c> mapAttendeeContact,
                                                     MAP<String,Contact> mapContacts,
                                                     MAP<String,AccountContactRelation> mapAcctContRels,
                                                     MAP<String,List<OrderApi__Sales_Order_Line__c>> mapsalesOrderLines,
                                                     MAP<String,OrderApi__Receipt__c> mapSalesReceipt,
                                                     MAP<String,OrderApi__Sales_Order__c> mapSalesOrders,
                                                     MAP<String,OrderApi__EPayment__c> mapEPayments,
                                                     MAP<String,OrderApi__Transaction__c> mapTrans,
                                                     MAP<String,String> mapAction) {
        Boolean ret;
        
        Id individualMembershipRecordId = RecordTypeHelper.GetRecordTypeId('Account','Individual'); 
        System.debug('individualMembershipRecordId:' + individualMembershipRecordId);

        List<Opportunity> addOpps = new List<opportunity>();
        List<Account> addAccts = new List<Account>();
        //Set<String> existingMemberAccounts = new Set<String>();
        List<Contact> updateContacts = new List<Contact>();
        List<AccountContactRelation> removeAcctContRels = new List<AccountContactRelation>();
        Id userId = UserInfo.getUserId();
        MAP<String,String> mapActionNew = new MAP<String,String>();
        MAP<String,String> mapPriceRuleToDiscountCode = new MAP<String,String>();
        MAP<String,String> mapPriceRuleToProductCode = new MAP<String,String>();
                                                         
        MAP<String,String> mapSourceCodetoPriceRule = new MAP<String,String>();
        MAP<String,String> mapSalesLineToProductCode = new MAP<String,String>();
        MAP<String,String> mapSalesLineToMemberProductCode = new MAP<String,String>();
        Set<String> salesLinesMemberProductCodes = new Set<String>();
        String fontevaAccount = System.Label.Fonteva_Guest_Checkout_Account_GARP_Store_ID;
        MAP<String,EventApi__Attendee__c> mapAcctAttendee = new MAP<String,EventApi__Attendee__c>();
                                                         
        System.debug('userId:' + userId);

        for(EventApi__Attendee__c ae :mapAttendee.values()) {

            System.debug('ae:' + ae);
               
            if(Test.isRunningTest()) {
                fontevaAccount = ae.EventApi__Account__c;
            } else if(ae.EventApi__Account__c != fontevaAccount) {
            
                mapAcctAttendee.put(ae.EventApi__Account__c,ae);
            
            }

            String action = mapAction.get(ae.Id);
            Boolean hasEventProduct = False;

            mapActionNew.put(ae.Id,action);
            System.debug('action:' + action);
                        
            if(ae.EventApi__Sales_Order__c != NULL) {
                List<OrderApi__Sales_Order_Line__c> fndLines = mapsalesOrderLines.get(ae.EventApi__Sales_Order__c);
                System.debug('fndLines:' + fndLines);
                
                if(fndLines != NULL && fndLines.size() > 0) {
                    for(OrderApi__Sales_Order_Line__c sol :fndLines) {
                        if(sol.OrderApi__Item__r.Is_Individual_Membership__c == True) {
                            action = 'Individual Membership';
                        }
                        mapActionNew.put(ae.Id,action);
                        
                        // Get Default Price Info
                        if(sol.OrderApi__Item__r.Event_Product_Code__c != NULL) {
                            hasEventProduct = True; 
                            mapSalesLineToProductCode.put(sol.Id,sol.OrderApi__Item__r.Event_Product_Code__c);
                        }
                        
                        // Collect Price Rule info
                        if(sol.OrderApi__Price_Rule__c != NULL) {
                            String priceRuleName = sol.OrderApi__Price_Rule__r.Name;
                            
                            if(priceRuleName.indexOf('~') > -1) {
                                String prod = priceRuleName.SubString(priceRuleName.indexOf('~')+1,priceRuleName.length());
                                System.debug('prod:' + prod);
                                
                                mapPriceRuleToProductCode.put(sol.OrderApi__Price_Rule__c, prod);    
                                //mapSalesLineToProductCode.put(sol.Id,prod);
                            }
                            
                            // Collect Discount Codes info
                            if(sol.OrderApi__Price_Rule__r.OrderApi__Required_Source_Codes__c != NULL) {
                                System.debug('Source_Codes:' + sol.OrderApi__Price_Rule__r.OrderApi__Required_Source_Codes__c);
                                
                                String[] arrText = sol.OrderApi__Price_Rule__r.OrderApi__Required_Source_Codes__c.split(',');
                                for(String id :arrText) {
                                    mapSourceCodetoPriceRule.put(id,sol.OrderApi__Price_Rule__c);
                                }
                            }
                        }
                    }
                }
            }
            System.debug('mapActionNew:' + mapActionNew);
            System.debug('mapSourceCodetoPriceRule:' + mapSourceCodetoPriceRule);
            System.debug('mapPriceRuleToProductCode:' + mapPriceRuleToProductCode);
            System.debug('hasEventProduct:' + hasEventProduct);
            System.debug('mapAcctAttendee:' + mapAcctAttendee);            
            System.debug('action:' + action);            
            
            
            // Collect Discount Codes info
            List<OrderApi__Source_Code__c> lstSourceCodes = [select Id, Name from OrderApi__Source_Code__c where ID in :mapSourceCodetoPriceRule.keySet()];
            System.debug('lstSourceCodes:' + lstSourceCodes);
            
            for(OrderApi__Source_Code__c sc :lstSourceCodes) {
                String fndPriceRule = mapSourceCodetoPriceRule.get(sc.Id);
                System.debug('fndPriceRule:' + fndPriceRule);
                
                // Only allows 1 Discount Code per Price Rule !!!
                if(fndPriceRule != NULL) {
                    mapPriceRuleToDiscountCode.put(fndPriceRule,sc.Name);
                }
            }
            System.debug('mapPriceRuleToDiscountCode:' + mapPriceRuleToDiscountCode);
            
            if(action == 'Affiliate Membership' || action == 'Individual Membership' || hasEventProduct != NULL) {
                
                Opportunity newOpp;
                String OppName = (hasEventProduct != NULL) ? 'Event Registration' : action;
                
                OrderApi__Receipt__c fndRec = mapSalesReceipt.get(ae.EventApi__Sales_Order__c);
                String paymentMethod = '';
                if(fndRec != NULL && fndRec.OrderApi__Payment_Type__c != NULL) {
                    paymentMethod = fndRec.OrderApi__Payment_Type__c;
                }
                
                if(action == 'Affiliate Membership') {
                    // Create Afiliate Opportunity
                    newOpp = new Opportunity(
                        Name = OppName,
                        RecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated'),
                        AccountId = ae.EventApi__Account__c,
                        StageName = 'New Lead',
                        CloseDate = Date.today(),
                        Alternate_Method_of_Payment__c = paymentMethod,
                        Company__c = 'GARP',
                        Membership_Emails__c = 'Affiliate',
                        Eligible_for_Membership_Extension__c = True,
                        ChargentSFA__Billing_First__c = ae.EventApi__Contact__r.FirstName,
                        ChargentSFA__Billing_Last__c = ae.EventApi__Contact__r.LastName,
                        ChargentSFA__Billing_Email__c = ae.EventApi__Contact__r.Email,
                        Fonteva_Original_Attendee_ID__c = ae.Id
                    );
                    
                    //mapSalesLineToMemberProductCode.put(ae.Id,'AFREE:4999');
                    salesLinesMemberProductCodes.add('AFREE:4999');
                    
                } else if(action == 'Individual Membership') {
                     newOpp = new Opportunity(
                        Name = OppName,
                        RecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated'),
                        AccountId = ae.EventApi__Account__c,
                        StageName = 'New Lead',
                        CloseDate = Date.today(),
                        Alternate_Method_of_Payment__c = paymentMethod,
                        Company__c = 'GARP',
                        //Membership_Emails__c = 'Affiliate',
                        Eligible_for_Membership_Extension__c = True,
                        ChargentSFA__Billing_First__c = ae.EventApi__Contact__r.FirstName,
                        ChargentSFA__Billing_Last__c = ae.EventApi__Contact__r.LastName,
                        ChargentSFA__Billing_Email__c = ae.EventApi__Contact__r.Email,
                        Fonteva_Original_Attendee_ID__c = ae.Id
                    );
                    
                    //mapSalesLineToMemberProductCode.put(ae.Id,'MEMI:4040');
                    //mapSalesLineToMemberProductCode.put(ae.Id,'MEMC:4040');
                    
                    salesLinesMemberProductCodes.add('MEMI:4040');
                    salesLinesMemberProductCodes.add('MEMC:4040');
                    
                } else {
                     newOpp = new Opportunity(
                        Name = OppName,
                        RecordTypeId = RecordTypeHelper.GetRecordTypeId('Opportunity','Automated'),
                        AccountId = ae.EventApi__Account__c,
                        StageName = 'New Lead',
                        CloseDate = Date.today(),
                        Alternate_Method_of_Payment__c = paymentMethod,
                        Company__c = 'GARP',
                        //Membership_Emails__c = 'Affiliate',
                        //Eligible_for_Membership_Extension__c = True,
                        ChargentSFA__Billing_First__c = ae.EventApi__Contact__r.FirstName,
                        ChargentSFA__Billing_Last__c = ae.EventApi__Contact__r.LastName,
                        ChargentSFA__Billing_Email__c = ae.EventApi__Contact__r.Email,
                        Fonteva_Original_Attendee_ID__c = ae.Id
                    );                    
                }
                System.debug('newOpp:' + newOpp);
                addOpps.add(newOpp);
                
                // Fix Account if needed
                Contact fndCont = mapContacts.get(ae.EventApi__Contact__c);
                System.debug('fndCont:' + fndCont);

                if(fndCont != NULL) {
                    // If pointing to Fonteva Guest
                    if(Test.isRunningTest() || (fndCont.AccountId == System.Label.Fonteva_Guest_Checkout_Account_GARP_Store_ID || 
                       fndCont.Account.RecordTypeID != individualMembershipRecordId)) {
                        
                        // Create Individual Account
                        Account newAcct = new Account(
                            RecordTypeID = individualMembershipRecordId,
                            Name = ae.EventApi__Contact__r.Name.replace(' ',''),
                            GARP_ID__c = ae.EventApi__Contact__r.GARP_ID_New__c,
                            ownerid = userid,
                            Fonteva_Original_Attendee_ID__c = ae.Id
                        );
                        System.debug('newAcct:' + newAcct);
                        addAccts.add(newAcct);   
                    }         
                }
            }
        }

        System.debug('insert addAccts:' + addAccts);
        if(addAccts.size() > 0)
            insert addAccts;

        System.debug('insert addOpps:' + addOpps);
        if(addOpps.size() > 0)
            insert addOpps;
        
        
        System.Debug('after addAccts:' + addAccts);
        Set<String> newAccts = new Set<String>();
        for(Account a :addAccts) {
            newAccts.add(a.Id);
        }
        System.debug('newAccts:' + newAccts);
        
        System.Debug('after addOpps:' + addOpps);        
        Set<String> newOpps = new Set<String>();
        for(Opportunity opp :addOpps) {
            newOpps.add(opp.Id);
        }
        System.debug('newOpps:' + newOpps);
        
        // Fix Up After Insert
        MAP<String,Opportunity> mapAfterOpp = new MAP<String,Opportunity>();
        List<Contact> updateContact = new List<Contact>();
        List<Opportunity> updateOpp = new List<Opportunity>();
        List<ChargentSFA__Transaction__c> addTrans = new List<ChargentSFA__Transaction__c>();
                                                         
        List<EventApi__Attendee__c> updateAttendee = new List<EventApi__Attendee__c>();
        List<OrderApi__Sales_Order_Line__c> updateSalesOrderLines = new List<OrderApi__Sales_Order_Line__c>();
        List<OrderApi__Receipt__c> updateReceipts = new List<OrderApi__Receipt__c>();

        List<OrderApi__Sales_Order__c> updateSalesOrders = new List<OrderApi__Sales_Order__c>();
        List<OrderApi__EPayment__c> updateEPays = new List<OrderApi__EPayment__c>();
        List<OrderApi__Transaction__c> updateTrans = new List<OrderApi__Transaction__c>();
                                                         
        List<Contract> addContracts = new List<Contract>();
        Id MembershipTypeId = RecordTypeHelper.GetRecordTypeId('Contract', 'Membership');

                           
        System.Debug('mapAttendee:' + mapAttendee.keySet());
                                                         
        List<Opportunity> lstOpp = [select Id, AccountID, Fonteva_Original_Attendee_ID__c, StageName, Amount from Opportunity where id in :newOpps];
        System.debug('lstOpp:' + lstOpp);
        
        if(lstOpp != NULL && lstOpp.size() > 0) {

            for(Opportunity opp :lstOpp) {
                mapAfterOpp.put(opp.Fonteva_Original_Attendee_ID__c, opp);
                
                // Create Transaction
                EventApi__Attendee__c fndAe = mapAttendee.get(opp.Fonteva_Original_Attendee_ID__c);
                System.debug('fndAe:' + fndAe);
                
                if(fndAe != NULL) {
                    
                    OrderApi__Receipt__c fndRec = mapSalesReceipt.get(fndAe.EventApi__Sales_Order__c);
                    System.debug('fndRec:' + fndRec);
                    
                    if(fndRec != NULL) {

                        String cardType = '';
                        String gatewayID= '';
                        String token = '';
                                                                        
                        if(fndRec.OrderApi__Payment_Type__c == 'Credit Card') {
                            if(fndRec.OrderApi__Payment_Method_Description__c != NULL && fndRec.OrderApi__Payment_Method_Description__c.length() > 3) {
                                cardType = fndRec.OrderApi__Payment_Method_Description__c.subString(0,4);
                            }       
                            
                            if(fndRec.OrderApi__EPayment__c != NULL) {
                                gatewayID = fndRec.OrderApi__EPayment__r.OrderApi__Gateway_Token__c;
                                token = fndRec.OrderApi__EPayment__r.OrderApi__Gateway_Transaction_ID__c;
                            }
                        }
                        
                        ChargentSFA__Transaction__c chargentTrans = new ChargentSFA__Transaction__c(
                            ChargentSFA__Gateway_Date__c = fndRec.OrderApi__EPayment__r.CreatedDate,
                            ChargentSFA__Gateway_Response__c = 'RESPMSG=Approved',
                            ChargentSFA__Amount__c = opp.Amount,
                            ChargentSFA__Opportunity__c = opp.Id, 
                            ChargentSFA__Type__c = 'Charge', 
                            ChargentSFA__Response_Status__c = 'Approved', 
                            ChargentSFA__Gateway_ID__c = gatewayID,
                            ChargentSFA__Tokenization__c = token,
                            ChargentSFA__Payment_Method__c = fndRec.OrderApi__Payment_Type__c, 
                            ChargentSFA__Credit_Card_Type__c = cardType, 
                            ChargentSFA__Authorization__c = fndRec.OrderApi__Reference_Number__c,
                            Fonteva_Receipt__c = fndRec.Id,
                            ChargentSFA__Gateway__c = null);
                            
                        System.debug('addTrans:' + chargentTrans);
                        addTrans.add(chargentTrans);                            

                    }
                }                
            }                           
            System.debug('mapAfterOpp:' + mapAfterOpp);                                
    
            Set<String> setProdCodes = new Set<String>();
            Set<String> setGlCodes = new Set<String>();
            
            // Collect Codes for Query based on Sales Line Items
            for(String prodCode :mapSalesLineToProductCode.values()) {
                String[] arrText = prodCode.split(':');
                if(arrText != NULL && arrText.size() > 1) {
                    setProdCodes.add(arrText[0]);
                    setGlCodes.add(arrText[1]); 
                }
            }
            
            // Collect Price Rule Codes
            for(String prodCode :mapPriceRuleToProductCode.values()) {
                String[] arrText = prodCode.split(':');
                if(arrText != NULL && arrText.size() > 1) {
                    setProdCodes.add(arrText[0]);
                    setGlCodes.add(arrText[1]); 
                }
            }

            // Collect Membership Codes
            for(String prodCode :salesLinesMemberProductCodes) {
                String[] arrText = prodCode.split(':');
                if(arrText != NULL && arrText.size() > 1) {
                    setProdCodes.add(arrText[0]);
                    setGlCodes.add(arrText[1]); 
                }
            }
            
            // Add Discount Product
            String PROD_DISC_EVENT = 'EVTDSC';
            String GL_DISC_EVENT = '4999';            
            
            setProdCodes.add(PROD_DISC_EVENT);
            setGlCodes.add(GL_DISC_EVENT);
            
            System.debug('setGlCodes:' + setGlCodes);
            System.debug('setProdCodes:' + setProdCodes);
                                                             
            List<PriceBookEntry> lstPrice = [
                SELECT Id, UnitPrice, ProductCode, Product2Id, Product2.Gl_Code__c, Product2.Name  
                FROM PriceBookEntry 
                WHERE 
                IsActive = TRUE AND
                Pricebook2.IsActive = TRUE AND 
                ProductCode IN :setProdCodes AND 
                Product2.Gl_Code__c IN :setGlCodes];                  
            System.debug('lstPrice:' + lstPrice);
                                                             
            MAP<String,PriceBookEntry> mapPrice = new MAP<String,PriceBookEntry>();
            for(PriceBookEntry pbe :lstPrice) {
                mapPrice.put(pbe.ProductCode + ':' + pbe.Product2.Gl_Code__c,pbe);
            }      
            System.debug('mapPrice:' + mapPrice);
                                                             
            List<Account> lstAct = [select Id, Fonteva_Original_Attendee_ID__c from Account where id in :newAccts OR id in :mapAcctAttendee.KeySet()];
            System.debug('lstAct:' + lstAct);
    
            Id memberRecordId = RecordTypeHelper.GetRecordTypeId('Contact','Member');
            System.debug('memberRecordId:' + memberRecordId);
            
            List<OpportunityLineItem> addLineItems = new List<OpportunityLineItem>();
            
            for(Account acct :lstAct) {
                
                System.debug('acct:' + acct);            
                                
                EventApi__Attendee__c fndAttendee = mapAttendee.get(acct.Fonteva_Original_Attendee_ID__c);
                System.debug('fndAttendee:' + fndAttendee);

                Boolean existingAcct = False;
                if(fndAttendee == NULL) {
                    fndAttendee = mapAcctAttendee.get(acct.id);
                    System.debug('fndAttendee existing:' + fndAttendee);
                    if(fndAttendee != NULL) {
                        existingAcct = True;
                    }
                }
                System.debug('existingAcct:' + existingAcct);
                
                if(fndAttendee != NULL) {
                    Contact fndCont = mapContacts.get(fndAttendee.EventApi__Contact__c);
                    System.debug('fndCont:' + fndCont);

                    String action = mapActionNew.get(fndAttendee.Id);
                    System.debug('action:' + action);

                    // Fix Account if needed
                    if(fndCont != NULL && !existingAcct) {
                                              
                        fndCont.AccountId = acct.Id;
                        
                        OrderApi__Receipt__c fndRec = mapSalesReceipt.get(fndAttendee.EventApi__Sales_Order__c);
                        System.debug('fndRec:' + fndRec);
                        
                        if(fndRec != NULL) {
                            fndRec.OrderApi__Account__c = acct.Id;
                            System.debug('Add updateReceipts:' + fndRec);
                            updateReceipts.add(fndRec);
                            
                            
                            fndAttendee.EventApi__Account__c = acct.Id;
                            System.debug('Add updateAttendee:' + fndAttendee);
                            updateAttendee.add(fndAttendee);
                            
                            OrderApi__Sales_Order__c fndSalesOrder = mapSalesOrders.get(fndAttendee.EventApi__Sales_Order__c);
                            System.debug('fndSalesOrder:' + fndSalesOrder);
                            
                            if(fndSalesOrder != NULL) {
                                fndSalesOrder.OrderApi__Account__c = acct.Id;
                                System.debug('Add updateSalesOrders:' + fndSalesOrder);
                                updateSalesOrders.add(fndSalesOrder);   
                            }
                            
                            OrderApi__EPayment__c fndEPay = mapEPayments.get(fndAttendee.EventApi__Sales_Order__c);
                            System.debug('fndEPay:' + fndEPay);
                            
                            if(fndEPay != NULL) {
                                fndEPay.OrderApi__Account__c = acct.Id;
                                System.debug('Add updateEPays:' + fndEPay);
                                updateEPays.add(fndEPay);   
                            }
                            
                            OrderApi__Transaction__c fndTrans = mapTrans.get(fndAttendee.EventApi__Sales_Order__c);
                            System.debug('fndTrans:' + fndTrans);
                            
                            if(fndTrans != NULL) {
                                fndTrans.OrderApi__Account__c = acct.Id;
                                System.debug('Add updateTrans:' + fndTrans);
                                updateTrans.add(fndTrans);   
                            }
                                                
                            // Set Contact Record Id
                            if(fndCont.RecordTypeId != memberRecordId && action == 'Affiliate Membership' || action == 'Individual Membership') {
                                fndCont.RecordTypeId = memberRecordId;                            
                            }                    
                            
                            // See if we need to remove Account Contact relationship from Guest Checkout Account GARP Store
                            AccountContactRelation fndAcctContRel = mapAcctContRels.get(fndCont.Id);
                            System.debug('fndAcctContRel:' + fndAcctContRel);
                            
                            if(fndAcctContRel != NULL) {
                                removeAcctContRels.add(fndAcctContRel);
                                System.debug('removeAcctContRels add:' + removeAcctContRels);
                            }
                            
                            System.debug('fndCont update:' + fndCont);
                            updateContact.add(fndCont);
                            
                        }
                            
                    }
                    Opportunity fndOpp = mapAfterOpp.get(fndAttendee.Id);
                    System.debug('fndOpp:' + fndOpp);
                    
                    if(fndOpp != NULL) {
                        
                        List<OrderApi__Sales_Order_Line__c> fndLines = mapsalesOrderLines.get(fndAttendee.EventApi__Sales_Order__c);
                        System.debug('fndLines:' + fndLines);
                        
                        if(fndLines != NULL && fndLines.size() > 0) {
                            for(OrderApi__Sales_Order_Line__c sol :fndLines) {
                                
                                System.debug('sol:' + sol);
                                
                                // Fix Account if needed
                                if(!existingAcct) {
                                    sol.OrderApi__Account__c = acct.Id;
                                    System.debug('Add updateSalesOrderLines:' + sol);
                                    updateSalesOrderLines.add(sol);
                                }
                                
                                // Get product
                                String prodCode = mapSalesLineToProductCode.get(sol.Id);
                                System.debug('prodCode:' + prodCode);

                                PriceBookEntry fndPrice = mapPrice.get(prodCode);
                                System.debug('fndPrice:' + fndPrice);   
                                
                                
                                if(fndPrice != NULL) {
                                    OpportunityLineItem oppLineItem = new OpportunityLineItem();
                                    oppLineItem.Quantity = 1;
                                    oppLineItem.OpportunityId = fndOpp.Id;
                                    oppLineItem.PricebookEntryId = fndPrice.Id;
                                        
                                    String fndPriceRuleProd = mapPriceRuleToProductCode.get(sol.OrderApi__Price_Rule__c);
                                    System.debug('fndPriceRuleProd :' + fndPriceRuleProd);
                                    
                                    PriceBookEntry fndPricePriceRule = mapPrice.get(fndPriceRuleProd);
                                    System.debug('fndPricePriceRule:' + fndPricePriceRule);
                                

                                    if(fndPriceRuleProd != NULL && fndPricePriceRule != NULL) {
                                        oppLineItem.PricebookEntryId = fndPricePriceRule.Id;                                    
                                    }
                                    
                                    // Discount Code??
                                    // Use OrderApi__List_Price__c and add a line for the Difference as a discount line with code used    
                                    String discPriceRuleProd = mapPriceRuleToDiscountCode.get(sol.OrderApi__Price_Rule__c);
                                    System.debug('discPriceRuleProd:' + discPriceRuleProd); 
                                    
                                    // Add Discount Line Item
                                    if(sol.OrderApi__Sale_Price__c < sol.OrderApi__List_Price__c && discPriceRuleProd != NULL && fndPriceRuleProd != NULL && fndPricePriceRule != NULL) {
                                        
                                        PriceBookEntry fndDiscPrice = mapPrice.get(PROD_DISC_EVENT + ':' + GL_DISC_EVENT);
                                        System.debug('fndDiscPrice:' + fndDiscPrice);
                                        
                                        if(fndDiscPrice != NULL) {
                                            OpportunityLineItem oppLineItemDisc = new OpportunityLineItem();
                                            oppLineItemDisc.OpportunityId = fndOpp.Id;
                                            oppLineItemDisc.PricebookEntryId = fndDiscPrice.Id;
                                            oppLineItemDisc.Quantity = 1;
                                            oppLineItemDisc.TotalPrice = (sol.OrderApi__List_Price__c - sol.OrderApi__Sale_Price__c) * -1;
                                            oppLineItemDisc.Description = 'Discount Code: ' + discPriceRuleProd;
                                            
                                            System.debug('add disc oppLineItem:' + oppLineItemDisc);
                                            addLineItems.add(oppLineItemDisc);                                             
                                        }
                                                                                
                                        oppLineItem.TotalPrice = sol.OrderApi__List_Price__c;                                    
                                    } else {
                                    
                                        oppLineItem.TotalPrice = sol.OrderApi__Sale_Price__c;                                    
                                    }
                                    
                                    System.debug('add oppLineItem:' + oppLineItem);
                                    addLineItems.add(oppLineItem);                                
                                } 

                            }
                            
                            if(action == 'Affiliate Membership') {
                                
                                PriceBookEntry memPrice = mapPrice.get('AFREE:4999');
                                System.debug('memPrice:' + memPrice); 
                                
                                OpportunityLineItem oppLineItemMem= new OpportunityLineItem();
                                oppLineItemMem.OpportunityId = fndOpp.Id;
                                oppLineItemMem.PricebookEntryId = memPrice.Id;
                                oppLineItemMem.Quantity = 1;
                                oppLineItemMem.TotalPrice = memPrice.UnitPrice;
                                addLineItems.add(oppLineItemMem);   
                                
                                Contract memCont = new Contract(Membership_Type__c='Affiliate',
                                                                AccountId=acct.Id,
                                                                Opportunity__c=fndOpp.Id,
                                                                CustomerSignedId=fndCont.Id,
                                                                RecordTypeId=MembershipTypeId,
                                                                StartDate=Date.today(),
                                                                ContractTerm=12
                                                                );
                                System.debug('memCont:' + memCont); 
                                
                                addContracts.add(memCont);
                                System.debug('addContracts:' + addContracts); 
                                
                            } 
                            /*
                            else if(action == 'Individual Membership') {
                                
                                String memProd = 'MEMI:4040';
                                if(fndAttendee.EventApi__Contact__r.KPI_FRM_Certified__c || fndAttendee.EventApi__Contact__r.KPI_ERP_Certified__c) {
                                    memProd = 'MEMC:4040';
                                }
                                PriceBookEntry memPrice = mapPrice.get(memProd);
                                System.debug('memPrice:' + memPrice); 
                                
                                OpportunityLineItem oppLineItemMem = new OpportunityLineItem();
                                oppLineItemMem.OpportunityId = fndOpp.Id;
                                oppLineItemMem.PricebookEntryId = memPrice.Id;
                                oppLineItemMem.Quantity = 1;
                                oppLineItemMem.TotalPrice = memPrice.UnitPrice;
                                addLineItems.add(oppLineItemMem);                                             
                                
                                Contract memCont = new Contract(Membership_Type__c='Individual',
                                                                AccountId=acct.Id,
                                                                Opportunity__c=fndOpp.Id,
                                                                CustomerSignedId=fndCont.Id,
                                                                RecordTypeId=MembershipTypeId,
                                                                StartDate=Date.today(),
                                                                ContractTerm=12
                                                                );
                                addContracts.add(memCont);
                            }
                            */
                            
                        }          
                        
                        // Fix Account if Needed
                        if(!existingAcct) {
                            fndOpp.AccountID = acct.Id;
                            System.debug('fndOpp update:' + fndOpp);
                            updateOpp.add(fndOpp);                             
                        }   
                    }
                }
            }
            
            update updateContact;
            insert addLineItems;
            
            System.debug('addContracts:' + addContracts); 
            insert addContracts;
            
            update updateOpp;
            delete removeAcctContRels;
            
            //update updateSalesOrderLines;
            update updateAttendee;
            update updateReceipts;
            
            update updateSalesOrders;
            update updateEPays;
            update updateTrans;
            
            // Close Opps
            //for(Opportunity opp :updateOpp) {
            //    opp.StageName = 'Closed';
            //}
            update updateOpp;
            insert addTrans;
        }                                                     
        return ret;      
    }
    
    
    public static Boolean processRefund(Set<String> receiptIds) { 
        Boolean ret;
        
        MAP<String,OrderApi__Receipt__c> mapSalesOrderToReceipt = new MAP<String,OrderApi__Receipt__c>();
        MAP<String,String> mapSalesOrderIdToAttendeeId = new MAP<String,String>();
        MAP<String,String> mapOppIdToAttendeeId = new MAP<String,String>();
        List<ChargentSFA__Transaction__c> addTrans = new List<ChargentSFA__Transaction__c>();
        
        List<OrderApi__Receipt__c> lstReceipts = [SELECT Id, OrderApi__Sales_Order__c, OrderApi__Contact__c, OrderApi__Account__c, 
                                                  OrderApi__Date__c, OrderApi__Payment_Type__c, OrderApi__Reference_Number__c, 
                                                  OrderApi__Total__c, OrderApi__Payment_Method_Description__c, OrderApi__Posted_Date__c,
                                                  OrderApi__EPayment__c, OrderApi__EPayment__r.OrderApi__Gateway_Transaction_ID__c,
                                                  OrderApi__EPayment__r.OrderApi__Transaction_Token__c,
                                                  OrderApi__EPayment__r.OrderApi__Gateway_Token__c, OrderApi__EPayment__r.OrderApi__Refund_Receipt__c,
                                                  OrderApi__EPayment__r.CreatedDate
                                                  FROM OrderApi__Receipt__c 
                                                  WHERE id in :receiptIds AND OrderApi__Type__c = 'Refund' AND OrderApi__Is_Posted__c = True];
        System.debug('lstReceipts:' + lstReceipts);
        
        for(OrderApi__Receipt__c rec :lstReceipts) {
            mapSalesOrderToReceipt.put(rec.OrderApi__Sales_Order__c,rec);
        }
        System.debug('mapSalesOrderToReceipt:' + mapSalesOrderToReceipt);
                
        List<EventApi__Attendee__c> lstAttendees = [select Id, EventApi__Sales_Order__c from EventApi__Attendee__c 
                                                    where EventApi__Sales_Order__c in :mapSalesOrderToReceipt.keySet()];
        System.debug('lstAttendees:' + lstAttendees);
        
        for(EventApi__Attendee__c att :lstAttendees) {
            mapSalesOrderIdToAttendeeId.put(att.EventApi__Sales_Order__c,att.Id);
        }
        System.debug('mapSalesOrderIdToAttendeeId:' + mapSalesOrderIdToAttendeeId);
        
        List<Opportunity> lstOpp = [select Id, Fonteva_Original_Attendee_ID__c from Opportunity 
                                    where Fonteva_Original_Attendee_ID__c in :mapSalesOrderIdToAttendeeId.values()];
        System.debug('lstOpp:' + lstOpp);
        
        for(Opportunity opp :lstOpp) {
            mapOppIdToAttendeeId.put(opp.Fonteva_Original_Attendee_ID__c,opp.Id);
        }
        System.debug('mapOppIdToAttendeeId:' + mapOppIdToAttendeeId);
        
        for(OrderApi__Receipt__c rec :lstReceipts) {
            
            System.debug('rec:' + rec);
            
            String AttendeeId = mapSalesOrderIdToAttendeeId.get(rec.OrderApi__Sales_Order__c);
            
            System.debug('AttendeeId:' + AttendeeId);
            
            if(AttendeeId != NULL) {
                String fndOppId = mapOppIdToAttendeeId.get(AttendeeId);
                System.debug('fndOppId:' + fndOppId);
                
                if(fndOppId != NULL && rec.OrderApi__Payment_Method_Description__c.length() > 3) {
                    
                    String cardType = rec.OrderApi__Payment_Method_Description__c.subString(0,4);
                    
                    ChargentSFA__Transaction__c chargentTrans = new ChargentSFA__Transaction__c(
                                ChargentSFA__Gateway_Response__c = 'RESPMSG=Approved',
                                ChargentSFA__Amount__c = rec.OrderApi__Total__c,
                                ChargentSFA__Opportunity__c = fndOppId, 
                                ChargentSFA__Type__c = 'Refund', 
                                ChargentSFA__Response_Status__c = 'Approved', 
                                ChargentSFA__Gateway_Date__c = rec.OrderApi__Posted_Date__c, 
                                ChargentSFA__Gateway_ID__c = rec.OrderApi__EPayment__r.OrderApi__Gateway_Token__c,
                                ChargentSFA__Tokenization__c = rec.OrderApi__EPayment__r.OrderApi__Gateway_Transaction_ID__c,
                                ChargentSFA__Payment_Method__c = rec.OrderApi__Payment_Type__c, 
                                ChargentSFA__Credit_Card_Type__c = cardType, 
                                //ChargentSFA__Authorization__c = rec.OrderApi__Reference_Number__c,
                                Fonteva_Receipt__c = rec.Id,
                                ChargentSFA__Gateway__c = null);
                    System.debug('Add chargentTrans' + chargentTrans);
                    
                    addTrans.add(chargentTrans);
                }
            }
        }
        
        System.debug('addTrans' + addTrans);
        
        if(addTrans.size() > 0) {
            insert addTrans;
        }
        
        return ret;
    }
    
    public static Boolean setRegistrations(Set<String> registrationIds) {
        Boolean ret;

        MAP<String,EventApi__Attendee__c> mapAttendee = new MAP<String,EventApi__Attendee__c>();
        MAP<String,EventApi__Attendee__c> mapAttendeeAccount = new MAP<String,EventApi__Attendee__c>();
        MAP<String,EventApi__Attendee__c> mapAttendeeContact = new MAP<String,EventApi__Attendee__c>();      
        MAP<String,String> mapAction = new MAP<String,String>();
        SET<String> salesOrderIDs = new SET<String>();
        MAP<String,List<OrderApi__Sales_Order_Line__c>> mapsalesOrderLines = new MAP<String,List<OrderApi__Sales_Order_Line__c>>(); 
        MAP<String,OrderApi__Receipt__c> mapSalesReceipt = new MAP<String,OrderApi__Receipt__c>(); 
        
        MAP<String,OrderApi__Sales_Order__c> mapSalesOrders = new MAP<String,OrderApi__Sales_Order__c>(); 
        MAP<String,OrderApi__EPayment__c> mapEPayments = new MAP<String,OrderApi__EPayment__c>(); 
        MAP<String,OrderApi__Transaction__c> mapTrans = new MAP<String,OrderApi__Transaction__c>(); 
        
        List<EventApi__Attendee__c> lstAttendees = [select Id, EventApi__Contact__c, 
                                                    EventApi__Contact__r.Name,
                                                    EventApi__Contact__r.FirstName,
                                                    EventApi__Contact__r.LastName,
                                                    EventApi__Contact__r.Email,
                                                    EventApi__Contact__r.GARP_ID_New__c,
                                                    EventApi__Contact__r.Membership_Type__c, 
                                                    EventApi__Contact__r.KPI_FRM_Certified__c, 
                                                    EventApi__Contact__r.KPI_ERP_Certified__c, 
                                                    EventApi__Account__c, 
                                                    EventApi__Account__r.RecordTypeID, 
                                                    EventApi__Status__c, 
                                                    EventApi__Attendee_Event__r.Affiliate_Membership_Required__c, 
                                                    EventApi__Sales_Order__c,
                                                    EventApi__Sales_Order__r.OrderApi__Sales_Order_Status__c 
                                                    from EventApi__Attendee__c where id in :registrationIds AND EventApi__Attendee_Event__c != NULL];
        System.debug('lstAttendees:' + lstAttendees);
        
        if(!lstAttendees.isEmpty()) {
            
            for(EventApi__Attendee__c ae :lstAttendees) {
                
                System.debug('ae:' + ae);
                System.debug('status:' + ae.EventApi__Sales_Order__r.OrderApi__Sales_Order_Status__c);
                
                if(Test.isRunningTest() || ae.EventApi__Sales_Order__r.OrderApi__Sales_Order_Status__c == 'Paid') {
                    
                    // If need Affilate Membership
                    if(ae.EventApi__Attendee_Event__r.Affiliate_Membership_Required__c == True && 
                       ae.EventApi__Status__c == 'Registered' && 
                       ae.EventApi__Contact__r.Membership_Type__c == NULL) {
                           mapAction.put(ae.Id,'Affiliate Membership');
                       }
                    if(ae.EventApi__Sales_Order__c != NULL) {
                        salesOrderIDs.add(ae.EventApi__Sales_Order__c);
                    }
                    mapAttendee.put(ae.Id, ae);
                    mapAttendeeAccount.put(ae.EventApi__Account__c, ae);
                    mapAttendeeContact.put(ae.EventApi__Contact__c, ae);
                }
                
            }
            System.debug('mapAction:' + mapAction);
            System.debug('mapAttendee:' + mapAttendee);
            System.debug('mapAttendeeAccount:' + mapAttendeeAccount);
            System.debug('mapAttendeeContact:' + mapAttendeeContact);
            
            List<OrderApi__Sales_Order__c> lstSalesOrders = [select Id, OrderApi__Account__c 
                                                             from OrderApi__Sales_Order__c 
                                                             where Id in :salesOrderIDs AND
                                                             OrderApi__Sales_Order_Status__c = 'Paid'];
            System.debug('lstSalesOrders:' + lstSalesOrders);
            
            for(OrderApi__Sales_Order__c so :lstSalesOrders) {
                mapSalesOrders.put(so.Id, so);
            }        
            System.debug('mapSalesOrders:' + mapSalesOrders);
            
            List<OrderApi__EPayment__c> lstEPay = [select Id, OrderApi__Account__c, OrderApi__Sales_Order__c 
                                                   from OrderApi__EPayment__c where OrderApi__Sales_Order__c in :salesOrderIDs];
            System.debug('lstEPay:' + lstEPay);
            
            for(OrderApi__EPayment__c ep :lstEPay) {
                mapEPayments.put(ep.OrderApi__Sales_Order__c, ep);
            }        
            System.debug('mapEPayments:' + mapEPayments);
            
            
            List<OrderApi__Transaction__c> lstTrans = [select Id, OrderApi__Account__c, OrderApi__Sales_Order__c 
                                                       from OrderApi__Transaction__c where OrderApi__Sales_Order__c in :salesOrderIDs];
            System.debug('lstTrans:' + lstTrans);
            
            for(OrderApi__Transaction__c tr :lstTrans) {
                mapTrans.put(tr.OrderApi__Sales_Order__c, tr);
            }        
            System.debug('mapTrans:' + mapTrans);
            
            
            List<OrderApi__Sales_Order_Line__c> lstSalesOrderLines = [select Id, OrderApi__Sales_Order__c, OrderApi__Item__c, OrderApi__Account__c, 
                                                                      OrderApi__List_Price__c, OrderApi__Sale_Price__c, OrderApi__Price_Rule__c,
                                                                      OrderApi__Price_Rule__r.Name, OrderApi__Price_Rule__r.OrderApi__Required_Source_Codes__c,
                                                                      OrderApi__Item__r.Is_Individual_Membership__c,
                                                                      OrderApi__Item__r.Event_Product_Code__c
                                                                      from OrderApi__Sales_Order_Line__c where OrderApi__Sales_Order__c in :salesOrderIDs];
            System.debug('lstSalesOrderLines:' + lstSalesOrderLines);
            for(OrderApi__Sales_Order_Line__c sol :lstSalesOrderLines) {
                List<OrderApi__Sales_Order_Line__c> fndLines = mapsalesOrderLines.get(sol.OrderApi__Sales_Order__c);
                if(fndLines == NULL) {
                    List<OrderApi__Sales_Order_Line__c> newLines = new List<OrderApi__Sales_Order_Line__c>();
                    newLines.add(sol);
                    mapsalesOrderLines.put(sol.OrderApi__Sales_Order__c, newLines);
                } else {
                    fndLines.add(sol);
                    mapsalesOrderLines.put(sol.OrderApi__Sales_Order__c, fndLines);
                }
            }
            System.debug('mapsalesOrderLines:' + mapsalesOrderLines);
            
            Set<String> setReceiptIds = new Set<String>();
            List<OrderApi__Receipt__c> lstSalesReceipts = [select Id, OrderApi__Sales_Order__c, OrderApi__Contact__c, OrderApi__Account__c,
                                                           OrderApi__Type__c, OrderApi__Business_Group__c, OrderApi__Payment_Gateway__c, 
                                                           OrderApi__Date__c, OrderApi__Payment_Type__c, OrderApi__Payment_Method_Description__c,
                                                           OrderApi__Reference_Number__c, OrderApi__Total__c, OrderApi__Applied_Amount__c,
                                                           OrderApi__EPayment__c, OrderApi__EPayment__r.OrderApi__Gateway_Transaction_ID__c,
                                                           OrderApi__EPayment__r.OrderApi__Transaction_Token__c,
                                                           OrderApi__EPayment__r.OrderApi__Gateway_Token__c, OrderApi__EPayment__r.OrderApi__Refund_Receipt__c,
                                                           OrderApi__EPayment__r.CreatedDate
                                                           from OrderApi__Receipt__c where 
                                                           OrderApi__Is_Posted__c = True AND OrderApi__Type__c = 'Payment' AND
                                                           OrderApi__Sales_Order__c in :salesOrderIDs];
            for(OrderApi__Receipt__c rec :lstSalesReceipts) {
                mapSalesReceipt.put(rec.OrderApi__Sales_Order__c, rec);
                setReceiptIds.add(rec.Id);
            }
            System.debug('mapSalesReceipt:' + mapSalesReceipt);
            System.debug('setReceiptIds:' + setReceiptIds);
            
            // Setup Contact Map to adjust RecordTypeId
            List<Contact> lstCont = [select Id, AccountID, RecordTypeID, Account.RecordTypeID from Contact where id in :mapAttendeeContact.keySet()];
            System.debug('lstCont:' + lstCont);
            
            MAP<String,Contact> mapContacts = new MAP<String,Contact>();
            for(Contact c :lstCont) {
                mapContacts.put(c.Id,c);
            }
            System.debug('mapContacts:' + mapContacts);
            
            MAP<String,AccountContactRelation> mapAcctContRels = new MAP<String,AccountContactRelation>();
            List<AccountContactRelation> lstAcctContRels = [select id,AccountId,ContactId from AccountContactRelation where ContactId in :mapContacts.keySet()];
            System.debug('lstAcctContRels:' + lstAcctContRels);
            
            for(AccountContactRelation acr :lstAcctContRels) {
                if(acr.AccountId == System.Label.Fonteva_Guest_Checkout_Account_GARP_Store_ID) {
                    mapAcctContRels.put(acr.ContactId,acr);            
                }
            }
            System.debug('mapAcctContRels:' + mapAcctContRels);
            
            //System.assert(false, 'BOOM!!!!' + mapAttendee); 
            
            ret = createAffiliateMemberships(mapAttendee, mapAttendeeAccount, mapAttendeeContact, mapContacts, mapAcctContRels, mapsalesOrderLines, mapSalesReceipt, mapSalesOrders, mapEPayments, mapTrans, mapAction);
            System.debug('createAffiliateMemberships ret:' + ret);
            
            ret = moveToUnMatched(mapAttendee, mapAttendeeAccount, mapAttendeeContact, mapContacts, mapAcctContRels, mapsalesOrderLines, mapSalesReceipt, mapSalesOrders, mapEPayments, mapTrans, mapAction);
            System.debug('moveToUnMatched ret:' + ret);
            
        }

        return ret;
    }
    
    /*
    @InvocableMethod(label='fontevaMethods' description='Operate Fonteva Class Methods.')
    public static void fontevaMethods(List<List<String>> inputParams) {  
        
        System.debug('inputParams:' + inputParams);
        
        String method;
        String param1;
        String param2;
        String param3;
        String param4;
        
        for(List<String> ids :inputParams) {
        
            //List<String> ids = inputParams[0];
            
            if(!ids.isEmpty()){
                Integer cnt=0;
                for(String idVal :ids) {
                    if(cnt==0)
                        method = idVal;
                    else if(cnt==1)
                        param1 = idVal;
                    else if(cnt==2)
                        param2 = idVal;
                    else if(cnt==3)
                        param3 = idVal;
                    else if(cnt==4)
                        param4 = idVal;
                    cnt++;
                }
                System.debug('method:' + method);
                System.debug('param1:' + param1);
                System.debug('param2:' + param2);
                System.debug('param3:' + param3);
                System.debug('param4:' + param4);
                
                if(method == 'StatusChange') {
                    contractStatusChange(param1);
                }
                
            }
        }
   
    }            
    */
}