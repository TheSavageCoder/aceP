#include "script_component.hpp"
/*
 * Author: 2LT.Mazinski
 * Opens an IV/IO on a patient and changes the patient's flow variable
 *
 * Arguments:
 * 0: Medic <OBJECT>
 * 1: Patient <OBJECT>
 * 2: Body Part <STRING>
 * 3: Treatment (not used) <STRING>
 * 4: Item User (not used) <OBJECT>
 * 5: Used Item <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [player, cursorObject, "LeftLeg", "", objNull, "kat_IV_20"] call kat_circulation_fnc_fractureCheck;
 *
 * Public: No
 */

params ["_medic", "_patient", "_bodyPart"];

private _part = ALL_BODY_PARTS find toLower _bodyPart;
private _fractureArray = _patient getVariable [QGVAR(fractures), [0,0,0,0,0,0]];
private _liveFracture = _fractureArray select _part;
private _fractureString = "";

if (_liveFracture != 0) exitWith {

    if (_liveFracture >= 3) then  {
        _fractureString = "Comminuted Fracture";
    };

    if (_liveFracture >= 2 && _liveFracture < 3) then {
        _fractureString = "Compound Fracture";
    };

    if (_liveFracture == 1) then {
        _fractureString = "Simple Fracture";
    };
    [_patient, "quick_view", LSTRING(fracture_log), [_fractureString, STRING_BODY_PARTS select _part]] call ace_medical_treatment_fnc_addToLog;  
};

private _value = random 100;

if (_value <= GVAR(simpleChance)) then {
    _liveFracture = 1;
    _fractureString = "Simple Fracture";
} else {
    private _subValue = random 100;
    if (_subValue <= GVAR(compoundChance)) then {
        _liveFracture = 2;
        _fractureString = "Compound Fracture";
    } else {
        _liveFracture = 3;
        _fractureString = "Comminuted Fracture";
    };
};

[_patient, "quick_view", LSTRING(fracture_log), [_fractureString, STRING_BODY_PARTS select _part]] call ace_medical_treatment_fnc_addToLog;
_fractureArray set [_part, _liveFracture];

_patient setVariable [QGVAR(fractures), _fractureArray, true];

