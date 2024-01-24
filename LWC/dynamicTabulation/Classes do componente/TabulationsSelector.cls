/**
 *  @author James Santos
 *  @company XCL Company - 2021
 *  @description Selector class for Tabulation__c SObject
 *  @lastOnDemand
 **/
public class TabulationsSelector extends fflib_SObjectSelector {
    public static final String RECORDTYPE_BANKING_ATTENDANCE = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName()
        .get('BankingAttendance')
        .getRecordTypeId();
    public static final String RECORDTYPE_BAAS_ATTENDANCE_PORTAL = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName()
        .get('BaasAttendancePortal')
        .getRecordTypeId();
    public static final String RECORDTYPE_DIGITAL_ATTENDANCE = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName()
        .get('DigitalAttendance')
        .getRecordTypeId();
    public static final String RECORDTYPE_CREDIT_ATTENDANCE = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName()
        .get('CreditAttendance')
        .getRecordTypeId();
    public static final String RECORDTYPE_OPS_CHARGE_ATTENDANCE = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName()
        .get('OpsChargeAttendance')
        .getRecordTypeId();
    public static final String RECORDTYPE_OPERATIONS_ONBOARDING_ATTENDANCE = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName()
        .get('OpOnbAttendance')
        .getRecordTypeId();

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{ Tabulation__c.Name };
    }

    public Schema.SObjectType getSObjectType() {
        return Tabulation__c.sObjectType;
    }
    public List<Tabulation__c> getTabulationOptions(List<String> fields, String recordTypeDevName) {
        String rtId = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId(); //NOPMD

        fflib_QueryFactory query = newQueryFactory().selectFields(fields).setCondition('Status__c = \'Active\' AND RecordTypeId =: rtId');

        return (List<Tabulation__c>) Database.query(query.toSOQL());
    }

    public List<Tabulation__c> getTabulationOptions(List<String> fields, String recordTypeDevName, String teamValue) {
        String rtId = Schema.SObjectType.Tabulation__c.getRecordTypeInfosByDeveloperName().get(recordTypeDevName).getRecordTypeId(); //NOPMD
        String likeFilter = '%' + teamValue + '%'; //NOPMD

        fflib_QueryFactory query = newQueryFactory()
            .selectFields(fields)
            .setCondition('Status__c = \'Active\' AND RecordTypeId =: rtId AND (Team__c LIKE :likeFilter OR DisregardTeam__c = true)');

        return (List<Tabulation__c>) Database.query(query.toSOQL());
    }

    public List<Tabulation__c> selectByAreaAndActivity(String recordTypeDevName, String area, String activity) {
        return [
            SELECT Time__c
            FROM Tabulation__c
            WHERE Area__c = :area AND Activity__c = :activity
            LIMIT 1
        ];
    }

    public List<Tabulation__c> selectFullMatByArea(String recordTypeDevName, Set<String> setArea) {
        return [
            SELECT Area__c, Activity__c, Mat__c
            FROM Tabulation__c
            WHERE Area__c IN :setArea AND Activity__c != NULL AND Mat__c != NULL AND RecordType.DeveloperName = :recordTypeDevName
        ];
    }
}
