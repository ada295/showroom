trigger ShowroomTrigger on Showroom__c (after update) {
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            List<Showroom__c> showroomsRenovation = new List<Showroom__c>();
            for (Showroom__c showroom : Trigger.new) {
                if (showroom.Status__c == 'Closed' && Trigger.oldMap.get(showroom.Id).Status__c != 'Closed') {
                    showroomsRenovation.add(showroom);
                }
            }
            RenovationQueueable renovation = new RenovationQueueable(showroomsRenovation);
            System.enqueueJob(renovation);
        }
    }
}