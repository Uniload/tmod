class tmodProjectileMortar extends EquipmentClasses.ProjectileMortar config(tribesmodSettings);
/**
*   Time Stamp: 15-04-15 13:37:01
*/

//projectile
var config float damage;
var config float projLifeSpan;
var config float knockback;
var config float damageAOE;
var config float projFuseTimer;
var config float projGravityScale;
var config float projMass;
//Weapon
var config float MortarPIVF;
var config float MortarProjectileVelocity;
var config int MortarAmmoUsage;

simulated function PreBeginPlay() {
    
    super.PreBeginPlay();  
    SaveConfig();
}

/**
 * Unregistered hit fix. From NRBgone.
*/
simulated function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
       super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

/**
 * Projectile catapult bounce server crash fix. From franga_v1.
*/  
simulated function bool projectileTouchProcessing(Actor Other, vector TouchLocation, vector TouchNormal)
{
    if (Other.IsA('BaseCatapult'))
        return false;

    if (Other.IsA('DeployedCatapult'))
        return false;

    return true;
    super.projectileTouchProcessing(Other, TouchLocation, TouchNormal);
}

simulated function SetProperties() {

    class'tmodProjectileMortar'.default.radiusDamageAmt = damage;
    class'tmodProjectileMortar'.default.radiusDamageMomentum = knockback;
    class'tmodProjectileMortar'.default.radiusDamageSize = damageAOE;
    class'tmodProjectileMortar'.default.FuseTimer = projFuseTimer;
    class'tmodProjectileMortar'.default.LifeSpan = projLifeSpan;
    class'tmodProjectileMortar'.default.GravityScale = projGravityScale;
    class'tmodProjectileMortar'.default.Mass = projMass;
}

defaultproperties
{
    damage=120.000000
    damageAOE=1400.000000
    knockback=290000.000000
    projFuseTimer=1.350000
    projLifeSpan=11.000000
    projGravityScale=1.200000
    projMass=100.000000
    
    MortarPIVF=0.400000
    MortarProjectileVelocity=5450.000000
    MortarAmmoUsage=1
}

