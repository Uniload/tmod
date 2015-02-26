/*
Time Stamp: 26-02-15 12:07:42
*/

class tmodInv extends Gameplay.InventoryStationAccess;


simulated function bool playerHasFlag() {
    
    local PlayerReplicationInfo PRI;
    local Controller C;
    
    PRI = C.PlayerReplicationInfo;
    
    return PRI.bHasFlag;
}

simulated function clientSetupInventoryStation(Character user)
{
    local int i;
    local InventoryStationWeapon w;
    local InventoryStationPack p;
    local InventoryStationCombatRole newRole;

    currentUser = user;
    if(currentUser != None)
        percentageHealth = FClamp(currentUser.health / currentUser.healthMaximum, 0.0, 1.0);
    else
        percentageHealth = 1.0;

    //================================
    // Auto Fill debug - fill out arrays
    
    /*if(playerHasFlag()) {
        bAutoFillWeapons = false;
        bAutoFillPacks = false;
        bAutoFillCombatRoles = false;
        bAutoConfigGrenades = false;
        bDispenseGrenades = false;
        Prompt = "You cannot use the Inventory Station while carrying a flag.";
    }*/

    if(bAutoFillWeapons || !playerHasFlag())
    {
        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponSpinfusor", class'class'));
        w.bEnabled = true;
        weapons[0] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponChaingun", class'class'));
        w.bEnabled = true;
        weapons[1] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponBlaster", class'class'));
        w.bEnabled = true;
        weapons[2] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponGrenadeLauncher", class'class'));
        w.bEnabled = true;
        weapons[3] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponSniperRifle", class'class'));
        w.bEnabled = true;
        weapons[4] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponMortar", class'class'));
        w.bEnabled = true;
        weapons[5] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponRocketPod", class'class'));
        w.bEnabled = true;
        weapons[6] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponBuckler", class'class'));
        w.bEnabled = true;
        weapons[7] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponBurner", class'class'));
        w.bEnabled = true;
        weapons[8] = w;

        w.weaponClass = class<Weapon>(DynamicLoadObject("EquipmentClasses.WeaponGrappler", class'class'));
        w.bEnabled = true;
        weapons[9] = w;
    }

    if(bAutoFillPacks || !playerHasFlag())
    {
        p.packClass = class<Pack>(DynamicLoadObject("EquipmentClasses.PackSpeed", class'class'));
        p.bEnabled = true;
        packs[0] = p;

        p.packClass = class<Pack>(DynamicLoadObject("tribesmod.tmodPackRepair", class'class'));
        p.bEnabled = true;
        packs[1] = p;

        p.packClass = class<Pack>(DynamicLoadObject("EquipmentClasses.PackEnergy", class'class'));
        p.bEnabled = true;
        packs[2] = p;

        p.packClass = class<Pack>(DynamicLoadObject("EquipmentClasses.PackShield", class'class'));
        p.bEnabled = true;
        packs[3] = p;
    }

    if(bAutoConfigGrenades || !playerHasFlag())
    {
        grenades.grenadeClass = class<HandGrenade>(DynamicLoadObject("tribesmod.tmodWeaponHandGrenade", class'class'));
        grenades.bEnabled = true;
    }
    //================================

    // fill out the roles array with team data
    if((bAutoFillCombatRoles && currentUser != None) || !playerHasFlag())
    {
        for(i = 0; i < currentUser.team().combatRoleData.Length; ++i)
        {
            currentUser.team().combatRoleData[i].role.default.armorClass.default.AllowedWeapons = class<Armor>(DynamicLoadObject("Lords.LordsArmorLight", class'class')).default.AllowedWeapons;
            newRole.combatRoleClass = currentUser.team().combatRoleData[i].role;
            newRole.bEnabled = true;
            roles[i] = newRole;
        }
    }
}

defaultproperties
{
     healRateHealthFractionPerSecond=0.400000
     NumFallbackWeapons=0
     maxWeapons=30
     Prompt="Press '%1' to enter the Inventory Station"
}
