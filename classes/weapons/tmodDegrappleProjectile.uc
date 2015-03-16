class tmodDegrappleProjectile extends Gameplay.GrapplerProjectile;

var float Health;
var float burningDamagerPerSecond;

function PostBeginPlay()
{
    SaveConfig();
}

function PostTakeDamage(float Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional float projectileFactor)
{
    Health -= Damage;
    
    if(Health <= 0)
        Destroy();
        
    Super.PostTakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, projectileFactor);
}

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
     Health=30.000000
     burningDamagerPerSecond=55.000000
     bCanBeDamaged=True
     bProjTarget=True
}
