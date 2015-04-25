class tmodProjectileRocketPod extends EquipmentClasses.ProjectileRocketPod config(tribesmodSettings);
/**
*   Time Stamp: 15-04-15 13:37:30
*/

//save weapon properties in here to keep the main class clean
var config float projectileVelocity;
var config float projectileInheritedVelFactor;
var config float roundsPerSecond;
var config float launchDelay;
//projectile variables
var config float RPspiralRate;
var config float RParmingPeriod;
var config float RPspreadRadius;
var config float RPspreadPeriod;
var config float RPconvergeRadius;
var config float RPconvergePeriod;
var config float RPpostSpreadVelocity;
var config float RPpostSpreadAcceleration;
var config float RPmaxAnglePerSecond;
var config float RProtationModifier;
var config float RPdamage;
var config float RPdamageAOE;
var config float RPknockback;
var config float RPacceleration;
var config float RPmaxVelocity;
var config float RPLifeSpan;
var config bool RPbDeflectable;
//sadly enough constant variables
//var config float RPcollisionRadius;
//var config float RPcollisionHeight;


simulated function PreBeginPlay() {
    
    super.PreBeginPlay();
    
    SetProperties();
    SaveConfig();
}

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal) {

    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

/**
* Set the properties of a single rocket at spawn. 
*/
simulated function SetProperties() {
    
    class'tmodProjectileRocketPod'.default.radiusDamageAmt = RPdamage;
    class'tmodProjectileRocketPod'.default.radiusDamageMomentum = RPknockback;
    class'tmodProjectileRocketPod'.default.radiusDamageSize = RPdamageAOE;
    class'tmodProjectileRocketPod'.default.LifeSpan = RPLifeSpan;
    class'tmodProjectileRocketPod'.default.armingPeriod = RParmingPeriod;            
    class'tmodProjectileRocketPod'.default.postSpreadVelocity = RPpostSpreadVelocity;
    class'tmodProjectileRocketPod'.default.postSpreadAcceleration = RPpostSpreadAcceleration;
    class'tmodProjectileRocketPod'.default.maxAnglePerSecond = RPmaxAnglePerSecond;
    class'tmodProjectileRocketPod'.default.rotationModifier = RProtationModifier;
    class'tmodProjectileRocketPod'.default.bDeflectable = RPbDeflectable;
    class'tmodProjectileRocketPod'.default.convergePeriod = RPconvergePeriod;
    class'tmodProjectileRocketPod'.default.convergeRadius = RPconvergeRadius;
    class'tmodProjectileRocketPod'.default.spreadPeriod = RPspreadPeriod;
    class'tmodProjectileRocketPod'.default.spreadRadius = RPspreadRadius;
    class'tmodProjectileRocketPod'.default.spiralRate = RPspiralRate;
}

defaultproperties {
    
    RPbDeflectable=true
    RPspiralRate=-100.000000
    RParmingPeriod=0.500000
    RPspreadRadius=120.000000
    RPspreadPeriod=0.250000
    RPconvergeRadius=40.000000
    RPconvergePeriod=1.000000
    RPpostSpreadVelocity=30000.000000
    RPpostSpreadAcceleration=1500.000000
    RPmaxAnglePerSecond=90.000000
    RProtationModifier=1.000000    
    RPdamage=13.000000
    RPdamageAOE=240.000000
    RPknockback=70000.000000       
    RPLifeSpan=3.000000
    
    projectileVelocity=2500.000000
    projectileInheritedVelFactor=0.700000
    roundsPerSecond=0.600000
    launchDelay=0.160000
}
