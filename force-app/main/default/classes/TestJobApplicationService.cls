@isTest
private class TestJobApplicationService {
    @TestSetup
    static void setupData(){
        Account account = new Account(Name = 'Cloud Code');
        insert account;

        List<Contact> contacts = new List<Contact>();
        Contact contact = new Contact(LastName = 'Test 1', AccountId = account.Id);
        Contact contact1 = new Contact(LastName = 'Test 2', AccountId = account.Id);
        contacts.add(contact);
        contacts.add(contact1);
        insert contacts;
        
    }

    @isTest static void testCreateTasksPositive(){
        List<Job_Application__c> jobApps = new List<Job_Application__c>();
        Job_Application__c jobApp = new Job_Application__c(Status__c = 'Saved');
        Job_Application__c jobApp1 = new Job_Application__c(Status__c = 'APPLYING');
        Job_Application__c jobApp2 = new Job_Application__c(Status__c = 'APPLIED');
        Job_Application__c jobApp3 = new Job_Application__c(Status__c = 'INTERVIEWING');
        Job_Application__c jobApp4 = new Job_Application__c(Status__c = 'NEGOTIATING');
        Job_Application__c jobApp5 = new Job_Application__c(Status__c = 'ACCEPTED');
        Job_Application__c jobApp6 = new Job_Application__c(Status__c = 'CLOSED');
        jobApps.add(jobApp);
        jobApps.add(jobApp1);
        jobApps.add(jobApp2);
        jobApps.add(jobApp3);
        jobApps.add(jobApp4);
        jobApps.add(jobApp5);
        jobApps.add(jobApp6);
    
        
        insert jobApps;

        Test.startTest();
        JobApplicationService.createTasks(jobApps);
        Test.stopTest();

        List<Task> tasks = [SELECT Id, WhatId, Subject FROM Task WHERE WhatId = :jobApps];

        Assert.areEqual(jobApps.size(), tasks.size(), 'One task should be created for each Job');
    }

    @isTest static void testCreateTasksNegative(){
        Job_Application__c jobApp = new Job_Application__c();
        insert jobApp;

        Test.startTest();
        JobApplicationService.createTasks(new List<Job_Application__c>{jobApp});
        Test.stopTest();

        List<Task> tasks = [SELECT Id, WhatId, Subject FROM Task WHERE WhatId = :jobApp.Id];

        Assert.areEqual(0, tasks.size(), 'No tasks should be created');
    }

    @isTest static void testSetPrimaryContactsPositive(){
        Account account = [SELECT Id FROM Account];
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Status__c = 'Saved';
        jobApp.Company__c = account.Id;
        insert jobApp;

        Test.startTest();
        JobApplicationService.setPrimaryContacts(new List<Job_Application__c>{jobApp});
        Test.stopTest();

        Job_Application__c updatedJobApp = [SELECT Id, Primary_Contact__c FROM Job_Application__c 
        WHERE Id = :jobApp.Id LIMIT 1];

        Assert.areNotEqual(null, updatedJobApp.Primary_Contact__c, 'Primary contact should be set');
    }

    @isTest static void testSetPrimaryContactsNegative(){
        Job_Application__c jobApp = new Job_Application__c();
        jobApp.Status__c = 'Saved';
        insert jobApp;

        Test.startTest();
        JobApplicationService.setPrimaryContacts(new List<Job_Application__c>{jobApp});
        Test.stopTest();

        Job_Application__c updatedJobApp = [SELECT Id, Primary_Contact__c FROM Job_Application__c 
        WHERE Id = :jobApp.Id LIMIT 1];

        Assert.areEqual(null, updatedJobApp.Primary_Contact__c, 'Primary contact should not be set');
    }

}