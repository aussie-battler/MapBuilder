/*
    Function:       MB_fnc_uiPaneResize
    Author:         Adanteh
    Description:    Resizes the pane. If it's a floating pane, allow both X and Y transformation. Else only Y
*/
#include "\mb\MapBuilder\ui\mbdefinesNew.hpp"

params ["_ctrl", ["_mode", "start"]];

switch (toLower _mode) do {
    case "start": {
        private _paneCtrl = ctrlParentControlsGroup (ctrlParentControlsGroup _ctrl);
        private _collapsed = _paneCtrl getVariable ["collapsed", false];
        private _floating = _paneCtrl getVariable ["floating", false];

        private _contentPosReal = [_paneCtrl] call MB_fnc_getCtrlPositionReal; // Get real position, not the position within controlGroup
        private _display = ctrlParent _paneCtrl;
        private _contentCtrl = _paneCtrl controlsGroupCtrl __IDC_PANE_CONTENT;

        private _adjustX = _floating; // -- Only adjust width if not attached to a sidebar
        uiNamespace setVariable ["MB_ResizingTarget", _contentCtrl];
        private _resizeHandle = ([_contentPosReal, _adjustX] spawn {
            disableSerialization;
            params ["_contentPosReal", "_adjustX"];

            // TOOD: Replace by perFrame
            // TODO: Create button up and button down framework
            while { !(isNull (__GUI_WINDOW)) } do {
                private _sizeY = (getMousePosition select 1) - (_contentPosReal select 1);
                private _sizeX = [-1, (getMousePosition select 0) - (_contentPosReal select 0)] select _adjustX;

                [(uiNamespace getVariable ["MB_ResizingTarget", controlNull]), _sizeY, _sizeX] call MB_fnc_uiAdjustContentCtrl;
                uiSleep 0.1;
            };
        });

        uiNamespace setVariable ["MB_ResizingHandle", _resizeHandle];

    };

    case "end": {
        private _handle = uiNamespace getVariable "MB_ResizingHandle";
        if (isNil "_handle") exitWith { };

        terminate _handle;
        private _contentCtrl = uiNamespace getVariable ["MB_ResizingTarget", controlNull];
        private _newHeight = (ctrlPosition _contentCtrl) select 3;

        uiNamespace setVariable ["MB_ResizingHandle", nil];
        uiNamespace setVariable ["MB_ResizingTarget", nil];
        private _paneCtrl = ctrlParentControlsGroup _contentCtrl;
        private _paneID = _paneCtrl getVariable ["id", ""];

        [_paneCtrl] call MB_fnc_uiPanesShift;
        [["ui.setting", _paneID, "sizeY"], _newHeight] call MB_fnc_uiSetSetting;
    };

};

true
