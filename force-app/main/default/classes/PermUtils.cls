public with sharing class PermUtils {
    
    @AuraEnabled
    public static string BLAHBLAH(){
        try {
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Boolean hasBrowseSolutions(){
        return SolutionsUtils.hasBrowseSolutions();
    }
}