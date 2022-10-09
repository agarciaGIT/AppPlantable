public class certuploader {
    
    public Blob contentFile{get;set;}
    public string fileName{get;set;}
    
    public PageReference ReadFile() {
        if(contentFile == null) return null;
        Dom.Document doc = new Dom.Document();
        doc.load(contentFile.toString());
        system.debug('doc == '+doc);
        Dom.XMLNode responseNode = doc.getRootElement();
        String strNameSpace = responseNode.getNamespace();
        Map<String,String> strTrackingNumberMap = new Map<String,String>(); 
        for(Dom.XMLNode child : responseNode.getChildElements()) {
            System.debug('Text : '+child.getText());
            Dom.XMLNode openShipMentNode = child.getChildElement('OpenShipment',strNameSpace);
            Dom.XMLNode processMessageNode = child.getChildElement('ProcessMessage',strNameSpace);
            system.debug('processMessageNode == '+processMessageNode);
            
            // XmlStreamReader streamReader = new XmlStreamReader(contentFile.toString());
            strTrackingNumberMap.putALL(readXML(processMessageNode));
        }
        updateCertificateShipping(strTrackingNumberMap);
        return null;
    }
    
    public  Map<String,String> readXML(Dom.XMLNode responseNode)
    {
        Map<String,String> strTrackingNumberMap = new Map<String,String>();
        String strTrackingNumber = '';
        String strInvoiceNo = '';
        for(Dom.XMLNode mainNode : responseNode.getChildElements())
        {
            system.debug('mainNode == '+mainNode);
            system.debug('mainNode Type == '+mainNode.getNodeType());
            system.debug('mainNode Text == '+mainNode.getName());
            if (mainNode.getNodeType() == DOM.XMLNodeType.ELEMENT && mainNode.getName() == 'TrackingNumbers') {
                
                //system.debug('mainNode == '+mainNode);
                for(Dom.XMLNode node : mainNode.getChildElements())
                {
                    system.debug('node == '+node);
                    if(node.getNodeType() == DOM.XMLNodeType.ELEMENT)
                    {
                        strTrackingNumber = node.getText();
                    }
                }
            }
            if (mainNode.getNodeType() == DOM.XMLNodeType.ELEMENT && mainNode.getName() == 'Reference1') {
                strInvoiceNo = mainNode.getText();
            }
        }
        system.debug('strTrackingNumber '+strTrackingNumber);
        system.debug('strInvoiceNo == '+strInvoiceNo); 
        if(strInvoiceNo !=null && strTrackingNumber !=null){
            strTrackingNumberMap.put(strInvoiceNo,strTrackingNumber);
        }
        contentFile = null;
        return strTrackingNumberMap;
    }
    
    public static void updateCertificateShipping(Map<String,String> strTrackingNumberMap){
        try
        {
            List<certificate_shipping__c> conList = new List<certificate_shipping__c>();
            for(certificate_shipping__c con:[select id,name,Garp_id__c ,Tracking_Number__c from certificate_shipping__c  where Name In : strTrackingNumberMap.keySet()]){
                if(strTrackingNumberMap.containsKey(con.Name)){
                    con.Tracking_Number__c = strTrackingNumberMap.get(con.Name);
                    con.Do_Not_Fire__c = true;
                    conList.add(con);
                }
            }
            if(!conList.isEmpty()){
                update conList;
            }
        }
        catch(Exception ex)
        { 
            
        }
    }
    
    
}