import { LightningElement, wire, api, track } from 'lwc';
import getAllAccounts from '@salesforce/apex/AccountShowroomVehicleBrowserController.getAllAccounts';
import getShowroomsByAccountId from '@salesforce/apex/AccountShowroomVehicleBrowserController.getShowroomsByAccountId';
import getVehiclesByShowroomId from '@salesforce/apex/AccountShowroomVehicleBrowserController.getVehiclesByShowroomId';

const COLUMNS = [
    { label: 'Serial number', fieldName: 'Name', type: 'text' },
    { label: 'Brand', fieldName: 'Brands__c', type: 'text' },
    { label: 'Model', fieldName: 'Model__c', type: 'text' }
];

export default class AccountShowroomVehicleBrowser extends LightningElement {
    accounts;
    showrooms;
    @api vehicles;
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
            // Handle error
        }
    }

    handleAccountClick(event) {
        const accountId = event.currentTarget.dataset.id;
        getShowroomsByAccountId({ accountId })
            .then(result => {
                this.showrooms = result;
            })
            .catch(error => {
                // Handle error
            });
            this.numberOfPages++;
            console.log('page')
            console.log(this.numberOfPages);
            
    }

    handleShowroomClick(event) {
        console.log("ddddd");
        const showroomId = event.currentTarget.dataset.id;
        getVehiclesByShowroomId({ showroomId })
            .then(result => {
                this.vehicles = result;
            })
            .catch(error => {
                // Handle error
            });
            this.numberOfPages++;
    }

    get columns() {
        return COLUMNS;
    }

    // handleRowAction(event){
    //     const vehicleId = event.detail.row.Id;
    //     console.log("Action");
    //     console.log(vehicleId);
    // }

    handleVehicleClick(event){
        const vehicleId = event.currentTarget.dataset.id;
        this.vehicleId = vehicleId;
        console.log("VehicleId: " + this.vehicleId);
        this.numberOfPages++;
    }

    // handleInterestChange(event) {
    //     const vehicleId = event.currentTarget.dataset.id;
    //     const interested = event.target.checked;

    //     // Update 'interested' field for the vehicle
    //     updateVehicleInterest({ vehicleId, interested })
    //         .then(result => {
    //             // Handle success
    //             console.log('Vehicle interest updated successfully.');
    //         })
    //         .catch(error => {
    //             // Handle error
    //             console.error('Error updating vehicle interest:', error);
    //         });
    // }
}