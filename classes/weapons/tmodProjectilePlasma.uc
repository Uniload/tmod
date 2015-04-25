class tmodProjectilePlasma extends EquipmentClasses.ProjectileBurner config(tribesmodSettings);

var bool bEndedLife;
//Burner projectile does not have radiusDamageSize and radiusDamageMomentum by default
var() float radiusDamageSize;
var() float radiusDamageMomentum;
//projectile
var config float damage;
var config float knockback;
var config float damageAOE;
//weapon 
var config string localizedName;
var config bool useDefaultBurner;
var config float PlasmaPIVF;
var config float PlasmaVelocity;
var config float PlasmaEnergyUsage;
var config bool canBeDeflected;
var config float PlasmaLifeSpan;

simulated function PreBeginPlay() {

    super.PreBeginPlay();
    SaveConfig();
}

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal){
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

simulated function ProjectileHit(Actor Other, vector TouchLocation, vector Normal) {
    endLife(Other, TouchLocation, Normal);
    super.ProjectileHit(Other, TouchLocation, Normal);
}

simulated function endLife(Actor HitActor, vector TouchLocation, Optional vector TouchNormal) {
    //local float speed;
    local Vector direction;

    SpawnBurningArea();

    if (bEndedLife)
        return;

    bEndedLife = true;

    HurtRadius(damage, radiusDamageSize, damageTypeClass, radiusDamageMomentum, TouchLocation, HitActor, direction);

    Super.endLife(None, TouchLocation, TouchNormal);
}

simulated function triggerHitEffect(Actor HitActor, vector TouchLocation, vector TouchNormal, optional Name HitEffect) {
    SpawnBurningArea();
}

simulated function BurnTarget(Rook target) {
}

simulated function SetProperties() {
 
    class'tmodProjectilePlasma'.default.damageAmt = damage;
    class'tmodProjectilePlasma'.default.radiusDamageSize = damageAoe;
    class'tmodProjectilePlasma'.default.knockbackAliveScale = knockback;
    class'tmodProjectilePlasma'.default.bDeflectable = canBeDeflected;
    
    class'tmodProjectilePlasma'.default.LifeSpan = PlasmaLifeSpan;    
    class'tmodProjectilePlasma'.default.ignitionDelay = PlasmaLifeSpan;
}

defaultproperties
{
    radiusDamageSize=400.000000
    ignitionDelay=4.25000000
    burningAreaClass=Class'tmodPlasmaArea'
    bDeflectable=False
    knockbackAliveScale=1.000000
    StaticMesh=None
    
    DrawScale3D=(Z=2.000000)
    CollisionRadius=30.000000
    CollisionHeight=30.000000
     
    damage=50.000000
    damageAoe = 400.000000
    knockback = 1.000000
    PlasmaLifeSpan=4.250000
    canBeDeflected = false
     
    localizedName = "Plasma Gun"
    useDefaultBurner = false
    PlasmaPIVF = 0.500000
    PlasmaVelocity = 4900.000000
    PlasmaEnergyUsage = 10.000000
}
