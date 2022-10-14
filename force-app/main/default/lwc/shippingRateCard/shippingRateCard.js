import { LightningElement, api, track, wire } from 'lwc';
import getShippingRate from '@salesforce/apex/GARP_MC_Shipping.getShippingRate';
import { util_isDefined, util_subscribeToMessages, util_dispatchMessage, util_console } from 'c/common';


export default class ShippingRateCard extends LightningElement {
    @api order={};

    @track sObjData={};
    hasCharge = false;
    rateNotFound = false;
    noAddress = false;
    componentSelector = "c-shipping-rate-card";

    connectedCallback() {
        util_console('initialize ship rate', this.order);
        if(util_isDefined(this,"order.address")) {
            this.getShippingRates(this.order)
        }
        util_subscribeToMessages(this,'shippingchange',this.handleMessage);    
    }

    handleMessage(message){
        if (util_isDefined(message,"data.channel") && message.data.channel == 'shippingchange') {
            
            util_console('receivedMessage', message.data.channel);

            if(util_isDefined(message,"data.payload")) {

                util_console('payload', message.data.payload);

                this.order = message.data.payload;
                this.getShippingRates(this.order)
            }
        }
    }

    getShippingRates(order) {

        if(util_isDefined(order)) {
            getShippingRate({rawJson: JSON.stringify(order)})
            .then(result =>{

                if(util_isDefined(result,"Shipping_Charge__c")) {
                    this.sObjData = result;
                    this.hasCharge = true;
                    this.rateNotFound = false;
                    this.noAddress = false;
                    
                    util_console('found rate', result);
    
                    util_dispatchMessage(this, 'shipping-fee-found', {charge: this.sObjData});
    
                } else {

                    util_console('rate not found');

                    this.sObjData={};
                    this.rateNotFound = true;
                    this.hasCharge = false;
                    this.noAddress = false;
                }
            })
            .catch(error =>{

                util_console('error', error);

                this.sObjData={};
                this.noAddress = true;
                this.hasCharge = false;
                this.rateNotFound = false;
                this.errorMsg = error;
            })            
        } else {
            this.noAddress = true;
            this.hasCharge = false;
            this.hasCharge = false;
        }
    }

}