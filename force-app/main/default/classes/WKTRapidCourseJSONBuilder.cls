public class WKTRapidCourseJSONBuilder {
	public static User updateUser( user currentUser,integer newCourseId){
        String finalRapidCourseVal;
        WKT_Settings__mdt wkt = WKT_Settings__mdt.getInstance('automation_script_id');
        integer automationId = Integer.valueOf(wkt.Value__c);
        if(string.isNotBlank(currentUser.Rapid_Courses__c)){
            List<Integer> coursesAssigned = new List<Integer>();
            List<RapidCourseJSON> courseList = (List<RapidCourseJSON>)JSON.deserialize(currentUser.Rapid_Courses__c, List<RapidCourseJSON>.class);
            for(RapidCourseJSON course : courseList){
                if(course.input != null){
                    coursesAssigned.add(course.input.course_id);
                }
            }
            
            if(!coursesAssigned.contains(newCourseId)){
                RapidCourseJSON.input courses = new RapidCourseJSON.input();
                courses.course_id = newCourseId;
                courses.idempotency_key = 'garp-'+newCourseId;
                
                RapidCourseJSON addCourse = new RapidCourseJSON();
                addCourse.automation_script_id = automationId;
                addCourse.input = courses;
                courseList.add(addCourse);
                finalRapidCourseVal = JSON.serialize(courseList);
            }
            
        }else{
            List<RapidCourseJSON> courseList = new List<RapidCourseJSON>();
            RapidCourseJSON.input courses = new RapidCourseJSON.input();
            courses.course_id = newCourseId;
            courses.idempotency_key = 'garp-'+newCourseId;
            
            RapidCourseJSON addCourse = new RapidCourseJSON();
            addCourse.automation_script_id = automationId;
            addCourse.input = courses;
            courseList.add(addCourse);
            
            finalRapidCourseVal = JSON.serialize(courseList);
        }
        
        if(String.isNotBlank(finalRapidCourseVal)){
            currentUser.Rapid_Courses__c = finalRapidCourseVal;
            return currentUser;
        }else{
            return null;
        }
        
    }
}