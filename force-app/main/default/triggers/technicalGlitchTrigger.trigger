trigger technicalGlitchTrigger on Approval_Matrix__c (after update, after insert) {
    Set<String> lstExamRegs = new Set<String>();
    Set<String> garpId = new Set<String>();
    Map<String,boolean> movingToActiveGroup = new Map<String,boolean>(); 
    if(trigger.isAfter && trigger.isUpdate) {
        for(Approval_Matrix__c a: trigger.new){
            if(a.Approval_Status__c == 'Approved') {
                if(a.Part_I_Exam_Registration__c != NULL){
                    lstExamRegs.add(a.Part_I_Exam_Registration__c);
                }
                system.debug('Part_I_Exam_Registration__c====>'+a.Part_I_Exam_Registration__c);
                if(a.Part_II_Exam_Registration__c != NULL){
                    lstExamRegs.add(a.Part_II_Exam_Registration__c);
                }
                system.debug('Part_II_Exam_Registration__c====>'+a.Part_II_Exam_Registration__c);
            }
            system.debug('lstExamRegs=====>'+lstExamRegs);
        }
        // system.debug('garpId======>'+garpId);
        Map<String,List<Exam_Attempt__c>> mapContactExamReg = new Map<String,List<Exam_Attempt__c>>();
        for(Exam_Attempt__c e: [select Id,Name,Section__c,Exam_Date__c,Exam_Site__c,Exam_Administration__c,
                                Exam_Administration__r.Name,Exam_Site__r.Name,Exam_Part__c,Garp_Id__c,
                                Exam_Administration__r.Exam_Group__c,Exam_Administration__r.Exam_Group__r.Next_Exam_Group__c,
                                Exam_Administration__r.Exam_Group__r.Next_Exam_Group__r.Active__c,Exam_Administration__r.Exam_Group__r.Next_Exam_Group__r.SCR_Active__c
                                from Exam_Attempt__c where Id IN: lstExamRegs] ){
                                    // system.debug('Rev: Exam_Administration__r.Exam_Group__r.Next_Exam_Group__r.Name====>'+e.Exam_Administration__r.Exam_Group__r.Next_Exam_Group__r.Name);
                                    system.debug('Rev: e.Exam_Administration__r.Exam_Group__r.Active__c======>'+e.Exam_Administration__r.Exam_Group__r.Next_Exam_Group__r.Active__c);
                                    system.debug('Rev:e.Section__c=====>' +e.Section__c);
                                    if (!mapContactExamReg.containsKey(e.Garp_Id__c)) {
                                        mapContactExamReg.put(e.Garp_Id__c,new List<Exam_Attempt__c>());
                                        if(e.Exam_Administration__r.Exam_Group__r.Next_Exam_Group__r.Active__c == true && (e.Section__c == 'FRM Part 1' || e.Section__c == 'FRM Part 2'))
                                        {
                                            movingToActiveGroup.put(e.Garp_Id__c, true);
                                            System.debug('Rev: movingToActiveGroup updated to true');
                                        } else if(e.Exam_Administration__r.Exam_Group__r.Next_Exam_Group__r.SCR_Active__c == true && e.Session__c == 'SCR') {
                                            movingToActiveGroup.put(e.Garp_Id__c, true);
                                        } else {
                                            movingToActiveGroup.put(e.Garp_Id__c, false);
                                            System.debug('Rev: movingToActiveGroup updated to false');
                                        }
                                    }
                                    system.debug('Rev: Reg data added');
                                    mapContactExamReg.get(e.Garp_Id__c).add(e);
                                }
        system.debug('Rev: movingToActiveGroup====>'+movingToActiveGroup);
        system.debug('mapContactExamReg==========>'+mapContactExamReg);
        for(Approval_Matrix__c a: trigger.new) {
            MemberServicesTool_Controller.requestWrapper mem = new MemberServicesTool_Controller.requestWrapper();
            mem.oneTimeDeferral = a.Free_Deferral__c == true? 'Yes':'No';
            mem.freeDeferral = a.One_Time_Deferral__c == true? 'No':'Yes';
            mem.part1Administration = a.Part_I_Exam_Admin__c;
            mem.part2Administration = a.Part_II_Exam_Admin__c;
            mem.part2ExamSite = a.Part_II_Exam_Site__c; 
            mem.part1ExamSite = a.Part_I_Exam_Site__c;
            mem.garpId = a.Garp_id__c;
            mem.registrations = mapContactExamReg.get(a.Garp_Id__c);
            mem.part1ExamPart = a.Part_I_Exam_Part__c ;
            mem.part2ExamPart = a.Part_II_Exam_Part__c ;
            mem.movingToActiveGroup = movingToActiveGroup.get(a.Garp_Id__c);
            String wrapperDetails = JSON.serialize(mem);
            system.debug('wrapperDetails======>'+wrapperDetails);
            MemberServicesTool_Controller.saveData(wrapperDetails);
        }
    }
    if(trigger.isAfter && trigger.isInsert){
        for(Approval_Matrix__c a : trigger.new) {
            if(a.Source__c == 'Technical Glitch') { 
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval.');
                req.setObjectId(a.Id);
                Approval.ProcessResult result = Approval.process(req);
                System.debug('Submitted for approval successfully: '+result.isSuccess());
            }
        }
    }
}