global class MonthlyLeaseExpiryBatch implements Database.Batchable<SObject>,Schedulable{
    
    global void execute(SchedulableContext context){
        Database.executeBatch(new MonthlyLeaseExpiryBatch());
    }

    global Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator([
            SELECT Id, Name,Terms__c, End_Date__c, Tenant__r.Email__c, Tenant__r.Name 
            FROM Lease_Agreement__c 
            WHERE End_Date__c = :System.today().addDays(30) 
            AND Tenant__r.Email__c != NULL
        ]);
    }

    global void execute(Database.BatchableContext context,List<Lease_Agreement__c> leaseAgreementList){
        for(Lease_Agreement__c lease:leaseAgreementList){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setToAddresses(new String[]{lease.Tenant__r.Email__c});
            email.setSubject('Lease Expiry Reminder for ' + lease.Tenant__r.Name);
            
            String emailBody = 'Dear ' + lease.Tenant__r.Name + ',<br/><br/>' +
                               'Your lease agreement "' + lease.Terms__c + '" is set to expire on ' + lease.End_Date__c + '.<br/>' +
                               'Please take the necessary action to renew or close the agreement.<br/><br/>' +
                               'Thank you,<br/>Real Estate Management Team';
            
            email.setHtmlBody(emailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email });
        }
    }

    global void finish(Database.BatchableContext context){
        system.debug('Monthly Lease Expiry Batch completed.');
    }
}