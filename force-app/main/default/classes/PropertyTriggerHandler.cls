public class PropertyTriggerHandler {
    public static void handleImageException(List<Property__c> propRecords){
        for(Property__c prop:propRecords){
            if(String.isEmpty(prop.Image__c)|| !prop.Image__c.contains('<img')){
                prop.addError('Cannot Save without Image');
            }
        }
    }

    public static void createTask(List<Property_Tenant__c> ptList){
        Id currentUserId=UserInfo.getUserId();
        List<Task> taskList=new List<Task>();
        List<Property_Tenant__c> tenantsWithProperties = [ 
        SELECT Id, Tenant__c, Tenant__r.Name, Property__c, Property__r.Name 
        FROM Property_Tenant__c 
        WHERE Id IN :ptList
    ];
        for(Property_Tenant__c pt:tenantsWithProperties){
            if(pt.Property__c!=null){
                Task ts=new Task();
                ts.OwnerId=currentUserId;
                ts.Status='Not Started';
                ts.Subject='Create a lease agreement for the Tenant '+pt.Tenant__r.Name+' for the Property '+pt.Property__r.Name;
                ts.Priority='Normal';
                ts.CurrencyIsoCode='INR';
                taskList.add(ts);

            }
        }
        insert taskList;
    }

    public static void assignVendor(List<Maintenance_Requests__c> mainReqList){
        List<Vendor__c> venList=[select Id,Name from Vendor__c];
        Map<String,Integer> venMap=new Map<String,Integer>();
        for(Vendor__c ven:venList){
            Integer ct=[Select COUNT() from Maintenance_Requests__c where Vendor__c=:ven.Id];
            venMap.put(ven.Name,ct);
        }
        List<Integer> intList=venMap.values();
        intList.sort();
        String availableVendor;
        for(String key:venMap.keySet()){
            if(venMap.get(key)==intList[0]){
                availableVendor=key;
            }
        }
        Vendor__c ava=[Select Id from Vendor__c where Name=:availableVendor LIMIT 1];
        system.debug(ava.Id);

        for(Maintenance_Requests__c mainReq:mainReqList){
            if(mainReq.Vendor__c==null){
                mainReq.Vendor__c=ava.Id;
            }
        }

    }
}