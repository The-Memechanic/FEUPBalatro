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

-- Mod icon

SMODS.Atlas({
key = "modicon",
path = "modicon.png", 
px = 32, 
py = 32
})

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
    order = 151,
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
    end,
    in_pool = function(self,wawa,wawa2)
        return true
    end
}

-- Spades and Clubs are debuffed, Hearts and Diamonds give 2X mult
SMODS.Joker{
    key = "Luis Paulo Reis",
    loc_txt = {
        name = "Luis Paulo Reis",
        text={
            "{C:spades}Spades{} and {C:clubs}Clubs{} are debuffed",
            "{C:hearts}Hearts{} and {C:diamonds}Diamonds{} give",
            "{X:mult,C:white} X#1# {} Mult when scored",
        },
    },
    atlas = "Jokers-Luis-Paulo-Reis",
    order = 152,
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
    config = {extra = 1.75},
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra}}
    end,
    update = function(self, card, dt)
		if G.deck and card.added_to_deck then
			for i, v in pairs(G.deck.cards) do
				if v:is_suit("Spades") or v:is_suit("Clubs") then
					v:set_debuff(true)
				end
			end
		end
		if G.hand and card.added_to_deck then
			for i, v in pairs(G.hand.cards) do
				if v:is_suit("Spades") or v:is_suit("Clubs") then
					v:set_debuff(true)
				end
			end
		end
	end,
    calculate = function(self,card,context)

        if not self.debuff and context.individual and context.cardarea == G.play and (context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds")) then
            return {
                x_mult = card.ability.extra,
                colour = G.C.RED,
                card = card
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        return true
    end
}

----------------------------------------------
------------MOD CODE END----------------------