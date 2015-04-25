class tmodFlagThrowerPhoenix extends GameClasses.FlagThrowerPhoenix config (tribesmodSettings);

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
    local tmodFlagThrowerPhoenix PnxFlag;
    foreach AllActors(class'tmodFlagThrowerPhoenix', PnxFlag)
    {
        if(PnxFlag != None)
        {
            PnxFlag.projectileInheritedVelFactor = FlagInheritedVelocity;//was .8
            PnxFlag.projectileVelocity = FlagVelocity;//was 800
                
            if (class'clientReplication'.default.UseNewFlagTextures)
            {
                PnxFlag.Skins[0]=class'clientReplication'.default.PNXFlagTexture;
                PnxFlag.Skins[1]=class'clientReplication'.default.PNXFlagTexture;
                //log("[tmodFlagThrowerPhoenix]: set new flagThrow skin");
            }
        }
    }
}

defaultproperties
{
    FlagInheritedVelocity=0.800000
    FlagVelocity=800.000000
}