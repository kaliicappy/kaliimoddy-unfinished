--- STEAMODDED HEADER
--- MOD_NAME: kaliimoddy
--- MOD_ID: kaliimoddy
--- MOD_AUTHOR: [kaliicappy]
--- MOD_DESCRIPTION: follow @kaliicappy on twitter
--- PREFIX: kali
-----------------------------------------------
---------------NOTE TO SELF--------------------

-- when making a joker, split it into 3 steps, making sure to test between them!
--example:

----------STEP ONE----------- - IMPLIMENTING JOKER
--SMODS.Atlas{
--  key = 'Jokers',
--  path = 'Jokers.png',
--  px = 71,
--  py = 95 
--}
--
--SMODS.Joker{
--  key = 'example',
--  loc_txt = {
--    name = 'ExampleJoker',
--    text = {
--      '{X:mult,C:white}X#1#{} Mult'
--    }
--  }
--}

----------STEP TWO---------- - JOKER ART
--place a comma and a linebreak after the second last }, write this there
--  atlas = 'Jokers',
--  pos = {x = 0, y = 0},

----------STEP THREE------- - loc_vars FUNCTION (DYNAMIC TEXT CHANGE)
--after the pos is stated, write this!
--  config = { extra = {
--    Xmult = 100
--}
--},
--  loc_vars = function(self,info_queue,center)
--    return {vars = {center.ability.extra.Xmult}}
--  end

--------STEP FOUR--------- - CALCULATION
-- right after the 'end' place a comma and continue from there
--  calculate = function(self,card,context)
--    if context.joker_main then
--      return {
--        card = card,
--        Xmult_mod = card.ability.extra.Xmult,
--        message = 'X' .. card.ability.extra.Xmult,
--        color = G.C.MULT
--    }
--  end
--end

--------and youre done!---------
----------------------------------------------
------------MOD CODE--------------------------


-- Six Seven Mason
SMODS.Atlas{
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Sound({key = "sixseven", path = "sixseven.mp3",})

SMODS.Joker{
    key = 'masonjoker',
    loc_txt = {
        name = 'Mason 67',
        text = {
            '{X:mult,C:white} X#1# {} Mult if scored hand',
            'contains a {C:attention}6{} and a {}{C:attention}7{}'
        }
    },
    atlas = 'Jokers',
    pos = {x = 0, y = 0},
    config = {
        extra = {
            Xmult = 6.7
        }
    },
    loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.Xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local hassix = false
            local hasseven = false

            for i = 1, #context.scoring_hand do
                if context.full_hand[i]:get_id() == 6 then
                    hassix = true
                end
                if context.full_hand[i]:get_id() == 7 then
                    hasseven = true
                end
            end

            if hassix and hasseven then
                return {
                    message = "67!",
                    Xmult_mod = card.ability.extra.Xmult,
                    sound = "kali_sixseven"
                }
            end
        end
    end
}


-- Job Application
SMODS.Atlas{
  key = 'JobApplication',
  path = 'JobApplication.png',
  px = 71,
  py = 95 
}

SMODS.Sound({key = "kaching", path = "Kaching.mp3",})

SMODS.Joker{
  key = 'jobapplication',
  loc_txt = {
    name = 'Job Application',
    text = {
      '{C:green}1 in #2#{} chance to',
      'earn {C:attention}$#1#{} at end of round'
    }
  },
  atlas = 'JobApplication',
  pos = {x = 0, y = 0},
  config = { extra = {dollars = 50, chance = 14}},
  loc_vars = function(self,info_queue,center)
    return {vars = {center.ability.extra.dollars, center.ability.extra.chance}}
  end,
  calculate = function(self,card,context)
  if context.joker_main and 
       pseudorandom('JobApplication') < (G.GAME.probabilities.normal / card.ability.extra.chance) then
      return {
        card = card,
        dollars = card.ability.extra.dollars,
        color = G.C.GOLD,
        message = 'Paid!',
        sound = 'kali_kaching'
    }
    elseif context.joker_main then

      return {
        card = card,
        message = 'Unpaid..'
    }
  end
end
}


-- I'm Done
function crashKali()
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 1,
        func = function()
            forceGameover()
            SMODS.restart_game()
            return true
        end
    }))
end

SMODS.Atlas{
    key = 'imdone',
    path = 'imdone.png',
    px = 71,
    py = 95 
}

SMODS.Joker{
    key = 'imdone',
    loc_txt = {
        name = "i'm done",
        text = {
            "self explanitory."
        }
    },
    atlas = 'imdone',
    pos = {x = 0, y = 0},
    config = { extra = {} },
    loc_vars = function(self, info_queue, center)
        return {vars = {}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            crashKali()
            return {
                message = "Goodbye.",
                color = G.C.RED,
                func = function()
                    return true
                end
            }
        end
    end
}


-- Wordle
SMODS.Atlas{
  key = 'wordle',
  path = 'wordle.png',
  px = 71,
  py = 95
}

SMODS.Joker {
    key = "wordle",
    blueprint_compat = true,
    eternal_compat = false,
    rarity = 3,
    cost = 9,
    atlas = 'wordle',
    pos = {x = 0, y = 0},
    config = { extra = { odds = 7, Xmult = 1 } },

    loc_txt = {
        name = "Wordle",
        text = {
            "Gains {X:mult,C:white}X1{} Mult every turn,",
            "{C:green}1 in #2#{} chance this is",
            "destroyed at end of round.",
            "{C:inactive}(Currently {X:mult,C:white}X#1#{} Mult)"
        }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.Xmult,
            card.ability.extra.odds
        }}
    end,

calculate = function(self, card, context)
    if context.end_of_round and context.cardarea == G.jokers then
        card.ability.extra.Xmult = card.ability.extra.Xmult + 1

        if pseudorandom('wordle') < (G.GAME.probabilities.normal / card.ability.extra.odds) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.4)
                    card:remove()
                    return true
                end
            }))
            return {
                card = card,
                message = "Lost streak...",
                color = G.C.RED
            }
        else
            return {
                card = card,
                message = "Solved!",
                color = G.C.GREEN
            }
        end
    end

    if context.joker_main then
        return {
            card = card,
            xmult = card.ability.extra.Xmult
        }
    end
end,
}


-- You Got The Dud
SMODS.Atlas{
  key = 'homerdud',
  path = 'homerdud.png',
  px = 71,
  py = 95 
}

SMODS.Joker {
  key = "homerdud",
  blueprint_compat = true,
  rarity = 1,
  cost = 3,
  atlas = 'homerdud',
  pos = {x = 0, y = 0},
  config = { extra = { chips = 25, mult = 7 } },

  loc_txt = {
    name = 'You Got The Dud!',
    text = {
      '{C:chips}+25 Chips{} and {C:mult}+7 Mult.',
      '{C:inactive}"He looks just like you,',
      '{C:inactive}pointdexter!"'
    }
  },

  loc_vars = function(self, info_queue, card)
    return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
  end,

  calculate = function(self, card, context)
    if context.joker_main then
      return {
        chips = card.ability.extra.chips,
        mult = card.ability.extra.mult
      }
    end
  end
}


-- The Dud
SMODS.Sound({key = "dudsfx", path = "dudsfx.ogg"})

SMODS.Atlas{
    key = 'thedud',
    path = 'TheDud.png',
    px = 71,
    py = 95,
}

SMODS.Joker{
    key = 'thedud',
    loc_txt= {
        name = 'The Dud',
        text = { "Retriggers all {C:green}The Dud Seals{} twice",
                    "If your first hand contains",
                    "{C:attention}only{} one card, applies",
                    "a {C:green}Dud Seal{} to it",
    },},
    atlas = 'thedud',
    rarity = 3,
    cost = 9,
    
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    pos = {x=0, y= 0},

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play then
            if context.other_card.seal == "kaliimoddy_dud_seal" then 
                    return {
                        message = localize("k_again_ex"),
                        repetitions = 2,
                        card = card,
                    }
            end
        end

        if context.cardarea == G.play and context.individual and #G.play.cards == 1 and G.GAME.current_round.hands_played == 0 then
            context.other_card.seal = "kaliimoddy_dud_seal"
            return {
                        message = "You Got The Dud!",
                        card = card,
                        play_sound = "kaliimoddy_dudsfx",
                        }
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'test' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
}


-- guess the suit (spade)
SMODS.Sound({key = "splat", path = "splat.mp3"})

SMODS.Atlas{
    key = 'selfdestructspade',
    path = 'selfdestructspade.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "selfdestructspade",
    atlas = 'selfdestructspade',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    config = {
        extra = {
            xmult = 2.5,
            suit = 'Spades'
        }
    },
    loc_txt = {
        name = "If You Play This Suit I'll Self Destruct",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "Destroyed if the {C:attention}Mystery Suit{} is played"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                localize(card.ability.extra.suit, 'suits_singular')
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then

            card.ability._skip_mult = true

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    play_sound("kaliimoddy_splat")
                    card:start_dissolve()
                    return true
                end
            }))

            return {
                message = "Spade!"
            }
        end

        if context.joker_main and not card.ability._skip_mult then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end
}


-- guess the suit (club)
SMODS.Sound({key = "splat", path = "splat.mp3"})

SMODS.Atlas{
    key = 'selfdestructclub',
    path = 'selfdestructclub.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "selfdestructclub",
    atlas = 'selfdestructclub',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    config = {
        extra = {
            xmult = 2.5,
            suit = 'Clubs'
        }
    },
    loc_txt = {
        name = "If You Play This Suit I'll Self Destruct",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "Destroyed if the {C:attention}Mystery Suit{} is played"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                localize(card.ability.extra.suit, 'suits_singular')
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then

            card.ability._skip_mult = true

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    play_sound("kaliimoddy_splat")
                    card:start_dissolve()
                    return true
                end
            }))

            return {
                message = "Club!"
            }
        end

        if context.joker_main and not card.ability._skip_mult then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end
}


-- guess the suit (diamond)
SMODS.Sound({key = "splat", path = "splat.mp3"})

SMODS.Atlas{
    key = 'selfdestructdiamond',
    path = 'selfdestructdiamond.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "selfdestructdiamond",
    atlas = 'selfdestructdiamond',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    config = {
        extra = {
            xmult = 2.5,
            suit = 'Diamonds'
        }
    },
    loc_txt = {
        name = "If You Play This Suit I'll Self Destruct",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "Destroyed if the {C:attention}Mystery Suit{} is played"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                localize(card.ability.extra.suit, 'suits_singular')
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then

            card.ability._skip_mult = true

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    play_sound("kaliimoddy_splat")
                    card:start_dissolve()
                    return true
                end
            }))

            return {
                message = "Diamond!"
            }
        end

        if context.joker_main and not card.ability._skip_mult then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end
}


-- guess the suit (heart)
SMODS.Sound({key = "splat", path = "splat.mp3"})

SMODS.Atlas{
    key = 'selfdestructheart',
    path = 'selfdestructheart.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "selfdestructheart",
    atlas = 'selfdestructheart',
    pos = {x = 0, y = 0},
    rarity = 2,
    cost = 5,
    blueprint_compat = true,
    config = {
        extra = {
            xmult = 2.5,
            suit = 'Hearts'
        }
    },
    loc_txt = {
        name = "If You Play This Suit I'll Self Destruct",
        text = {
            "{X:mult,C:white} X#1# {} Mult",
            "Destroyed if the {C:attention}Mystery Suit{} is played"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult,
                localize(card.ability.extra.suit, 'suits_singular')
            }
        }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and
            context.other_card:is_suit(card.ability.extra.suit) then

            card.ability._skip_mult = true

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.3,
                blockable = false,
                func = function()
                    play_sound("kaliimoddy_splat")
                    card:start_dissolve()
                    return true
                end
            }))

            return {
                message = "Heart!"
            }
        end

        if context.joker_main and not card.ability._skip_mult then
            return {
                x_mult = card.ability.extra.xmult
            }
        end
    end
}


-- Bjorn Joker
--sfx stuff lolz for bjorn + 1 for a tarot cuz idk where else to put it lolzzzz
SMODS.Sound({key = "XP", path = "XP.mp3"})
SMODS.Sound({key = "failpeggle", path = "failpeggle.ogg"})
SMODS.Sound({key = "multiball", path = "multiball.ogg"})
SMODS.Sound({key = "sigh", path = "sigh.ogg"})
SMODS.Sound({key = "extraball", path = "extraball.ogg"})
SMODS.Sound({key = "freeball", path = "freeball.ogg"})
SMODS.Sound({key = "peghi", path = "peghi.ogg"})
SMODS.Sound({key = "peglo", path = "peglo.ogg"})

SMODS.Atlas{
    key = 'bjorn',
    path = 'bjornjoker.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "bjorn",
    atlas = 'bjorn',
    pos = {x = 0, y = 0},
    blueprint_compat = true,
    rarity = 2,
    cost = 5,
    config = { extra = { max = 100, min = -50 } },
    loc_txt = {
    name = "Bjorker"
    },
    loc_vars = function(self, info_queue, card)
        local r_mults = {}
        for i = card.ability.extra.min, card.ability.extra.max do
            r_mults[#r_mults + 1] = tostring(i)
        end
        local loc_mult = ' ' .. (localize('k_mult')) .. ' '
        main_start = {
            { n = G.UIT.T, config = { text = '  +', colour = G.C.MULT, scale = 0.32 } },
            { n = G.UIT.O, config = { object = DynaText({ string = r_mults, colours = { G.C.RED }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
            {
                n = G.UIT.O,
                config = {
                    object = DynaText({
                        string = {
                            { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.RED },
                            loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult,
                            loc_mult, loc_mult, loc_mult, loc_mult },
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
        }
        return { main_start = main_start }
    end,
calculate = function(self, card, context)
    if context.joker_main then
        local result = pseudorandom('bjorn', card.ability.extra.min, card.ability.extra.max)

        if result == 100 then
            play_sound('kaliimoddy_multiball')
        elseif result >= -50 and result <= -1 then
            play_sound('kaliimoddy_failpeggle')
        elseif result == 0 then
            play_sound('kaliimoddy_sigh')
        elseif result >= 90 and result <= 99 then
            play_sound('kaliimoddy_extraball')
        elseif result >= 60 and result <= 89 then
            play_sound('kaliimoddy_freeball')
        elseif result >= 25 and result <= 59 then
            play_sound('kaliimoddy_peghi')
        elseif result >= 1 and result <=24 then
            play_sound('kaliimoddy_peglo')
        end

        return {
            mult = result
        }
    end
end
}


-- Fake Transparent Joker
SMODS.Atlas{
    key = 'FakeTransparent',
    path = 'transparent.png',
    px = 71,
    py = 95,
}

SMODS.Joker {
    key = "FakeTransparent",
    blueprint_compat = false,
    rarity = 2,
    cost = 7,
    atlas = 'FakeTransparent',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = "Fake Transparent PNG Joker",
        text = {
            "All played {C:attention}glass{} cards become a",
            "{C:attention}Fake Transparent PNG{} when scored"
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_kaliimoddy_faketp
    end,
    calculate = function(self, card, context)
        if context.before and context.main_eval and not context.blueprint then
            local changed = 0
            for _, scored_card in ipairs(context.scoring_hand) do
                if SMODS.has_enhancement(scored_card, 'm_glass') then
                    scored_card:set_ability('c_base', nil, true)
                    scored_card:set_ability('m_kaliimoddy_faketp', nil, true)

                    changed = changed + 1

                    G.E_MANAGER:add_event(Event({
                        func = function()
                            scored_card:juice_up()
                            return true
                        end
                    }))
                end
            end
            if changed > 0 then
                return {
                    message = localize('k_faketp'),
                    colour = G.C.MONEY
                }
            end
        end
    end,
}







-----------------------------------------------
---------------MOD CODE END--------------------