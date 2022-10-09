@isTest
public class NewsFeedEditor_test {

    static void testData() {
        
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Content__c', 'News Feed');
        
        //Setup articles
        List<Content__c> articles = new List<Content__c>{
            new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
			new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
           	new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
           	new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
            new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
            new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
           	new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
            new Content__c(Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),Is_On_Demand__c = true,RecordTypeId = recordTypeId,Raw_HTML__c = 'test')
        };
                    
		INSERT articles;
        
        List<Id> articleIds = new List<Id>();
        for(Content__c article: articles){
            articleIds.add(article.Id);
        }
        
        Content_Selector__c cs = new Content_Selector__c();
        
        cs.Application_Reference__c = 'News Feed Selector';
        cs.Content_Ids__c = String.join(articleIds, ',');
        
        // Setup Sidebar Ads
        List<Content__c> sideBarAds = new List<Content__c>{
            new Content__c(Name='TEST1',Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: 240x120',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
			new Content__c(Name='TEST2',Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: 240x120',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
           	new Content__c(Name='TEST3',Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: 240x120',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
           	new Content__c(Name='TEST4',Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: 240x120',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test')
        }; 
        INSERT sideBarAds;
        
        List<Id> sideBarAdIds = new List<Id>();
        for(Content__c sideBarAd: sideBarAds){
            sideBarAdIds.add(sideBarAd.Id);
        }
        
        cs.Content_Selector_Sidebar_Ad_Ids__c = String.join(sideBarAdIds, ',');
        
        // Setup Top/Bottom Ads
        List<Content__c> topBottomAds = new List<Content__c>{
            new Content__c(Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: 460x80',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
			new Content__c(Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: 460x80',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test')
        }; 
        INSERT topBottomAds;

        // Setup Text Ads
        List<Content__c> textAds = new List<Content__c>{
            new Content__c(Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: Text Ads',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test'),
			new Content__c(Is_advertisement__c=TRUE,Ad_Format__c = 'Newsletter: Text Ads',Content_Type__c = 'News Feed',Status__c = 'Active',Published_Date__c = system.today(),RecordTypeId = recordTypeId,Raw_HTML__c = 'test')
        }; 
        INSERT textAds;

        cs.Content_Selector_Top_Ad_Ids__c = topBottomAds[0].Id;
        cs.Content_Selector_Bottom_Ad_Ids__c = topBottomAds[1].Id;

        cs.Content_Selector_Start_Date__c = date.newInstance(2015,5,16);
        cs.Content_Selector_End_Date__c = date.newInstance(2015,5,16);        
        
        INSERT cs;
        
    }
    
    static testMethod void unitTest_1() {

        testData();

        test.startTest();
       
        NewsFeedEditor feed = new NewsFeedEditor();

        feed.selectedItem = [SELECT Id FROM Content__c WHERE Ad_Format__c = 'Newsletter: 460x80' LIMIT 1].Id; 
        feed.selectedBottom = [SELECT Id FROM Content__c WHERE Ad_Format__c = 'Newsletter: 460x80' LIMIT 1].Id; 
        feed.txtAdSelected1 = [SELECT Id FROM Content__c WHERE Ad_Format__c = 'Newsletter: Text Ads' LIMIT 1].Id;  
        feed.txtAdSelected2 = [SELECT Id FROM Content__c WHERE Ad_Format__c = 'Newsletter: Text Ads' LIMIT 1].Id; 
        
        feed.rightSelected = new List<String>();
        feed.leftSelected = new List<String>();

        feed.pageLoad();

        for(Content__c content: [SELECT Id, Name FROM Content__c WHERE Ad_Format__c = 'Newsletter: 240x120']){  
            feed.leftSelected.add(content.Name);
        }

        feed.addToRightBox();
        feed.sortRecords();
        feed.filterRecords();
        feed.saveRecords();
        feed.publish();

        for(Content__c content: [SELECT Id, Name FROM Content__c WHERE Ad_Format__c = 'Newsletter: 240x120']){  
            feed.rightSelected.add(content.Name);
        }

        feed.addToLeftBox();
        feed.clear();
        feed.publish();

        List<string> feedids = new List<String>();
        feed.startDate.Published_Date__c = Date.today().addDays(-1);
        feed.endDate.Published_Date__c = Date.today().addDays(1);
        feed.fetchRecords();

        Decimal foundNumber = feed.FoundNumber;
        List<Content__c> cust = new List<Content__c>();
        cust = [Select Id, Name from Content__c where id in :feedids];
        for (Content__c content : cust) {
            if(content!= null)
            content.Is_On_Demand__c = false;
        }

        Content_Selector__c cs = new Content_Selector__c();
        
        List<Content_Selector__c> lstContentSelector = [
            Select Id, Name, Content_Selector_End_Date__c, Content_Selector_Start_Date__c, Content_Ids__c, Content_Selector_Text_Ad_Ids__c, Content_Selector_Bottom_Ad_Ids__c, Content_Selector_Sidebar_Ad_Ids__c, Content_Selector_Top_Ad_Ids__c 
            from Content_Selector__c
        
        ];

        List<id> csids = new List<id>();
        List<Content__c> Cont = [Select Id, Name, Is_On_Demand__c, Published_Date__c from Content__c where id in :csids];
        if(cs != null){   
            for(Content__c c: Cont) {
                c.Is_On_Demand__c = false;
                feed.startDate.Published_Date__c = cs.Content_Selector_Start_Date__c;
                feed.endDate.Published_Date__c = cs.Content_Selector_End_Date__c;
                feed.selectedItem = cs.Content_Selector_Top_Ad_Ids__c;
                feed.selectedBottom = cs.Content_Selector_Bottom_Ad_Ids__c;
            }
        }
        
        List<Content__c> lstCont = [Select Id, Name, Status__c, Content_Type__c, Sequence__c, Is_On_Demand__c, Published_Date__c from Content__c];
               
        List<Content_Selector__c> allcs = [Select Id, Name, Content_Selector_Start_Date__c, Content_Selector_End_Date__c, Content_Selector_Bottom_Ad_Ids__c, Content_Ids__c, Content_Selector_Sidebar_Ad_Ids__c, Content_Selector_Top_Ad_Ids__c from Content_Selector__c] ;
        List<Content_Selector__c> cs1 = new list<Content_Selector__c>();

        if(allcs.size() == 0){
            Content_Selector__c cons = new Content_Selector__c();
            
            cons.Content_Selector_Top_Ad_Ids__c = feed.selectedItem; 
            cons.Content_Selector_Bottom_Ad_Ids__c = feed.selectedBottom;  
            
            cons.Content_Selector_Start_Date__c = feed.startDate.Published_Date__c;
            cons.Content_Selector_End_Date__c = feed.endDate.Published_Date__c;
            insert cons;
    
          } else {
           
            for(Content_Selector__c c:allcs){           
                c.Content_Selector_Top_Ad_Ids__c = feed.selectedItem; 
                c.Content_Selector_Bottom_Ad_Ids__c = feed.selectedBottom;  
                c.Content_Selector_Sidebar_Ad_Ids__c = feed.selectedItem;
                c.Content_Selector_Start_Date__c = feed.startDate.Published_Date__c;
                c.Content_Selector_End_Date__c = feed.endDate.Published_Date__c;
                cs1.add(c);
            }

            UPDATE cs1;

        }
      
        for (Content__c conad: [Select Id, Name, Status__c, Content_Name__c, Is_advertisement__c, Ad_Format__c from Content__c where Is_advertisement__c = true and Status__c = 'Active' ]) {
            feed.selectedItem = conad.Id;
            feed.selectedBottom = conad.Id;
        }
                          
        feed.gettopAds();
        feed.getbottomAds();
        feed.gettextAds1(); 
        feed.gettextAds2(); 
        feed.printSelectedValues();
        feed.getIsOtherOptionSelected();
        feed.getRightBoxValues();
        feed.getLeftBoxValues();
        feed.sendEmail();
        test.stopTest();

    }
}