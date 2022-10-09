({
	onOptionSelect: function (cmp, evt, helper) {
        //alert(cmp.find('ActionSelect').get('v.value'));
        var selectedValue = cmp.find('ActionSelect').get('v.value');
         
        cmp.set('v.selectedValue',selectedValue);
        cmp.set("v.optionSelected",selectedValue);
        if(selectedValue == 'Defer/Undefer' || selectedValue == 'ExamSiteChange' || selectedValue == 'Technical Glitch' || selectedValue == 'Pearson Merge Request'
          || selectedValue == 'Free Invoice'){
        	cmp.set("v.showInput",true);
            cmp.set("v.selectedComponent",selectedValue)
        } else if(selectedValue == 'Switch Exam' || selectedValue =='Create Switch Exam Fee' || selectedValue == 'Update Opportunity Billing Info' ||
                  selectedValue == 'Update Opportunity Price' || selectedValue =='Scholarship refund' || selectedValue == 'Ups Edit'
                  )
        {
            console.log('Set selectedComponent ');
            
            cmp.set("v.selectedComponent","NavigateUrl");
            cmp.set("v.showInput",false);
            } else {
            cmp.set("v.showInput",false);
        }
    },
    
    OnclickfreeInvoiceNextButton: function (cmp, evt, helper) { 
        var invoiceNumber;
         invoiceNumber = cmp.find('invoice').get('v.value');
        console.log('invoiceNumber======>'+invoiceNumber);
        if(invoiceNumber == null || invoiceNumber=='') { 
                cmp.set("v.ErrorMessage","Please Enter Invoice Number");  
            } else {
                console.log('Entered Invoice number');
                cmp.set("v.ErrorMessage","");
                cmp.set("v.InvoiceNumber",invoiceNumber);
                cmp.set("v.navigateNext",true);
            }
    },
    
    OnclickNextButton: function (cmp, evt, helper) {
        //alert(cmp.find('garpID').get('v.value'));
        var garpId;
        var invoiceNumber;
        console.log('v.selectedComponent========>'+cmp.get('v.selectedComponent'));
        cmp.set("v.showInput",false);
        if(cmp.get('v.selectedComponent') == "NavigateUrl") {
            invoiceNumber = cmp.find('invoice').get('v.value');
            if(invoiceNumber == null || invoiceNumber=='') { 
                cmp.set("v.ErrorMessage","Please Enter Invoice Number");  
            } else {
                console.log('Entered Invoice number');
                cmp.set("v.ErrorMessage","");
                cmp.set("v.InvoiceNumber",invoiceNumber);
                helper.getNavigateionUrl(cmp, evt);
            }
        } else {
            garpId = cmp.find('garpID').get('v.value');
            cmp.set("v.GARPId",garpId);
            cmp.set("v.navigateNext",true);
        }
    }
    
})