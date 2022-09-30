public class Plant_Cases_SC {

    public class respCasesCommentItem {
        public String body;
        public DateTime created_date;
        public String created_by;
    }

    public class respCasesEmailItem {
     	public String subject;
        public String body;
        public DateTime created_date;
        public String fromAddress;
        public String toAddress;
    }
    
    public class respCases {
        public Integer status_code;
        public String status_message;
        public String case_number;
        public String customer_id;
		public String customer_email;
		public String subject;
		public String body;
		public String case_status;
		public DateTime last_contact_date;
        public DateTime open_date;
        public DateTime last_modified_date;
        public List<respCasesCommentItem> comments;
        public List<respCasesEmailItem> emails;
    }
    
	public class reqCases {
        public String authenticationToken;
     	public String subject;
        public String body;
        public String email_address;
    }    
    
    public class respAddCases {
        public Integer status_code;
        public String status_message;
        public String case_number;
    }
    
    public class reqUpdateCases {
        public String authenticationToken;
        public String case_number;
     	public String case_status;
        public respCasesCommentItem comment;
        public respCasesEmailItem email;
    }    

    public class respUpdateCases {
        public Integer status_code;
        public String status_message;
    }

    public static Plant_Utility.responseWrapper processPOSTRequest(Plant_Cases_SC.reqCases reqCase) {
        return Plant_Cases_BC.processPOSTRequest(reqCase);
    }

 
    public static Plant_Utility.responseWrapper processGETRequest(String existingCustomerId, String param_CaseId) {
        return Plant_Cases_BC.processGETRequest(existingCustomerId, param_CaseId);
    }

    public static Plant_Utility.responseWrapper processPUTRequest(Plant_Cases_SC.reqUpdateCases reqCase, String existingCustomerId) {
        return Plant_Cases_BC.processPUTRequest(reqCase, existingCustomerId);
    }
}