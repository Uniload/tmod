class tmodFlagThrowerBeagle extends GameClasses.FlagThrowerBeagle config(tribesmodSettings);

var config float FlagInheritedVelocity;
var config int FlagVelocity;

function PostBeginPlay() {
    Super.PostBeginPlay();
    SetFlagThrow();
}

function SetFlagThrow() {   
    local tmodFlagThrowerBeagle BEFlag;
    foreach AllActors(class'tmodFlagThrowerBeagle', BEFlag)
        if(BEFlag != None) {
            BEFlag.projectileInheritedVelFactor = FlagInheritedVelocity;    //was .8
            BEFlag.projectileVelocity = FlagVelocity;   //was 800
        }
}

defaultproperties {
    FlagInheritedVelocity=0.800000
    FlagVelocity=800.000000
}