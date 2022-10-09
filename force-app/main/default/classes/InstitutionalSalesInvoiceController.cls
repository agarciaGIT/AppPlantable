/*  Controller for InstitutionalSalesInvoice and Public_InstitutionalSalesInvoice page. Can be use either as controller or extension.
 *  01/24/2019 Xiang - Created per [US-17765]
 *  04/25/2019 Xiang - [US-21245] Prevent invoice display when not approved
 *  05/14/2019 Xiang - [US-21939] Adjustments
 *  06/10/2019 Xiang - [US-22178] Discount and sorting
 */
public without sharing class InstitutionalSalesInvoiceController {
    
    public String renderOpt { get; set; }
    
    // Use this oppty variable in Apex Class only. VF page needs wrapped attributes
    public Opportunity oppty { get; private set; }
    
    // Formula field, need wrapper for public site display
    public String displayInvoice { get; private set; }

    // Billing Information - From Chargent, need wrapper for public site display
    public String billCompany {get;private set;}
    public String billFirst {get;private set;}
    public String billLast {get;private set;}
    public String billAddress {get;private set;}
    public String billAddressLine2 {get;private set;}
    public String billCity {get;private set;}
    public String billState {get;private set;}
    public String billZip {get;private set;}
    public String billCountry {get;private set;}
    
    public String attentionName { get; private set; }
    public String attentionEmail { get; private set; }
    public String salesSummary { get; private set; }
    public String generalStatement { get; private set; }
    public Decimal totalAmount { get; private set; }
    public String salesPerson { get; private set; }
    public String paymentTerm { get; private set; }
    public String dueDate { get; private set; }

    public List<LineItemWrapper> lineItems { get; private set; }
    
    public Boolean showInvoice { get; private set; }
    public Boolean isPaid { get; private set; }
    public Boolean isCancelled { get; private set; }

    // Either GARP Risk Academy, LLC or Global Association of Risk Professionals, Inc
    public String garpName { get; private set; }
    public String garpTaxId { get; private set; }
    public String garpAcctNum { get; private set; }

    private static Set<String> noCreditCountry = new Set<String>{'Ghana', 'Nigeria'};
    public Boolean noCreditPayment { get; private set; }
    
    // As a custom Controller
    public InstitutionalSalesInvoiceController() {
        Id oppId = ApexPages.currentPage().getParameters().get('id');
        if(String.isNotEmpty(oppId)) {
            pageSetup(oppId);
        }
    }

    // As a Controller Extension
    public InstitutionalSalesInvoiceController(ApexPages.StandardController ctrl) {
        Id opportunityId = ctrl.getId();
        
        pageSetup(opportunityId);
    }

    private void pageSetup(Id opportunityId) {
        // Inst_Sale_Attention__c - Attention Name, Inst_Sale_Billing_Email__c - Attention Email
        List<Opportunity> opportunities = [
            SELECT Id, Name, RecordType.Name, StageName, Company__c, Inst_Sale_Display_Invoice_Number__c, Inst_Sale_Attention__c, Inst_Sale_Billing_Email__c,
            Amount, Institutional_Sale__c, Summary_Description_of_Services__c, Inst_Sale_General_Invoice_Statement__c, 
            Owner.Name, GARP_Sales_Contact__c, GARP_Sales_Contact__r.Name, Inst_Sale_Payment_Terms__c, Inst_Sale_Due_Date__c, Institutional_Sale_Stage__c, 
            ChargentSFA__Billing_Company__c, ChargentSFA__Billing_First__c, ChargentSFA__Billing_Last__c,
            ChargentSFA__Billing_Address__c, ChargentSFA__Billing_Address_Line_2__c, ChargentSFA__Billing_City__c, ChargentSFA__Billing_State__c, ChargentSFA__Billing_Zip__c, ChargentSFA__Billing_Country__c,
            (SELECT Id, Product2.Name, Product2.Inst_Sale_Sort_Order__c, Quantity, UnitPrice, TotalPrice, Inst_Sale_Product_Name__c FROM OpportunityLineItems WHERE Product2.Name != 'Inst Sale Total Discount'),
            (SELECT Line_Item_Id__c, Product__r.Name, Product__r.Inst_Sale_Sort_Order__c, Line_Item_Quantity__c, Discount_Percent__c, Discount_Amount__c, Invoice_Description__c FROM Line_Item_Discounts__r)
            FROM Opportunity WHERE Id = :opportunityId
        ];
        
        if(opportunities.size() > 0) {
            oppty = opportunities[0];
                
            Profile p = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()];

            if(p.Name == 'Institutional Outreach' && oppty.Institutional_Sale_Stage__c != 'Approved') {
                showInvoice = false;
            }else {
                showInvoice = true;
            }
            
            if(showInvoice) {
                setupOpptyInfo(oppty);

                // Use Oppty Company as package company. If empty defaults to GARP
                loadGarpInfo(String.isEmpty(oppty.Company__c) ? 'GARP' : oppty.Company__c);
            
                loadLineItems(oppty);
                
                noCreditPayment = noCreditCountry.contains(oppty.ChargentSFA__Billing_Country__c);
                isPaid = (oppty.StageName == 'Closed');
                isCancelled = (oppty.StageName == 'Closed Lost');
            }
        }
        
        // For viewing this page in html
        String paraRenderOpt = ApexPages.currentPage().getParameters().get('renderOpt');
        renderOpt = paraRenderOpt == 'html' ? paraRenderOpt : 'PDF';
    }

    // Seems fields in package and formula are not displayed in public site regardless of without sharing
    private void setupOpptyInfo(Opportunity oppty) {
        displayInvoice = oppty.Inst_Sale_Display_Invoice_Number__c;
        
        billCompany = oppty.ChargentSFA__Billing_Company__c;
        billFirst = oppty.ChargentSFA__Billing_First__c;
        billLast = oppty.ChargentSFA__Billing_Last__c;
        billAddress = oppty.ChargentSFA__Billing_Address__c;
        billAddressLine2 = oppty.ChargentSFA__Billing_Address_Line_2__c;
        billCity = oppty.ChargentSFA__Billing_City__c;
        billState = oppty.ChargentSFA__Billing_State__c;
        billZip = oppty.ChargentSFA__Billing_Zip__c;
        billCountry = oppty.ChargentSFA__Billing_Country__c;
        
        attentionName = oppty.Inst_Sale_Attention__c;
        attentionEmail = oppty.Inst_Sale_Billing_Email__c;
        salesSummary = oppty.Summary_Description_of_Services__c;
        generalStatement = oppty.Inst_Sale_General_Invoice_Statement__c;
        totalAmount = oppty.Amount;
        salesPerson = oppty.GARP_Sales_Contact__r.Name;
        paymentTerm = oppty.Inst_Sale_Payment_Terms__c;
        dueDate = oppty.Inst_Sale_Due_Date__c;
    }
    
    private void loadGarpInfo(String compName) {
        if(compName == 'GRA') {
            garpName = 'GARP Risk Academy, LLC';
            garpTaxId = '20-3453938';
            garpAcctNum = '53544466';
        }else If(compName == 'GARP') {
            garpName = 'Global Association of Risk Professionals, Inc';
            garpTaxId = '020-571-577';
            garpAcctNum = '95628297';
        }
    }
    
    private void loadLineItems(Opportunity oppty) {
        lineItems = new List<LineItemWrapper>();
        
        // Load info from Line Items
        for(OpportunityLineItem lineItem : oppty.OpportunityLineItems) {
            lineItems.add(new LineItemWrapper(lineItem));
        }
        
        // Load Info from Item Discounts
        Map<Id, OpportunityLineItem> lineItemMap = new Map<Id, OpportunityLineItem>(oppty.OpportunityLineItems);

        for(Line_Item_Discount__c itemDisc : oppty.Line_Item_Discounts__r) {
            // If Line Item Discount is set properly
            if(null != itemDisc.Line_Item_Id__c) {
                // Get related Opportunity Line Item under same Opportunity
                OpportunityLineItem oli = lineItemMap.get(itemDisc.Line_Item_Id__c);
                
				String instSaleProdName = oli != null ? oli.Inst_Sale_Product_Name__c : null;
                lineItems.add(new LineItemWrapper(itemDisc, instSaleProdName));
            }
        }
        
        lineItems.sort();
    }
    
    public without sharing class LineItemWrapper implements Comparable {
        // Indicates amount is negative and apply red font with css 
        public Boolean isDiscount {get;set;}
        public Boolean isProdDisc {get;set;}
        
        // System required fields
        public Integer sortOrder {get;set;}
        public String prodInstSaleName {get;set;}
		
        // Fields to display on invoice
        public Decimal quantity {get;set;}
        public String productName {get;set;}
        public Decimal unitPrice {get;set;}
        public Decimal totalPrice {get;set;}
        
        public LineItemWrapper(OpportunityLineItem lineItem) {
			this.prodInstSaleName = String.isNotEmpty(lineItem.Inst_Sale_Product_Name__c) ? lineItem.Inst_Sale_Product_Name__c : lineItem.Product2.Name;
                
            // For supporting page on public site
            this.quantity = lineItem.Quantity;
            this.productName = prodInstSaleName;
            this.unitPrice = lineItem.UnitPrice;
            this.totalPrice = lineItem.TotalPrice;
            
            this.sortOrder = (Integer)lineItem.Product2.Inst_Sale_Sort_Order__c;
            this.isDiscount = (lineItem.UnitPrice < 0);
            this.isProdDisc = false;
        }
        
        public LineItemWrapper(Line_Item_Discount__c itemDisc, String instSaleProdName) {
            Product2 discProd = itemDisc.Product__r;
            
            this.prodInstSaleName = instSaleProdName != null ? instSaleProdName : discProd.Name;
            
            this.quantity = itemDisc.Line_Item_Quantity__c;
            this.productName = itemDisc.Invoice_Description__c;
            if(null == this.productName) {
                this.productName = itemDisc.Discount_Percent__c + '% Discount on ' + this.prodInstSaleName;
            }
            this.unitPrice = -1 * itemDisc.Discount_Amount__c;
            this.totalPrice = -1 * itemDisc.Discount_Amount__c * itemDisc.Line_Item_Quantity__c;
            
            this.sortOrder = (Integer)discProd.Inst_Sale_Sort_Order__c;
            this.isDiscount = true;
            this.isProdDisc = true;
        }
        
        public Integer compareTo(Object compareTo) {
            LineItemWrapper another = (LineItemWrapper)compareTo;
            Decimal thisOrder = this.sortOrder, thatOrder = another.sortOrder;
            Boolean thisIsDisc = this.isProdDisc, thatIsDisc = another.isProdDisc;
            
            if(null != thisOrder && null != thatOrder) {
                if(thisOrder == thatOrder) {
                    if(thisIsDisc && !thatIsDisc) {
                        return 1;
                    }else if(!thisIsDisc && thatIsDisc) {
                        return -1;
                    }else {
                        return this.prodInstSaleName.compareTo(another.prodInstSaleName);
                    }
                }else {
                    return (Integer)(thisOrder - thatOrder);
                }
            }else {
                return this.prodInstSaleName.compareTo(another.prodInstSaleName);
            }
        }
    }
}