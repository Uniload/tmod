class tmodFlagThrowerPhoenix extends GameClasses.FlagThrowerPhoenix config (tribesmodSettings);

var config float FlagInheritedVelocity;
var config int FlagVelocity;

function PostBeginPlay()
{
    Super.PostBeginPlay();
        SetFlagThrow();
}

function SetFlagThrow()

{
        local tmodFlagThrowerPhoenix PnxFlag;
        foreach AllActors(class'tmodFlagThrowerPhoenix', PnxFlag)
            if(PnxFlag != None) {
                PnxFlag.projectileInheritedVelFactor = FlagInheritedVelocity;//was .8
                PnxFlag.projectileVelocity = FlagVelocity;//was 800
            }
}

defaultproperties
{
FlagInheritedVelocity=0.800000
FlagVelocity=800.000000
}