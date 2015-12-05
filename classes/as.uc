//  ============================================================================================
//   * File Name:    tribesmod
//   * Created By:   Cobra
//   * Time Stamp:     12-02-15 14:17:01
//   * UDK Path:   C:\Program Files\VUGames\Tribes Vengeance\Program\Bin\TVed.exe
//   * Unreal X-Editor v3.1.5.0
//   * © Copyright 2012 - 2015. All Rights Reserved.
//  ============================================================================================

//#StartBlock ===========================================INFO=================================================

/* @info ... class
*
*   Mutator for the Tribes Vengeance community, credits to dEhaV for having released the promod's source code on which this mutator is based.
*
*       Tribesmod changes or adds the following features to the game server when enabled;
*       
*       - Removable vehicles (The tank and rover have been slightly modified).
*       - Overwrites and changes the tribes MultiPlayerCharacter class.
*       - Grants the ability to change the spawn class as well as changing the spawn protection duration.
*       - Overwrites and changes the flag throwing properties.
*       - Changes some BaseDevice's shield classes (catapult and inventory stations).
*       - removes the deployable BaseDevice stations (turrets and mines).
*       - removes the base turrets
*       - Adds new game stats to the game
*       - Adds mutate commands. See function Mutate()
*       - Increased the grapple roundsPerSecond slightly to reduce the chance for the "grapple bug" to occur.
*       - Fixes pack reload animation (though it is still buggy and will not work when the reload time is modified ingame (needs some more testing)
*       - Fixed Repair pack emmiter's max range (was bugged in promod)
*       - Fixes shield pack texture when getting hit and carrying a shield pack (will now display a shader around the player's model when activating the pack, or when getting hit)
*       - Changed the flag's texture to hologram shaders.
*
*
*   New Console commands (only executable when logged into admins, not case sensitive):
*
*
*       ConsoleCommand("mutate help")               Displays a list of all available commands.
*       ConsoleCommand("mutate test")               helloWorld text will appear in the chat.
*       ConsoleCommand("mutate time [value]")       Sets the gametime to [value].
*       ConsoleCommand("mutate tournament")         Toggles between tournament mode on or off. Takes effect at next map.
*       ConsoleCommand("mutate troc")               Toggles between the default gameplay and troc-mode (enhanced energyPack boost).
*
*
*
*   Info;   Native function SaveConfig();
*
*       Saves all config variables to the class's config file (see class modifiers). If the variables are already saved, this function will import their values into the classes.
*
*
*
*   Info:  Relation between distance and ingame Units
*
*       100 Units = 1,25 (config value)
* 
*/

//#EndBlock

class as extends Gameplay.Mutator config(tribesmodSettings); 
// Some unresolved issue with UCC forces the use of the name "as.uc" instead of another class name.


//#StartBlock ========================================VARIABLES===============================================
/* @effect ... variables
*
*   list of variables used in the mutator's main class; tribesmod. Ordered by function
*
*/

const MOD_VERSION = "tribesmod";
//replication class reference
var public class clientReplicationClass;
var private bool spawnRepClass;
//Change this in defaultproperties to enable the tests
var public bool enableTests;
//function modifyVehicles()
var config bool EnablePod;
var config bool EnableRover;
var config bool EnableRoverGun;     //toggles between retail rover with anti-AA gun and rover without gun.
var config bool EnableAssaultShip;
var config bool EnableTank;
//function modifyPlayerStart()
var config class<Gameplay.CombatRole> SpawnCombatRole;
var config int SpawnInvincibility;
//function actorReplace()
var config bool useDefaultBurner;
var config float PlasmaPIVF;
var config int PlasmaVelocity;
var config int PlasmaEnergyUsage;
//function removeBaseTurrets()
var config bool RemoveBaseTurret;
//function disableMineTurret()
var config bool DisableDeployableTurrets;
var config bool DisableMines;
//function modifyStats()
var config bool BonusStatsOn;
//function PostBeginPlay()
var config bool RunInTournament;
//function PostBeginPlay()
var config bool MTBalance;
var config int MTTeamPlayerMin;
var config int BRTeamPlayerMin;
var config array<class<BaseDevice> > MTInclusionList;
var config array<class<BaseDevice> > BRBaseDeviceInclusionList;
var config bool BaseRape;
//function Timer()
var config bool TeamKillBanUser;
var config int MaxTeamKills;
var config int TimerInterval;
//function Mutate()
var private bool allowMutate;          // TEST: cannot be changed with console commands
var private bool trocIsOn;
var private bool bTournamentMode;
//function actorReplace()
var public float EnergyBoost;
var public float EnergyDuration;
//function MutateSpawnCombatRoleClass()
var config float HOknockbackscale;
var config int HOHealth;
//function actorReplace()
var config bool TankUsesMortarProjectile;
var config int TankDefaultProjectileVelocity;
var config int TankMortarProjectileVelocity;
var config bool EnableDegrapple;

//#EndBlock 

//#StartBlock ========================================FUNCTIONS===============================================

function bool CTF() {
    /* @effect ... function
    *
    *   Called by modifyPlayerStart(). Will return true if the current map has a capture point (flag stand). 
    *
    *   Time Stamp: 14-02-15 15:21:03
    */

    local GameClasses.CaptureStand FlagStand;
    foreach AllActors(class'GameClasses.CaptureStand', FlagStand)
        if (FlagStand != None)
            return true;
}
        
function bool tournamentOn() {
    /* @effect ... function
    *
    *   Called by PostBeginPlay(). Will return true if the current map is running in tournament mode.
    *
    *   Time Stamp: 14-02-15 15:21:29
    */
     
    if (!RunInTournament)
        return MultiplayerGameInfo(Level.Game).bTournamentMode;
    else
        return false;
}
    
simulated function PreBeginPlay() {
    /* @effect ... event
    *   
    *   Allows the mutator to modify, remove, or replace any actor when spawned through this function.
    *   (exeptions include actors flagged as "bGameRelevant" or when PreBeginPlay() is overridden without calling super.PreBeginPlay())
    *   Most of these functions originate from dEhaV's original mod, "promod".
    *
    *   Time Stamp: 14-02-15 15:21:51
    */
    
    super.PreBeginPlay();
    
    log("************************");
    log("***    TribesMod     ***");
    log("************************");
    
    destroyClientReplicationClass();
    
    modifyCharacters();
    modifyPlayerStart();
    modifyFlagThrower();
    modifyVehicles();
    modifyBaseDeviceShieldClass();
    removeBaseTurrets();
    disableMineTurret();
    modifyStats();
}

simulated function destroyClientReplicationClass() {
    /*
    * @effect ...
    *
    *   function checks the loaded actors for class'ClientReplication' and destroys it if it was still alive.
    *   (Class ClientReplication extends Engine.LevelInfo and should in theory get destroyed whenever the map ends. This is just an additional check.
    *
    *   This function can be called ingame by any admin with the following mutate command: "admin mutate destroyrepclass".
    */
    
    local tribesmod.clientReplication cRep;
    
    if (cRep == None) {
        log("No remaining clientReplication class was found");
    } else {
        foreach Allactors (class'tribesmod.clientReplication', cRep)
            cRep.Destroy();

        log("class'clientReplication' has been destroyed");
    }
}

function modifyCharacters() {
    /* @effect ... function
    *   
    *   Overwrites GameInfo.DefaultPlayerClassName and GameInfo.Default.DefaultPlayerClassName with tmodMultiplayerCharacter.
    *
    *   Time Stamp: 14-02-15 15:22:03
    */
    
    local Gameplay.GameInfo Instance;
    
    foreach AllActors(class'Gameplay.Gameinfo', Instance) {
        if (Instance != None) {
            Instance.Default.DefaultPlayerClassName = MOD_VERSION $ ".tmodMultiplayerCharacter";
            Instance.DefaultPlayerClassName = MOD_VERSION $ ".tmodMultiplayerCharacter";
        }
    }   
}

function modifyPlayerStart() {
    /* @effect ... function
    *
    *   Allows server administratos to change which default armor class players will spawn in (defined in the configuration.ini file)              
    *
    *   Time Stamp: 14-02-15 15:24:49
    */
    
    local Gameplay.MultiPlayerStart Start;
    
    foreach AllActors(class'Gameplay.MultiPlayerStart', Start) {
        if (Start != None && Start.combatRole != class'EquipmentClasses.CombatRoleLight' && CTF()) {
            Start.combatRole = SpawnCombatRole;
        } 
        if (Start != None) {
            Start.invincibleDelay = SpawnInvincibility;
        }    
    }
}

simulated function modifyFlagThrower() {
    /* @effect ... function
    *
    *   Allows the administrator to modify flag throwing properties. The default flag classes will be overwritten with the tribesmod clases.
    *
    *   Time Stamp: 14-02-15 15:24:24
    */ 
    
    local GameClasses.CaptureFlagImperial ImpFlag;
    local GameClasses.CaptureFlagBeagle BEFlag;
    local GameClasses.CaptureFlagPhoenix PnxFlag;
    
    foreach AllActors(class'GameClasses.CaptureFlagImperial', ImpFlag)
        if(ImpFlag != None) {    
            ImpFlag.carriedObjectClass = Class'tmodFlagThrowerImperial';
        }
       
    foreach AllActors(class'GameClasses.CaptureFlagBeagle', BEFlag)
        if(BEFlag != None) {
            BEFlag.carriedObjectClass = Class'tmodFlagThrowerBeagle';
        }
        
    foreach AllActors(class'GameClasses.CaptureFlagPhoenix', PnxFlag)
        if(PnxFlag != None) {      
            PnxFlag.carriedObjectClass = Class'tmodFlagThrowerPhoenix';  
        }
}
    
function modifyVehicles() {
    /* @effect ... function
    *   
    *   Allows the administrator to decide which vehicle to spawn
    *
    *   Time Stamp: 14-02-15 15:23:53
    */
    
    local Gameplay.VehicleSpawnPoint vehiclePad;
    
    foreach AllActors(class'Gameplay.VehicleSpawnPoint', vehiclePad) {
    
        if(EnablePod) {
            if (vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehiclePod')
            vehiclePad.vehicleClass = class'tribesmod.tmodPod';
        } else if(!EnablePod) {
                if (vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehiclePod')
                    vehiclePad.setSwitchedOn(false);
        }
                
        if(EnableRover) {
            if (vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleBuggy') {
                if(EnableRoverGun) {
                    vehiclePad.vehicleClass = class'tribesmod.tmodDefaultBuggy';
                    } else {
                    vehiclePad.vehicleClass = class'tribesmod.tmodBuggy';
                }
            }
        } else if(!EnableRover) {
                if (vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleBuggy')
                    vehiclePad.setSwitchedOn(false);
        } 
                
        if(EnableAssaultShip) {
              if(vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleAssaultShip')
            vehiclePad.setSwitchedOn(true);
        } else if(!EnableAssaultShip) {
                if(vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleAssaultShip')
                    vehiclePad.setSwitchedOn(false);
        }
                
        if(EnableTank) {
              if(vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleTank')
              vehiclePad.vehicleClass = class'tribesmod.tmodTank';
        } else if(!EnableTank) {

            if (vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleTank')
                vehiclePad.setSwitchedOn(false);

        }
    }
}
        
function modifyBaseDeviceShieldClass() {
    /* @effect ... function
    *   
    *   overwrites or adds a new shield class to the base devices (weak, medium or strong)
    *
    *   Time Stamp: 14-02-15 15:25:42
    */ 
    
    local BaseObjectClasses.BaseCatapult Catapult;
    local BaseObjectClasses.BaseInventoryStation InventoryStation;
    
    foreach AllActors(class'BaseObjectClasses.BaseCatapult', Catapult)
        if(Catapult != None)
            Catapult.personalShieldClass = Class'BaseObjectClasses.ScreenStrong';
            //Catapult.personalShieldClass = Class'BaseObjectClasses.ScreenDefault';
            //Catapult.personalShieldClass = Class'BaseObjectClasses.ScreenMedium';
            //Catapult.personalShieldClass = Class'BaseObjectClasses.ScreenWeak';
                        
    foreach AllActors(class'BaseObjectClasses.BaseInventoryStation', InventoryStation)
        if(InventoryStation != None)
            InventoryStation.personalShieldClass = Class'BaseObjectClasses.ScreenMedium';
}

function removeBaseTurrets() {
    /* @effect ... function
    *   
    *   Removes base turrets (not the deployable ones)
    *   | if (RemoveBaseTurret) 
    *
    *   Time Stamp: 06-11-15 17:36:00
    */
    
    local BaseObjectClasses.BaseTurret BaseTurrets;
    local BaseObjectClasses.StaticMeshRemovable TurretBase;
    
    if(RemoveBaseTurret) {
    
        foreach AllActors(class'BaseObjectClasses.BaseTurret', BaseTurrets)
            if(BaseTurrets != None)
                BaseTurrets.destroy();
            
        foreach AllActors(class'BaseObjectClasses.StaticMeshRemovable', TurretBase)
            if(BaseTurrets != None)
                TurretBase.destroy();
    }
}
        
function disableMineTurret() {
    /* @effect ... function
    *   
    *   Disables the deployable Turret and Mine stations
    *   | if (DisableDeployableTurrets && DisableMines)
    *
    *   Time Stamp: 06-11-15 17:37:19
    */
    
    local BaseObjectClasses.BaseDeployableSpawnTurret DeployableTurretStation;
    local BaseObjectClasses.BaseDeployableSpawnShockMine DeployableMineStation;
    
    if(DisableDeployableTurrets) {

        foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnTurret', DeployableTurretStation)
            if(DeployableTurretStation != None)
                DeployableTurretStation.Destroy();
    }
    
    if (DisableMines) {
        foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnShockMine', DeployableMineStation)
            if(DeployableMineStation != None)
                DeployableMineStation.Destroy();
    }
}

function modifyStats() {
    /* @effect ... function
    *   
    *   Modifies and adds new game stats to the game.
    *
    *   Time Stamp: 22-02-15 15:26:58
    */

    local ModeInfo M;
    local int statCount;
    local int i;
    
    M = ModeInfo(Level.Game);
  
    if(M != None && BonusStatsOn) {
        //search for the already existing weapon stat and overwrite it
        for(i = 0; i < M.extendedProjectileDamageStats.Length; ++i) {
            //search by damage type
            if(M.extendedProjectileDamageStats[i].damageTypeClass == Class'EquipmentClasses.ProjectileDamageTypeSpinfusor') {
                M.extendedProjectileDamageStats[i].extendedStatClass = Class'statMA';
            }
        }   
        //Same as above: Search in the array of default stats, look for the correct weaponDamageType class, and modify the found stat.
        for(i = 0; i < M.projectileDamageStats.Length; ++i) {
            if(M.projectileDamageStats[i].damageTypeClass == Class'EquipmentClasses.ProjectileDamageTypeSniperRifle') {
                M.projectileDamageStats[i].damageTypeClass = Class'tribesmod.tmodSniperProjectileDamageType';
                M.projectileDamageStats[i].headShotStatClass = Class'statHS';
            }   
        }
    
        statCount = M.extendedProjectileDamageStats.Length;
        M.extendedProjectileDamageStats.Insert(statCount, 8);       // We have 8 new stats
    
        //E-Blade       1
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'tribesmod.tmodBladeProjectileDamageType';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statEBMA';
        ++statCount;
    
        // GLMA         2
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeGrenadeLauncher';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statGLMA';
        ++statCount;
        
        // MMA          3
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeMortar';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statMMA';
        ++statCount;
    
        //PMA           4
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeBurner';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statPMA';
        ++statCount;
    
        //ED            5
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeSpinfusor';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statEatDisc';
        ++statCount;
    
        //Rocketeer     6
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeRocketPod';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statRocketeer';
        ++statCount;
    
        //OMG           7
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeSpinfusor';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statOMG';
        ++statCount;
        
        //SPLASH        8
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeSpinfusor';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statSplash';
        ++statCount;
    }
}

simulated function PostBeginPlay() {
    /* @effect ... event
    * 
    *   Used to implement logic that should happen after engine-side initialisation of the actor. In our case, used for anti-baserape, anti-team kill and mines/turret control
    *   Most of these functions originate from dEhaV's original mod, "promod".
    *   This function will aslo spawn the ClientReplication class on all clients and server (this happens at map startup for the server, and right after a client has loaded the map).   
    *
    *   Time Stamp: 14-02-15 15:27:24
    */
    
    super.PostBeginPlay();
    
    Spawn(class'tribesmod.clientReplication');
    SetStats();
    SaveConfigVariables();

    if(!tournamentOn() && CTF())     // Functions will never be called if the gamemode is not CTF, but will, if RunInTournament=true
    
    /*TEST WHEN OFF*/
    {          
    UpdateMTDevices();
    UpdateBRDevices();
    SetTimer(TimerInterval, true);
    }
    
    ServerSaveConfig();
}

function setStats() {
   
    //maxDistance == vt + (1/2)at^2

    local float v;
    local float dT;
    local float a;
    
    v = Class'spinfusorProperties'.default.ProjectileVelocity;
    a = Class'spinfusorProperties'.default.AccelerationMagtitude;
    dT = Class'spinfusorProperties'.default.LifeSpan;
    
    class'tribesmod.statSplash'.default.minDistance = ((v*dT) + ((0.5*a) * (dT * dT)));
}

function SaveConfigVariables() {
    
    //Damage Needs to be set before the projectile class is initialised.
    Class'tmodProjectileSniperRifle'.default.damageAmt = Class'tmodProjectileSniperRifle'.default.sniperDamage;
    
}

function ServerSaveConfig() {
    /*
    *   Function is not simulated. This means the functions will be called on both client and server, but only the server will execute the code.
    *   In this case, only the server's TribesmodSettings.ini file needs to save the variables, so we do not simulate the function.
    */
 
    SaveConfig();   
}

function Timer() {
    /* @effect ... function
    *   
    *   Server-side timer (Server and clients are never in sync, so timers should never be simulated). Also takes care of the anti-teamkill system
    *
    *   Time Stamp: 15-02-15 15:28:06
    */
    
    local Controller C;
    local int s;
    local PlayerReplicationInfo P;
  
    if(MTBalance && !EnableMT())
    {
        MTBalance = false;
        UpdateMTDevices();
        Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 100);
    } else if(!MTBalance && EnableMT())
        {
            MTBalance = true;
            UpdateMTDevices();
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 101);
        }
    
    if(BaseRape && !EnableBR())
    {
        BaseRape = false;
        UpdateBRDevices();
        Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 103);
    } else if(!BaseRape && EnableBR())
        {
            BaseRape = true;
            UpdateBRDevices();
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 104);
        }
    
    //Anti-TK
    for (C = Level.ControllerList; C != none; C = C.nextController) {
        if(PlayerController(C) == none && !MultiplayerGameInfo(Level.Game).bTournamentMode)
            continue;

        P = C.PlayerReplicationInfo;

        if(P.playerName == "" || tribesReplicationInfo(P).team == None)
            continue;

        S = P.Score + MaxTeamKills;
            
        if(S==1 || S==2) {
            PlayerController(C).ReceiveLocalizedMessage(class'tmodGameMessage', 105, P);
                return;
        }
        if(S<=0) {
            if(TeamKillBanUser) {
                Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 106, P);
                Level.Game.AccessControl.BanPlayer(PlayerController(C));
                
                } else {
                    Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 107, P);
                    Level.Game.AccessControl.KickPlayer(PlayerController(C));
            }
        }
    }
}
   
function bool EnableMT() {
    /* @effect ... function
    *   
    *   Enables mine and turret stations above a certain player amount
    *
    *   Time Stamp: 14-02-15 15:28:19
    */ 
    
    local TeamInfo Team;
     
    foreach AllActors(class'TeamInfo', Team) {
        if(Team != None)
            if(Team.numPlayers() < MTTeamPlayerMin)
                return false;
                
        return true;
    }
}
   
function bool EnableBR() {
    /* @effect ... functionc
    *   
    *   Enables base-rape  above a certain player amount
    *
    *   Time Stamp: 14-02-15 15:29:01
    */
    
    local TeamInfo Team;

    ForEach AllActors(Class'TeamInfo', Team) {
        if(Team != None)
            if(Team.numPlayers() < BRTeamPlayerMin)
                return false;
        return true;
    }
}
     
function UpdateMTDevices() {
    /* @effect ... function
    *   
    *   Updates Base station availability (timer based)
    *
    *   Time Stamp: 14-02-15 15:29:17
    */
    
    local BaseDevice Device;
    
    foreach AllActors(Class'BaseDevice', Device) {
        if(Device != None)
            if(ShouldModifyMTDevice(Device))
                Device.setSwitchedOn(MTBalance);
    }
}
        
function UpdateBRDevices() {
    /* @effect ... function
    *   
    *   Updates Base-rape status (timer based)
    *
    *   Time Stamp: 14-02-15 15:29:30
    */
    
    local BaseDevice Device;

    ForEach AllActors(Class'BaseDevice', Device) {
        if(Device != None)
            if(ShouldModifyBRDevice(Device))
                Device.bCanBeDamaged = BaseRape;
    }
}
        
function bool ShouldModifyMTDevice(BaseDevice device) {
    /* @effect ... function
    *   
    *   Defines list of affected BaseDevices (in array MTInclusionList)
    *
    *   Time Stamp: 14-02-15 15:29:46
    */
    
    local int i;

    for(i = 0; i < MTInclusionList.Length; i++) {
        if(device.IsA(MTInclusionList[i].Name))
            return true;
        return false;
    }
}

function bool ShouldModifyBRDevice(BaseDevice device) {
    /* @effect ... function
    *   
    *   Defines list of affected BaseDevices (in array BRBaseDeviceInclusionList)
    *
    *   Time Stamp: 14-02-15 15:29:59
    */
    
    local int i;

    for(i = 0; i < BRBaseDeviceInclusionList.Length; i++) {
        if(device.IsA(BRBaseDeviceInclusionList[i].Name))
            return true;
        return false;
    }
}

event Actor ReplaceActor(Actor Other) {
    /* @effect ... event
    *   
    *   find actors and replace their classes (This function is called whenever an actor is spawned in the game world).
    *   Note: Actor ReplaceActor() was a simulated event, this caused timer-based settings (like weapon firerate) to be occasionnaly out of sync with the server.
    *
    *   Tested the simulated property of the ReplaceActor event:
    *   Got unexpected behaviour from actors replaced in this event (more specifically the spinfusor projectile that seemed to have a different inherited velocity factor)
    *   Went back to a public event (UCC considers events and functions to be the same thing)
    *
    *   Time Stamp: 27-02-15 17:1l7:52
    */
    
    /*
    if(Other.IsA('anticsCharacterController')) {
        //catch antics' modified player controller class
        log("Found anticsCharacterController class");
        return Super.ReplaceActor(Other);
    }
    */
    
    if(Other.IsA('WeaponSpinfusor')) {
           
        //spawn(class'tribesmod.spinfusorProperties');
    
        WeaponSpinfusor(Other).projectileClass = class'tmodProjectileSpinfusor';
        WeaponSpinfusor(Other).projectileInheritedVelFactor = class'spinfusorProperties'.default.InheritedVelFactor;
        WeaponSpinfusor(Other).projectileVelocity = class'spinfusorProperties'.default.ProjectileVelocity;
        WeaponSpinfusor(Other).ammoUsage = class'spinfusorProperties'.default.AmmoUsage;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponSniperRifle')) {
        WeaponSniperRifle(Other).projectileClass = Class'tmodProjectileSniperRifle';
        return Super.ReplaceActor(Other);
    }
    
    /*if(Other.IsA('WeaponSniperRifle')) {
        //LASER POINTER
        Other.Destroy();
        log("Destroyed orig sniper, replaced with beamer");
        return ReplaceWith(Other, MOD_VERSION $ ".tmodWeaponPointer");
    }*/
    
    if(Other.IsA('Grappler')) {
        if(EnableDegrapple)
            Grappler(Other).projectileClass = Class'tmodDegrappleProjectile';
        else
            Grappler(Other).projectileClass = Class'tmodGrapplerProjectile';
            
            // Increased grapple RPS by 10% to reduce the chance for the grapple bug to occur.
            //Grappler(Other).roundsPerSecond = 1.0;
            Grappler(Other).roundsPerSecond += Grappler(Other).roundsPerSecond / 10;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponGrenadeLauncher')) {
        WeaponGrenadeLauncher(Other).projectileClass = Class'tmodProjectileGrenadeLauncher';   
        WeaponGrenadeLauncher(Other).projectileInheritedVelFactor = class'tmodProjectileGrenadeLauncher'.default.GrenadeLauncherPIVF;
        WeaponGrenadeLauncher(Other).projectileVelocity = class'tmodProjectileGrenadeLauncher'.default.GrenadeLauncherProjectileVelocity;
        WeaponGrenadeLauncher(Other).ammoUsage = class'tmodProjectileGrenadeLauncher'.default.GrenadeLauncherAmmoUsage;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponMortar')) {
        WeaponMortar(Other).projectileClass = Class'tmodProjectileMortar';
        WeaponMortar(Other).projectileInheritedVelFactor = class'tmodProjectileMortar'.default.MortarPIVF;
        WeaponMortar(Other).projectileVelocity = class'tmodProjectileMortar'.default.MortarProjectileVelocity;
        WeaponMortar(Other).ammoUsage = class'tmodProjectileMortar'.default.MortarAmmoUsage;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponChaingun')) {
        WeaponChaingun(Other).projectileClass = Class'tmodProjectileChaingun';
        WeaponChaingun(Other).projectileVelocity=class'tmodProjectileChaingun'.default.projectileVelocity;
        WeaponChaingun(Other).projectileInheritedVelFactor=class'tmodProjectileChaingun'.default.projectileInheritedVelFactor;
        WeaponChaingun(Other).roundsPerSecond=class'tmodProjectileChaingun'.default.roundsPerSecond;
        WeaponChaingun(Other).spinPeriod=class'tmodProjectileChaingun'.default.spinPeriod;
        WeaponChaingun(Other).speedCooldownFactor=class'tmodProjectileChaingun'.default.speedCooldownFactor;
        WeaponChaingun(Other).heatPeriod=class'tmodProjectileChaingun'.default.heatPeriod;
        WeaponChaingun(Other).maxSpread=class'tmodProjectileChaingun'.default.maxSpread;
        WeaponChaingun(Other).minSpread=class'tmodProjectileChaingun'.default.minSpread;      
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponRocketPod')) {
        WeaponRocketPod(Other).projectileClass = class'tmodProjectileRocketPod';
        //save weapon properties in projectile class to keep the main class clean
        WeaponRocketPod(Other).projectileVelocity = class'tmodProjectileRocketPod'.default.projectileVelocity;
        WeaponRocketPod(Other).projectileInheritedVelFactor = class'tmodProjectileRocketPod'.default.projectileInheritedVelFactor;
        WeaponRocketPod(Other).roundsPerSecond = class'tmodProjectileRocketPod'.default.roundsPerSecond;
        WeaponRocketPod(Other).launchDelay = class'tmodProjectileRocketPod'.default.launchDelay;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponBuckler')) {
        // from compmod07
        WeaponBuckler(Other).checkingDamage = 0;        //was 15
        WeaponBuckler(Other).checkingDmgVelMultiplier = 0;  //was 0.01
        WeaponBuckler(Other).checkingMultiplier = 0;    //was 300
        WeaponBuckler(Other).minCheckRate = 0;          //was 0.2
        WeaponBuckler(Other).minCheckVelocity = 0;      //was 800
    }
    
    if(Other.IsA('WeaponBlaster')) {
        WeaponBlaster(Other).projectileClass = class'tmodProjectileBlaster';
        WeaponBlaster(Other).spread = class'tmodProjectileBlaster'.default.BlasterSpread;
        WeaponBlaster(Other).numberOfBullets = class'tmodProjectileBlaster'.default.BlasterBulletAmount;
        WeaponBlaster(Other).roundsPerSecond = class'tmodProjectileBlaster'.default.BlasterRoundsPerSecond;
        WeaponBlaster(Other).energyUsage = class'tmodProjectileBlaster'.default.BlasterEnergyUsage;
        WeaponBlaster(Other).projectileVelocity = class'tmodProjectileBlaster'.default.BlasterVelocity;
        WeaponBlaster(Other).projectileInheritedVelFactor = class'tmodProjectileBlaster'.default.BlasterPIVF;
        return Super.ReplaceActor(Other);
    }
       
    if(Other.IsA('WeaponBurner')) {
        if(!class'tmodProjectilePlasma'.default.useDefaultBurner) {
            WeaponBurner(Other).projectileClass = class'tmodProjectilePlasma';
            WeaponBurner(Other).projectileInheritedVelFactor = class'tmodProjectilePlasma'.default.PlasmaPIVF; //was .4
            WeaponBurner(Other).projectileVelocity = class'tmodProjectilePlasma'.default.PlasmaVelocity; //was 4700
            WeaponBurner(Other).energyUsage = class'tmodProjectilePlasma'.default.PlasmaEnergyUsage;
            WeaponBurner(Other).localizedname = class'tmodProjectilePlasma'.default.localizedName;
        }
        return Super.ReplaceActor(Other);
    }
    
    /*if(Other.IsA('WeaponHandGrenade')) {
        //Does not work
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodWeaponHandGrenade");
    }*/
    
    if(Other.IsA('WeaponEnergyBlade')) {
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodWeaponEnergyBlade");
    }
    
    if(Other.IsA('SpeedPack')) {
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodPackSpeed");
    }
    
    if(Other.IsA('ShieldPack')) {
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodPackShield");
    }
    
    if(Other.IsA('RepairPack')) {
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodPackRepair");
    }
    
    if(Other.IsA('EnergyPack')) {    
        EnergyPack(Other).boostImpulsePerSecond = EnergyBoost;
        EnergyPack(Other).durationSeconds = EnergyDuration;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponVehicleTank')) {
        if(TankUsesMortarProjectile)
            {
                WeaponVehicleTank(Other).aimClass = Class'AimArcWeapons';
                WeaponVehicleTank(Other).projectileClass = Class'tribesmod.tmodTankRound';
                WeaponVehicleTank(Other).projectileVelocity = TankMortarProjectileVelocity;
                WeaponVehicleTank(Other).ammoUsage = 0; //was 1
            } else {
                WeaponVehicleTank(Other).aimClass = Class'AimProjectileWeapons';
                WeaponVehicleTank(Other).projectileVelocity = TankDefaultProjectileVelocity;
                WeaponVehicleTank(Other).ammoUsage = 0; //was 1
            }   
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('CatapultDeployable')) {
        CatapultDeployable(Other).basedeviceClass = Class'tmodDeployedCatapult';
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('InventoryStationDeployable')) {
        InventoryStationDeployable(Other).basedeviceClass = Class'tmodDeployedInventoryStation';
        return Super.ReplaceActor(Other);
    }
   
    if(Other.IsA('CloakPack')) {
    // anti gameplay hack
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodAntiCloak");
    }      
    
    return Super.ReplaceActor(Other);
}

function string MutateSpawnCombatRoleClass(Character c) {
    /* @effect ... function
    *   
    *   Function copied form promod.
    *
    *   Time Stamp: 20-02-15 15:31:21
    */
    
    local int i, j;

    //Heavies. Knockback of weapon explosions decreased to balance health increase with disc jumping.  Copied from Vanilla Plus. Thank you Odio
    c.team().combatRoleData[2].role.default.armorClass.default.knockbackScale = HOknockbackscale; //was 1.175
    c.team().combatRoleData[2].role.default.armorClass.default.health = HOHealth; //was 195

    c.team().combatRoleData[0].role.default.armorClass.default.AllowedWeapons = class<Armor>(DynamicLoadObject("tribesmod.tmodArmorLight", class'class')).default.AllowedWeapons;
    c.team().combatRoleData[1].role.default.armorClass.default.AllowedWeapons = class<Armor>(DynamicLoadObject("tribesmod.tmodArmorMedium", class'class')).default.AllowedWeapons;
    c.team().combatRoleData[2].role.default.armorClass.default.AllowedWeapons = class<Armor>(DynamicLoadObject("tribesmod.tmodArmorHeavy", class'class')).default.AllowedWeapons;

    for(i = 0; i < c.team().combatRoleData.length; i++)
    {
        for(j = 0; j < c.team().combatRoleData[i].role.default.armorClass.default.AllowedWeapons.length; j++)
        {
           if(c.team().combatRoleData[i].role.default.armorClass.default.AllowedWeapons[j].typeClass == Class'EquipmentClasses.WeaponBurner')
               c.team().combatRoleData[i].role.default.armorClass.default.AllowedWeapons[j].quantity = 25 + i *5;
        }    
    }
    return Super.MutateSpawnCombatRoleClass(c);
}

simulated function Mutate(string Command, PlayerController Sender) {
    /* @effect ... function
    *   
    *   Mutate function allows clients to execute functions defined in the mutator tribesmod. (such as enabling troc).
    *   Mutate function is required to be simulated for clients to call it.          
    *
    *    Time Stamp: 20-02-15 15:31:46
    */

    local string ParsedString;
    
    // TODO: Anonym adminlogin
    
    
    //  All defined commands require admin privileges to be executed
    if(allowMutate && Sender.AdminManager.bAdmin) {
    
        //  (admin) mutate troc
        if(Command ~= "troc") {
            if(!trocIsOn) {    
                energyBoost = class'tmodPackEnergy'.default.TROCenergyBoost;
                energyDuration = class'tmodPackEnergy'.default.TROCenergyDuration;
                Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 112);                
                trocIsOn = true;
            } else {
                energyBoost = class'tmodPackEnergy'.default.DEFAULTenergyBoost;
                energyDuration = class'tmodPackEnergy'.default.DEFAULTenergyBoost;
                Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 113);                
                trocIsOn = false;
            }
        }
        
        // (admin) mutate time [int]
        else if (Left(Command, 4) ~= "time") {
            parsedString = Locs(Command);
            parsedString -= "time ";
            
            if ( int(parsedString) < 0 )
                parsedString = "0";
            
            //ccmd will apply the new game duration to every 
            Sender.ConsoleCommand("set rounddata duration" @parsedString);
        }
        
        // (admin) mutate tournament
        else if (Command ~= "tournament") {
            
            if(!bTournamentMode) {
                //Cast broadcast msg to sender
                Sender.ClientMessage("Tournament Mode is enabled.");
                Sender.ConsoleCommand("admin set multiplayergameinfo bTournamentMode 1");
                bTournamentMode = true;
                } else {
                //Cast broadcast msg to sender
                Sender.ClientMessage("Tournament Mode is disabled.");
                Sender.ConsoleCommand("admin set multiplayergameinfo bTournamentMode 0");
                bTournamentMode = false;
            }
        }    
        
        //  (admin) mutate test
        else if (Command ~= "HelloWorld") {
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 110);
        }  
            
        //  (admin) mutate adminTest
        else if (Command ~= "admintest") {
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 111);
        }

        //  (admin) mutate help
        else if (Command ~= "help") {
        Sender.ClientMessage("List of available tribesmod commands:");
        Sender.ClientMessage("mutate troc               Toggles Between trocmode and default EnergyPack");
        Sender.ClientMessage("mutate time [value]       Adds [value] minutes to the game gime.");
        Sender.ClientMessage("mutate tournament         Toggles between tournament mode on or off. (takes effect after map change)");
        }
        
        // (admin) Destroy and respawn the replication class
        else if (Command ~= "RespawnRepclass") {
            destroyClientReplicationClass();
            log("*************** ADMIN SPAWNED NEW CLIENTREPLICATION CLASS **************");
            Spawn(class'tribesmod.clientReplication');
        }
        
        else if (Command ~= "destroyrepclass") {
            destroyClientReplicationClass();
        }
        
        else if (Command ~= "reload") {
            SaveConfigVariables();
        }
    }
    
    else if (!allowMutate) {
        // cast error to Sender   
        Sender.ClientMessage("Mutate commands are disabled");
    }
    
    else if (!Sender.AdminManager.bAdmin) {
       // cast error to Sender
       Sender.ClientMessage("You do not have the required permission to execute this command");
    }
}

simulated function ModifyPlayer(Pawn Other) {
    /* @effect ... function
    *
    *   Called by the server every time a player spawns
    */
    
    super.ModifyPlayer(Other);
}


simulated event Destroyed() {
    
    log("*** ======================= DESTROYED AS CLASS ======================= ***");
}

//#EndBlock

//#StartBlock ====================================DEFAULTPROPERTIES===========================================

    /* @effect ... DEFAULTPROPERTIES
    * 
    *   Defines values to the variables (more info: http://wiki.beyondunreal.com/Legacy:Default_Properties )    
    *   Contains inherited properties form Engine.Mutator
    *
    *   Comments inside the defaultproperties field should be avoided
    */

defaultproperties {
    
    SpawnCombatRole = class'EquipmentClasses.CombatRoleLight'
    SpawnInvincibility = 2
    HOknockbackscale=1.175000
    HOHealth=195
    
    EnablePod = true
    EnableRover = true
    EnableRoverGun = true
    EnableAssaultShip = true
    EnableTank = true
    TankUsesMortarProjectile = false
    TankDefaultProjectileVelocity = 6000
    TankMortarProjectileVelocity = 6000
    
    EnergyBoost = 75000.000000
    EnergyDuration = 1.000000
    
    RemoveBaseTurret = false   
    DisableDeployableTurrets = false
    DisableMines = false
    
    BonusStatsOn = true
    RunInTournament = true
    allowMutate = true
    enableTests = false
    trocIsOn = false
    bTournamentMode = false
    EnableDegrapple = true
    clientReplicationClass = class'clientReplication'
    spawnRepClass = true
    
    MTBalance = true
    MTTeamPlayerMin = 3
    BRTeamPlayerMin = 6
    BaseRape = false   
    TeamKillBanUser = false
    MaxTeamKills = 3
    TimerInterval = 45
    
    bAddToServerPackages = true             
    FriendlyName = "TribesMod, created by Cobra."
    Description = "Mutator code: tribesmod.as, settings in tribesmodSettings.ini and tribesmod.int. Big Thanks to dEhaV for releasing the promod's source!"
}