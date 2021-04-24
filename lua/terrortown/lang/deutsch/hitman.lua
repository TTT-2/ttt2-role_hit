local L = LANG.GetLanguageTableReference("deutsch")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Auftragsmörder"
L["info_popup_" .. HITMAN.name] = [[Du bist ein Auftragsmörder!
Versuche ein paar Credits zu bekommen!]]
L["body_found_" .. HITMAN.abbr] = "Er war ein Auftragsmörder..."
L["search_role_" .. HITMAN.abbr] = "Diese Person war ein Auftragsmörder!"
L["target_" .. HITMAN.name] = "Auftragsmörder"
L["ttt2_desc_" .. HITMAN.name] = [[Der Auftragsmörder ist ein Verräter, der mit den anderen Verräter-Rollen zusammenarbeitet und dessen Ziel es ist, alle anderen Rollen (außer Verräter-Rollen) zu töten.

Er kann nur Credits sammeln indem er sein Ziel tötet.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "Du hast {amount} Aursüstungspunkt(e) für das Töten deines Zieles erhalten."
L["ttt2_hitman_target_killed"] = "Du hast dein Ziel getötet!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' ist ein Auftragsmörder!"
L["ttt2_hitman_target_died"] = "Dein Ziel ist gestorben ..."
L["info_popup_hitman_alone"] = "Du bist alleine"

L["tooltip_target_kill_score"] = "Mord: {score}"
L["target_kill_score"] = "Mord:"
L["tooltip_target_kill_score_hit_right"] = "Richtiges Ziel: {score}"
L["tooltip_target_kill_score_hit_wrong"] = "Falsches Ziel: {score}"
L["target_kill_score_hit_right"] = "Richtiges Ziel:"
L["target_kill_score_hit_wrong"] = "Falsches Ziel:"
L["desc_target_kill_hit_right"] = "Er wurde von einem Auftragsmörder umgebracht. Es war das richtige Ziel."
L["desc_target_kill_hit_wrong"] = "Er wurde von einem Auftragsmörder umgebracht. Es war das falsche Ziel."
