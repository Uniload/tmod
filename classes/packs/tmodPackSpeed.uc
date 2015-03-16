/*
Time Stamp: 01-03-15 14:28:04
*
*   None: The weapon's reload animation will be unaffected until the wearer activates the Speed Pack for the first time.
*   After this, both the passive and the active reload time will be correctly displayed on the HUD.
*
*/

class tmodPackSpeed extends Gameplay.SpeedPack config(tribesmodSettings);

//TEST: Copy some functions from superClass'Gameplay.Pack' in an attempt to make some variables configurable
var config float rechargeTimeSeconds;
var config float rampUpTimeSeconds;
var config float durationSeconds;
var config float deactivatingDuration;

var config float refireRateScale       "How much to scale the refire rate of all weapons when the pack is active";
var config float passiveRefireRateScale "How much to scale the refire rate of all weapons when the pack is worn";
var Material passiveMaterial    "Overlay material, if any, to be used when pack is passive";
var Material activeMaterial     "Overlay material, if any, to be used when pack is active";
var Character user;
var bool bWarned;

var Material currentOverlay;

function PostBeginPlay()
{
    SaveConfig(); 
}

// The pack is regenerating its charge. Indicated through animation and sound.
// Copied from superClass'Gameplay.Pack'
simulated state Recharging
{
    simulated function beginState()
    {
        progressedRechargingTime = 0;
    }

    simulated function tick(float deltaSeconds)
    {
        Global.Tick(deltaSeconds);

        progressedRechargingTime += deltaSeconds;

        rechargingAlpha = progressedRechargingTime / rechargeTimeSeconds;

        if (progressedRechargingTime >= rechargeTimeSeconds)
        {
            rechargingAlpha = 1.0;
            GotoState('Charged');
        }
    }

Begin:

}

// The pack is active and using up its charge. Indicated through animation and sound.
simulated state Activating
{
    simulated function beginState()
    {
        rechargingAlpha = 0;

        progressedActivatingTime = 0;

        startApplyPartialActiveEffect();

        playEffect(activatingEffectStartedName);
        playEffect(activatingEffectName);
    }

    simulated function tick(float deltaSeconds)
    {
        Global.Tick(deltaSeconds);

        // calculate alpha
        alpha = progressedActivatingTime / rampUpTimeSeconds;
        alpha = fclamp(alpha, 0, 1);

        applyPartialActiveEffect(alpha, heldBy);

        progressedActivatingTime += deltaSeconds;
        if (progressedActivatingTime >= rampUpTimeSeconds)
            GotoState('Active');
    }

    simulated function endState()
    {
        stopEffect(activatingEffectName);
    }

Begin:

}

// The pack is active and using up its charge. Indicated through animation and sound.
simulated state Active
{
    simulated function beginState()
    {
        progressedActiveTime = 0;

        startActiveEffect(character(owner));

        playEffect(activeEffectStartedName);
        playEffect(activeEffectName);

        if (Level.NetMode != NM_Client)
            bLocalActive = true;
    }

    simulated function tick(float deltaSeconds)
    {
        Global.Tick(deltaSeconds);

        progressedActiveTime += deltaSeconds;

        // if we have no controller, we're probably driving or manning a turret and shouldn't be allowed to use our pack.
        if (Level.NetMode != NM_Client)
        {
            if (Character(Owner) == None || Character(Owner).Controller == None)
            {
                GotoState('Recharging');
                return;
            }

            if (progressedActiveTime >= durationSeconds)
                GotoState('Recharging');
        }
        else
        {
            if (!bLocalActive)
            {
                GotoState('Recharging');
                return;
            }
        }
    }

    simulated function endState()
    {
        finishActiveEffect();

        stopEffect(activeEffectName);

        // ... deactivation
        deactivating = true;
        deactivatingProgressedTime = 0;

        playEffect(deactivatingEffectName);

        if (Level.NetMode != NM_Client)
            bLocalActive = false;
    }

Begin:

}

simulated function tick(float deltaSeconds)
{
    Super.tick(deltaSeconds);

    // stop deactivating visual effect if necesssary
    if (deactivating)
    {
        deactivatingProgressedTime += deltaSeconds;
        if (deactivatingProgressedTime >= deactivatingDuration)
        {
            stopEffect(deactivatingEffectName);
            deactivating = false;
        }
    }

    // move pack to location of character to ensure relevancy
    if (heldBy != None)
    {
        Move(heldBy.Location - Location);
    }

    if (Level.NetMode == NM_Client)
    {
        if (bLocalActive)
            GotoState('Active');
    }
}

simulated function applyPassiveEffect(Character characterOwner)
{
    user = characterOwner;

    currentOverlay = passiveMaterial;

    scaleRefireRate(passiveRefireRateScale);
}

simulated function removePassiveEffect(Character characterOwner)
{
    resetRefireRate();
}

simulated function startActiveEffect(Character characterOwner)
{
    currentOverlay = activeMaterial;

    scaleRefireRate(refireRateScale);

    user.TriggerEffectEvent('SpeedPackActive',,,,,,,self);
}

simulated function finishActiveEffect()
{
    resetRefireRate();

    applyPassiveEffect(user);

    user.UnTriggerEffectEvent('SpeedPackActive');
}

simulated function scaleRefireRate(float scale)
{
    local Equipment e;
    local Weapon w;

    e = user.equipmentHead();

    // Scale up weapon refire rates
    while (e != None)
    {
        w = Weapon(e);

        if (w != None)
            w.addSpeedPackScale(scale);

        e = e.next;
    }

    if (user.fallbackWeapon == None)
        user.spawnFallbackWeapon();

    if (user.fallbackWeapon != None)
        user.fallbackWeapon.addSpeedPackScale(scale);
}

simulated function resetRefireRate()
{
    local Equipment e;
    local Weapon w;

    e = user.equipmentHead();
    // Reset weapon refire rates
    while (e != None)
    {
        w = Weapon(e);

        if (w != None)
            w.removeSpeedPackScale();

        e = e.next;
    }

    if (user.fallbackWeapon == None)
        user.spawnFallbackWeapon();

    if (user.fallbackWeapon != None)
        user.fallbackWeapon.removeSpeedPackScale();
}

simulated event Material GetOverlayMaterialForOwner(int Index)
{
    return currentOverlay;
}

simulated function OnEffectStarted(Actor inStartedEffect)
{
    local Emitter e;
    local int i;

    e = Emitter(inStartedEffect);

    if (e != None)
    {
        for (i = 0; i < e.Emitters.Length; i++)
        {
            e.Emitters[i].SkeletalMeshActor = user;
        }
    }
    else
        super.OnEffectStarted(inStartedEffect);
}

    // rechargeTimeSeconds=13.000000
    // force the mutator to get the value from the ini file (tribesmodSettings.ini)
    // does not work
    
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