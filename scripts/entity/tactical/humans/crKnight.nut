this.crKnight <- this.inherit("scripts/entity/tactical/human", {
	m = {},
	function create()
	{
		this.m.Type = this.Const.EntityType.crKnight;
		this.m.BloodType = this.Const.BloodType.Red;
		this.m.XP = this.Const.Tactical.Actor.crKnight.XP;
		this.m.Name = this.generateName();
		this.m.IsGeneratingKillName = false;
		this.human.create();
		this.m.Faces = this.Const.Faces.SmartMale;
		this.m.Hairs = this.Const.Hair.CommonMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/military_melee_agent");
		this.m.AIAgent.setActor(this);
	}

	function generateName()
	{
		return this.Const.Strings.KnightNames[this.Math.rand(0, this.Const.Strings.KnightNames.len() - 1)];
	}

	function onInit()
	{
		this.human.onInit();
		local b = this.m.BaseProperties;
		b.setValues(this.Const.Tactical.Actor.crKnight);
		b.TargetAttractionMult = 1.0;
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
		this.m.Skills.add(this.new("scripts/skills/perks/perk_shield_expert"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_armor_mastery_heavy"));			
		this.m.Skills.add(this.new("scripts/skills/perks/perk_brawny"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_captain"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_fast_adaption"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crippling_strikes"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_coup_de_grace"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_battle_forged"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_berserk"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_underdog"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_rotation"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_recover"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_duelist"));		
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_second_wind"));				
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_smackdown"));	
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_specialist_shield_skill"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_specialist_shield_push"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_shield_bash"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_return_favor"));	
		this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_full_force"));
		this.m.Skills.add(this.new("scripts/skills/perks/perk_crresilient"));

		if (::Is_PTR_Exist)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_vigilant"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_str_phalanx"));	
			this.m.Skills.add(this.new("scripts/skills/perks/perk_str_line_breaker"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_pattern_recognition"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_the_rush_of_battle"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_bulwark"));
		}

		local dc = this.World.getTime().Days;			
		local blk = this.Math.rand(1, 100);
		if (dc > 180 && blk >= 85)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_crBlockmaster"));
		}
		else if(dc > 150 && blk >= 70)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_crBlockskilled"));
		}
		else if(dc > 120 && blk >= 55)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_crBlocknormal"));
		}
		local dc = this.World.getTime().Days;
		local mn = this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon");	
		dc = this.Math.max(dc, mn * 3);			
		if (dc >= 80)
		{
			this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_true_believer"));								
			this.m.BaseProperties.Stamina += 5;
			if (dc >= 120)
			{
				this.m.Skills.add(this.new("scripts/skills/perks/perk_crFoB"));	
				this.m.Skills.add(this.new("scripts/skills/perks/perk_crHonorheritage"));				
				this.m.BaseProperties.Stamina += 5;	
				if (dc >= 150)
				{							
					this.m.BaseProperties.MeleeSkill += 2;			
					this.m.BaseProperties.MeleeDefense += 2;			
					this.m.BaseProperties.RangedDefense += 2;
					this.m.Skills.removeByID("perk.return_favor");						
					local returnFavor = this.new("scripts/skills/effects/return_favor_effect");
					returnFavor.onTurnStart = function() {}; // overwrite the original function which removes it
					this.m.Skills.add(returnFavor);						
					if (dc >= 180)
					{
						this.m.Skills.add(this.new("scripts/skills/perks/perk_crTotalcover"));			
						this.m.BaseProperties.MeleeSkill += 3;	
						//this.m.BaseProperties.Initiative += 3;
						this.m.BaseProperties.Stamina += 5;							
						if (dc >= 210)
						{													
							this.m.BaseProperties.MeleeDefense += 3;	
							//this.m.BaseProperties.Initiative += 2;
							this.m.BaseProperties.RangedDefense += 3;								
						}						
					}		
				}
			}
		}
		if (("Assets" in this.World) && this.World.Assets != null && this.World.Assets.getCombatDifficulty() == this.Const.Difficulty.Legendary)
		{	
			this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_feint"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_legend_last_stand"));
			this.m.Skills.add(this.new("scripts/skills/traits/fearless_trait"));
			this.m.Skills.add(this.new("scripts/skills/perks/perk_lone_wolf"));

			if (::Is_PTR_Exist)
			{
				this.m.Skills.addPerkTree(this.Const.Perks.LaborerProfessionTree);	

				this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_man_of_steel"));	
				this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_exude_confidence"));				
				this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_personal_armor"));
				this.m.Skills.add(this.new("scripts/skills/perks/perk_ptr_survival_instinct"));
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

		if (::Mod_Sellswords.EnableHostileSequences)
		{
			local roll = this.Math.rand(1.0, 100.0);
			if (roll <= 15.0)
				::Mod_Sellswords.add_unhold(this.actor, true);
		}
	}

	function onDeath(_killer, _skill, _tile, _fatalityType)
	{
		if (::Mod_Sellswords.EnableHostileSequences)
			::Mod_Sellswords.doHostileSequencePotionDrop(_killer, _skill, _tile, _fatalityType, this.actor);
		this.human.onDeath(_killer, _skill, _tile, _fatalityType);
	}

	function assignRandomEquipment()
	{
		local r;
		local banner = 4;
		local dc = this.World.getTime().Days;
		local mn = this.World.Statistics.getFlags().getAsInt("ArenaRegularFightsWon");	
		dc = this.Math.max(dc, mn * 3);			

		if (("State" in this.Tactical) && this.Tactical.State != null && !this.Tactical.State.isScenarioMode())
		{
			banner = this.World.FactionManager.getFaction(this.getFaction()).getBanner();
		}
		else
		{
			banner = this.getFaction();
		}

		this.m.Surcoat = banner;

		this.getSprite("surcoat").setBrush("surcoat_" + (banner < 10 ? "0" + banner : banner));

		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/fighting_axe",
				"weapons/noble_sword",
				"weapons/winged_mace",
				"weapons/warhammer"
			];
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));

			//if (::Is_PTR_Exist)
			//{
			//	this.m.Skills.addTreeOfEquippedWeapon(7);	
			//}	
			::Mod_Sellswords.HookHelper.addTreeOfEquippedWeapon(this);
		}

		if (this.m.Items.hasEmptySlot(this.Const.ItemSlot.Offhand))
		{
			r = this.Math.rand(1, 2);
			local shield;
			local rr = this.Math.rand(1, 100);
			if (rr > dc)
			{
				if (r == 1)
				{
					shield = this.new("scripts/items/shields/faction_heater_shield");
				}
				else if (r == 2)
				{
					shield = this.new("scripts/items/shields/faction_kite_shield");
				}
			}
			else if (rr <= dc)
			{
				shield = this.new("scripts/items/shields/legend_faction_tower_shield");				
			}

			shield.setFaction(banner);
			this.m.Items.equip(shield);
		}

		if (dc <= 80)
		{
			this.m.Items.equip(this.Const.World.Common.pickArmor([
				[1, "cr_plate_scale_mid"],	  //315,-40							 320
				[1, "cr_plate_full_mid"],		   //320,-41
				[1, "cr_plate_full_mid_reinforced"],	 //335,-43					
			]));
			this.m.Items.equip(this.Const.World.Common.pickHelmet([				
				[2, "crknight_helmet_mid_bread"],			//350,-23						350,10/16
				[2, "crknight_helmet_mid_decorative"],		 //335,-22
				[1, "crknight_helmet_mid_unadorned"],			//325 -21
				[5, "crknight_faction_helm_enclave_armet",banner],  //355,-24 
				[1, "cr_enclave_armet"],			   //355,-24  	
				[1, "crknight_faction_helm_great_helm_faceplate_01",banner],			//340,-24 
				[3, "crknight_faction_helm_great_helm_armet_heavy",banner],	 		//345,-23 
				[1, "crknight_faction_helm_great_helm_frogmouth",banner],	   		//340,-22  															
			]));
		}	
		else if (dc <= 110)
		{
			this.m.Items.equip(this.Const.World.Common.pickArmor([
				[1, "cr_plate_full_mid"],		   //320,-41					340
				[2, "cr_plate_full_mid_reinforced"],	 //335,-43
				[1, "cr_plate_full_late"],	   //370,-50					
			]));
			this.m.Items.equip(this.Const.World.Common.pickHelmet([				
				[1, "crknight_helmet_mid_bread"],			//350,-23			   370,8/12				 				
				[2, "crknight_faction_helm_enclave_armet",banner],  //355,-24 
				[1, "cr_enclave_armet"],			   //355,-24  	
				[2, "crknight_helmet_mid_bascinet_faceplate"],			   //385,-26
				[2, "crknight_faction_helm_great_helm_faceplate_02",banner],			//365,-23					
				[2, "crknight_faction_helm_great_helm_frogmouth_heavy",banner],  		//380,-26 
				[2, "crknight_faction_helm_great_helm_faceplate_heavy_01",banner],	  //385,-30 					
			]));
		}	
		else if (dc <= 140)
		{
			this.m.Items.equip(this.Const.World.Common.pickArmor([
				[1, "cr_plate_full_late"],	   //370,-50				 375
				[1, "cr_plate_full_heavy"],	   //380,-49					
			]));
			this.m.Items.equip(this.Const.World.Common.pickHelmet([	   					 	
				[3, "crknight_faction_helm_enclave_great_bascinet",banner],  //415,-29		  410,6/10
				[1, "cr_enclave_great_bascinet"],			   //415,-29	
				[1, "cr_enclave_armet_late"],			   //400,-28
				[1, "crknight_helmet_late_mixed"],				//410, min 400	
				[1, "crknight_helmet_late_mixed_patched"],		//405, min 390 
				[3, "crknight_faction_helm_great_helm_faceplate_heavy_02",banner],	  //410,-32 					
			]));
		}	
		else if (dc <= 170)
		{
			this.m.Items.equip(this.Const.World.Common.pickArmor([
				[1, "cr_plate_full_late"],	   //370,-50			 
				[2, "cr_plate_full_heavy"],	   //380,-49		  380
				[1, "cr_plate_full_knight"]		 //430,-56						
			]));
			this.m.Items.equip(this.Const.World.Common.pickHelmet([					
				[2, "cr_enclave_great_bascinet_late"],			   //465,-32			 		  440,9/18
				[5, "crknight_faction_helm_enclave_venitian_bascinet",banner],   //460,-33
				[3, "cr_enclave_venitian_bascinet"],			   //460,-33	
				[1, "crknight_faction_helm_enclave_great_bascinet",banner],  //415,-29	   
				[1, "cr_enclave_great_bascinet"],			   //415,-29	
				[1, "crknight_helmet_late_mixed"],				//410, min 400	
				[1, "crknight_helmet_late_mixed_patched"],		//405, min 390					
				[1, "crknight_helmet_late_enclave_ichi"],			   //420
				[3, "crknight_faction_helm_frogmouth_faceplate",banner],  //440,-30					
			]));
		}
		else if (dc <= 200)
		{
			this.m.Items.equip(this.Const.World.Common.pickArmor([
				[1, "cr_plate_full_heavy_late"],	   //435,-57		 410
				[1, "cr_plate_full_heavy"],	   //380,-49
				[1, "cr_plate_full_knight"]		 //430,-56						
			]));
			this.m.Items.equip(this.Const.World.Common.pickHelmet([												
				[4, "crknight_faction_helm_enclave_great_helm",banner],	//475,-36	   480,4/8
				[1, "cr_enclave_great_helm"],				//475,-36						
				[1, "cr_enclave_great_bascinet_late"],			  //465,-32
				[1, "crknight_helmet_late_enclave_ni"],			   //460
				[1, "crknight_helmet_late_enclave_sann"]			   //460					
			]));
		}
		else if (dc > 200)
		{
			this.m.Items.equip(this.Const.World.Common.pickArmor([
				[2, "cr_plate_full_knight_late"],		//465,-58		  450
				[1, "cr_plate_full_knight"]		 //430,-56						
			]));
			this.m.Items.equip(this.Const.World.Common.pickHelmet([						
				[1, "cr_enclave_venitian_bascinet_late"],			   //490,-31				   500,4/8			
				[4, "crknight_faction_helm_enclave_great_helm_late",banner],	//515
				[1, "cr_enclave_great_helm"],				//475,-36	
				[2, "cr_enclave_great_helm_late"],			   //515
				[1, "cr_lion_helmet"],			   //515				
			]));
		}			
	}

	function makeMiniboss()
	{
		if (!this.actor.makeMiniboss())
		{
			return false;
		}

		this.getSprite("miniboss").setBrush("bust_miniboss");
		local weapons = [
			"weapons/named/named_axe",
			"weapons/named/named_greatsword",
			"weapons/named/named_mace",
			"weapons/named/named_sword",
			"weapons/named/named_longsword"
		];
		local shields = clone this.Const.Items.NamedShields;
		local r = this.Math.rand(1, 4);

		if (r == 1)
		{
			this.m.Items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}
		else if (r == 2)
		{
			this.m.Items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
		}
		else if (r == 3)	
		{
			this.m.Items.equip(this.Const.World.Common.pickArmor([
				[1, "cr_named_full_armor_cloth"],	
				[1, "cr_named_full_armor_chain"],		
				[1, "cr_named_full_armor_plate"],				
			]));
		}
		else
		{
			this.m.Items.equip(this.Const.World.Common.pickHelmet([
				[
					1,
					"cr_named_full_helmet"
				]
			]));
		}

		//if (::Is_PTR_Exist)
		//{
		//	this.m.Skills.addTreeOfEquippedWeapon(7);	
		//}	
		::Mod_Sellswords.HookHelper.addTreeOfEquippedWeapon(this);

		this.m.Skills.add(this.new("scripts/skills/perks/perk_killing_frenzy"));
		return true;
	}

});

