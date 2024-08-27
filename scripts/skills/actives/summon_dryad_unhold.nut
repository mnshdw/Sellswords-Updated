this.summon_dryad_unhold <- this.inherit("scripts/skills/skill", {
	m = {
		EntityName = "Woodland Protector",
		Summon = "scripts/entity/tactical/enemies/dryad_unhold",
		Sounds0 = [
			"sounds/enemies/unhold_hurt_01.wav",
			"sounds/enemies/unhold_hurt_02.wav",
			"sounds/enemies/unhold_hurt_03.wav",
			"sounds/enemies/unhold_hurt_04.wav"
		],
		Sounds1 = [
			"sounds/enemies/unhold_death_01.wav",
			"sounds/enemies/unhold_death_02.wav",
			"sounds/enemies/unhold_death_03.wav",
			"sounds/enemies/unhold_death_04.wav",
			"sounds/enemies/unhold_death_05.wav",
			"sounds/enemies/unhold_death_06.wav"
		],
		Sounds2 = [
			"sounds/enemies/unhold_idle_01.wav",
			"sounds/enemies/unhold_idle_02.wav",
			"sounds/enemies/unhold_idle_03.wav",
			"sounds/enemies/unhold_idle_04.wav",
			"sounds/enemies/unhold_idle_05.wav",
			"sounds/enemies/unhold_idle_06.wav",
			"sounds/enemies/unhold_idle_07.wav"
		]
	},

	function create()
	{
		this.m.ID = "actives.summon_dryad_unhold";
		this.m.Name = "Beckon Woodland Protector";
		this.m.Description = "Summons a woodland protector. Needs a free nearby tile to spawn in. Can not be used while engaged in melee.";
		this.m.Icon = "skills/dryad_summon_unhold.png";
		this.m.IconDisabled = "skills/dryad_summon_unhold_sw.png";
		this.m.Overlay = "dryad_summon_unhold";
		this.m.SoundOnUse = [
			"sounds/enemies/unhold_idle_01.wav",
			"sounds/enemies/unhold_idle_02.wav"
		];
		this.m.Type = this.Const.SkillType.Active;
		this.m.Order = this.Const.SkillOrder.Last + 4;
		this.m.IsSerialized = false;
		this.m.IsActive = true;
		this.m.IsTargeted = true;
		this.m.IsStacking = false;
		this.m.IsAttack = false;
		this.m.IsTargetingActor = false;
		this.m.ActionPointCost = 7;
		this.m.FatigueCost = 40;
		this.m.MinRange = 1;
		this.m.MaxRange = 3;
	}

	function addResources()
	{
		this.skill.addResources();

		foreach( r in this.m.Sounds0 )
		{
			this.Tactical.addResource(r);
		}

		foreach( r in this.m.Sounds1 )
		{
			this.Tactical.addResource(r);
		}

		foreach( r in this.m.Sounds2 )
		{
			this.Tactical.addResource(r);
		}
	}

	function getTooltip()
	{
		local ret = this.getDefaultUtilityTooltip();
		local ammo = this.getAmmo();
		
		ret.push({
			id = 6,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Summons a Woodland Protector"
		});
		ret.push({
			id = 7,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Costs 3 Forest Heart charges"
		});
		if (ammo > 0)
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/icons/ammo.png",
				text = "Has [color=" + this.Const.UI.Color.PositiveValue + "]" + ammo + "[/color] charges left"
			});
		}
		else
		{
			ret.push({
				id = 8,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Needs a heart filled with power equipped[/color]"
			});
		}
		if (this.Tactical.isActive() && this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions()))
		{
			ret.push({
				id = 9,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "[color=" + this.Const.UI.Color.NegativeValue + "]Can not be used because this character is engaged in melee[/color]"
			});
		}
		return ret;
	}

	function isUsable()
	{
		return !this.Tactical.isActive() || this.skill.isUsable() && this.getAmmo() > 2 && !this.getContainer().getActor().getTile().hasZoneOfControlOtherThan(this.getContainer().getActor().getAlliedFactions());
	}
	
	function getAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item == null)
		{
			return 0;
		}

		if (item.getAmmoType() == this.Const.Items.AmmoType.Heart)
		{
			return item.getAmmo();
		}
	}
	
	function consumeAmmo()
	{
		local item = this.getContainer().getActor().getItems().getItemAtSlot(this.Const.ItemSlot.Ammo);

		if (item != null)
		{
			item.consumeAmmo();
			item.consumeAmmo();
			item.consumeAmmo();
		}
	}
	
	function onVerifyTarget( _originTile, _targetTile )
	{
		local actor = this.getContainer().getActor();
		return this.skill.onVerifyTarget(_originTile, _targetTile) && _targetTile.IsEmpty;
	}

	function onUse( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		local summon = this.Tactical.spawnEntity(this.m.Summon, _targetTile.Coords.X, _targetTile.Coords.Y);
		this.consumeAmmo();

		summon.setFaction(_user.getFaction() == this.Const.Faction.Player ? this.Const.Faction.PlayerAnimals : this.getContainer().getActor().getFaction());
		summon.setName(this.m.EntityName);
		summon.setMoraleState(this.Const.MoraleState.Confident);
		
		return true;
	}

});

