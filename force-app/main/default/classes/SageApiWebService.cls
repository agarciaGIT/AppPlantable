public class SageApiWebService {
    
    
    public static String authentication(){
        
        String contentobject = 'SODOCUMENT';
        String fields = '*';
        String returnFormat = 'xml';
        Integer pagesize = 100;
        
        Boolean uniqueid = false;
        Decimal dtdversion = 3.0;
        Boolean includewhitespace = true;
        
        
        Sage_API__mdt sageMDt = [SELECT senderid__c, ctrlpassword__c, controlid__c, userid__c,
                                 Companyid__c, password__c FROM Sage_API__mdt where DeveloperName = 'Sage_API'];
        
        string xml = '';
        xml+=  '<?xml version="1.0" encoding="UTF-8"?>';
        xml+=  '<request>';
        xml+=     '<control>';
        xml+=        '<senderid>'+ sageMDt.senderid__c +'</senderid>';
        xml+=        '<password>'+ sageMDt.ctrlpassword__c +'</password>';
        xml+=        '<controlid>'+ sageMDt.controlid__c +'</controlid>';
        xml+=        '<uniqueid>'+ uniqueid +'</uniqueid>';
        xml+=        '<dtdversion>'+ dtdversion +'</dtdversion>';
        xml+=        '<includewhitespace>'+ includewhitespace +'</includewhitespace>';
        xml+=     '</control>';
        xml+=     '<operation transaction="false">';
        xml+=        '<authentication>';
        xml+=           '<login>';
        xml+=              '<userid>'+ sageMDt.userid__c +'</userid>';
        xml+=              '<companyid>'+ sageMDt.Companyid__c +'</companyid>';
        xml+=              '<password>'+ sageMDt.password__c +'</password>';
        xml+=           '</login>';
        xml+=        '</authentication>';
        xml+= '<content>';
        xml+= '<function controlid="testControlId">';
        xml+= '<readByQuery>';
        xml+= '<object>'+contentobject+'</object>';
        xml+= '<fields>'+fields+'</fields>';
        xml+= '<query />';
        xml+= '<returnFormat>'+returnFormat+'</returnFormat>';
        xml+= '<pagesize>'+pagesize+'</pagesize>';
        xml+= '</readByQuery>';
        xml+= '</function>';
        xml+= '</content>';
        xml+= '</operation>';
        xml+= '</request>';
        
        return callOutMethod(xml);
        
    }
    
    public static void reallocation(String InvoiceNo,Date InitialDate){
        
        if(authentication() != 'Failed'){
            
            Boolean uniqueid = false;
            Decimal dtdversion = 3.0;
            Boolean includewhitespace = true;
            
            String Recordno ;
            Integer Rev_Year;
            Integer Rev_month;
            Integer Rev_day;
            Date revDate;
            
            
            Sage_API__mdt sageMDt = [SELECT senderid__c, ctrlpassword__c, controlid__c, userid__c,
                                     Companyid__c, password__c,recordno__c FROM Sage_API__mdt where DeveloperName = 'Sage_API'];
            
            string xml = '';
            
            xml+=  '<?xml version="1.0" encoding="UTF-8"?>';
            xml+=  '<request>';
            xml+=  '	<control>';
            xml+=  '		<senderid>'+ sageMDt.senderid__c +'</senderid>';
            xml+=  '		<password>'+ sageMDt.ctrlpassword__c +'</password>';
            xml+=  '		<controlid>'+ sageMDt.controlid__c +'</controlid>';
            xml+=  '		<uniqueid>'+ uniqueid +'</uniqueid>';
            xml+=  '		<dtdversion>'+ dtdversion +'</dtdversion>';
            xml+=  '		<includewhitespace>'+ includewhitespace +'</includewhitespace>';
            xml+=  '	</control>';
            xml+=  '	<operation transaction="false">';
            xml+=  '		<authentication>';
            xml+=  '			<login>';
            xml+=  '				<userid>'+ sageMDt.userid__c +'</userid>';
            xml+=  '				<companyid>'+ sageMDt.Companyid__c +'</companyid>';
            xml+=  '				<password>'+ sageMDt.password__c +'</password>';
            xml+=  '			</login>';
            xml+=  '		</authentication>';
            xml+=  '		<content>';
            xml+=  '			<function controlid="testControlId">';
            xml+=  '				<readByQuery>';
            xml+=  '					<object>REVRECSCHEDULE</object>';
            xml+=  '					<fields>RECORDNO,SOREVRECSTARTDATE</fields>';
            xml+=  '					<query>DOCID=\'Sales Invoice - Salesforce-'+InvoiceNo+'\'</query>';
            xml+=  '					<returnFormat>xml</returnFormat>';
            xml+=  '					<pagesize>100</pagesize>';
            xml+=  '				</readByQuery>';
            xml+=  '			</function>';
            xml+=  '		</content>';
            xml+=  '	</operation>';
            xml+=  '</request>';
            
            String expectedResult =  callOutMethod(xml);
            System.debug('expectedResult::'+expectedResult);
            
            
            try
            {
                
                DOM.XMLNode childNode;
                DOM.XMLNode responseNode;
                
                String IsResultStatusSuccess;
                Boolean IsResultDataAvailable;
                
                DOM.Document doc = new DOM.Document();
                doc.load(expectedResult);
                
                //Retrieve the root element for this document.
                responseNode = doc.getRootElement();
                System.debug('responseNode == '+responseNode);
                
                //Is Status Success
                IsResultStatusSuccess = responseNode.getChildElement('operation',null).getChildElement('result',null).getChildElement('status',null).getText();
                System.debug('IsResultStatusSuccess ='+IsResultStatusSuccess);
                
                //Is Data Tag Available
                IsResultDataAvailable = (responseNode.getChildElement('operation',null).getChildElement('result',null).getChildElement('data',null)) != null;
                System.debug('IsResultDataAvailable ='+IsResultDataAvailable);
                
                //Parsing for Date and RecordNo
                if(IsResultDataAvailable && IsResultStatusSuccess == 'success'){
                    for(DOM.XMLNode Node : responseNode.getChildElements()){
                        if(Node.getName() == 'operation'){
                            childNode = Node.getChildElement('result',null).getChildElement('data',null);
                            Integer count = Integer.valueOf(childNode.getAttribute('count',null));
                            Integer Totalcount = Integer.valueOf(childNode.getAttribute('totalcount',null));
                            
                            System.debug('count'+count);
                            System.debug('total count '+Totalcount);
                            
                            if(count == Totalcount && count  == 1 ){
                                
                                Recordno = childNode.getChildElement('revrecschedule',null).getChildElement('RECORDNO',null).getText();
                                System.debug('RECORDNO'+Recordno);
                                if(childNode.getChildElement('revrecschedule',null).getChildElement('SOREVRECSTARTDATE',null).getName() == 'SOREVRECSTARTDATE'){
                                    String str = childNode.getChildElement('revrecschedule',null).getChildElement('SOREVRECSTARTDATE',null).getText();
                                    Rev_month = Integer.Valueof(str.split('/').get(0));
                                    Rev_day = Integer.Valueof(str.split('/').get(1));
                                    Rev_Year = Integer.Valueof(str.split('/').get(2));
                                    
                                    revDate = date.newInstance(Rev_Year, Rev_month, Rev_day);
                                }
                                
                            }
                            else{                                
                                system.debug('There are zero Data Records or More than one Data Records Available');
                            }
                            
                        }
                    }                       
                }
                else{
                    
                    System.debug('<<  ===  RECEIVED XML STATUS IS FAILURE OR NO DATA AVAILABLE ===  >>');
                    
                }            
            }
            
            catch(exception e)
            {
                System.debug('Exception Message =='+e.getMessage());
            }    
            //InitialDate = Date.today();
            System.debug('Initial day'+InitialDate.day());
            System.debug('Initial month'+InitialDate.month());
            System.debug('Initial year'+InitialDate.year());
            //if(InitialDate !=Null && Rev_day !=Null && Rev_month !=Null && Rev_Year !=Null)
            if(InitialDate !=Null)
            {
                //if(Integer.valueOf(InitialDate.day()) > Rev_day && Integer.valueOf(InitialDate.month()) >= Rev_month && Integer.valueOf(InitialDate.year()) >= Rev_Year){
                if(InitialDate > revDate){
                    System.debug('The Received XML after initial call to reallocation() has Date value is Less than Initial Date you sent');
                    
                    String RecallXml = '';
                    
                    RecallXml +='<?xml version="1.0" encoding="UTF-8"?>';
                    RecallXml +='<request>';
                    RecallXml +='	<control>';
                    RecallXml +='		<senderid>'+ sageMDt.senderid__c +'</senderid>';
                    RecallXml +='		<password>'+ sageMDt.ctrlpassword__c +'</password>';
                    RecallXml +='		<controlid>'+ sageMDt.controlid__c +'</controlid>';
                    RecallXml +='		<uniqueid>'+ uniqueid +'</uniqueid>';
                    RecallXml +='		<dtdversion>'+ dtdversion +'</dtdversion>';
                    RecallXml +='		<includewhitespace>'+ includewhitespace +'</includewhitespace>';
                    RecallXml +='	</control>';
                    RecallXml +='	<operation transaction="false">';
                    RecallXml +='		<authentication>';
                    RecallXml +='			<login>';                   
                    RecallXml +='				<userid>'+ sageMDt.userid__c +'</userid>';
                    RecallXml +='				<companyid>'+ sageMDt.Companyid__c +'</companyid>';
                    RecallXml +='				<password>'+ sageMDt.password__c +'</password>';
                    RecallXml +='			</login>';
                    RecallXml +='		</authentication>';
                    RecallXml +='		<content>';
                    RecallXml +='			<function controlid="testControlId">';
                    RecallXml +='				<reallocate_revrecschedule>';
                    RecallXml +='					<recordno>'+Recordno+'</recordno>';
                    RecallXml +='					<revrecstartdate>';
                    RecallXml +='						<year>'+InitialDate.Year()+'</year>';
                    RecallXml +='						<month>'+InitialDate.month()+'</month>';
                    RecallXml +='						<day>'+InitialDate.day()+'</day>';
                    RecallXml +='					</revrecstartdate>';
                    RecallXml +='					<revrecenddate>';
                    RecallXml +='						<year>'+InitialDate.Year()+'</year>';
                    RecallXml +='						<month>'+InitialDate.month()+'</month>';
                    RecallXml +='						<day>'+InitialDate.day()+'</day>';
                    RecallXml +='					</revrecenddate>';
                    RecallXml +='				</reallocate_revrecschedule>';
                    RecallXml +='			</function>';
                    RecallXml +='		</content>';
                    RecallXml +='	</operation>';
                    RecallXml +='</request>';
                    
                    system.debug('<<===== RecallXml Before again Reallocation call that Date value is in Past ======>>' + RecallXml);
                    
                    xml = '';
                    xml = callOutMethod(RecallXml);
                    
                    System.debug('<< ==  Received  XML after again Reallocation call that Date value is in Past ==  >>' + xml);
                    
                }            
                else{
                    
                    System.debug('After initial call to reallocation() has Date value is in Future');
                }
            }
            else{
                
                System.debug('No Data Records Available or More Than one Data Records are avaialble or Initial Date is Null');
            }
            
        }
        else{
            
            System.debug('<< == Authentication Error == >>');
        }
        
        
    }
    
    
    public static string updateOppLineItems(Map<String,List<OpportunityLineItem>> OppIdOLIMap){
        
        Map<String,ia_crm__Sales_Order_Item__c> soiMap = new Map<String,ia_crm__Sales_Order_Item__c>();
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        Set<Id> siteCodeSet = new Set<Id>();
        
        List<Opportunity> oppList = [SELECT Id,Display_Invoice_Number__c,
                                     (SELECT Id,ProductCode,Product_ID__c
                                      FROM OpportunityLineItems),
                                     (SELECT id,Name,ia_crm__Sales_Order__r.Name,ia_crm__Item__c,ia_crm__Opportunity__c
                                      FROM R00N40000001bdmZEAQ /*ia_crm__Sales_Order_Items__c*/) 
                                     FROM Opportunity WHERE Id IN: OppIdOLIMap.keySet()];
        
        for(Opportunity opp : oppList){
            for(ia_crm__Sales_Order_Item__c soi : opp.R00N40000001bdmZEAQ){
                soiMap.put(opp.Id+soi.ia_crm__Item__c,soi);
            }
            oliList.addAll(OppIdOLIMap.get(opp.Id));
        }
        
        for(OpportunityLineItem oli : oliList){
            siteCodeSet.add(oli.Site_Code__c);
        }
        
        Map<Id,ia_crm__Intacct_User_Dimension__c> siteCodeMap = new Map<Id,ia_crm__Intacct_User_Dimension__c>([Select Id,ia_crm__Intacct_Id__c 
                                                                                                               from ia_crm__Intacct_User_Dimension__c 
                                                                                                               where Id IN: siteCodeSet]);
        
        Decimal dtdversion = 3.0;
        Boolean uniqueid = false;
        
        if(authentication() != 'Failed'){
            Sage_API__mdt sageMDt = [SELECT senderid__c, ctrlpassword__c, controlid__c, userid__c,Companyid__c,
                                     password__c FROM Sage_API__mdt where DeveloperName = 'Sage_API'];
            string xml = '';
            xml+=  '<?xml version="1.0" encoding="UTF-8"?>';
            xml+=  '<request>';
            xml+=  		'<control>';
            xml+=  			'<senderid>'+ sageMDt.senderid__c +'</senderid>';
            xml+=  			'<password>'+ sageMDt.ctrlpassword__c +'</password>';
            xml+=  			'<controlid>'+ sageMDt.controlid__c +'</controlid>';
            xml+=  			'<uniqueid>'+ uniqueid +'</uniqueid>';
            xml+=  			'<dtdversion>'+ dtdversion +'</dtdversion>';
            xml+=  			'<includewhitespace>'+ true +'</includewhitespace>';
            xml+=  		'</control>';
            xml+=  		'<operation transaction="false">';
            xml+=  			'<authentication>';
            xml+=  				'<login>';
            xml+=  					'<userid>'+ sageMDt.userid__c +'</userid>';
            xml+=  					'<companyid>'+ sageMDt.Companyid__c +'</companyid>';
            xml+=  					'<password>'+ sageMDt.password__c +'</password>';
            xml+=  				'</login>';
            xml+=  			'</authentication>';
            xml+=  			'<content>';
            xml+=  	 				'<function controlid="testControlId">';
            
            
            for (Opportunity opp : oppList){
                System.debug('opp.ChargentSFA__Invoice_Number__c::>>   '+opp.Display_Invoice_Number__c);
                
                xml+=		'<update_sotransaction key="Sales Invoice - Salesforce-'+opp.Display_Invoice_Number__c+'">';
                xml+= 		 '<updatesotransitems>';    
                
                for(OpportunityLineItem oli : OppIdOLIMap.get(opp.Id)){
                    if(soiMap.containsKey(opp.Id+oli.Product_ID__c)){
                        ia_crm__Sales_Order_Item__c SalesOrderItems = soiMap.get(opp.Id+oli.Product_ID__c);
                        xml+=  			'<updatesotransitem line_num="'+SalesOrderItems.Name+'">';
                        xml+=  				'<customfields>';
                        xml+=					'<customfield>';
                        xml+=  						    '<customfieldname>GLDIMSITE_CODE</customfieldname>';
                        xml+= 							'<customfieldvalue>'+siteCodeMap.get(Oli.Site_Code__c).ia_crm__Intacct_Id__c+'</customfieldvalue>';
                        xml+=  					'</customfield>';
                        xml+=				'</customfields>';
                        xml+=  			'</updatesotransitem>';
                    }
                }
                xml+= 				  '</updatesotransitems>';
                xml+=  				'</update_sotransaction>';
            }
            
            xml+=  			'</function>';
            xml+=  		'</content>';
            xml+=  	'</operation>';
            xml+= '</request>';
            
            return callOutMethod(xml);
        }
        return '<< == Authentication Error == >>';
    }
    
    /*
    public static string updateOppLineItems(set<opportunity> OppList){
        
        List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>();
        List<ia_crm__Sales_Order_Item__c> SalesOrderListItems = new List<ia_crm__Sales_Order_Item__c>(); 
        Decimal dtdversion = 3.0;
        Boolean uniqueid = false;
        if(authentication() != 'Failed'){
            
            Sage_API__mdt sageMDt = [SELECT senderid__c, ctrlpassword__c, controlid__c, userid__c,Companyid__c,
                                     password__c FROM Sage_API__mdt where DeveloperName = 'Sage_API'];
            String inv = 'W33333';
            String sc = '1048';
            string xml = '';
            xml+=  '<?xml version="1.0" encoding="UTF-8"?>';
            xml+=  '<request>';
            xml+=  		'<control>';
            xml+=  			'<senderid>'+ sageMDt.senderid__c +'</senderid>';
            xml+=  			'<password>'+ sageMDt.ctrlpassword__c +'</password>';
            xml+=  			'<controlid>'+ sageMDt.controlid__c +'</controlid>';
            xml+=  			'<uniqueid>'+ uniqueid +'</uniqueid>';
            xml+=  			'<dtdversion>'+ dtdversion +'</dtdversion>';
            xml+=  			'<includewhitespace>'+ true +'</includewhitespace>';
            xml+=  		'</control>';
            xml+=  		'<operation transaction="false">';
            xml+=  			'<authentication>';
            xml+=  				'<login>';
            xml+=  					'<userid>'+ sageMDt.userid__c +'</userid>';
            xml+=  					'<companyid>'+ sageMDt.Companyid__c +'</companyid>';
            xml+=  					'<password>'+ sageMDt.password__c +'</password>';
            xml+=  				'</login>';
            xml+=  			'</authentication>';
            xml+=  			'<content>';
            xml+=  	 				'<function controlid="testControlId">';
            
            for (Opportunity opp : OppList){
                System.debug('Display Invoice Number ::'+opp.ChargentSFA__Invoice_Number__c);
                
                xml+=		'<update_sotransaction key="Sales Invoice - Salesforce-'+opp.ChargentSFA__Invoice_Number__c+'">';
                xml+= 		 '<updatesotransitems>';    
                
                oppLineItem = [SELECT Id,Site_Code__r.ia_crm__Intacct_Id__c,OpportunityId,Product_ID__c
                               FROM OpportunityLineItem WHERE OpportunityId =: opp.id];
                
                Integer i=0;
                
                for(OpportunityLineItem Oli : oppLineItem)	{        
                    try{
                        SalesOrderListItems = [ SELECT id,Name,ia_crm__Sales_Order__r.Name,
                                               ia_crm__Item__c,ia_crm__Opportunity__c from 
                                               ia_crm__Sales_Order_Item__c where ia_crm__Opportunity__c =: opp.id and 
                                               ia_crm__Sales_Order__r.Name =: opp.ChargentSFA__Invoice_Number__c ];
                        
                        xml+=  			'<updatesotransitem line_num="'+SalesOrderListItems[i].Name+'">';
                        xml+=  				'<customfields>';
                        xml+=					'<customfield>';
                        xml+=  						    '<customfieldname>GLDIMSITE_CODE</customfieldname>';
                        xml+= 							'<customfieldvalue>'+Oli.Site_Code__r.ia_crm__Intacct_Id__c+'</customfieldvalue>';
                        xml+=  					'</customfield>';
                        xml+=				'</customfields>';
                        xml+=  			'</updatesotransitem>';
                        
                        System.debug('Product_ID__c  --> '+SalesOrderListItems[i].ia_crm__Item__c);	    
                        System.debug('Line number  --> '+SalesOrderListItems[i].Name);    
                        System.debug('intact number  --> '+Oli.Site_Code__r.ia_crm__Intacct_Id__c);	   
                        
                    }
                    catch(Exception e){
                        System.debug('Exception Message :: '+e.getMessage());
                    } 
                    i++;			
                }
                
                xml+= 				  '</updatesotransitems>';
                xml+=  				'</update_sotransaction>';
            }
            xml+=  			'</function>';
            xml+=  		'</content>';
            xml+=  	'</operation>';
            xml+= '</request>';
            
            return callOutMethod(xml);
        }
        
        else{
            return '<< == Authentication Error == >>';
        }
    }
    */
    
    public static String callOutMethod(String reqBody) {
        
        Sage_API__mdt sageMDt = [SELECT EndPoint__c FROM Sage_API__mdt where DeveloperName = 'Sage_API'];
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        
        req.setEndpoint(sageMDt.EndPoint__c); 
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/xml');
        req.setBody(reqBody);
        
        system.debug('request::>>  '+req);
        system.debug('request::>>  '+req.getBody());
        
        String XmlResponse;
        if(Test.isRunningTest()){
            //XmlResponse = '<?xml version="1.0" encoding="UTF-8"?><testing>done!!</testing>';
            XmlResponse = '<?xml version="1.0" encoding="UTF-8"?><response><operation><result><status>success</status><data listtype="revrecschedule" count="1" totalcount="1" numremaining="0" resultId=""><revrecschedule><RECORDNO>40</RECORDNO><SOREVRECSTARTDATE>1/1/2022</SOREVRECSTARTDATE></revrecschedule></data></result></operation></response>';
        }else{
            res = http.send(req);
            XmlResponse = (res.getStatusCode() == 200 || res.getStatusCode() == 201) ? res.getBody() : 'Failed';
        }
        system.debug('Response::>>  '+XmlResponse+'  ==>> with response status code ::  '+res.getStatusCode());
        
        return XmlResponse;
    }
    
        
}