trigger AccountTrigger on Account (before insert, after insert) {
    List<Account> accListToUpdate = new List<Account>();
    if(Trigger.isBefore && Trigger.isInsert){
    for(Account acc : Trigger.New) {
        //check if account is null on contact
        if(acc.Type == null ) {
            acc.Type = 'Prospect';
        }
        if(acc.ShippingStreet != null && acc.ShippingPostalCode != null && acc.ShippingCountry != null && acc.ShippingCity != null && acc.ShippingState != null) {
            acc.BillingStreet = acc.ShippingStreet;
            acc.BillingPostalCode = acc.ShippingPostalCode;
            acc.BillingCountry = acc.ShippingCountry;
            acc.BillingCity = acc.ShippingCity;
            acc.BillingState = acc.ShippingState;
        }
        if(acc.Phone != '' && acc.Website != '' && acc.Fax != '' ) {
            acc.Rating = 'Hot';
        }
    }    
}
    if(Trigger.isAfter && Trigger.isInsert){
        List<Contact> listOfContact = new List<Contact>();
        for(Account acc : Trigger.New) {
            Contact con = new Contact(LastName = 'DefaultContact', Email = 'default@email.com', AccountId = acc.Id);
            listOfContact.add(con);
        }
        insert listOfContact;        
    }
}