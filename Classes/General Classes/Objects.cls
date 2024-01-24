/**
*  @author Felipe ferreira
*  @description Domain class for Object
*  @lastOnDemand
**/
public class Objects extends fflib_SObjectDomain {

    Map<Id, List<Object>> mapRecords;

    public Objects(List<Object> sObjectList) {
        super(sObjectList);
        Configuration.disableTriggerCRUDSecurity();
        fetchMapRecords();
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Objects(sObjectList);
        }
    }

    //Separa todos os registros da trigger num mapa por RecordTypeId
    private void fetchMapRecords() {
        this.mapRecords =  new Map<Id, List<Object>>();

        List<Object> lstobjects = (List<Object>) Records;
        for ( Object record : lstobjects ) {
            List<Object> values = mapRecords.get( record.RecordTypeId );

            values = values != null
                ? values
                : new List<Object>();

            values.add( record );
        }
    }

    public override void onAfterInsert() {
        for ( Id key : mapRecords.keySet() ) {
            List<Object> lstobjects = mapRecords.get( key );
            fflib_SObjectDomain domain = ObjectDomainFactory.getInstance().createDomain( key , lstobjects ); // verifica se o recordtype possui uma domain (responsável por chamar os métodos)
            if ( domain != null ) {
                domain.onAfterInsert();
            }else{
                /** Demais chamadas de métodos se não houver Domain
                 * ObjectsService.método(lstobjects);
                 * ...
                 */
            }
        }
    }

    public override void onAfterUpdate(Map<Id,SObject> existingRecords) {
        for ( Id key : mapRecords.keySet() ) {
            List<Object> lstobjects = mapRecords.get( key );
            fflib_SObjectDomain domain = ObjectDomainFactory.getInstance().createDomain( key , lstobjects ); // verifica se o recordtype possui uma domain (responsável por chamar os métodos)
            if ( domain != null ) {
                domain.onAfterUpdate( existingRecords );
            }else{
                /** Demais chamadas de métodos se não houver Domain
                 * ObjectsService.método(lstobjects);
                 * ...
                 */
            }
        }
    }

    public override void onBeforeInsert() {
        for ( Id key : mapRecords.keySet() ) {
            List<Object> lstobjects = mapRecords.get( key );
            fflib_SObjectDomain domain = ObjectDomainFactory.getInstance().createDomain( key , lstobjects ); // verifica se o recordtype possui uma domain (responsável por chamar os métodos)
            if ( domain != null ) {
                domain.onBeforeInsert();
            }else{
                /** Demais chamadas de métodos se não houver Domain
                 * ObjectsService.método(lstobjects);
                 * ...
                 */
            }
    	}
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords){
        for ( Id key : mapRecords.keySet() ) {
            List<Object> lstobjects = mapRecords.get( key );
            fflib_SObjectDomain domain = ObjectDomainFactory.getInstance().createDomain( key , lstobjects ); // verifica se o recordtype possui uma domain (responsável por chamar os métodos)
            if ( domain != null ) {
                domain.onBeforeUpdate( existingRecords );
            }else{
                /** Demais chamadas de métodos se não houver Domain
                 * ObjectsService.método(lstobjects);
                 * ...
                 */
            }
        }
    }
}