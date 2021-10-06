local L = LANG.GetLanguageTableReference("fr")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Tueur à Gages"
L["info_popup_" .. HITMAN.name] = [[Vous êtes un Tueur à Gages!
Essayez d'obtenir des crédits!]]
L["body_found_" .. HITMAN.abbr] = "C'était un Tueur à Gages!"
L["search_role_" .. HITMAN.abbr] = "Cette personne était un Tueur à Gages!"
L["target_" .. HITMAN.name] = "Tueur à Gages"
L["ttt2_desc_" .. HITMAN.name] = [[Le Tueur à Gages est un traître qui travaille avec les autres traîtres dans le but de tuer tous les autres joueurs qui ne sont pas dans son équipe.
Le Tueur à Gages est juste capable de collecter quelques crédits s'il tue sa cible.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "Vous avez reçu {amount} crédit(s) pour avoir éliminé votre cible."
L["ttt2_hitman_target_killed"] = "Vous avez tué votre cible!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' est  un Tueur à Gages!"
L["ttt2_hitman_target_died"] = "Votre cible est morte..."

--L["tooltip_target_kill_score"] = "Kill: {score}"
--L["target_kill_score"] = "Kill:"
--L["tooltip_target_kill_score_suicide"] = "Suicide: {score}"
--L["target_kill_score_suicide"] = "Suicide:"
--L["tooltip_target_kill_score_team"] = "Team kill: {score}"
--L["target_kill_score_team"] = "Team kill:"
--L["tooltip_target_kill_score_hit_right"] = "Correct target: {score}"
--L["tooltip_target_kill_score_hit_wrong"] = "Wrong target: {score}"
--L["target_kill_score_hit_right"] = "Correct target:"
--L["target_kill_score_hit_wrong"] = "Wrong target:"
--L["desc_target_kill_hit_right"] = "They were killed by a hitman. It was the correct target."
--L["desc_target_kill_hit_wrong"] = "They were killed by a hitman. It was the wrong target."
