/**
 * @description AccountTriggerHandler
 */
public with sharing class AccountTriggerHandler {

    /**
     * @description assignUser
     * @param records
     */
    public static void assignUser(List<Account> records){
        User u = [SELECT Id FROM User WHERE UserName ='amitacertifications@gmail.com.learning.dev1-sfp' WITH SECURITY_ENFORCED];
        for(Account acc: records){
            if (Schema.sObjectType.Account.fields.OwnerId.isUpdateable()) {
                acc.OwnerId = u.Id;
            }
        }
    }
}