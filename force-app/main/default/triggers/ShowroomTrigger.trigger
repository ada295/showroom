trigger ShowroomTrigger on Showroom__c (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            ShowroomHandler.handlerAfterUpdate(Trigger.new, Trigger.oldMap);
        }
    }
}