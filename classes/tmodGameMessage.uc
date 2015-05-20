class tmodGameMessage extends Gameplay.TribesGameMessage; //thank you rapher

var localized string MTDisabled;
var localized string MTEnabled;
var localized string BRDisabled;
var localized string BREnabled;
var localized string TKWarnMessage;
var localized string TKKickMessage;
var localized string TKBanMessage;
var localized string SniperEnabled;
var localized string SniperDisabled;
var localized string mutateTest;    // test exec mutate by displaying a message.
var localized string adminMutateTest;   // test admin exec mutate by displaying a message.
var localized string trocOn;
var localized string trocOff;

static function string GetString(optional int Switch,
                 optional Core.Object Related1,
                 optional Core.Object Related2,
                 optional Core.Object OptionalObject,
                 optional String OptionalString) {

    local PlayerReplicationInfo PRI1;

    PRI1 = PlayerReplicationInfo(Related1);
   
    switch (Switch) {
        case 100:
            return default.MTDisabled;
            break;
        case 101:
            return default.MTEnabled;
            break;
        case 103:
            return default.BRDisabled;
            break;
        case 104:
            return default.BREnabled;
            break;
        case 105:
            return default.TKWarnMessage;
            break;
        case 106:
            return replaceStr(default.TKBanMessage, PRI1.PlayerName);
            break;
        case 107:
            return replaceStr(default.TKKickMessage, PRI1.PlayerName);
            break;
        case 108:
            return default.SniperDisabled;
            break;
        case 109:
            return default.SniperEnabled;
            break;
        case 110:
            return default.mutateTest;
            break;
        case 111:
            return default.adminMutateTest;
            break;
        case 112:
            return default.trocOn;
            break;
        case 113:
            return default.trocOff;
            break;
    }
    return super.GetString(Switch, Related1, Related2, OptionalObject, OptionalString);
}

defaultproperties
{
    MTDisabled="Server: Mines and turrets have been disabled."
    MTEnabled="Server: Mines and turrets have been enabled."
    BRDisabled="Server: Base rape has been disabled."
    BREnabled="Server: Base rape has been enabled."
    TKWarnMessage="Server: Warning! You are about to be removed for team killing!"
    TKKickMessage="Server: %1 was kicked for team killing."
    TKBanMessage="Server: %1 was banned for team killing."
    SniperEnabled="Server: The Sniper Rifle will be disabled untill more players join the game."
    SniperDisabled="Server: The Sniper Rifle has been enabled."
    mutateTest="Client: Hello Tribes Vengeance."
    adminMutateTest="Admin: Hello Tribes Vengeance."
    trocOn="Server: Troc has been enabled."
    trocOff="Server: Troc has been disabled."
}