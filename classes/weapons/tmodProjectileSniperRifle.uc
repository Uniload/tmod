class tmodProjectileSniperRifle extends EquipmentClasses.ProjectileSniperRifle config(tribesmodSettings);

var config int sniperSensorDmg; // removes ability of light armour with speed pack to take out Sensor
var config int sniperDamage;

var config float headModifier;
var config float backModifier;
var config float vehicleModifier;


function ProjectileTouch(Actor Other, vector TouchLocation, vector TouchNormal)
{
    if(BaseObjectClasses.BaseSensor(Other) != None)
        {
            damageAmt = sniperSensorDmg;
    }
    super.ProjectileTouch(Other, TouchLocation, TouchNormal);
}


function PreBeginPlay() {
    
    super.PreBeginPlay();
    
    class'tribesmod.tmodSniperProjectileDamageType'.default.headDamageModifier = headModifier;
    class'tribesmod.tmodSniperProjectileDamageType'.default.backDamageModifier = backModifier;
    class'tribesmod.tmodSniperProjectileDamageType'.default.vehicleDamageModifier = vehicleModifier;
    
    SaveConfig();
}

defaultproperties
{
    sniperDamage=50
    sniperSensorDmg=0
    
    headModifier=1.400000
    backModifier=1.000000
    vehicleModifier=1.000000
    
    damageAmt=50.000000
    damageTypeClass=Class'tmodSniperProjectileDamageType'
}
