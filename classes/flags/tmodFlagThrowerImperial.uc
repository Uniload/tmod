class tmodFlagThrowerImperial extends GameClasses.FlagThrowerImperial config (tribesmodSettings);

var config float FlagInheritedVelocity;
var config int FlagVelocity;

function PostBeginPlay()
{
    Super.PostBeginPlay();
        SetFlagThrow();
}

function SetFlagThrow()

{
        local tmodFlagThrowerImperial ImpFlag;
        foreach AllActors(class'tmodFlagThrowerImperial', ImpFlag)
            if(ImpFlag != None) {
                ImpFlag.projectileInheritedVelFactor = FlagInheritedVelocity;//was .8
                ImpFlag.projectileVelocity = FlagVelocity;//was 800
            }
}

defaultproperties
{
FlagInheritedVelocity=0.800000
FlagVelocity=800.000000
}