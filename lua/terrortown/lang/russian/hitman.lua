local L = LANG.GetLanguageTableReference("Русский")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Хитмэн"
L["info_popup_" .. HITMAN.name] = [[Вы хитмэн!
Попытайтесь получить кредиты!]]
L["body_found_" .. HITMAN.abbr] = "Он был хитмэном!"
L["search_role_" .. HITMAN.abbr] = "Этот человек был хитмэном!"
L["target_" .. HITMAN.name] = "Хитмэн"
L["ttt2_desc_" .. HITMAN.name] = [[Хитмэн - предатель, работающий вместе с другими предателями с целью убить всех других игроков, не являющихся предателями.

Хитмэн может просто получить несколько кредитов, если убьёт свою цель.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "Вы получили {amount} кредит(а/ов) за устранение цели."
L["ttt2_hitman_target_killed"] = "Вы убили свою цель!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' хитмэн!"
L["ttt2_hitman_target_died"] = "Ваша цель умерла..."

--L["tooltip_target_kill_score"] = "Kill: {score}"
--L["target_kill_score"] = "Kill:"
--L["tooltip_target_kill_score_hit_right"] = "Correct target: {score}"
--L["tooltip_target_kill_score_hit_wrong"] = "Wrong target: {score}"
--L["target_kill_score_hit_right"] = "Correct target:"
--L["target_kill_score_hit_wrong"] = "Wrong target:"
--L["desc_target_kill_hit_right"] = "They were killed by a hitman. It was the correct target."
--L["desc_target_kill_hit_wrong"] = "They were killed by a hitman. It was the wrong target."
