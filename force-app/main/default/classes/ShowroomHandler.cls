/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 17/03/2024
 * @description This class provides methods for handling showrooms.
 */
public with sharing class ShowroomHandler {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description The method handles logic after update of Showroom__c records.
     * 
     * @param inUpdatedShowrooms List of showrooms with new data.
     * @param inOldShowrooms Map of showrooms with old data.
     * @param closedShowrooms List of showrooms which new status is 'Closed'.
     */
    public static void handlerAfterUpdate(List<Showroom__c> inUpdatedShowrooms, Map<Id, Showroom__c> inOldShowrooms){
        if(inUpdatedShowrooms == null){
            return;
        }
        List<Showroom__c> closedShowrooms = getClosedShowrooms(inUpdatedShowrooms, inOldShowrooms);
        RenovationQueueable renovation = new RenovationQueueable(closedShowrooms);
        System.enqueueJob(renovation);
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description The method returns list of showrooms which are updated to be closed.
     * 
     * @param inUpdatedShowrooms List of showrooms with new data.
     * @param inOldShowrooms Map of showrooms with old data.
     * @param closedShowrooms List of showrooms which new status is 'Closed'.
     */
    private static List<Showroom__c> getClosedShowrooms(List<Showroom__c> inUpdatedShowrooms,  Map<Id, Showroom__c> inOldShowrooms){
        List<Showroom__c> closedShowrooms = new List<Showroom__c>();
        for(Showroom__c showroom : inUpdatedShowrooms){
            Showroom__c oldShowroom = inOldShowrooms.get(showroom.Id);
            if (showroom.Status__c == 'Closed' && oldShowroom.Status__c != 'Closed') {
                closedShowrooms.add(showroom);
            }
        }
        return closedShowrooms;
    }
}