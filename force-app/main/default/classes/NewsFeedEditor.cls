public class NewsFeedEditor {
    
    Public List<string> leftSelected{get;set;}
    Public List<string> rightSelected{get;set;}
    Set<string> leftValues = new Set<string>();
    Set<string> rightValues = new Set<string>();
    Set<string> selectedObjects = new Set<string>();
    
    public String applicationReference = 'News Feed Selector';
    
    public class gooItem {
        public String kind;
        public String id;
        public String longUrl;
    }
    
    /* Add item to rightbox of picklist*/
    public PageReference addToRightBox(){
        rightSelected.clear();
        for(String s : leftSelected){
            leftValues.remove(s);
            rightValues.add(s);
        }
        return null;
    }
    
    /* Add item to leftbox of picklist*/
    public PageReference addToLeftBox(){
        leftSelected.clear();
        for(String s : rightSelected){
            rightValues.remove(s);
            leftValues.add(s);
        }
        return null;
    }
    
    /* return rightbox values of picklist */
    public List<SelectOption> getLeftBoxValues(){
        List<SelectOption> options = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(leftValues);
        //      tempList.sort();
        for(string s : tempList)
            options.add(new SelectOption(s,s));
        return options;
        
        
    }
    
    /* return leftbox values of picklist */
    public List<SelectOption> getRightBoxValues(){
        List<SelectOption> options1 = new List<SelectOption>();
        List<string> tempList = new List<String>();
        tempList.addAll(rightValues);
        //      tempList.sort();
        for(String s : tempList)
            options1.add(new SelectOption(s,s));
        return options1;
    }
    
    public Boolean getIsOtherOptionSelected(){
        Boolean retValue = false;
        for(String selObj: rightValues ){
            if(selObj.contains('Other')){
                return true;
            }
        }
        return retValue;
    }
    
    
    public PageReference printSelectedValues(){
        return null;
    }
    
    
    List < Content_Selector__c > savedContent = new List < Content_Selector__c > ();
    
    List < SelectOption > sidebarads = new List < Selectoption > ();
    
    List < contSelected > lstContInternal = new List <contSelected>();
    
    public Boolean showRecords {get; set;}
    
    public List <Content__c> cust {get; set;}
    
    public class contSelected {
        public Content__c  content{ get; set; }
        // public String txtAdSelected { get; set; }
    }       
    
    public List <contSelected> lstCont {get; set;}
    
    public Content__c startDate {get; set;}
    
    public Content__c endDate {get; set;}
    
    public Content__c genHTML {get; set;}
    
    public List < Content__c > Ad {get; set;}
    
    public List < Content__c > lstTextAd {get; set;}
    
    public Decimal foundNumber {get; set;}
    
    public String selectedItem {get; set;}
    
    public String selectedBottom {get; set;}
    
    public String txtAdSelected1 { get; set; }
    
    public String txtAdSelected2 { get; set; }
    
    //public String selectedSide {get; set;}
    public List<String> selectedSide {get;set;}
    
    List < SelectOption > sidebarAdsInternal = new List <SelectOption>();
    MAP<String,String> sidebarMapNametoID = new MAP<String,String>();
    MAP<String,String> sidebarMapIDtoName = new MAP<String,String>();
    
    MAP<String,String> topBottomIDtoHTML = new MAP<String,String>();
    MAP<String,String> sideBarIDtoHTML = new MAP<String,String>();
    MAP<String,String> txtAdsIDtoHTML = new MAP<String,String>();
    
    public List < SelectOption > sidebarAdsX { get; set; }
    
    list < SelectOption > topads = new list < Selectoption > ();
    list < SelectOption > bottomads = new list < Selectoption > ();
    list < SelectOption > textads1 = new list < Selectoption > ();
    list < SelectOption > textads2 = new list < Selectoption > ();
    
    
    //In constructor
    public NewsFeedEditor() {
        showRecords = false;
        startDate = new Content__c();
        endDate = new Content__c();
        genHTML = new Content__c();
        genHTML.Story__c = '';
        foundNumber = 0;
        genHTML.Content_Name__c = '';
        
        // Get Side Bar Ads
        for (Content__c cont: [Select Id, Name, Status__c, Content_Name__c, Is_advertisement__c, Ad_Format__c, Raw_HTML__c from Content__c where Is_advertisement__c = true and Ad_Format__c = 'Newsletter: 240x120' and Status__c = 'Active' and Published_Date__c <= TODAY]) {
            sidebarAdsInternal.add(new selectOption(cont.Id, cont.Name));
            sidebarMapNametoID.put(cont.Name, cont.Id);
            sidebarMapIDtoName.put(cont.Id, cont.Name);
            leftValues.add(cont.Name);
            sideBarIDtoHTML.put(cont.Id,cont.Raw_HTML__c);
        }
        sidebarAdsX = sidebarAdsInternal;
        
        // Top
        topads.add(new SelectOption('None', '--None--'));
        bottomads.add(new SelectOption('None', '--None--'));
        for (Content__c cont: [Select Id, Name, Status__c, Content_Name__c, Is_advertisement__c, Ad_Format__c, Raw_HTML__c from Content__c where Is_advertisement__c = true and Ad_Format__c = 'Newsletter: 460x80' and Status__c = 'Active' and Published_Date__c <= TODAY]) {
            topads.add(new selectOption(cont.Id, cont.Name));
            bottomads.add(new selectOption(cont.Id, cont.Name));
            topBottomIDtoHTML.put(cont.Id,cont.Raw_HTML__c);
        }            
        
        
        textads1.add(new SelectOption('None', '--None--'));
        textads2.add(new SelectOption('None', '--None--'));
        for (Content__c cont: [Select Id, Name, Status__c, Content_Name__c, Is_advertisement__c, Ad_Format__c, Raw_HTML__c from Content__c where Is_advertisement__c = true and Ad_Format__c = 'Newsletter: Text Ads' and Status__c = 'Active' and Published_Date__c <= TODAY]) {
            // textads.add(new selectOption(cont.Id, cont.Name));
            textads1.add(new selectOption(cont.Id, cont.Name));
            textads2.add(new selectOption(cont.Id, cont.Name));
            txtAdsIDtoHTML.put(cont.Id,cont.Raw_HTML__c);
        }
        
        system.debug('txtAdsIDtoHTML:' + txtAdsIDtoHTML);
        
        system.debug('topads:' + topads);
        system.debug('bottomads:' + bottomads);
        system.debug('textads1:' + textads1);
        system.debug('textads2:' + textads2);
        
    }
    
    public class ContentWrapper implements Comparable {
        
        public Content__c content;
        
        // Constructor
        public ContentWrapper(contSelected con) {
            content = con.content;
            if (content.Sequence__c == null) {
                content.Sequence__c = 0;
                
            }
        }
        
        // Compare Contents based on the Sequence.
        public Integer compareTo(Object compareTo) {
            // Cast argument to ContentWrapper
            ContentWrapper compareToContent = (ContentWrapper) compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (content.Sequence__c > compareToContent.content.Sequence__c) {
                // Set return value to a positive value.
                returnValue = 1;
            } else if (content.Sequence__c > compareToContent.content.Sequence__c) {
                // Set return value to a negative value.
                returnValue = -1;
            }
            
            return returnValue;
        }
    }
    
    
    public void sortRecords() {
        ContentWrapper[] wrapperList = new List < ContentWrapper > ();
        for (contSelected content: lstCont) {
            ContentWrapper wrapper = new ContentWrapper(content);
            wrapperList.add(wrapper);
        }
        wrapperList.sort();
        foundNumber = lstCont.size();
        lstCont.clear();
        
        for (ContentWrapper wrapper: wrapperList) {
            contSelected newCon = new contSelected ();
            newCon.content = wrapper.content;
            lstCont.add(newCon);
        }
        
    }
    
    public void filterRecords() {
        Integer j = 0;
        while (j < lstCont.size()) {
            if (lstCont.get(j).content.Is_On_Demand__c == false) {
                lstCont.remove(j);
            } else {
                j++;
            }
        }
        sortRecords();
    }
    
    public void saveRecords() {

        ApexPages.getMessages().clear();
        String saveIds = '';
        
        Integer j = 0;
        Integer y = lstCont.size(); 
        while (j < y) {
            if (lstCont.get(j).content.Is_On_Demand__c == false) {
                y--;
            } else {
                j++;
            }
        }
        
        if(lstCont != null && j != 8) {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Must save 8 items'));
            return;
            
        } else {
            
            List<Content__c> contentsName = New List<Content__c>();
            
            for (contSelected cont :lstCont) {
                
                contentsName.add(cont.content);
                
                String str = String.ValueOf(cont.content.Id);
                
                if(saveIds == '')
                    saveIds = str;
                else saveIds = saveIds + ',' + str;
                system.debug('saveIds ' + saveIds);
                system.debug(String.ValueOf(cont.content.Name_Override__c));
            }
            
            UPDATE contentsName;
        }

        List<Content_Selector__c> allcs = [Select Id, Name, Content_Selector_Start_Date__c, Content_Selector_End_Date__c, Content_Ids__c from Content_Selector__c where Application_Reference__c = :applicationReference];
        
        if(allcs.size() ==0 ) {
            Content_Selector__c cs = new Content_Selector__c();
            cs.Content_Ids__c = saveIds;
            
            cs.Content_Selector_Start_Date__c = startDate.Published_Date__c;
            cs.Content_Selector_End_Date__c = endDate.Published_Date__c;
            cs.Application_Reference__c = applicationReference;
            
            insert cs;
        } else {
            allcs[0].Content_Ids__c = saveIds;
            
            allcs[0].Content_Selector_Start_Date__c = startDate.Published_Date__c;
            allcs[0].Content_Selector_End_Date__c = endDate.Published_Date__c;
            update allcs;
        }
    }      
    
    public PageReference clear(){
        
        startDate.Published_Date__c = null;
        endDate.Published_Date__c = null;
        genHTML.Story__c = null;
        if(lstCont != null){
            lstCont.clear();
        }
        
        List<Content_Selector__c> newcs = [Select Id, Name, Content_Selector_End_Date__c, Content_Selector_Start_Date__c, Content_Ids__c, Content_Selector_Text_Ad_Ids__c, Content_Selector_Bottom_Ad_Ids__c, Content_Selector_Sidebar_Ad_Ids__c, Content_Selector_Top_Ad_Ids__c from Content_Selector__c where Application_Reference__c = :applicationReference];
        
        if(newcs.size()!=0){
            delete newcs;
        }

        foundNumber = 0;
        return null;

    }
    
    
    public void pageLoad(){
        
        genHTML.Story__c = null;
        
        List<Content_Selector__c> lstContentSelector = [Select Id, Name, Content_Selector_End_Date__c, Content_Selector_Start_Date__c, Content_Ids__c from Content_Selector__c where Application_Reference__c = :applicationReference];
        
        if(lstContentSelector != null && lstContentSelector.size()>0){

            List<String> csParts = new List<String>();
            List<String> csids = new List<String>();

            if(lstContentSelector[0].Content_Ids__c != null) {
                csParts = lstContentSelector[0].Content_Ids__c.split(',');    
                for(String part :csParts) {                 
                    csids.add(part);                    
                }
            }

            List<Content__c> lstContSel = [
                SELECT Id, Name, Name_Override__c, Description__c, Status__c, Content_Type__c, Sequence__c, Is_On_Demand__c, Published_Date__c 
                FROM Content__c 
                WHERE Id in: csids
            ];
            
            system.debug('lstContSel' + lstContSel);
            
            foundNumber = lstContSel.size();
            showRecords = true;
            for (Content__c cont: lstContSel ) {
                cont.Is_On_Demand__c = true;
                contSelected conSel = new contSelected();
                conSel.content = cont;
                lstContInternal.add(conSel);
            }
            lstCont = lstContInternal;
            
            startDate.Published_Date__c = lstContentSelector[0].Content_Selector_Start_Date__c;
            endDate.Published_Date__c = lstContentSelector[0].Content_Selector_End_Date__c;
            
        }
        
    }
    
    
    public void fetchRecords() {
        Id recordTypeID = RecordTypeHelper.GetRecordTypeId('Content__c', 'News Feed');
        List<Content__c> lstContSel = [Select Id, Name, Name_Override__c, Description__c, Status__c, Content_Type__c, Sequence__c, Is_On_Demand__c, Published_Date__c, RecordTypeID from Content__c where RecordTypeID =: recordTypeID and Published_Date__c >=: startDate.Published_Date__c and Published_Date__c <=: endDate.Published_Date__c limit 1000];
        showRecords = true;
        for (Content__c cont: lstContSel ) {
            cont.Is_On_Demand__c = false;
            contSelected conSel = new contSelected();
            conSel.content = cont;
            lstContInternal.add(conSel);
        }
        foundNumber = lstContSel.size();
        system.debug('foundNumber:'+foundNumber);
        lstCont = lstContInternal;
        system.debug('lstContInternal:'+lstContInternal);
    }
    
    public List < SelectOption > gettopAds() {
        system.debug('topads:'+topads);
        return topads;
    }
    
    public List < SelectOption > getbottomAds() {
        system.debug('bottomads:'+bottomads);
        return bottomads;
    }
    
    public List < SelectOption > gettextAds1() {
        system.debug('textads1:'+textads1);
        return textads1;
    }
    
    public List < SelectOption > gettextAds2() {
        system.debug('textads2:'+textads2);
        return textads2;
    }
    
    public void Publish() {
        
        Boolean dataCheck = Boolean.valueOf('true');
        genHTML.Story__c = '';
        String barAd1 = '';
        String barAd2 = '';
        String txtAd1 = '';
        String txtAd2 = '';
        List<String> arrayArticles = new List<String>();
        List<String> arraySideAds = new List<String>();
        
        ApexPages.getMessages().clear();
        
        Integer j = 0;
        Integer y = lstCont.size(); 
        while (j < y) {
            if (lstCont.get(j).content.Is_On_Demand__c == false) {
                y--;
            } else {
                j++;
            }
        }

        if(lstCont == null || j != 8) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Must have 8 news items selected'));
            dataCheck = false;
        }
        
        barAd1 = topBottomIDtoHTML.get(selectedItem);
        if(barAd1 == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Missing top ad'));
            dataCheck = false;
        }
        
        barAd2 = topBottomIDtoHTML.get(selectedBottom);
        if(barAd2 == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Missing bottom ad'));
            dataCheck = false;
        }
        
        txtAd1 = txtAdsIDtoHTML.get(txtAdSelected1);
        if(txtAd1 == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Missing 1st text ad'));
            dataCheck = false;
        }
        
        txtAd2 = txtAdsIDtoHTML.get(txtAdSelected2);
        if(txtAd2 == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Missing 2nd text ad'));
            dataCheck = false;
        }
        
        if(rightValues == null || rightValues.size() != 4) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'Must have 4 sidebar ads selected'));
            dataCheck = false;
        }
        
        if(dataCheck == false){
            return;
        }
        
        
        
        
        //Create the first banner ad
        
        barAd1 = '<table align="center" style="width:95%;max-width:610px;border:1px solid #9DA7AE;border-collapse:collapse;margin-bottom:4px;"><tbody><tr><td align="center" height="110" style="text-align:center;" valign="middle"><!-- TOP BANNER AD START-->';
        barAd1 += topBottomIDtoHTML.get(selectedItem);
        barAd1 += '<!-- TOP BANNER AD END --></td></tr></tbody></table>';
        
        
        //Create the second banner ad
        
        barAd2 = '<tr><td align="center" colspan="2" style="background-color: #fff;text-align:center;margin-bottom: 2px;"><table align="center" style="width:94%;border:1px solid #9DA7AE;border-collapse:collapse;box-sizing:border-box;"><tbody><tr><td align="center" height="110" style="text-align:center;" valign="middle"><!-- BOTTTOM BANNER AD START --><div pardot-data="" pardot-region="std_content01" style="color: rgb(80, 80, 80);">';
        barAd2 += topBottomIDtoHTML.get(selectedBottom);
        barAd2 += '</div><!-- BOTTOM BANNER AD END --></td></tr></tbody></table></td></tr>';
        
        
        //Create the first text ad
        
        txtAd1 = '<tr><td align="center" colspan="2"><table style="background-color: #f1f2f4;border-collapse:collapse;margin-bottom:4px;width:94%;box-sizing:border-box;"><tbody><tr><td><p style="margin-bottom:8px;line-height:0;">&nbsp;</p><p style="margin-left: 10%;margin-right:10%;color:#9DA7AE"><strong>Advertisement</strong></p><p style="margin-left: 10%;margin-right:10%;margin-bottom:8px;font-size:13px;">';
        txtAd1 += txtAdsIDtoHTML.get(txtAdSelected1);
        txtAd1 += '</p></td></tr><!-- Advertisement End --></tbody></table></td></tr>';
        
        
        //Create the second text ad
        
        txtAd2 = '<tr><td align="center" colspan="2"><table style="background-color: #f1f2f4;border-collapse:collapse;margin-bottom:4px;width:94%;box-sizing:border-box;"><!-- Advertisement --><tbody><tr><td><p style="margin-bottom:8px;line-height:0;">&nbsp;</p><p style="margin-left: 10%;margin-right:10%;color:#9DA7AE;font-family:tahoma;"><strong>Advertisement</strong></p><p style="margin-left: 10%;margin-right:10%;margin-bottom:8px;font-size:13px;">';
        txtAd2 += txtAdsIDtoHTML.get(txtAdSelected2);
        txtAd2 += '</p></td></tr></tbody><!-- Advertisement End --></table></td></tr>';
        
        
        //Generate Date String for Google Analytics in format 'May_10_2015' 
        
        DateTime d = DateTime.now();
        String monthName = d.format('MMMMM');
        String dayOfMonth = d.format('d');
        String year = d.format('yyyy');
        String dateString = monthName + '_' + dayOfMonth + '_' + year;
        
        //HTML for news articles
        
        String articleString = '<table align="left" class="tables" style="width:100%;max-width:485px;min-width:300px;border-collapse:collapse;border:1px solid #D0D4D8;margin-bottom: 3px;"><!-- Begin Story --><tbody><tr><td align="left" class="tables" style="padding-top:25px; padding-bottom:5px; font-family:Tahoma,serif; font-size:16px; color:#00A2DD" valign="top"><p style="margin-left: 3%;margin-right: 3%;"><strong><a style="color:#00A2DD;" href="{0}" target="_blank">{1}</a></strong></p></td></tr><tr><td align="left" style="font-family:Tahoma; font-size:13px; color:#535353;padding-bottom:5px;" valign="top"><p style="margin-left: 3%;margin-right: 3%;margin-bottom:10px;font-family:tahoma;">{2}</p><p><img height="10" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png" style="display:block;border:none;height:10px;"></p></td></tr></tbody><!-- END STORY --></table>';
        
        //Setting counters for loops below
        
        Integer cnt=0;
        
        
        //Loop news and assign them into an array
        
        for (contSelected cont: lstCont) {
            
            cnt++;
            
            String docUrl = 'http://www.garp.org/risk-intelligence/all/all/' + cont.content.Id + '?utm_content=' + dateString + '&utm_source=audience&utm_medium=email&utm_campaign=dailynews&utm_term=article' + cnt;
            
            cont.content.Status__c = 'Active';
            String name = cont.content.Name_Override__c != null && !cont.content.Name_Override__c.isWhiteSpace() ? cont.content.Name_Override__c : cont.content.Name;
            
            String[] arguments = new String[] {
                docUrl,
                    name,
                    cont.content.Description__c
                    };
                        String formattedString = String.format(articleString, arguments);
            arrayArticles.add(formattedString);
        }
        
        //Loop sidebar ads
        For(String s :rightValues) {
            String fnd = sidebarMapNametoID.get(s);
            if(fnd!=null) {
                String sideHTML = sideBarIDtoHTML.get(fnd);
                if(sideHTML != null) {
                    arraySideAds.add(sideHTML);
                }
            } 
        }
        
        //Combine all the html
        
        //Head html    
        genHTML.Story__c += '%%[SET @FirstName = AttributeValue("FirstName") IF EMPTY(@FirstName) THEN SET @Salutation = "Hello," ELSE SET @Salutation = Concat("Dear ", @FirstName, ",") ENDIF /* To use: %%=v(@Salutation)=%% */ ]%% <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head> <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/> <meta name="format-detection" content="telephone=no"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <meta http-equiv="X-UA-Compatible" content="IE=9; IE=8; IE=7; IE=EDGE"/> <meta name="x-apple-disable-message-reformatting"/> <custom name="opencounter" type="tracking"/> <title>The Daily News</title> <style type="text/css"> .ExternalClass{width:100%;}.ExternalClass, .ExternalClass p, .ExternalClass span, .ExternalClass font, .ExternalClass td, .ExternalClass div{line-height: 100%;}body{-webkit-text-size-adjust:none; -ms-text-size-adjust:none;}body{margin:0; padding:0;}table td{border-collapse:collapse;}p{margin:0; padding:0; margin-bottom:0;}h1, h2, h3, h4, h5, h6{color: #00AB91; line-height: 100%;}a, a:link{color:#2A5DB0; text-decoration: underline;}body, #body_style{background:#ffffff; min-height:1000px; color:#212120; font-family: Tahoma; font-size: 14px; line-height: 20px}span.yshortcuts{color:#000; background-color:none; border:none;}span.yshortcuts:hover, span.yshortcuts:active, span.yshortcuts:focus{color:#000; background-color:none; border:none;}@media only screen and (max-device-width: 480px){body[yahoo] #container1{display:block !important}td.mobile{display:block !important; clear:both; width: 100% !important;}.mainTable, .body_style{width: 100% !important;max-width: 480px;}.tables{margin-left: auto !important;margin-right: auto !important;width: 100% !important;}}</style></head>';
        
        //Body Start
        genHTML.Story__c += '<body style="background:#fff; min-height:1000px; color:#212120;font-family:Tahoma; font-size:14px;padding:0;"bgcolor="#ffffff" text="#212120" yahoo="fix">';
        
        //Litmus Code HTML
        genHTML.Story__c += '<style data-ignore-inlining>@media print{ #_t { background-image: url("https://w8hoxfjs.emltrk.com/w8hoxfjs?p&d=%%emailaddr%%");}} div.OutlookMessageHeader {background-image:url("https://w8hoxfjs.emltrk.com/w8hoxfjs?f&d=%%emailaddr%%")} table.moz-email-headers-table {background-image:url("https://w8hoxfjs.emltrk.com/w8hoxfjs?f&d=%%emailaddr%%")} blockquote #_t {background-image:url("https://w8hoxfjs.emltrk.com/w8hoxfjs?f&d=%%emailaddr%%")} #MailContainerBody #_t {background-image:url("https://w8hoxfjs.emltrk.com/w8hoxfjs?f&d=%%emailaddr%%")}</style><div id="_t"></div><img src="https://w8hoxfjs.emltrk.com/w8hoxfjs?d=%%emailaddr%%" width="1" height="1" border="0" alt="" />';
        
        //Page Start
        genHTML.Story__c += '<!--PAGE WRAPPER--><!--[if mso]><center><table><tr><td width="650"><![endif]--><div id="body_style" style="max-width: 650px;margin:0 auto;"><!-- PAGE LAYOUT --><table align="center" bgcolor="#ffffff" border="0" cellpadding="0" cellspacing="0" class="mainTable" style="width:650px;box-sizing:border-box;margin:0 auto;border-collapse: collapse;" width="100%"><tbody><tr bgcolor="#f1f2f4" style="background-color: #f1f2f4;" valign="middle"><td style="margin-left: 10px;background-color: #f1f2f4;" width="50%">&nbsp;</td><td style="margin-right: 10px;background-color: #f1f2f4;text-align:right;" width="50%"><custom type="header" /></td></tr><tr><td colspan="2" style="background-color: #fff;"><img height="40" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png" style="display:block;border:none;"></td></tr><tr><td align="center" colspan="2" style="background-color: #fff;text-align:center;"><img alt="GARP | Risk Management" height="44" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/8344cdc8-403b-4735-a9cd-4395a2f52627.jpg" style="display:inline-block;border:none;"></td></tr><tr><td colspan="2" style="background-color: #fff;"><img height="50" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png" style="display:block;border:none;"></td></tr><tr><td align="center" colspan="2" style="background-color: #fff;text-align:center;"><h1 style="color:#081a31;font-family:Tahoma;font-size:24px;line-height:29px;font-weight:bold;text-align:center;">The Daily News</h1><h2 style="color:#828E97;font-family:Tahoma;font-size:16px;margin-bottom: 25px;font-weight:bold;text-align:center;margin-left:3%;margin-right:3%;">%%=v(@Salutation)=%% check out the latest stories!</h2></td></tr><tr><td align="center" colspan="2" style="background-color: #fff;" valign="top">';
        
        //First banner ad
        genHTML.Story__c += barAd1;
        genHTML.Story__c += '<table style="border-collapse:collapse;margin-bottom:2px;border:none;width:95%;max-width:612px;"><tbody><tr><td align="left" style="background-color: #9DA7AE;text-align:left;height:42px;border-left:1px solid #ffffff;" valign="middle"><p style="font-family: Tahoma;font-size: 14px;color: #fff;font-weight:bold;margin-left:3%;text-align:left;">LATEST</p></td></tr></tbody></table><table style="width:95%;max-width:615px;border-collapse:collapse;"><tbody><tr><td align="left" class="mobile" style="max-width:485px;" valign="top">';
        
        //First 2 articles
        
        if (arrayArticles.size()>0 && arraySideAds.size()>0){
            genHTML.Story__c += arrayArticles[0];
            genHTML.Story__c += arrayArticles[1];
            
            
            //First sidebar ad
            genHTML.Story__c += '</td><td class="mobile" style="width:3px;"><p><a href="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png"><img height="3" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png" style="display:block;border:none;height:3px;width:10px;" width="10"></a></p></td><td align="center" class="mobile" style="width:120px;" valign="middle"><!-- TOP RIGHT BANNER AD -->';
            genHTML.Story__c += arraySideAds[0];
            genHTML.Story__c += '<!-- END TOP RIGHT BANNER AD --></td></tr></tbody></table></td></tr><tr><td align="center" colspan="2" style="background-color: #fff;" valign="top"><table style="width:95%;max-width:615px;border-collapse:collapse;"><tbody><tr><td align="left" class="mobile" style="max-width:480px;" valign="top">';
            
            //Second 2 articles
            genHTML.Story__c += arrayArticles[2];
            genHTML.Story__c += arrayArticles[3];
            
            //Second side bar ad
            genHTML.Story__c += '</td><td class="mobile" style="width:3px;"><p><a href="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png"><img height="3" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png" style="display:block;border:none;height:3px;width:10px;" width="10"></a></p></td><td align="center" class="mobile" style="width:120px;" valign="middle"><!-- BOTTOM RIGHT BANNER AD -->';
            genHTML.Story__c += arraySideAds[1];
            genHTML.Story__c += '<!-- END BOTTOM RIGHT BANNER AD --></td></tr></tbody></table></td></tr>';
            
            //First text ad
            genHTML.Story__c += txtAd1;
            
            //Second banner ad
            genHTML.Story__c += barAd2;
            genHTML.Story__c += '<tr><td align="center" colspan="2" style="background-color: #fff;" valign="top"><table style="width:95%;max-width:615px;border-collapse:collapse;"><tbody><tr><td align="left" class="mobile" style="max-width:485px;" valign="top">';
            
            //Third 2 articles
            genHTML.Story__c += arrayArticles[4];
            genHTML.Story__c += arrayArticles[5];
            
            //Third sidebar ad
            genHTML.Story__c += '</td><td class="mobile" style="width:3px;"><p><a href="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png"><img height="3" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png" style="display:block;border:none;height:3px;width:10px;" width="10"></a></p></td><td align="center" class="mobile" style="width:120px;" valign="middle"><!-- TOP RIGHT BANNER AD -->';
            genHTML.Story__c += arraySideAds[2];
            genHTML.Story__c += '<!-- END TOP RIGHT BANNER AD --></td></tr></tbody></table></td></tr>';
            
            //Second text ad
            genHTML.Story__c += txtAd2;
            genHTML.Story__c += '<tr><td align="center" colspan="2" style="background-color: #fff;" valign="top"><table style="width:95%;max-width:615px;border-collapse:collapse;"><tbody><tr><td align="left" class="mobile" style="max-width:485px;" valign="top">';
            
            //Fourth 2 articles
            genHTML.Story__c += arrayArticles[6];
            genHTML.Story__c += arrayArticles[7];
            
            //Fourth side bar ad
            genHTML.Story__c += '</td><td class="mobile" style="width:3px;"><p><a href="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png"><img height="3" src="http://image.mc.garp.org/lib/fe3815707564067b731074/m/1/0f9be531-9fb4-4259-8c8d-f3037b54529a.png" style="display:block;border:none;height:3px;width:10px;" width="10"></a></p></td><td align="center" class="mobile" style="width:120px;" valign="middle"><!-- BOTTOM RIGHT BANNER AD -->';
            genHTML.Story__c += arraySideAds[3];
            genHTML.Story__c += '<!-- END BOTTOM RIGHT BANNER AD --></td></tr></tbody></table></td></tr>';
            
            //Footer HTML
            genHTML.Story__c += '<tr><td align="center" colspan="2"><table style="border-collapse:collapse;width:94%;box-sizing:border-box;"><tbody><tr bgcolor="#f1f2f4" style="background-color: #f1f2f4;line-height:40px;" valign="middle"><td bgcolor="#f1f2f4" style="background-color: #f1f2f4;text-align:center;"><custom type="footer" /></td></tr></tbody></table></td></tr></tbody></table></div><!--[if mso]></td></tr></table></center><![endif]--><!--end wrapper-->';
            
            //Closing HTML
            genHTML.Story__c += '</body></html>';
        }
        
    }
    
    
    public void sendEmail() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Retrieve email recipient's address from Custom Setting
        List < String > toAddresses = new List < String > ();
        List < News_Feed_Selector__c > selector = News_Feed_Selector__c.getall().values();
        Set < String > emailids = new Set < String > ();
        system.debug('selector'+selector);
        //System.debug(selector.Recipient_Emil__c);
        for (News_Feed_Selector__c email: selector) {
            emailids.add(email.Name);
        }
        for (string s: emailids)
            if (s != null) {
                toAddresses.add(s);
            } else {
                Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'No Email address found in Custom Settings, using default value: websiteupdates@garp.com'));
                toAddresses.add('websiteupdates@garp.com');
            }
        
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('News Feed Selector');
        mail.setSubject('Newsletter Feed');
        mail.setBccSender(false);
        //mail.setUseSignature(true); ??
        mail.setPlainTextBody('Daily articles chosen for newsletter: ' + DateTime.now().format());
        
        if (!Test.isRunningTest() && selector != null) {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                mail
                    });
        }
        
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Email sent on ' + DateTime.now().format()));
        
    }
    
}