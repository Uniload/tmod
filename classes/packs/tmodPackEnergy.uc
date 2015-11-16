

class tmodPackEnergy extends Gameplay.EnergyPack config(tribesmodSettings);


var config int charges;

/*
    3Charges on Epack
*/

simulated state Active
{
    simulated function tick(float deltaSeconds)
    {
        local vector facing;
        local float AppliedImpulsePerSecond;
        
        if (charges != 0) {
        
            Super.tick(deltaSeconds);

            if (heldBy != None && heldBy.movementObject != None)
            {
                // calculate facing
                facing = vect(1,0,0);
                facing = facing >> heldBy.motor.getViewRotation();

                // tune the boost to act on a mass of 100 regardless
                AppliedImpulsePerSecond = (boostImpulsePerSecond * heldBy.unifiedGetMass()) / 100;

                // apply boost
                heldBy.movementObject.addImpulse(facing * AppliedImpulsePerSecond * deltaSeconds);
            }
            
            charges -= 1;
            log("EPACK TROC CHARGES::");
            log(charges);
            
        } else {
        
            log("EPACK TROC CHARGES::");
            log(charges);
        }
    }
}


defaultproperties
{
    charges=3
    
    
    refireRateScale=2.000000
    passiveRefireRateScale=1.250000
    activeMaterial=Shader'FX.BucklerShieldShadder'
    rechargeTimeSeconds=13.000000
    rampUpTimeSeconds=0.250000
    deactivatingDuration=0.250000
    durationSeconds=5.000000
    thirdPersonMesh=StaticMesh'packs.SpeedPack'
    localizedName="SPEED PACK"
    infoString="Passive effect increases the user's running speed.  Active effect decreases the reload time of equipped weapons."
    inventoryIcon=Texture'GUITribes.InvButtonSpeed'
    hudIcon=Texture'HUD.Tabs'
    hudIconCoords=(U=410.000000,V=165.000000)
    hudRefireIcon=Texture'HUD.Tabs'
    hudRefireIconCoords=(U=410.000000,V=114.000000)
    cannnotBeUsedWhileTouchingInventoryStation=True
    StaticMesh=StaticMesh'packs.SpeedPackdropped'
}