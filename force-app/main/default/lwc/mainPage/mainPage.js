import { LightningElement, track } from 'lwc';

export default class MainPage extends LightningElement {
    @track showDashboard=true;
    @track showPersonalInfo=false;
    @track showPreferred=false;
    @track showMembership=false;
    @track showExpertise=false;
    @track showPurchase=false;
    @track showAccountDirectory=false;
    @track showVolunteer=false;
    @track showProgram=false;
    @track showStudy=false;
    @track showEvent=false;
    @track showMutimedia=false;
    @track showContentHub=false;
    @track showExclusive=false;
    @track showRiskDirectory=false;
    @track showTechnology=false;
    @track showCredit=false;
    @track showCulture=false;
    @track showEnergy=false;
    @track showOperational=false;
    @track showMarket=false;

    @track showContents = [this.showDashboard=true,this.showPersonalInfo=false,this.showPreferred=false,this.showMembership=false,
                        this.showExpertise=false,this.showPurchase=false,this.showAccountDirectory=false,this.showVolunteer=false,
                        this.showProgram=false,this.showStudy=false,this.showEvent=false,this.showMutimedia=false,this.showContentHub=false,
                        this.showExclusive=false,this.showRiskDirectory=false,this.showTechnology=false,this.showCredit=false,
                        this.showCulture=false,this.showEnergy=false,this.showOperational=false,this.showMarket=false];
    
    @track sectionNames = ['dashboard','personalInfo','preferred','membership','expertise','purchase',
                        'account-directory','volunteer','program','study','events','multimedia',
                        'content-hub','exclusive','risk-directory','technology',
                        'credit','culture','energy','operational','market'];

    switchTab(event){ 
        //alert('name:'+event.currentTarget.dataset.name);
        this.deactivateAllTabs();
        let targetId = event.target.dataset.targetId;
        //alert('tab:'+targetId);
        let target = this.template.querySelector(`[data-target-id="${targetId}"]`);
        //alert('target:'+target);
        target.className = "active-tab";
        this.showContent(event.currentTarget.dataset.name);
    }

    showContent(section){
        /*for(var i=0;i<this.showContents.length;i++){
            //alert(section+':section:'+this.sectionNames[i]);
            if(this.sectionNames[i]==section){
                this.showContents[i]= true;
                //alert(this.showContents[i]+':section1:'+this.showContents);
            }else{
                this.showContents[i]= false;
            }
        }*/
        if(section=='dashboard'){
            this.showDashboard=true;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='personalInfo'){
            this.showDashboard=false;
            this.showPersonalInfo=true;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='preferred'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=true;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='membership'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=true;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='expertise'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=true;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='purchase'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=true;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='account-directory'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=true;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='volunteer'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=true;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='program'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=true;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='study'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=true;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='events'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=true;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='multimedia'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=true;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='content-hub'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=true;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='exclusive'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=true;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='risk-directory'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=true;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='technology'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=true;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='credit'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=true;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='culture'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=true;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='energy'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=true;
            this.showOperational=false;
            this.showMarket=false;
        }
        else if(section=='operational'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=true;
            this.showMarket=false;
        }
        else if(section=='market'){
            this.showDashboard=false;
            this.showPersonalInfo=false;
            this.showPreferred=false;
            this.showMembership=false;
            this.showExpertise=false;
            this.showPurchase=false;
            this.showAccountDirectory=false;
            this.showVolunteer=false;
            this.showProgram=false;
            this.showStudy=false;
            this.showEvent=false;
            this.showMutimedia=false;
            this.showContentHub=false;
            this.showExclusive=false;
            this.showRiskDirectory=false;
            this.showTechnology=false;
            this.showCredit=false;
            this.showCulture=false;
            this.showEnergy=false;
            this.showOperational=false;
            this.showMarket=true;
        }
    }

    switchDropDownMenu(event){
        this.deactivateAllTabs();
        let targetId = event.target.dataset.targetId;
        //alert('Menu:'+targetId);
        let tabId = targetId+'-dropdown';
        //alert('divid:'+tabId);
        let target = this.template.querySelector(`[data-target-id="${tabId}"]`);
        //alert('menu element:'+target);
        target.classList.add('active-tab');
        //target.classList.toggle('dropdown');
        this.showContent(event.currentTarget.dataset.name);
    }

    deactivateAllTabs(){
        const allTabs = this.template.querySelectorAll("a,div");
        //alert("alltabs:"+allTabs);
        allTabs.forEach(tab => {
            tab.classList.remove('active-tab');
        });
    }
}