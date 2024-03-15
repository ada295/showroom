
/**
 * @author Adriann Zajac <adrianna.zajac@accenture.com>
 * @date 13/03/2024
 * @description This class contains test methods for the VehicleTrigger trigger.
 */@isTest
public class VehicleTriggerTest {

    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check the behavior when the input list of the deleted vehicles is null.
     */
    @IsTest
    static void shouldPerformNoActionWhenInputListOfDeletedVehiclesIsNull() {
        List<Vehicle__c> emptyList = null;

        Test.startTest();
        VehicleHandler.handleBeforeDeleteVehicle(emptyList);
        Test.stopTest();

        Integer taskNumber = [SELECT COUNT() FROM Task];
        System.assertEquals(0, taskNumber, 'No new tasks should be created');
    }

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check if telemetry of the of the deleted vehicle is deleted.
     */
    @isTest static void shouldDeleteTelemetry(){
        List<Telemetry__c> telemetries = TestDataFactory.createTelemetries(1);
        List<Vehicle__c> vehicles = TestDataFactory.createVehicles(1);
        telemetries[0].Vehicle__c = vehicles[0].Id;
       
        Test.startTest();
    		Database.DeleteResult result = Database.delete(vehicles[0], false);
    	Test.stopTest();
        
        List<Telemetry__c> deletedTelemetries = [SELECT Id FROM Telemetry__c WHERE Vehicle__c = :vehicles[0].Id];
        System.assert(result.isSuccess(), 'Deleting telemetry should be successful');
        System.assertEquals(0, deletedTelemetries.size(), 'Telemetry list should be empty');
    }
    
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check if task is added for deleted vehicle.
     */
    @isTest static void shouldCreateTaskBeforeDeleteVehicle(){
        List<Vehicle__c> vehicles = TestDataFactory.createVehicles(1);
        
        Test.startTest();
    		Database.DeleteResult result = Database.delete(vehicles[0], false);
    	Test.stopTest();
        
        List<Task> tasks = [SELECT CallObject FROM Task WHERE CallObject = :vehicles[0].Name];
        System.assert(result.isSuccess(), 'Creating Task should success');
        System.assertEquals(1, tasks.size(), 'There should be one Task');
		System.assertEquals(vehicles[0].Name, tasks[0].CallObject, 'There should be one Task connected with deleting Vehicle');
    }
}