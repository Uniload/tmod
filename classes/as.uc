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
*       - Adds stat classes to the game
*       - Adds mutate commands. See function Mutate()
*       
*/

// Some unresolved issue with UCC forces the use of the name "as.uc" instead of another class name

//#EndBlock

class as extends Gameplay.Mutator config(tribesmodSettings); 

//#StartBlock ========================================VARIABLES===============================================
/* @effect ... variables
*
*   list of variables used in the mutator's main class; tribesmod. Ordered by function
*
*/

const MOD_VERSION = "tribesmod";
// function modifyVehicles()
var config bool EnablePod;
var config bool EnableRover;
var config bool EnableRoverGun;     //toggles between retail rover with anti-AA gun and rover without gun.
var config bool EnableAssaultShip;
var config bool EnableTank;
// function modifyPlayerStart()
var config class<Gameplay.CombatRole> SpawnCombatRole;
var config int SpawnInvincibility;
// function modifySpinfusorWeaponClass
var config float SpinfusorPIVF;
var config int SpinfusorProjectileVelocity;
var config int SpinfusorAmmoUsage;
// function modifySniperRifleWeaponClass
var public int SnipeAmmoCount;
var public int SnipeAmmoUsage;
var public float SnipeLife;
//function actorReplace()
var config bool useDefaultBurner;
var config float PlasmaPIVF;
var config int PlasmaVelocity;
var config int PlasmaEnergyUsage;
// function removeBaseTurrets()
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
//function isSniperAllowed()
var config bool SniperPlayerThreshold;
var config int SniperTeamPlayerMin;
//function Mutate()
var config bool allowMutate;
var private bool trocIsOn;
//function actorReplace()
var public float EnergyBoost;
var public float EnergyDuration;
var config float ShieldPackActive;
var config float ShieldPackPassive;
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
        
function bool tournamentOn(string param) {
    /* @effect ... function
    *
    *   Called by PostBeginPlay(). Will return true if the current map is running in tournament mode.
    *
    * @param    ...
    *           if(param == string "boolean")
    *               Checks if the current game is running in tournament mode.
    *           if(param != string "boolean")
    *               Uses the function to enable or disable code when tournament mode is on (f.e. no extra stats in tourney mode)
    *
    *   Time Stamp: 14-02-15 15:21:29
    */
    
    if(param == "boolean") {
        return MultiplayerGameInfo(Level.Game).bTournamentMode;
        
    } else {        
        if(!RunInTournament) {
            return MultiplayerGameInfo(Level.Game).bTournamentMode;
            } else {
            return false;
        }
    }
}

simulated event PreBeginPlay() {
    /* @effect ... event
    *   
    *   Allows the mutator to modify, remove, or replace any actor when spawned through this function.
    *   (exeptions include actors flagged as "bGameRelevant" or when PreBeginPlay() is overridden without calling super.PreBeginPlay())
    *   Most of these functions originate from dEhaV's original mod, "promod".
    *
    *   Time Stamp: 14-02-15 15:21:51
    */
    
    super.PreBeginPlay();
    modifyCharacters();
    modifyPlayerStart();
    modifyFlagThrower();
    modifyVehicles();
    modifyBaseDeviceShieldClass();
    removeBaseTurrets();
    disableMineTurret();
    modifyStats();
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
    
function modifyFlagThrower() {
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
        if(ImpFlag != None)
            ImpFlag.carriedObjectClass = Class'tmodFlagThrowerImperial';
            
    foreach AllActors(class'GameClasses.CaptureFlagBeagle', BEFlag)
        if(BEFlag != None)
            BEFlag.carriedObjectClass = Class'tmodFlagThrowerBeagle';
            
    foreach AllActors(class'GameClasses.CaptureFlagPhoenix', PnxFlag)
        if(PnxFlag != None)
            PnxFlag.carriedObjectClass = Class'tmodFlagThrowerPhoenix';   
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
        }
            else if(!EnablePod) {
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
        }
            else if(!EnableRover) {
                if (vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleBuggy')
                    vehiclePad.setSwitchedOn(false);
            }               
        if(EnableAssaultShip) {
              if(vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleAssaultShip')
            vehiclePad.setSwitchedOn(true);
        }
            else if(!EnableAssaultShip) {
                if(vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleAssaultShip')
                    vehiclePad.setSwitchedOn(false);
            }
        if(EnableTank) {
              if(vehiclePad != None && vehiclePad.vehicleClass == class'VehicleClasses.VehicleTank')
              vehiclePad.vehicleClass = class'tribesmod.tmodTank';
        }
            else if(!EnableTank) {
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
    *
    *   Time Stamp: 14-02-15 15:25:58
    */
    
    local BaseObjectClasses.BaseTurret BaseTurrets;
    local BaseObjectClasses.StaticMeshRemovable TurretBase;
    
    foreach AllActors(class'BaseObjectClasses.BaseTurret', BaseTurrets)
        if(BaseTurrets != None && RemoveBaseTurret)
            BaseTurrets.destroy();
            
    foreach AllActors(class'BaseObjectClasses.StaticMeshRemovable', TurretBase)
        if(BaseTurrets != None && RemoveBaseTurret)
            TurretBase.destroy();
}
        
function disableMineTurret() {
    /* @effect ... function
    *   
    *   Disables the deployable Turret and Mine stations
    *
    *   Time Stamp: 14-02-15 15:26:30
    */
    
    local BaseObjectClasses.BaseDeployableSpawnTurret DeployableTurretStation;
    local BaseObjectClasses.BaseDeployableSpawnShockMine DeployableMineStation;

    foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnTurret', DeployableTurretStation)
        if(DeployableTurretStation != None && DisableDeployableTurrets)
            DeployableTurretStation.Destroy();

    foreach AllActors(class'BaseObjectClasses.BaseDeployableSpawnShockMine', DeployableMineStation)
        if(DeployableMineStation != None && DisableMines)
            DeployableMineStation.Destroy();
}

function modifyStats() {
    /* @effect ... function
    *   
    *   Modifies and adds new stats to the game (midair stats)
    *
    *   Time Stamp: 22-02-15 15:26:58
    */

    local ModeInfo M;
    local int statCount;
    local int i;
    
    M = ModeInfo(Level.Game);
      
    if(M != None && BonusStatsOn) {
        //search for the weapon stat and set it's extended stat
        for(i = 0; i < M.extendedProjectileDamageStats.Length; ++i) {
            //search by damage type
            if(M.extendedProjectileDamageStats[i].damageTypeClass == Class'EquipmentClasses.ProjectileDamageTypeSpinfusor') {
                M.extendedProjectileDamageStats[i].extendedStatClass = Class'statMA';
            }
        }   
        for(i = 0; i < M.projectileDamageStats.Length; ++i) {
            if(M.projectileDamageStats[i].damageTypeClass == Class'EquipmentClasses.ProjectileDamageTypeSniperRifle') {
                M.projectileDamageStats[i].damageTypeClass = Class'tribesmod.tmodSniperProjectileDamageType';
                M.projectileDamageStats[i].headShotStatClass = Class'statHS';
            }   
        }
    
        statCount = M.extendedProjectileDamageStats.Length;
        M.extendedProjectileDamageStats.Insert(statCount, 7);       // We have 7 new stats
    
        //E-Blade       1
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'tribesmod.tmodBladeProjectileDamageType';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statEBMA';
        ++statCount;
    
        // GLMA         2
        //M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'EquipmentClasses.ProjectileDamageTypeGrenadeLauncher'; issue with GLma stat
        M.extendedProjectileDamageStats[statCount].damageTypeClass = Class'tribesmod.tmodProjectileGrenadeLauncherDamageType';
        M.extendedProjectileDamageStats[statCount].extendedStatClass = Class'statGLMA';
    
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
    }
}

function PostBeginPlay() {
    /* @effect ... event
    * 
    *   Used to implement logic that should happen after engine-side initialisation of the actor. In our case, used for anti-baserape, anti-team kill and mines/turret control
    *   Most of these functions originate from dEhaV's original mod, "promod".    
    *
    *   Time Stamp: 14-02-15 15:27:24
    */
    
    super.PostBeginPlay();

    if(!tournamentOn(" ") && CTF()) {   // Functions will never be called if the gamemode is not CTF, but will, if RunInTournament=true, run in tournament Mode        
    UpdateMTDevices();
    UpdateBRDevices();
    SniperRifleAllowance();
    SetTimer(TimerInterval, true);
    }
}

function Timer() {
    /* @effect ... function
    *   
    *   Server-side timer (Might not be true because PostBeginPlay() is a simulated event). Also takes care of the anti-teamkill system
    *
    *   Time Stamp: 15-02-15 15:28:06
    */
    
    local Controller C;
    local int i, s;
    local PlayerReplicationInfo P;
  
    if(MTBalance && !EnableMT()) {
        MTBalance = false;
        UpdateMTDevices();
        Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 100);
        
        } else if(!MTBalance && EnableMT()) {
            MTBalance = true;
            UpdateMTDevices();
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 101);
    }
    if(BaseRape && !EnableBR()) {
        BaseRape = false;
        UpdateBRDevices();
        Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 103);
        
        } else if(!BaseRape && EnableBR()) {
            BaseRape = true;
            UpdateBRDevices();
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 104);
    }
    if(SniperPlayerThreshold && !EnableSniperRifle()) {
        SniperPlayerThreshold = false;
        SniperRifleAllowance();
        Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 108);
        
        } else if(!SniperPlayerThreshold && EnableSniperRifle()) {
            SniperPlayerThreshold = true;
            SniperRifleAllowance();
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 109);
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
   
function bool EnableSniperRifle() {
    /* @effect ... function
    *   
    *   Enables sniperRifle above a certain player amount
    *
    *   Time Stamp: 15-02-15 15:28:34
    */
    
    local TeamInfo Team;
    
    foreach AllActors(class'TeamInfo', Team) {
        if(Team != None)
            if(Team.numPlayers() < SniperTeamPlayerMin)
                return false;
            return true;
    }
}
   
function bool EnableBR() {
    /* @effect ... function
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

function SniperRifleAllowance() {
    /* @effect ... function
    *   
    *   Time Stamp: 15-02-15 15:30:18
    */
    
    if(SniperPlayerThreshold) {
        SnipeAmmoCount = 0;		//does not work, yet ;p
        SnipeLife = 1.000000;        
        } else if(!SniperPlayerThreshold) {
        SnipeAmmoCount = 10;	//does not work, yet ;p
        SnipeLife = 0.000000;
    }               
}

simulated event Actor ReplaceActor(Actor Other) {
    /* @effect ... event
    *   
    *   find actors and replace their classes
    *   Note: Actor ReplaceActor() is a simulated event, this will cause timer-based settings (like weapon firerate) to be occasionnaly out of sync with the server.
    *
    *   Time Stamp: 22-02-15 15:30:54
    */
 
    if(Other.IsA('WeaponSpinfusor')) {    
        WeaponSpinfusor(Other).projectileClass = class'tmodProjectileSpinfusor';
        WeaponSpinfusor(Other).projectileInheritedVelFactor = SpinfusorPIVF;
        WeaponSpinfusor(Other).projectileVelocity = SpinfusorProjectileVelocity;
        WeaponSpinfusor(Other).ammoUsage = SpinfusorAmmoUsage;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponSniperRifle')) {
        WeaponSniperRifle(Other).projectileClass = Class'tmodProjectileSniperRifle';
        WeaponSniperRifle(Other).LifeSpan = SnipeLife;
        WeaponSniperRifle(Other).ammoCount = SnipeAmmoCount;
        WeaponSniperRifle(Other).ammoUsage = SnipeAmmoUsage;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('Grappler')) {
        if(EnableDegrapple)
            Grappler(Other).projectileClass = Class'tmodDegrappleProjectile';
        else
            Grappler(Other).projectileClass = Class'Gameplay.GrapplerProjectile';
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponGrenadeLauncher')) {
        WeaponGrenadeLauncher(Other).projectileClass = Class'tmodProjectileGrenadeLauncher';
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponMortar')) {
        WeaponMortar(Other).projectileClass = Class'tmodProjectileMortar';
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponChaingun')) {
        WeaponChaingun(Other).projectileClass = Class'tmodProjectileChaingun';
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('WeaponRocketPod')) {
        WeaponRocketPod(Other).projectileClass = Class'tmodProjectileRocketPod';
        return Super.ReplaceActor(Other);
    }
    
    if(!useDefaultBurner) {
        if(Other.IsA('WeaponBurner')) {
            WeaponBurner(Other).projectileClass = Class'tmodProjectilePlasma';
            WeaponBurner(Other).projectileInheritedVelFactor = PlasmaPIVF; //was .4
            WeaponBurner(Other).projectileVelocity = PlasmaVelocity; //was 4700
            WeaponBurner(Other).energyUsage = PlasmaEnergyUsage;
            WeaponBurner(Other).localizedname = "Plasma gun";
            return Super.ReplaceActor(Other);
        }
    }
    
    if(Other.IsA('WeaponHandGrenade')) {
        //Does not work, possibly overwritten by map classes. (though "admin set (package)(property)(value)" does work)
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodWeaponHandGrenade");
    }
    
    if(Other.IsA('WeaponEnergyBlade')) {
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodWeaponEnergyBlade");
    }
    
    if(Other.IsA('WeaponVehicleTank')) {
        if(TankUsesMortarProjectile) {
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
    
    if(Other.IsA('EnergyPack')) {    
        EnergyPack(Other).boostImpulsePerSecond = EnergyBoost;
        EnergyPack(Other).durationSeconds = EnergyDuration;
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('ShieldPack')) {
        ShieldPack(Other).activeFractionDamageBlocked = ShieldPackActive;   //was .75
        ShieldPack(Other).passiveFractionDamageBlocked = ShieldPackPassive; //was .2
        return Super.ReplaceActor(Other);
    }
    
    if(Other.IsA('CloakPack')) {
        Other.Destroy();
        return ReplaceWith(Other, MOD_VERSION $ ".tmodAntiCloak");
    }        
    return Super.ReplaceActor(Other);
}

function string MutateSpawnCombatRoleClass(Character c) {
    /* @effect ... function
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

    for(i = 0; i < c.team().combatRoleData.length; i++) {
		for(j = 0; j < c.team().combatRoleData[i].role.default.armorClass.default.AllowedWeapons.length; j++) {
                      
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
    *	Time Stamp: 20-02-15 15:31:46
    */
    
    if(allowMutate && Sender.AdminManager.bAdmin) {
    
        if(Command == "test") {
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 110);
        }
        if(Command == "adminTest" && Sender.AdminManager.bAdmin) {
            Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 111);
        }
        if(Command == "troc") {
            
            if(!trocIsOn) {    
                EnergyBoost = 750000.000000;
                EnergyDuration = 0.100000;
                Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 112);                
                trocIsOn = true;
                } else {
                EnergyBoost = 75000.000000;
                EnergyDuration = 1.000000;
                Level.Game.BroadcastLocalized(self, class'tmodGameMessage', 113);                
                trocIsOn = false;
            }
        }
    }
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
    
    SniperPlayerThreshold = false
    SniperTeamPlayerMin = 2
    
    SpinfusorPIVF = 0.50000
    SpinfusorProjectileVelocity = 6850
    SpinfusorAmmoUsage = 1
    EnergyBoost = 75000.000000
    EnergyDuration = 1.000000
    SnipeAmmoCount = 0
    SnipeAmmoUsage = 1
    SnipeLife = 1.000000
    useDefaultBurner = false
    PlasmaPIVF = 0.500000
    PlasmaVelocity = 4900
    PlasmaEnergyUsage = 10
    
    ShieldPackActive = 0.600000
    ShieldPackPassive = 0.130000
    
    RemoveBaseTurret = false   
    DisableDeployableTurrets = false
    DisableMines = false
    
    BonusStatsOn = true
    RunInTournament = true
    allowMutate = true
    trocIsOn = false
    EnableDegrapple = true
    
    MTBalance = true
    MTTeamPlayerMin = 3
    BRTeamPlayerMin = 6
    BaseRape = true   
    TeamKillBanUser = false
    MaxTeamKills = 3
    TimerInterval = 45
    
    bAddToServerPackages = true             
    FriendlyName = "TribesMod, created by Cobra."
    Description = "Mutator code: tribesmod.as, settings in tribesmodSettings.ini and tribesmod.int"
}

//#EndBlock