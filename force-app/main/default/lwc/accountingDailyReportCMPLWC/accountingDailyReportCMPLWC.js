import { LightningElement, track ,wire} from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import intacctTransaction from '@salesforce/schema/Opportunity.ia_crm__Intacct_Transaction__c';
import ChargentSFAPaymentMethod from '@salesforce/schema/Opportunity.ChargentSFA__Payment_Method__c';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import accountingDailyReport from '@salesforce/apex/AccountingDailyReportLWCController.getAccountingDailyReport';
import insertOrderTransactionItems from '@salesforce/apex/AccountingDailyReportLWCController.insertOrderTransactionItems';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class accountingDailyReportCMPLWC extends LightningElement {
    @track intacctTransactionoptions = [];
    @track paymentMethodoptions = [];
    selectedintacctTransaction = [];
    selectedpaymentMethod = []; 
    @track tableheaderListData = [];
    @track dailyAccountReportTableList;  
    @track startDate;
    @track endDate;
    @track isLoaded = false; 
    @track selectedRowsCount = 0;  
  @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    opportunityInfo; 
    

    @wire(getPicklistValues,{ recordTypeId: '$opportunityInfo.data.defaultRecordTypeId', fieldApiName: intacctTransaction})
    intacctTransactionfield({ error, data }) {
        if (data) {  
            data.values.forEach(e => { this.intacctTransactionoptions.push({label:e.label,value:e.value}) }); 
        } else if (error) {
            console.log('Error');
        }
    }

    @wire(getPicklistValues,{ recordTypeId: '$opportunityInfo.data.defaultRecordTypeId', fieldApiName: ChargentSFAPaymentMethod})
    paymentMethodfield({ error, data }) {
        if (data) {  
            data.values.forEach(e => { this.paymentMethodoptions.push({label:e.label,value:e.value}) }); 
        } else if (error) {
            console.log('Error');
        }
    }
 
    handleinputchange(event){
        var evname = event.target.name;
        var evvalue = event.target.value;
        if(evname == 'StartDate'){
            this.startDate = evvalue;
        }
        if(evname == 'EndDate'){
            this.endDate = evvalue;
        }
    }
    handlerefresh(){
        this.isLoaded = true;
        this.dailyAccountReportTableList = []; 
        accountingDailyReport({intacctTransaction:this.selectedintacctTransaction,paymentMethod:this.selectedpaymentMethod,startDate:this.startDate,endDate:this.endDate})
		.then(result => { 
            try{ 
                this.dailyAccountReportTableList = [];  
                var maxheaderheader = 0; 
                for(let key in result) {     
                    if(maxheaderheader <= result[key].length){ 
                        maxheaderheader = result[key].length; 
                    }  
                }   
                var totalgrandtotal = 0; 
                for(let oppid in result) {  
                    var tableobj = {}; 
                    var rowobjdata = [];  
                    var index = 0;
                   
                    var rowobj = [];
                    var oppmap = result[oppid][0];  
                    rowobj.push({label:"TransactionType",value:oppmap.Opportunity.ia_crm__Intacct_Transaction__c});  
                    rowobj.push({label:"Company",value:oppmap.Opportunity.Company__c});
                    rowobj.push({label:"GARPID",value:oppmap.Opportunity.GARP_Member_ID__c});
                    rowobj.push( {label:"AccountName",value:oppmap.Opportunity.AccountId !=undefined?oppmap.Opportunity.Account.Name:''});
                    rowobj.push({label:"PaidDate",value:oppmap.Opportunity.Sage_Paid_Date__c});
                    rowobj.push({label:"PaymentMethod",value:oppmap.Opportunity.ChargentSFA__Payment_Method__c});
                    rowobj.push({label:"CreditCardType",value:oppmap.Opportunity.ChargentSFA__Card_Type__c});
                    rowobj.push({label:"BatchID",value:oppmap.Opportunity.Sage_Document_Number__c});
                    rowobj.push({label:"PaypalTransID",value:oppmap.Opportunity.ChargentSFA__Tokenization__c});                    
                    rowobj.push({label:"InvoiceNo",value:oppmap.Opportunity.Display_Invoice_Number__c});
                    rowobj.push({label:"BillingCountry",value:oppmap.Opportunity.ChargentSFA__Billing_Country__c}); 
                    //rowobj.push({label:"BillingState",value:oppmap.Opportunity.ChargentSFA__Billing_State__c});
                    rowobj.push({label:"ShippingCountry",value:oppmap.Opportunity.Shipping_Country__c}); 
                    rowobj.push({label:"ShippingState",value:oppmap.Opportunity.Shipping_State__c}); 
                   //rowobj.push({label:"ContactName",value:oppmap.Opportunity.AccountId !=undefined?oppmap.Opportunity.Account.Name:''});//value:oppmap.Opportunity.ContactId}); 
                     
                    index ++;
                    var grandtotal = 0;  
                    var a = 0; 
                    var backgroundtotal = 0;                 
                    for(let oppobj in result[oppid]) { 
                        var olobj = result[oppid][oppobj]; 
                        let total = 0.00;
                        if(olobj.TotalPrice != undefined){
                            total = Number(Math.round(olobj.TotalPrice+'e2')+'e-2');
                            total = total.toFixed(2);
                        }
                         
                        if(backgroundtotal >= 3){
                            backgroundtotal = 0;
                        }
                        backgroundtotal ++;
                        
                        rowobj.push({label:"Product ID",value:olobj.Product_ID__c,class:"productbackground"+backgroundtotal});
                        rowobj.push({label:"Class",value:olobj.ia_crm__Class__c != undefined? olobj.ia_crm__Class__r.Name:'',class:"productbackground"+backgroundtotal});
                        rowobj.push({label:"Revenue Start Date",value:olobj.ServiceDate,class:"productbackground"+backgroundtotal});  
                        rowobj.push({label:"Template",value:olobj.Intacct_Template__c != undefined?olobj.Intacct_Template__r.Name:'',class:"productbackground"+backgroundtotal});                        
                        rowobj.push({label:"Site Code",value:olobj.Site_Code__c !=undefined ? olobj.Site_Code__r.Name:'',class:"productbackground"+backgroundtotal}); 
                        rowobj.push({label:"Total",value:olobj.Opportunity.ia_crm__Intacct_Transaction__c == 'Salesforce - Refund'?'('+total+')':total,class:"productbackground"+backgroundtotal});
                        if(olobj.Opportunity.ia_crm__Intacct_Transaction__c == 'Salesforce - Refund'){
                            grandtotal -= olobj.TotalPrice;
                            totalgrandtotal -=  olobj.TotalPrice;
                        }else{
                            grandtotal += olobj.TotalPrice;
                            totalgrandtotal +=  olobj.TotalPrice;
                        } 
                        a++; 
                    }   
                    if(a != maxheaderheader){
                        var dummydata = maxheaderheader - a; 
                        for(var i=1;i <= dummydata;i++){   
                            rowobj.push({label:"Product ID",value:"",class:"productbackground"});
                            rowobj.push({label:"Class",value:"",class:"productbackground"});
                            rowobj.push({label:"Revenue Start Date",value:"",class:"productbackground"}); 
                            rowobj.push({label:"Template",value:"",class:"productbackground"});                            
                            rowobj.push({label:"Site Code",value:"",class:"productbackground"}); 
                            rowobj.push({label:"Total",value:"",class:"productbackground"});
                        }
                    }
                     
                    grandtotal = Number(Math.round(grandtotal+'e2')+'e-2');
                    grandtotal = grandtotal.toFixed(2);  
                   // rowobj.push({label:"GrandTotal",value:oppmap.Opportunity.ia_crm__Intacct_Transaction__c == 'Salesforce - Refund'?'('+grandtotal+')':grandtotal});
                   rowobj.push({label:"GrandTotal",value:grandtotal});
                    rowobjdata.push(rowobj); 
                    tableobj["rowdata"] = rowobjdata;
                    tableobj["oppid"] = oppid;
                    tableobj["isrowchecked"] = false;
                    tableobj["totalrowcount"] = rowobjdata.length; 
                    this.dailyAccountReportTableList.push(tableobj);
           }  
           this.tableheaderListData = [];
           //maxheaer mapping  
          this.tableheaderListData.push({label:"Transaction Type",value:"Transaction Type"});
          this.tableheaderListData.push({label:"Company",value:"Company"});
           this.tableheaderListData.push({label:"GARP ID",value:"GARP ID"});
           this.tableheaderListData.push( {label:"Account Name",value:"Account Name"});
           this.tableheaderListData.push({label:"Paid Date",value:"Paid Date"});
           this.tableheaderListData.push({label:"Payment Method",value:"Payment Method"});
           this.tableheaderListData.push({label:"Credit Card Type",value:"Credit Card Type"});
           this.tableheaderListData.push({label:"Batch ID",value:"Batch ID"});
           this.tableheaderListData.push({label:"Paypal Trans ID",value:"Paypal Trans ID"});           
           this.tableheaderListData.push({label:"Invoice #",value:"Invoice #"});
           this.tableheaderListData.push({label:"Billing Country",value:"Billing Country"});
           //this.tableheaderListData.push({label:"Billing State",value:"Billing State"});            
           this.tableheaderListData.push({label:"Shipping Country",value:"Shipping Country"});
           this.tableheaderListData.push({label:"Shipping State",value:"Shipping State"}); 
           //this.tableheaderListData.push({label:"Contact Name",value:"Contact Name"});
         
           
           var backgroundtotalhd = 0;
           for(var i=1;i <= maxheaderheader;i++){   
               if(backgroundtotalhd >= 3){
                   backgroundtotalhd = 0;
               }
               backgroundtotalhd ++;
               this.tableheaderListData.push({label:"Product ID",value:"Product ID"+i,class:"productbackground"+backgroundtotalhd});   
               this.tableheaderListData.push({label:"Class",value:"Class"+i,class:"productbackground"+backgroundtotalhd});
               this.tableheaderListData.push({label:"Revenue Start Date",value:"Revenue Start Date"+i,class:"productbackground"+backgroundtotalhd}); 
               this.tableheaderListData.push({label:"Template",value:"Template"+i,class:"productbackground"+backgroundtotalhd});               
               this.tableheaderListData.push({label:"Site Code",value:"Site Code"+i,class:"productbackground"+backgroundtotalhd}); 
               this.tableheaderListData.push({label:"Total",value:"Total"+i,class:"productbackground"+backgroundtotalhd});
           }
           if((totalgrandtotal < 0)){
            this.tableheaderListData.push({label:"Grand Total ("+Number(Math.round(totalgrandtotal+'e2')+'e-2')+")",value:"Grand Total",class:"grandtotalcolor"});
           }else{
            this.tableheaderListData.push({label:"Grand Total "+Number(Math.round(totalgrandtotal+'e2')+'e-2'),value:"Grand Total",class:"grandtotalcolor"});
           }
           
            
            if(this.dailyAccountReportTableList.length == 0){
                this.dailyAccountReportTableList = undefined;
            }             
            this.isLoaded = false;
            
        }catch(error){
            console.log('>>'+error);
            this.isLoaded = false;
        }
		})
		.catch(error => { 
			this.dailyAccountReportTableList = undefined;
            this.isLoaded = false;
		})
    }

    handleAllChange(event){
        if(this.dailyAccountReportTableList && this.dailyAccountReportTableList.length > 0){             
            this.dailyAccountReportTableList.forEach(function (e) {
                 e["isrowchecked"] =  event.target.checked;
            });
            this.selectedRowsCount = this.dailyAccountReportTableList.length;
        }
    }
  
    handleCheckBoxChange(event) {   
        this.dailyAccountReportTableList[event.currentTarget.dataset.index]["isrowchecked"] =  event.target.checked; 
        if(event.target.checked){
            this.selectedRowsCount += 1;
        }else{
            this.selectedRowsCount -= 1;
        }
    }

    approveSelectedItems(){ 
        let selectedopportunity = [];
        this.dailyAccountReportTableList.forEach(function (e) {
            if( e["isrowchecked"] == true){ 
                selectedopportunity.push(e.oppid);
            } 
       });

       if(selectedopportunity.length > 0){
            this.getinsertOrderTransactionItems(selectedopportunity);
       }else{
        const evt = new ShowToastEvent({
            title: 'error',
            message: 'Select atleast one Order Transaction..',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
       }
    }
 

    getinsertOrderTransactionItems(e){  
        this.isLoaded = true; 
        this.selectedRowsCount = 0;     
        insertOrderTransactionItems({opportunityIds:e})
		.then(result => { 
            if(result != 'Success'){ 
                const evt = new ShowToastEvent({
                    title: 'Error',
                    message: result,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
            }else{ 
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Created Successfully..',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.handlerefresh();
            }
            this.isLoaded = false;
        })
		.catch(error => {  
            console.log('Error >>'+JSON.stringify(error));
            this.isLoaded = false;
		})
    }
    handleintacctTransaction(e) {
        this.selectedintacctTransaction = e.detail.value; 
    }

    handlepaymentMethod(e) {
        this.selectedpaymentMethod = e.detail.value; 
    }

    handledownload(){
        if(this.dailyAccountReportTableList != undefined && this.dailyAccountReportTableList.length >= 0){ 
            this.isLoaded = true;
            const elementobj = this.template.querySelector('[data-id="overview"]');   
                var element = 'data:application/vnd.ms-excel,' + encodeURIComponent(elementobj.innerHTML);
                let downloadElement = document.createElement('a');
                downloadElement.href = element;
                downloadElement.target = '_self';
                // use .csv as extension on below line if you want to export data as csv
                downloadElement.download = 'Accounting Daily Report.xls';
                document.body.appendChild(downloadElement);
                downloadElement.click(); 
            this.isLoaded = false;
        }
    }

    changeToggle(event) { 
        if(event.target.name == 'Intacct Transaction'){ 
            if(event.target.checked == true){ 
                var tempobj = [];
                for(var i in this.intacctTransactionoptions){
                    tempobj.push(this.intacctTransactionoptions[i].value); 
                } 
                this.selectedintacctTransaction = tempobj;
            }else{ 
                this.selectedintacctTransaction = [];
            }
        }else if(event.target.name == 'Payment Method'){
            if(event.target.checked){
                var tempobj = [];
                for(var i in this.paymentMethodoptions){
                    tempobj.push(this.paymentMethodoptions[i].value); 
                } 
                this.selectedpaymentMethod = tempobj;
            }else{
                this.selectedpaymentMethod = [];
            }
        } 
    }
    
}