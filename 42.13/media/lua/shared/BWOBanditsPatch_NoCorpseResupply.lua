-- WeekOneMP runtime patch: prevent peaceful NPCs from looting weapons from corpses.
-- This intentionally does NOT modify the base `Bandits` mod files.
--
-- Strategy:
-- - Override `BanditPrograms.Weapon.Resupply` at runtime.
-- - Keep original behavior for hostile bandits.
-- - For peaceful bandits (not hostile/hostileP), skip scanning `IsoDeadBody` containers.

-- Don't hard-require Bandits' modules here: WeekOneMP can load before Bandits depending on mod order.
-- We'll attempt to require for convenience, but the patch also re-checks availability on OnGameStart.
pcall(require, "BanditCompatibility")

BWOBanditsPatch_NoCorpseResupply = BWOBanditsPatch_NoCorpseResupply or {}

local function predicateAll(item)
	return true
end

local function predicateMelee(item)
	if item and item.IsWeapon and item:IsWeapon() then
		local weaponType = WeaponType.getWeaponType(item)
		if weaponType ~= WeaponType.FIREARM and weaponType ~= WeaponType.HANDGUN then
			return true
		end
	end
	return false
end

local function isPeacefulBandit(bandit)
	if not bandit then return false end
	if not BanditBrain or not BanditBrain.Get then return false end
	local brain = BanditBrain.Get(bandit)
	if not brain then return false end
	return (not brain.hostile) and (not brain.hostileP)
end

function BWOBanditsPatch_NoCorpseResupply.Apply()
	if BWOBanditsPatch_NoCorpseResupply._applied then return end
	if not BanditPrograms or not BanditPrograms.Weapon or not BanditPrograms.Weapon.Resupply then return end
	if not BanditCompatibility then return end

	BWOBanditsPatch_NoCorpseResupply._applied = true
	BWOBanditsPatch_NoCorpseResupply._original = BanditPrograms.Weapon.Resupply

	BanditPrograms.Weapon.Resupply = function(bandit)
		local tasks = {}

		local cell = getCell()
		local zx, zy, zz = bandit:getX(), bandit:getY(), bandit:getZ()
		local isBareHands = Bandit.IsBareHands(bandit)
		local needPrimary = Bandit.NeedResupplySlot(bandit, "primary")
		local needSecondary = Bandit.NeedResupplySlot(bandit, "secondary")
		local objectList = {}
		local bestDist = 100
		local destObject

		local skipBodies = isPeacefulBandit(bandit)

		for y = -3, 3 do
			for x = -3, 3 do
				local square = cell:getGridSquare(zx + x, zy + y, zz)
				if square then

					-- loot bodies (disabled for peaceful NPCs)
					if (not skipBodies) and square:getDeadBody() then
						local objects = square:getStaticMovingObjects()
						for i = 0, objects:size() - 1 do
							local object = objects:get(i)
							if instanceof(object, "IsoDeadBody") then
								local container = object:getContainer()
								if container and not container:isEmpty() then
									table.insert(objectList, object)
								end
							end
						end
					end

					-- loot shelfs (keep for everyone)
					local objects = square:getObjects()
					for i = 0, objects:size() - 1 do
						local object = objects:get(i)
						local container = object:getContainer()
						if container and not container:isEmpty() then
							table.insert(objectList, object)
						end
					end

					for i = 1, #objectList do
						local object = objectList[i]
						local container = object:getContainer()
						local dist = math.abs(x) + math.abs(y)

						-- find melee
						if isBareHands then
							local items = ArrayList.new()
							container:getAllEvalRecurse(predicateMelee, items)
							if items:size() > 0 and dist < bestDist then
								bestDist = dist
								destObject = object
							end
						end

						-- find primary or secondary
						if needPrimary or needSecondary then
							local items = ArrayList.new()
							container:getAllEvalRecurse(predicateAll, items)
							for j = 0, items:size() - 1 do
								local item = items:get(j)
								if item:IsWeapon() then
									local weaponItem = item
									local weaponType = WeaponType.getWeaponType(weaponItem)

									if (needPrimary and weaponType == WeaponType.FIREARM) or (needSecondary and weaponType == WeaponType.HANDGUN) then
										if BanditCompatibility.UsesExternalMagazine(weaponItem) then
											local magazineType = weaponItem:getMagazineType()
											for k = 0, items:size() - 1 do
												local it2 = items:get(k)
												if it2:getFullType() == magazineType and it2:getCurrentAmmoCount() > 0 then
													bestDist = dist
													destObject = object
												end
											end
										else
											local ammoType = weaponItem:getAmmoType():getItemKey()
											for k = 0, items:size() - 1 do
												local it2 = items:get(k)
												if it2:getFullType() == ammoType then
													bestDist = dist
													destObject = object
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end

		if destObject then
			local square = destObject:getSquare()
			local lx, ly, lz = square:getX(), square:getY(), square:getZ()
			local ax, ay, az = lx, ly, lz

			if not square:isFree(false) then
				local asquare = AdjacentFreeTileFinder.Find(square, bandit)
				if asquare then
					ax, ay, az = asquare:getX(), asquare:getY(), asquare:getZ()
				end
			end
			local dist = BanditUtils.DistTo(zx, zy, ax, ay)

			if dist > 0.9 then
				local task = BanditUtils.GetMoveTask(0.01, ax + 0.5, ay + 0.5, az, "Run", dist, false)
				table.insert(tasks, task)
				return tasks
			else
				local task = { action = "LootWeapons", anim = "LootLow", time = 100, x = lx, y = ly, z = lz }
				table.insert(tasks, task)
				return tasks
			end
		end

		return tasks
	end
end

-- Apply immediately if possible, and also on game start (covers load-order differences).
BWOBanditsPatch_NoCorpseResupply.Apply()
Events.OnGameStart.Add(BWOBanditsPatch_NoCorpseResupply.Apply)


