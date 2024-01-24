/**
 *  @author Felipe Ferreira
 *  @company BTG - 2022
 *  @description Selector class for Case SObject
 *  @lastOnDemand
 **/
public inherited sharing class Selector extends fflib_SObjectSelector {
    public static final String SPECIFIC_RECORD_TYPE = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName()
        .get('RecordtypeDeveloperName')
        .getRecordTypeId();


    public static Set<Id> SET_RECORDTYPE_BANKING_DIGITAL = new Set<Id>{
        SPECIFIC_RECORD_TYPE
    };

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Case.CaseNumber,
            Case.Subject,
            Case.Description,
            Case.SuppliedEmail
        };
    }
    public Schema.SObjectType getSObjectType() {
        return Case.sObjectType;
    }

    public List<Case> selectById(Set<ID> idSet) {
        return (List<Case>) selectSObjectsById(idSet);
    }

    public List<Case> defaultSelect(String pStrCaseId) {
        return [
            SELECT Id, RecordType.DeveloperName, Mat__c, Area__c, Activity__c, Segment__c, CoSegment__c, Priority
            FROM Case
            WHERE Id = :pStrCaseId AND Area__ LIKE '%esteira%'
        ];
    }

    public List<Case> defaultWithSubqueryOrderByLimit(String pStrCaseId) {
        return [
            SELECT Id, RecordType.DeveloperName,
            ( SELECT Id, toLabel(Status), CaseNumber, Team__c, Description, Origin FROM Cases ),//toLabel retorna a label do picklist, se status = new e label = novo, a query mostrará 'novo'
            ( SELECT Id, JiraStatus__c, ONBArea__c, DelegateArea__c, KeyAreas__c, Key__c FROM JiraIssues__r )
            FROM Case
            WHERE Id = :pStrCaseId
            ORDER BY Mat__c
            LIMIT 10
        ];
    }

    public String aggregateResultSelect() {
        List<AggregateResult> lstAggregateResult = [
            SELECT Status, count(Id) openCases
            FROM Case
            WHERE AccountId IN (SELECT Id FROM Account WHERE Name LIKE '%Brasil&')
            AND Status != 'Closed'
            GROUP BY Status
            HAVING count(Id) > 1
            LIMIT 10000
        ];

        return !lstAggregateResult.isEmpty() ? String.valueOf(lstAggregateResult[0].get('openCases')) : '0';
    }

    public List<Case> offSetSelect(String pStrCaseId) {
        return [
            SELECT Id, RecordType.DeveloperName
            FROM Case
            WHERE Id = :pStrCaseId
            AND Tags INCLUDES('TAG1;TAG2') //INCLUDES E EXCLUDES apenas para multipicklists
            ORDER BY Mat__c
            LIMIT 10
            OFFSET 5 //Retorna apenas os itens de 6-10 (desconsidera os 5 primeiros)
        ];
    }

    public List<Case> offSetSelectSubquery(String pStrCaseId) {
        return [
            SELECT Id, RecordType.DeveloperName,
            ( SELECT Id FROM Jiraissue__r
                LIMIT 10
                OFFSET 5 //Retorna apenas os itens de 6-10 (desconsidera os 5 primeiros)
            )
            FROM Case
            WHERE Id = :pStrCaseId
            ORDER BY Mat__c
            LIMIT 1 //LIMIT 1 Obrigatório se utilizar offset em subquery
        ];
    }

    public List<Case> typeOFSelect(){
        return [
        SELECT Id,
        TYPEOF Owner //quando o owner for um objeto, pegar xpto campos correspondêntes
                WHEN User THEN Id, LastName
                WHEN Group THEN Id, Name
                ELSE Name, Email
            END
        FROM Case
        LIMIT 1000
        FOR UPDATE //Bloquei o registro de ser atualizado
        ];
    }

    public List<Account> formatedCurrency(){
        return [
                SELECT FORMAT(convertCurrency(amount)) FROM Account
                //FORMAT Formata o valor de acordo com o local do usuário
                //ConvertCurrency converte o valor para a moeda logal do usuário se houver multiple currency na org
               ];
    }

    public List<AggregateResult> convertTimeZone(){
        return [
            SELECT HOUR_IN_DAY(convertTimezone(CreatedDate)), SUM(Amount) //convert a data e hora para a datahora total
            FROM Opportunity
            GROUP BY HOUR_IN_DAY(convertTimezone(CreatedDate)) //Obrigatório
        ];
    }

    public List<AggregateResult> groupByRollup(){
        return [
            SELECT Status, Priority, COUNT(Id) countId //essa query retorna a quantidade de ids de casos agrupados por status e prioridade
            FROM Case                                  //new => low  => 10;
            GROUP BY ROLLUP(Status, Priority)          //new => high => 70
        ];
    }

    public List<Case> usingScoupe(){
        return [
            SELECT Id FROM Case USING SCOPE Everything
        ];
        /*
            Everything – Todos os registros do objeto (todos os casos)
            Mine – Registros onde o proprietário é o usuário que está executando a query
            Queue – Registros onde o proprietário é uma fila
            Delegated – Registros que foram delegados a outras pessoas. disponível apenas para versão API 17.0 em diante.
            MyTerritory – Registros cadastrados apenas no território do usuário que está executando a query. disponível apenas para versão API 17.0 em diante.
            MyTeamTerritory – Registros cadastrados apenas nos territórios dos times que o usuário pertence. . disponível apenas para versão API 17.0 em diante.
            Team – Registros atribuídos a times. disponível apenas para versão API 17.0 em diante.
        */
    }

    public List<KnowledgeArticleVersion> withDataCategory(){
        return[
            SELECT Title FROM KnowledgeArticleVersion WHERE PublishStatus='online' WITH DATA CATEGORY Earth__c AT Canada__c //AT, BELOW, ABOVE, ABOVE_OR_BELOW
        ];
        /* EXEMPLO DE CATEGORIA
            => Earth__c
                -> Asia__c
                    * India__c
                    * Bangladesh__c
                -> NorthAmerica__c
                    * Canada__c
                    * USA__c
                -> Europe__c
                    * Switzerland__c
                    * France__c
                    * German__c
        */
    }
}
