import { api, LightningElement, track, wire } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import plant_Authentication_Token__c from "@salesforce/schema/Account.plant_Authentication_Token__c";
import validateAccessToken from "@salesforce/apex/plant_Edit_OrderController.validateAccessToken";
import updateCustomerMealList from "@salesforce/apex/plant_Edit_OrderController.updateCustomerMealList";
import updatePaymentDetails from "@salesforce/apex/plant_Edit_OrderController.updatePaymentDetails";
import updateShippingDetails from "@salesforce/apex/plant_Edit_OrderController.updateShippingDetails";
import updateDeliveryDate from "@salesforce/apex/plant_Edit_OrderController.updateDeliveryDate";
import getOrderDetails from "@salesforce/apex/plant_Edit_OrderController.getOrderDetails";
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getMeals from "@salesforce/apex/Plant_NewOrderCustomerController.getMeals";

export default class plant_Edit_Order extends LightningElement {
	@api recordId;
	@track paymentDetailList = new Array();
	@track showSpinner = false;
	@track selectedOrder = {Id : '' , OrderNumber : ''};
	@track availableDeliveryDatesList = new Array();
	@track shippingDetails = {};
	@track selectedMealList = new Array();
	@track authorisationTokenExpired = true;
	@track selectedDeliveryDate = '';
	@track selectedPaymentCard = {Id : '' , Name : ''};
	@track paymentMethodsList = new Array();
	@track selectedMealSelectionId  = '';
	@track orderDetailsData = {shippingDetails : {} , paymentDetailList: {} , availableDeliveryDatesList : {}};
	@track showEditView = true;
	@track mealsVisibleList = new Array();
	@track customerAccount = { "Id" : '',"Token" : '' }

	connectedCallback(){
		this.showSpinner = true;
		getMeals()
			.then(response => {
				this.showSpinner = false;
				response = JSON.parse(response);
				if (response.statusCode == 200) {
					this.allMealsBackupList = response.result.resultArr;
					console.log('allMealsBackupList:::'+JSON.stringify(response.result.resultArr))
				}

			}).catch(error => {
				this.showSpinner = false;
				console.log('error::get meals::', error);
			})
	}

	@wire(getRecord, { recordId: "$recordId", layoutTypes: ['Full'], modes: ['View'] })
	fetchCustomerAccount({data,error}){
		this.showSpinner = true
		if(data){
			data = JSON.parse(JSON.stringify(data));
			this.customerAccount.Id = data.id;
			this.customerAccount.Token = getFieldValue(data, plant_Authentication_Token__c);
			if(this.customerAccount.Token && this.customerAccount.Token != ''){
				validateAccessToken({token : this.customerAccount.Token})
				.then(response =>{
					this.showSpinner = false;
					if(response.includes('Success')){
						this.authorisationTokenExpired = false;
						console.log('Token Is Available');
					}
					else{
						this.authorisationTokenExpired = true;
						this.showCustomErrorMessage(response , 'Error' , 'error' , 'dismissable');
					}
				}).catch(error =>{
				this.showSpinner = false;
				})
			}
			else{
				this.showSpinner = false;
			}
			console.log('Account Id',this.customerAccount.Id);
			console.log('Token',this.customerAccount.Token);
		}
		else{
			this.showSpinner = false;
		}
	}

	handleRecordSelection(event){
		let object = event.detail.object;
		this.selectedOrder.Id = (event.detail.selectedRecordId ? event.detail.selectedRecordId : '');
		this.selectedOrder.OrderNumber = (event.detail.selectedValue ? event.detail.selectedValue : '');
		if(this.selectedOrder.Id && this.selectedOrder.Id !='' && this.selectedOrder.OrderNumber && this.selectedOrder.OrderNumber != '' ){
			this.showSpinner = true;
			getOrderDetails({orderId : this.selectedOrder.Id , authorisationToken: (this.customerAccount.Token && this.customerAccount.Token != '' ? this.customerAccount.Token : '')})
			.then(orderResponse =>{
				console.log('orderResponse:::',orderResponse);
				orderResponse = JSON.parse(orderResponse);
				this.orderDetailsData = orderResponse;
				this.shippingDetails = (orderResponse.hasOwnProperty('shippingDetails') ? orderResponse.shippingDetails : {});
				if(orderResponse.hasOwnProperty('availableDeliveryDatesList') && orderResponse.availableDeliveryDatesList.hasOwnProperty('availableDates') && 
				orderResponse.availableDeliveryDatesList.availableDates.hasOwnProperty('result') && orderResponse.availableDeliveryDatesList.availableDates.result.hasOwnProperty('resultMap') 
				&& orderResponse.availableDeliveryDatesList.availableDates.result.resultMap && Object.keys(orderResponse.availableDeliveryDatesList.availableDates.result.resultMap).length > 0 ){

					for (let key in orderResponse.availableDeliveryDatesList.availableDates.result.resultMap) {
						this.availableDeliveryDatesList = [ ...this.availableDeliveryDatesList, {label : key , value : key} ]
					}
				}
				else{
					this.availableDeliveryDatesList = []
				}
				if(this.availableDeliveryDatesList.length > 0 ){
					this.selectedDeliveryDate = (this.shippingDetails.hasOwnProperty('deliveryDate') && this.shippingDetails.deliveryDate ? this.shippingDetails.deliveryDate : '');
				}
				this.selectedPaymentCard.Id = (this.shippingDetails.hasOwnProperty('paymentMethodId') &&  this.shippingDetails.paymentMethodId && this.shippingDetails.paymentMethodId != '' ?  this.shippingDetails.paymentMethodId : '');
				this.selectedPaymentCard.Name = (this.shippingDetails.paymentMethodName && this.shippingDetails.paymentMethodName != '' ? this.shippingDetails.paymentMethodName : '' )
				if(	orderResponse.hasOwnProperty('paymentDetailList')  && orderResponse.paymentDetailList.hasOwnProperty('paymentDetailList') && orderResponse.paymentDetailList.paymentDetailList && orderResponse.paymentDetailList.paymentDetailList.hasOwnProperty('result') && 
					orderResponse.paymentDetailList.paymentDetailList.result.hasOwnProperty('resultArr') && orderResponse.paymentDetailList.paymentDetailList.result.resultArr && orderResponse.paymentDetailList.paymentDetailList.result.resultArr.length > 0 ){
						this.paymentMethodsList = orderResponse.paymentDetailList.paymentDetailList.result.resultArr;
					for(let data of orderResponse.paymentDetailList.paymentDetailList.result.resultArr){
						this.paymentDetailList =  [ ...this.paymentDetailList, {label : '...' + data.cardInformation.card_Last_4_Digits + '(' + data.cardInformation.card_Type + ')' , value : data.paymentId} ]
					}
				}
				else{
					this.paymentDetailList = new Array();
					this.paymentMethodsList = new Array();
				}
				if(	orderResponse.hasOwnProperty('selectedMealList')  && orderResponse.selectedMealList.hasOwnProperty('selectedMealList') && orderResponse.selectedMealList.selectedMealList && orderResponse.selectedMealList.selectedMealList.hasOwnProperty('result') && 
				orderResponse.selectedMealList.selectedMealList.result.hasOwnProperty('resultArr') && orderResponse.paymentDetailList.paymentDetailList.result.resultArr && orderResponse.paymentDetailList.paymentDetailList.result.resultArr.length > 0 ){
					this.selectedMealSelectionId =  (orderResponse.selectedMealList.selectedMealList.result.resultArr[0].hasOwnProperty('mealSelectionId') && orderResponse.selectedMealList.selectedMealList.result.resultArr[0].mealSelectionId ? orderResponse.selectedMealList.selectedMealList.result.resultArr[0].mealSelectionId : '');
					//for(let data of orderResponse.selectedMealList.selectedMealList.result.resultArr){
						 orderResponse.selectedMealList.selectedMealList.result.resultArr[0].mealList.forEach(meal =>{
							this.selectedMealList = [...this.selectedMealList , {Name : meal.meal , mealID : meal.mealId , quantity : meal.quantity , mealSelectionMealId : this.selectedMealSelectionId }]
						});
						//this.paymentDetailList =  [ ...this.paymentDetailList, {label : data.cardInformation.name , value : data.paymentId} ]
					//}
				}
				else{
					this.paymentDetailList = new Array();
				}
				//console.log('orderResponse:::'+JSON.stringify(orderResponse));
				//console.log('paymentDetailList:::',this.paymentDetailList);
				//console.log('shippingDetails:::',this.shippingDetails);
				//console.log('availableDeliveryDatesList:::',this.availableDeliveryDatesList);
				//console.log('selectedMealList:::',this.selectedMealList);
				this.showSpinner = false;
			}).catch(error =>{
				this.showSpinner = false;
				console.log('order Error::',error);
			})
		}
		else{
			this.shippingDetails = {}
			this.availableDeliveryDatesList = new Array();
			this.paymentDetailList = new Array();
			this.selectedMealList = new Array();
			this.selectedMealSelectionId = '';
			this.paymentMethodsList = new Array();
			this.selectedOrder = {Id : '' , OrderNumber : ''};
			this.selectedPaymentCard = {Id : '' , Name : ''};
		}
	}

	handleButton(event){
		console.log('eveee',event.target.value)
		if(event.target.value == 'Customize'){
			this.showEditView = false;
		}

		else if(event.target.value == 'Save'){
			this.showEditView = true;
		}

		else if(event.target.value == 'Update Meal'){
			if(this.selectedMealList.length > 0 ){
				this.showSpinner = true;
				let mealListToUpdate = [];
				this.selectedMealList.forEach(element =>{
					mealListToUpdate.push({mealId : (element.mealID && element.mealID != '' ? element.mealID : (element.mealId && element.mealId ? element.mealId : '')) , quantity : element.quantity , mealSelectionMealId : (element.mealSelectionMealId && element.mealSelectionMealId != '' ? element.mealSelectionMealId : '') });
				})
				console.log('selectedMealList::',this.selectedMealList);
				console.log('update meal list:;',JSON.stringify( {authenticationToken : this.customerAccount.Token , OrderNumber : this.selectedOrder.OrderNumber, mealList : mealListToUpdate}));
				updateCustomerMealList({mealList : JSON.stringify( {authenticationToken : this.customerAccount.Token , OrderNumber : this.selectedOrder.OrderNumber, mealList : mealListToUpdate})})
				.then(response =>{
					response = JSON.parse(response);
					if(response.hasOwnProperty('statusCode') && response.statusCode == '200'){
						if(response.hasOwnProperty('msg') && response.msg){
						this.showCustomErrorMessage(response.msg , 'Success' ,'success' , 'dismissable');
						}
					}
					else{
						this.showCustomErrorMessage(response.msg , 'Error' ,'error' , 'sticky');
					}
					this.showSpinner = false;
					console.log('update Meal Response::',response)
				}).catch(error =>{
					console.log('update Meal Error:',error);
					this.showSpinner = false;
				})
			}
			else{
				this.showCustomErrorMessage('Please Selected Meals' , 'Error' , 'error' , 'dismissable');
			}
			console.log('Update Meal')
		}

		else if(event.target.value == 'Update Shipping Address'){
			this.showSpinner = true;
			let shippingUpdateJSON = {
				orderNumber : (this.selectedOrder.OrderNumber && this.selectedOrder.OrderNumber != '' ? this.selectedOrder.OrderNumber : '' ),
				authenticationToken : (this.customerAccount.Token && this.customerAccount.Token != '' ? this.customerAccount.Token : ''),
				shippingAddressId : ''/* (this.shippingDetails.shippingAddressId && this.shippingDetails.shippingAddressId != '' ? this.shippingDetails.shippingAddressId : '') */,
				deliveryDate : (this.shippingDetails.deliveryDate && this.shippingDetails.deliveryDate != '' ? this.shippingDetails.deliveryDate : ''),
				shippingAddress : {
					street1 : (this.shippingDetails.street1 ? this.shippingDetails.street1 : ''),
					street2 : (this.shippingDetails.street2 ? this.shippingDetails.street2 : ''),
					street3 : (this.shippingDetails.street3 ? this.shippingDetails.street3 : ''),
					city : (this.shippingDetails.city ? this.shippingDetails.city : ''),
					state : (this.shippingDetails.state ? this.shippingDetails.state :''),
					zip : (this.shippingDetails.zip ? this.shippingDetails.zip : ''),
					country : (this.shippingDetails.country ? this.shippingDetails.country :''),
					phone : (this.shippingDetails.phone ? this.shippingDetails.phone : ''),
					canSMS : (this.shippingDetails.canSMS && this.shippingDetails.canSMS !='' ? String(true) == this.shippingDetails.canSMS : false)
				}
			}
			console.log('shippingUpdateJSON::::',JSON.stringify(shippingUpdateJSON));
			
			updateShippingDetails({ shippingJSON : JSON.stringify(shippingUpdateJSON) })
			.then(response =>{
				response = JSON.parse(response);
				if(response.hasOwnProperty('statusCode') && response.statusCode =='200'){
					this.showCustomErrorMessage((response.hasOwnProperty('msg') ? response.msg : '') , 'Success', 'success' , 'dismissable')
				}
				else{
					this.showCustomErrorMessage((response.hasOwnProperty('msg') &&  response.msg ? response.msg : 'Unknown Error' ) , 'Error' ,'error' , 'sticky');
				}
				this.showSpinner = false;
				console.log('shipping update Response::',response);
			}).catch(error =>{
				console.log('Shipping Update Error:::',error);
				this.showSpinner = false;
			})
		}

		else if(event.target.value == 'Update Delivery Date'){
			console.log('Update Delivery Date');
			if(this.shippingDetails.DeliveryDate && this.shippingDetails.DeliveryDate != '' && this.shippingDetails.orderPropertyId && this.shippingDetails.orderPropertyId != ''){
				this.showSpinner = true;
				updateDeliveryDate( {updateOrderPropertyJSON : JSON.stringify({Id : this.shippingDetails.orderPropertyId , Plant_Delivery_Date__c : this.shippingDetails.DeliveryDate}) })
				.then(response =>{
					this.showSpinner = false;
					this.showCustomErrorMessage('Delivery date Update Successfully' , 'Success' , 'success' , 'dismissable');
					console.log('response::',response);
				}).catch(error =>{
					this.showSpinner = false;
					console.log('update DeliveryDate Error ::',error);
				})
			}
			else{
				this.showCustomErrorMessage('Order Property Id Not Available' , 'Error' , 'error' , 'dismissable');
			}
		
		}

		else if(event.target.value == 'Update payment Detail'){
			console.log('Update payment Detail');
			if(this.selectedPaymentCard.Id != ''){
				this.showSpinner = true;
				let cardInformation = {};
				for ( let data of this.paymentMethodsList){
					if(data.paymentId == this.selectedPaymentCard.Id){
						cardInformation = data.cardInformation;
						break;
					}
				}
				console.log('payment Method Update JSON:::',JSON.stringify({authenticationToken : this.customerAccount.Token , orderNumber : this.selectedOrder.OrderNumber , paymentMethodId : this.selectedPaymentCard.Id , cardInformation : null}));
				updatePaymentDetails({paymentDetailJSON : JSON.stringify({authenticationToken : this.customerAccount.Token , orderNumber : this.selectedOrder.OrderNumber , paymentMethodId : this.selectedPaymentCard.Id , cardInformation : null}) })
				.then(response =>{
					this.showSpinner = false;
					response = JSON.parse(response);
					if(response.hasOwnProperty('statusCode') && response.statusCode && response.statusCode == '200'){
						this.showCustomErrorMessage(response.msg ,'Success', 'success' , 'dismissable');
					}
					else{
						if(response.hasOwnProperty('msg') && response.msg && response.msg != ''){
							this.showCustomErrorMessage(response.msg ,'Error', 'error' , 'sticky');
						}
					}
					console.log('updatePaymentDetails response::',response)
				}).catch(error =>{
					this.showSpinner = false;
					console.log('Update payment Error::',error);
					var errorObj = this.parseErrorBody(error);
					console.log('errorObj >>' + JSON.stringify(errorObj));
					if (errorObj && errorObj.message && errorObj.title && errorObj.message != '' && errorObj.title != '') {
						this.showCustomErrorMessage(errorObj.message, errorObj.title, 'error', 'dismissable');
					} else {
						this.showCustomErrorMessage('An Error has occured please contact your system administrator...', 'Error', 'dismissable');
					}
				})
			}
			else{
				this.showCustomErrorMessage('Please Select Payment Type' , 'Error' , 'error' , 'dismissable');
			}
		}
	}

	handleChange(event){
		if(event.target.dataset.field == 'DeliveryDate'){
			console.log('deliverydate::',typeof(event.target.value))
			this.shippingDetails.DeliveryDate = event.target.value;
		}
		else if(event.target.dataset.field == 'Payment'){
			this.selectedPaymentCard.Id = event.target.value;
			this.selectedPaymentCard.Name = event.target.options.find(opt => opt.value === event.detail.value).label;
		}
		else if(event.target.dataset.field == 'shippingStreet1'){
			this.shippingDetails.street1 = event.target.value;
		}
		else if(event.target.dataset.field == 'shippingStreet2'){
			this.shippingDetails.street2 = event.target.value;
		}
		else if(event.target.dataset.field == 'shippingStreet3'){
			this.shippingDetails.street3 = event.target.value;
		}
		else if(event.target.dataset.field == 'shippingCity'){
			this.shippingDetails.city = event.target.value;
		}
		else if(event.target.dataset.field == 'shippingState'){
			this.shippingDetails.state = event.target.value;
		}
		else if(event.target.dataset.field == 'shippingZip'){
			this.shippingDetails.zip = event.target.value;
		}
		else if(event.target.dataset.field == 'shippingCountry'){
			this.shippingDetails.country = event.target.value;
		}
		console.log('shipp::',JSON.stringify(this.shippingDetails))
	}

	handleMealsTab(event) {
		if (event.target.dataset.field == 'mealTab') {
			if (event.target.value == 'Snacks') {
				this.mealsVisibleList = this.allMealsBackupList.filter(item => item.Type__c == 'Snacks');
			} else if (event.target.value == 'Dinner') {
				this.mealsVisibleList = this.allMealsBackupList.filter(item => item.Type__c == 'Dinner');
			} else if (event.target.value == 'Lunch') {
				this.mealsVisibleList = this.allMealsBackupList.filter(item => item.Type__c == 'Lunch');
			} else if (event.target.value == 'Breakfast') {
				this.mealsVisibleList = this.allMealsBackupList.filter(item => item.Type__c == 'Breakfast');
			}
		} 
		else if (event.target.dataset.field == 'mealSelection') {
			//console.log('mealList::'+JSON.stringify(this.selectedMealList));
			console.log('mealSelection:::');
			if (this.selectedMealList.length < 12) {
				let index = parseInt(event.target.dataset.index);
				let selectedMeal = this.mealsVisibleList[index];
				let mealAlreadySelected = this.selectedMealList.some(element => element.mealID === selectedMeal.Id);
				console.log('mealAlreadySelected::', mealAlreadySelected);
				if (!mealAlreadySelected) {
					//selectedMeal['Quantity'] = 1;
					this.selectedMealList.push({
						mealID: selectedMeal.Id,
						quantity: 1,
						mealSelectionMealId: '',
						Name: selectedMeal.Name
					});
				}
				 else {
					this.showCustomErrorMessage('Meal already selected', '', 'error', 'dismissable');
				}
			} else {
				this.showCustomErrorMessage('we can process only 12 meals.', '', 'error', 'dismissable');
			}
		}
		else if (event.target.dataset.field == 'mealQuantitySubstract') {
			let index = parseInt(event.target.dataset.index);
			if (this.selectedMealList[index].quantity > 1) {
				this.selectedMealList[index].quantity = this.selectedMealList[index].quantity - 1;
			}
			console.log('sustract::')
		}
		else if (event.target.dataset.field == 'mealQuantityAdd') {
			let index = parseInt(event.target.dataset.index);
			this.selectedMealList[index].quantity = this.selectedMealList[index].quantity + 1;
			console.log('Add::')
		}
		else if (event.target.dataset.field == 'Remove Meal') {
			let index = parseInt(event.target.dataset.index);
			this.selectedMealList.splice(index, 1);
		}

	}

	showCustomErrorMessage(message, title, variant, mode) {
		const evt = new ShowToastEvent({
			title: title,
			message: message,
			variant: variant,
			mode: mode
		});
		this.dispatchEvent(evt);
	}

	parseErrorBody(error) {
		var errorObject = {};
		if (error != null && error != undefined) {
			var message = '';
			var defaultMessage = error.body.message;
			var loop = 1;
			if (error.body.output != undefined && error.body.output != null) {
				if (error.body.output.errors.length > 0) {
					for (let data of error.body.output.errors) {
						message = (data.errorCode && data.errorCode != '' && data.message && data.message != '' ? message + loop + '. ' + data.errorCode + ' : ' + data.message + '\n' : message);
						loop = (data.errorCode && data.errorCode != '' && data.message && data.message != '' ? ++loop : loop);

					}
				}

				if (error.body.output.fieldErrors && Object.values(error.body.output.fieldErrors).length > 0) {
					for (let data of Object.values(error.body.output.fieldErrors)) {
						for (let fielderror of data) {
							if ((!message.includes(fielderror.message) && fielderror.message.includes(fielderror.field)) || !fielderror.message.includes(fielderror.field)) {
								if (fielderror.message.includes(fielderror.field)) {
									message = (fielderror.errorCode && fielderror.errorCode != '' && fielderror.message && fielderror.message != '' ? message + loop + '. ' + fielderror.errorCode + ' : ' + fielderror.message + '\n' : message);
									loop = (fielderror.errorCode && fielderror.errorCode != '' && fielderror.message && fielderror.message != '' ? ++loop : loop);
								} else {
									message = (fielderror.errorCode && fielderror.errorCode != '' && fielderror.message && fielderror.message != '' ? message + loop + '. ' + fielderror.errorCode + ' : ' + fielderror.message + ' [' + fielderror.field + ']' + '\n' : message);
									loop = (fielderror.errorCode && fielderror.errorCode != '' && fielderror.message && fielderror.message != '' ? ++loop : loop);
								}
							}
						}
					}
				}
			}

			if (message && message != '') {
				errorObject['message'] = message;
				errorObject['title'] = 'Review the following errors:';
			} else {
				errorObject['message'] = defaultMessage;
				errorObject['title'] = 'Error';
			}
		} else {
			errorObject['message'] = defaultMessage;
			errorObject['title'] = 'Error';
		}
		return errorObject;
	}

	get disableMealUpdate(){
		return (this.selectedMealList.length > 0 && !this.authorisationTokenExpired ? false : true);
	}

	get showUpdateCustomizeMealButton(){
		return (this.selectedOrder.OrderNumber && this.selectedOrder.OrderNumber != '' && !this.authorisationTokenExpired ? true : false)
	}

	get disableUpdateRecords(){
		return (!this.authorisationTokenExpired && this.selectedOrder.OrderNumber && this.selectedOrder.OrderNumber != '' ? false : true)
	}

	get updateDeliveryDateDisabled(){
		return (this.shippingDetails.hasOwnProperty('orderPropertyId') && this.shippingDetails.orderPropertyId && this.shippingDetails.orderPropertyId != '' && this.availableDeliveryDatesList.length > 0  ? false : true);
	}
}