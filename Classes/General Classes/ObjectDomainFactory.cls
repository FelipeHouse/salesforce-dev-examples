/**
 *  @author Felipe Ferreira
 *  @description Factory class for Object Domain
 *  @lastOnDemand
 *  @upd
 **/
public class ObjectDomainFactory extends SObjectDomainFactory {
    private static ObjectDomainFactory instance;

    private Map<String, String> mapIdentifierType;
    private Map<String, Schema.RecordTypeInfo> mapRecordTypeInfo;

    public static ObjectDomainFactory getInstance() {
        instance = instance == null ? new ObjectDomainFactory() : instance;

        return instance;
    }

    public ObjectDomainFactory() {
        this.mapRecordTypeInfo = Schema.SObjectType.Object.getRecordTypeInfosByDeveloperName();
    }

    protected override Map<String, String> getIdentifierType() {
        if (this.mapIdentifierType == null) {
            this.mapIdentifierType = new Map<String, String>();

            Map<String, String> mapIdentifiersDomainConstructor = getIdentifiersDomainConstructor();

            for (String identifier : mapIdentifiersDomainConstructor.keySet()) {
                RecordTypeInfo recordTypeInfo = mapRecordTypeInfo.get(identifier);
                if (recordTypeInfo != null) {
                    this.mapIdentifierType.put(
                        recordTypeInfo.getRecordTypeId(),
                        mapIdentifiersDomainConstructor.get(identifier)
                    );
                }
            }
        }

        return this.mapIdentifierType;
    }

    protected override Map<String, String> getIdentifiersDomainConstructor() {
        return new Map<String, String>{
            'RecordtypeDeveloperName' => 'RecordtypeDomain.Constructor'
        };
    }
}
