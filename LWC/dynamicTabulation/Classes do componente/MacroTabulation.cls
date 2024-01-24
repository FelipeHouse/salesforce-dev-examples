public abstract class MacroTabulation {
    protected Map<String, Set<String>> mapSObject;
    public String recordTypeDeveloperName;
    
    public virtual String getTabulationRecordType(){
        return recordTypeDeveloperName;
    }

    public Set<String> getTabulationFields() {
        return this.getSObjectFields( 'Tabulation__c' );
    }
    
    public Set<String> getSObjectTypes() {
        return this.mapSObject.keySet();
    }

    public Set<String> getSObjectFields( String sObjectType) {
        return this.mapSObject.get( sObjectType );
    }

    public interface IConstructable {
		MacroTabulation construct( String front );        
	}
}