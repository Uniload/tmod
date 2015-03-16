class tmodFlagThrowerImperial extends GameClasses.FlagThrowerImperial config (tribesmodSettings);

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
    local tmodFlagThrowerImperial ImpFlag;
    foreach AllActors(class'tmodFlagThrowerImperial', ImpFlag)
    {
        if(ImpFlag != None)
        {
            ImpFlag.projectileInheritedVelFactor = FlagInheritedVelocity;       //Default was = 0.8
            ImpFlag.projectileVelocity = FlagVelocity;                          //Default was = 800
                
            if (useAlternativeTexture)
            {
                ImpFlag.Skins[0]=alternateTexture;
                ImpFlag.Skins[1]=alternateTexture;
                //log("[tmodFlagThrowerImperial]: set new flagThrow skin");
            }
        }
    }
}

defaultproperties
{
    useAlternativeTexture=true   
    alternateTexture=Shader'MPGameObjects.HologramImperialFalbackShader'
    FlagInheritedVelocity=0.800000
    FlagVelocity=800.000000
}