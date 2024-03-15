trigger VehicleShowroomTrigger on Vehicle_Showroom__c (before insert, before update) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            VehicleShowroomHandler.handlerBeforeInsertUpdate(Trigger.new, null);
        } else if(Trigger.isUpdate){
            VehicleShowroomHandler.handlerBeforeInsertUpdate(Trigger.new, Trigger.old);
        }
    }
}