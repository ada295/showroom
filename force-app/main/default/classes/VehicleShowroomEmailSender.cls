public with sharing class VehicleShowroomEmailSender {
    @future
    public static void sendAnEmail (List<Id> vehicleShowroomsIds) {
        if (vehicleShowroomsIds.size() > 0) {
            List<Vehicle_Showroom__c> vehicleShowrooms = [SELECT Id, Vehicles__c, CarShowrooms__c 
            FROM Vehicle_Showroom__c WHERE Id IN :vehicleShowroomsIds];
            
            if(!vehicleShowrooms.isEmpty()){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('New car sales offers have been added');

                String emailBody = 'The following offers have been added:<br/><br/>';
                for(Vehicle_Showroom__c vehicleShowroom : vehicleShowrooms){
                    emailBody += 'Id of showroom: ' + vehicleShowroom.CarShowrooms__c + '<br/>';
                    emailBody += 'Id of vehicle: ' + vehicleShowroom.Vehicles__c + '<br/><br/>';
                }

                email.setHtmlBody(emailBody);
                email.setToAddresses(new String[] {'adrianna.maria.zajac@gmail.com'});
                email.setSaveAsActivity(false);

                try {
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
                    System.debug('The email was sent successfully!');
                } catch (Exception e) {
                    System.debug('There was a problem sending the email: ' + e.getMessage());
                }
            }  
        }
    }
}