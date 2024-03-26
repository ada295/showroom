/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 25/03/2024
 * @description This class provides methods for getting data: account, showrroms, vehocles.
 */
public with sharing class AccountShowroomVehicleBrowserController {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method returns list of all accounts.
     */
    @AuraEnabled(cacheable=true)
    public static Account[] getAllAccounts() {
        return [
            SELECT Name
            FROM Account
            ORDER BY Name
        ];
    }
     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method returns list of showrooms which are connected with accountId.
     * 
     * @param accountId Id of account for which method will return list of showrooms.
     */
    @AuraEnabled(cacheable=true)
    public static Showroom__c[] getShowroomsByAccountId(Id accountId) {
        return [
            SELECT Name
            FROM Showroom__c
            WHERE Account__c = :accountId
            ORDER BY Name
        ];
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 16/03/2024
     * @description The method returns list of vehicles which are connected with showroomId.
     * 
     * @param showroomId Id of showroom for which method will return list of vehicles.
     */
    @AuraEnabled(cacheable=true)
    public static Vehicle__c[] getVehiclesByShowroomId(Id showroomId) {
        List<Id> vehiclesId = new List<Id>();
        List<Vehicle_Showroom__c> vehicleShowrooms = [SELECT Vehicles__c FROM Vehicle_Showroom__c
        WHERE CarShowrooms__c = :showroomId];
        for(Vehicle_Showroom__c vehicleShowroom : vehicleShowrooms){
            vehiclesId.add(vehicleShowroom.Vehicles__c);
        }
        List<Vehicle__c> vehicles = [
            SELECT Name, Brands__c, Model__c
            FROM Vehicle__c
            WHERE Id IN :vehiclesId
            ORDER BY Brands__c
        ];
        return vehicles;
    }
}