@isTest
private class PropertyListControllerTest {

    @isTest(seeAllData=true)
    static void testGetProperties() {
        List<Property__c> expected=[Select Id from Property__c where Rent__c<20000 and Status__c='Available' and Furnishing_Status__c='Furnished'];
        Test.startTest();
        List<Property__c> results = PropertyListController.getProperties(1, 25, 0,20000, 'Available', 'Furnished', null, null);
        Test.stopTest();
        
        //System.assertNotEquals(0, results.size(), 'Expected some properties to be returned');
        System.assertEquals(expected.size(),results.size(), 'Expected maximum of 2 properties per page');
    }

    @isTest(seeAllData=true)
    static void testGetPropertyGeolocation() {
        Property__c property = [SELECT Id FROM Property__c WHERE Address1__c!=null LIMIT 1];
        
        Test.startTest();
        Map<String, Double> geolocation = PropertyListController.getPropertyGeolocation(property.Id);
        Test.stopTest();
        
        System.assertNotEquals(null, geolocation, 'Expected geolocation to be returned');
        System.assert(geolocation.containsKey('latitude'), 'Expected latitude to be present');
        System.assert(geolocation.containsKey('longitude'), 'Expected longitude to be present');
    }

    @isTest(seeAllData=true)
    static void testGetPropertyGeolocationWithNoAddress() {
        Property__c propertyWithoutAddress = [SELECT Id FROM Property__c WHERE Address1__c = NULL LIMIT 1];
        
        Test.startTest();
        Map<String, Double> geolocation = PropertyListController.getPropertyGeolocation(propertyWithoutAddress.Id);
        Test.stopTest();
        
        System.assertEquals(null, geolocation, 'Expected null geolocation for property without address');
    }

    @isTest(seeAllData=true)
    static void testLeaseAgreementController() {
        Lease_Agreement__c expected = [SELECT Id,Name, Terms__c, Tenant__r.Name,Start_Date__c,End_Date__c,Agreed_Monthly_Rent__c FROM Lease_Agreement__c LIMIT 1];
        
        Test.startTest();
        Lease_Agreement__c result= PropertyListController.getLeaseAgreementController(expected.Id);
        Test.stopTest();
        
        System.assertEquals(expected.Name,result.Name);
    }
}