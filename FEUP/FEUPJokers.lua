--- STEAMODDED HEADER
--- MOD_NAME: FEUP Jokers
--- MOD_ID: FEUPJkrs
--- MOD_AUTHOR: [Memechanic]
--- MOD_DESCRIPTION: Adds FEUP Joker cards

----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas {
    key = "Jokers-Diniz",
    path = "Jokers-Diniz.png",
    px = 71,
    py = 95
}
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
            "{C:attention}9.5/20{} of required chips",
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
        
        if not self.debuff and context.end_of_round and context.game_over and (G.GAME.chips/G.GAME.blind.chips >= to_big(0.475)) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    return true
                end
            })) 
            return {
                message = "It was trivial",
                saved = true,
                colour = G.C.RED
            }
        end   
    end,
    in_pool = function(self,wawa,wawa2)
        return true
    end
}

----------------------------------------------
------------MOD CODE END----------------------