/**
 *  @author Felipe Ferreira
 *  @description Service class for Object
 *  @lastOnDemand
 **/
public with sharing class ObjectService {
    private static final Map<String, String> MAP_FINAL = new Map<String, String>{
        'Chave' => 'Valor'
    };

    public void método(List<Case> lstCase, String domainName) {
        switch on domainName {
            when 'RecordtypeDomain' {
                //lógica
            }
            when 'RTDomain2' {
                //lógica
            }
        }
    }
}
