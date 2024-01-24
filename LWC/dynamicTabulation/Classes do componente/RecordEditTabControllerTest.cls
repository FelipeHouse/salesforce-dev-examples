@isTest
public with sharing class RecordEditTabControllerTest {
    @isTest
    static void initValuesTest(){

        Case lCase = buildCase();        

        RecordEditTabController.InitValuesResponse response = new RecordEditTabController.InitValuesResponse();

        Test.startTest();
        response = RecordEditTabController.initValues(lCase.recordtypeid, 'Case', null);
        Test.stopTest();

        System.assertEquals(true, response != null);

    }

    @isTest
    static void initValuesDigitalWithTeamToConsiderTest(){

        Case lCase = CaseTestBuilder.build().withStatus('New').isDigitalAttendance().withTeam('WM').persist();

        RecordEditTabController.InitValuesResponse response = new RecordEditTabController.InitValuesResponse();

        Test.startTest();
        response = RecordEditTabController.initValues(lCase.recordtypeid, 'Case', lCase.Team__c);
        Test.stopTest();

        System.assertEquals(true, response != null);

    }

    @isTest
    static void initValuesDigitalWithoutTeamToConsiderTest(){

        Case lCase = CaseTestBuilder.build().withStatus('New').isDigitalAttendance().withTeam('BI').persist();        

        RecordEditTabController.InitValuesResponse response = new RecordEditTabController.InitValuesResponse();

        Test.startTest();
        response = RecordEditTabController.initValues(lCase.recordtypeid, 'Case', lCase.Team__c);
        Test.stopTest();

        System.assertEquals(true, response != null);

    }

    private static Case buildCase() {
        return CaseTestBuilder.build()            
            .withStatus('New')
            .isBankingAttendance()
            .persist();
    }
}