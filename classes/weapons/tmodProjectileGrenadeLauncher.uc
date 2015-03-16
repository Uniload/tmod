class tmodProjectileGrenadeLauncher extends EquipmentClasses.ProjectileGrenadeLauncher;

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
       super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

/**
 * Projectile catapult bounce server crash fix. From franga_v1.
*/  
simulated function bool projectileTouchProcessing(Actor Other, vector TouchLocation, vector TouchNormal)
{
    if (Other.IsA('BaseCatapult'))
    {
        return false;
    }
        if (Other.IsA('DeployedCatapult'))
    {
        return false;
    }
    return true;
    super.projectileTouchProcessing(Other, TouchLocation, TouchNormal);
}

//damageTypeClass = Class'tmodProjectileGrenadeLauncherDamageType';

defaultproperties
{
}
