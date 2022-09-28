trigger Plant_LearningItemChangeEventTrigger on Plant_Learning_Item__ChangeEvent (after insert) {
	System.debug('Plant_Learning_Item__ChangeEvent!!');
}