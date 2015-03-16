class statMA extends Gameplay.ExtendedStat;

/**
*   @info   ... Ingame range and "distance".
*
*
*   The ingame range (1 unit) equals to a value of (0,0125)     [ 100 (ingame units) = (distance of) 1,25 ]
*
*
*   "Ma stat" minimum distance (0) = 0 units
*   "Ma stat" maximum distance (11000) = 137,5 units
*
*   (note: Altiude seems to use a different scale than distance)
*/

defaultproperties
{
    minTargetAltitude=400
    minDistance=0
    MaxDistance=11000
    minDamage=44.000000
    stylePointsPerStat=1
    logLevel=3
    Acronym="MA"
    Description="Midair discs"
    awardDescription="Most midair discs"
    personalMessage="You midair disced %1"
    PersonalMessageClass=Class'StatClasses.MPPersonalStatMessageDefault'
}
