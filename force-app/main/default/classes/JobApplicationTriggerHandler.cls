public with sharing class JobApplicationTriggerHandler {
    public static void handleBeforeInsert(List<Job_Application__c> jobApplications) {
        JobApplicationService.setPrimaryContacts(jobApplications);
    }

    public static void handleAfterUpdate(List<Job_Application__c> jobApplications) {
        JobApplicationService.createTasks(jobApplications);
    }
}