public class VaykayHideOldTimeOff_Sch implements Schedulable {
    public static void execute(SchedulableContext sc) {
    VaykayHideOldTimeOff.UpdateVaykayOwner(); 
    // VaykayHideOldTimeOff_Sch m = new VaykayHideOldTimeOff_Sch();
    // String sch = '0 0 0 15 JAN ? *';
    // String jobID = system.schedule('VaykayHideOldTimeOff_Sch', sch, m);
   }
}