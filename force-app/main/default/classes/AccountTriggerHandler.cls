/**
 * @description AccountTriggerHandler
 */
public with sharing class AccountTriggerHandler {

    private static final String USER_NAME = 'amitacertifications@gmail.com.learning.dev1-sfp';
    
    private static List<Product2> getRandomProducts() {
        return [SELECT Id, Name FROM Product2 LIMIT 3];
    }

    /**
     * @description assignUser
     * @param records
     */
    public static void assignUser(List<Account> records){
        Id userId = [SELECT Id FROM User WHERE UserName =:USER_NAME WITH SECURITY_ENFORCED]?.Id;
        for(Account acc: records){
            if (Schema.sObjectType.Account.fields.OwnerId.isUpdateable()) {
                acc.OwnerId = userId;
            }
        }
    }

    private static Map<Id, Map<String, Object>> getPricebookEntryMap(Set<Id> productIds) {
        Map<Id, Map<String, Object>> pricebookEntryMap = new Map<Id, Map<String, Object>>();
        
        List<PricebookEntry> pricebookEntries = [
            SELECT Id, Product2Id, UnitPrice 
            FROM PricebookEntry 
            WHERE Product2Id IN :productIds
        ];
        
        for (PricebookEntry pbe : pricebookEntries) {
            Map<String, Object> entryDetails = new Map<String, Object>{
                'PricebookEntryId' => pbe.Id,
                'UnitPrice' => pbe.UnitPrice
            };
            pricebookEntryMap.put(pbe.Product2Id, entryDetails);
        }
        
        return pricebookEntryMap;
    }

    public static void handleAfterInsert(List<Account> newAccounts) {
        List<Opportunity> opportunitiesToCreate = new List<Opportunity>();
        List<OpportunityLineItem> lineItemsToCreate = new List<OpportunityLineItem>();
        Set<Id> productIds = new Set<Id>();
        
        for (Account acc : newAccounts) {
            if (acc.CreateOpportunity__c) {
                Opportunity opp = new Opportunity(
                    Name = acc.Name + ' Opportunity',
                    AccountId = acc.Id,
                    CloseDate = Date.today().addDays(30),
                    StageName = 'Prospecting'
                );
                opportunitiesToCreate.add(opp);
            }
        }
        
        if (!opportunitiesToCreate.isEmpty()) {
            insert opportunitiesToCreate;
            
            // Assuming you have a method to get random products
            List<Product2> randomProducts = getRandomProducts();
            for (Product2 prod : randomProducts) {
                productIds.add(prod.Id);
            }
            
            Map<Id, Map<String, Object>> pricebookEntryMap = getPricebookEntryMap(productIds);
            
            for (Opportunity opp : opportunitiesToCreate) {
                for (Product2 prod : randomProducts) {
                    if (pricebookEntryMap.containsKey(prod.Id)) {
                        Map<String, Object> entryDetails = pricebookEntryMap.get(prod.Id);
                        OpportunityLineItem lineItem = new OpportunityLineItem(
                            OpportunityId = opp.Id,
                            PricebookEntryId = (Id)entryDetails.get('PricebookEntryId'),
                            Quantity = 1,
                            UnitPrice = (Decimal)entryDetails.get('UnitPrice')
                        );
                        lineItemsToCreate.add(lineItem);
                    }
                }
            }
            
            if (!lineItemsToCreate.isEmpty()) {
                insert lineItemsToCreate;
            }
        }
    }
}