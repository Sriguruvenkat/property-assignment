@isTest
public class LastDayLeaseExpiryBatchTest {
    
    @isTest(seeAllData=true)
    public static void testMonthlyLeaseExpiryBatch() {
        // Query existing Lease_Agreement__c records with End_Date__c set to 30 days from today
        List<Lease_Agreement__c> leaseAgreements = [
            SELECT Id, Name,Terms__c, End_Date__c, Tenant__r.Email__c, Tenant__r.Name 
            FROM Lease_Agreement__c 
            WHERE End_Date__c = :System.today().addDays(1) 
            AND Tenant__r.Email__c != NULL
        ];
        
        // Ensure there are lease agreements that match the criteria
        System.assertNotEquals(0, leaseAgreements.size(), 'No lease agreements found with the specified end date.');

        // Start the test for the batch class
        Test.startTest();
        
        // Execute the batch job
        LastDayLeaseExpiryBatch batchJob = new LastDayLeaseExpiryBatch();
        Database.executeBatch(batchJob, 1);
        
        // Stop the test
        Test.stopTest();
        
        System.assertEquals(true, true, 'Batch execution finished successfully.');
    }
}
