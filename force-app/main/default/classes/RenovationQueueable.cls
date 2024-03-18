/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 16/03/2024
 * @description This class provides methods for handling renovation of Showroom.
 * 
 * @param renovationCases List of cases closed showrooms.
 */
public with sharing class RenovationQueueable implements Queueable, Database.AllowsCallouts{
    private List<Case> renovationCases;

    public RenovationQueueable(List<Case> cases) {
        this.renovationCases = cases;
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
}