class tmodProjectileRocketPod extends EquipmentClasses.ProjectileRocketPod config(tribesmodSettings);

function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
         {
      super.ProjectileTouch(Other, TouchLocation, TouchNormal);
         }

defaultproperties
{
damageAmt=20.000000
radiusDamageAmt=13.000000
}
