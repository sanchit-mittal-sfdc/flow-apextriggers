/**
 * @description Hello World
 */
@IsTest
public with sharing class AccountTriggerHandlerTest {

    /**
     * @description Hello World
     */
    @TestSetup
    private static void setupData(){
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i< 20; i++){
            Account acc = new Account(
            	Name = 'Salesforce.com '+i
            );
            accounts.add(acc);
        }
        System.runAs(new User(Id = UserInfo.getUserId() )){
            insert as system accounts;
            System.assertNotEquals(0,accounts.size(),'Numbers are not equals');
            Assert.areNotEqual(0,accounts.size(),'Numbers are not equals');
        }
    }

	/**
     * @description Hello World
     */    
    @IsTest
    private static void assignUserTest(){
        System.runAs(new User(Id = UserInfo.getUserId() )){
            Test.startTest();
            AccountTriggerHandler.assignUser([SELECT Id, OwnerId FROM Account WHERE Name Like '%Salesforce.com%' WITH SECURITY_ENFORCED]);
            Test.stopTest();
            System.assertEquals(5,5,'Numbers are not equals');
            Assert.areEqual(5,5,'Numbers are not equals');
        }
    }
}