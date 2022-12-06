import {LightningElement,track,wire} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getMeals from "@salesforce/apex/Plant_NewOrderCustomerController.getMeals";
import createOrder from "@salesforce/apex/Plant_NewOrderCustomerController.createOrder";
import getAccountData from "@salesforce/apex/Plant_NewOrderCustomerController.getAccount";
import getShippingList from "@salesforce/apex/Plant_NewOrderCustomerController.getShippingAddress";
import getCardTypePicklistValues from "@salesforce/apex/Plant_NewOrderCustomerController.getPicklistValue";
import {NavigationMixin} from 'lightning/navigation'; 
export default class plant_newOrderCustomer extends NavigationMixin(LightningElement) {

	accountComoboxValues = [{
		label: 'New Account',
		value: 'New Account'
	}, {
		label: 'Existing Customer',
		value: 'Existing Customer'
	}];
	deleveryDateComoboxValues = [{
		label: 'Ship ASAP',
		value: 'Ship ASAP'
	}, {
		label: 'Manual',
		value: 'Manual'
	}];
	productComoboxValues = [{
		label: 'A-la-carte',
		value: 'A-la-carte'
	}, {
		label: 'Reboot',
		value: 'Reboot'
	}, {
		label: 'Quickstart',
		value: 'Quickstart'
	}];
	paymentComoboxValues = [{
		label: 'Send Email',
		value: 'Send Email'
	}, {
		label: 'Add Card ',
		value: 'Add Card'
	}];
	cardComoboxValues = [{
		label: 'New Card',
		value: 'New Card'
	}, {
		label: 'Existing Card',
		value: 'Existing Card'
	}]
	@track selectedComboxboxvalues = {
		orderInformation: {
			value: (this.accountComoboxValues.length > 0 ? this.accountComoboxValues[0].value : ''),
			disable: false
		},
		paymentMethod: {
			value: (this.paymentComoboxValues.length > 0 ? this.paymentComoboxValues[0].value : ''),
			disable: false
		},
		DeliveryDate: {
			value: (this.deleveryDateComoboxValues.length > 0 ? this.deleveryDateComoboxValues[0].value : ''),
			disable: false
		},
		cardInformation: {
			value: (this.cardComoboxValues.length > 0 ? this.cardComoboxValues[0].value : ''),
			disable: false
		}
	};
	@track showCreateOrderView = true;
	@track showDatePicker = false;
	@track DiscountCodes = new Array();
	@track cartNavigation = {url: ''}
	@track showDiscountAddIcon = false;
	@track showBreakFastTab = false;
	allMealsBackupList = [];
	mealsVisibleList = [];
	@track selectedMealList = [];
	@track showSpinner = false;
	@track selectedAccountId = '';
	@track selectedAccountName = '';
	@track disableCreateOrder = true;
	@track createOrderJson = this.newOrderJSON;
	@track showNavigation = false;
	@track showModal = false;
	@track DiscountedPrice = {};
	@track messageList = [];
	@track showAccountLookup = {show: false,class: ''}
	@track AuthorizationToken = '';
	@track shippingAddressListByAccount = new Array();
	@track selectedShippingAddress = {Id: ''};
	@track showpaymentTabSet = false;
	@track selectedPaymentCard = {Name: '',Id: ''}
	@track disableCardInformation = false;
	@track disableEdit = false;
	@track disableShippingInformation = false;
	@track disableAccountEditForm = false;
    @track cardTypeComboBoxvalues = []
	columns = [{
			label: 'street1',
			fieldName: 'street1'
		},
		{
			label: 'street2',
			fieldName: 'street2'
		},
		{
			label: 'street3',
			fieldName: 'street3'
		},
		{
			label: 'City',
			fieldName: 'city'
		},
		{
			label: 'State',
			fieldName: 'state'
		},
		{
			label: 'Zip',
			fieldName: 'zip'
		},
		{
			label: 'Country',
			fieldName: 'country'
		},
	];

	connectedCallback() {
		this.showSpinner = true;
		getMeals()
			.then(response => {
				this.showSpinner = false;
				response = JSON.parse(response);
				if (response.statusCode == 200) {
					this.allMealsBackupList = response.result.resultArr;
				}

			}).catch(error => {
				this.showSpinner = false;
				var errorObj = this.parseErrorBody(error);
				console.log('errorObj >>' + JSON.stringify(errorObj));
				if (errorObj && errorObj.message && errorObj.title && errorObj.message != '' && errorObj.title != '') {
					this.showCustomErrorMessage(errorObj.message, errorObj.title, 'error', 'dismissable');
				} else {
					this.showCustomErrorMessage('An Error has occured please contact your system administrator...', 'Error', 'dismissable');
				}
				console.log('error::get meals::', error);
			})

        getCardTypePicklistValues({ObjectApi_name:'Plant_Payment_Method__c' , Field_name: 'Plant_Card_Type__c'}).then(response =>{
            this.cardTypeComboBoxvalues = JSON.parse(response);
        }).catch(error=>{
            console.log('get picklist error::',error)
        })
	}

	closeModal() {
		this.showModal = false;
	}

	handleShippingAndCardTab(event) {
		if (event.target.dataset.field == 'shippingTab') {
			if (event.target.value == 'Existing Address') {

			} else {
				this.selectedShippingAddress.Id = (this.createOrderJson.cartId != '' ? this.selectedShippingAddress.Id : '');
				const selectedRows = this.template.querySelector('lightning-datatable[data-tablename="shippingAddress"]');
				if (selectedRows != null && selectedRows) {
					this.template.querySelector('lightning-datatable[data-tablename="shippingAddress"]').selectedRows = [];
				}
			}
		} else if (event.target.dataset.field == 'paymentTab') {
			if (event.target.value == 'New Card') {
				this.selectedPaymentCard.Id = (this.createOrderJson.cartId != '' ? this.createOrderJson.paymentMethodId : this.selectedPaymentCard.Id);
				this.selectedPaymentCard.Name = (this.createOrderJson.cartId != '' ? this.createOrderJson.paymentMethodId : this.selectedPaymentCard.Name);
				//this.selectedPaymentCard.Name = (this.createOrderJson.cartId != '' ? this.selectedPaymentCard.Name : '');
				//this.disableCardInformation = (this.createOrderJson.cartId == '' && this.selectedPaymentCard.Id == '' ? false : this.disableCardInformation );
			}
		}
	}

	handleRecordSelection(event) {
		let object = event.detail.object;
		if (object == 'Account' && this.createOrderJson.cartId == '') {
			this.createOrderJson.authorizeToken = '';
			this.selectedAccountId = event.detail.selectedRecordId;
			console.log('this acc', this.selectedAccountId)
			this.selectedAccountName = event.detail.selectedValue;
			this.shippingAddressListByAccount = [];
			this.AuthorizationToken = '';
			if (this.selectedAccountId != '' && this.selectedAccountId) {
				getAccountData({
						accountId: event.detail.selectedRecordId
					})
					.then(response => {
						console.log('account:', response)
						this.createOrderJson.firstName = (response.hasOwnProperty('First_Name__c') ? response.First_Name__c : '');
						this.createOrderJson.lastName = (response.hasOwnProperty('Last_Name__c') ? response.Last_Name__c : '');
						this.createOrderJson.email = (response.hasOwnProperty('Email__c') ? response.Email__c : '');
						this.createOrderJson.phone = (response.hasOwnProperty('First_Name__c') ? response.Phone : '');

						if (response.hasOwnProperty('plant_Authentication_Token__c')) {
							this.AuthorizationToken = response.plant_Authentication_Token__c;
							this.createOrderJson.authorizeToken = (response.plant_Authentication_Token__c && response.plant_Authentication_Token__c != '' ? response.plant_Authentication_Token__c : '');
							if (response.plant_Authentication_Token__c != '' && response.plant_Authentication_Token__c) {
								getShippingList({
										authorizationTokenJson: response.plant_Authentication_Token__c /*JSON.stringify({
											authorizationToken: response.plant_Authentication_Token__c
										}) */
									})
									.then(result => {
										console.log('response shiiping list::', result);
										result = JSON.parse(result);
										if (result.statusCode == '200') {
											if (result.hasOwnProperty('result') && result.result.hasOwnProperty('resultArr')) {
												let Shippingdata = result.result.resultArr
												for (let i = 0; i < Shippingdata.length; i++) {
													if (Shippingdata[i].hasOwnProperty('shippingAddressId')) {
														Object.assign(Shippingdata[i].shippingAddress, {
															Id: Shippingdata[i].shippingAddressId
														});
														this.shippingAddressListByAccount.push(Shippingdata[i].shippingAddress);
													}
												}
												//this.shippindAddressListByAccount = result.result.resultArr;
											}
											console.log('shippingAddressListByAccount::', this.shippingAddressListByAccount);
										}
									}).catch(error => {
										console.log('GertShipping dta error::', error)
									})
							}
						}
						console.log('Authorization Token', response)
					}).catch(error => {

					})
			} else {
				this.createOrderJson.authorizeToken = '';
				this.createOrderJson.firstName = '';
				this.createOrderJson.lastName = '';
				this.createOrderJson.email = '';
				this.createOrderJson.phone = '';
				this.createOrderJson.canSMS = false;
			}
		} 
		else if (object == 'Plant_Payment_Method__c' && this.createOrderJson.cartId == '') {
			this.selectedPaymentCard.Id = event.detail.selectedRecordId;
			this.selectedPaymentCard.Name = event.detail.selectedValue;
			console.log('selectedPaymentCard:::',this.selectedPaymentCard)
			this.createOrderJson.paymentMethodId = (event.detail.selectedRecordId && event.detail.selectedRecordId != '' ? event.detail.selectedRecordId : '');
			if (this.selectedPaymentCard.Id != '' && this.selectedPaymentCard.Id && this.selectedAccountId.Id != '') {
				this.disableCardInformation = true;
			} else {
				this.disableCardInformation = false;
			}
		}
		console.log('handle Record Selection')
	}

	handleShippingSelect(event) {
		let selectedRows = event.detail.selectedRows;
		console.log('selectedRows::' + JSON.stringify(event.detail.selectedRows));
		if (selectedRows && selectedRows.length > 0) {
			this.createOrderJson.ShippingAddressId = selectedRows[0].Id;
			this.selectedShippingAddress.Id = selectedRows[0].Id;
		} else {
			this.createOrderJson.ShippingAddressId = '';
			this.selectedShippingAddress.Id = '';
		}

	}

	handleChange(event) {
		let field = event.target.dataset.field;
		if (field == 'account') {
			this.selectedAccountId = '';
			this.selectedAccountName = '';
			this.selectedPaymentCard.Id = '';
			this.selectedPaymentCard.Name = '';
			this.createOrderJson.email = '';
			this.createOrderJson.phone = '';
			this.createOrderJson.firstName = '';
			this.createOrderJson.lastName = '';
			this.selectedComboxboxvalues.orderInformation.value = event.target.value;
			if (event.target.value == 'New Account') {
				this.showAccountLookup.show = false;
				this.disableAccountEditForm = false;
			} else {
				this.showAccountLookup.show = true;
				this.disableAccountEditForm = true;
			}
		}
		if (field == 'Delivery Date') {
			this.showDatePicker = (event.target.value == 'Manual' ? true : false);
			this.selectedComboxboxvalues.DeliveryDate.value = event.target.value;
			if (event.target.value == 'Ship ASAP') {
				this.createOrderJson.shipASAP = true;
			} else {
				this.createOrderJson.shipASAP = false;
			}
		}

		if (field == 'Discount') {
			this.showDiscountAddIcon = (event.target.value && event.target.value != '' ? true : false);
		} else if (field == 'manual datePicker') {
			this.createOrderJson.DeliveryDate = event.target.value;
		} else if (field == 'Add Discount Code') {
			let inputDiscountField = this.template.querySelector('lightning-input[data-field="Discount"]').value;
			if (inputDiscountField && inputDiscountField != '') {
				if (this.DiscountCodes.length < 1) {
					if (!this.DiscountCodes.includes(inputDiscountField)) {
						this.DiscountCodes.push(inputDiscountField);
						this.template.querySelector('lightning-input[data-field="Discount"]').value = '';
						this.showDiscountAddIcon = false;
					} else {
						this.showCustomErrorMessage('Code Already Exist', '', 'error', 'dismissable');
					}
				} else {
					this.showCustomErrorMessage('Discount Code already selected', '', 'error', 'dismissable');
				}

				this.createOrderJson.discountCode = (this.DiscountCodes.length > 0 ? this.DiscountCodes[0] : '')
			}
			console.log('inputDiscountField::', inputDiscountField)
		} else if (field == 'product') {
			if (event.target.value != '') {
				this.createOrderJson.product = event.target.value;
				this.createOrderJson.recurrence = (event.target.value == 'Reboot' ? true : false);
				this.disableCreateOrder = false
			}
			console.log('product::', event.target.value);
		} else if (field == 'first name') {
			this.createOrderJson.firstName = event.target.value;
		} else if (field == 'last name') {
			this.createOrderJson.lastName = event.target.value;
		} else if (field == 'email') {
			let patternmatch = this.template.querySelector(['lightning-input[data-field="email"]']).checkValidity();
			if (patternmatch) {
				this.createOrderJson.email = event.target.value;
			} else {
				this.createOrderJson.email = '';
			}
		} else if (field == 'phone') {
			let patternmatch = this.template.querySelector(['lightning-input[data-field="phone"]']).checkValidity();
			if (patternmatch) {
				this.createOrderJson.phone = event.target.value;
			} else {
				this.createOrderJson.phone = '';
			}
		} else if (field == 'can sms') {
			this.createOrderJson.canSMS = event.target.checked;
			//this.createOrderJson.shippingAddress.canSMS = event.target.checked;
		} else if (field == 'street 1') {
			this.createOrderJson.shippingAddress.street1 = event.target.value;
		} else if (field == 'street 2') {
			this.createOrderJson.shippingAddress.street2 = event.target.value;
		} else if (field == 'street 3') {
			this.createOrderJson.shippingAddress.street3 = event.target.value;
		} else if (field == 'city') {
			this.createOrderJson.shippingAddress.city = event.target.value;
		} else if (field == 'state') {
			this.createOrderJson.shippingAddress.state = event.target.value;
		} else if (field == 'zip') {
			this.createOrderJson.shippingAddress.zip = event.target.value;
		} else if (field == 'country') {
			this.createOrderJson.shippingAddress.country = event.target.value;
		} else if (field == 'payment ComboBox') {
			this.selectedComboxboxvalues.paymentMethod.value = event.target.value;
			if (event.target.value == 'Add Card') {
				this.showpaymentTabSet = true;
			} else {
				this.showpaymentTabSet = false;
				this.selectedPaymentCard.Name = '';
				this.selectedPaymentCard.Id = ''
			}
		} else if (field == 'street1 card') {
			this.createOrderJson.cardInformation.billingAddress.street1 = event.target.value;
		} else if (field == 'street2 card') {
			this.createOrderJson.cardInformation.billingAddress.street2 = event.target.value;
		} else if (field == 'street3 card') {
			this.createOrderJson.cardInformation.billingAddress.street3 = event.target.value;
		} else if (field == 'city card') {
			this.createOrderJson.cardInformation.billingAddress.city = event.target.value;
		} else if (field == 'state card') {
			this.createOrderJson.cardInformation.billingAddress.state = event.target.value;
		} else if (field == 'zip card') {
			this.createOrderJson.cardInformation.billingAddress.zip = event.target.value;
		} else if (field == 'country card') {
			this.createOrderJson.cardInformation.billingAddress.country = event.target.value;
		} else if (field == 'phone card') {
			let patternmatch = this.template.querySelector(['lightning-input[data-field="phone card"]']).checkValidity();
			if (patternmatch) {
				this.createOrderJson.cardInformation.billingAddress.phone = event.target.value;
			} else {
				this.createOrderJson.cardInformation.billingAddress.phone = '';
			}
		} else if (field == 'can SMS Card') {
			this.createOrderJson.cardInformation.billingAddress.canSMS = event.target.checked;
		} else if (field == 'card name') {
			this.createOrderJson.cardInformation.name = event.target.value;
		} else if (field == 'card number') {
			let checkValidity = this.template.querySelector(['lightning-input[data-field="card number"]']).checkValidity();
			if (checkValidity) {
				this.createOrderJson.cardInformation.cardnumber = event.target.value;
			} else {
				this.createOrderJson.cardInformation.cardnumber = '';
			}
		} else if (field == 'card type') {
			this.createOrderJson.cardInformation.card_Type = event.target.value;
		} else if (field == 'card last4 digit') {
			let checkValidity = this.template.querySelector(['lightning-input[data-field="card last4 digit"]']).checkValidity();
			if (checkValidity) {
				this.createOrderJson.cardInformation.card_Last_4_Digits = event.target.value;
			} else {
				this.createOrderJson.cardInformation.card_Last_4_Digits = '';
			}

		} else if (field == 'card cvv') {
			let checkValidity = this.template.querySelector(['lightning-input[data-field="card cvv"]']).checkValidity();
			if (checkValidity) {
				this.createOrderJson.cardInformation.cvv = event.target.value;
			} else {
				this.createOrderJson.cardInformation.cvv = '';
			}

		} else if (field == 'card expiration date') {
			this.createOrderJson.cardInformation.expDate = event.target.value;
		}
		if (field == 'Remove Discount Code') {
			let index = parseInt(event.target.dataset.index);
			this.DiscountCodes.splice(index, 1);
			this.createOrderJson.discountCode = (this.DiscountCodes.length > 0 ? this.DiscountCodes[0] : '')
		}
	}

	handleButton(event) {
		if (event.target.value == 'Customize') {
			this.showCreateOrderView = false;
		} else if (event.target.value == 'Save') {
			this.showCreateOrderView = true;
		} else if (event.target.value == 'Cancel Meal') {
			this.showCreateOrderView = true;
		} else if (event.target.value == 'create Order') {
			this.showSpinner = true;
			this.createOrderJson.meals = this.selectedMealList.filter(element => element.quantity > 0);
			this.createOrderJson.meals = JSON.parse(JSON.stringify(this.createOrderJson.meals));
			this.createOrderJson.phone = this.createOrderJson.phone.toString()
			for (let data of this.createOrderJson.meals) {
				delete data['Name'];
			}

			createOrder({
					createOrderJSON: JSON.stringify(this.createOrderJson)
				})
				.then(response => {

					this.messageList = [];
					response = JSON.parse(response);
					console.log('resonse::', response);
					this.showSpinner = false;
					if (response.hasOwnProperty('msg')) {
						let index = 0;
						for (let data of response.msg.split(',')) {
							if (data != '' && data && !data.includes('success')) {
								index = index + 1;
								this.messageList.push({
									msg: data,
									Sno: index
								})
							}
						}
					}
					try {
						if (response.statusCode == 200) {

							if (this.createOrderJson.cartId && this.createOrderJson.cartId != '') {
								this.showCustomErrorMessage('Cart Updated Successfully.', 'Success', 'success', 'dismissable');
							} else {
								this.showCustomErrorMessage('Cart Inserted Successfully.', 'Success', 'success', 'dismissable');
							}
							if (response.hasOwnProperty('result') && response.result.hasOwnProperty('resultArr') && response.result.resultArr && response.result.resultArr.length > 0) {
								if (response.result.resultArr[0].hasOwnProperty('cartId') && response.result.resultArr[0].cartId) {
									let cartDetailObj = response.result.resultArr[0];
									this.createOrderJson.cartId = cartDetailObj.cartId;
									// this.createOrderJson.paymentMethodId = (cartDetailObj.paymentMethod && cartDetailObj.paymentMethod.hasOwnProperty('Id') ? cartDetailObj.paymentMethod.Id : '')
									// this.createOrderJson.ShippingAddressId = (cartDetailObj.shippingAddress && cartDetailObj.shippingAddress.hasOwnProperty('Id') ? cartDetailObj.shippingAddress.Id : '')
									this.disableCardInformation = true;
									this.disableShippingInformation = true;
									this.disableEdit = true;
									//this.showAccountLookup.show = true;
									this.disableAccountEditForm = true;
									this.selectedComboxboxvalues.orderInformation.disable = true;
									this.selectedComboxboxvalues.paymentMethod.disable = true;
									this.selectedComboxboxvalues.DeliveryDate.disable = true;
									this.generateUrl(response.result.resultArr[0].cartId);
									if (response.result.resultArr[0].discountCodeList) {
										if (response.result.resultArr[0].discountCodeList.hasOwnProperty('resultArr')) {
											this.DiscountedPrice = (response.result.resultArr[0].discountCodeList.resultArr.length > 0 && response.result.resultArr[0].discountCodeList.resultArr[0].priceDetail ? response.result.resultArr[0].discountCodeList.resultArr[0].priceDetail : {})
										}
									}
								}

							}
						} else {
							this.showSpinner = false;
							if (response.hasOwnProperty('msg')) {
								this.showCustomErrorMessage(response.msg, 'Error', 'error', 'sticky');
							}
						}
					} catch (error) {
						this.showSpinner = false
						console.log('error::', error)
					}
				}).catch(error => {
					this.showSpinner = false;
					console.log('create order:', error)
					var errorObj = this.parseErrorBody(error);
					console.log('errorObj >>' + JSON.stringify(errorObj));
					if (errorObj && errorObj.message && errorObj.title && errorObj.message != '' && errorObj.title != '') {
						this.showCustomErrorMessage(errorObj.message, errorObj.title, 'error', 'sticky');
					} else {
						this.showCustomErrorMessage('An Error has occured please contact your system administrator...', 'Error', 'sticky');
					}
				})
			console.log('json data::', this.createOrderJson);

		} else if (event.target.value == 'View Order') {
			this.showModal = true;
		} else if (event.target.value == 'Edit Cart') {
			this.disableEdit = false;
			console.log('payment::', this.selectedPaymentCard)
			console.log('shipping::', this.selectedShippingAddress)
			this.disableCardInformation = (this.selectedPaymentCard.Id == null || this.selectedPaymentCard.Id == '' ? false : true);
			this.disableShippingInformation = (this.selectedShippingAddress.Id && this.selectedShippingAddress.Id != '' ? true : false)
			this.disableAccountEditForm = (this.selectedAccountId != '' && this.selectedAccountId ? true : false)
		}
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
		} else if (event.target.dataset.field == 'mealSelection') {
			//console.log('mealList::'+JSON.stringify(this.selectedMealList));

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
				} else {
					this.showCustomErrorMessage('Meal already selected', '', 'error', 'dismissable');
				}
			} else {
				this.showCustomErrorMessage('we can process only 12 meals.', '', 'error', 'dismissable');
			}
		} else if (event.target.dataset.field == 'mealQuantitySubstract') {
			let index = parseInt(event.target.dataset.index);
			if (this.selectedMealList[index].quantity > 1) {
				this.selectedMealList[index].quantity = this.selectedMealList[index].quantity - 1;
			}
			console.log('sustract::')
		} else if (event.target.dataset.field == 'mealQuantityAdd') {
			let index = parseInt(event.target.dataset.index);
			this.selectedMealList[index].quantity = this.selectedMealList[index].quantity + 1;
			console.log('Add::')
		} else if (event.target.dataset.field == 'Remove Meal') {
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
			var defaultMessage = (error.hasOwnProperty('body') && error.body.hasOwnProperty('message') && error.body.message ? error.body.message : '');
			var loop = 1;
			if (error.hasOwnProperty('body') && error.body.hasOwnProperty('output') && error.body.output != undefined && error.body.output != null) {
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

	generateUrl(recordId) {
		//let recordId = event.target.value;
		this[NavigationMixin.GenerateUrl]({
			type: 'standard__recordPage',
			attributes: {
				recordId: recordId,
				actionName: 'view'
			}
		}).then((url) => {
			this.cartNavigation.url = url;
			console.log('Url::', url)
		})
	}

	navigateToRecordPage(event) {
		let url = event.target.value;
		window.open(url);
	}


	get disableSave() {
		return (this.selectedMealList.length > 0 ? false : true);
	}

	get shownavigationButton() {
		return (this.cartNavigation.url != '' ? true : false);
	}


	get accountLookupDisable() {
		return (this.createOrderJson.cartId != '' ? true : false)
	}

	get PayementLookupVisible() {
		return (this.createOrderJson.cartId == '' ? false : true)

	}


	get showDiscountInputField() {
		return (this.DiscountCodes.length > 0 ? false : true);
	}

	get productName() {
		return (this.createOrderJson.product != '' && this.createOrderJson.product ? this.createOrderJson.product + ' : ' : '');
	}

	get showExistingShippingTab() {
		return (this.selectedAccountId != '' && this.selectedAccountId ? true : false)
	}

	get showShippingDatatableCheckBox() {
		return (this.createOrderJson.cartId != '' && this.createOrderJson.cartId ? true : false);
	}

	get newOrderJSON() {

		return {
			"product": '',
			"cartId": '',
			"mealSelectionId": "",
			"firstName": "",
			"lastName": "",
			"phone": "",
			"canSMS": false,
			"email": "",
			"shippingAddress": {
				"street1": "",
				"street2": "",
				"street3": "",
				"city": "",
				"state": "",
				"zip": "",
				"country": "",
				"phone": "",
				"canSMS": false
			},
			"shipASAP": true,
			"DeliveryDate": "",
			"meals": [],
			"discountCode": "",
			"recurrence": false,
			"cardInformation": {
				"name": "",
				"cardnumber": "",
				"card_Last_4_Digits": "",
				"card_Type": "",
				"cvv": "",
				"expDate": "",
				"billingAddress": {
					"street1": "",
					"street2": "",
					"street3": "",
					"city": "",
					"state": "",
					"zip": "",
					"country": "",
					"phone": "",
					"canSMS": false
				}
			},
			"authorizeToken": "",
			"paymentMethodId": "",
			"ShippingAddressId": ""
		}
	}
}