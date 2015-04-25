class tmodProjectileGrenadeLauncher extends EquipmentClasses.ProjectileGrenadeLauncher config(tribesmodSettings);
/**
*   Time Stamp: 15-04-15 13:36:53
*/

//projectile
var config float damage;
var config float projLifeSpan;
var config float knockback;
var config float damageAOE;
var config float projFuseTimer;
var config float projGravityScale;
var config float projMass;
//weapon
var config float GrenadeLauncherPIVF;
var config float GrenadeLauncherProjectileVelocity;
var config float GrenadeLauncherAmmoUsage;

simulated function PreBeginPlay() {
    
    super.PreBeginPlay();   
    SaveConfig();
}

/**
 * Unregistered hit fix. From NRBgone.
*/
simulated function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal) {
       super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

/**
 * Projectile catapult bounce server crash fix. From franga_v1.
*/  
simulated function bool projectileTouchProcessing(Actor Other, vector TouchLocation, vector TouchNormal) {
    if (Other.IsA('BaseCatapult'))
        return false;
    
    if (Other.IsA('DeployedCatapult'))
        return false;

    return true;
    super.projectileTouchProcessing(Other, TouchLocation, TouchNormal);
}

simulated function SetProperties() {
/*
*   Was used to set the desired weapon properties with the ini file. This method did not affect the first projectile though.
*/   
    log("Called Function");
    class'tmodProjectileGrenadeLauncher'.default.radiusDamageAmt = damage;
    class'tmodProjectileGrenadeLauncher'.default.radiusDamageMomentum = knockback;
    class'tmodProjectileGrenadeLauncher'.default.radiusDamageSize = damageAOE;
    class'tmodProjectileGrenadeLauncher'.default.FuseTimer = projFuseTimer;
    class'tmodProjectileGrenadeLauncher'.default.LifeSpan = projLifeSpan;
    class'tmodProjectileGrenadeLauncher'.default.GravityScale = projGravityScale;
    class'tmodProjectileGrenadeLauncher'.default.Mass = projMass;
}
  
defaultproperties
{
    damage=58.000000
    damageAOE=900.000000
    knockback=220000.000000
    projFuseTimer=0.750000
    projLifeSpan=10.000000
    collisionRadius=11.000000
    collisionHeight=11.000000
    projGravityScale=1.200000
    projMass=100.000000
   
    GrenadeLauncherPIVF=0.500000
    GrenadeLauncherProjectileVelocity=4800.000000
    GrenadeLauncherAmmoUsage=1
}
