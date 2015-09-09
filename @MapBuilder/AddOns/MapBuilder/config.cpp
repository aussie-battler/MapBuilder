#define DEBUG

class CfgPatches
{
	class MapBuilder
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.50;
		requiredAddons[] = {"A3_Misc_F_Helpers"};
		version = "0.9";
		projectName = "MapBuilder";
		author = "NeoArmageddon";
	};
};

class CfgMods
{
	class Mod_Base;
	class MapBuilder: Mod_Base
	{
		picture = "MB\MapBuilder\data\mb.paa";
		logo = "MB\MapBuilder\data\mb.paa";
		logoOver = "MB\MapBuilder\data\mb_reversed.paa";
		action = "http://map-builder.info";
		dlcColor[] = {0.31,0.78,0.78,1};
		overview = "Map Builder 0.9";
		hideName = 0;
		hidePicture = 0;
		name = "Map Builder";
		//dir = "MapBuilder";
		//appId = 275700;
	};
};

class CfgFactionClasses
{
	class MapBuilder_Faction
	{
		displayname = "Map Builder";
		priority = 8;
		side = 7;
		addon = "MapBuilder";

		class subCategories
		{
			class MapBuilder
			{
				displayname = "Map Builder";
				moduleClass = "MapBuilder_ModuleEmpty";
			};
		};
	};
};
class CfgVehicles
{
	class Logic;
	class Module_F: Logic
	{
		class ArgumentsBaseUnits
		{
			class Units;
		};
		class ModuleDescription
		{
			class AnyPlayer;
			class AnyBrain;
			class EmptyDetector;
		};
	};
	class MapBuilder_ModuleBase: Module_F
	{
		mapSize = 1;
		author = "NeoArmageddon";
		vehicleClass = "Modules";
		category = "MapBuilder_Faction";
		subCategory = "MapBuilder";		
		side = 7;
		
		scope = 1;
		scopeCurator = 1;
		
		icon =  "\MB\MapBuilder\data\mapbuilder_mapicon.paa";
		
		displayName = "MB Modules";
		function = "";
		functionPriority = 10;
		isGlobal = 1;
		isTriggerActivated = 0;
		isDisposable = 0;

		class Arguments{};
		class ModuleDescription: ModuleDescription
		{
			description = "MB Module Base";
		};
	};
	class MapBuilder_Module: MapBuilder_ModuleBase
	{
		displayName = "Map Builder";
		author = "NeoArmageddon";
		function = "mb_fnc_setup";
		scopeCurator = 1;
		scope = 2;
		class Arguments: ArgumentsBaseUnits
		{
			// Arguments shared by specific module type (have to be mentioned in order to be placed on top)
			//class Units: Units {};
			// Module specific arguments
		};
		class ModuleDescription: ModuleDescription
		{
			description = "Map Builder Main Module. Placing this on the map grants all players access to Map Builder via action menu."; // Short description, will be formatted as structured text
			//sync[] = {}; // Array of synced entities (can contain base classes)
		};
	};
	class MapBuilder_ModuleEmpty: MapBuilder_ModuleBase
	{
		mapSize = 0;
		category = "Curator";
		subCategory = "";
		icon = "";

		displayName = "";
		function = "";
		scopeCurator = 1;
	};
	class Helper_Base_F;
	class mb_bounding_box: Helper_Base_F
	{
		scope        = 1;
		displayName  = "Bounding Box";
		model        = "mb\mapbuilder\data\mb_bounding_box";
		author = "NeoArmageddon";
		class AnimationSources
		{
			class left
			{
				source     = "user";
				initPhase  = 0;
				animPeriod = 1; // Hier den wert 0 ausprobieren, schauen ob es dann auch noch funktioniert.
			};
			/*
			class right : left {};
			class front : left {};
			class rear : left {};
			class top : left {};
			class bottom : left {};
			*/
		};
	};
};

#include "\MB\MapBuilder\ui\ui.hpp"

#ifndef DEBUG
class CfgFunctions
{
	#include "\MB\MapBuilder\functions\functions.hpp"
};
#endif