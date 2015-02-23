class tmodProjectileSniperRifle extends EquipmentClasses.ProjectileSniperRifle config(tribesmodSettings);

var config int SniperSensorDmg; // removes ability of light armour with speed pack to take out Sensor

function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
    if(BaseObjectClasses.BaseSensor(Other) != None)
        {
        damageAmt = SniperSensorDmg;
    }

    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}

// damageTypeClass=Class'tmodSniperProjectileDamageType'

defaultproperties
{
SniperSensorDmg=0
damageAmt=50.000000
damageTypeClass=Class'tmodSniperProjectileDamageType'
}
