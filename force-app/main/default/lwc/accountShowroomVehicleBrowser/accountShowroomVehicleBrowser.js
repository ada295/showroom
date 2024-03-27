/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 25/03/2024
 * @description This class contains methods for managing events related to accounts, showrooms and vehicles.
 * 
 * @param accounts List of all accounts.
 * @param showrooms List of showrooms which are connected with chosen account.
 * @param vehicles List of vehicles which are connected wirh chosen showroom.
 * @param vehicleId Id of chosen vehicle.
 * @param numberOfPages Number of the current page.
 */
import { LightningElement, wire, api, track } from 'lwc';
import getAllAccounts from '@salesforce/apex/AccountShowroomVehicleBrowserController.getAllAccounts';
import getShowroomsByAccountId from '@salesforce/apex/AccountShowroomVehicleBrowserController.getShowroomsByAccountId';
import getVehiclesByShowroomId from '@salesforce/apex/AccountShowroomVehicleBrowserController.getVehiclesByShowroomId';

export default class AccountShowroomVehicleBrowser extends LightningElement {
    accounts;
    showrooms;
    vehicles;
    @track vehicleId;
    @api numberOfPages = 0;
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method verifies if numberOfPages equals 0.
     */
    get isZeroPage(){
        return this.numberOfPages === 0;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method verifies if numberOfPages equals 1.
     */
    get isFirstPage(){
        return this.numberOfPages === 1;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method verifies if numberOfPages equals 2.
     */
    get isSecondPage(){
        return this.numberOfPages === 2;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method verifies if numberOfPages equals 3.
     */
    get isThirdPage(){
        return this.numberOfPages === 3;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method is fired when BackButton is clicked and decrements numberOfPages.
     */
    handleButtonBackClick(event){
        this.numberOfPages--;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method get all accounts.
     */
    @wire(getAllAccounts)
    allAccounts({ error, data }) {
        if (data) {
            this.accounts = data;            
        } else if (error) {
            console.error(error);
        }
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method is fired when account record is clicled, gets showrooms by accountId and increments number of pages.
     * 
     * @param accountId Id of chosen account.
     */
    handleAccountClick(event) {
        const accountId = event.currentTarget.dataset.id;
        getShowroomsByAccountId({ accountId })
            .then(result => {
                this.showrooms = result;

            })
            .catch(error => {
                console.error(error);
            });
            this.numberOfPages++;          
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method is fired when showroom record is clicled, gets vehocles by showroomId and increments number of pages.
     * 
     * @param showroomId Id of chosen showroom.
     */
    handleShowroomClick(event) {
        const showroomId = event.currentTarget.dataset.id;
        getVehiclesByShowroomId({ showroomId })
            .then(result => {
                this.vehicles = result;
            })
            .catch(error => {
                console.error(error);
            });
            this.numberOfPages++;
    }
    /**
     * @author Adrianna Zajac <adrianna.zajac@accenture.com>
     * @date 25/03/2024
     * @description The method is fired when vehicle record is clicled and increments number of pages.
     * 
     * @param vehicleId Id of chosen vehicle.
     */
    handleVehicleClick(event){
        const vehicleId = event.currentTarget.dataset.id;
        this.vehicleId = vehicleId;
        this.numberOfPages++;
    }
}