trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after update) {
    if(Trigger.isBefore && Trigger.isUpdate) {
            for(Opportunity opp : Trigger.New) {
            if(opp.Amount < 5000) {
                Trigger.new[0].addError('Opportunity amount must be greater than 5000');
            }
        }
    }
    
    if (Trigger.isBefore && Trigger.isDelete) { 
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

    if(Trigger.isAfter && Trigger.isUpdate){

    }
}