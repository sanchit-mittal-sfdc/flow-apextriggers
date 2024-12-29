/**
 * @description       : 
 * @author            : Amit Singh - PantherSchools
 * @group             : 
 * @last modified on  : 06-26-2024
 * @last modified by  : Amit Singh - PantherSchools
**/
public without sharing class FormulaCalculator {
    public static FINAL Map<String, FormulaEval.FormulaReturnType> MAP_RETURN_TYPES_ENUM = new Map<String, FormulaEval.FormulaReturnType>{
        'Boolean' => FormulaEval.FormulaReturnType.BOOLEAN,
        'String' => FormulaEval.FormulaReturnType.STRING,
        'Integer' => FormulaEval.FormulaReturnType.INTEGER,
        'Decimal' => FormulaEval.FormulaReturnType.DECIMAL,
        'Double' => FormulaEval.FormulaReturnType.DOUBLE,
        'Id' => FormulaEval.FormulaReturnType.ID,
        'Date' => FormulaEval.FormulaReturnType.DATE,
        'Datetime' => FormulaEval.FormulaReturnType.DATETIME,
        'Time' => FormulaEval.FormulaReturnType.TIME,
        'Long' => FormulaEval.FormulaReturnType.LONG
    };
}