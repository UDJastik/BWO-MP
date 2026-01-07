-- WeekOneMP runtime patch: prevent Bandits' ApplyVisuals() from stripping clothes on corpses.
-- This intentionally does NOT modify the base `Bandits` mod files.
--
-- Why this is needed:
-- Bandits' `Bandit.ApplyVisuals()` clears item visuals and worn items BEFORE checking `brain.cid`.
-- If ApplyVisuals() runs on a dead bandit / corpse, it can wipe clothing visuals ("naked corpse" bug).
--
-- Strategy:
-- - Wrap `Bandit.ApplyVisuals` at runtime.
-- - For non-bandits (no brain.cid) and dead bandits (dead/health<=0), return early.
-- - Keep original behavior for living bandits.

BWOBanditsPatch_NoCorpseUndress = BWOBanditsPatch_NoCorpseUndress or {}

function BWOBanditsPatch_NoCorpseUndress.Apply()
	if BWOBanditsPatch_NoCorpseUndress._applied then return end
	if not Bandit or not Bandit.ApplyVisuals then return end

	BWOBanditsPatch_NoCorpseUndress._applied = true
	BWOBanditsPatch_NoCorpseUndress._original = Bandit.ApplyVisuals

	Bandit.ApplyVisuals = function(bandit, brain)
		-- [FIX] Don't touch visuals for non-bandits
		if not brain or not brain.cid then return end

		-- [FIX] Don't touch visuals for corpses / dead bandits (prevents clearing worn items on dead bodies)
		if bandit and (bandit:isDead() or (bandit.getHealth and bandit:getHealth() <= 0)) then
			return
		end

		return BWOBanditsPatch_NoCorpseUndress._original(bandit, brain)
	end
end

-- Apply immediately if possible, and also on game start (covers load-order differences).
BWOBanditsPatch_NoCorpseUndress.Apply()
Events.OnGameStart.Add(BWOBanditsPatch_NoCorpseUndress.Apply)




