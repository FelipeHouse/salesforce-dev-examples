/**
 *  @author Felipe Ferreira
 *  @description Domain class for Object (RT)
 *  @lastOnDemand
 **/
public class ObjectRecordtypeDomain extends fflib_SObjectDomain {
    public ObjectRecordtypeDomain(List<Object> sObjectList) {
        super(sObjectList);
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new ObjectRecordtypeDomain(sObjectList);
        }
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) {
        //cast only once
        List<Object> lstObjects = (List<Object>) Records;
        Map<Id, Object> mapExistingObjects = (Map<Id, Object>) existingRecords;

        (((ObjectsService) Injector.getInstance().instantiate(ObjectsService.class)).método(lstObjects, mapExistingObjects, 'ObjectRecordtypeDomain'));
    }

    public override void onAfterInsert() {
        List<Object> lstObjects = (List<Object>) Records;
        (((ObjectsService) Injector.getInstance().instantiate(ObjectsService.class)).método(lstObjects, null, 'ObjectRecordtypeDomain'));
    }
}
