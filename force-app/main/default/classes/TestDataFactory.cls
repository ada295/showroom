/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 13/03/2024
 * @description This class provides methods for generating tests data.
 */
@isTest
public class TestDataFactory {  
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description This method generates Vehicles.
     */
	public static List<Vehicle__c> createVehicles(Integer numVehicles) {
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        for(Integer i=0;i<numVehicles;i++) {
            Vehicle__c vehicle = new Vehicle__c(
                Name = '1122334455'+i,
                Brands__c = 'Suzuki'+i,
                Model__c = 'Vitara'+i,
                Production_Year__c = 2018
            );
            vehicles.add(vehicle);
        }
        insert vehicles;
        return vehicles;
    }   
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description This method generates Showrooms.
     */
    public static List<Showroom__c> createShowrooms(Integer numShowrooms){
        List<Showroom__c> showrooms = new List<Showroom__c>();
        for(Integer i=0;i<numShowrooms;i++) {
            Showroom__c showroom = new Showroom__c(
                Name = 'Salon Suzuki Warszawa'+i,
                Account__c = '001Qy00000DREyhIAH',
                Type__c = 'Cars'
        	); 
            showrooms.add(showroom);
        }
        insert showrooms;
        return showrooms;
    }   
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description This method generates VehicleShowrooms.
     */
    public static List<Vehicle_Showroom__c> createVehiclesShowrooms(Integer numVehiclesShowrooms){
        List<Showroom__c> showrooms = createShowrooms(numVehiclesShowrooms);
        List<Vehicle__c> vehicles = createVehicles(numVehiclesShowrooms);
        List<Vehicle_Showroom__c> vehicleShowrooms = new List<Vehicle_Showroom__c>(); 
         
        for(Integer i=0; i<numVehiclesShowrooms; i++) {
            Vehicle_Showroom__c vehicleShowroom = new Vehicle_Showroom__c(
                Vehicles__c = vehicles[i].Id,
                CarShowrooms__c = showrooms[i].Id,
                Is_available_in_showroom__c = false
        	); 
            vehicleShowrooms.add(vehicleShowroom);
        }         
        return vehicleShowrooms;
    }   
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 13/03/2024
     * @description This method generates Telemetries.
     */
    public static List<Telemetry__c> createTelemetries(Integer numTelemetries) {
        List<Telemetry__c> telemetries = new List<Telemetry__c>();
        for(Integer i=0;i<numTelemetries;i++) {
            Telemetry__c telemetry = new Telemetry__c(
                Name = 'Telemetry'+i,
                Component__c = 'piston',
                Type__c = 'temperature'
            );
            telemetries.add(telemetry);
        }
        insert telemetries;
        return telemetries;
    }  
}