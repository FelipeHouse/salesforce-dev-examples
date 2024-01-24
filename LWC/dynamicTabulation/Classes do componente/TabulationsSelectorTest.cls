@isTest
public with sharing class TabulationsSelectorTest {
    @isTest
    static void testGetSObjectType() {
        Schema.SObjectType tabulationSelectorType;
        Test.startTest();
        tabulationSelectorType = new TabulationsSelector().getSObjectType();
        Test.stopTest();
        system.assertEquals(false, tabulationSelectorType == null);
    }

    @isTest
    static void testGetSObjectFieldList() {
        List<Schema.SObjectField> tabulationSelectorFields = new List<Schema.SObjectField>();
        Test.startTest();
        tabulationSelectorFields = new TabulationsSelector().getSObjectFieldList();
        Test.stopTest();
        system.assertEquals(false, tabulationSelectorFields.isEmpty());
    }

    @isTest
    static void getTabulationOptionsTest() {
        List<Tabulation__c> lstTabulation = new List<Tabulation__c>();
        String rtDeveloperName = 'DigitalAttendance';

        Test.startTest();
        lstTabulation = ((TabulationsSelector) Injector.getInstance().instantiate(TabulationsSelector.class))
            .getTabulationOptions(new List<String>{ 'Name' }, rtDeveloperName);
        Test.stopTest();

        System.assertEquals(true, lstTabulation.isEmpty());
    }

    @isTest
    static void getTabulationOptionsTeamTest() {
        List<Tabulation__c> lstTabulation = new List<Tabulation__c>();
        String rtDeveloperName = 'DigitalAttendance';

        Test.startTest();
        lstTabulation = ((TabulationsSelector) Injector.getInstance().instantiate(TabulationsSelector.class))
            .getTabulationOptions(new List<String>{ 'Name' }, rtDeveloperName, '');
        Test.stopTest();

        System.assertEquals(true, lstTabulation.isEmpty());
    }

    @isTest
    static void selectByAreaAndActivityTest() {
        List<Tabulation__c> lstTabulation = new List<Tabulation__c>();

        Test.startTest();
        lstTabulation = ((TabulationsSelector) Injector.getInstance().instantiate(TabulationsSelector.class))
            .selectByAreaAndActivity('', '', '');
        Test.stopTest();

        System.assertEquals(true, lstTabulation.isEmpty());
    }
    @isTest
    static void selectFullMatByAreaTest() {
        List<Tabulation__c> lstTabulation = new List<Tabulation__c>();
        Test.startTest();
        lstTabulation = ((TabulationsSelector) Injector.getInstance().instantiate(TabulationsSelector.class))
            .selectFullMatByArea('', new Set<String>());
        Test.stopTest();

        System.assertEquals(true, lstTabulation.isEmpty());
    }
}
