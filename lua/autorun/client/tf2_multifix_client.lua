
--Particle mounting, by parsing the TF2 particle manifest

local function ParseManifest(manifest)
	for _,line in ipairs(manifest) do
		if string.match(line,"file") then
			local particle = string.match(line, "particles/.*%.pcf")
			if particle != nil then
				if GetConVar("developer"):GetString() == "1" then
					print("[TF2 Multi-Fix] Adding particle: ",particle,"\n---------------")
				end
				game.AddParticles(particle)
			end
		end
	end
end

local function TF2ParticleFix()
	if !IsMounted("tf") then return end
	--Main particle manifest loading
	local manifest = string.Split(file.Read("particles/particles_manifest.txt", "tf"), "\n")
	MsgN("[TF2 Multi-Fix] Caching particles...")
	ParseManifest(manifest)
	--Map particle manifest loading
	if file.Exists("maps/"..game.GetMap().."_particles.txt", "BSP") then
		MsgN("[TF2 Multi-Fix] Caching map-specific particles...")
		local manifest_map = string.Split(file.Read("maps/"..game.GetMap().."_particles.txt", "BSP"), "\n")
		ParseManifest(manifest_map)
	else
		MsgN("[TF2 Multi-Fix] No map specific particle manifest detected, skipping")
	end
end
hook.Add("Initialize", "TF2ParticleFix", function() timer.Simple(2.5, function() TF2ParticleFix() end) end)

hook.Add("OnEntityCreated", "TF2ShotgunFix", function (ent)
	if !IsValid(ent) then return end
	if (string.StartsWith(ent:GetClass(), "prop_") && ent:GetModel() == "models/weapons/w_models/w_shotgun.mdl") then
		ent:SetMaterial("tf_replacements/weapon_shotgun")
	end
end)
