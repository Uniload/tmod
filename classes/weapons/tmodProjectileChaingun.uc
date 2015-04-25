class tmodProjectileChaingun extends EquipmentClasses.ProjectileChaingun config(tribesmodSettings);
/**
*   Time Stamp: 15-04-15 13:37:10
*/

//projectile
var config float damage;
var config float projLifeSpan;
//weapon
var config float projectileVelocity;
var config float projectileInheritedVelFactor;
var config float roundsPerSecond;
var config float spinPeriod;
var config float speedCooldownFactor;
var config float heatPeriod;
var config float maxSpread;
var config float minSpread;

simulated function PreBeginPlay() {
    
    super.PreBeginPlay();  
    SaveConfig();
    if(class'as'.default.enableTests){ProjTest();}
}

/**
 * Unregistered hit fix. From NRBgone.
*/
simulated function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal){
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

simulated function SetProperties() {
    
    class'tmodProjectileChaingun'.default.damageAmt = damage;
    class'tmodProjectileChaingun'.default.LifeSpan = projLifeSpan;
}
        
function ProjTest() {
    
    local tmodProjectileChaingun projectileInstance;
    foreach AllActors(class'tmodProjectileChaingun', projectileInstance) {
    
        log("class'tmodProjectileChaingun' Projectile test");
        log(projectileInstance);
        log("proj damage: ");
        log(projectileInstance.damageAmt);
    }
    log("***************");
}

defaultproperties
{
    damage=4.000000
    lifeSpan=1.100000
    
    projectileVelocity=32000.000000
    projectileInheritedVelFactor=1.000000
    roundsPerSecond=7.500000
    spinPeriod=0.050000
    speedCooldownFactor=0.002000
    heatPeriod=7.000000
    maxSpread=2.000000
    minSpread=0.400000
}
