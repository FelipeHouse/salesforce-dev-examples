import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { getFieldValue, getRecord, updateRecord } from "lightning/uiRecordApi";
import { getObjectInfo } from "lightning/uiObjectInfoApi";

import TABULATION_OBJECT from "@salesforce/schema/Tabulation__c";

import getFieldsOptions from "@salesforce/apex/RecordEditTabController.getFieldsOptions";
import getFieldsToDisplay from "@salesforce/apex/RecordEditTabController.getFieldsToDisplay";
import labelTabulationSearch from "@salesforce/label/c.labelTabulationSearch";
import placeholderTabulationSearch from "@salesforce/label/c.placeholderTabulationSearch";

export default class DynamicTabulation extends LightningElement {
  // default injected
  @api recordId;
  @api objectApiName;
  // meta variables
  @api title;
  @api cardIconName;

  //track
  @track formFields = [];
  @track mode = "view";
  @track isLoading = false;

  //record info
  recordTypeId;
  teamValue;
  allValidFields = [];
  recordFields = [];

  currentFieldValues = {};
  relatedFields = {};
  recordInfo;
  tabOptions = [];
  objectInfo;
  fieldRecordTypeValidRecord = "RecordTypeId";
  tabulationIconName = "standard:timeslot";

  fieldsFilter = ["Case.Team__c"];

  label = {
    labelTabulationSearch,
    placeholderTabulationSearch,
  };

  getFieldsToDisplay() {
    if (this.recordTypeId && this.objectApiName) {
      getFieldsToDisplay({
        recordTypeId: this.recordTypeId,
        objectApiName: this.objectApiName,
      })
        .then((data) => {
          this.allValidFields = data.tabulationFields;
          this.assembleFields();
        })
        .catch((error) => {
          console.error(error);
        });
    }
  }

  renderedCallback() {
    this.initializeFormCurrentInfo();
  }

  getFieldsOptions() {
    if (
      this.recordTypeId &&
      this.objectApiName &&
      this.tabOptions.length == 0
    ) {
      this.toggleIsLoading();

      getFieldsOptions({
        recordTypeId: this.recordTypeId,
        objectApiName: this.objectApiName,
        teamValue: this.teamValue,
      })
        .then((data) => {
          this.tabOptions = data.options;
          this.getMaxDependencyLevel();
          this.mode = "edit";
          this.toggleIsLoading();
        })
        .catch((error) => {
          console.error(error);
          this.toggleIsLoading();
        });
    } else if (this.tabOptions.length > 0) {
      this.mode = "edit";
    }
  }

  @wire(getRecord, { recordId: "$recordId", fields: "$fieldsFilter" })
  wiredRecordRelated({ error, data }) {
    if (data) {
      this.recordTypeId = data.recordTypeInfo.recordTypeId;
      this.teamValue = data.fields.Team__c.value;
      this.getFieldsToDisplay();
    } else if (error) {
      console.error("wiredRecordRelated " + JSON.stringify(error));
    }
  }

  getMaxDependencyLevel() {
    for (let iF = 0; iF < this.allValidFields.length; iF++) {
      let mainFieldApiName = this.allValidFields[iF];
      let lstFilledFields = this.relatedFields[mainFieldApiName];
      for (let iO = 0; iO < this.tabOptions.length; iO++) {
        let iOption = this.tabOptions[iO];
        if (iOption) {
          for (let iF = 0; iF < this.allValidFields.length; iF++) {
            let fieldApiName = this.allValidFields[iF];

            if (iOption[fieldApiName] && iOption[mainFieldApiName]) {
              if (lstFilledFields) {
                if (!lstFilledFields.includes(fieldApiName)) {
                  lstFilledFields.push(fieldApiName);
                }
              } else {
                lstFilledFields = [fieldApiName];
              }
            }
          }
        }
        this.relatedFields[mainFieldApiName] = lstFilledFields;
      }
    }
  }

  toggleIsLoading() {
    this.isLoading = !this.isLoading;
  }

  assembleFields() {
    if (this.allValidFields && this.allValidFields.length) {
      if (this.objectApiName && this.recordFields.length == 0) {
        let recordFields = [];
        this.allValidFields.forEach((field) => {
          recordFields.push(this.objectApiName + "." + field);
        });
        this.recordFields = recordFields;
      }

      if (this.objectInfo && this.formFields.length == 0) {
        let formFields = [];

        this.allValidFields.forEach((field) => {
          let meta = this.objectInfo.fields[field];
          formFields.push({ label: meta.label, apiName: meta.apiName });
        });

        this.formFields = formFields;
      }
    }
  }

  @wire(getObjectInfo, { objectApiName: TABULATION_OBJECT })
  wiredObject({ error, data }) {
    if (error) {
      console.error(error);
    } else if (data) {
      this.objectInfo = data;
      this.assembleFields();
    }
  }

  @wire(getRecord, { recordId: "$recordId", fields: "$recordFields" })
  wiredRecord({ error, data }) {
    if (error) {
      console.error(error);
    } else if (data) {
      this.recordInfo = data;
      this.initializeFormCurrentInfo();
    }
  }

  initializeFormCurrentInfo() {
    if (this.recordInfo && this.formFields && this.allValidFields) {
      this.setCurrentFieldValues();
    }
  }

  setCurrentFieldValues() {
    this.allValidFields.forEach((field) => {
      let meta = this.fieldMeta(field);

      let value = this.recordInfo.fields[field].value;
      this.currentFieldValues[field] = value;

      this.loadFieldOptions(meta);
      this.changeFieldValue(meta, value);
    });
  }

  loadFieldOptions(meta) {
    let fieldElement = this.template.querySelector(
      "[data-name='" + meta.fieldName + "']"
    );
    if (fieldElement) {
      fieldElement.refresh(
        meta.controlField,
        meta.controlValue,
        this.getMapFieldDependency(this.allValidFields, meta.controlField)
      );
    }
  }

  getMapFieldDependency(fields, controlField) {
    //Map to configure tababulation fields dependency
    let mapFieldDependency = [];

    fields.forEach((field) => {
      if (this.currentFieldValues[field] != undefined) {
        mapFieldDependency.push({
          field: field,
          value: this.currentFieldValues[field],
          controlValue: this.currentFieldValues[controlField],
        });
      }
    });

    return mapFieldDependency;
  }

  refreshField(meta) {
    this.loadFieldOptions(meta);
  }

  fieldMeta(fieldName) {
    let index;
    let controlField;
    if (Object.keys(this.relatedFields).length > 0) {
      let lstRelatedFields = this.relatedFields[fieldName];
      lstRelatedFields =
        lstRelatedFields === undefined ? [fieldName] : lstRelatedFields;
      index = lstRelatedFields.indexOf(fieldName);
      controlField = index > 0 ? lstRelatedFields[index - 1] : undefined;
    } else {
      index = this.allValidFields.indexOf(fieldName);
      controlField = index > 0 ? this.allValidFields[index - 1] : undefined;
    }
    let controlValue = undefined;

    if (controlField) {
      let controlElement = this.template.querySelector(
        "[data-name='" + controlField + "']"
      );
      if (controlElement) {
        controlValue = controlElement.selected;
      }
    }

    return {
      fieldName: fieldName,
      index: index,
      controlField: controlField,
      controlValue: controlValue,
    };
  }

  changeFieldValue(meta, value) {
    let fieldElement = this.template.querySelector(
      "[data-name='" + meta.fieldName + "']"
    );
    if (fieldElement) {
      fieldElement.setValue(value);
    }
  }

  handleOnSelect(event) {
    let detail = event.detail;
    this.currentFieldValues[detail.fieldName] = detail.selected
      ? detail.selected
      : "";
    this.refreshNextField(detail.fieldName);
  }

  handleOnRefresh(event) {
    let detail = event.detail;
    this.refreshNextField(detail.fieldName);
  }

  refreshNextField(fieldName) {
    let index = this.allValidFields.indexOf(fieldName); //['tabulationtype__c', 'Segmento__c', 'CoSegmento__c']
    let indexDependency = this.relatedFields[fieldName].indexOf(fieldName);
    let lstDependencyFields = this.relatedFields[fieldName].slice(
      indexDependency + 1
    );
    if (index < this.allValidFields.length - 1) {
      let fieldsDependency = lstDependencyFields;

      //clear values for next fields dependency
      fieldsDependency.forEach((field) => {
        if (lstDependencyFields.length > 0) {
          this.currentFieldValues[field] = "";
          let meta = this.fieldMeta(field);
          this.refreshField(meta);
        }
      });
    }
  }

  handleSubmit(event) {
    this.toggleIsLoading();
    // stop the form from submitting
    event.preventDefault();

    // get details fields
    let eventFields = event.detail.fields;

    // tabulations fields
    let fields = this.currentFieldValues;

    // recordToUpdate
    let recordToUpdate = {
      ...eventFields,
      ...fields,
    };

    this.template
      .querySelector("lightning-record-edit-form")
      .submit(recordToUpdate);
  }

  handleSuccess(event) {
    this.mode = "view";
    this.showToast(
      "SUCESSO",
      "Tabulação salva com sucesso",
      "success",
      "dismissable"
    );
    this.toggleIsLoading();
  }
  handleErrors(event) {
    this.mode = "edit";
    let target = event.detail;
    this.showToast(target.message, target.detail, "error", "dismissable");
    this.toggleIsLoading();
  }

  handleEditClick(event) {
    this.getFieldsOptions();
  }

  handleCancelClick(event) {
    this.mode = "view";
  }

  showToast(title, message, variant, mode) {
    const event = new ShowToastEvent({
      title: title,
      message: message,
      variant: variant,
      mode: mode,
    });
    this.dispatchEvent(event);
  }

  get isViewMode() {
    return this.mode == "view";
  }

  get isEditMode() {
    return this.mode == "edit";
  }
}
