class tmodProjectileSpinfusor extends EquipmentClasses.ProjectileSpinfusor config(tribesmodSettings);


function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
       super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}


   
defaultproperties {
    
    radiusDamageAmt=58
    radiusDamageSize=650.000000
    radiusDamageMomentum=255000.000000
    MaxVelocity=10000.000000
    Lifespan=6.000000
}
