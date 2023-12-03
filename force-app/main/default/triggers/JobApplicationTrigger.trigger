trigger JobApplicationTrigger on Job_Application__c (before insert, before update, after insert, after update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            JobApplicationTriggerHandler.beforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            JobApplicationTriggerHandler.beforeUpdate(Trigger.new);
        }
        when AFTER_INSERT {
            JobApplicationTriggerHandler.afterInsert(Trigger.new, Trigger.newMap);
        }
        when AFTER_UPDATE {
            JobApplicationTriggerHandler.afterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}