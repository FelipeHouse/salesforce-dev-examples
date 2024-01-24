/**
 *  @author Felipe Ferreira
 *  @description Object trigger
 *  @lastOnDemand
**/
trigger ObjectTrigger on Case (before insert,before update, after update, after insert) {

    fflib_SObjectDomain.triggerHandler(Objects.class);

}