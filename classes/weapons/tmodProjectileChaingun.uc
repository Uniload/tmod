class tmodProjectileChaingun extends EquipmentClasses.ProjectileChaingun config(tribesmodSettings);

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal){
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
    damageAmt=4.0
}
