class tmodFlagThrowerBeagle extends GameClasses.FlagThrowerBeagle config(tribesmodSettings);

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
    local tmodFlagThrowerBeagle BEFlag;
    foreach AllActors(class'tmodFlagThrowerBeagle', BEFlag)
    {
        if(BEFlag != None)
        {
            BEFlag.projectileInheritedVelFactor = FlagInheritedVelocity;    //was .8
            BEFlag.projectileVelocity = FlagVelocity;   //was 800
            
            if (useAlternativeTexture)
            {
                BEFlag.Skins[0]=alternateTexture;
                BEFlag.Skins[1]=alternateTexture;
                //log("[tmodFlagThrowerBeagle]: set new flagThrow skin");
            }
        }
    }
}
   
defaultproperties
{
    useAlternativeTexture=true
    alternateTexture=Shader'MPGameObjects.HologramBeagleFalbackShader'
    FlagInheritedVelocity=0.800000
    FlagVelocity=800.000000
}