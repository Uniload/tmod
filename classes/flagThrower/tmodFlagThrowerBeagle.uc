class tmodFlagThrowerBeagle extends GameClasses.FlagThrowerBeagle config(tribesmodSettings);

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
    local tmodFlagThrowerBeagle BEFlag;
    foreach AllActors(class'tmodFlagThrowerBeagle', BEFlag)
    {
        if(BEFlag != None)
        {
            BEFlag.projectileInheritedVelFactor = FlagInheritedVelocity;    //was .8
            BEFlag.projectileVelocity = FlagVelocity;   //was 800
            
            if (class'clientReplication'.default.UseNewFlagTextures)
            {
                BEFlag.Skins[0]=class'clientReplication'.default.BEFlagTexture;
                BEFlag.Skins[1]=class'clientReplication'.default.BEFlagTexture;
                //log("[tmodFlagThrowerBeagle]: set new flagThrow skin");
            }
        }
    }
}
   
defaultproperties
{
    FlagInheritedVelocity=0.800000
    FlagVelocity=800.000000
}