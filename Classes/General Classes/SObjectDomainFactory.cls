/**
*  @author Felipe Ferreira
*  @description Base SObjectDomainFactory
*  @lastOnDemand
*  @upd
**/
public virtual class SObjectDomainFactory {
    protected virtual Map<String, String> getIdentifierType() {
        throw new CustomException('Missing getIdentifierType implementation.');
    }

    protected virtual Map<String, String> getIdentifiersDomainConstructor() {
        throw new CustomException('Missing getIdentifiersDomainConstructor implementation.');
    }

    public virtual fflib_SObjectDomain createDomain( String identifier, List<SObject> lstSObjects ) {
        // Determine Apex classes for the identifier

        Map<String, String> mapType = getIdentifierType();
        String domainConstructorName = mapType.get( identifier );
        if ( domainConstructorName != null ) {
            Type constructableClass = Type.forName( domainConstructorName );
			fflib_SObjectDomain.IConstructable domainConstructor = (fflib_SObjectDomain.IConstructable) constructableClass.newInstance();
            fflib_SObjectDomain domainObject = domainConstructor.construct( lstSObjects );
            return domainObject;
        }

        return null;
    }
}