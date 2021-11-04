local L = LANG.GetLanguageTableReference("en")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "Hitman"
L["info_popup_" .. HITMAN.name] = [[You are a Hitman!
Try to get some credits!]]
L["body_found_" .. HITMAN.abbr] = "They were a Hitman!"
L["search_role_" .. HITMAN.abbr] = "This person was a Hitman!"
L["target_" .. HITMAN.name] = "Hitman"
L["ttt2_desc_" .. HITMAN.name] = [[The Hitman is a Traitor working together with the other traitors with the goal of killing all other non-traitor players.

The Hitman is only able to collect credits if he kills his target.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "You received {amount} credit(s) for eliminating your target."
L["ttt2_hitman_target_killed"] = "You've killed your target!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' is a Hitman!"
L["ttt2_hitman_target_died"] = "Your target died..."

L["tooltip_target_kill_score"] = "Kill: {score}"
L["target_kill_score"] = "Kill:"
L["tooltip_target_kill_score_suicide"] = "Suicide: {score}"
L["target_kill_score_suicide"] = "Suicide:"
L["tooltip_target_kill_score_team"] = "Team kill: {score}"
L["target_kill_score_team"] = "Team kill:"
L["tooltip_target_kill_score_hit_right"] = "Correct target: {score}"
L["tooltip_target_kill_score_hit_wrong"] = "Wrong target: {score}"
L["target_kill_score_hit_right"] = "Correct target:"
L["target_kill_score_hit_wrong"] = "Wrong target:"
L["desc_target_kill_hit_right"] = "They were killed by a hitman. It was the correct target."
L["desc_target_kill_hit_wrong"] = "They were killed by a hitman. It was the wrong target."

L["label_hitman_target_credit_bonus"] = "Credit reward for killed target"
L["label_hitman_target_chatreveal"] = "Reveal role if wrong player was killed"
L["label_hitman_target_right_score_bonus"] = "Score bonus for target kill"
L["label_hitman_target_wrong_score_penalty"] = "Score penalty for non-target kill"
