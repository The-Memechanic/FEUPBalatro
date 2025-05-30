--- STEAMODDED HEADER
--- MOD_NAME: FEUP Jokers
--- MOD_ID: FEUPJkrs
--- MOD_AUTHOR: [Memechanic]
--- MOD_DESCRIPTION: Adds FEUP Joker cards

----------------------------------------------
------------MOD CODE -------------------------

-- Joker paths
SMODS.Atlas {
    key = "Jokers-Diniz",
    path = "Jokers-Diniz.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "Jokers-Luis-Paulo-Reis",
    path = "Jokers-Luis-Paulo-Reis.png",
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = "Jokers-Augusto-Sousa",
    path = "Jokers-Augusto-Sousa.png",
    px = 71,
    py = 95
}

-- Mod icon

SMODS.Atlas({
key = "modicon",
path = "modicon.png", 
px = 32, 
py = 32
})

-- 8/20 nota minima
SMODS.Joker{
    key = "Peter Diniz",
    loc_txt = {
        name = "Peter Diniz",
        text={
            "Prevents Death if",
            "chips scored are at least",
            "{C:attention}8/20{} of required chips",
        },
    },
    atlas = "Jokers-Diniz",
    order = 1,
    set = "Joker",
    pos = {x = 0, y = 0},
    rarity = 4,
    soul_pos = { x = 0, y = 1},
    cost = 20,
    cost_mult = 1.0;
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = {},
    effect = "Prevent Death",
    calculate = function(self,card,context)
        
        if not self.debuff and context.end_of_round and context.game_over and (G.GAME.chips/G.GAME.blind.chips >= to_big(0.4)) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    return true
                end
            })) 
            return {
                message = "Trivial",
                saved = true,
                colour = G.C.RED
            }
        end   
    end
}

-- Queens are debuffed, Kings and Jacks give 1.75X mult
SMODS.Joker{
    key = "Luis Paulo Reis",
    loc_txt = {
        name = "Luis Paulo Reis",
        text={
            "{C:attention}Queens{} are debuffed.",
            "{C:attention}Kings{} and {C:attention}Jacks{} give",
            "{X:mult,C:white} X#1# {} Mult when scored",
        },
    },
    atlas = "Jokers-Luis-Paulo-Reis",
    order = 2,
    set = "Joker",
    pos = {x = 0, y = 0},
    rarity = 4,
    soul_pos = { x = 0, y = 1},
    cost = 20,
    cost_mult = 1.0;
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = 1.75},
    effect = "",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra}}
    end,
    update = function(self, card, dt)
		if G.deck and card.added_to_deck then
			for i, v in pairs(G.deck.cards) do
				if v:get_id() == 12 then
					v:set_debuff(true)
				end
			end
		end
		if G.hand and card.added_to_deck then
			for i, v in pairs(G.hand.cards) do
				if v:get_id() == 12 then
					v:set_debuff(true)
				end
			end
		end
	end,
    calculate = function(self,card,context)

        if not self.debuff and context.individual and context.cardarea == G.play then
            if context.other_card:get_id() == 13 or context.other_card:get_id() == 11 then
                return {
                    x_mult = card.ability.extra,
                    colour = G.C.RED,
                    card = card
                }
            end
        end
    end
}

-- Red Seal played Aces, Steel Aces in hand
SMODS.Joker{
    key = "Augusto Sousa",
    loc_txt = {
        name = "Augusto Sousa",
        text={
            "If played hand has only 1 card,",
            "it becomes {C:dark_edition}Polychrome{}.",
            "This Joker gains {X:mult,C:white}X0.2{} Mult",
            "for every scoring {C:dark_edition}Polychrome{} card",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)",
        },
    },
    atlas = "Jokers-Augusto-Sousa",
    order = 3,
    set = "Joker",
    pos = {x = 0, y = 0},
    rarity = 4,
    soul_pos = { x = 0, y = 1},
    cost = 20,
    cost_mult = 1.0;
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    config = { extra = {
        Xmult = 1,
        Xmult_gain = 0.2
        }
    },
    effect = "Enhance",
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,
    calculate = function(self,card,context)
        
        -- upgrade played card
        if not self.debuff and context.cardarea == G.jokers and context.before and not context.blueprint then
            if #context.full_hand == 1 then
                context.full_hand[1]:set_edition({polychrome = true}, true)
                return {
                    message = "RGB!",
                    colour = G.C.RED,
                    card = self
                }
            end
        end

        -- upgrade joker value
        if not self.debuff and context.individual and context.cardarea == G.play then
            if context.other_card.edition and context.other_card.edition.x_mult then
                card.ability.extra.Xmult = card.ability.extra.Xmult + card.ability.extra.Xmult_gain
                return { 
                    message = localize('k_upgrade_ex') 
                }
            end
        end

        -- apply x mult at the end
        if not self.debuff and context.joker_main then
            return {  
                card = card,
                Xmult_mod = card.ability.extra.Xmult,
                message = "x" .. card.ability.extra.Xmult,
                colour = G.C.MULT,
            }
        end
    end
}

----------------------------------------------
------------MOD CODE END----------------------