public with sharing class RenovationQueueable implements Queueable{
    private List<Showroom__c> showrooms;
    public RenovationQueueable(List<Showroom__c> showrooms) {
        this.showrooms = showrooms;
    }

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