class tmodProjectileChaingun extends EquipmentClasses.ProjectileChaingun config(tribesmodSettings);

function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal){
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

defaultproperties
{
    damageAmt=5.0
}
