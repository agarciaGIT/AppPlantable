/******************************************************************************************************************************************
 * DESCRIPTION  :   after insert/update trigger. automate shipment record automations and subscripiton record update on transaction completed
 * HELPER CLASS :   Plant_TransactionTiggerHelper
 * MAIN CLASS   :	Plant_TransactionTigger
 * 
 * CREATED BY   :   HIC Dev(25 May)
 ******************************************************************************************************************************************/

@istest
public class Plant_TransactionTigger_Test {
    @testSetup
    public static void setup(){
         
        plantable_TriggersSwitch__c c=new plantable_TriggersSwitch__c();
        c.name='plantableHIC_Switches';
        c.pauseChargentTransaction_Trigger__c=false;
        insert c;
        
        Account accounts = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts;
        
        Order order = new order(Accountid=accounts.id, EffectiveDate=System.today(), Status ='Draft');
        insert order;
        Plant_Shipping_Date__c ShippingDate= Plant_TestDataFactory.createShippingDate(1)[0];
        insert ShippingDate;
        
        Meal__c meal=Plant_TestDataFactory.createMeal(1)[0];
        insert meal;
        
        Plant_Meal_Selection__c Mealselection=Plant_TestDataFactory.createMealSelection(1)[0];
        insert MealSelection;
        
        Plant_Shipping_Address__c shippingAddress = Plant_TestDataFactory.createShippingAddress(1)[0];
        shippingAddress.Plant_Account__c= accounts.id;
        insert shippingAddress;
        
        Plant_Delivery_Schedule__c DeliverySchedule= Plant_TestDataFactory.createDeliverySchedule(1, 2)[0];
        insert DeliverySchedule;
        Plant_Order_Properties__c orderProperty = Plant_TestDataFactory.createOrderProperties(1)[0];
        orderProperty.Plant_Account__c= accounts.id;
        orderProperty.Shipping_Address__c=shippingAddress.id;
        insert orderProperty;
        
        ChargentOrders__ChargentOrder__c corder=new ChargentOrders__ChargentOrder__c();
        corder.ChargentOrders__Account__c=accounts.id;
        corder.Order__c=order.id;
        corder.ChargentOrders__Payment_Status__c='Recurring';
        corder.ChargentOrders__Payment_Start_Date__c=System.today();
        corder.ChargentOrders__Charge_Amount__c=2300;
        insert corder;
        
        ChargentBase__Gateway__c cGateway=new ChargentBase__Gateway__c();
        cGateway.ChargentBase__Accounting_Seed_Integration__c=true;
        cGateway.ChargentBase__Active__c=false;
        insert cGateway;
        
        ChargentOrders__Transaction__c cTransaction =new ChargentOrders__Transaction__c();
        cTransaction.ChargentOrders__Account__c=accounts.id;
        cTransaction.ChargentOrders__Amount__c=2300;
        cTransaction.ChargentOrders__Amount_available_for_Refund__c=200;
        cTransaction.ChargentOrders__Bank_Account_Type__c='Savings';
        cTransaction.ChargentOrders__Type__c='Refund';
        cTransaction.ChargentOrders__Response_Status__c='Approved';
        cTransaction.ChargentOrders__Response__c='OK';
        
        cTransaction.Order__c=order.id;
        cTransaction.ChargentOrders__Payment_Method__c='Cash';
        String s=cGateway.id;
        cTransaction.ChargentOrders__Gateway_ID__c=s;
        cTransaction.ChargentOrders__Gateway__c=cGateway.id;
        cTransaction.ChargentOrders__Gateway_Date__c=system.today();
        cTransaction.ChargentOrders__Cash_Receipt__c='yxtubnew';
        cTransaction.ChargentOrders__Order__c=corder.id;
        insert cTransaction;
        }
    
    public static testMethod void Transaction_Test2(){
        ChargentOrders__Transaction__c cTransaction=[Select id, ChargentOrders__Type__c from ChargentOrders__Transaction__c limit 1];
        cTransaction.ChargentOrders__Type__c='Charge';
        Update cTransaction;
    }
    
    
    public static testMethod void Transaction_Test3(){
        Account accounts1 = Plant_TestDataFactory.createAccounts(1)[0];
        insert accounts1;
        
        Order order1 = new order(Accountid=accounts1.id, EffectiveDate=System.today(), Status ='Draft');
        
        insert order1;
        
        
        ChargentOrders__ChargentOrder__c corder1=new ChargentOrders__ChargentOrder__c();
        corder1.ChargentOrders__Account__c=accounts1.id;
        corder1.Order__c=order1.id;
        corder1.ChargentOrders__Payment_Status__c='Recurring';
        corder1.ChargentOrders__Payment_Start_Date__c=System.today();
        corder1.ChargentOrders__Charge_Amount__c=2300;
        insert corder1;
        
        ChargentBase__Gateway__c cGateway1=new ChargentBase__Gateway__c();
        cGateway1.ChargentBase__Accounting_Seed_Integration__c=true;
        cGateway1.ChargentBase__Active__c=false;
        insert cGateway1;  
        
        ChargentOrders__Transaction__c cTransaction1 =new ChargentOrders__Transaction__c();
        cTransaction1.ChargentOrders__Account__c=accounts1.id;
        cTransaction1.ChargentOrders__Amount__c=2300;
        cTransaction1.ChargentOrders__Amount_available_for_Refund__c=200;
        cTransaction1.ChargentOrders__Bank_Account_Type__c='Savings';
        cTransaction1.ChargentOrders__Type__c='Charge';
        cTransaction1.ChargentOrders__Response_Status__c='Approved';
        cTransaction1.ChargentOrders__Response__c='OK';
        
        cTransaction1.Order__c=order1.id;
        cTransaction1.ChargentOrders__Payment_Method__c='Cash';
        String s=cGateway1.id;
        cTransaction1.ChargentOrders__Gateway_ID__c=s;
        cTransaction1.ChargentOrders__Gateway__c=cGateway1.id;
        cTransaction1.ChargentOrders__Gateway_Date__c=system.today();
        cTransaction1.ChargentOrders__Cash_Receipt__c='yxtubnew';
        cTransaction1.ChargentOrders__Order__c=corder1.id;
        insert cTransaction1;
        }
}