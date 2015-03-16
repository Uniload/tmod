//POINTER PROJECTILE

class tmodProjectilePointer extends Gameplay.SniperRifleProjectile;

//var SniperRifleBeam beam;
var tmodPointerBeam beam;
var float energyModifier;

// construct
overloaded simulated function construct(Rook attacker, optional actor Owner, optional name Tag, 
                  optional vector Location, optional rotator Rotation)
{
    //energyModifier = Character(attacker).energy / Character(attacker).energyMaximum;  //this value modifies the beam's color intensity, pointer will always have max intensity (= 1).
    energyModifier = 2;         

    damageAmt = default.damageAmt * energyModifier;
    
    super.construct(attacker, Owner, Tag, Location, Rotation);
}

simulated function ProjectileHit(Actor Other, vector TouchLocation, vector TouchNormal)
{
    // scale knockback my energy multiplier

    local Vector momentum;
    
    momentum = normal(velocity) * knockback;

    victim = Other.Name;

    Other.TakeDamage(damageAmt, Instigator, TouchLocation, momentum, damageTypeClass, 1.0-knockbackAliveScale);

    endLife(Other, TouchLocation, TouchNormal);
}

simulated function PostBounce(Projectile newProjectile)
{
    //local SniperRifleProjectile srProj;
    local tmodProjectilePointer srProj;

    srProj = tmodProjectilePointer(newProjectile);

    srProj.energyModifier = energyModifier;
    srProj.damageAmt = damageAmt;

    //new class'SniperRifleBeam'(srProj);
    new class'tmodPointerBeam'(srProj);     //we have our custom beam class for this weapon

    super.PostBounce(srProj);
}

simulated function Destroyed()
{
    if (beam != None)
        beam.onProjectileDeath();

    super.Destroyed();
}

defaultproperties
{
    damageAmt=0.000000
    LifeSpan=0.100000
    Knockback=-60000.000000
    DrawScale3D=(X=0.100000,Y=0.100000,Z=0.100000)
    damageTypeClass=class'tmodPointerDamageType'
}
