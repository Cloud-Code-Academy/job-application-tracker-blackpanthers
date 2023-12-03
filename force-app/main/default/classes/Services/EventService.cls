public with sharing class EventService {
    /**
     * Meeting Validation: Create validations so that interview meetings cannot overlap. 
     * This will reduce the chance of double booking and missing an interview. 
     */
    public static void preventDuplicateEvents(List<Event> newEvents) {
        Set<DateTime> existingEventStartDates = new Set<DateTime>();
        List<DateTime> newEventStartDates = new List<DateTime>();

        for (Event newEvent : newEvents) {
            if (newEvent.StartDateTime != null) {
                newEventStartDates.add(newEvent.StartDateTime);
            }
        }

        List<Event> existingEvents = [SELECT StartDateTime FROM Event WHERE StartDateTime IN :newEventStartDates];

        for (Event existingEvent : existingEvents) {
            existingEventStartDates.add(existingEvent.StartDateTime);
        }

        for (Event newEvent : newEvents) {
            if (newEvent.StartDateTime != null) {
                if (existingEventStartDates.contains(newEvent.StartDateTime)) {
                    newEvent.addError('Another event with the same start date/time already exists.');
                    break;
                }
            }
        }
    }
}