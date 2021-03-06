class tmodProjectileBlaster extends EquipmentClasses.ProjectileBlaster config(tribesmodSettings);

//projectile
var bool bShouldBounce;
var config float bounceTime "The amount of time for which a projectile is allowed to bounce";
var config int maxBounces;
var config float damageAmt;
//weapon
var config float BlasterSpread;
var config int BlasterBulletAmount;
var config float BlasterRoundsPerSecond;
var config float BlasterEnergyUsage;
var config float BlasterVelocity;
var config float BlasterPIVF;

//const AI_FRIENDLY_FIRE_MULTIPLIER = 0.2;

simulated function PostNetBeginPlay()
{
    Super.PostNetBeginPlay();

    SetTimer(bounceTime, false); // blaster projectiles can only bounce over a short range
}
    
function PostBeginPlay()
{
    SaveConfig();
}

simulated function Timer()
{
    bShouldBounce = false;
}

simulated function HitWall(vector HitNormal, actor Wall)
{
    if (bShouldBounce && bounceCount < maxBounces)
    {
        bounce(HitNormal, Location, Vect(0.0, 0.0, 0.0));
        TriggerEffectEvent('Bounce');

        if (Level.NetMode == NM_Client)
            Destroy();
    }
    else
    {
        endLife(None, Location, HitNormal);
    }
}

simulated function ProjectileHit(Actor Other, vector TouchLocation, vector TouchNormal)
{
    local Rook rookOther;

    if (Level.NetMode == NM_StandAlone && Instigator != None && Instigator.Controller != None && !Instigator.Controller.bIsPlayer)
    {
        rookOther = Rook(Other);

        if (rookOther != None && rookOther.isFriendly(Rook(Instigator)))
            damageAmt *= AI_FRIENDLY_FIRE_MULTIPLIER;
    }

    super.ProjectileHit(Other, TouchLocation, TouchNormal);
}

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal){
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
     bShouldBounce=True
     bounceTime=0.500000
     maxBounces=2
     damageAmt=7.000000
     bScaleProjectile=True
     initialXDrawScale=0.050000
     xDrawScalePerSecond=10.000000
     Knockback=15000.000000
     DrawScale3D=(X=0.300000,Y=0.300000,Z=0.300000)
     
     BlasterSpread=2.200000
     BlasterBulletAmount=7
     BlasterRoundsPerSecond=1.200000
     BlasterEnergyUsage=1.500000
     BlasterVelocity=18000.000000
     BlasterPIVF=0.000000
}