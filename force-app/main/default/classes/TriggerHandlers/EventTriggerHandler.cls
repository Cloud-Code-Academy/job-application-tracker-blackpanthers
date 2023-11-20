public with sharing class EventTriggerHandler {
    public static void handleBeforeInsert(List<Event> newEvents){
        EventService.preventDuplicateEvents(newEvents);
    }

    public static void handleBeforeUpdate(List<Event> newEvents){
        EventService.preventDuplicateEvents(newEvents);
    }
}