public class ExamRegistrationFormRemoter {
        
    @RemoteAction
    public static Response.Detail fetchExamRegistrationFormData(String registrationType, String teamRegistrationCode){
        
        try{

            switch on registrationType.toUpperCase() {
                when 'FRM' {
                    FrmRegistrationForm form = new FrmRegistrationForm();
                    return ExamRegistrationFormHelper.getExamRegistrationFormData(form, teamRegistrationCode);
                } 
                when 'ERP' {
                    ErpRegistrationForm form = new ErpRegistrationForm();
                    return ExamRegistrationFormHelper.getExamRegistrationFormData(form, null);
                }
                when 'SCR' {
                    ScrExamRegistrationForm form = new ScrExamRegistrationForm();
                    return ExamRegistrationFormHelper.getExamRegistrationFormData(form, teamRegistrationCode);
                }
                when else {
                    throw new Response.ResponseException(
                        'Invalid registration type ' + registrationType + '.', 400,
                        new List<String>{'Invalid registration type ' + registrationType + '.'}
                    );
                }
            }
                
        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 
        
    }
    
    @RemoteAction
    public static Response.Detail createExamRegistrationOrder(String registrationType, String jsonString){

        ExamRegistrationForm form = null;

        //system.assert(false, 'BOOM!'+ jsonString);
        
        try{

            ExamRegistrationForm.RegistrationRequest registrationRequest = (ExamRegistrationForm.RegistrationRequest)JSON.deserialize(jsonString, ExamRegistrationForm.RegistrationRequest.class);

            switch on registrationType.toUpperCase() {
                when 'FRM' {
                    form = new FrmRegistrationForm();
                    return ExamRegistrationFormHelper.createExamRegistrationOrder((FrmRegistrationForm)form, registrationRequest);
                } 
                when 'ERP' {
                    form = new ErpRegistrationForm();
                    return ExamRegistrationFormHelper.createExamRegistrationOrder((ErpRegistrationForm)form, registrationRequest);
                }
                when 'SCR' {
                    form = new ScrExamRegistrationForm();
                    return ExamRegistrationFormHelper.createExamRegistrationOrder((ScrExamRegistrationForm)form, registrationRequest);
                }
                when else {
                    throw new Response.ResponseException(
                        'Invalid registration type ' + registrationType + '.', 400,
                        new List<String>{'Invalid registration type ' + registrationType + '.'}
                    );
                }
            }
                
        }catch(Response.ResponseException e){

            if(form != null && form.savepoint != null){
                Database.rollback(form.savepoint);
            }

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            System.debug('Exception:' + e.getMessage()+':'+e.getLineNumber()+':'+e.getStackTraceString());
            
            if(form != null && form.savepoint != null){
                Database.rollback(form.savepoint);
            }

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 

    }

    @RemoteAction
    public static Response.Detail payExamRegistrationOrder(String registrationType, String jsonString){

        ExamRegistrationForm form = null;

        try{

            ExamRegistrationForm.ChargeRequest chargeRequest = (ExamRegistrationForm.ChargeRequest)JSON.deserialize(jsonString, ExamRegistrationForm.ChargeRequest.class);

            switch on registrationType.toUpperCase() {
                when 'FRM' {
                    form = new FrmRegistrationForm();
                    return ExamRegistrationFormHelper.payExamRegistrationOrder((FrmRegistrationForm)form, chargeRequest);  
                }
                when 'ERP'{
                    form = new ErpRegistrationForm();
                    return ExamRegistrationFormHelper.payExamRegistrationOrder((ErpRegistrationForm)form, chargeRequest);  
                }
                when 'SCR'{
                    form = new ScrExamRegistrationForm();
                    return ExamRegistrationFormHelper.payExamRegistrationOrder((ScrExamRegistrationForm)form, chargeRequest);  
                }
                when else {
                    throw new Response.ResponseException(
                        'Invalid registration type ' + registrationType + '.', 400,
                        new List<String>{'Invalid registration type ' + registrationType + '.'}
                    );
                }
            }
                
        }catch(Response.ResponseException e){
            
            if(form != null && form.savepoint != null){
                Database.rollback(form.savepoint);
            }

            if(form != null && !form.disableManualRollback){
                form.manualRollback();
            }

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){
            
            if(form != null && form.savepoint != null){
                Database.rollback(form.savepoint);
            }

            if(form != null && !form.disableManualRollback){
                form.manualRollback();
            }

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(), e.getLineNumber(), e.getStackTraceString()});

        }

    }

    @RemoteAction
    public static Response.Detail fetchExamRegistrationInfoData(String registrationType, String contactId){

        try{

            switch on registrationType.toUpperCase() {
                when 'FRM' {
                    FrmRegistrationForm form = new FrmRegistrationForm();
                    return ExamRegistrationFormHelper.fetchExamRegistrationInfoData(form, contactId);
                } 
                when 'ERP' {
                    ErpRegistrationForm form = new ErpRegistrationForm();
                    return ExamRegistrationFormHelper.fetchExamRegistrationInfoData(form, contactId);
                }
                when 'SCR' {
                    ScrExamRegistrationForm form = new ScrExamRegistrationForm();
                    return ExamRegistrationFormHelper.fetchExamRegistrationInfoData(form, contactId);
                }
                when 'FBR', 'ICBRR', 'INDIVIDUAL' {
                    return ExamRegistrationFormHelper.fetchExamRegistrationInfoData(registrationType, contactId);
                }
                when else {
                    throw new Response.ResponseException(
                        'Invalid registration type ' + registrationType + '.', 400,
                        new List<String>{'Invalid registration type ' + registrationType + '.'}
                    );
                }
            }
                
        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 

    }  

    @RemoteAction
    public static Response.Detail updateExamRegistrationInfoData(String registrationType, String jsonString){

        try{

            Contact contact = (Contact)JSON.deserialize(jsonString, Contact.class);

            switch on registrationType.toUpperCase() {
                when 'FRM' {
                    FrmRegistrationForm form = new FrmRegistrationForm();
                    return ExamRegistrationFormHelper.updateExamRegistrationInfoData(form, contact);
                } 
                when 'ERP' {
                    ErpRegistrationForm form = new ErpRegistrationForm();
                    return ExamRegistrationFormHelper.updateExamRegistrationInfoData(form, contact);
                }
                when 'SCR' {
                    ScrExamRegistrationForm form = new ScrExamRegistrationForm();
                    return ExamRegistrationFormHelper.updateExamRegistrationInfoData(form, contact);
                }
                when else {
                    throw new Response.ResponseException(
                        'Invalid registration type ' + registrationType + '.', 400,
                        new List<String>{'Invalid registration type ' + registrationType + '.'}
                    );
                }
            }
                
        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 

    }

    @RemoteAction
    public static Response.Detail fetchExamRegistrationCompletedData(String registrationType){

        try{

            switch on registrationType.toUpperCase() {
                when 'FRM' {
                    FrmRegistrationForm form = new FrmRegistrationForm();
                    return ExamRegistrationFormHelper.fetchExamRegistrationCompletedData(form);
                } 
                when 'ERP' {
                    ErpRegistrationForm form = new ErpRegistrationForm();
                    return ExamRegistrationFormHelper.fetchExamRegistrationCompletedData(form);
                }
                when 'SCR' {
                    ScrExamRegistrationForm form = new ScrExamRegistrationForm();
                    return ExamRegistrationFormHelper.fetchExamRegistrationCompletedData(form);
                }
                when else {
                    throw new Response.ResponseException(
                        'Invalid registration type ' + registrationType + '.', 400,
                        new List<String>{'Invalid registration type ' + registrationType + '.'}
                    );
                }
            }
                
        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 

    }  

    public ExamRegistrationFormRemoter(sfdcAppRemoter controller){}
    
}