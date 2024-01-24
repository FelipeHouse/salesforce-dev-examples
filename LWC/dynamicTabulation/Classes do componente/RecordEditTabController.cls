public with sharing class RecordEditTabController {
    @AuraEnabled
    public static InitValuesResponse getFieldsOptions(String recordTypeId, String objectApiName, String teamValue) {
        try {
            InitValuesResponse response = new InitValuesResponse();
            MacroTabulation helper;
            String recordTypeDeveloperName;
            Schema.DescribeSObjectResult describeSObjectResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe();

            if (recordTypeId != null) {
                recordTypeDeveloperName = describeSObjectResult.getRecordTypeInfosById().get(recordTypeId).getDeveloperName();
                helper = TabulationHelperFactory.createHelperBySObjectRecordType(objectApiName, recordTypeDeveloperName, teamValue);
            }
            if (helper != null) {
                response.tabulationFields = new List<String>(helper.getTabulationFields());
                List<String> lstFieldsToQuery = new List<String>(helper.getTabulationFields());
                lstFieldsToQuery.add('Priority__c');
                lstFieldsToQuery.add('TabulationFlow__c');

                if (teamValue != null) {
                    response.options = (new TabulationsSelector()).getTabulationOptions(lstFieldsToQuery, helper.recordTypeDeveloperName, teamValue);
                } else {
                    response.options = (new TabulationsSelector()).getTabulationOptions(lstFieldsToQuery, helper.recordTypeDeveloperName);
                }
            }
            System.debug('response ' + JSON.serializepretty(response));
            return response;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static InitValuesResponse getFieldsToDisplay(String recordTypeId, String objectApiName) {
        try {
            InitValuesResponse response = new InitValuesResponse();
            MacroTabulation helper;
            String recordTypeDeveloperName;
            Schema.DescribeSObjectResult describeSObjectResult = Schema.getGlobalDescribe().get(objectApiName).getDescribe();

            if (recordTypeId != null) {
                recordTypeDeveloperName = describeSObjectResult.getRecordTypeInfosById().get(recordTypeId).getDeveloperName();
                helper = TabulationHelperFactory.createHelperBySObjectRecordType(objectApiName, recordTypeDeveloperName, null);
            }
            if (helper != null) {
                response.tabulationFields = new List<String>(helper.getTabulationFields());
            }
            return response;
        } catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getStackTraceString());
            throw new AuraHandledException(e.getMessage());
        }
    }

    public class InitValuesResponse {
        @AuraEnabled
        public List<String> tabulationFields;
        @AuraEnabled
        public List<Tabulation__c> options;
    }
}
