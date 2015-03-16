class tmodFlagThrowerPhoenix extends GameClasses.FlagThrowerPhoenix config (tribesmodSettings);

var config float FlagInheritedVelocity;
var config int FlagVelocity;
var config Material alternateTexture;
var config bool useAlternativeTexture;



simulated function PostBeginPlay()
{
    Super.PostBeginPlay();
    SetFlagThrow();
    SaveConfig();
}

simulated function SetFlagThrow()
{
    local tmodFlagThrowerPhoenix PnxFlag;
    foreach AllActors(class'tmodFlagThrowerPhoenix', PnxFlag)
    {
        if(PnxFlag != None)
        {
            PnxFlag.projectileInheritedVelFactor = FlagInheritedVelocity;//was .8
            PnxFlag.projectileVelocity = FlagVelocity;//was 800
                
            if (useAlternativeTexture)
            {
                PnxFlag.Skins[0]=alternateTexture;
                PnxFlag.Skins[1]=alternateTexture;
                //log("[tmodFlagThrowerPhoenix]: set new flagThrow skin");
            }
        }
    }
}

defaultproperties
{
    useAlternativeTexture=true 
    alternateTexture=Shader'MPGameObjects.HologramPhoenixFalbackShader'
    FlagInheritedVelocity=0.800000
    FlagVelocity=800.000000
}