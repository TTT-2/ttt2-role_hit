local L = LANG.GetLanguageTableReference("zh_hans")

-- GENERAL ROLE LANGUAGE STRINGS
L[HITMAN.name] = "杀手"
L["info_popup_" .. HITMAN.name] = [[你是个杀手!

试着获得一些学分!]]
L["body_found_" .. HITMAN.abbr] = "他们是杀手!"
L["search_role_" .. HITMAN.abbr] = "这个人是杀手!"
L["target_" .. HITMAN.name] = "杀手"
L["ttt2_desc_" .. HITMAN.name] = [[杀手是一个叛徒,与其他叛徒一起工作,目的是杀死所有其他非叛徒玩家.

杀手只有在杀死目标后才能获得学分.]]

-- OTHER ROLE LANGUAGE STRINGS
L["ttt2_hitman_target_killed_credits"] = "您因消除目标而获得{amount}个学分."
L["ttt2_hitman_target_killed"] = "你杀了你的目标!"
L["ttt2_hitman_chat_reveal"] = "'{playername}' 是个杀手!"
L["ttt2_hitman_target_died"] = "你的目标死了..."
L["ttt2_hitman_target_unavailable"] = "没有可用的目标玩家."

L["tooltip_target_kill_score"] = "击杀: {score}"
L["target_kill_score"] = "击杀:"
L["tooltip_target_kill_score_suicide"] = "自杀: {score}"
L["target_kill_score_suicide"] = "自杀:"
L["tooltip_target_kill_score_team"] = "团体击杀: {score}"
L["target_kill_score_team"] = "团体击杀:"
L["tooltip_target_kill_score_hit_right"] = "正确的目标: {score}"
L["tooltip_target_kill_score_hit_wrong"] = "错误的目标: {score}"
L["target_kill_score_hit_right"] = "正确的目标:"
L["target_kill_score_hit_wrong"] = "错误的目标:"
L["desc_target_kill_hit_right"] = "他们是被杀手杀死.这是正确的目标."
L["desc_target_kill_hit_wrong"] = "他们是被杀手杀死.这是错误的目标."

L["label_hitman_target_credit_bonus"] = "被杀目标的信用奖励"
L["label_hitman_target_chatreveal"] = "如果错误的玩家被杀,则显示角色"
L["label_hitman_target_right_score_bonus"] = "目标杀死的得分奖励"
L["label_hitman_target_wrong_score_penalty"] = "非目标杀伤得分惩罚"
