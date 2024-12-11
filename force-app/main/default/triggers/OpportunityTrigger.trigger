trigger OpportunityTrigger on Opportunity (before insert, before update) {
    if(Trigger.isBefore && Trigger.isUpdate) {
            for(Opportunity opp : Trigger.New) {
            if(opp.Amount < 5000) {
                Trigger.new[0].addError('Opportunity amount must be greater than 5000');
            }
        }
    }
}