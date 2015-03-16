//NEW WEAPON POINTER

class tmodWeaponPointer extends Gameplay.Weapon config(tribesmodSettings);

function simulated useAmmo()
{
    //Character(rookOwner).weaponUseEnergy(Character(rookOwner).energy);
    Character(rookOwner).weaponUseEnergy(0);
    Super.useAmmo();
}

protected simulated function Projectile makeProjectile(Rotator fireRot, Vector fireLoc)
{
    //local SniperRifleProjectile p;
    //local SniperRifleBeam b;
    
    local tmodProjectilePointer p;
    local tmodPointerBeam b;

    //p = SniperRifleProjectile(Super.makeProjectile(fireRot, fireLoc));
    p = tmodProjectilePointer(Super.makeProjectile(fireRot, fireLoc));

    if (p != None)
        b = new class'tmodPointerBeam'(p);

    return p;
}

simulated function Tick(float Delta)
{
    local Character characterOwner;

    Super.Tick(Delta);

    characterOwner = Character(rookOwner);

    if (bIsFirstPerson)
    {
        if (!IsAnimating())
            PlayAnim(Name(animPrefix $ "_Close"),,, 1);

        //AnimBlendParams(1, characterOwner.energy / characterOwner.energyMaximum);
        AnimBlendParams(1, 1);
            
        PlayAnim(Name(animPrefix $ "_Open"),,, 1);
    }
}

/**
DEFAULT VALUES:

animClass=Class'CharacterEquippableAnimator'
thirdPersonStaticMesh=StaticMesh'weapons.HeavyChaingunHeld'
StaticMesh=StaticMesh'weapons.HeavyChaingunHeld'
animClass=None
*/

defaultproperties
{
     ammoCount=1
     ammoUsage=0
     roundsPerSecond=125.000000
     projectileClass=Class'tmodProjectilePointer'
     projectileVelocity=400000.000000
     projectileInheritedVelFactor=0.000000
     aimClass=Class'AimProjectileWeapons'
     firstPersonMesh=SkeletalMesh'weapons.SniperRifle'
     firstPersonOffset=(X=-25.000000,Y=26.000000,Z=-18.000000)
     animPrefix="SniperRifle"
     localizedName="Pointer Beam"
     infoString="Long-range beam used to point out things"
     bCanDrop=false
}