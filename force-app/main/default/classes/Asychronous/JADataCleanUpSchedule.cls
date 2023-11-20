public class JADataCleanUpSchedule implements Schedulable{
    
    public static final String CRON = '0 0 0 * * ?';
    
    public void execute(SchedulableContext sc) {    
        JADataCleanUpBatch jobApplicationBatch = new JADataCleanUpBatch();
        Database.executeBatch(jobApplicationBatch, 2000);
    }
}