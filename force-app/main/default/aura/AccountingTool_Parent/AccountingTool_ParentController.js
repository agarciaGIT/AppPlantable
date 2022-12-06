({
    onOptionSelect: function (cmp, evt, helper) {
        //AccountingTool_Parent
        var selectedValue = cmp.find('ActionSelect').get('v.value');
        cmp.set('v.selectedValue',selectedValue);
        cmp.set("v.optionSelected",selectedValue);
    },
    
    OnclickOfNextButton: function (cmp, evt, helper) { 
        var invoiceNumber = cmp.find('invoice').get('v.value');
        console.log('invoiceNumber::>>   '+invoiceNumber);
        if(invoiceNumber == null || invoiceNumber=='') { 
            cmp.set("v.ErrorMessage","Please Enter Invoice Number");
            cmp.set("v.navigateNext",false);
        } else {
            cmp.set("v.ErrorMessage","");
            cmp.set("v.InvoiceNumber",invoiceNumber);
            cmp.set("v.navigateNext",true);
        }
    }
    
})