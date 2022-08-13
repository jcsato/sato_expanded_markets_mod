::mods_registerMod("sato_expanded_markets", 1.1, "Sato's Expanded Markets");

::mods_queue(null, null, function() {
    ::mods_hookBaseClass("entity/world/attached_location", function(al) {
        while(!("onUpdateShopList" in al)) al = al[al.SuperName];

        local onUpdateShopList = al.onUpdateShopList;

        al.onUpdateShopList = function( _id, _list ) {
            if (_id == "building.armorsmith" && m.ID == "attached_location.blast_furnace") {
                _list.push({ R = 90, P = 1.0, S = "helmets/greatsword_faction_helm" });
                _list.push({ R = 95, P = 1.0, S = "helmets/faction_helm" });
                _list.push({ R = 99, P = 1.1, S = "armor/special/heraldic_armor" });
            } else if (_id == "building.marketplace" && (m.ID == "attached_location.leather_tanner" || m.ID == "attached_location.trapper"))
                _list.push({ R = 55, P = 1.0, S = "helmets/greatsword_hat" });

            onUpdateShopList(_id, _list);
        }
    });

    ::mods_hookBaseClass("entity/world/settlements/buildings/building", function(b) {
        while(!("fillStash" in b)) b = b[b.SuperName];
        local fillStash = b.fillStash;

        ::mods_override(b, "fillStash", function(_list, _stash, _priceMult, _allowDamagedEquipment = false) {
            fillStash(_list, _stash, _priceMult, _allowDamagedEquipment = false);
            foreach( item in _stash.getItems() ) {
                if (item.getID() == "armor.head.greatsword_faction_helm" || item.getID() == "armor.head.faction_helm") {
                    local settlement = getSettlement();
                    local faction = settlement.getOwner();
                    local banner = faction.getBanner();

                    item.setVariant(banner);
                } else if (item.getID() == "armor.body.heraldic_armor") {
                    local settlement = getSettlement();
                    local faction = settlement.getOwner();
                    local banner = faction.getBanner();

                    item.setFaction(banner);
                }
            }
        });
    });

    ::mods_hookBaseClass("entity/world/settlement", function(s) {
        while(!("onUpdateShopList" in s)) s = s[s.SuperName];

        local NORTHERN_BEAST_PARTS_LOW = [
            "misc/werewolf_pelt_item",
            "misc/adrenaline_gland_item",
            "misc/ghoul_teeth_item",
            "misc/ghoul_horn_item",
            "misc/ghoul_brain_item"
        ];

        local NORTHERN_BEAST_PARTS_MED = [
            "misc/frost_unhold_fur_item",
            "misc/unhold_heart_item",
            "misc/unhold_bones_item",
            "misc/parched_skin_item",
            "misc/third_eye_item",
            "misc/petrified_scream_item"
        ];

        local NORTHERN_BEAST_PARTS_HIGH = [
            "misc/ancient_wood_item",
            "misc/glowing_resin_item",
            "misc/heart_of_the_forest_item"
        ];

        local MIDLAND_BEAST_PARTS_LOW = [
            "misc/werewolf_pelt_item",
            "misc/adrenaline_gland_item",
            "misc/spider_silk_item",
            "misc/poison_gland_item"
        ];

        local MIDLAND_BEAST_PARTS_MED = [
            "misc/unhold_hide_item",
            "misc/unhold_heart_item",
            "misc/unhold_bones_item",
            "misc/parched_skin_item",
            "misc/third_eye_item",
            "misc/petrified_scream_item"
        ];

        local MIDLAND_BEAST_PARTS_HIGH = [
            "misc/witch_hair_item",
            "misc/mysterious_herbs_item",
            "misc/poisoned_apple_item"
        ];

        local SOUTHERN_BEAST_PARTS_LOW = [
            "misc/hyena_fur_item",
            "misc/acidic_saliva_item",
            "misc/ghoul_teeth_item",
            "misc/ghoul_horn_item",
            "misc/ghoul_brain_item"
        ];

        local SOUTHERN_BEAST_PARTS_MED = [
            "misc/serpent_skin_item",
            "misc/glistening_scales_item",
            "misc/sulfurous_rocks_item"
        ];

        local SOUTHERN_BEAST_PARTS_HIGH = [
            "misc/lindwurm_blood_item",
            "misc/lindwurm_scales_item",
            "misc/lindwurm_bones_item"
        ];

        local NORTHERN_ARMOR = [
            "helmets/nordic_helmet",
            "helmets/nordic_helmet",
            "helmets/barbarians/bear_headpiece",
            "helmets/barbarians/bear_headpiece",
            "helmets/barbarians/bear_headpiece",
            "helmets/barbarians/leather_headband",
            "helmets/barbarians/leather_headband",
            "helmets/barbarians/leather_headband",
            "helmets/barbarians/leather_helmet",
            "helmets/barbarians/leather_helmet",
            "helmets/barbarians/crude_metal_helmet",
            "helmets/barbarians/crude_metal_helmet",
            "helmets/barbarians/crude_faceguard_helmet",
            "helmets/barbarians/closed_scrap_metal_helmet",
            "armor/barbarians/animal_hide_armor",
            "armor/barbarians/animal_hide_armor",
            "armor/barbarians/animal_hide_armor",
            "armor/barbarians/thick_furs_armor",
            "armor/barbarians/thick_furs_armor",
            "armor/barbarians/thick_furs_armor",
            "armor/barbarians/reinforced_animal_hide_armor",
            "armor/barbarians/reinforced_animal_hide_armor",
            "armor/barbarians/reinforced_animal_hide_armor",
            "armor/barbarians/hide_and_bone_armor",
            "armor/barbarians/hide_and_bone_armor",
            "armor/barbarians/rugged_scale_armor",
            "armor/barbarians/rugged_scale_armor",
            "armor/barbarians/heavy_iron_armor",
            "armor/barbarians/rugged_scale_armor"
        ];

        local NORTHERN_WEAPONS = [
            "weapons/barbarians/antler_cleaver",
            "weapons/barbarians/antler_cleaver",
            "weapons/barbarians/antler_cleaver",
            "weapons/barbarians/claw_club",
            "weapons/barbarians/claw_club",
            "weapons/barbarians/claw_club",
            "weapons/barbarians/axehammer",
            "weapons/barbarians/axehammer",
            "weapons/barbarians/blunt_cleaver",
            "weapons/barbarians/blunt_cleaver",
            "weapons/barbarians/crude_axe",
            "weapons/barbarians/crude_axe",
            "weapons/barbarians/heavy_rusty_axe",
            "weapons/barbarians/rusty_warblade",
            "weapons/barbarians/skull_hammer",
            "weapons/barbarians/two_handed_spikce_mace"
        ];

        local MIDLAND_ARMOR = [
            "helmets/full_leather_cap",
            "helmets/full_leather_cap",
            "helmets/full_leather_cap",
            "helmets/rusty_mail_coif",
            "helmets/rusty_mail_coif",
            "helmets/rusty_mail_coif",
            "helmets/dented_nasal_helmet",
            "helmets/dented_nasal_helmet",
            "helmets/nasal_helmet_with_rusty_mail",
            "helmets/nasal_helmet_with_rusty_mail",
            "helmets/decayed_closed_flat_top_with_mail",
            "helmets/decayed_closed_flat_top_with_sack",
            "armor/ragged_surcoat",
            "armor/ragged_surcoat",
            "armor/ragged_surcoat",
            "armor/blotched_gambeson",
            "armor/blotched_gambeson",
            "armor/blotched_gambeson",
            "armor/patched_mail_shirt",
            "armor/patched_mail_shirt",
            "armor/worn_mail_shirt",
            "armor/worn_mail_shirt",
            "armor/decayed_reinforced_mail_hauberk"
        ];

        local SOUTHERN_ARMOR = [
            "helmets/oriental/nomad_head_wrap",
            "helmets/oriental/nomad_head_wrap",
            "helmets/oriental/nomad_head_wrap",
            "helmets/oriental/nomad_leather_cap",
            "helmets/oriental/nomad_leather_cap",
            "helmets/oriental/nomad_leather_cap",
            "helmets/oriental/nomad_light_helmet",
            "helmets/oriental/nomad_light_helmet",
            "helmets/oriental/nomad_reinforced_helmet",
            "helmets/oriental/nomad_reinforced_helmet",
            "armor/oriental/nomad_robe",
            "armor/oriental/nomad_robe",
            "armor/oriental/nomad_robe",
            "armor/oriental/thick_nomad_robe",
            "armor/oriental/thick_nomad_robe",
            "armor/oriental/thick_nomad_robe",
            "armor/oriental/leather_nomad_robe",
            "armor/oriental/leather_nomad_robe",
            "armor/oriental/stitched_nomad_armor",
            "armor/oriental/stitched_nomad_armor",
            "armor/oriental/plated_nomad_mail"
        ];

        local SOUTHERN_WEAPONS = [
            "weapons/oriental/nomad_mace",
            "weapons/oriental/nomad_mace",
            "weapons/oriental/nomad_mace",
            "weapons/oriental/nomad_sling",
            "weapons/oriental/nomad_sling",
            "weapons/oriental/nomad_sling"
        ];

        local onUpdateShopList = s.onUpdateShopList;

        s.onUpdateShopList = function( _id, _list ) {
            if (_id == "building.marketplace") {
                // DLC check is inherently in place due to taxidermist presence
                if (getBuilding("building.taxidermist") != null || getBuilding("building.taxidermist_oriental") != null) {
                    if (getCulture() == Const.World.Culture.Northern) {
                        _list.extend([
                            { R = 50, P = 1.0, S = NORTHERN_BEAST_PARTS_LOW[Math.rand(0, NORTHERN_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 75, P = 1.0, S = NORTHERN_BEAST_PARTS_LOW[Math.rand(0, NORTHERN_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 99, P = 1.0, S = NORTHERN_BEAST_PARTS_LOW[Math.rand(0, NORTHERN_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 75, P = 1.1, S = NORTHERN_BEAST_PARTS_MED[Math.rand(0, NORTHERN_BEAST_PARTS_MED.len() - 1)] },
                            { R = 99, P = 1.1, S = NORTHERN_BEAST_PARTS_MED[Math.rand(0, NORTHERN_BEAST_PARTS_MED.len() - 1)] },
                            { R = 90, P = 1.2, S = NORTHERN_BEAST_PARTS_HIGH[Math.rand(0, NORTHERN_BEAST_PARTS_HIGH.len() - 1)] }
                        ]);
                    } else if (getCulture() == Const.World.Culture.Neutral) {
                        _list.extend([
                            { R = 50, P = 1.0, S = MIDLAND_BEAST_PARTS_LOW[Math.rand(0, MIDLAND_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 75, P = 1.0, S = MIDLAND_BEAST_PARTS_LOW[Math.rand(0, MIDLAND_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 99, P = 1.0, S = MIDLAND_BEAST_PARTS_LOW[Math.rand(0, MIDLAND_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 75, P = 1.1, S = MIDLAND_BEAST_PARTS_MED[Math.rand(0, MIDLAND_BEAST_PARTS_MED.len() - 1)] },
                            { R = 99, P = 1.1, S = MIDLAND_BEAST_PARTS_MED[Math.rand(0, MIDLAND_BEAST_PARTS_MED.len() - 1)] },
                            { R = 90, P = 1.2, S = MIDLAND_BEAST_PARTS_HIGH[Math.rand(0, MIDLAND_BEAST_PARTS_HIGH.len() - 1)] }
                        ]);
                    } else if (getCulture() == Const.World.Culture.Southern) {
                        _list.extend([
                            { R = 50, P = 1.0, S = SOUTHERN_BEAST_PARTS_LOW[Math.rand(0, SOUTHERN_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 75, P = 1.0, S = SOUTHERN_BEAST_PARTS_LOW[Math.rand(0, SOUTHERN_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 99, P = 1.0, S = SOUTHERN_BEAST_PARTS_LOW[Math.rand(0, SOUTHERN_BEAST_PARTS_LOW.len() - 1)] },
                            { R = 75, P = 1.1, S = SOUTHERN_BEAST_PARTS_MED[Math.rand(0, SOUTHERN_BEAST_PARTS_MED.len() - 1)] },
                            { R = 99, P = 1.1, S = SOUTHERN_BEAST_PARTS_MED[Math.rand(0, SOUTHERN_BEAST_PARTS_MED.len() - 1)] },
                            { R = 90, P = 1.2, S = SOUTHERN_BEAST_PARTS_HIGH[Math.rand(0, SOUTHERN_BEAST_PARTS_HIGH.len() - 1)] }
                        ]);
                    }
                }

                if (getCulture() == Const.World.Culture.Northern) {
                    if (Const.DLC.Wildmen) {
                        _list.extend([
                            { R = 75, P = 1.0, S = NORTHERN_WEAPONS[Math.rand(0, NORTHERN_WEAPONS.len() - 1)] },
                            { R = 75, P = 1.0, S = NORTHERN_ARMOR[Math.rand(0, NORTHERN_ARMOR.len() - 1)] },
                            { R = 80, P = 1.0, S = NORTHERN_ARMOR[Math.rand(0, NORTHERN_ARMOR.len() - 1)] },
                        ]);
                    } else {
                        _list.extend([
                            { R = 75, P = 1.0, S = MIDLAND_ARMOR[Math.rand(0, MIDLAND_ARMOR.len() - 1)] },
                            { R = 80, P = 1.0, S = MIDLAND_ARMOR[Math.rand(0, MIDLAND_ARMOR.len() - 1)] },
                        ]);
                    }
                } else if (getCulture() == Const.World.Culture.Neutral) {
                    _list.extend([
                        { R = 75, P = 1.0, S = MIDLAND_ARMOR[Math.rand(0, MIDLAND_ARMOR.len() - 1)] },
                        { R = 80, P = 1.0, S = MIDLAND_ARMOR[Math.rand(0, MIDLAND_ARMOR.len() - 1)] },
                    ]);
                } else if (getCulture() == Const.World.Culture.Southern) {
                    _list.extend([
                        { R = 80, P = 1.0, S = SOUTHERN_WEAPONS[Math.rand(0, SOUTHERN_WEAPONS.len() - 1)] },
                        { R = 75, P = 1.0, S = SOUTHERN_ARMOR[Math.rand(0, SOUTHERN_ARMOR.len() - 1)] },
                        { R = 80, P = 1.0, S = SOUTHERN_ARMOR[Math.rand(0, SOUTHERN_ARMOR.len() - 1)] },
                    ]);
                }
            }
            onUpdateShopList( _id, _list );
        }
    });
});
