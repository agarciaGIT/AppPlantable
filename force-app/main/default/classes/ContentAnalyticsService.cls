public class ContentAnalyticsService {
	public static void getContentDocInternal(String docId){
        
        List<Content__c> contents = [
            SELECT Id, Name, Content_Name__c, View_Count__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c, Category__c, Subcategory__c, Featured__c, Published_Date__c, Story__c, Raw_HTML__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c, Bucket1__c, Bucket2__c 
            FROM Content__c 
            WHERE Status__c = 'Active' and Is_advertisement__c != true and Id = :docId
        ];
        
        if(!contents.isEmpty()) {
            //Function To calculate the week Number of the year
            integer weekNum = integer.valueof(System.Now().Format('w'));
            system.debug('weekNum:' + String.valueOf(weekNum));
            
            integer bucketNumber = 2;
            integer mod = Math.mod(weekNum, 2);
            
            system.debug('mod:' + String.valueOf(mod));
            
            if(mod == 0) {
                bucketNumber = 1;
            }
            
            system.debug('bucketNumber:' + String.valueOf(bucketNumber));
            
            Decimal cnt = contents[0].View_Count__c;
            if(cnt == null)
                cnt=1;
            else cnt++;
            contents[0].View_Count__c = cnt;
            if(bucketNumber==1) {
                if(contents[0].Bucket1__c == null)
                    contents[0].Bucket1__c=1;
                else contents[0].Bucket1__c = Integer.valueOf(contents[0].Bucket1__c)+1;
            } else {
                if(contents[0].Bucket2__c == null)
                    contents[0].Bucket2__c=1;
                else contents[0].Bucket2__c = Integer.valueOf(contents[0].Bucket2__c)+1;                
            }
            update contents;
            
            // Content Types
            String contType = null;
            String cat = null;
            String subCat = null;
            
            if(contents[0].Content_Type__c != null) {
        contType = contents[0].Content_Type__c;
            }
            if(contents[0].Category__c != null) {
        cat = contents[0].Category__c;
            }
            if(contents[0].Subcategory__c != null) {
        subCat = contents[0].Subcategory__c;
            }
            
            List<Content_Analytic__c> lstContenyAnalytics = [Select Id, Name, Type__c, Count__c, Bucket1__c, Bucket2__c, Trend__c from Content_Analytic__c where Contact__c = null];
            system.debug('lstContenyAnalytics:' + lstContenyAnalytics);
            
            Content_Analytic__c caContType = null;
            Content_Analytic__c caCat = null;
            Content_Analytic__c caSubCat = null;
            
            for(Content_Analytic__c ca :lstContenyAnalytics) {
                if(ca.Type__c == 'Content-Type' && contType != NULL && ca.Name == contType)
                    caContType = ca;
                if(ca.Type__c == 'Category' && cat != NULL && ca.Name == cat)
                    caCat = ca;
                if(ca.Type__c == 'Sub-Category' && subCat != NULL && ca.Name == subCat)
                    caSubCat = ca;
            }
            
            List<Content_Analytic__c> updateCA = new List<Content_Analytic__c>();
            List<Content_Analytic__c> addCA = new List<Content_Analytic__c>();
            
            if(caContType != null) {
                if(bucketNumber==1) {
                    if(caContType.Bucket1__c == null)
                        caContType.Bucket1__c=1;
                    else caContType.Bucket1__c = Integer.valueOf(caContType.Bucket1__c)+1;
                } else {
                    if(caContType.Bucket2__c == null)
                        caContType.Bucket2__c=1;
                    else caContType.Bucket2__c = Integer.valueOf(caContType.Bucket2__c)+1;                
                }
                caContType.Count__c = Integer.valueOf(caContType.Count__c)+1;
                updateCA.add(caContType);
            } else if(contType != NULL) {
                Content_Analytic__c addContType = new Content_Analytic__c();
                addContType.Name = contType;
                addContType.Type__c = 'Content-Type';
                if(bucketNumber==1) {
                    addContType.Bucket1__c=1;
                    addContType.Bucket2__c=0;
                } else {
                    addContType.Bucket1__c=0;
                    addContType.Bucket2__c=1;                    
                }
                addContType.Trend__c=0;
                addContType.Count__c=1;
                addCA.add(addContType);
            }
            
            if(caCat != null) {
                if(bucketNumber==1) {
                    if(caCat.Bucket1__c == null)
                        caCat.Bucket1__c=1;
                    else caCat.Bucket1__c = Integer.valueOf(caCat.Bucket1__c)+1;
                } else {
                    if(caCat.Bucket2__c == null)
                        caCat.Bucket2__c=1;
                    else caCat.Bucket2__c = Integer.valueOf(caCat.Bucket2__c)+1;                
                }
                caCat.Count__c = Integer.valueOf(caCat.Count__c)+1;
                updateCA.add(caCat);
            } else if(cat != NULL) {
                Content_Analytic__c addCategory = new Content_Analytic__c();
                addCategory.Name = cat;
                addCategory.Type__c = 'Category';
                if(bucketNumber==1) {
                    addCategory.Bucket1__c=1;
                    addCategory.Bucket2__c=0;
                } else {
                    addCategory.Bucket1__c=0;
                    addCategory.Bucket2__c=1;                    
                }
                addCategory.Trend__c=0;
                addCategory.Count__c=1;
                addCA.add(addCategory);
            }            
            
            if(caSubCat != null) {
                if(bucketNumber==1) {
                    if(caSubCat.Bucket1__c == null)
                        caSubCat.Bucket1__c=1;
                    else caSubCat.Bucket1__c = Integer.valueOf(caSubCat.Bucket1__c)+1;
                } else {
                    if(caSubCat.Bucket2__c == null)
                        caSubCat.Bucket2__c=1;
                    else caSubCat.Bucket2__c = Integer.valueOf(caSubCat.Bucket2__c)+1;                
                }
                caSubCat.Count__c = Integer.valueOf(caSubCat.Count__c)+1;
                updateCA.add(caSubCat);
            } else if(subCat != NULL) {
                Content_Analytic__c addSubCategory = new Content_Analytic__c();
                addSubCategory.Name = subCat;
                addSubCategory.Type__c = 'Sub-Category';
                if(bucketNumber==1) {
                    addSubCategory.Bucket1__c=1;
                    addSubCategory.Bucket2__c=0;
                } else {
                    addSubCategory.Bucket1__c=0;
                    addSubCategory.Bucket2__c=1;                    
                }
                addSubCategory.Trend__c=0;
                addSubCategory.Count__c=1;
                addCA.add(addSubCategory);
            }   
            
            if(updateCA.size() > 0)
                update updateCA;
            if(addCA.size() > 0)
                insert addCA;
        }
    }
    
    public static void getContentDocInternal(String docId, String contactId){
               
        system.debug('contactId:' + contactId);
            
        List<Content__c> contents = [
            SELECT Id, Name, Content_Name__c, View_Count__c, RecordTypeId, Description__c, SKU__c, Is_advertisement__c, Image__c, Third_Party_Author__c, Author__r.Name, Content_Type__c, Category__c, Subcategory__c, Featured__c, Published_Date__c, Story__c, Raw_HTML__c, Topic__c, Start_Date__c, End_Date__c, Third_Party_URL__c, Duration_in_Minutes__c, Event_Date_Time__c, Is_On_Demand__c, Moderators__c, Presenters__c, Visibility_ERP__c, Visibility_FRM__c, Visibility_Membership__c, Location__c, Bucket1__c, Bucket2__c 
            FROM Content__c 
            WHERE Status__c = 'Active' and Is_advertisement__c != true and Id = :docId
        ];
        
        if(!contents.isEmpty()) {
            //Function To calculate the week Number of the year
            integer weekNum = integer.valueof(System.Now().Format('w'));
            system.debug('weekNum:' + String.valueOf(weekNum));
            
            integer bucketNumber = 2;
            integer mod = Math.mod(weekNum, 2);
            
            system.debug('mod:' + String.valueOf(mod));
            
            if(mod == 0) {
                bucketNumber = 1;
            }
            
            system.debug('bucketNumber:' + String.valueOf(bucketNumber));
            
            Decimal cnt = contents[0].View_Count__c;
            if(cnt == null)
                cnt=1;
            else cnt++;
            contents[0].View_Count__c = cnt;
            if(bucketNumber==1) {
                if(contents[0].Bucket1__c == null)
                    contents[0].Bucket1__c=1;
                else contents[0].Bucket1__c = Integer.valueOf(contents[0].Bucket1__c)+1;
            } else {
                if(contents[0].Bucket2__c == null)
                    contents[0].Bucket2__c=1;
                else contents[0].Bucket2__c = Integer.valueOf(contents[0].Bucket2__c)+1;                
            }
            update contents;
            
            // Content Types
            String contType = null;
            String cat = null;
            String subCat = null;
            
            if(contents[0].Content_Type__c != null) {
        contType = contents[0].Content_Type__c;
            }
            if(contents[0].Category__c != null) {
        cat = contents[0].Category__c;
            }
            if(contents[0].Subcategory__c != null) {
        subCat = contents[0].Subcategory__c;
            }
            
            List<Content_Analytic__c> lstContenyAnalytics = [Select Id, Name, Type__c, Count__c, Bucket1__c, Bucket2__c, Trend__c from Content_Analytic__c where Contact__c = :contactId];
            system.debug('lstContenyAnalytics:' + lstContenyAnalytics);
            
            Content_Analytic__c caContType = null;
            Content_Analytic__c caCat = null;
            Content_Analytic__c caSubCat = null;
            
            for(Content_Analytic__c ca :lstContenyAnalytics) {
                if(ca.Type__c == 'Content-Type' && contType != NULL && ca.Name == contType)
                    caContType = ca;
                if(ca.Type__c == 'Category' && cat != NULL && ca.Name == cat)
                    caCat = ca;
                if(ca.Type__c == 'Sub-Category' && subCat != NULL && ca.Name == subCat)
                    caSubCat = ca;
            }
            
            List<Content_Analytic__c> updateCA = new List<Content_Analytic__c>();
            List<Content_Analytic__c> addCA = new List<Content_Analytic__c>();
            
            if(caContType != null) {
                if(bucketNumber==1) {
                    if(caContType.Bucket1__c == null)
                        caContType.Bucket1__c=1;
                    else caContType.Bucket1__c = Integer.valueOf(caContType.Bucket1__c)+1;
                } else {
                    if(caContType.Bucket2__c == null)
                        caContType.Bucket2__c=1;
                    else caContType.Bucket2__c = Integer.valueOf(caContType.Bucket2__c)+1;                
                }
                caContType.Count__c = Integer.valueOf(caContType.Count__c)+1;
                updateCA.add(caContType);
            } else {
                Content_Analytic__c addContType = new Content_Analytic__c();
                addContType.Name = contType;
                addContType.Type__c = 'Content-Type';
                if(bucketNumber==1) {
                    addContType.Bucket1__c=1;
                    addContType.Bucket2__c=0;
                } else {
                    addContType.Bucket1__c=0;
                    addContType.Bucket2__c=1;                    
                }
                addContType.Trend__c=0;
                addContType.Count__c=1;
                addContType.Contact__c = contactId;
                addCA.add(addContType);
            }
            
            if(caCat != null) {
                if(bucketNumber==1) {
                    if(caCat.Bucket1__c == null)
                        caCat.Bucket1__c=1;
                    else caCat.Bucket1__c = Integer.valueOf(caCat.Bucket1__c)+1;
                } else {
                    if(caCat.Bucket2__c == null)
                        caCat.Bucket2__c=1;
                    else caCat.Bucket2__c = Integer.valueOf(caCat.Bucket2__c)+1;                
                }
                caCat.Count__c = Integer.valueOf(caCat.Count__c)+1;
                updateCA.add(caCat);
            } else {
                Content_Analytic__c addCategory = new Content_Analytic__c();
                addCategory.Name = cat;
                addCategory.Type__c = 'Category';
                if(bucketNumber==1) {
                    addCategory.Bucket1__c=1;
                    addCategory.Bucket2__c=0;
                } else {
                    addCategory.Bucket1__c=0;
                    addCategory.Bucket2__c=1;                    
                }
                addCategory.Trend__c=0;
                addCategory.Count__c=1;
                addCategory.Contact__c = contactId;
                addCA.add(addCategory);
            }            
            
            if(caSubCat != null) {
                if(bucketNumber==1) {
                    if(caSubCat.Bucket1__c == null)
                        caSubCat.Bucket1__c=1;
                    else caSubCat.Bucket1__c = Integer.valueOf(caSubCat.Bucket1__c)+1;
                } else {
                    if(caSubCat.Bucket2__c == null)
                        caSubCat.Bucket2__c=1;
                    else caSubCat.Bucket2__c = Integer.valueOf(caSubCat.Bucket2__c)+1;                
                }
                caSubCat.Count__c = Integer.valueOf(caSubCat.Count__c)+1;
                updateCA.add(caSubCat);
            } else {
                Content_Analytic__c addSubCategory = new Content_Analytic__c();
                addSubCategory.Name = subCat;
                addSubCategory.Type__c = 'Sub-Category';
                if(bucketNumber==1) {
                    addSubCategory.Bucket1__c=1;
                    addSubCategory.Bucket2__c=0;
                } else {
                    addSubCategory.Bucket1__c=0;
                    addSubCategory.Bucket2__c=1;                    
                }
                addSubCategory.Trend__c=0;
                addSubCategory.Count__c=1;
                addSubCategory.Contact__c = contactId;
                addCA.add(addSubCategory);
            }   
            
            if(updateCA.size() > 0)
                update updateCA;
            if(addCA.size() > 0)
                insert addCA;
        }
            
    } 

}