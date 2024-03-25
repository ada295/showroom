public with sharing class AccountShowroomVehicleBrowserController {
    @AuraEnabled(cacheable=true)
    public static Account[] getAllAccounts() {
        return [
            SELECT Name
            FROM Account
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Showroom__c[] getShowroomsByAccountId(Id accountId) {
        return [
            SELECT Name
            FROM Showroom__c
            WHERE Account__c = :accountId
        ];
    }

    @AuraEnabled(cacheable=true)
    public static Vehicle__c[] getVehiclesByShowroomId(Id showroomId) {
        List<Id> vehiclesId = new List<Id>();
        List<Vehicle_Showroom__c> vehicleShowrooms = [SELECT Vehicles__c FROM Vehicle_Showroom__c
        WHERE CarShowrooms__c = :showroomId];
        // System.debug(vehicleShowrooms);
        for(Vehicle_Showroom__c vehicleShowroom : vehicleShowrooms){
            vehiclesId.add(vehicleShowroom.Vehicles__c);
        }
        List<Vehicle__c> vehicles = [
            SELECT Name, Brands__c, Model__c
            FROM Vehicle__c
            WHERE Id IN :vehiclesId
        ];
        // System.debug(vehicles);
        return vehicles;
    }
}