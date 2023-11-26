/**
 * Apex class to manage job applications.
 */
public with sharing class JobApplicationService {
    public static void createTasks(List<Job_Application__c> jobApps, Map<Id, Job_Application__c> oldMap) {
        List<Task> tasks = new List<Task>();

        for (Job_Application__c jobApp : jobApps) {
            String oldStatus = (oldMap != null && oldMap.containsKey(jobApp.Id)) ? oldMap.get(jobApp.Id).Status__c : null;
            String newStatus = jobApp.Status__c;

            // This is a validation rule that could be done using declarative means as well
            if (newStatus == null) {
                jobApp.addError('Status cannot be null');
                continue;
            }

            if (oldStatus != newStatus) {
                Task task = createTaskForJobApplication(jobApp, newStatus);
                tasks.add(task);
            }
        }

        insertTasks(tasks);
    }

    /**
     * Creates automation to create tasks when job application status is changed. 
     * Each task should have a due date, subject, and priority, 
     * making it easier to track what needs to be done and when
     */
    private static Task createTaskForJobApplication(Job_Application__c jobApp, String newStatus) {
        Task task = new Task();
        task.WhatId = jobApp.Id;
        task.ActivityDate = calculateActivityDate(newStatus);
        task.Priority = 'Normal';

        switch on newStatus {
            when 'Saved' {
                task.Subject = 'Job Application Review';
                task.Description = 'Check if the job description aligns with your interests and values. Review the highlighted skills to see if the role is a good fit. Research the company or role and mark your excitement level';
            }
            when 'Applying' {
                task.Subject = 'Get an insider!';
                task.Description = 'Find and research someone who works at the company and add them as a contact. Set up an informational interview to learn more about the role/company. Identify potential referrals to help get your application on the top of the pile. Customize your work achievements using the job description keywords. Submit your application on the company website if possible';
            }
            when 'Applied' {
                task.Subject = 'Apply/Follow-Up!';
                task.Description = 'Reach out to the hiring manager or recruiter. Follow up on your application via email weekly. Continue identifying and saving similar job opportunities. Set up weekly networking calls to explore similar companies/roles';
            }
            when 'Interviewing' {
                task.Subject = 'Prepare for the interview!';
                task.Description = 'Prepare your blurb or “tell me about yourself” response. Practice answering behavioral interview questions. Research the company and your interviewers. Set up your virtual interview space and test your tech. Send thank you emails within 24 hours';
            }
            when 'Negotiating' {
                task.Subject = 'Prepare to Negotiate!'; 
                task.Description = 'Research your market value and know your numbers. Prepare your negotiation scripts. Evaluate your offer and decline or accept';
            }
            when 'Accepted' {
                task.Subject = 'Prepare to resume!';
                task.Description = 'Plan your resignation if applicable. Take some time to relax and recharge. Prepare for your first day of onboarding';
            }
            when 'Closed' {
                task.Subject = 'Close gracefully!';
                task.Description = 'Send a follow-up email thanking the interviewer and asking for feedback. Review your notes and reflect on areas of improvement';
            }
        }

        return task;
    }

    private static Date calculateActivityDate(String newStatus) {
        return (newStatus == 'Closed') ? Date.today().addDays(2) :
               (newStatus == 'Accepted') ? Date.today().addDays(10) : Date.today().addDays(7);
    }

    private static void insertTasks(List<Task> tasks) {
        if (!tasks.isEmpty()) {
            insert tasks;
        }
    }
    
    /**
     * Primary Contact: Creates automation to always have the important 
     * contacts on the job application record
     */
    public static void setPrimaryContacts(List<Job_Application__c> jobApps) {
        Set<Id> companyIds = new Set<Id>();
        Map<Id, Id> jobAppToUpdateMap = new Map<Id, Id>();
    
        for (Job_Application__c jobApp : jobApps) {
            if (jobApp.Primary_Contact__c == null && jobApp.Company__c != null) {
                companyIds.add(jobApp.Company__c);
                jobAppToUpdateMap.put(jobApp.Id, jobApp.Company__c);
            }
        }
    
        Map<Id, Contact> companyToContactMap = new Map<Id, Contact>();
        for (Contact contact : [SELECT Id, AccountId FROM Contact
            WHERE AccountId IN :companyIds ORDER BY CreatedDate ASC LIMIT 1]) {
            companyToContactMap.put(contact.AccountId, contact);
        }
    
        for (Job_Application__c jobApp : jobApps) {
            Id companyId = jobAppToUpdateMap.get(jobApp.Id);
            if (companyId != null && companyToContactMap.containsKey(companyId)) {
                Id contactId = companyToContactMap.get(companyId).Id;    
                jobApp.Primary_Contact__c = contactId;
            }
        }
    }
   
}