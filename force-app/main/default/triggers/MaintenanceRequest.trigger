trigger MaintenanceRequest on Maintenance_Requests__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        PropertyTriggerHandler.assignVendor(Trigger.NEW);
    }
}