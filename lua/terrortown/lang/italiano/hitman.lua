local L = LANG.GetLanguageTableReference("italiano")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Hitman"
L["info_popup_" .. HITMAN.name] = [[Sei l'Hitman!
Prova a prendere dei crediti!]]
L["body_found_" .. HITMAN.abbr] = "Era un Hitman!"
L["search_role_" .. HITMAN.abbr] = "Questa persona era un Hitman!"
L["target_" .. HITMAN.name] = "Hitman"
L["ttt2_desc_" .. HITMAN.name] = [[L'Hitman è un Traditore che collabora con gli altri Traditori con l'obiettivo di uccidere tutti i giocatori che non fanno parte del team.

L'Hitman può prendere crediti solo se uccide il suo bersaglio.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "Hai ricevuto {amount} credito/i per aver ucciso il tuo bersaglio."
L["ttt2_hitman_target_killed"] = "Hai ucciso il tuo bersaglio!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' è un Hitman!"
L["ttt2_hitman_target_died"] = "Il tuo bersaglio è morto..."

--L["tooltip_target_kill_score"] = "Kill: {score}"
--L["target_kill_score"] = "Kill:"
--L["tooltip_target_kill_score_hit_right"] = "Correct target: {score}"
--L["tooltip_target_kill_score_hit_wrong"] = "Wrong target: {score}"
--L["target_kill_score_hit_right"] = "Correct target:"
--L["target_kill_score_hit_wrong"] = "Wrong target:"
--L["desc_target_kill_hit_right"] = "They were killed by a hitman. It was the correct target."
--L["desc_target_kill_hit_wrong"] = "They were killed by a hitman. It was the wrong target."
