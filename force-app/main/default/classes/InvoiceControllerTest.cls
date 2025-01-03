/**
 * @description       : 
 * @author            : Amit Singh
 * @group             : 
 * @last modified on  : 01-02-2025
 * @last modified by  : Amit Singh
**/
@isTest
public class InvoiceControllerTest {
    
    @testSetup
    static void setup() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create a test contact under the account
        Contact testContact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            AccountId = testAccount.Id,
            Email = 'test.contact@example.com'
        );
        insert testContact;

        Sponsor__c sponsor = new Sponsor__c(
            Name = 'Test Sponsor',
            PrimaryContact__c = testContact.Id,
            Status__c = 'New',
            Tier__c = 'Gold',
            Website__c = 'http://www.example.com',
            Amount__c = 5000
        );
        insert sponsor;

        Event__c testEvent = new Event__c(
            Name = 'Test Event',
            Start_Date__c = System.now(),
            End_Date__c = System.now().addDays(30),
            Status__c = 'Draft',
            ShortDescription__c = 'Short Description',
            TicketPrefix__c = 'TST',
            InvoicePrefix__c = 'INV'
        );
        insert testEvent;
        // Create a test invoice
        Invoice__c testInvoice = new Invoice__c(
            Name = 'Test Invoice',
            Event__c = testEvent.Id,
            Description__c = 'Test Description',
            Status__c = 'Draft',
            DueDate__c = Date.today().addDays(3),
            InvoiceDate__c = Date.today(),
            Sponsor__c = sponsor.Id
        );
        insert testInvoice;

        // Create a test product
        Product2 testProduct = new Product2(
            Name = 'Test Product',
            ProductCode = 'TP001',
            IsActive = true
        );
        insert testProduct;

        // Create test invoice line items
        InvoiceLine__c testLineItem = new InvoiceLine__c(
            Invoice__c = testInvoice.Id,
            Description__c = 'Test Line Item Description',
            Product__c = testProduct.Id,
            Quantity__c = 5,
            Amount__c = 200
        );
        insert testLineItem;
    }

    @isTest
    static void testInvoiceController() {
        // Set the current page parameters
        Test.setCurrentPageReference(new PageReference('/apex/InvoicePage'));
        ApexPages.currentPage().getParameters().put('id', [SELECT Id FROM Invoice__c LIMIT 1].Id);

        // Instantiate the controller
        InvoiceController controller = new InvoiceController();

        // Verify the controller's behavior
        System.assertNotEquals(null, controller.invoice, 'Invoice should not be null');
        System.assertEquals('Test Invoice', controller.invoice.Name, 'Invoice name should be "Test Invoice"');
        System.assertEquals(1, controller.invoice.Invoice_Line_Items__r.size(), 'There should be one invoice line item');
        System.assertNotEquals('Test Line Item', controller.invoice.Invoice_Line_Items__r[0].Name, 'Line item name should be "Test Line Item"');
    }
}