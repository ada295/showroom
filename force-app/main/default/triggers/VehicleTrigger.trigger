trigger VehicleTrigger on Vehicle__c (before delete) {
    VehicleHandler.handleBeforeDeleteVehicle(Trigger.old);
}