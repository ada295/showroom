/**
 * @author Adrianna Zajac <aadrianna.zajac@accenture.com>
 * @date 26/03/2024
 * @description This class contains test methods for the VehicleShowroomTrigger trigger.
 */
@isTest
public class AccShVehBrowserControllerTest {
    /**
   * @author Adrianna Zajac <aadrianna.zajac@accenture.com>
   * @date 26/03/2024
   * @description Test method that verifies if all accounts are returned alphabetically.
   */
    @isTest
    static void shouldReturnAllAccounts() {
        List<Account> generatedAccounts = TestDataFactory.createAccounts(3);

        Test.startTest();
        List<Account> accounts = AccountShowroomVehicleBrowserController.getAllAccounts();
        Test.stopTest();
    
        System.assertEquals(3, accounts.size(), 'Incorrect number of returned accounts.');
        for (Integer i = 0; i < accounts.size() - 1; i++) {
            System.assert(accounts[i].Name <= accounts[i + 1].Name,'Accounts are not sorted alphabetically');
          }
    }
}