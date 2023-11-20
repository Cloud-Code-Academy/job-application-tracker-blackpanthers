    @isTest
    private class TestInterviewReminderScheduler {

        @TestSetup
        static void setupData(){

        }
    
        @isTest
        static void testInterviewReminderScheduler() {  
            Job_Interview__c testInterview = new Job_Interview__c(
                Interview_Date__c = Date.today().addDays(1),
                Interview_Type__c = 'Panel'
            );
            insert testInterview;

            Job_Application__c testJobApplication = new Job_Application__c(
                Status__c = 'Saved'
            );
            insert testJobApplication;

            testInterview.Job_Application__c = testJobApplication.Id;
            update testInterview;

            Contact testContact = new Contact(
                LastName = 'Test Name', Email = 'test@test.com'
            );
            insert testContact;

            testJobApplication.Primary_Contact__c = testContact.Id;
            update testJobApplication;

            Test.startTest();
            InterviewReminderScheduler scheduler = new InterviewReminderScheduler();
            scheduler.execute(null); 
            Test.stopTest();

            // Assert.areEqual(true, scheduler.wereRemindersSent(), 'Reminders were not sent as expected');

        }
    }
    