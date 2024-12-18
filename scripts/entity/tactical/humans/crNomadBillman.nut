this.crNomadBillman <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.crNomadBillman;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.Billman.XP;
		this.human.create();
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.Billman);
		b.IsSpecializedInSwords = true;
		b.IsSpecializedInAxes = true;
		b.IsSpecializedInMaces = true;
		b.IsSpecializedInFlails = true;
		b.IsSpecializedInPolearms = true;
		b.IsSpecializedInThrowing = true;
		b.IsSpecializedInHammers = true;
		b.IsSpecializedInSpears = true;
		b.IsSpecializedInCleavers = true;
		this.m.ActionPoints = b.ActionPoints;
		this.m.Hitpoints = b.Hitpoints;
		this.m.CurrentProperties = clone b;
		this.setAppearance();
		this.getSprite("socket").setBrush("bust_base_military");
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_reach_advantage"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_rotation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_recover"));						
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_assured_conquest"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_pathfinder"));		
		this.m.Skills.add(this.new("scripts/skills/actives/throw_dirt_skill"));

		if (::Is_PTR_Exist)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_follow_up"));
		}

		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
		{
			this.m.Skills.add(this.new("scripts/skills/effects/dodge_effect"));				
			this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_back_to_basics"));
			this.m.Skills.add(this.new("scripts/skills/traits/fearless_trait"));										
			this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_clarity"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_smackdown"));				
			this.m.Skills.add(this.new("scripts/skills/perks/perk_anticipation"));

			if (::Is_PTR_Exist)
			{
				this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_pattern_recognition"));
			}		
		}

		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getEconomicDifficulty() == this.Const.Difficulty.Legendary)
		{
			local dc = this.World.getTime().Days;
			local dca = this.Math.floor(dc/50) + this.Math.floor(dc/100) + this.Math.floor(dc/150) + this.Math.floor(dc/200);
			dca = this.Math.min(dca, 8 + this.Math.floor(dc/100));				
			this.m.BaseProperties.MeleeSkill += dca;
			this.m.BaseProperties.MeleeDefense += 0.5 * dca;
			this.m.BaseProperties.RangedSkill += dca;	
			this.m.BaseProperties.RangedDefense += 0.5 * dca;				
			this.m.BaseProperties.Bravery += dca;
			this.m.BaseProperties.Hitpoints += 2 * dca;	
		}

		this.m.BaseProperties.Initiative += 5;		
	}

	function assignRandomEquipment()
	{
		local dc = this.World.getTime().Days;			

		local weapons = [
			"weapons/oriental/polemace",
			"weapons/oriental/polemace",			
			"weapons/oriental/swordlance",			
			"weapons/legend_ranged_flail"			
		];

		this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));	
		
		this.m.Items.equip(this.Const.World.Common.pickArmor([
			[1, "crnomad_armor_early_ichi"],   //95,-11  55,-4
			[1, "crnomad_armor_early_cloth"],   //90,-8 60,-3					
			[1, "crnomad_armor_early_ni"],  	//80,-6			
			[1, "crnomad_armor_mid_ni"],  	 //110,-8
			[1, "crnomad_armor_mid_sann"],  	 //105,-11								
		]));
		this.m.Items.equip(this.Const.World.Common.pickHelmet([		
			[1, "oriental/leather_head_wrap"], 
			[1, "cr_cutthroat_helmet"],  		//50
			[1, "citrene_nomad_cutthroat_helmet_01"], 					
			[1, "oriental/nomad_light_helmet"],  	 					 					  	  									
		]));
		
		if (::Is_PTR_Exist)
		{
			if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
			{
				//this.m.Skills.addTreeOfEquippedWeapon(7);
				::Mod_Sellswords.HookHelper.addTreeOfEquippedWeapon(this);
			}
			else
			{
		  		::Mod_Sellswords.HookHelper.addTreeOfEquippedWeapon(this, 5);
			}
			//this.m.Skills.addTreeOfEquippedWeapon(5);		
			this.m.Skills.removeByID("perk.ptr_bloodlust");
			this.m.Skills.removeByID("perk.ptr_dent_armor");	
		}
	}

});

