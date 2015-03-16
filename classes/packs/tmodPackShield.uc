/*
Time Stamp: 01-03-15 12:52:15
*/

class tmodPackShield extends Gameplay.ShieldPack config(tribesmodSettings);
    

var config float shieldReload;
var config float RUPSeconds;
var config float shieldDuration;
var config float stopDuration;


var config float passiveFractionDamageBlocked;
var config float activeFractionDamageBlocked;
var Material passiveIdleMaterial   "Overlay material, if any, to be used when shield is active but has not been impacted";
var Material activeIdleMaterial    "Overlay material, if any, to be used when shield is active but has not been impacted";
var Material passiveHitMaterial    "Overlay material to be used when shield has been impacted";
var Material activeHitMaterial     "Overlay material to be used when shield has been impacted";
var config float hitStayTime              "Length of time that the hit material is displayed for on damage";

var Material currentIdle;
var Material currentHit;
var float currentHitTime;
var float lastHealth;

var Sound shieldCharged; 
var sound shieldActive;

event PostBeginPlay() {
    
    setShieldTimeValues();   
    SaveConfig();
}

function setShieldTimeValues() {
    
    local tmodPackShield tShieldPack;
    
    foreach AllActors(class'tmodPackShield', tShieldPack) {
        tShieldPack.rechargeTimeSeconds = shieldReload;
        tShieldPack.durationSeconds = shieldDuration;
        tShieldPack.rampUpTimeSeconds = RUPSeconds;
        tShieldPack.deactivatingDuration = stopDuration;
    }
}

simulated function applyPassiveEffect(Character characterOwner)
{
    currentIdle = passiveIdleMaterial;
    currentHit = passiveHitMaterial;
    characterOwner.shieldActive = true;
    characterOwner.shieldFractionDamageBlocked = passiveFractionDamageBlocked;
}

simulated function removePassiveEffect(Character characterOwner)
{
    characterOwner.shieldActive = false;
}

simulated function startActiveEffect(Character characterOwner)
{
    currentIdle = activeIdleMaterial;
    currentHit = activeHitMaterial;
    lastHealth = characterOwner.health;
    characterOwner.shieldFractionDamageBlocked = activeFractionDamageBlocked;
}

simulated function finishActiveEffect()
{
    if (heldBy != None)
        heldBy.shieldFractionDamageBlocked = passiveFractionDamageBlocked;
    currentIdle = passiveIdleMaterial;
    currentHit = passiveHitMaterial;
}

simulated event Material GetOverlayMaterialForOwner(int Index)
{
    if (currentHitTime <= 0) {
        return currentIdle;
        } else {
        return currentHit;
    }
}

simulated function tick(float deltaSeconds)
{
    super.tick(deltaSeconds);

    if (currentHitTime > 0)
        currentHitTime -= deltaSeconds;

    if (localHeldBy != None)
    {
        if (lastHealth != localHeldBy.health)
        {
            if (lastHealth > localHeldBy.health)
            {
                currentHitTime = hitStayTime;
            }

            lastHealth = localHeldBy.health;
        }
    }
}

// The pack is fully charged and ready to be activated.
simulated state Charged
{
    simulated function BeginState()
    {
        if (heldBy != None && heldBy.Controller == Level.GetLocalPlayerController())
        {
            heldBy.TriggerEffectEvent(Name(Class.Name$chargedEffectName));
            //sound hack
            #if IG_EFFECTS
                    heldBy.PlaySound(shieldCharged,255,,30,200,,,,false,,);
                LOG("played sound1");
            #else
                heldBy.PlaySound(shieldCharged,SLOT_None,255,,156,,false,,);
                LOG("played sound2");
            #endif 
        }

        rechargingAlpha = 1.0;
    }

//maybe can delete stuff below here, and let the super handle it

    simulated function activate()
    {
        // if we have no controller, we're probably driving or manning a turret and shouldn't be allowed to use our pack.
        if (Character(Owner) == None || Character(Owner).Controller == None)
            return;

        // some packs cannot be used while touching an inventory station - handle that here
        if (Level.NetMode != NM_Client && cannnotBeUsedWhileTouchingInventoryStation && isInRangeOfInventoryStation())
            return;

        GotoState('Activating');

        // inform clients
        if (Level.NetMode != NM_Client && !IsInState('Active'))
            packActivatedTrigger = !packActivatedTrigger;
    }


Begin:

}

/**
@INFO:

following variables modify the HUD reload animation (will only change if recompiled)

    rechargeTimeSeconds=10.000000
    durationSeconds=10.000000
    rampUpTimeSeconds=0.250000
    deactivatingDuration=0.250000
    
Following variables change the actual timers ingame (does not affect HUD animation, unfortunately)

    shieldReload=12.000000
    RUPSeconds=0.250000
    shieldDuration=2.000000
    stopDuration=0.250000

*
*   Changed the (activeIdle)Materials to: Shader'FX.ScreenFindmeShader'
*
*   Time Stamp: 01-03-15 14:03:30
*/
defaultproperties
{
    passiveFractionDamageBlocked=0.200000
    activeFractionDamageBlocked=0.750000
    hitStayTime=0.500000
    
    rechargeTimeSeconds=12.000000
    durationSeconds=2.000000
    rampUpTimeSeconds=0.250000
    deactivatingDuration=0.250000
    
    shieldReload=12.000000
    RUPSeconds=0.250000
    shieldDuration=2.000000
    stopDuration=0.250000
    
    activeIdleMaterial=Shader'FX.ScreenFindmeShader'
    passiveHitMaterial=Shader'FX.ScreenFindmeShader'
    activeHitMaterial=Shader'FX.ScreenFindmeShader'    
    shieldCharged=Sound'TV_packs.pack_charged1'
    shieldActive=Sound'TV_packs.shieldpack_loop1'
    thirdPersonMesh=StaticMesh'packs.ShieldPack'
    localizedName="SHIELD PACK"
    StaticMesh=StaticMesh'packs.ShieldPackDropped'
    infoString="Passive effect slightly reduces damage to the user.  Active effect greatly reduces damage."
    inventoryIcon=Texture'GUITribes.InvButtonShield'
    hudIcon=Texture'HUD.Tabs'
    hudIconCoords=(U=205.000000,V=165.000000)
    hudRefireIcon=Texture'HUD.Tabs'
    hudRefireIconCoords=(U=205.000000,V=165.000000)
}