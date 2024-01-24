/**
 *  @author Felipe Ferreira
 *  @description Test Builder para objetos
 *  @lastOnDemand
 **/
@isTest
public class TestBuilder implements ITestBuilder {
    private Object record; //Object = Case...Account...

    public TestBuilder() {
        record = new Object();
        record.Subject = 'test'; //podemos setar valores na própria constructor
    }

    public static TestBuilder build() {
        return new TestBuilder(); //retorna uma instancia da test builder, nesse exemplo um novo objeto já com assunto é atribuido ao record
    }

    //insere e retorna o objeto
    public Object persist() {
        insert record;
        return record;
    }

    //apenas retorna o objeto
    public Object getInstance() {
        return record;
    }

    //Gera um id fake do registros que desejar (fflib_IDGenerator.generate(Case.SObjectType);)
    public TestBuilder withMockId() {
        record.Id = fflib_IDGenerator.generate(Object.SObjectType);
        return this;
    }

    public TestBuilder withId(Id ObjectId) {
        record.Id = ObjectId;
        return this;
    }

    public TestBuilder isSpecificRecordtype() {
        record.RecordTypeId = Schema.SObjectType.Object.getRecordTypeInfosByDeveloperName()
            .get('RecordTypeDeveloperName')
            .getRecordTypeId();
        return this;
    }

    //relacionar registros
    public TestBuilder withRelatedRecord(Contact contact) { //precisamos passar tanto o id quanto o objeto inteiro no relacionamento, pois o mock não identifica o relacionamento só pelo id, tão pouco o id pelo objeto relacionado.
        record.ContactId = contact.Id;
        record.Contact = contact;
        return this;
    }

    public TestBuilder withField(String value) {
        record.Field__c = value;
        return this;
    }
}
