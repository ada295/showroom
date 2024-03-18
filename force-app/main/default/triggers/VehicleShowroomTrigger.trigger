trigger VehicleShowroomTrigger on Vehicle_Showroom__c (before insert, before update, after insert) {
    if(Trigger.isBefore){
        if(Trigger.isInsert){
            VehicleShowroomHandler.handlerBeforeInsertUpdate(Trigger.new, null);
        } else if(Trigger.isUpdate){
            VehicleShowroomHandler.handlerBeforeInsertUpdate(Trigger.new, Trigger.old);
        }
    } else if(Trigger.isAfter) {
        if (Trigger.isInsert) {
           VehicleShowroomHandler.handlerAfterInsert(Trigger.new);
        }
    }
}