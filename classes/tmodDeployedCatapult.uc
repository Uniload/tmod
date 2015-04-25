class tmodDeployedCatapult extends Gameplay.DeployedCatapult config(tribesmodSettings);

//Health=400
defaultproperties
{
Health=400
damagedHealthThreshold=0.750000
functionalHealthThreshold=0.050000
CollisionHeight=8.000000
CollisionRadius=34.000000
actorInfluence=0.500000
catapultInfluence=0.500000
throwForce=125000.000000
verticalInfluence=0.500000

localizedName="Deployed Catapult"
bWasDeployed=true
bNoDelete=false
bIgnoreEncroachers=true
bIsDetectableByEnemies=true
bCanBeSensed=true
bDirectional=False
bIgnoreActorVelocity=False
bReflective=False
Mesh=SkeletalMesh'Deployables.DepCatapult'
destroyedExplosionClass=Class'ExplosionClasses.ExplosionSmall'
radarinfoClass=Class'HudClasses.RadarInfoDeployableCatapult'
personalShieldClass=None
}