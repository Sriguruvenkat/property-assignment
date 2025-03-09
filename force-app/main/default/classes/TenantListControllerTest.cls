@isTest
public class TenantListControllerTest {
    
    // Test method to validate the getTenants method
    @isTest(seeAllData=true)
    public static void testGetTenants() {
        // Query existing Tenant records from the database
        List<Tenant__c> tenants = TenantListController.getTenants();
        
        // Assertions to check if the tenants data is fetched correctly
        System.assertNotEquals(0, tenants.size(), 'The tenant list should not be empty.');
        
        // Example: Checking if at least one tenant is present
        if (tenants.size() > 0) {
            System.assertNotEquals(null, tenants[0].Name, 'Tenant name should not be null.');
            System.assertNotEquals(null, tenants[0].Email__c, 'Tenant email should not be null.');
            System.assertNotEquals(null, tenants[0].Phone_Number__c, 'Tenant phone number should not be null.');
        }
    }
}
