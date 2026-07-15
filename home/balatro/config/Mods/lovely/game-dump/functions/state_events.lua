function win_game()
    if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
        set_joker_win()
        set_deck_win()
        
        check_and_set_high_score('win_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_and_set_high_score('current_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_for_unlock({type = 'win_no_hand'})
        check_for_unlock({type = 'win_no'})
        check_for_unlock({type = 'win_custom'})
        check_for_unlock({type = 'win_deck'})
        check_for_unlock({type = 'win_stake'})
        check_for_unlock({type = 'win'})
        inc_career_stat('c_wins', 1)
    end

    set_profile_progress()

    if G.GAME.challenge then
        G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[G.GAME.challenge] = true
        set_challenge_unlock()
        check_for_unlock({type = 'win_challenge'})
        G:save_settings()
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            for k, v in pairs(G.I.CARD) do
                v.sticker_run = nil
            end
            
            play_sound('win')
            G.SETTINGS.paused = true

            G.FUNCS.overlay_menu{
                definition = create_UIBox_win(),
                config = {no_esc = true}
            }
            local Jimbo = nil

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 2.5,
                blocking = false,
                func = (function()
                    if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then 
                        local quip, extra = SMODS.quip("win")
                        extra.x = 0
                        extra.y = 5
                        Jimbo = Card_Character(extra)
                        local spot = G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot')
                        spot.config.object:remove()
                        spot.config.object = Jimbo
                        Jimbo.ui_object_updated = true
                        Jimbo:add_speech_bubble(quip, nil, {quip = true}, extra)
                        Jimbo:say_stuff((extra and extra.times) or 5, false, quip)
                        if G.F_JAN_CTA then 
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    Jimbo:add_button(localize('b_wishlist'), 'wishlist_steam', G.C.DARK_EDITION, nil, true, 1.6)
                                    return true
                                end}))
                        end
                        end
                    return true
                end)
            }))
            
            return true
        end)
    }))

    if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
        G.PROFILES[G.SETTINGS.profile].stake = math.max(G.PROFILES[G.SETTINGS.profile].stake or 1, (G.GAME.stake or 1)+1)
    end
    G:save_progress()
    G.FILE_HANDLER.force = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            if not G.SETTINGS.paused then
                G.GAME.current_round.round_text = 'Endless Round '
                return true
            end
        end)
    }))
end

function end_round()
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        G.GAME.blind.in_blind = false
        local game_over = true
        local game_won = false
        G.RESET_BLIND_STATES = true
        G.RESET_JIGGLES = true
            if G.GAME.chips - G.GAME.blind.chips >= 0 then
                game_over = false
            end
            -- context.end_of_round calculations
            SMODS.saved = false
            G.GAME.saved_text = nil
            SMODS.last_hand = SMODS.last_hand or {scoring_hand = {}, full_hand = {}}
            SMODS.calculate_context({end_of_round = true, game_over = game_over, beat_boss = G.GAME.blind.boss, scoring_hand = SMODS.last_hand.scoring_hand, scoring_name = SMODS.last_hand.scoring_name, full_hand = SMODS.last_hand.full_hand })
            if SMODS.saved then game_over = false end
            -- TARGET: main end_of_round evaluation
            if not G.GAME.won and G.GAME.round_resets.ante >= G.GAME.win_ante and G.GAME.blind_on_deck == 'Boss' then
                game_won = true
                G.GAME.won = true
            end
            if game_over then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            else
                G.GAME.unused_discards = (G.GAME.unused_discards or 0) + G.GAME.current_round.discards_left
                if G.GAME.blind and G.GAME.blind.config.blind then 
                    discover_card(G.GAME.blind.config.blind)
                end

                if G.GAME.blind:get_type() == 'Boss' then
                    local _handname, _played, _order = 'High Card', -1, 100
                    for k, v in pairs(G.GAME.hands) do
                        if v.played > _played or (v.played == _played and _order > v.order) then 
                            _played = v.played
                            _handname = k
                        end
                    end
                    G.GAME.current_round.most_played_poker_hand = _handname
                end

                if G.GAME.blind:get_type() == 'Boss' and not G.GAME.seeded and not G.GAME.challenge  then
                    G.GAME.current_boss_streak = G.GAME.current_boss_streak + 1
                    check_and_set_high_score('boss_streak', G.GAME.current_boss_streak)
                end
                
                if G.GAME.current_round.hands_played == 1 then 
                    inc_career_stat('c_single_hand_round_streak', 1)
                else
                    if not G.GAME.seeded and not G.GAME.challenge  then
                        G.PROFILES[G.SETTINGS.profile].career_stats.c_single_hand_round_streak = 0
                        G:save_settings()
                    end
                end

                check_for_unlock({type = 'round_win'})
                set_joker_usage()
                if game_won and not G.GAME.win_notified then
                    G.GAME.win_notified = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        blockable = false,
                        func = (function()
                            if G.STATE == G.STATES.ROUND_EVAL then 
                                win_game()
                                G.GAME.won = true
                                return true
                            end
                        end)
                    }))
                end
                for _,v in ipairs(SMODS.get_card_areas('playing_cards', 'end_of_round')) do
                    SMODS.calculate_end_of_round_effects({ cardarea = v, end_of_round = true, beat_boss = G.GAME.blind.boss })
                end



                G.FUNCS.draw_from_hand_to_discard()
                if G.GAME.blind:get_type() == 'Boss' then
                    G.GAME.voucher_restock = nil
                    for k, v in pairs(G.GAME.hands) do
                        v.played_this_ante = 0
                    end
                    if G.GAME.modifiers.set_eternal_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_eternal_ante) then 
                        for k, v in ipairs(G.jokers.cards) do
                            v:set_eternal(true)
                        end
                    end
                    if G.GAME.modifiers.set_joker_slots_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_joker_slots_ante) then 
                        G.jokers.config.card_limit = 0
                    end
                    delay(0.4); SMODS.ante_end = true; ease_ante(1); SMODS.ante_end = nil; delay(0.4); check_for_unlock({type = 'ante_up', ante = G.GAME.round_resets.ante + 1})
                end
                G.FUNCS.draw_from_discard_to_deck()
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        G.STATE = G.STATES.ROUND_EVAL
                        G.STATE_COMPLETE = false

                        if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
                            G.GAME.round_resets.blind_states.Small = 'Defeated'
                        elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
                            G.GAME.round_resets.blind_states.Big = 'Defeated'
                        else
                            G.GAME.current_round.voucher = SMODS.get_next_vouchers()
                            G.GAME.round_resets.blind_states.Boss = 'Defeated'
                            for k, v in ipairs(G.playing_cards) do
                                v.ability.played_this_ante = nil
                            end
                        end

                        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
                        if G.GAME.round_resets.temp_reroll_cost then G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true) end

                        reset_idol_card()
                        reset_mail_rank()
                        reset_ancient_card()
                        reset_castle_card()                        
                        for _, mod in ipairs(SMODS.mod_list) do
                        	if mod.reset_game_globals and type(mod.reset_game_globals) == 'function' then
                        		mod.reset_game_globals(false)
                        	end
                        end
                        for k, v in ipairs(G.playing_cards) do
                            v.ability.discarded = nil
                            v.ability.forced_selection = nil
                        end
                    return true
                    end
                }))
            end
        return true
      end
    }))
  end
  
function new_round()
    G.RESET_JIGGLES = nil
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
            G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
            G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            G.GAME.current_round.hands_played = 0
            G.GAME.current_round.discards_used = 0
            G.GAME.current_round.any_hand_drawn = nil
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}

            for k, v in pairs(G.GAME.hands) do 
                v.played_this_round = 0
            end

            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end

            G.GAME.current_round.free_rerolls = G.GAME.round_resets.free_rerolls
            calculate_reroll_cost(true)

            G.GAME.round_bonus.next_hands = 0
            G.GAME.round_bonus.discards = 0

            local blhash = ''
            if G.GAME.round_resets.blind == G.P_BLINDS.bl_small then
                G.GAME.round_resets.blind_states.Small = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'S'
            elseif G.GAME.round_resets.blind == G.P_BLINDS.bl_big then
                G.GAME.round_resets.blind_states.Big = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'B'
            else
                G.GAME.round_resets.blind_states.Boss = 'Current'
                blhash = 'L'
            end
            G.GAME.subhash = (G.GAME.round_resets.ante)..(blhash)

            G.GAME.blind:set_blind(G.GAME.round_resets.blind)
            
            SMODS.calculate_context({setting_blind = true, blind = G.GAME.round_resets.blind})
            
            -- TARGET: setting_blind effects
            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.DRAW_TO_HAND
                    G.deck:shuffle('nr'..G.GAME.round_resets.ante)
                    G.deck:hard_set_T()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
            end
        }))
end

G.FUNCS.draw_from_deck_to_hand = function(e)
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        G.hand.config.card_limit <= 0 and #G.hand.cards == 0 then 
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
        return true
    end

    local hand_space = e
    local cards_to_draw = {}
    local space_taken = 0
    local limit = (G.hand.config.card_limit - #G.hand.cards - (SMODS.cards_to_draw or 0))
    local flags = SMODS.calculate_context({drawing_cards = true, amount = math.max(limit, 0)})
    limit = flags.cards_to_draw or flags.modify or limit
    local unfixed = not G.hand.config.fixed_limit
    local n = 0
    while n < #G.deck.cards and limit > 0 do
        local card = G.deck.cards[#G.deck.cards-n]
        local mod = unfixed and (card.ability.card_limit - card.ability.extra_slots_used) or 0
        if limit - 1 + mod < 0 then
        else    
            limit = limit - 1 + mod
            table.insert(cards_to_draw, card)
            space_taken = space_taken + (1 - mod)
        end
        n = n + 1
    end
    hand_space = #cards_to_draw
    if G.GAME.blind.name == 'The Serpent' and
        G.STATE == G.STATES.DRAW_TO_HAND and
        not G.GAME.blind.disabled and
        (G.GAME.current_round.hands_played > 0 or
        G.GAME.current_round.discards_used > 0) then
            G.hand.config.card_limits.blind_restriction = hand_space - math.min(#G.deck.cards, 3)
            hand_space = math.min(#G.deck.cards, 3)
    end
    delay(0.3)
    SMODS.cards_to_draw = (SMODS.cards_to_draw or 0) + hand_space
    SMODS.drawn_cards = {}
    for i=1, hand_space do --draw cards from deckL
        if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK then 
            if cards_to_draw[i] and cards_to_draw[i].ability and cards_to_draw[i].ability.extra_slots_used then
                SMODS.cards_to_draw = SMODS.cards_to_draw + cards_to_draw[i].ability.extra_slots_used
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()                
                        SMODS.cards_to_draw = SMODS.cards_to_draw - cards_to_draw[i].ability.extra_slots_used
                        return true
                    end
                }))
            end
            draw_card(G.deck,G.hand, i*100/hand_space,'up', true, cards_to_draw[i])
        else
            if cards_to_draw[i] and cards_to_draw[i].ability and cards_to_draw[i].ability.extra_slots_used then
                SMODS.cards_to_draw = SMODS.cards_to_draw + cards_to_draw[i].ability.extra_slots_used
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()                
                        SMODS.cards_to_draw = SMODS.cards_to_draw - cards_to_draw[i].ability.extra_slots_used
                        return true
                    end
                }))
            end
            draw_card(G.deck,G.hand, i*100/hand_space,'up', true, cards_to_draw[i])
        end
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()                
            SMODS.cards_to_draw = SMODS.cards_to_draw - hand_space
            return true
        end
    }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if #SMODS.drawn_cards > 0 then
                SMODS.calculate_context({first_hand_drawn = not G.GAME.current_round.any_hand_drawn and G.GAME.facing_blind,
                                        hand_drawn = G.GAME.facing_blind and SMODS.drawn_cards,
                                        other_drawn = not G.GAME.facing_blind and SMODS.drawn_cards})
                SMODS.drawn_cards = {}
                if G.GAME.facing_blind then G.GAME.current_round.any_hand_drawn = true end
            end
            return true
        end
    }))
end

G.FUNCS.discard_cards_from_highlighted = function(e, hook)
    stop_use()
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end

    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
    local highlighted_count = math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards)
    if highlighted_count > 0 then 
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        for name, parameter in pairs(SMODS.Scoring_Parameters) do
            update_hand_text({immediate = true, nopulse = true, delay = 0}, {[name] = parameter.default_value})
        end
        table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)
        inc_career_stat('c_cards_discarded', highlighted_count)
        SMODS.calculate_context({pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
        
        -- TARGET: pre_discard
        local cards = {}
        local destroyed_cards = {}
        for i=1, highlighted_count do
            G.hand.highlighted[i]:calculate_seal({discard = true})
            local removed = false
            local effects = {}
            SMODS.calculate_context({discard = true, other_card =  G.hand.highlighted[i], full_hand = G.hand.highlighted, ignore_other_debuff = true}, effects)
            SMODS.trigger_effects(effects)
            for _, eval in pairs(effects) do
                if type(eval) == 'table' then
                    for key, eval2 in pairs(eval) do
                        if key == 'remove' or (type(eval2) == 'table' and eval2.remove) then removed = true end
                    end
                end
            end
            table.insert(cards, G.hand.highlighted[i])
            if removed then
                destroyed_cards[#destroyed_cards + 1] = G.hand.highlighted[i]
                if SMODS.shatters(G.hand.highlighted[i]) then
                    G.hand.highlighted[i]:shatter()
                else
                    G.hand.highlighted[i]:start_dissolve()
                end
            else 
                G.hand.highlighted[i].ability.discarded = true
                draw_card(G.hand, G.discard, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
            end
        end

        -- context.remove_playing_cards from discard
        if destroyed_cards[1] then
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
        end
        
        -- TARGET: effects after cards destroyed in discard

        G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
        check_for_unlock({type = 'discard_custom', cards = cards})
        if not hook then
            if G.GAME.modifiers.discard_cost then
                ease_dollars(-G.GAME.modifiers.discard_cost)
            end
            ease_discard(-1)
            G.GAME.current_round.discards_used = G.GAME.current_round.discards_used + 1
            G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        end
    end
end
  
G.FUNCS.play_cards_from_highlighted = function(e)
    if G.play and G.play.cards[1] then return end
    --check the hand first

    stop_use()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    
    table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    inc_career_stat('c_cards_played', #G.hand.highlighted)
    inc_career_stat('c_hands_played', 1)
    ease_hands_played(-1)
    delay(0.4)

        for i=1, #G.hand.highlighted do
            if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
            G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
            -- removed by SMODS
            G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
            draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
        end

        check_for_unlock({type = 'run_card_replays'})

        if G.GAME.blind:press_play() then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    SMODS.juice_up_blind()
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                check_for_unlock({type = 'hand_contents', cards = G.play.cards})

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.FUNCS.evaluate_play()
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        check_for_unlock({type = 'play_all_hearts'})
                        G.FUNCS.draw_from_play_to_discard()
                        G.GAME.hands_played = G.GAME.hands_played + 1
                        G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
                return true
            end)
        }))
end

-- Function overridden by SMODS in src/overrides.lua
G.FUNCS.get_poker_hand_info = function(_cards)
    local poker_hands = evaluate_poker_hand(_cards)
    local scoring_hand = {}
    local text,disp_text,loc_disp_text = 'NULL','NULL', 'NULL'
    if next(poker_hands["Flush Five"]) then text = "Flush Five"; scoring_hand = poker_hands["Flush Five"][1]
    elseif next(poker_hands["Flush House"]) then text = "Flush House"; scoring_hand = poker_hands["Flush House"][1]
    elseif next(poker_hands["Five of a Kind"]) then text = "Five of a Kind"; scoring_hand = poker_hands["Five of a Kind"][1]
    elseif next(poker_hands["Straight Flush"]) then text = "Straight Flush"; scoring_hand = poker_hands["Straight Flush"][1]
    elseif next(poker_hands["Four of a Kind"]) then text = "Four of a Kind"; scoring_hand = poker_hands["Four of a Kind"][1]
    elseif next(poker_hands["Full House"]) then text = "Full House"; scoring_hand = poker_hands["Full House"][1]
    elseif next(poker_hands["Flush"]) then text = "Flush"; scoring_hand = poker_hands["Flush"][1]
    elseif next(poker_hands["Straight"]) then text = "Straight"; scoring_hand = poker_hands["Straight"][1]
    elseif next(poker_hands["Three of a Kind"]) then text = "Three of a Kind"; scoring_hand = poker_hands["Three of a Kind"][1]
    elseif next(poker_hands["Two Pair"]) then text = "Two Pair"; scoring_hand = poker_hands["Two Pair"][1]
    elseif next(poker_hands["Pair"]) then text = "Pair"; scoring_hand = poker_hands["Pair"][1]
    elseif next(poker_hands["High Card"]) then text = "High Card"; scoring_hand = poker_hands["High Card"][1] end

    disp_text = text
    if text =='Straight Flush' then
        local min = 10
        for j = 1, #scoring_hand do
            if scoring_hand[j]:get_id() < min then min =scoring_hand[j]:get_id() end
        end
        if min >= 10 then 
            disp_text = 'Royal Flush'
        end
    end
    loc_disp_text = localize(disp_text, 'poker_hands')
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end
  
G.FUNCS.evaluate_play = function(e)
    local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
    
    G.GAME.hands[text].played = G.GAME.hands[text].played + 1
    G.GAME.hands[text].played_this_round = G.GAME.hands[text].played_this_round + 1
    G.GAME.hands[text].played_this_ante = G.GAME.hands[text].played_this_ante + 1
    G.GAME.last_hand_played = text
    set_hand_usage(text)
    G.GAME.hands[text].visible = true

    local final_scoring_hand = {}
    for i=1, #G.play.cards do
        local splashed = SMODS.always_scores(G.play.cards[i]) or next(find_joker('Splash'))
        local unsplashed = SMODS.never_scores(G.play.cards[i])
        if not splashed then
            for _, card in pairs(scoring_hand) do
                if card == G.play.cards[i] then splashed = true end
            end
        end
        local effects = {}
        SMODS.calculate_context({modify_scoring_hand = true, other_card =  G.play.cards[i], full_hand = G.play.cards, scoring_hand = scoring_hand, in_scoring = true, ignore_other_debuff = true}, effects)
        local flags = SMODS.trigger_effects(effects, G.play.cards[i])
        if flags.add_to_hand then splashed = true end
    	if flags.remove_from_hand then unsplashed = true end
        if splashed and not unsplashed then table.insert(final_scoring_hand, G.play.cards[i]) end
    end
    -- TARGET: adding to hand effects
    scoring_hand = final_scoring_hand
    delay(0.2)
    for i=1, #scoring_hand do
        --Highlight all the cards used in scoring and play a sound indicating highlight
        highlight_card(scoring_hand[i],(i-0.999)/5,'up')
    end

    percent = 0.3
    percent_delta = 0.08

    if G.GAME.current_round.current_hand.handname ~= disp_text then delay(0.3) end
    update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = nil,
                delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = G.GAME.hands[text].mult, chips = G.GAME.hands[text].chips})
    
for name, parameter in pairs(SMODS.Scoring_Parameters) do
    if name ~= 'chips' and name ~= 'mult' then update_hand_text({immediate = true}, {[name] = parameter.current}) end
end
SMODS.displayed_hand = text
SMODS.displaying_scoring = true

    if not G.GAME.blind:debuff_hand(G.play.cards, poker_hands, text) then
        mult = mod_mult(G.GAME.hands[text].mult)
        hand_chips = mod_chips(G.GAME.hands[text].chips)

        check_for_unlock({type = 'hand', handname = text, disp_text = non_loc_disp_text, scoring_hand = scoring_hand, full_hand = G.play.cards})

        delay(0.4)

        if G.GAME.first_used_hand_level and G.GAME.first_used_hand_level > 0 then
            level_up_hand(G.deck.cards[1], text, nil, G.GAME.first_used_hand_level)
            G.GAME.first_used_hand_level = nil
        end

        local hand_text_set = false
        -- context.before calculations
        if SMODS.last_hand then
            for _, v in ipairs({'scoring_hand', 'full_hand'}) do
                for _, _c in ipairs(SMODS.last_hand[v]) do
                    _c.ability['SMODS_'..v] = nil
                end
            end
        end
        SMODS.last_hand = {scoring_hand = scoring_hand, scoring_name = text, full_hand = G.play.cards}
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, before = true})
        
        -- TARGET: effects before scoring starts
        
        SMODS.displayed_hand = nil

        mult = mod_mult(G.GAME.hands[text].mult)
        hand_chips = mod_chips(G.GAME.hands[text].chips)

        local modded = false

        mult, hand_chips, modded = G.GAME.blind:modify_hand(G.play.cards, poker_hands, text, mult, hand_chips, scoring_hand)
        mult, hand_chips = mod_mult(mult), mod_chips(hand_chips)
        if modded then update_hand_text({sound = 'chips2', modded = modded}, {chips = hand_chips, mult = mult}) end
        SMODS.calculate_context({initial_scoring_step = true, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands})
        for _, v in ipairs(SMODS.get_card_areas('playing_cards')) do
            SMODS.calculate_main_scoring({cardarea = v, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands}, v == G.play and scoring_hand or nil)
        end
        delay(0.3)
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        percent = percent + percent_delta
        for _, area in ipairs(SMODS.get_card_areas('jokers')) do for _, _card in ipairs(area.cards) do
            local effects = {}
            -- remove base game joker edition calc
            local eval = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true, pre_joker = true})
            if eval.edition then effects[#effects+1] = eval end
            

            -- Calculate context.joker_main
            local joker_eval, post = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true})
            if next(joker_eval) then
                if joker_eval.edition then joker_eval.edition = {} end
                table.insert(effects, joker_eval)
                for _, v in ipairs(post) do effects[#effects+1] = v end
                if joker_eval.retriggers then
                    for rt = 1, #joker_eval.retriggers do
                        local rt_eval, rt_post = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true, retrigger_joker = true})
                        if next(rt_eval) then
                            table.insert(effects, {retriggers = joker_eval.retriggers[rt]})
                            table.insert(effects, rt_eval)
                            for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                        end
                    end
                end
            end

            -- Calculate context.other_joker effects
            for _, _area in ipairs(SMODS.get_card_areas('jokers')) do
                for _, _joker in ipairs(_area.cards) do
                    local other_key = 'other_unknown'
                    if _card.ability.set == 'Joker' then other_key = 'other_joker' end
                    if _card.ability.consumeable then other_key = 'other_consumeable' end
                    if _card.ability.set == 'Voucher' then other_key = 'other_voucher' end
                    -- TARGET: add context.other_something identifier to your cards
                    local joker_eval,post = eval_card(_joker, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, other_main = _card })
                    if next(joker_eval) then
                        if joker_eval.edition then joker_eval.edition = {} end
                        joker_eval.jokers.juice_card = _joker
                        table.insert(effects, joker_eval)
                        for _, v in ipairs(post) do effects[#effects+1] = v end
                        if joker_eval.retriggers then
                            for rt = 1, #joker_eval.retriggers do
                                local rt_eval, rt_post = eval_card(_joker, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, retrigger_joker = true})
                                if next(rt_eval) then
                                    table.insert(effects, {retriggers = joker_eval.retriggers[rt]})
                                    table.insert(effects, rt_eval)
                                    for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                                end
                            end
                        end
                    end
                end
            end
            for _, _area in ipairs(SMODS.get_card_areas('individual')) do
                local other_key = 'other_unknown'
                if _card.ability.set == 'Joker' then other_key = 'other_joker' end
                if _card.ability.consumeable then other_key = 'other_consumeable' end
                if _card.ability.set == 'Voucher' then other_key = 'other_voucher' end
                -- TARGET: add context.other_something identifier to your cards
                local _eval,post = SMODS.eval_individual(_area, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, other_main = _card })
                if next(_eval) then
                    _eval.individual.juice_card = _area.scored_card
                    table.insert(effects, _eval)
                    for _, v in ipairs(post) do effects[#effects+1] = v end
                    if _eval.retriggers then
                        for rt = 1, #_eval.retriggers do
                            local rt_eval, rt_post = SMODS.eval_individual(_area, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, retrigger_joker = true})
                            if next(rt_eval) then
                                table.insert(effects, {_eval.retriggers[rt]})
                                table.insert(effects, rt_eval)
                                for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                            end
                        end
                    end
                end
            end

            -- calculate edition multipliers
            local eval = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true, post_joker = true})
            if eval.edition then effects[#effects+1] = eval end

            SMODS.trigger_effects(effects, _card)
        end end

        --- context.main_scoring for individual area calculations
        for _, _area in ipairs(SMODS.get_card_areas('individual')) do
            local effects = {}
            -- Calculate context.main_scoring for individual areas
            local _eval, post = SMODS.eval_individual(_area, { full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, main_scoring = true })
            if next(_eval) then
                table.insert(effects, _eval)
                _eval.individual.juice_card = _area.scored_card
                for _, v in ipairs(post) do effects[#effects + 1] = v end
                if _eval.retriggers then
                    for rt = 1, #_eval.retriggers do
                        local rt_eval, rt_post = SMODS.eval_individual(_area, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, main_scoring = true, retrigger_joker = true})
                        if next(rt_eval) then
                            table.insert(effects, {_eval.retriggers[rt]})
                            table.insert(effects, rt_eval)
                            for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                        end
                    end
                end
            end
        
            SMODS.trigger_effects(effects, _area.scored_card)
        end
        
        
        -- context.final_scoring_step calculations
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, final_scoring_step = true})
        
        -- TARGET: effects before deck final_scoring_step
        local nu_chip, nu_mult = G.GAME.selected_back:trigger_effect{context = 'final_scoring_step', chips = hand_chips, mult = mult}
        mult = mod_mult(nu_mult or mult)
        hand_chips = mod_chips(nu_chip or hand_chips)

        local cards_destroyed = {}
        for _,v in ipairs(SMODS.get_card_areas('playing_cards', 'destroying_cards')) do
            SMODS.calculate_destroying_cards({ full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, cardarea = v }, cards_destroyed, v == G.play and scoring_hand or nil)
        end
        
        -- context.remove_playing_cards calculations
        if cards_destroyed[1] then
            SMODS.calculate_context({scoring_hand = scoring_hand, remove_playing_cards = true, removed = cards_destroyed})
        end
        
        -- TARGET: effects when cards are removed
        


        local glass_shattered = {}
        for k, v in ipairs(cards_destroyed) do
            if v.shattered then glass_shattered[#glass_shattered+1] = v end
        end

        check_for_unlock{type = 'shatter', shattered = glass_shattered}
        
        for i=1, #cards_destroyed do
            G.E_MANAGER:add_event(Event({
                func = function()
                    if cards_destroyed[i].shattered then
                        cards_destroyed[i]:shatter()
                    else
                        cards_destroyed[i]:start_dissolve()
                    end
                  return true
                end
              }))
        end
    else
        mult = mod_mult(0)
        hand_chips = mod_chips(0)
        SMODS.displayed_hand = nil
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                if SMODS.hand_debuff_source then SMODS.hand_debuff_source:juice_up(0.3,0) else SMODS.juice_up_blind() end
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))

        play_area_status_text("Not Allowed!")--localize('k_not_allowed_ex'), true)
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Debuff Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        -- context.debuffed_hand calculations
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, debuffed_hand = true})
        
        -- TARGET: effects after hand debuffed by blind
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after',delay = 0.4,
        func = (function()  update_hand_text({delay = 0, immediate = true}, {mult = 0, chips = 0, chip_total = math.floor( SMODS.calculate_round_score() ), level = '', handname = ''});play_sound('button', 0.9, 0.6);return true end)
      }))
      for name, parameter in pairs(SMODS.Scoring_Parameters) do
          update_hand_text({delay = 0}, {[name] = parameter.default_value})
      end
      check_and_set_high_score('hand',  SMODS.calculate_round_score() )

      check_for_unlock({type = 'chip_score', chips = math.floor( SMODS.calculate_round_score() )})
   
    if  SMODS.calculate_round_score()  > 0 then 
        delay(0.8)
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function() play_sound('chips2');return true end)
        }))
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = false,
      ref_table = G.GAME,
      ref_value = 'chips',
      ease_to = G.GAME.chips + math.floor( SMODS.calculate_round_score() ),
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = true,
      ref_table = G.GAME.current_round.current_hand,
      ref_value = 'chip_total',
      ease_to = 0,
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function() G.GAME.current_round.current_hand.handname = '';return true end)
    }))
    delay(0.3)
    SMODS.last_hand_oneshot = SMODS.calculate_round_score() >= G.GAME.blind.chips
    SMODS.last_hand_score = SMODS.calculate_round_score()
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function() 
        for name, parameter in pairs(SMODS.Scoring_Parameters) do
            parameter.current = parameter.default_value
        end
        return true 
      end)
    }))
    
    SMODS.displaying_scoring = nil

    -- context.after calculations
    SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after = true})
    
    -- set `ability.played_this_ante` on played cards
    for _,v in ipairs(G.play.cards) do
        G.E_MANAGER:add_event(Event({
            func = function()
                v.ability.played_this_ante = true
                return true
            end,
        }))
    end
    
    -- TARGET: effects after hand evaluation

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()     
            if G.GAME.modifiers.debuff_played_cards then 
                for k, v in ipairs(scoring_hand) do v.ability.perma_debuff = true end
            end
        return true end)
      }))

  end
  
  G.FUNCS.draw_from_play_to_discard = function(e)
    local play_count = #G.play.cards
    local it = 1
    for k, v in ipairs(G.play.cards) do
        if (not v.shattered) and (not v.destroyed) then 
            draw_card(G.play,G.discard, it*100/play_count,'down', false, v)
            it = it + 1
        end
    end
  end

  G.FUNCS.draw_from_play_to_hand = function(cards)
    local gold_count = #cards
    for i=1, gold_count do --draw cards from play
        if not cards[i].shattered and not cards[i].destroyed then
            draw_card(G.play,G.hand, i*100/gold_count,'up', true, cards[i])
        end
    end
  end
  
  G.FUNCS.draw_from_discard_to_deck = function(e)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local discard_count = #G.discard.cards
            for i=1, discard_count do --draw cards from deck
                draw_card(G.discard, G.deck, i*100/discard_count,'up', nil ,nil, 0.005, i%2==0, nil, math.max((21-i)/20,0.7))
            end
            return true
        end
      }))
  end

  G.FUNCS.draw_from_hand_to_deck = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do --draw cards from deck
        draw_card(G.hand, G.deck, i*100/hand_count,'down', nil, nil,  0.08)
    end
  end
  
  G.FUNCS.draw_from_hand_to_discard = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do
        draw_card(G.hand,G.discard, i*100/hand_count,'down', nil, nil, 0.07)
    end
end

G.FUNCS.evaluate_round = function()
    total_cashout_rows = 0
    local pitch = 0.95
    local dollars = 0

    if G.GAME.chips - G.GAME.blind.chips >= 0 then
        add_round_eval_row({dollars = G.GAME.blind.dollars, name='blind1', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars + G.GAME.blind.dollars
    else
        add_round_eval_row({dollars = 0, name='blind1', pitch = pitch, saved = true})
        pitch = pitch + 0.06
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 1.3*math.min(G.GAME.blind.dollars+2, 7)/2*0.15 + 0.5,
        func = function()
          G.GAME.blind:defeat()
          return true
        end
      }))
    delay(0.2)
    G.E_MANAGER:add_event(Event({
        func = function()
            ease_background_colour_blind(G.STATES.ROUND_EVAL, '')
            return true
        end
    }))
    SMODS.calculate_context{round_eval = true}
    G.GAME.selected_back:trigger_effect({context = 'eval'})

    if G.GAME.current_round.hands_left > 0 and not G.GAME.modifiers.no_extra_hand_money then
        add_round_eval_row({dollars = G.GAME.current_round.hands_left*(G.GAME.modifiers.money_per_hand or 1), disp = G.GAME.current_round.hands_left, bonus = true, name='hands', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars + G.GAME.current_round.hands_left*(G.GAME.modifiers.money_per_hand or 1)
    end
    if G.GAME.current_round.discards_left > 0 and G.GAME.modifiers.money_per_discard then
        add_round_eval_row({dollars = G.GAME.current_round.discards_left*(G.GAME.modifiers.money_per_discard), disp = G.GAME.current_round.discards_left, bonus = true, name='discards', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars +  G.GAME.current_round.discards_left*(G.GAME.modifiers.money_per_discard)
    end
    local i = 0
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        for _, _card in ipairs(area.cards) do
            local ret, ret_opts = _card:calculate_dollar_bonus()
            ret_opts = ret_opts or {}
    
            -- TARGET: calc_dollar_bonus per card
            if ret then
                if not ret_opts.no_eval_row then
                    i = i+1
                    add_round_eval_row({dollars = ret, bonus = true, name='joker'..i, pitch = pitch, card = _card, loc_opts = ret_opts})
                    pitch = pitch + 0.06
                end
                dollars = dollars + ret
            end
        end
    end
    i = 0
    for _, target in ipairs(SMODS.get_card_areas('individual', 'calc_dollar_bonus')) do
        if type(target.object.calc_dollar_bonus) == 'function' then
            local ret, ret_opts = target.object:calc_dollar_bonus()
            ret_opts = ret_opts or {}
            local name
            
            -- TARGET: calc_dollar_bonus per individual object
            if ret then
                if not ret_opts.no_eval_row then
                    if ret_opts.text then
                        name = text
                    elseif (ret_opts.set or target.set) and (ret_opts.key or target.key) then
                        if ret_opts.set == "Challenge" or (not ret_opts.set and target.set == "Challenge") then
                            name = localize(ret_opts.key or target.key, 'challenge_names')
                        elseif (ret_opts.set == "Mod" or (not ret_opts.set and target.set == "Mod")) and not (G.localization.descriptions.Mod or {})[ret_opts.key or target.key] then
                            name = (SMODS.Mods[ret_opts.key or target.key] or {}).name
                        else
                            name = localize{type = 'name_text', set = ret_opts.set or target.set, key = ret_opts.key or target.key}
                        end
                    end
                    i = i+1
                    add_round_eval_row({dollars = ret, bonus = true, name='custom_individual'..i, pitch = pitch, text_colour = ret_opts.text_colour or G.C.FILTER, text = name or 'ERROR', text_scale = ret_opts.scale or 0.6})
                    pitch = pitch + 0.06
                end
                dollars = dollars + ret
            end
        end
    end
    for i = 1, #G.GAME.tags do
        local ret = G.GAME.tags[i]:apply_to_run({type = 'eval'})
        if ret then
            add_round_eval_row({dollars = ret.dollars, bonus = true, name='tag'..i, pitch = pitch, condition = ret.condition, pos = ret.pos, tag = ret.tag})
            pitch = pitch + 0.06
            dollars = dollars + ret.dollars
        end
    end
    if G.GAME.dollars >= 5 and not G.GAME.modifiers.no_interest then
        add_round_eval_row({bonus = true, name='interest', pitch = pitch, dollars = G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)})
        pitch = pitch + 0.06
        if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
            if G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5) == G.GAME.interest_amount*G.GAME.interest_cap/5 then 
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak + 1
            else
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = 0
            end
        end
        check_for_unlock({type = 'interest_streak'})
        dollars = dollars + G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/5), G.GAME.interest_cap/5)
    end

    SMODS.cashout_pitch = pitch; SMODS.cashout_index = i; SMODS.cashout_dollars = dollars
    SMODS.calculate_context({modify_final_cashout = true, amount = dollars})
    dollars = SMODS.cashout_dollars
    SMODS.cashout_pitch = nil; SMODS.cashout_index = nil; SMODS.cashout_dollars = nil

    pitch = pitch + 0.06

    if total_cashout_rows > 7 then
        local total_hidden = total_cashout_rows - 7
    
        G.E_MANAGER:add_event(Event({
            trigger = 'before',delay = 0.38,
            func = function()
                local hidden = {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.O, config={object = DynaText({
                        string = {localize{type = 'variable', key = 'cashout_hidden', vars = {total_hidden}}}, 
                        colours = {G.C.WHITE}, shadow = true, float = false, 
                        scale = 0.45,
                        font = G.LANGUAGES['en-us'].font, pop_in = 0
                    })}}
                }}
    
                G.round_eval:add_child(hidden, G.round_eval:get_UIE_by_ID('bonus_round_eval'))
                return true
            end
        }))
    end
    add_round_eval_row({name = 'bottom', dollars = dollars})
end

G.FUNCS.tutorial_controller = function()
    if G.F_SKIP_TUTORIAL then
        G.SETTINGS.tutorial_complete = true
        G.SETTINGS.tutorial_progress = nil
        return
    end
    G.SETTINGS.tutorial_progress = G.SETTINGS.tutorial_progress or 
    {
        forced_shop = {'j_joker', 'c_empress'},
        forced_voucher = 'v_grabber',
        forced_tags = {'tag_handy', 'tag_garbage'},
        hold_parts = {},
        completed_parts = {},
    }
    if not G.SETTINGS.paused and (not G.SETTINGS.tutorial_complete) then
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.tutorial_progress.completed_parts['small_blind'] then
            G.SETTINGS.tutorial_progress.section = 'small_blind'
            G.FUNCS.tutorial_part('small_blind')
            G.SETTINGS.tutorial_progress.completed_parts['small_blind']  = true
            G:save_progress()
        end
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.tutorial_progress.completed_parts['big_blind'] and G.GAME.round > 0 then
            G.SETTINGS.tutorial_progress.section = 'big_blind'
            G.FUNCS.tutorial_part('big_blind')
            G.SETTINGS.tutorial_progress.completed_parts['big_blind']  = true
            G.SETTINGS.tutorial_progress.forced_tags = nil
            G:save_progress()
        end
        if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['second_hand'] and G.SETTINGS.tutorial_progress.hold_parts['big_blind'] then
            G.SETTINGS.tutorial_progress.section = 'second_hand'
            G.FUNCS.tutorial_part('second_hand')
            G.SETTINGS.tutorial_progress.completed_parts['second_hand']  = true
            G:save_progress()
        end
        if G.SETTINGS.tutorial_progress.hold_parts['second_hand'] then
            G.SETTINGS.tutorial_complete = true
        end
        if not G.SETTINGS.tutorial_progress.completed_parts['first_hand_section'] then 
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand'] then
                G.SETTINGS.tutorial_progress.section = 'first_hand'
                G.FUNCS.tutorial_part('first_hand')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_2'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand']  then
                G.FUNCS.tutorial_part('first_hand_2')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_2']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_3'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand_2']  then
                G.FUNCS.tutorial_part('first_hand_3')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_3']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_4'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand_3']  then
                G.FUNCS.tutorial_part('first_hand_4')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_4']  = true
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_section']  = true
                G:save_progress()
            end
        end
         if G.STATE == G.STATES.SHOP and G.shop and G.shop.VT.y < 5 and not G.SETTINGS.tutorial_progress.completed_parts['shop_1'] then
            G.SETTINGS.tutorial_progress.section = 'shop'
            G.FUNCS.tutorial_part('shop_1')
            G.SETTINGS.tutorial_progress.completed_parts['shop_1']  = true
            G.SETTINGS.tutorial_progress.forced_voucher = nil
            G:save_progress()
        end
    end
end

G.FUNCS.tutorial_part = function(_part)
    local step = 1
    G.SETTINGS.paused = true
    if _part == 'small_blind' then 
        step = tutorial_info({
            text_key = 'sb_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_2',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_3',
            highlight = {
                G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('blind_desc'),
            },
            attach = {major =  G.blind_select.UIRoot.children[1].children[1], type = 'tr', offset = {x = 2, y = 4}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_4',
            highlight = {
                G.blind_select.UIRoot.children[1].children[1]
            },
            snap_to = function() 
                if G.blind_select and G.blind_select.UIRoot and G.blind_select.UIRoot.children[1] and G.blind_select.UIRoot.children[1].children[1] and G.blind_select.UIRoot.children[1].children[1].config.object then 
                    return G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('select_blind_button') end
                end,
            attach = {major =  G.blind_select.UIRoot.children[1].children[1], type = 'tr', offset = {x = 2, y = 4}},
            step = step,
            no_button = true,
            button_listen = 'select_blind'
        })
    elseif _part == 'big_blind' then 
        step = tutorial_info({
            text_key = 'bb_1',
            highlight = {
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_desc'),
            },
            hard_set = true,
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_2',
            highlight = {
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('tag_desc'),
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_3',
            highlight = {
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_desc'),
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_4',
            highlight = {
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_desc'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_extras'),
                G.HUD:get_UIE_by_ID('hud_ante')
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_5',
            loc_vars = {G.GAME.win_ante},
            highlight = {
                G.blind_select,
                G.HUD:get_UIE_by_ID('hud_ante')
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
            no_button = true,
            snap_to = function() 
                if G.blind_select and G.blind_select.UIRoot and G.blind_select.UIRoot.children[1] and G.blind_select.UIRoot.children[1].children[2] and
                G.blind_select.UIRoot.children[1].children[2].config.object then 
                    return G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('select_blind_button') end
                end,
            button_listen = 'select_blind'
        })
    elseif _part == 'first_hand' then
        step = tutorial_info({
            text_key = 'fh_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_2',
            highlight = {
                G.HUD:get_UIE_by_ID('hand_text_area')
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            highlight = {
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            no_button = true,
            button_listen = 'run_info',
            snap_to = function() return G.HUD:get_UIE_by_ID('run_info_button') end,
            step = step,
        })
    elseif _part == 'first_hand_2' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_4',
            highlight = {
                G.hand,
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            snap_to = function() return G.hand.cards[1] end,
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_5',
            highlight = {
                G.hand,
                G.buttons:get_UIE_by_ID('play_button'),
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            no_button = true,
            button_listen = 'play_cards_from_highlighted',
            step = step,
        })
    elseif _part == 'first_hand_3' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_6',
            highlight = {
                G.hand,
                G.buttons:get_UIE_by_ID('discard_button'),
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            no_button = true,
            button_listen = 'discard_cards_from_highlighted',
            step = step,
        })
    elseif _part == 'first_hand_4' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_7',
            highlight = {
                G.HUD:get_UIE_by_ID('hud_hands').parent,
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_8',
            highlight = {
                G.HUD:get_UIE_by_ID('hud_hands').parent,
                G.HUD:get_UIE_by_ID('row_dollars_chips'),
                G.HUD_blind
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    elseif _part == 'second_hand' then
        step = tutorial_info({
            text_key = 'sh_1',
            hard_set = true,
            highlight = {
                G.jokers
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        local empress = find_joker('The Empress')[1]
        if empress then 
            step = tutorial_info({
                text_key = 'sh_2',
                highlight = {
                    empress
                },
                attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
                step = step,
            })
            step = tutorial_info({
                text_key = 'sh_3',
                attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
                highlight = {
                    empress,
                    G.hand
                },
                no_button = true,
                button_listen = 'use_card',
                snap_to = function() return G.hand.cards[1] end,
                step = step,
            })
        end
    elseif _part == 'shop_1' then
        step = tutorial_info({
            hard_set = true,
            text_key = 's_1',
            highlight = {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent
            },
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 4}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_2',
            highlight = {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_jokers.cards[2],
            },
            snap_to = function() return G.shop_jokers.cards[2] end,
            attach = {major = G.shop, type = 'tr', offset = {x = -0.5, y = 6}},
            no_button = true,
            button_listen = 'buy_from_shop',
            step = step,
        })
        step = tutorial_info({
            text_key = 's_3',
            loc_vars = {#G.P_CENTER_POOLS.Joker},
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers.cards[1],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_4',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers.cards[1],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_5',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers,
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_6',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_jokers.cards[1],
            } end,
            snap_to = function() return G.shop_jokers.cards[1] end,
            no_button = true,
            button_listen = 'buy_from_shop',
            attach = {major = G.shop, type = 'tr', offset = {x = -0.5, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_7',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.consumeables.cards[#G.consumeables.cards],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_8',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.consumeables
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_9',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_vouchers,
            } end,
            snap_to = function() return G.shop_vouchers.cards[1] end,
            attach = {major = G.shop, type = 'tr', offset = {x = -4, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_10',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_vouchers,
            } end,
            attach = {major = G.shop, type = 'tr', offset = {x = -4, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_11',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_booster,
            } end,
            snap_to = function() return G.shop_booster.cards[1] end,
            attach = {major = G.shop, type = 'tl', offset = {x = 3, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_12',
            highlight = function() return {
                G.shop:get_UIE_by_ID('next_round_button'),
            } end,
            snap_to = function() if G.shop then return G.shop:get_UIE_by_ID('next_round_button') end end,
            no_button = true,
            button_listen = 'toggle_shop',
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
    end

    
    G.E_MANAGER:add_event(Event({
        blockable = false,
        timer = 'REAL',
        func = function()
            if (G.OVERLAY_TUTORIAL.step == step and
            not G.OVERLAY_TUTORIAL.step_complete) or G.OVERLAY_TUTORIAL.skip_steps then
                if G.OVERLAY_TUTORIAL.Jimbo then G.OVERLAY_TUTORIAL.Jimbo:remove() end
                if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
                G.OVERLAY_TUTORIAL:remove()
                G.OVERLAY_TUTORIAL = nil
                G.SETTINGS.tutorial_progress.hold_parts[_part]=true
                return true
            end
            return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
        end
    }), 'tutorial') 
    G.SETTINGS.paused = false
end
