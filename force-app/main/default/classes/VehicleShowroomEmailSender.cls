/**
    * @author Adrianna Zajac <adrianna.zajac@accenture.com>
    * @date 16/03/2024
    * @description This class provides future method for sending an email.
    */
public with sharing class VehicleShowroomEmailSender {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 16/03/2024
     * @description This future method is responsible for sending an email when new VehicleShowroom was inserted.
     *
     *@param vehicleShowroomsIds List of new Vehicle_Showroom__c ids.
     *@param vehicleShowrooms List of new  Vehicle_Showroom__c.
    */
    @future
    public static void sendAnEmail (List<Id> Vehicle_Showroom__c) {
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