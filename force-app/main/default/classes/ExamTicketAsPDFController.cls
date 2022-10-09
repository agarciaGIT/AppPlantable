/*  Controller for examTicketAsPDF page, which generates admission ticket for member services
*  05/29/2019 Xiang - [US-22015] Adding Address, Room and Date overrides for approved RAD/ADA
*/
global without sharing class ExamTicketAsPDFController{
    
    private static final String SHORT_TIME_FORMAT = 'EEEE, MMMM d, yyyy';
    
    private static final String SYS_DATE_FORMAT = 'MM/dd/yyyy h:mm a';
    private static final String FRM_PART_ONE = 'FRM Part 1';
    private static final String FRM_PART_TWO = 'FRM Part 2';
    private static final String siteid = System.Label.ExamSiteIdNewYorkTickets;
    
    private static final String ERP_PART_ONE = 'ERP Exam Part I';
    private static final String ERP_PART_TWO = 'ERP Exam Part II';
    
    private static final String CHINA = 'China';
    private static final String HONG_KONG = 'Hong Kong';
    private static final String ISRAEL = 'Israel';
    
    global eaWrapper eaObj {get;set;}
    global ContactWrapper Contact { get; set; }
    global RoomWrapper Room { get; set; }
    global VenueWrapper Venue { get; set; }
    global String ExamName { get; set; }
    
    global Id eaId {get;set;} 
    global String status {get;set;} 
    
    private boolean address1Consumed = false;
    private boolean address2Consumed = false;
    
    global ExamTicketAsPDFController() {
        status = 'Unpaid';
    }
    
    global String getNow() {
        return System.now().format(SYS_DATE_FORMAT);
    }
    
    global void fetchData() {
        //Get opportunity data
        eaId = ApexPages.currentPage().getParameters().get('id');     
        fetchDataForExamAttempt(eaId);
    }
    
    global void fetchDataForExamAttempt(Id examAttemptId) {
        
        system.debug('examAttemptId========>'+examAttemptId);
        eaObj = new eaWrapper([
            SELECT Id, Name, Room__r.id, Seat_No__c, Member__c, Session__c, Exam_Site__c, Site_Code__c, Display_Candidate_ID__c, Seating_Section__c, AssignSeat__c, ADA_Status__c, RAD_Status__c, Session_Time__c, Reporting_Time__c, Sunday_Exam__c, exam_Date__C, Cancelled__c, Reg_Status__c, Opportunity__r.stageName, RAD_ADA_Address__c, RAD_ADA_Room__c, RAD_ADA_Date__c
            FROM Exam_Attempt__c
            WHERE 
            Id = :examAttemptId AND 
            Cancelled__c != TRUE AND 
            Opportunity__r.StageName = 'Closed' AND 
            Exam_Site__r.Exam__r.Exam_Group__r.Loading_Exam_Results__c = FALSE AND
            (Reg_Status__c != 'Cancelled' or Reg_Status__c != 'Deferred Out Pending')
        ]);                       
        
        Contact = new ContactWrapper([Select FirstName, LastName, Middle_Initial__c, Name_As_it_Appears_On_ID__c, GARP_Member_ID__c, RPT_GARP_ID_for_Exam_Ticket__c from Contact where Id= :eaObj.ContactId ]);

        system.debug('eaObj.room==:'+eaObj.room);
        
        if(eaObj.room==null && (eaObj.ADAStatus=='Approved'||eaObj.RADStatus=='Approved')&& eaObj.radAdaAddress!=null &&eaObj.radAdaRoom!=null){
            Room = new RoomWrapper([Select Name, Venue__r.Id from Room__c limit 1]); 
        }
        
        if(eaObj.room!=null){
            Room = new RoomWrapper([Select Name, Venue__r.Id from Room__c where Id = :eaObj.room]); 
        }
        
        Venue = new VenueWrapper([Select Institution_Name__c, Building_Name__c, Address1__c, Address2__c, City__c, State__c, Country__c, Zipcode__c, Venue_Code__c from Venue__c where Id= :Room.VenueId ]);
        
        ExamName = getExamName();
    }
    
    public String getAddress1() {
        if (String.isNotBlank(Venue.InstitutionName)) {
            return Venue.InstitutionName;
        }
        
        if (String.isNotBlank(Venue.BuildingName)) {
            return Venue.BuildingName;
        }
        address1Consumed = true;
        return Venue.Address1;
    }
        
    public String getAddress2() {
        if (String.isNotBlank(Venue.InstitutionName) && String.isNotBlank(Venue.BuildingName)) {
            return Venue.BuildingName;
        }
        //If only ONE of building name and institution name is present, it has already been consumed in address line1
        if (String.isBlank(Venue.InstitutionName) && String.isNotBlank(Venue.BuildingName)) {
            address1Consumed = true;
            return Venue.Address1;
        }
        if (String.isNotBlank(Venue.InstitutionName) && String.isBlank(Venue.BuildingName)) {
            address1Consumed = true;
            return Venue.Address1;
        }
        //End if 
        if (address1Consumed) {
            address2Consumed = true;
            return Venue.Address2;
        }
        return '';
    }
    
    public String getAddress3() {
        if (address2Consumed) { 
            return '';
        }
        
        if (!address1Consumed) { 
            address1Consumed = true;
            return Venue.Address1;
        }        
        
        if (address1Consumed && String.isNotBlank(Venue.Address2)) { 
            address2Consumed = true;
            return Venue.Address2;
        }
        
        return '';
    }
    
    public String getAddress4() {
        if (address2Consumed) { 
            return '';
        }
        
        if (String.isNotBlank(Venue.Address2)) {
            return Venue.Address2;
        }
        else return '';
    }
    
    public String getMorningExamTime() {
        
        if (IsHongKong()) {
            return '8:30am-12:30pm';
        }
        else return '8:00am-12:00pm';
    }
    
    public String getAfternoonExamTime() {
        
        if (IsHongKong()) {
            return '2:30pm-6:30pm';
        }
        else return '2:00pm-6:00pm';
    }
    
    global String getCandidateName() {
        if (!String.isBlank(Contact.NameOnId)) {
            return Contact.NameOnId;   
        }
        
        if (!String.isBlank(Contact.MiddleInitial)) {
            return Contact.FirstName + ' ' + Contact.MiddleInitial + ' ' + Contact.LastName;     
        }
        else {
            return Contact.FirstName + ' ' + Contact.LastName; 
        }
        
    }
    
    public Boolean getIsADA() {
        if (String.IsNotBlank(eaObj.ADAStatus) && eaObj.ADAStatus.equals('Approved')) {
            return true;
        } 
        else return false;
    }
    
    public Boolean getIsRAD() {
        if (String.IsNotBlank(eaObj.RADStatus) && eaObj.RADStatus.equals('Approved')) {
            return true;
        } 
        else return false;
    }
    
    public Boolean getUseRadAdaAddres() {
        if((getIsRAD() || getIsADA()) && String.isNotEmpty(eaObj.radAdaAddress)) {
            return true;
        }else {
            return false;
        }
    }
    
    global String getExamTime() {
        
        /* if (getIsADA() || getIsRAD()) {
            return eaObj.SessionTime;
        }*/
         if (String.isNotBlank(eaObj.SessionTime)) {
            return eaObj.SessionTime;
        }
        
        if ((ExamName.equals(FRM_PART_ONE) || ExamName.equals(ERP_PART_ONE)) && IsHongKong()) {
            return '8:30am-12:30pm';
        }
        else if ((ExamName.equals(FRM_PART_ONE) || ExamName.equals(ERP_PART_ONE)) && !IsHongKong()) {
            return '8:00am-12:00pm';
        }
        else if ((ExamName.equals(FRM_PART_TWO) || ExamName.equals(ERP_PART_TWO)) && IsHongKong()) {
            return '2:30pm-6:30pm';
        }
        else if ((ExamName.equals(FRM_PART_TWO) || ExamName.equals(ERP_PART_TWO)) && !IsHongKong()) {
            return '2:00pm-6:00pm';
        } 
        else return '';
        
    }

    public String getExamSiteRoom() {
        if((getIsADA() || getIsRAD()) && String.isNotEmpty(eaObj.radAdaRoom)) {
            return eaObj.radAdaRoom;
        }
        
        if (String.isBlank(eaObj.SeatingSection)) {
            return Room.Name;
        }
        else {
            return Room.Name + '/' + eaObj.SeatingSection; 
        }
    }
    
    public String getExamSiteRoomLabel() {
        if (String.isBlank(eaObj.SeatingSection)) {
            return 'Exam Site Room';
        }
        else {
            return 'Exam Room/Section';
        }
    }
       
    public String getExamDateString() {
        if((getIsRAD() || getIsADA()) && String.isNotEmpty(eaObj.radAdaDate)) {
            return eaObj.radAdaDate;
        }
        
        if (getIsRAD()) {
            return eaobj.sundayExamDay;
        }
        //ADA Candidate: We can explicitly specify Sunday Exam
        if (getIsADA() && eaObj.SundayExam) {
            return eaobj.sundayExamDay;
        }
        if (Venue.Country.equals('Israel')) {
            return eaobj.sundayExamDay;
        }
        else {
            return eaobj.examDate;
        }
        
    } 
    
    // Added this method to get exam year from exam date which is used in notes on VF page. Year was hard coded previously  
    public integer getExamYear() {
        
        return eaobj.examYear;
    } 
      
    private Boolean isHongKong() {
        if (String.IsNotBlank(Venue.State) && Venue.State.equals(HONG_KONG)) {
            return true;
        }else {
            return false;
        }
    }
    
    public String getDoorClosingTimes() {
        
        //Person with Disabilities or Religious Exemption: Has a customized reporting time
        if (getIsADA() || getIsRAD()) {
            return eaObj.ReportingTime;
        }
        if ( String.isNotBlank(eaObj.SessionTime) && eaObj.ExamSiteId == siteid) {
            return '7:45am';
        } 
        if ((ExamName.equals(FRM_PART_ONE) || ExamName.equals(ERP_PART_ONE)) && !IsHongKong()) {
            return '7:45am';
        }else if ((ExamName.equals(FRM_PART_ONE) || ExamName.equals(ERP_PART_ONE)) && IsHongKong()) {
            return '8:15am';
        }else if ((ExamName.equals(FRM_PART_TWO) || ExamName.equals(ERP_PART_TWO)) && !IsHongKong()) {
            return '1:45pm';
        }else if ((ExamName.equals(FRM_PART_TWO) || ExamName.equals(ERP_PART_TWO)) && IsHongKong()) {
            return '2:15pm';
        }
        else{
            return '';
        }
    }
    
    private String getExamName() {
        Id sid = eaObj.ExamSiteId;
        system.debug('sid is ' + sid);
        String name = [Select Site__r.Site_Code__c,Exam__r.Exam__c from Exam_Sites__c where Id = :sid LIMIT 1].Exam__r.Exam__c;
        system.debug('exam name is ' + name);
        return name;
        
    }
    
    global class eaWrapper {
        global String id {get; set;}
        global String room {get; set;}
        global String seat {get;set;}
        global Id ContactId { get; set; }
        global String Session { get; set; }
        global Id ExamSiteId { get; set; }
        global String CandidateId { get; set; } 
        global String SeatingSection { get; set; }
        global String ADAStatus { get; set; }
        global String RADStatus { get; set; }
        global String SessionTime { get; set; }
        global String ReportingTime { get; set; }
        global Boolean SundayExam { get; set; }
        global String Code { get; set; }
        
        global date examDateforYear {get;set;}
        global String examDate { get; set; }
        global integer examYear {get;set;}
        global date sundayExamDate {get;set;}
        global String SundayexamDay { get; set; }
        
        global String radAdaAddress {get; private set;}
        global String radAdaRoom {get; private set;}
        global String radAdaDate {get; private set;}
        
        global eaWrapper(Exam_Attempt__c ea) {
            id = ea.id;
            room = ea.Room__r.id;  
            seat = ea.AssignSeat__c;
            ContactId = ea.Member__c;
            Session = ea.Session__c;
            ExamSiteId = ea.Exam_Site__c;
            CandidateId = ea.Display_Candidate_ID__c;
            SeatingSection = ea.Seating_Section__c;
            ADAStatus = ea.ADA_Status__c;
            RADStatus = ea.RAD_Status__c;
            SessionTime = ea.Session_Time__c;
            ReportingTime = ea.Reporting_Time__c;
            SundayExam = ea.Sunday_Exam__c;
            Code = ea.Site_Code__c;
            radAdaAddress = ea.RAD_ADA_Address__c;
            radAdaRoom = ea.RAD_ADA_Room__c;
            radAdaDate = ea.RAD_ADA_Date__c;
            
            // Added below exam dates which are used in methods above
            examDateforyear = ea.exam_date__C;
            examDate = datetime.newInstance(ea.exam_Date__C.year(), ea.exam_Date__C.month(), ea.exam_Date__C.day()).format(SHORT_TIME_FORMAT);
            examYear = examDateforYear.year();
            sundayExamDate = ea.exam_date__C + 1;
            sundayExamDay = datetime.newInstance(sundayExamDate.year(), sundayExamDate.month(), sundayExamDate.day()).format(SHORT_TIME_FORMAT);
        }
    }
    
    global class ContactWrapper {
        
        global String FirstName {get; set;}
        global String LastName {get; set;}
        global String MiddleInitial {get; set;}
        global String NameOnId { get; set; }
        global String GarpId {get; set;}
        
        global ContactWrapper(Contact c) {
            FirstName = c.FirstName;
            LastName = c.LastName;
            MiddleInitial = c.Middle_Initial__c;
            NameOnId = c.Name_As_it_Appears_On_ID__c;
            GarpId = c.RPT_GARP_ID_for_Exam_Ticket__c;
        }
        
    }
    
    global class RoomWrapper {
        global String Name {get; set;}
        global String VenueId {get; set;}
        
        global RoomWrapper(Room__c r) {
            if(r !=null){
                Name = r.Name;
                VenueId = r.Venue__c; 
            } 
        }
    }
    
    global class VenueWrapper {
        global String BuildingName { get; set; }
        global String Address1 {get; set;}
        global String Address2 {get; set;}
        global String City { get; set; }
        global String State { get; set; }
        global String Country { get; set; }
        global String Zipcode { get; set; }
        global String Code { get; set; }
        global String InstitutionName { get; set; } 
        
        global VenueWrapper(Venue__c v) {
            if(v !=null){
                Address1 = v.Address1__c;
                Address2 = v.Address2__c;
                City = v.City__c;
                State = v.State__c;
                Country = v.Country__c;
                Zipcode = v.Zipcode__c;
                Code = v.Venue_Code__c;
                BuildingName = v.Building_Name__c;
                InstitutionName = v.Institution_Name__c;
            }
        }
    }    
    
}