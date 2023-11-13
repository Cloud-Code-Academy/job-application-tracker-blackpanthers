public with sharing class JobApplicationService {
    public static void createTasks(List<Job_Application__c> jobApplications){
        List<Task> tasks = new List<Task>();        

        for (Job_Application__c jobApp : jobApplications) {
            if (jobApp.Status__c == 'Saved') {
                Task task = new Task();
                task.Subject = 'Check Career Alignment/Interest!';
                task.Description = 'Check if the job description aligns with your interests and values. Review the highlighted skills to see if the role is a good fit. Research the company or role and mark your excitement level';
                task.WhatId = jobApp.Id;  
                task.ActivityDate = Date.today().addDays(1);
                task.Priority = 'Normal';
        
                tasks.add(task);
            }  
            else if (jobApp.Status__c == 'APPLYING'){
                Task task = new Task();
                task.Subject = 'Get an insider!';
                task.Description = 'Find and research someone who works at the company and add them as a contact. Set up an informational interview to learn more about the role/company. Identify potential referrals to help get your application on the top of the pile. Customize your work achievements using the job description keywords. Submit your application on the company website if possible';
                task.WhatId = jobApp.Id;  
                task.ActivityDate = Date.today().addDays(1);
                task.Priority = 'Normal';
        
                tasks.add(task);
            } 
            else if (jobApp.Status__c == 'APPLIED'){
                Task task = new Task();
                task.Subject = 'Apply/Follow-Up!';
                task.Description = 'Reach out to the hiring manager or recruiter. Follow up on your application via email weekly. Continue identifying and saving similar job opportunities. Set up weekly networking calls to explore similar companies/roles';
                task.WhatId = jobApp.Id;  
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Normal';
        
                tasks.add(task);
            } 
            else if (jobApp.Status__c == 'INTERVIEWING'){
                Task task = new Task();
                task.Subject = 'Prepare for the interview!';
                task.Description = 'Prepare your blurb or “tell me about yourself” response. Practice answering behavioral interview questions. Research the company and your interviewers. Set up your virtual interview space and test your tech. Send thank you emails within 24 hours';
                task.WhatId = jobApp.Id;  
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Normal';
        
                tasks.add(task);
            } 
            else if (jobApp.Status__c == 'NEGOTIATING'){
                Task task = new Task();
                task.Subject = 'Prepare to Negotiate!';
                task.Description = 'Research your market value and know your numbers. Prepare your negotiation scripts. Evaluate your offer and decline or accept';
                task.WhatId = jobApp.Id;  
                task.ActivityDate = Date.today().addDays(7);
                task.Priority = 'Normal';
        
                tasks.add(task);
            } 
            else if (jobApp.Status__c == 'ACCEPTED'){
                Task task = new Task();
                task.Subject = 'Prepare to resume!';
                task.Description = 'Plan your resignation if applicable. Take some time to relax and recharge. Prepare for your first day of onboarding';
                task.WhatId = jobApp.Id;  
                task.ActivityDate = Date.today().addDays(10);
                task.Priority = 'Normal';
        
                tasks.add(task);
            } 
            else if (jobApp.Status__c == 'CLOSED'){
                Task task = new Task();
                task.Subject = 'Close gracefully!';
                task.Description = 'Send a follow-up email thanking the interviewer and asking for feedback. Review your notes and reflect on areas of improvement';
                task.WhatId = jobApp.Id;  
                task.ActivityDate = Date.today().addDays(2);
                task.Priority = 'Normal';
        
                tasks.add(task);
            } 
        }

        if (!tasks.isEmpty()) {
            insert tasks;    
        } 
    }

    public static void setPrimaryContacts(List<Job_Application__c> jobApplications){
        List<Job_Application__c> jobAppsToUpdate = new List<Job_Application__c>();
        Map<Id, Contact> companyToContactMap = new Map<Id, Contact>();
        Set<Id> companyIds = new Set<Id>();

        for (Job_Application__c jobApp : jobApplications) {
            if (jobApp.Primary_Contact__c == null) {
                companyIds.add(jobApp.Company__c);
            }
        }

        List<Contact> relatedContacts = [SELECT Id, Name, AccountId FROM Contact WHERE AccountId IN :companyIds];

        for (Contact relatedContact : relatedContacts) {
            if (!companyToContactMap.containsKey(relatedContact.AccountId)) {
                companyToContactMap.put(relatedContact.AccountId, relatedContact);
            }
        }

        for (Job_Application__c jobApp : jobApplications) {
            if (jobApp.Primary_Contact__c == null && companyToContactMap.containsKey(jobApp.Company__c)) {
                jobApp.Primary_Contact__c = companyToContactMap.get(jobApp.Company__c).Id;
                jobAppsToUpdate.add(jobApp);
            }
        }
    }

}