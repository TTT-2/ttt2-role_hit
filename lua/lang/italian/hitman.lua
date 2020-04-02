L = LANG.GetLanguageTableReference("italian")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Sicario"
L["info_popup_" .. HITMAN.name] = [[Sei un Sicario!
Prova a prendere dei crediti!]]
L["body_found_" .. HITMAN.abbr] = "Era un Sicario!"
L["search_role_" .. HITMAN.abbr] = "Questa persona era un Sicario!"
L["target_" .. HITMAN.name] = "Sicario"
L["ttt2_desc_" .. HITMAN.name] = [[Il Sicario è un Traditore che lavora insieme agli altri traditore con lo scopo di uccidere tutti tranne i traditori.
Il Sicario può raccogliere crediti solo se uccide il suo bersaglio.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "Hai ricevuto {amount} credito/i per aver ucciso il tuo bersaglio."
L["ttt2_hitman_target_killed"] = "Hai ucciso il tuo bersaglio!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' è un Sicario!"
L["ttt2_hitman_target_died"] = "Il tuo bersaglio è morto..."
