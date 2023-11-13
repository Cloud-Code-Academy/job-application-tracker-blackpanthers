@isTest
public class TestEventService {

    @testSetup
    static void setupData() {
        DateTime testStartDateTime = DateTime.newInstance(2023, 1, 1, 12, 0, 0);
        Event testEvent = new Event(
            Subject = 'Test Event',
            StartDateTime = testStartDateTime,
            EndDateTime = testStartDateTime.addHours(1)
        );
        insert testEvent;
    }

    @isTest
    static void testPreventDuplicateEvents() {
        Event testEvent = [SELECT Id, StartDateTime, EndDateTime FROM Event 
        WHERE Subject = 'Test Event' LIMIT 1];

        List<Event> newEvents = new List<Event>{
            new Event(
                Subject = 'Duplicate Event 1',
                StartDateTime = testEvent.StartDateTime,
                EndDateTime = testEvent.EndDateTime
            ),
            new Event(
                Subject = 'Duplicate Event 2',
                StartDateTime = testEvent.StartDateTime,
                EndDateTime = testEvent.EndDateTime
            )
        };

        Test.startTest();
        EventService.preventDuplicateEvents(newEvents);
        Test.stopTest();

        Assert.areNotEqual(null, newEvents[0].getErrors(), 'Error should be added to Duplicate Event 1');
        Assert.areNotEqual(null, newEvents[1].getErrors(), 'Error should be added to Duplicate Event 2');
        
    }
}
