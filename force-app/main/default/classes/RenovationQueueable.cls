/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 16/03/2024
 * @description This class provides methods for handling renovation of Showroom.
 * 
 * @param showrooms List of closed showrooms to process.
 */
public with sharing class RenovationQueueable implements Queueable{
    private List<Showroom__c> showrooms;
    public RenovationQueueable(List<Showroom__c> showrooms) {
        this.showrooms = showrooms;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 16/03/2024
     * @description This future method send HttpRequest with closed Showroom cases.
     * 
     * @param casesIds List of new casesIds to be processed. 
     * @param renovationCases List of cases with ids in casesIds.
     */
    @Future(callout=true)
    public static void executeAsync(List<Id> casesIds){
        List<Case> renovationCases = [SELECT Id, Showroom__c, Subject FROM Case WHERE Id IN :casesIds];

        Http server = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://jsonplaceholder.typicode.com/posts');
        request.setMethod('POST');
        request.setBody(JSON.serialize(renovationCases)); 
        HttpResponse response = server.send(request);

        if (response.getStatusCode()==201) {
            for (Case renovationCase : renovationCases) {
                renovationCase.Status = 'Closed';
            }
        } else {
            for (Case renovationCase : renovationCases) {
                renovationCase.Status = 'Failed';
            }
            System.debug(LoggingLevel.ERROR, 'Connection error!');
        }
        update renovationCases;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 16/03/2024
     * @description This queueable method generating cases for closed Showrooms.
     * 
     * @param renovationCases List of new cases for closed showrooms.
     * @param casesIds List of new cases Ids for closed showrooms.
     */
    public void execute(QueueableContext context) {
        List<Case> renovationCases = new List<Case>();
        for (Showroom__c showroom : showrooms) {
            Case renovationCase = new Case(
                Showroom__c = showroom.Id,
                Subject = 'Renovation Case ' + showroom.Name 
            );
            renovationCases.add(renovationCase);
        }
        insert renovationCases;

        List<Id> casesIds = new List<Id>();
            for(Case newCase : renovationCases){
                casesIds.add(newCase.Id);
            }
        executeAsync(casesIds);
    }
}