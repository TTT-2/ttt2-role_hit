local L = LANG.GetLanguageTableReference("es")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Asesino"
L["info_popup_" .. HITMAN.name] = [[¡Eres un Asesino!
¡Intenta ganar algunos créditos!]]
L["body_found_" .. HITMAN.abbr] = "¡Era un Asesino!"
L["search_role_" .. HITMAN.abbr] = "Esta persona era un Asesino."
L["target_" .. HITMAN.name] = "Asesino"
L["ttt2_desc_" .. HITMAN.name] = [[El Asesino es un traidor que mata a su objetivo para obtener equipamiento especial.

Matar a jugadores que no son tu objetivo hará que nunca puedas comprar tus preciados objetos.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "Has recibido {amount} crédito(s) por eliminar a tu objetivo."
L["ttt2_hitman_target_killed"] = "¡Has asesinado a tu objetivo!"
L["ttt2_hitman_chat_reveal"] = "¡'{playername}' es un Asesino!"
L["ttt2_hitman_target_died"] = "Tu objetivo murió..."

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
