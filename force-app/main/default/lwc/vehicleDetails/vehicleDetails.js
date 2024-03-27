/**
 * @author Adrianna Zajac <adrianna.zajac@accenture.com>
 * @date 25/03/2024
 * @description This class provides methods for handling vehicle interest checkbox.
 * 
 * @param recordId Id of chosen vehicle.
 */
import { LightningElement, api } from 'lwc';

export default class VehicleDetails extends LightningElement {
    @api recordId;

    handleSuccess() {}

    saveInterest(e) {
        this.template.querySelector('lightning-record-edit-form').submit();
    }
}