public with sharing class JADataCleanUpBatch implements Database.Batchable<SObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator('SELECT Id, Status__c, Follow_Up_Date__c, Note__c FROM Job_Application__c WHERE (Status__c != \'Closed\' AND Status__c != \'Accepted\') AND Follow_Up_Date__c <= :Date.today().addDays(-30)');
    }

    public void execute(Database.BatchableContext BC, list<Job_Application__c> staleApplications){
        List<Job_Application__c> applicationsToUpdate = new List<Job_Application__c>();
        for (Job_Application__c application : staleApplications) {
            application.Status__c = 'Closed';
            application.Note__c = 'Closed by automated process on ' + DateTime.now().format('yyyy-MM-dd HH:mm:ss');
            applicationsToUpdate.add(application);
        }

        if (!applicationsToUpdate.isEmpty()) {
            update applicationsToUpdate;
        }
    }

    public void finish(Database.BatchableContext BC){}
}