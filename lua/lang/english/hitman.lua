L = LANG.GetLanguageTableReference("english")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Hitman"
L["info_popup_" .. HITMAN.name] = [[You are a Hitman!
Try to get some credits!]]
L["body_found_" .. HITMAN.abbr] = "They were a Hitman!"
L["search_role_" .. HITMAN.abbr] = "This person was a Hitman!"
L["target_" .. HITMAN.name] = "Hitman"
L["ttt2_desc_" .. HITMAN.name] = [[The Hitman is a Traitor working together with the other traitors with the goal to kill all other non-traitor players.
The Hitman is just able to collect some credits if he kills his target.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "You received {amount} credit(s) for eleminating your target."
L["ttt2_hitman_target_killed"] = "You've killed your target!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' is a Hitman!"
L["ttt2_hitman_target_died"] = "Your target died..."
