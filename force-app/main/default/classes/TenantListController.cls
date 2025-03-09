public with sharing class TenantListController {
    
    @AuraEnabled(cacheable=true)
    public static List<Tenant__c> getTenants(){
        List<Tenant__c> tenantList=[Select Id,Name,Email__c,Phone_Number__c FROM Tenant__c];
        return tenantList;
    }
}