/**
 * @description       :
 * @author            : Guilherme Cardoso
 * @group             :
 * @last modified on  : 06-10-2023
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 **/
public class TabulationHelperFactory {
    public static MacroTabulation createHelperBySObjectRecordType(String sObjectType, String recordTypeDeveloperName, String teamValue) {
        Map<String, Map<String, String>> mapIdentifierSObject = new Map<String, Map<String, String>>{
            'Case' => new Map<String, String>{
                'BankingAttendance' => 'MacroTabulationBankingAttendance.Constructor',
                'BaasAttendance' => 'MacroTabulationBaasAttendance.Constructor',
                'DigitalAttendance' => 'MacroTabulationDigitalAttendance.Constructor',
                'BaasAttendancePortal' => 'MacroTabulationBaasAttendancePortal.Constructor',
                'PocketAttendance' => 'MacroTabulationPocketAttendance.Constructor',
                'MiddleAttendance' => 'MacroTabulationMiddleAttendance.Constructor',
                'SupportCashAttendance' => 'MacroTabulationSupportCashAttendance.Constructor',
                'CreditAttendance' => 'MacroTabulationCreditAttendance.Constructor',
                'PMEAttendance' => 'MacroTabulationPMEAttendance.Constructor',
                'OpsChargeAttendance' => 'MacroTabulationOpsChargeAttendance.Constructor',
                'CustodyAttendance' => 'MacroTabulationCustodyAttendance.Constructor',
                'FundsAttendance' => 'MacroTabulationFundsAttendance.Constructor',
                'OpsPrevIcatuAttendance' => 'MacroTabulationOpsPrevIcatuAttendance.Constructor',
                'ProductsFundsTableAttendance' => 'MacroTabulationProdFundsTableAttendance.Constructor',
                'OpOnbAttendance' => 'MacroTabulationOpOnbAttendance.Constructor',
                'AMLAttendance' => 'MacroTabulationAMLAttendance.Constructor',
                'IntlBranchesIFAttendance' => 'MacroTabulationIntlBranchesIFAttendance.Constructor',
                'EquityFutureAttendance' => 'MacroTabulationEquityFutureAttendance.Constructor',
                'HSPreventAttendance' => 'MacroTabulationHSPreventAttendance.Constructor',
                'FraudPreventionAttendance' => 'MacroTabulationFraudPreventionAttendance.Constructor',
                'FIDICAttendance' => 'MacroTabulationFIDICAttendance.Constructor',
                'PensionsAttendance' => 'MacroTabulationPensionsAttendance.Constructor',
                'PrivateBondsAttendance' => 'MacroTabulationPrivateBondsAttendance.Constructor',
                'PublicBondsAttendance' => 'MacroTabulationPublicBondsAttendance.Constructor',
                'OperationsOverTheCounterAttendance' => 'MacroTabulationCounterProducts.Constructor'
            }
        };

        Map<String, String> mapIdentifierHelperConstructor = mapIdentifierSObject.get(sObjectType);
        if (mapIdentifierHelperConstructor != null) {
            String domainConstructorName = mapIdentifierHelperConstructor.get(recordTypeDeveloperName);
            if (domainConstructorName != null) {
                Type constructableClass = Type.forName(domainConstructorName);
                MacroTabulation.IConstructable domainConstructor = (MacroTabulation.IConstructable) constructableClass.newInstance();
                MacroTabulation helperObject;
                if (recordTypeDeveloperName == 'DigitalAttendance' && String.isNotBlank(teamValue)) {
                    helperObject = domainConstructor.construct(teamValue);
                } else {
                    helperObject = domainConstructor.construct(recordTypeDeveloperName);
                }
                return helperObject;
            }
        }

        return null;
    }
}
