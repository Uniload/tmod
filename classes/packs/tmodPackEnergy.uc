

class tmodPackEnergy extends Gameplay.SpeedPack config(tribesmodSettings);

defaultproperties
{
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