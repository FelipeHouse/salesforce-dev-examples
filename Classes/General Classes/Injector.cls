/**
 *  @author Felipe Ferreira
 *  @description Test class CasesService
 *  @lastOnDemand
 **/

public class Injector {
    private static Injector instance;
    @TestVisible
    private static Injector mockInjector;

        public static Injector getInstance() {
            instance = (instance == null && mockInjector != null) ? mockInjector : new Injector();

            return instance;
        }

    public Object instantiate( Type classType ) {
        Object instance = classType.newInstance();
        return instance;
    }
    /**
     * Como chamar a injector:
     *  -O método chamado não pode ser static, pois a injector instancia a classe (new ApexClass()).método();
     *  Classe:
     *   public class classeApex{
     *       public void método(){ funções }
     *   }
     *   Chamada da classe pela Injector:
     *   ((classeApex) Injector.getInstance().Instantiate()).método();
     *
     * A Injector é utilizada para testes mockados, agilizando a esteira de aplicação e fazendo testes individualizados.
     */
}