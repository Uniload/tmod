class tmodGrapplerProjectile extends Gameplay.GrapplerProjectile;

/**
 * Unregistered hit fix. From NRBgone.
*/
function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal){
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

/**
 * Server crash fix. From franga_v1.
*/
simulated function simulatedAttach(Actor Other, vector TouchLocation)
{
    local Character c;
    c = Character(Other);

      if(c != None)
            Destroy();

    Super.simulatedAttach(Other, TouchLocation);

    SetCollision(true, true, true);
}

defaultproperties
{
}
