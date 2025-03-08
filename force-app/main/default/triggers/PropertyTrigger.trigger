trigger PropertyTrigger on Property__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert){
        PropertyTriggerHandler.handleImageException(Trigger.new);
    }
}