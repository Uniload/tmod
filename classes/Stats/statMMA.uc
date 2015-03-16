Class statMMA extends Gameplay.ExtendedStat;

// Mortar MA stat

/**
*   NOTE: minDamage takes ShieldPack.passiveFractionDamageBlocked(0.2) into account
*
*   The stat will not trigger when the target activates shield pack, unless the target gets killed by the mortar. (mindamage would have to be 29 with ShieldPack.activeFractionDamageBlocked(0.75)...)
*
*/

defaultproperties
{
    minTargetAltitude=400
    minDamage=95.000000
    stylePointsPerStat=4
    logLevel=3
    Acronym="MMA"
    Description="Mortar midair"
    awardDescription="Most mortar midairs"
    personalMessage="You mortar midaired %1"
    PersonalMessageClass=Class'StatClasses.MPPersonalStatMessageDefault'
}
