/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-02-2025
 * @last modified by  : Amit Singh
**/
public without sharing class InvoiceController {
    public Invoice__c invoice { get; set; }

    public InvoiceController() {
        
        String invoiceId = ApexPages.currentPage().getParameters().get('id');
        invoice = [SELECT Id, Name, Event__c, Description__c, Status__c, DueDate__c, GrandTotal__c, Discount_Amount__c,
                   	TaxAmount__c, Quantity__c, InvoiceDate__c, Sponsor__c,
                   (SELECT Id, Name, Description__c, Product__c, Product__r.Name, Quantity__c, Amount__c, TotalAmount__c,TotalAfterDiscount__c, GrandTotal__c,
                    Discount__c, DiscountAmount__c, Tax__c, TaxAmount__c
                    FROM Invoice_Line_Items__r
                   )
                   FROM
                   	Invoice__c
                   WHERE Id = :invoiceId
                  ];
    }
}