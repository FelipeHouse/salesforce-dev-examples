public with sharing class MacroTabulationOpOnbAttendance extends MacroTabulation {
    public MacroTabulationOpOnbAttendance() {
        this.mapSObject = new Map<String, Set<String>>();

        this.mapSObject.put(
            'Tabulation__c',
            new Set<String>{
                'TabulationType__c',
                'Segment__c',
                'CoSegment__c',
                'Area__c',
                'Activity__c',
                'Mat__c',
                'Officer__c',
                'Desk__c',
                'Complexity__c'
            }
        );

        this.mapSObject.put(
            'Case',
            new Set<String>{
                'TabulationType__c',
                'Segment__c',
                'CoSegment__c',
                'Area__c',
                'Activity__c',
                'Mat__c',
                'Officer__c',
                'Desk__c',
                'Complexity__c'
            }
        );

        this.recordTypeDeveloperName = 'OpOnbAttendance';
    }

    public class Constructor implements MacroTabulation.IConstructable {
        public MacroTabulation construct(String recordTypeDeveloperName) {
            return new MacroTabulationOpOnbAttendance();
        }
    }
}
