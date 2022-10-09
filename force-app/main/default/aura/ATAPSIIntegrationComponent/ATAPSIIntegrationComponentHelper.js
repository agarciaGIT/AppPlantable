({ 
    setPSIParserTableColumns:function(component){
        component.set('v.ATAPSIcolumns', [
            {label: 'Name', fieldName: 'Name', type: 'text',initialWith:80},
            {label: 'Address', fieldName: 'Address', type: 'text',initialWith:80},
            {label: 'Candidate Id', fieldName: 'candidate_id', type: 'text',initialWith:80},
            {label: 'Email', fieldName: 'email', type: 'text',initialWith:80},
            {label: 'Eligibility End Date', fieldName: 'eligibility_end_date', type: 'text',initialWith:80}, 
            {label: 'Eligible to Schedule', fieldName: 'eligible_to_schedule', type: 'text',initialWith:80},
            {label: 'Eligibility Status Message', fieldName: 'eligibility_status_message', type: 'text',initialWith:80}, 
            {label: 'Test Code', fieldName: 'test_code', type: 'text',initialWith:80},
            {label: 'psi_eligiblity_id', fieldName: 'psi_eligiblity_id', type: 'text',initialWith:80}, 
            {label: 'created_datetime', fieldName: 'created_datetime', type: 'text',initialWith:80}, 
            {label: 'client_eligibility_id', fieldName: 'client_eligibility_id', type: 'text',initialWith:80}, 
            {label: 'status', fieldName: 'status', type: 'text',initialWith:80}
        ]); 
    },seATAtParserTableColumns:function(component){
        component.set('v.ATAPSIcolumns', [
            {label: 'batch_name', fieldName: 'batch_name', type: 'text'},
            {label: 'cert_id', fieldName: 'cert_id', type: 'text'},
            {label: 'cert_type', fieldName: 'cert_type', type: 'text'},            
            {label: 'Extend', fieldName: 'extend', type: 'text',wrapText: true},
            {label: 'Name', fieldName: 'name', type: 'text'},
            {label: 'pay_status', fieldName: 'pay_status', type: 'text'}, 
            {label: 'reg_code', fieldName: 'reg_code', type: 'text'}, 
            {label: 'status', fieldName: 'status', type: 'text'},
            {label: 'room_address', fieldName: 'room_address', type: 'text'}, 
            {label: 'room_name', fieldName: 'room_name', type: 'text'},
            {label: 'start_time', fieldName: 'start_time', type: 'text'},
            {label: 'end_time', fieldName: 'end_time', type: 'text'}
        ]); 
    },
    getAtaIntegrationData : function(component) {
        var action=component.get('c.ATAQueryExamRegistation');  
        action.setParams({ 
            'exaAttmt' : component.get("v.selectedExamReg"),
            'SelIntegrationType':component.get("v.selectedIntegrationType")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                if(result == null){
                    component.set("v.ErrorMessage","No Records Found");
                    return;
                }
                
                for(var i=0;i<result.length;i++){
                    var row = result[i]; 
                    var extendres; 
                    if(row.extend){  
                        extendres = 'c_name:'+row.extend.c_name +', email:'+row.extend.email+' , id_number:'+row.extend.id_number +' , id_type:'+row.extend.id_type
                          row.extend = extendres;
                    }
                }
                //console.log(JSON.stringify(result));
                component.set("v.ATAPSIParserList",result); 
                component.set("v.selectedExamres",JSON.stringify(result));
                
            } 
        });
        $A.enqueueAction(action); 
    },getPsiIntegrationData : function(component) {
        var action=component.get('c.getPSIeligiblitiesCandidateId'); 
        action.setParams({ 
            'exaAttmt' : component.get("v.selectedExamReg")
        }); 
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var result = response.getReturnValue(); 
                if(result == null){
                    component.set("v.ErrorMessage","No Records Found");
                    return;
                }
                for(var i=0;i<result.length;i++){
                    var row = result[i]; 
                    if(row.candidate){ 
                        if(row.candidate.first_name != null)  row.Name = row.candidate.first_name;
                        if(row.candidate.first_name != null)  row.Name += " "+row.candidate.last_name;
                        if(row.candidate.address1 != null)  row.Address = row.candidate.address1;
                        if(row.candidate.city != null)  row.Address += " "+row.candidate.city;
                        if(row.candidate.province_state != null)  row.Address = row.candidate.province_state;
                        if(row.candidate.country != null)  row.Address = row.candidate.country;
                        if(row.candidate.postal_code != null)  row.Address += " "+row.candidate.postal_code; 
                        if(row.candidate.candidate_id != null)  row.candidate_id = row.candidate.candidate_id;
                        if(row.candidate.email != null)  row.email = row.candidate.email;
                    }
                }
                
                component.set("v.ATAPSIParserList",result);
                // alert(JSON.stringify(result));
                component.set("v.selectedExamres",JSON.stringify(result));
                
            } 
        });
        $A.enqueueAction(action); 
    }
})