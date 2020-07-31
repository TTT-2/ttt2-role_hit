L = LANG.GetLanguageTableReference("spanish")

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
