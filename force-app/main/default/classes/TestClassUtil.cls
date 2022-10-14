public class TestClassUtil {
    
    public static String isOldTrigger = 'OLD';
    public static String isNewTrigger = '';
    public static Boolean isFirstTime = true;
    
    public static String isForOldTrigger(){ 
        isOldTrigger = 'OLD';
        isNewTrigger = '';
        return isOldTrigger; 
    }
    public static String isForNewTrigger(){ 
        isNewTrigger = 'NEW'; 
        isOldTrigger = '';
        return isNewTrigger; 
    }
}