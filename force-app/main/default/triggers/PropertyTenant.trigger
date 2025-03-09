trigger PropertyTenant on Property_Tenant__c (after insert) {
    if(Trigger.isAfter && Trigger.isInsert){
        PropertyTriggerHandler.createTask(Trigger.NEW);
    }
}