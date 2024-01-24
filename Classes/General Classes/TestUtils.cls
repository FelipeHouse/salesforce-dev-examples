/**
 *  @author Felipe Ferreira
 *  @description Funcionalidades de testes genéricas (não inclusas nas fflibs)
 *  @lastOnDemand
**/

public with sharing class TestUtils {
    public static Object setReadOnlyFields(SObject objInstance, Type deserializeType, Map<String, Object> properties) {
        Map<String, Object> mergedMap = new Map<String, Object>(objInstance.getPopulatedFieldsAsMap());
        for (String field : properties.keySet()) {
            // Merge the values from the properties map into the fields already set on the object
            mergedMap.put(field, properties.get(field));
        }
        // Serialize the merged map, and then deserialize it as the desired object type.
        String jsonString = JSON.serializePretty(mergedMap);
        return (SObject) JSON.deserialize(jsonString, deserializeType);
    }
}