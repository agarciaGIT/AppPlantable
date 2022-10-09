<aura:application extends="ltng:outApp" >
	
    <!--we need to use the dependency in order to avoid twice load of the component in the vf page -->	
    <aura:dependency resource="c:deleteTestData"/>
</aura:application>