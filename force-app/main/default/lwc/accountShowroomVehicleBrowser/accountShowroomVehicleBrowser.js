import { LightningElement, wire, api, track } from 'lwc';
import getAllAccounts from '@salesforce/apex/AccountShowroomVehicleBrowserController.getAllAccounts';
import getShowroomsByAccountId from '@salesforce/apex/AccountShowroomVehicleBrowserController.getShowroomsByAccountId';
import getVehiclesByShowroomId from '@salesforce/apex/AccountShowroomVehicleBrowserController.getVehiclesByShowroomId';

export default class AccountShowroomVehicleBrowser extends LightningElement {
    accounts;
    showrooms;
    vehicles;
    @track vehicleId;
    @api numberOfPages;
    numberOfPages = 0; 

    get isZeroPage(){
        return this.numberOfPages === 0;
    }

    get isFirstPage(){
        return this.numberOfPages === 1;
    }

    get isSecondPage(){
        return this.numberOfPages === 2;
    }

    get isThirdPage(){
        return this.numberOfPages === 3;
    }

    handleButtonBackClick(event){
        this.numberOfPages--;
    }

    @wire(getAllAccounts)
    allAccounts({ error, data }) {
        if (data) {
            this.accounts = data;            
        } else if (error) {
            console.error(error);
        }
    }

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

    handleVehicleClick(event){
        const vehicleId = event.currentTarget.dataset.id;
        this.vehicleId = vehicleId;
        this.numberOfPages++;
    }
}