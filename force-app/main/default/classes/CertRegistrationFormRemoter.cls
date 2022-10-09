public class CertRegistrationFormRemoter {

    @RemoteAction
    public static Response.Detail fetchCertRegistrationFormData(String registrationType){
        try{

            if(registrationType.toUpperCase() == 'SCR'){
                ScrRegistrationForm form = new ScrRegistrationForm();
                return form.getCertRegistrationFormData();
            }
                
            throw new Response.ResponseException(
                'Invalid registration type ' + registrationType + '.', 400,
                new List<String>{'Invalid registration type ' + registrationType + '.'}
            );

        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 
    }

    @RemoteAction
    public static Response.Detail fetchCertRegistrationInfoFormData(String registrationType, String contactId){
        try{

            if(registrationType.toUpperCase() == 'SCR'){
                ScrRegistrationForm form = new ScrRegistrationForm();
                return form.getCertRegistrationInfoFormData(contactId);
            }
                
            throw new Response.ResponseException(
                'Invalid registration type ' + registrationType + '.', 400,
                new List<String>{'Invalid registration type ' + registrationType + '.'}
            );

        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 
    }

    @RemoteAction
    public static Response.Detail fetchCertRegistrationCompletedFormData(String registrationType){
            
        try{

            if(registrationType.toUpperCase() == 'SCR'){
                ScrRegistrationForm form = new ScrRegistrationForm();
                return form.getCertRegistrationCompletedFormData();
            }
                
            throw new Response.ResponseException(
                'Invalid registration type ' + registrationType + '.', 400,
                new List<String>{'Invalid registration type ' + registrationType + '.'}
            );

        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 
    }

    @RemoteAction
    public static Response.Detail createCertRegistrationOrder(String registrationType, String jsonString){

        CertRegistrationForm form;

        try{

            CertRegistrationForm.RegistrationRequest registrationRequest = (CertRegistrationForm.RegistrationRequest)JSON.deserialize(jsonString, CertRegistrationForm.RegistrationRequest.class);

            if(registrationType.toUpperCase() == 'SCR'){
                form = new ScrRegistrationForm();
                return ((ScrRegistrationForm)form).createCertRegistrationOrder(registrationRequest);
            }
                
            throw new Response.ResponseException(
                'Invalid registration type ' + registrationType + '.', 400,
                new List<String>{'Invalid registration type ' + registrationType + '.'}
            );

        }catch(Response.ResponseException e){

            if(form != null && form.savepoint != null) Database.rollback(form.savepoint);

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            if(form != null && form.savepoint != null) Database.rollback(form.savepoint);

            String errorMessage = e.getMessage();

            if(errorMessage.contains('FIELD_CUSTOM_VALIDATION_EXCEPTION')){
                return new Response.Detail(null, 400, new List<Object>{
                    errorMessage.substring(
                        errorMessage.indexOf('FIELD_CUSTOM_VALIDATION_EXCEPTION: ') + 'FIELD_CUSTOM_VALIDATION_EXCEPTION: '.length(), 
                        errorMessage.indexOf('You can look up ExceptionCode values in the SOAP API Developer Guide.'))
                });
            }else{
                return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});
            }

        } 
    }

    @RemoteAction
    public static Response.Detail payCertRegistrationOrder(String registrationType, String jsonString){

        CertRegistrationForm form;

        try{

            CertRegistrationForm.ChargeRequest chargeRequest = (CertRegistrationForm.ChargeRequest)JSON.deserialize(jsonString, CertRegistrationForm.ChargeRequest.class);

            if(registrationType.toUpperCase() == 'SCR'){
                form = new ScrRegistrationForm();
                return ((ScrRegistrationForm)form).payCertRegistrationOrder(chargeRequest);
            }
                
            throw new Response.ResponseException(
                'Invalid registration type ' + registrationType + '.', 400,
                new List<String>{'Invalid registration type ' + registrationType + '.'}
            );

        }catch(Response.ResponseException e){
            
            if(form != null && form.savepoint != null) Database.rollback(form.savepoint);

            if(form != null && !form.disableManualRollback){
                form.manualRollback();
            }

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){
            
            if(form != null && form.savepoint != null) Database.rollback(form.savepoint);

            if(form != null && !form.disableManualRollback){
                form.manualRollback();
            }

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        }
    }

    @RemoteAction
    public static Response.Detail updateCertRegistrationInfo(String registrationType, String jsonString){
        try{

            Contact contact = (Contact)JSON.deserialize(jsonString, Contact.class);

            if(registrationType.toUpperCase() == 'SCR'){
                ScrRegistrationForm form = new ScrRegistrationForm();
                return form.updateCertRegistrationInfo(contact);
            }
                
            throw new Response.ResponseException(
                'Invalid registration type ' + registrationType + '.', 400,
                new List<String>{'Invalid registration type ' + registrationType + '.'}
            );

        }catch(Response.ResponseException e){

            return new Response.Detail(e.getMessage(), e.status, e.errors);

        }catch(Exception e){

            return new Response.Detail(null, 400, new List<Object>{e.getMessage(),e.getLineNumber(),e.getStackTraceString()});

        } 
    }

    public CertRegistrationFormRemoter(sfdcAppRemoter ctrl) {}

}