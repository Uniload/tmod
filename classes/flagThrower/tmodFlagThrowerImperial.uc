class tmodFlagThrowerImperial extends GameClasses.FlagThrowerImperial config (tribesmodSettings);

var config float FlagInheritedVelocity;
var config int FlagVelocity;


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
                
            if (class'clientReplication'.default.UseNewFlagTextures)
            {
                ImpFlag.Skins[0]=class'clientReplication'.default.IMPFlagTexture;
                ImpFlag.Skins[1]=class'clientReplication'.default.IMPFlagTexture;
                //log("[tmodFlagThrowerImperial]: set new flagThrow skin");
            }
        }
    }
}

defaultproperties
{
    FlagInheritedVelocity=0.800000
    FlagVelocity=800.000000
}