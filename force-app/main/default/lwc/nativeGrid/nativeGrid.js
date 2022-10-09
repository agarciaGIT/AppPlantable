import { LightningElement, api, track } from 'lwc';

export default class NativeGrid extends LightningElement {
    // Inputs from partent component
    @api headers;
    @api fields;
    @api hasFooter = false;
    @api get rows() {
        return this.displayRows;
    }

    // Rows for display. Processed from input rows.
    @track displayRows;

    // Processed headers
    get headerRows() {
        let headerRows = [{index: 'head_0', value: 'Row Index'}];

        if(this.headers) {
            for(let i=0; i<this.headers.length; i++) {
                headerRows.push({index: 'head_' + (i+1), value: this.headers[i]});
            }
        }

        return headerRows;
    }

    // For column span on: 1 child row, 2 no row message, 3 footer
    get columnCnt() {
        return this.headers.length + 1;
    }

    get hasRows() {
        let hasRows = false;
        if(this.displayRows && this.displayRows.length > 0) {
            hasRows = true;
        }

        return hasRows;
    }

    set rows(inptRows) {
        //console.log('Inside set rows');
        this.displayRows = this.calculateRows(inptRows);
    }

    calculateRows(inptRows) {
        let recordRows = [];

        if(inptRows && this.fields) {
            // Setup Display Rows
            for(let i=0; i<inptRows.length; i++) {
                let row = inptRows[i];
                
                let fieldRows = [{name: 'Row_Index', value: i+1}];

                for(let j=0; j<this.fields.length; j++) {
                    let fldName = this.fields[j];
                    let fldVal = this.getFieldValue(fldName, row);
                    
                    fieldRows.push({name:fldName, value:fldVal});
                }

                let allChildList;
                if(row.child) {
                    allChildList = [];

                    row.child.forEach(oneChild => {
                        let objName = oneChild.object;
                        let oneChildList = [];
                        oneChildList.list_index = 'childList_' + i;
                        oneChildList.objName = objName;
                        oneChildList.colorClass = oneChild.color;

                        oneChild.records.forEach(oneRec => {
                            let singleChild = JSON.stringify(oneRec);
                            oneChildList.push({obj: objName, id: oneRec.Id, data: singleChild});
                        });

                        allChildList.push(oneChildList);
                    });
                }

                let rowObj = {index: 'row_' + i, fields: fieldRows, child_index: 'childRow_' + i};
                if(allChildList && allChildList.length > 0) {
                    rowObj.child = allChildList;
                }

                recordRows.push(rowObj);
            }
        }

        return recordRows;
    }

    getFieldValue(fldName, row) {
        let fldVal;

        if(fldName.includes('.')) {
            let objRef = row;
            for(let objName of fldName.split('.')) {
                objRef = objRef[objName];
            }
            fldVal = objRef;
        }else {
            fldVal = row[fldName];
        }

        return fldVal;
    }
}