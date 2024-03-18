/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 13/03/2024
 * @description This class provides methods for handling vehicle showrooms.
 */
public with sharing class VehicleShowroomHandler {
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description The method handles logic before insertion or update of Vehicle_Showroom__c records.
     * 
     * @param vsListNew List of new Vehicle_Showroom__c records or Vehicle_Showroom__c records with updated data.
     * @param vsListOld List with data before updating Vehicle_Showroom__c records.
     * @param showroomsWithAvailableVehicle List of Vehicle_Showroom__c witch vahicle is available in showroom.
     */
    public static void handlerBeforeInsertUpdate(List<Vehicle_Showroom__c> vsListNew, List<Vehicle_Showroom__c> vsListOld){
        if(vsListNew == null){
            return;
        }
        for(Vehicle_Showroom__c newVs : vsListNew){
            if(newVs.Is_available_in_showroom__c == true){
                List<Vehicle_Showroom__c> showroomsWithAvailableVehicle = [SELECT Vehicles__c, CarShowrooms__c FROM Vehicle_Showroom__c
                    WHERE Vehicles__c = :newVs.Vehicles__c AND Is_available_in_showroom__c = TRUE];
                if(showroomsWithAvailableVehicle.size() > 0){
                    newVs.AddError('This vehicle is already available in ' 
                    + showroomsWithAvailableVehicle[0].CarShowrooms__c); 
                }                              
            }
        }
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 17/03/2024
     * @description The method handles logic ifter insertion of Vehicle_Showroom__c records.
     * 
     * @param inInsertVsList List of newly inserted Vehicle_Showroom__c records.
     * @param newVehicleShowroomsIds List of newly inserted Vehicle_Showroom__c ids.
     */
    public static void handlerAfterInsert(List<Vehicle_Showroom__c> inInsertVsList){
        List<Id> newVehicleShowroomsIds = new List<Id>();
        for(Vehicle_Showroom__c vehicleShowroom : inInsertVsList){
            newVehicleShowroomsIds.add(vehicleShowroom.Id);
        }
        VehicleShowroomEmailSender.sendAnEmail(newVehicleShowroomsIds);
    }
}
