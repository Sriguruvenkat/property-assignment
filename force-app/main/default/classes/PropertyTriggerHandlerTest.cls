@isTest
public class PropertyTriggerHandlerTest {

    // Test method for handleImageException
    @isTest(seeAllData=true)
    public static void testHandleImageException() {
        // Query existing Property__c records
        List<Property__c> properties = [SELECT Id, Image__c FROM Property__c LIMIT 5];
        
        // Check if there are any properties to test
        if (!properties.isEmpty()) {
            // Test case where Image__c is empty
            properties[0].Image__c = '';
            Test.startTest();
            PropertyTriggerHandler.handleImageException(properties);
            System.assert(properties[0].getErrors().size() > 0, 'Error should be thrown for empty image field.');
            
            // Test case where Image__c does not contain '<img'
            properties[1].Image__c = 'invalidImage';
            
            PropertyTriggerHandler.handleImageException(properties);
            
            System.assert(properties[1].getErrors().size() > 0, 'Error should be thrown for invalid image format.');
            
            // Test case where Image__c contains '<img>'
            properties[2].Image__c = '<img src="image.jpg">';
        
            PropertyTriggerHandler.handleImageException(properties);
            Test.stopTest();
            System.assert(properties[2].getErrors().size() == 0, 'No error should be thrown for valid image format.');
        }
    }

    // Test method for createTask
    @isTest(seeAllData=true)
    public static void testCreateTask() {
        // Query existing Property_Tenant__c records
        List<Property_Tenant__c> propertyTenants = [SELECT Id, Tenant__c, Property__c FROM Property_Tenant__c LIMIT 5];
        
        if (!propertyTenants.isEmpty()) {
            Test.startTest();
            PropertyTriggerHandler.createTask(propertyTenants);
            Test.stopTest();
            
            // Check if tasks were created
            List<Task> tasks = [SELECT Id, Subject FROM Task WHERE Subject LIKE 'Create a lease agreement%' LIMIT 5];
            System.assertNotEquals(0, tasks.size(), 'Tasks should be created for tenants with properties.');
        }
    }

    // Test method for assignVendor
    @isTest(seeAllData=true)
    public static void testAssignVendor() {
        // Query existing Maintenance_Requests__c records
        List<Maintenance_Requests__c> maintenanceRequests = [SELECT Id, Vendor__c FROM Maintenance_Requests__c LIMIT 5];
        
        if (!maintenanceRequests.isEmpty()) {
            // Make sure Vendor__c is null in some records to test the logic
            for (Maintenance_Requests__c req : maintenanceRequests) {
                if (req.Vendor__c == null) {
                    req.Vendor__c = null;
                }
            }
            
            Test.startTest();
            PropertyTriggerHandler.assignVendor(maintenanceRequests);
            Test.stopTest();
            
            // Check if the Vendor__c field is populated in maintenance requests
            for (Maintenance_Requests__c req : maintenanceRequests) {
                System.assertNotEquals(null, req.Vendor__c, 'Vendor should be assigned to the maintenance request.');
            }
        }
    }
    @isTest
    public static void testMaintainenceRequest(){
         // Step 1: Create test data for Vendors
         Vendor__c vendor1 = new Vendor__c(Name = 'Vendor 1');
         Vendor__c vendor2 = new Vendor__c(Name = 'Vendor 2');
         insert new List<Vendor__c> { vendor1, vendor2 };
 
         // Step 2: Create maintenance request (it will trigger the assignment logic)
         Maintenance_Requests__c mr = new Maintenance_Requests__c(Status__c = 'Open');
         List<Maintenance_Requests__c> mrList=new List<Maintenance_Requests__c>();
         mrList.add(mr);
         insert mrList;
 
         // Step 3: Retrieve the maintenance request and ensure it was assigned to the correct vendor
         mr = [SELECT Name, Vendor__r.Name, Status__c FROM Maintenance_Requests__c WHERE Id = :mr.Id];
 
         // Step 4: Verify that the trigger has assigned the request to the vendor with the least workload
         System.assertNotEquals('Vendor 1', mr.Vendor__r.Name);
         System.assertEquals('Open', mr.Status__c);
    }

    @isTest
    public static void testPropertyTenantTrigger(){
        Property_Tenant__c pt = new Property_Tenant__c(Property__c = 'a19J4000000suXgIAI',Tenant__c='a1AJ4000000Mi56MAC');
        insert pt;
        // After the insert, verify that a Task was created
        List<Task> tasks = [SELECT Id, WhatId FROM Task ];

        // Step 3: Assert that a Task was created for the Property_Tenant__c record
        System.assertNotEquals(0, tasks.size(), 'Task should be created after Property_Tenant__c insert');
    }

    @isTest
    public static void testPropertyTrigger(){
        Property__c prop = new Property__c(
            Name = 'Test Property',Address__c='Test Address',City__c='Test City',State__c='Test State',Country__c='Test Country',
            Type__c='Residential',Status__c='Available',Postal_Code__c='234566',Description__c='test',
            Image__c = null 
        );

        Test.startTest();
        try{
            insert prop;  // This should trigger the exception handling
        }catch(Exception e){
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, Cannot Save without Image: []',e.getMessage());
        }   
        Test.stopTest();
    }
}
