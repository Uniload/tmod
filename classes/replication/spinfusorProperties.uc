
class spinfusorProperties extends EquipmentClasses.ProjectileSpinfusor config(tribesmodSettings);

/*
*******************************************Replicate default projectile class
*class spinfusorProperties extends Engine.Actor config(tribesmodSettings);
*
*   Time Stamp: 15-04-15 19:05:37
*/


/*
* Replication attempt
*/

var config float radiusDamageAmt;
var config float radiusDamageMomentum;
var config float radiusDamageSize;
var config float AccelerationMagtitude;
var config float LifeSpan;
var config float MaxVelocity;

var config float ProjectileVelocity;
var config float InheritedVelFactor;
var config int AmmoUsage;

/*
replication
{
    reliable if (ROLE == ROLE_Authority)
        AccelerationMagtitude, LifeSpan, MaxVelocity, ProjectileVelocity, InheritedVelFactor, InitializeSpinfusor, ClientLogTest;
}
*/

event PreBeginPlay()
{
    local tribesmod.spinfusorProperties sP;
 
    foreach AllActors(class'tribesmod.spinfusorProperties', sP)
    {
        if (sP != self)
        {
            sP.Destroy();
        }
    }
    log(sP);
}

simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    
    InitializeSpinfusor();
    ServerSaveConfig();
    ClientLogTest();
    
    log(self.name);
}

simulated function InitializeSpinfusor()
{    
    class'tmodProjectileSpinfusor'.default.radiusDamageAmt = radiusDamageAmt;
    class'tmodProjectileSpinfusor'.default.radiusDamageMomentum = radiusDamageMomentum;
    class'tmodProjectileSpinfusor'.default.radiusDamageSize = radiusDamageSize;
    class'tmodProjectileSpinfusor'.default.AccelerationMagtitude = AccelerationMagtitude;
    class'tmodProjectileSpinfusor'.default.LifeSpan = LifeSpan;
    class'tmodProjectileSpinfusor'.default.MaxVelocity = MaxVelocity;
    log("SpinfusorProperties :: Spinfusor properties replicated");
}

function ServerSaveConfig()
{
    SaveConfig();   
}

function  ClientLogTest()
{
    log("CLIENT REPLICATED THE FUNCTION");   
}

simulated event Destroyed()
{
    log("*** DESTROYED SPINPROPERTIES CLASS ***");
}

defaultproperties
{
    RemoteRole = ROLE_SimulatedProxy
    bStatic = false
    bNoDelete = false
    bNetNotify = true
    
    radiusDamageAmt=58.000000
    radiusDamageMomentum=255000.000000
    radiusDamageSize=650.000000
    AccelerationMagtitude=360.000000
    MaxVelocity=0.000000
    LifeSpan=6.000000
    
    ProjectileVelocity = 6850.000000
    InheritedVelFactor = 0.500000
    AmmoUsage = 1    
}