public class InterviewReminderScheduler implements Schedulable {

    public static final String CRON = '0 0 0 * * ?';

    /**
     * Email Notifications: Create a feature that sends an email notification to 
     * the user a day before their scheduled interview.
     */
    public void execute(SchedulableContext sc) {

        Date tomorrow = Date.today().addDays(1);
        List<Job_Interview__c> interviews = [
            SELECT
                Id,
                Interview_Date__c,
                Interview_Type__c,
                Job_Application__c,
                Job_Application__r.Primary_Contact__c
            FROM
                Job_Interview__c
            WHERE
                Interview_Date__c = :tomorrow
        ];


        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage>();

        for (Job_Interview__c interview : interviews) {
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

            email.setSubject('Interview Reminder');
            email.setHtmlBody('<html><body>This is to remind you of ' + interview.Interview_Type__c + '</body></html>');

            email.setTargetObjectId(interview.Job_Application__r.Primary_Contact__c);
            email.setSaveAsActivity(false);

            emailMessages.add(email);
        }

        Messaging.sendEmail(emailMessages);
    
    }
    
}
