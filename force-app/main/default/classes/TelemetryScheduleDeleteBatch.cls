/**
* @author Adrianna Zajac <adrianna.zajac@accenture.com>
* @date 16/03/2024
* @description This class handling batch methods for monthly deletion of telemetry older than 3 months.
*/
public class TelemetryScheduleDeleteBatch implements Database.Batchable<SObject>, Schedulable {
    public Database.QueryLocator start (Database.BatchableContext bc) {
        Date deadline = Date.today().addMonths(-3);
        return Database.getQueryLocator('SELECT Id FROM Telemetry__c WHERE CreatedDate < :deadline');
        //Date deadline = Date.today().addDays(-5);
        //return Database.getQueryLocator('SELECT Id FROM Telemetry__c WHERE CreatedDate < :deadline');
    }

    public void execute(Database.BatchableContext bc, List<Telemetry__c> telemetryToDelete) {
        delete telemetryToDelete;
    }

    public void finish(Database.BatchableContext bc) {
    }

    /**
    * @author Adrianna Zajac <adrianna.zajac@accenture.com>
    * @date 16/03/2024
    * @description This method is responsible for scheduling the next batch method call.
    */
    public void execute(SchedulableContext sc) {
        TelemetryScheduleDeleteBatch batch = new TelemetryScheduleDeleteBatch();
        System.debug('Old telemetry deleted successfully!');
        Database.executeBatch(batch);
    }
}