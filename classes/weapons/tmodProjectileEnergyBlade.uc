class tmodProjectileEnergyBlade extends Gameplay.Projectile;

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal){
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
    damageTypeClass=Class'tmodBladeProjectileDamageType'
}
