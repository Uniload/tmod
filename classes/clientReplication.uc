class clientReplication extends Engine.LevelInfo config(tribesmodSettings);
/*
*   Time Stamp: 15-04-15 19:05:37
*/

/*
*   This class is spawned on every client's machine (as well as on the server) and is SUPPOSED to force the modifications made in the server's tribesmodSettings.ini file to be applied onto the client"s tribesmod package.
*   I have not yet managed to make variable replication work, so for now, this class only allows the client to change their own flag's texture.
*/


var config bool UseNewFlagTextures;
var config Material BEFlagTexture;
var config Material PNXFlagTexture;
var config Material IMPFlagTexture;


simulated event PostBeginPlay()
{
    super.PostBeginPlay();
    
    log("Tribesmod :: SPAWNING NEW CLIENTREPLICATION CLASS");

    InitializeFlagtexture();
    InitializeGrenadeLauncher();
    InitializeMortar();
    if(!class'tmodProjectilePlasma'.default.useDefaultBurner){InitializePlasmaGun();}
    ClientSaveProperties();
}

simulated function ClientSaveProperties() {
/*
*   This will create a tribesmodSettings.ini file in the client's AND server's Program/Bin directory with the variables and values of this class. 
*   The mod will also read the values of the variables from the tribesmodSettings.ini file rather than the ones defined in defaultproperties.
*/
    SaveConfig();
}

simulated function InitializeFlagtexture() {
/*
*   Change the client's default flag textures by ovewriting the default material in TV"s GameClasses package
*/
    if (UseNewFlagTextures)
    {
        /*
        * Due to the very nature of config variables, clients can modify the values of their own tribesmod package. In this case, clients can decide what new texture they want the flags to have,
        * regardless of the settings set on the server. Although this is a rather good thing for the clients to change their own flag textures,
        * it can cause some issues with the other config variables such as projectile velocities or firerates. Client"s can luckily not cheat by changing the mod's variables, the server will always have the final say,
        * but this will often lead to the client incorrectly rendering what is happening in the game world (client rendering the projectiles at incorrect speeds, glitches, bugs etc...).
        * To prevent synchronization issues, we would have to find a way to sync the server's variables with the client. UnrealScript"s Variable replication could possibly provide an answer to this.
        */
        class'GameClasses.CaptureFlagImperial'.default.Skins[0] = IMPFlagTexture;
        class'GameClasses.CaptureFlagImperial'.default.Skins[1] = IMPFlagTexture;
        class'GameClasses.CaptureFlagBeagle'.default.Skins[0] = BEFlagTexture;
        class'GameClasses.CaptureFlagBeagle'.default.Skins[1] = BEFlagTexture;
        class'GameClasses.CaptureFlagPhoenix'.default.Skins[0] = PNXFlagTexture;
        class'GameClasses.CaptureFlagPhoenix'.default.Skins[1] = PNXFlagTexture;
        log("Tribesmod.clientReplication :: Flag Textures replicated");
    }
}


simulated function InitializeGrenadeLauncher()
{ 
    class'tmodProjectileGrenadeLauncher'.default.radiusDamageAmt = class'tmodProjectileGrenadeLauncher'.default.damage;
    class'tmodProjectileGrenadeLauncher'.default.radiusDamageMomentum = class'tmodProjectileGrenadeLauncher'.default.knockback;
    class'tmodProjectileGrenadeLauncher'.default.radiusDamageSize = class'tmodProjectileGrenadeLauncher'.default.damageAOE;
    class'tmodProjectileGrenadeLauncher'.default.FuseTimer = class'tmodProjectileGrenadeLauncher'.default.projFuseTimer;
    class'tmodProjectileGrenadeLauncher'.default.LifeSpan = class'tmodProjectileGrenadeLauncher'.default.projLifeSpan;
    class'tmodProjectileGrenadeLauncher'.default.GravityScale = class'tmodProjectileGrenadeLauncher'.default.projGravityScale;
    class'tmodProjectileGrenadeLauncher'.default.Mass = class'tmodProjectileGrenadeLauncher'.default.projMass; 
    log("Tribesmod.clientReplication :: GrenadeLauncher properties replicated");  
}

simulated function InitializeMortar()
{   
    class'tmodProjectileMortar'.default.radiusDamageAmt = class'tmodProjectileMortar'.default.damage;
    class'tmodProjectileMortar'.default.radiusDamageMomentum = class'tmodProjectileMortar'.default.knockback;
    class'tmodProjectileMortar'.default.radiusDamageSize = class'tmodProjectileMortar'.default.damageAOE;
    class'tmodProjectileMortar'.default.FuseTimer = class'tmodProjectileMortar'.default.projFuseTimer;
    class'tmodProjectileMortar'.default.LifeSpan = class'tmodProjectileMortar'.default.projLifeSpan;
    class'tmodProjectileMortar'.default.GravityScale = class'tmodProjectileMortar'.default.projGravityScale;
    class'tmodProjectileMortar'.default.Mass = class'tmodProjectileMortar'.default.projMass;
    log("Tribesmod.clientReplication :: Mortar properties replicated");
}

simulated function InitializePlasmaGun()
{    
    class'tmodProjectilePlasma'.default.damageAmt = class'tmodProjectilePlasma'.default.damage;
    class'tmodProjectilePlasma'.default.radiusDamageSize = class'tmodProjectilePlasma'.default.damageAoe;
    class'tmodProjectilePlasma'.default.knockbackAliveScale = class'tmodProjectilePlasma'.default.knockback;
    class'tmodProjectilePlasma'.default.bDeflectable = class'tmodProjectilePlasma'.default.canBeDeflected;
    class'tmodProjectilePlasma'.default.LifeSpan = class'tmodProjectilePlasma'.default.PlasmaLifeSpan;    
    class'tmodProjectilePlasma'.default.ignitionDelay = class'tmodProjectilePlasma'.default.PlasmaLifeSpan;
    log("Tribesmod.clientReplication :: PlasmaGun properties replicated");
}

simulated function InitializeChainGun()
{
    class'tmodProjectileChaingun'.default.damageAmt = class'tmodProjectileChaingun'.default.damage;
    class'tmodProjectileChaingun'.default.LifeSpan = class'tmodProjectileChaingun'.default.projLifeSpan;
}

// TODO ************************ BLASTER REPLICATION ************************

simulated event Destroyed()
{
    log("******************* DESTROYED CLIENTREPLICATION CLASS *******************");
}

defaultproperties
{
    UseNewFlagTextures = true
    BEFlagTexture=Shader'MPGameObjects.HologramBeagleFalbackShader'
    PNXFlagTexture=Shader'MPGameObjects.HologramPhoenixFalbackShader'
    IMPFlagTexture=Shader'MPGameObjects.HologramImperialFalbackShader'
    
    RemoteRole = ROLE_SimulatedProxy
    bStatic = false
    bNoDelete = false
    bNetNotify = true
}