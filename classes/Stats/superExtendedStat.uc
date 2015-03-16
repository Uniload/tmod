class superExtendedStat extends Gameplay.Stat;

var()   int     minTargetAltitude;
var()   float   minTargetSpeed;
var()   float   maxTargetSpeed;
var()   int     minDistance;
var()   int     maxDistance;
var()   float   minDamage;
var()   bool    bAllowTargetInVehicleOrTurret;


static function bool isEligible(Controller Source, Controller Target, float damageAmount)
{
    local vector hitLocation, hitNormal, startTrace, endTrace;
    local int relativeDistance;
    local Character targetCharacter;
    local PlayerCharacterController pcc;
    local int range;
    
    if (Target == None || Source == None)
        return false;

    // Damage check, but only if target is alive
    if (Target.Pawn.IsAlive() && damageAmount < default.minDamage)
        return false;

    // Vehicle/turret check
    pcc = PlayerCharacterController(Target);
    if (!default.bAllowTargetInVehicleOrTurret && pcc != None && !pcc.IsInState('CharacterMovement'))
        return false;

    // Minimum distance check
    relativeDistance = VSize(Source.Pawn.Location - Target.Pawn.Location);
    
    //===============================MODIFIED CODE==================================
    range = (relativeDistance / 100) * 1.25;
    ///self.personalMessage="Range:" & range;
    
    if (relativeDistance < default.minDistance)
        return false;

    // Maximum distance check
    if (default.maxDistance != 0 && relativeDistance >= default.maxDistance)
        return false;

    // Minimum target altitude check
    startTrace = Target.Pawn.Location;
    endTrace = Target.Pawn.Location;
    endTrace.z -= default.minTargetAltitude;
    if (Target.Trace(hitLocation, hitNormal, endTrace, startTrace) != None)
        return false;

    // Minimum target speed check
    targetCharacter = Character(Target.Pawn);
    if (targetCharacter.movementSpeed < default.minTargetSpeed)
        return false;

    // Maximum target speed check
    if (default.maxTargetSpeed != 0 && targetCharacter.movementSpeed >= default.maxTargetSpeed)
        return false;

    // If this point is reached, all tests passed and the stat is awarded
    return true;
}

defaultproperties
{
    personalMessage="superExtendedStat message"
}