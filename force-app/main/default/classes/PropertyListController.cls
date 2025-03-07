public with sharing class PropertyListController {

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getProperties(Integer pageNumber,Integer pageSize,Decimal minRent,Decimal maxRent,String status,
    String furnishingStatus,Decimal userLat,Decimal userLong){
        String query='SELECT Id, Name, Address__c, City__c, State__c, Rent__c, Status__c, Furnishing_Status__c,Location__Latitude__s,Location__Longitude__s FROM Property__c WHERE Rent__c >:minRent';
        
        else if(maxRent!=null){
            query +=' AND Rent__c <=:maxRent';
        }
        else if(!String.isEmpty(status)){
            query +=' AND Status__c=:status';
        }
        else if(!String.isEmpty(furnishingStatus)){
            query +=' AND Furnishing_Status__c=:furnishingStatus';
        }
        return Database.query(query);
    }

    @AuraEnabled(cacheable=true)
    public static Integer getTotalProperties(Decimal userLat,Decimal userLong,Decimal maxDistance,Decimal minRent,Decimal maxRent, 
        String availabilityStatus, String furnishingStatus) {
        String query = 'SELECT COUNT() FROM Property__c WHERE Rent__c >= :minRent AND Rent__c <= :maxRent';
        
        if (String.isNotBlank(availabilityStatus)) {
            query += ' AND Status__c = :availabilityStatus';
        }
        
        if (String.isNotBlank(furnishingStatus)) {
            query += ' AND Furnishing_Status__c = :furnishingStatus';
        }
        
        if (userLat != null && userLong != null && maxDistance != null) {
            query += ' AND DISTANCE(Location__Latitude__s, Location__Longitude__s, :userLat, :userLong, \'km\') <= :maxDistance';
        }
        
        return (Integer) Database.countQuery(query);
    }
}