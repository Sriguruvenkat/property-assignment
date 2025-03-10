public with sharing class PropertyListController {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(Integer pageNumber,Integer pageSize,Decimal minRent,Decimal maxRent,String status,
    String furnishingStatus,Decimal userLat,Decimal userLong){

        List<String> filters = new List<String>();
        
        // Always add minRent (Assume minRent is always provided)
        filters.add('Rent__c >= :minRent');

        if (maxRent!=null) {
            filters.add('Rent__c <= :maxRent');
        }
        if (String.isNotBlank(status)) {
            filters.add('Status__c = :status');
        }
        if (String.isNotBlank(furnishingStatus)) {
            filters.add('Furnishing_Status__c = :furnishingStatus');
        }

        // Join all conditions dynamically
        String query = 'SELECT Id, Name, Address__c, City__c, State__c, Rent__c, Status__c, Furnishing_Status__c, Location__Latitude__s, Location__Longitude__s FROM Property__c';
        if (!filters.isEmpty()) {
            query += ' WHERE ' + String.join(filters, ' AND ');
        }

        Integer offset=((pageNumber-1)*pageSize);
        query += ' LIMIT :pageSize OFFSET :offset';
        
        System.debug('Final Query: ' + query);
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,Double> getPropertyGeolocation(Id propertyId){
        Property__c property=[select Id,Address1__c,Address1__r.Latitude,Address1__r.Longitude FROM Property__c where Id=:propertyId LIMIT 1];

        if(property.Address1__c !=null){
            return new Map<String,Double>{
                'latitude'=>property.Address1__r.Latitude,
                'longitude'=>property.Address1__r.Longitude
            };
        }
        return null;
    }

    @AuraEnabled
	public static Lease_Agreement__c getLeaseAgreementController(Id leaseId){
		return [SELECT Id,Name,Terms__c, Tenant__r.Name,Start_Date__c,End_Date__c,Agreed_Monthly_Rent__c FROM Lease_Agreement__c Where Id=:leaseId LIMIT 1];
	}
}