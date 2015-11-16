Class statSplash extends Gameplay.ExtendedStat;

// Ultimate Long Range stat

/*
    maxDistance == vt + (1/2)at^2
    
    v = Class'spinfusorProperties'.default.ProjectileVelocity;
    a = Class'spinfusorProperties'.default.ProjectileVelocity;
    t = Class'spinfusorProperties'.default.LifeSpan;
*/

//var float minDistance;
var float v;
var float dT;
var float a;

/*
 have this class change its own default properties
*/
function PreBeginPlay() {
    
    v = Class'spinfusorProperties'.default.ProjectileVelocity;
    a = Class'spinfusorProperties'.default.ProjectileVelocity;
    dT = Class'spinfusorProperties'.default.LifeSpan;
    
    Class'statSplash'.default.minDistance = ((v*dT) + ((0.5*a) * (dT * dT)));
}

defaultproperties
{
    minTargetAltitude=400
    minDistance=20000
    MaxDistance=9000000
    minDamage=1.000000
    stylePointsPerStat=3
    logLevel=3
    Acronym="PLASH"
    Description="SPLASH MA"
    awardDescription="Most splash ma's"
    personalMessage="     +   SPLASH   +     "
    PersonalMessageClass=Class'StatClasses.MPPersonalStatMessageDefault'
}
