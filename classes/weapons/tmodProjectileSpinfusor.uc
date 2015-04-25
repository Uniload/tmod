class tmodProjectileSpinfusor extends EquipmentClasses.ProjectileSpinfusor config(tribesmodSettings);
/**
*   Class that will be called every time a spinfusor projectile is spawned.
*
*
*   Time Stamp: 15-04-15 13:37:41
*/

simulated function PreBeginPlay() {
    /*
    *   PreBeginPlay is called before the projectile is spawned.
    *
    */
    
    super.PreBeginPlay();
    SaveConfig();
    if(class'as'.default.enableTests){ProjTest();}
}

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
       super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

/**
*   Test function to check projectile lifespan. Note that Input/Output (in this case the use of "log()") is very slow,
*   so this function should never be used unless for debugging. (Will only be executed if var "enableTests" in main class is true.)
*/
function ProjTest() {
    
    local tmodProjectileSpinfusor projectileInstance;
    foreach AllActors(class'tmodProjectileSpinfusor', projectileInstance) {
    
        log("class'tmodProjectileSpinfusor' Projectile test");
        log(projectileInstance);
        log("proj LifeSpan: ");
        log(projectileInstance.LifeSpan);
    }
    log("***************");
}

defaultproperties
{
    radiusDamageAmt=58.000000
    radiusDamageMomentum=255000.000000
    radiusDamageSize=650.000000
    AccelerationMagtitude=360.000000
    MaxVelocity=0.000000
    LifeSpan=6.000000
}
