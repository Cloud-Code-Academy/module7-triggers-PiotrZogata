trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after update, after delete) {

    switch on Trigger.operationType {
        when AFTER_UPDATE {
            for(Opportunity opp : Trigger.New) {
                if(opp.Amount < 5000) {
                    Trigger.new[0].addError('Opportunity amount must be greater than 5000');
                }
            }
        }
        when BEFORE_DELETE {
             // Collect Account IDs from Opportunities 
        Set<Id> accountIds = new Set<Id>(); 
        for (Opportunity opp : Trigger.old) {
             accountIds.add(opp.AccountId); 
        } 
             
        // Query Accounts to get their Industries 
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :accountIds]); 
             
        // Check conditions and add error 
        for (Opportunity opp : Trigger.old) {
            if (opp.StageName == 'Closed Won' && accountMap.get(opp.AccountId).Industry == 'Banking') {
                    opp.addError('Cannot delete closed opportunity for a banking account that is won'); 
                                
            }
        }
        }
        when BEFORE_UPDATE {
        // Collect Account IDs from Opportunities 
            Set<Id> accountIds = new Set<Id>(); 
                for (Opportunity opp : Trigger.new) { 
                    accountIds.add(opp.AccountId); 
        }      
        // SOQL query to get Account IDs and their associated Contacts with the title 'CEO' 
        List<Account> accountsWithContacts = [SELECT Id, (SELECT Id, FirstName, LastName, Title FROM Contacts WHERE Title = 'CEO') FROM Account WHERE Id IN :accountIds];

        // Map to store Account IDs and their associated Contacts 
        Map<Id, List<Contact>> accountToContactsMap = new Map<Id, List<Contact>>(); 

        // Populate the map with the query results 
        for (Account acc : accountsWithContacts) {
            accountToContactsMap.put(acc.Id, acc.Contacts); 
        } 

        for (Opportunity opp : Trigger.new) { 
            if (accountToContactsMap.containsKey(opp.AccountId) && !accountToContactsMap.get(opp.AccountId).isEmpty()) {
            opp.Primary_Contact__c = accountToContactsMap.get(opp.AccountId)[0].Id; 
            } 
        } 
        } 
    }
}    

  