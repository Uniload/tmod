

class tmodPackEnergy extends Gameplay.EnergyPack config(tribesmodSettings);


var private int charges;

var config float TROCenergyBoost;
var config float TROCenergyDuration;
var config float DEFAULTenergyBoost;
var config float DEFAULTenergyDuration;


/*
    3Charges on Epack Test
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


function PreBeginPlay() {

    super.PreBeginPlay();

    saveConfig();    
}

defaultproperties
{
    charges=3
    
    TROCenergyBoost=750000.000000
    TROCenergyDuration=0.100000
    DEFAULTenergyBoost=75000.000000
    DEFAULTenergyDuration=1.000000
    
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