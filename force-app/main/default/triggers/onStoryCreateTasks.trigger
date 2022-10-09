trigger onStoryCreateTasks on Story__c(after insert, after update) {

    List < Story_Task__c > taskList = new List < Story_Task__c > ();
    List < ID > lstIds = new List < ID > ();
   
    for (Story__c sto: trigger.new) {
      if (sto.Id != null)
        lstIds.add(sto.Id);
    }

    List < Story__c > lststo = [select Id, Name, Create_Tasks__c, Add_Tasks__c from Story__c where Id in: lstIds];
    List < Story_Task__c > lstTasks = [select Id, Name, Story__c from Story_Task__c where Story__c in: lstIds];

    system.debug('lstIds:' + lstIds);
    system.debug('lstTasks :' + lstTasks);

    Map < String, ID > mapStoryIdName = new MAP < String, ID > ();

    for (Story_Task__c task: lstTasks) {
      String key = task.Story__c + '~' + task.name;
      mapStoryIdName.put(key, task.Story__c);
    }
    
    system.debug('mapStoryIdName:' + mapStoryIdName);

      for (Story__c sto: lststo) {
   
      if (sto.Create_Tasks__c != null && sto.Add_Tasks__c == true) {

        for (String task: sto.Create_Tasks__c.split(';')) {

          system.debug('task:' + task);

          if (trigger.isInsert) {
            taskList.add(new Story_Task__c(Name = task, Story__c = sto.Id));
          } else {
            String key = sto.Id + '~' + task;
            ID fnd = mapStoryIdName.get(key);
            
            system.debug('fnd :' + fnd );
            
            if (fnd == NULL) {
              taskList.add(new Story_Task__c(Name = task, Story__c = sto.Id));
            }
          }
        }
      }

      insert tasklist;
    }
}