import { LightningElement, api } from 'lwc';

export default class VehicleDetails extends LightningElement {
    @api recordId;

    saveInterest(e) {
        this.template.querySelector('lightning-record-edit-form').submit();
    }
}