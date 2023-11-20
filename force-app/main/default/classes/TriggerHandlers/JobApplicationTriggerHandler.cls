public with sharing class JobApplicationTriggerHandler {
    public static void beforeInsert(List<Job_Application__c> jobApps) {
        JobApplicationService.setPrimaryContacts(jobApps);
    }

    public static void beforeUpdate(List<Job_Application__c> jobApps) {
        JobApplicationService.setPrimaryContacts(jobApps);
    }
    
    public static void afterInsert(List<Job_Application__c> jobApps, Map<Id,Job_Application__c> newMap) {
        JobApplicationService.createTasks(jobApps, null);
    }
    
    public static void afterUpdate(List<Job_Application__c> jobApps, Map<Id,Job_Application__c> oldMap) {
        JobApplicationService.createTasks(jobApps, oldMap);
    }
}