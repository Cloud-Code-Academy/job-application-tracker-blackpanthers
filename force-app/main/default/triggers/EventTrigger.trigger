trigger EventTrigger on Event (before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            EventTriggerHandler.handleBeforeInsert(Trigger.new);
        }
        when BEFORE_UPDATE {
            EventTriggerHandler.handleBeforeUpdate(Trigger.new);
        }
    }
}