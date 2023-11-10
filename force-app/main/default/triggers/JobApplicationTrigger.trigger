trigger JobApplicationTrigger on Job_Application__c (before insert, after insert, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            JobApplicationTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        when AFTER_INSERT {
            JobApplicationTriggerHandler.handleAfterInsert(Trigger.new);
        }
        when AFTER_UPDATE {
            JobApplicationTriggerHandler.handleAfterUpdate(Trigger.new);
        }
    }
}