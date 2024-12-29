/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 12-18-2024
 * @last modified by  : Amit Singh
**/
public with sharing class DataTableController {
    
    @AuraEnabled(cacheable=true)
    public static Object getContactList(){
        return [SELECT Id, Name, Email, Phone, AccountId, Account.Name, OwnerId, Owner.Name FROM Contact WHERE AccountId <> null LIMIT 10];
    }
}