public class PropertyTriggerHandler {
    public static void handleImageException(List<Property__c> propRecords){
        for(Property__c prop:propRecords){
            if(String.isEmpty(prop.Image__c)|| !prop.Image__c.contains('<img')){
                prop.addError('Cannot Save without Image');
            }
        }
    }
}