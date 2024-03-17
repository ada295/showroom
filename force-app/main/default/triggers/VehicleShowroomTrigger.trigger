trigger VehicleShowroomTrigger on Vehicle_Showroom__c (before insert, before update, after insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            VehicleShowroomHandler.handlerBeforeInsertUpdate(Trigger.new, null);
        } else if(Trigger.isUpdate){
            VehicleShowroomHandler.handlerBeforeInsertUpdate(Trigger.new, Trigger.old);
        }
    } else if(Trigger.isAfter) {
        if (Trigger.isInsert) {
            List<Id> newVehicleShowroomsIds = new List<Id>();
            for(Vehicle_Showroom__c vehicleShowroom : Trigger.new){
                newVehicleShowroomsIds.add(vehicleShowroom.Id);
            }
            VehicleShowroomEmailSender.sendAnEmail(newVehicleShowroomsIds);
        }
    }
}