/*
Time Stamp: 01-03-15 14:28:04
*
*   None: The weapon's reload animation will be unaffected until the wearer activates the Speed Pack for the first time.
*   After this, both the passive and the active reload time will be correctly displayed on the HUD.
*
*/

class tmodPackEnergy extends Gameplay.EnergyPack config(tribesmodSettings);

var Material passiveMaterial    "Overlay material, if any, to be used when pack is passive";
var Material activeMaterial     "Overlay material, if any, to be used when pack is active";


var Material currentOverlay;

function PostBeginPlay()
{
    SaveConfig(); 
}

// The pack is active and using up its charge. Indicated through animation and sound.
simulated state Activating
{
	simulated function tick(float deltaSeconds)
	{
		local vector facing;
		local float AppliedImpulsePerSecond;

		Super.tick(deltaSeconds);

		// calculate facing
		if (heldBy != None && heldBy.movementObject != None)
		{
			facing = vect(1,0,0);
			facing = facing >> heldBy.motor.getViewRotation();

			// tune the boost to act on a mass of 100 regardless
			AppliedImpulsePerSecond = (boostImpulsePerSecond * heldBy.unifiedGetMass()) / 100;

			// apply boost
			heldBy.movementObject.addImpulse(facing * AppliedImpulsePerSecond * deltaSeconds);
		}
	}
}

// The pack is active and using up its charge. Indicated through animation and sound.
simulated state Active
{
	simulated function tick(float deltaSeconds)
	{
		local vector facing;
		local float AppliedImpulsePerSecond;

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
	}
}

simulated function applyPassiveEffect(Character characterOwner)
{
    user = characterOwner;
    currentOverlay = passiveMaterial;
	
	originalEnergyRechargeScale = characterOwner.energyRechargeScale;
	characterOwner.energyRechargeScale = rechargeScale;
}

simulated function removePassiveEffect(Character characterOwner)
{
    characterOwner.energyRechargeScale = originalEnergyRechargeScale;
}

simulated function startActiveEffect(Character characterOwner)
{
    currentOverlay = activeMaterial;
}


simulated event Material GetOverlayMaterialForOwner(int Index)
{
    return currentOverlay;
}
    
defaultproperties
{
    refireRateScale=2.000000
    passiveRefireRateScale=1.250000
    activeMaterial=Shader'FX.BucklerShieldShadder'
    rechargeTimeSeconds=13.000000
    rampUpTimeSeconds=0.250000
    deactivatingDuration=0.250000
    durationSeconds=5.000000
    thirdPersonMesh=StaticMesh'packs.EnergyPack'
    localizedName="ENERGY PACK"
    inventoryIcon=Texture'GUITribes.InvButtonEnergy'
    hudIcon=Texture'HUD.Tabs'
    hudIconCoords=(U=410.000000,V=165.000000)
    hudRefireIcon=Texture'HUD.Tabs'
    hudRefireIconCoords=(U=410.000000,V=114.000000)
    cannnotBeUsedWhileTouchingInventoryStation=True
    StaticMesh=StaticMesh'packs.EnergyPackdropped'
}