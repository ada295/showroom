/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 13/03/2024
 * @description This class provides methods for handling vehicles.
 */
public with sharing class VehicleHandler {

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description The method handles logic before deletion of Vehicle__c records.
     * 
     * @param vehiclesToDelete List of Vehicle__c objects representing deleted vehicles.
     */
    public static void handleBeforeDeleteVehicle(List<Vehicle__c> vehiclesToDelete) {
        if(vehiclesToDelete == null){
            return;
        }
        createTask(vehiclesToDelete);
        deleteVehicleTelemetry(vehiclesToDelete);
    }

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description The method creates tasks for vehicles which are deleted.
     * 
     * @param vehiclesToDelete List of Vehicle__c objects representing deleted vehicles.
     */
    @TestVisible
    public static void createTask(List<Vehicle__c> vehiclesToDelete){
        List<Task> tasks = new List<Task>();
        for(Vehicle__c v : vehiclesToDelete){
            Task t = new Task(
                Type = 'Vehicle',
                Subject = 'Delete vehicle',
                Status = 'In progress',
                Priority = 'High',
                CallObject = v.Name,
                Description = 'Check the impact on the environment of removing the vehicle whose serial number is: ' + v.Name + ' and whether the disposal was successful.'
            );        
            tasks.add(t);
        }
        insert tasks;
    }
    
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description The method deletes telemetry records related to deleted vehicles.
     * 
     * @param vehiclesToDelete List of Vehicle__c objects representing deleted vehicles.
     */
    @TestVisible
    public static void deleteVehicleTelemetry(List<Vehicle__c> vehiclesToDelete){
        List<Telemetry__c> telemetryToDelete = [SELECT Id FROM Telemetry__c WHERE Vehicle__c IN :vehiclesToDelete];
    	delete telemetryToDelete;
    }
}