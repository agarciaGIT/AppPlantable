public class DeleteMedicalData_sch implements schedulable{
    public void execute(SchedulableContext sc)
    {
        DeleteMedicalData b = new DeleteMedicalData();
        database.executebatch(b,4);
    }
}