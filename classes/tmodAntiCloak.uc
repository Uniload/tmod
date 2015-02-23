class tmodanticloak extends Gameplay.Cloakpack;

simulated function applyPartialActiveEffect(float alpha, Character characterOwner)
{
        characterOwner.bHidden = false;
}

defaultproperties
{
}
