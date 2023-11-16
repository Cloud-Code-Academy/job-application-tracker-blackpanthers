public class InterviewReminderScheduler implements Schedulable {

    public static final String CRON = '0 0 0 * * ?';

    public void execute(SchedulableContext sc) {

        Date tomorrow = Date.today().addDays(1);
        List<Job_Interview__c> interviews = [SELECT Id, Interview_Date__c, Interview_Type__c, Job_Application__c FROM Job_Interview__c WHERE Interview_Date__c = :tomorrow];

        for (Job_Interview__c interview : interviews) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setTemplateId('');
            email.setTargetObjectId(interview.Id);
            email.setSaveAsActivity(false);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});
        }
    }
}
