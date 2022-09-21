import { LightningElement, api } from 'lwc';

export default class Childrens extends LightningElement {

    handleClick(event){
        var usrClick =  event.target.dataset.clickId;
        console.log('clicked => '+usrClick);

        this.dispatchEvent(new CustomEvent('childactivity',{detail: usrClick,bubbles:true,composed:false}));
        
    }
}