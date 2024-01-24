import { api, track, LightningElement } from 'lwc';

export default class TabCombobox extends LightningElement {
    @api fieldLabel;
    @api fieldName;

    @track options;
    @api selected = undefined;

    @api tabRecords;
    @api controlField;
    @api controlValue;
    @api mapCurrentRecordValues = [];

    handleOnChange(event) {
        this.selected = event.detail.value;
        this.dispatchEvent(new CustomEvent('select', { detail: this.detail() }));
    }

    @api
    refresh(controlField, controlValue, mapCurrentRecordValues) {
        this.selected = undefined;
        this.controlField = controlField;
        this.controlValue = controlValue;
        this.mapCurrentRecordValues = mapCurrentRecordValues;
        this.refreshOptions();
        this.dispatchEvent(new CustomEvent('refresh', { detail: this.detail() }));
    }

    @api
    setValue(value) {
        this.selected = value;
    }

    detail() {
        return {
            fieldName: this.fieldName,
            selected: this.selected
        };
    }

    refreshOptions() {
        if (!this.tabRecords) {
            return;
        }
        console.log('DynamicTabulation FEFO tabRecords' + JSON.stringify(this.tabRecords));
        let arrayOptions = [];
        let setOptions = new Set();

        for (let i = 0; i < this.tabRecords.length; i++) {
            let option = this.tabRecords[i];
            let fielValue = option[this.fieldName];
            let controlValue = this.controlField ? option[this.controlField] : undefined;
            let isValidOption = true;
            let hasFieldControl = false;

            this.mapCurrentRecordValues.forEach((currentOpt) => {
                let currentValue = currentOpt.field ? option[currentOpt.field] : undefined;
                hasFieldControl = currentOpt.field === this.controlField ? true : hasFieldControl;

                if (currentOpt.value && currentValue && controlValue && controlValue != currentOpt.controlValue) {
                    isValidOption = false;
                }
            });

            if (
                (isValidOption && hasFieldControl && this.mapCurrentRecordValues && this.mapCurrentRecordValues.length > 0) ||
                !this.controlField ||
                (!this.mapCurrentRecordValues && this.controlValue && controlValue && controlValue == this.controlValue)
            ) {
                if (!setOptions.has(fielValue)) {
                    arrayOptions.push({ label: fielValue, value: fielValue });
                    setOptions.add(fielValue);
                }
            }
        }
        arrayOptions.sort((a, b) => (a.label > b.label ? 1 : -1));
        this.options = arrayOptions;
    }

    currentValue(currentValue) {
        this.selected = currentValue;
    }
}
