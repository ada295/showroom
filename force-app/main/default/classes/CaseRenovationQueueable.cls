/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 21/03/2024
 * @description This class provides methods for creating cases for closed showrooms.
 * 
 * @param closedShowrooms List of updated showrooms which status is closed.
 */
public with sharing class CaseRenovationQueueable implements Queueable{
    private List<Showroom__c>  closedShowrooms;
    
    public CaseRenovationQueueable(List<Showroom__c> closedShowrooms) {
        this.closedShowrooms = closedShowrooms;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 16/03/2024
     * @description The method creates cases for closed Showroom__c records and enqueue RenovationQueuable.
     * 
     * @param closedShowrooms List of showrooms which new status is 'Closed'.
     * @param renovationCases List of cases for closed showrooms.
     */
    public void execute(QueueableContext context){
        List<Case> renovationCases = new List<Case>();
        for (Showroom__c showroom : closedShowrooms) {
            Case renovationCase = new Case(
                Showroom__c = showroom.Id,
                Subject = 'Renovation Case ' + showroom.Name 
            );
            renovationCases.add(renovationCase);
        }
        insert renovationCases;

        if(renovationCases.size()>0){
            RenovationQueueable renovation = new RenovationQueueable(renovationCases);
            System.enqueueJob(renovation);
        } 
    }
}