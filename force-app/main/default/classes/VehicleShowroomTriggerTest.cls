/**
 * @author Adrianna Zajac <aadrianna.zajac@accenture.com>
 * @date 13/03/2024
 * @description This class contains test methods for the VehicleShowroomTrigger trigger.
 */
@isTest
public class VehicleShowroomTriggerTest {
    
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check the behavior 
     * when the input list of the new vehicles showrooms is null.
     */
    @IsTest
    static void shouldNotPerformAnyActionsWhenInputListOfNewVehiclesShowroomsIsNull() {
        List<Vehicle_Showroom__c> emptyList = null;

        Test.startTest();
        VehicleShowroomHandler.handlerBeforeInsertUpdate(emptyList, emptyList);
        Test.stopTest();

        System.assertEquals(0, Limits.getQueries(), 'No queries should be executed.');
    }

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check vehicle insert behavior
     * when the new vehicle field available in the showroom is false.
     */
	@isTest static void shoulBeNoConflictAvailableInShowroomIsFalse() {
        List<Vehicle_Showroom__c> vsList = TestDataFactory.createVehiclesShowrooms(1);
        vsList[0].Is_available_in_showroom__c = false;

        Test.startTest();
        Database.SaveResult result = Database.insert(vsList[0], false);
        Test.stopTest();
    
        System.assert(result.isSuccess(), 'Creating VehicleShowroom should success');
        System.assert(vsList[0].Id != null, 'Id of VehicleShowroom should not be null');
	}
    
     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check vehicle insert behavior
     * when the new vehicle field available in the showroom is true
     * and the vehicle is not available in another showroom.
     */
    @isTest static void shouldBeNoConflictWhenIsAvailableInShowroomWithNoConflictInsert() {
		List<Vehicle_Showroom__c> vsList = TestDataFactory.createVehiclesShowrooms(1);
        vsList[0].Is_available_in_showroom__c = true;
        
        Test.startTest();
        Database.SaveResult result = Database.insert( vsList[0]);
        Test.stopTest();

        System.assert(vsList[0] != null, 'Id of VehicleShowroom should not be null');
        System.assert(result.isSuccess(), 'Creating VehicleShowroom should be successful');
	}
    
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check vehicle update behavior
     * when the new vehicle field available in the showroom is true
     * and the vehicle is not available in another showroom.
     */
    @isTest static void shouldBeNoConflictWhenAvailableInShowroomIsTrueWithNoConflictUpdate() {
        List<Vehicle_Showroom__c> vsList = TestDataFactory.createVehiclesShowrooms(1);
        vsList[0].Is_available_in_showroom__c = false;
        insert vsList[0];
        vsList[0].Is_available_in_showroom__c = true;

        Test.startTest();
        Database.SaveResult result =Database.update( vsList[0]);
        Test.stopTest();

        System.assert(vsList[0] != null, 'Id of VehicleShowroom should not be null');
        System.assert(result.isSuccess(), 'Creating VehicleShowroom should be successful');
	}

     /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check vehicle insert behavior
     * when the new vehicle field available in the showroom is true
     * and the vehicle is available in another showroom.
     */                
    @isTest static void shouldBeConflictWhenAvailableInShowroomIsTrueWithConflictInsert() {
        List<Vehicle_Showroom__c> vehicleShowrooms = TestDataFactory.createVehiclesShowrooms(2);
        vehicleShowrooms[0].Vehicles__c = vehicleShowrooms[1].Vehicles__c;
        vehicleShowrooms[0].Is_available_in_showroom__c = true;
        insert vehicleShowrooms[0];
        vehicleShowrooms[1].Is_available_in_showroom__c = true;

        Test.startTest();
    	Database.SaveResult result = Database.insert(vehicleShowrooms[1], false);
    	Test.stopTest();
        
        System.assert(!result.isSuccess(), 'Creating VehicleShowroom should fail');
        System.assertEquals(1, result.getErrors().size(), 'There should be one error');
        System.assertEquals('This vehicle is already available in ' + vehicleShowrooms[0].CarShowrooms__c, result.getErrors()[0].getMessage());
	}

      /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description Test method to check vehicle update behavior
     * when the new vehicle field available in the showroom is true
     * and the vehicle is available in another showroom.
     */                 
    @isTest static void shouldBeConflictAvailableInShowroomIsTrueWithConflictUpdate() {
        List<Vehicle_Showroom__c> vehicleShowrooms = TestDataFactory.createVehiclesShowrooms(2);
        vehicleShowrooms[0].Is_available_in_showroom__c = true;
        insert vehicleShowrooms[0];
        vehicleShowrooms[1].Vehicles__c = vehicleShowrooms[0].Vehicles__c;
        insert vehicleShowrooms[1];
        
        vehicleShowrooms[1].Is_available_in_showroom__c = true;
       
        Test.startTest();
    	Database.SaveResult result = Database.update(vehicleShowrooms[1], false);
    	Test.stopTest();
        
        System.assert(!result.isSuccess(), 'Creating VehicleShowroom should fail');
        System.assertEquals(1, result.getErrors().size(), 'There should be one error');
        System.assertEquals('This vehicle is already available in ' + vehicleShowrooms[0].CarShowrooms__c, result.getErrors()[0].getMessage());             
	}
}