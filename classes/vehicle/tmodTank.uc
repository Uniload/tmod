class tmodTank extends VehicleClasses.VehicleTank config(tribesmodSettings);

simulated function bool canArmorOccupy(VehiclePositionType position, Character character)
{
    if (character.armorClass == None)
    {
        warn(character.name $ "'s armor class is none");
        return true;
    }

    if(character.ArmorClass == class'EquipmentClasses.ArmorHeavy')
        return true;
    else
        return true;
    
}

defaultproperties
{
     Health=1500.000000
     boostStrength=16000000.000000
     treadLength=230.000000
     throttleToVelocityFactor=35.000000
     treadGainFactor=0.090000
     treadVehicleGravityScale=2.000000
}
