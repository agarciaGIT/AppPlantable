import { LightningElement, track, wire, api } from "lwc";  
  import findRecords from "@salesforce/apex/Plant_LwcLookupController.findRecords";  
  export default class plant_LwcLookup extends LightningElement {  
  @track recordsList;  
  @track searchKey = "";  
  @api selectedValue;  
  @api selectedRecordId;  
  @api objectApiName;  
  @api iconName;  
  @api lookupLabel; 
  @api placeHolderName; 
  @api isRequired = false;
  @api userRoleWise = false;
  @api accountId;
  @track message;  
  @api disablelookup = false;
  @track test = "test";
  onLeave(event) {  
    setTimeout(() => {  
      this.searchKey = "";  
      this.recordsList = null;  
    }, 300);  
  }  
    
  onRecordSelection(event) {  
    console.log('hello')
    this.selectedRecordId = event.target.dataset.key;  
    this.selectedValue = event.target.dataset.name;  
    this.searchKey = "";  
    this.onSeletedRecordUpdate();  
  }  
   
  handleKeyChange(event) {  
    const searchKey = event.target.value;  
    this.searchKey = searchKey;  
    this.getLookupResult();  
  }  
   
  @api removeRecordOnLookup(event) {  
    this.searchKey = "";  
    this.selectedValue = null;  
    this.selectedRecordId = null;  
    this.recordsList = null;  
    this.onSeletedRecordUpdate();  
 }  

  getLookupResult() {  
    console.log('this..',this.accountId)
    findRecords({ searchKey: this.searchKey, objectName : this.objectApiName, userRoleWise : this.userRoleWise ,accountId:(this.accountId != undefined && this.accountId != null ? this.accountId : '')})  
      .then((result) => {  
        if (result.length===0) {  
          this.recordsList = [];  
          this.message = "No Records Found";  
          } else {  
          this.recordsList = result;  
          this.message = "";  
          }  
          this.error = undefined;  
      })  
      .catch((error) => {  
        console.log('error lookup::',error)
      this.error = error;  
      this.recordsList = undefined;  
      });  
  }  
   
  onSeletedRecordUpdate(){  
    const passEventr = new CustomEvent('recordselection', {  
      detail: { selectedRecordId: this.selectedRecordId, selectedValue: this.selectedValue, object: this.objectApiName }  
      });  
      this.dispatchEvent(passEventr);  
  }  

  get objectOrder(){
    return (this.objectApiName == 'Order' ? true : false);
  }
}