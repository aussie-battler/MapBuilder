//################################################
//# Map Builder Export Functions
//# Author: Dennis "NeoArmageddon" Meyer
//# For instructions and license see readme-file
//################################################

MB_fnc_exportTB = {
	_filename = [_this,0,"noFilename"] call bis_fnc_param;
	
	_path = ("MB_FileIO" callExtension format["open_w|export\%1.txt",_filename]);
	systemChat format["Opening %1",_path];
	_count = 0;
	_mapframeX = 200000;
	_mapframeY = 0;
	{
		_obj = _x;
		_pos = [_obj,[_mapframeX,_mapframeY]] call MB_fnc_exactPosition;
		_height = str ((getposATL _obj) select 2);
		_dir = getdir _obj;
		_model = getText (configFile >> "CfgVehicles" >> (typeof _obj) >> "model");
		_model = toLower(_model);

		//Split modelname into parts
		_model = [_model,"\"] call BIS_fnc_splitString;
		//Extract last part (model.p3d) and split into name and extension
		_model = [(_model select (count(_model)-1)),"."] call BIS_fnc_splitString;
		//Use extension
		_model = _model select 0;
		
		_pitchBank = _obj call BIS_fnc_getPitchBank;
		
		_pitch = [_pitchBank select 0] call MB_fnc_roundNumbers;
		_bank = [_pitchBank select 1] call MB_fnc_roundNumbers;
		_scale = 1;

		_dir = [_dir] call MB_fnc_roundNumbers;
		//_name;_x_pos;_y_pos;_yaw;_pitch;_roll;_scale;_z_pos_rel;
		

		_string = format["write|""%1"";%2;%3;%4;%5;%6;%7;%8",_model,(_pos select 0),(_pos select 1),_dir,_pitch,_bank,_scale,_height];
		systemChat ("MB_FileIO" callExtension _string);
		_count = _count + 1;
	 
	} foreach ((MB_Layers select MB_CurLayer) select 0);
	systemChat ("MB_FileIO" callExtension "close");
	systemchat format["%1 objects exported to %2.",_count,_path];
};
MB_fnc_exportSQF = {
	_filename = [_this,0,"noFilename"] call bis_fnc_param;
	if(_filename == "") exitWith {systemChat "Error: Export needs a name!";};
	_path = ("MB_FileIO" callExtension format["open_w|export\%1.sqf",_filename]);
	systemChat format["Opening %1",_path];
	private["_number","_digits","_acc"];
	"MB_FileIO" callExtension "write|//This file was generated by Map Builder";
	"MB_FileIO" callExtension "write|//To load this objects copy this script to your mission and put";
	"MB_FileIO" callExtension format["write|// nil = [] execVM ""%1.sqf"";",_filename];
	"MB_FileIO" callExtension "write|//in your init.sqf or a trigger-activation.";
	systemChat ("MB_FileIO" callExtension "write|private[""_obj""];");
	_count = 0;
	{
		_obj = _x;
		_dir = getdir _obj;

		_pitchBank = _obj call BIS_fnc_getPitchBank;
		
		_pitch = [_pitchBank select 0,3] call MB_fnc_roundNumbers;
		_bank = [_pitchBank select 0,3] call MB_fnc_roundNumbers;
		_type = (typeof _obj);
		_obj = _x;
		_pos = [_obj] call MB_fnc_exactPosition;
		_height = str ((getposATL _obj) select 2);
		_pos pushBack _height;
		_dir = [getdir _obj,3] call MB_fnc_roundNumbers;
		_string = format["write|_obj = ""%1"" createvehicle %2;",_type,str _pos];
		systemChat ("MB_FileIO" callExtension _string);
		_string = format["write|_obj setposATL %1;",str _pos];
		systemChat ("MB_FileIO" callExtension _string);
		_string = format["write|_obj setdir %1;",_dir];
		systemChat ("MB_FileIO" callExtension _string);
		_string = format["write|[_obj,%1,%2] call BIS_fnc_setPitchBank;",_pitch,_bank];
		systemChat ("MB_FileIO" callExtension _string);
		_count = _count + 1;
	 
	} foreach ((MB_Layers select MB_CurLayer) select 0);
	systemChat ("MB_FileIO" callExtension "close");
	systemchat format["%1 objects exported to %2.",_count,_path];
};

MB_fnc_exportSQM = {
	_filename = [_this,0,"noFilename"] call bis_fnc_param;
	if(_filename == "") exitWith {systemChat "Error: Export needs a name!";};
	_path = ("MB_FileIO" callExtension format["open_w|export\%1.sqm",_filename]);
	systemChat format["Opening %1",_path];
	private["_number","_digits","_acc"];
	version=12;

	"MB_FileIO" callExtension "write|version=12";
	"MB_FileIO" callExtension "write|class Mission {";
	"MB_FileIO" callExtension "write|addOns[]= {};";
	"MB_FileIO" callExtension "write|addOnsAuto[]= {};";
	"MB_FileIO" callExtension "write|class Intel{};";
	"MB_FileIO" callExtension "write|class Vehicles {";
	"MB_FileIO" callExtension format["write|items=%1;",count(((MB_Layers select MB_CurLayer) select 0))];
	_count = 0;
	{
		_obj = _x;
		_dir = getdir _obj;

		_pitchBank = _obj call BIS_fnc_getPitchBank;
		
		_pitch = [_pitchBank select 0,3] call MB_fnc_roundNumbers;
		_bank = [_pitchBank select 0,3] call MB_fnc_roundNumbers;
		_type = (typeof _obj);
		_pos = [_obj] call MB_fnc_exactPosition;
		_height = str ((getposATL _obj) select 2);
		_pos pushBack _height;
		_dir = [getdir _obj,3] call MB_fnc_roundNumbers;
		"MB_FileIO" callExtension format["write|class Item%1 {",_forEachIndex];
		"MB_FileIO" callExtension format["write|position[]={%1,%3,%2};",_pos select 0, _pos select 1, _pos select 2];
		"MB_FileIO" callExtension format["write|azimut=%1;",_dir];
		"MB_FileIO" callExtension format["write|offsetY=%1;",_pos select 2];
		"MB_FileIO" callExtension format["write|id=%1;",_forEachIndex];
		"MB_FileIO" callExtension "write|side=""EMPTY"";";
		"MB_FileIO" callExtension format["write|vehicle=""%1"";",typeof _obj];
		"MB_FileIO" callExtension "write|skill=0.6;";
		if(_pitch!=0 || _bank!=0) then {
			"MB_FileIO" callExtension format["write|init=""[this,%1,%2] call BIS_fnc_setPitchBank;"";",_pitch,_bank];
		};
		"MB_FileIO" callExtension "write|};";
		_count = _count + 1;
	 
	} foreach ((MB_Layers select MB_CurLayer) select 0);
	"MB_FileIO" callExtension "write|};";
	"MB_FileIO" callExtension "write|};";

"MB_FileIO" callExtension "write|class Intro {";
	"MB_FileIO" callExtension "write|addOns[]={};";
	"MB_FileIO" callExtension "write|addOnsAuto[]={};";
	"MB_FileIO" callExtension "write|randomSeed=2744005;";
	"MB_FileIO" callExtension "write|class Intel{};";
"MB_FileIO" callExtension "write|};";
"MB_FileIO" callExtension "write|class OutroWin";
"MB_FileIO" callExtension "write|{";
	"MB_FileIO" callExtension "write|addOns[]={};";
	"MB_FileIO" callExtension "write|addOnsAuto[]={};";
	"MB_FileIO" callExtension "write|randomSeed=2744005;";
	"MB_FileIO" callExtension "write|class Intel{};";
"MB_FileIO" callExtension "write|};";
"MB_FileIO" callExtension "write|class OutroLoose";
"MB_FileIO" callExtension "write|{";
	"MB_FileIO" callExtension "write|addOns[]={};";
	"MB_FileIO" callExtension "write|addOnsAuto[]={};";
	"MB_FileIO" callExtension "write|randomSeed=2744005;";
	"MB_FileIO" callExtension "write|class Intel{};";
"MB_FileIO" callExtension "write|};";
	
	systemChat ("MB_FileIO" callExtension "close");
	systemchat format["%1 objects exported to %2.",_count,_path];
};
MB_fnc_import = {

};
MB_fnc_loadProject = {
	private["_filename"];
	_filename = [_this,0,"Unknown_Project"] call bis_fnc_param;
	if(_filename == "") exitWith {systemChat "Error: Projects needs a name!";};
	[] call MB_fnc_DeleteAllObjects;
	MB_ProjectName = "";
	[_filename] call MB_fnc_importProject;
};
MB_fnc_saveProject = {
	private["_filename"];
	_filename = [_this,0,"Unknown_Project"] call bis_fnc_param;
	if(_filename == "") exitWith {systemChat "Error: Projects needs a name!";};
	MB_ProjectName = _filename;
	[2,false] call MB_fnc_togglePopup;
	_path = ("MB_FileIO" callExtension format["open_w|projects\%1.mbp",_filename]);
	systemChat format["Opening %1",_path];
	{
		_obj = _x;
		_pos = getPosATL _obj;
		_dir = getdir _obj;
		_type =(typeof _obj);

		_pitchBank = _obj call BIS_fnc_getPitchBank;
		
		_pitch = [_pitchBank select 0] call MB_fnc_roundNumbers;
		_bank = [_pitchBank select 1] call MB_fnc_roundNumbers;
		_scale = 1;
		_xPos  = [_pos select 0] call MB_fnc_roundNumbers;
		_yPos  = [_pos select 1] call MB_fnc_roundNumbers;
		_zPos  = [_pos select 2] call MB_fnc_roundNumbers;
		_dir = [_dir] call MB_fnc_roundNumbers;
		_layer = 0;
		_string = format["write|%1;%2;%3;%4;%5;%6;%7;%8;%9",_layer,_type,_xPos,_yPos,_zPos,_dir,_pitch,_bank,_scale];
		systemChat ("MB_FileIO" callExtension _string);
	} foreach ((MB_Layers select MB_CurLayer) select 0);
	systemChat ("MB_FileIO" callExtension "close");
	systemchat format["Project saved!"];
};
MB_fnc_importProject = {
	private["_filename"];
	_filename = [_this,0,"Unknown_Project"] call bis_fnc_param;
	if(_filename == "") exitWith {systemChat "Error: Can't load a project without name!";};
	_projectFolder = ("MB_FileIO" callExtension "listfiles|projects");
	_projects = [_projectFolder,"|"] call BIS_fnc_splitString;
	if((_projects find format["%1.mbp",_filename])==-1) exitwith {systemChat "Error: Project not found!"};
	MB_ProjectName = _filename;
	[2,false] call MB_fnc_togglePopup;
	_path = ("MB_FileIO" callExtension format["open_r|projects\%1.mbp",_filename]);
	systemChat format["Opening %1",_path];
	
	_line = "MB_FileIO" callExtension "readline";
	while{_line != "EOF"} do {
		_object = [_line,";"] call BIS_fnc_splitString;
		[
			_object select 1,	//Object type
			[parseNumber (_object select 2),parseNumber (_object select 3),parseNumber (_object select 4)], //Position
			parseNumber (_object select 0),	//Layer
			parseNumber (_object select 5),	//Dir
			parseNumber (_object select 6),	//Pitch
			parseNumber (_object select 7),	//Bank
			parseNumber (_object select 8) //Scale
		] call MB_fnc_CreateObject;
		_line = "MB_FileIO" callExtension "readline";
	};
	systemChat ("MB_FileIO" callExtension "close");
};
MB_fnc_roundNumbers = {
private["_number","_digits","_acc"];
	_number = [_this,0,0] call bis_fnc_param;
	_digits = [_this,1,5] call bis_fnc_param;
	//Accuracy is 5 digits
	_acc = 10^_digits;
	_number = round((_number)*_acc)/_acc;
	_number;
};

//Thanks to Mondkalb for this
MB_fnc_exactPosition = {
	private["_output","_object","_offset","_xcord","_xcordAC","_ycord","_ycordAC","_tempArray"];
	_object = [_this,0] call bis_fnc_param;
	_offset = [_this,1,[0,0]] call bis_fnc_param;
	_xcord = floor ((getPos _object) select 0);
	_xcordAC = (((getPos _object) select 0) - (floor ((getPos _object) select 0)));
	_ycord = floor ((getPos _object) select 1);
	_ycordAC = (((getPos _object) select 1) - (floor ((getPos _object) select 1)));


	_tempArray = toArray str _xcordAC;
	if ((_tempArray select 0) == 48 and (_tempArray select 1) == 46) then
	{
		_tempArray set [0, 999];
		_tempArray set [1, 999];
		_tempArray = _tempArray - [999];
		_xcordAC = toString _tempArray;
	};
	
	_tempArray = toArray str _ycordAC;
	if ((_tempArray select 0) == 48 and (_tempArray select 1) == 46) then
	{
		_tempArray set [0, 999];
		_tempArray set [1, 999];
		_tempArray = _tempArray - [999];
		_ycordAC = toString _tempArray;
	};
	
	_output = [format["%1.%2",(_xcord+(_offset select 0)),_xcordAC],format["%1.%2",(_ycord+(_offset select 1)),_ycordAC]];
	_output;
};