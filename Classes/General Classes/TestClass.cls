/**
 *  @author Felipe Ferreira
 *  @description Test class
 *  Classe de teste mockada, atualmente uma org com aproximadamente 1000 testes mockados tem seus testes executados em 5 minutos,
 *  Ao passo que uma org com aproximadamente 1000 testes NÃO mockados tem seus testes executados em aproximadamente 40 min, a depender da quantidade de DMLs executados
 *  @lastOnDemand
 **/
@isTest
private class TestClass {
    private static fflib_ApexMocks mocks;
    private static Injector mockInjector;
    private static DML mockDML;
    private static ServiceClass mockServiceClass;
    private static SelectorClass mockSelectorClass;

    static {
        mocks = new fflib_ApexMocks();
        mockInjector = (Injector) mocks.mock(Injector.class);
        mockDML = (DML) mocks.mock(DML.class);
        mockSelectorClass = (SelectorClass) mocks.mock(SelectorClass.class);
        mockServiceClass = (ServiceClass) mocks.mock(ServiceClass.class);

        mocks.startStubbing();
            mocks.when(mockInjector.instantiate(DML.class)).thenReturn(mockDML);
            mocks.when(mockInjector.instantiate(SelectorClass.class)).thenReturn(mockSelectorClass);
            mocks.when(mockInjector.instantiate(ServiceClass.class)).thenReturn(mockServiceClass);
        mocks.stopStubbing();

        Injector.mockInjector = mockInjector;
    }

    @isTest
    static void testeMethod() {
        Object objNew = ObjectTestBuilder.build()
            .isSpecificRecordtype() //método para definir um rt específico
            .withField('value') //método para definir um valor específico num campo
            .withMockId() //método para simular um id no registro (Id Mockado)
            .getInstance(); //retorna a instancia do registro (em testes mockados, não queremos usar o .persist() que insere o registro na base de teste)

        Object objOld = ObjectTestBuilder.build()
            .isSpecificRecordtype()
            .withField('value')
            .withId(objNew.Id) //with ID é utilizado para para relacionar um oldRecord com um newRecord, se o método estará no old ou no new, não importa.
            .getInstance();

        //Se houver algum campo como formulas, Mestre-Detalhe ou algum outro campo que não for 'Writeble', basta utilizar a TestUtils
        objNew = (Object) TestUtils.setReadOnlyFields(
            objNew,
            Object.class,
            new Map<String, Object>{'FormulaField__c' => 'Value', 'MasterDetailField__c' => new Object(/**campos */)}
        );

        mocks.startStubbing();
            //Quando o mockVoidMethod é chamado ele não estoura null pointer, não impedindo o decorrer de um fluxo
            mocks.mockVoidMethod( //mock de método void
                mockServiceClass, //mock que será chamado
                'método',         //nome do método na ServiceClass
                new List<Type>{ List<Object>.class, String.class }, //Quais são os tipos de parâmetros esperados no método
                new List<Object>{ new List<Object>{ objNew }, 'string value' } //Argumentos passados no método
            );

            //Quando o mock.when é chamado, podemos setar um valor específico para retorno, somente se o método retornar algo.
            mocks.when(
                mockServiceClass.método( //quando o método for chamado então retornarão uma lista de conta vazia (poderia conter uma conta manipulada)
                    (Set<String>) fflib_Match.anyObject(), //fflib_Mathc utilizado para permitir qualquer argumento no método, se quiser retornar um valor específico quando argumentos específicos forem passados, também é possivel
                    (Set<String>) fflib_Match.anyObject() // não é possivel misturar fflib_match, com valores específicos.
                )
            )
            .thenReturn(new List<Account>{ objAccount });
        mocks.stopStubbing();

        Test.startTest();
        (new ServiceClass()).método(
                new List<Object>{ objNew },
                new Map<Id, Object>{
                    objOld.Id => objOld
                },
                'recordTypeDomain' //estrutura de domain, pode ser visualisada nas triggers
            );
        Test.stopTest();
    }
}
