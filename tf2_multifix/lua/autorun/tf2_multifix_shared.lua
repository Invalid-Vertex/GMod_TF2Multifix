
--DO NOT PARSE ANYTHING USING NIL AS THE VAR, THIS WILL CAUSE THE FUCKY
--For future reference, $basetexturetransform (scale) = Matrix():Scale(Vector(matrixscale[1],matrixscale[2],matrixscale[3]))

local function FixUpTexture(material, replacement, detail, detailscale, detailblendmode, detailblendfactor, matrixscale, flags)
	--var ref = string, string, string, float, int, float, float OR vector, int
	local matstring = material
	local material = Material(material)
	local matrix = Matrix()
	if (material == nil) then return end
	if (material != nil) then
		if (replacement == nil) then
			material:SetTexture("$basetexture", "tf_replacements/"..string.Split(matstring, "/")[2])
		else
			material:SetTexture("$basetexture", "tf_replacements/"..replacement)
		end
	end
	if (detail != nil) then material:SetTexture("$detail", "tf_replacements/"..detail) end
	if (detailscale != nil) then material:SetFloat("$detailscale", detailscale) end
	if (detailblendmode != nil) then material:SetInt("$detailblendmode",detailblendmode) end
	if (detailblendfactor != nil) then material:SetFloat("$detailblendfactor",detailblendfactor) end
	if (matrixscale != nil) then
		if (isvector(matrixscale)) then
			matrix:Scale(Vector(matrixscale[1],matrixscale[2],matrixscale[3])) material:SetMatrix("$basetexturetransform", matrix)
		else
			matrix:Scale(Vector(matrixscale,matrixscale,matrixscale)) material:SetMatrix("$basetexturetransform", matrix)
		end
	end
	if (flags != nil) then
		material:SetInt("$flags", flags)	--https://wiki.facepunch.com/gmod/Material_Flags
	else
		material:SetInt("$flags", material:GetInt("$flags"))
	end
	material:Recompute()
	if GetConVar("developer"):GetString() == "1" then
		print("[TF2 Multi-Fix] Fixing up material:",tostring(material),"\nReplacement:",replacement,"\nDetail [Texture, Scale, BlendMode, BlendFactor]:",detail,detailscale,detailblendmode,detailblendfactor,"\nMatrix Scale:",matrixscale,"\n$flags:",material:GetInt("$flags"),"\n---------------")
	end
end

--Sound fix for maps using voice lines pre TF2s ".wav -> .mp3" change
hook.Add("EntityKeyValue", "FixTF2Voices", function (ent, key, value)
	for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do
		if (ent:IsValid()) then
			if (ent:GetClass() == "ambient_generic") then
				if (key == "message") then
					if (string.StartWith(value, "vo/") and string.EndsWith(value, ".wav")) then
						return string.Replace(value, ".wav", ".mp3")
					end
				end
			end
		end
	break end
end)

--Texture fixup
local function TF2TextureFix()
	--Reference:
	--FixUpTexture(material, replacement, detail, detailscale, detailblendmode, detailblendfactor, matrixscale, flags)

	--Concrete
	FixUpTexture("concrete/concretewall001c",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall002","concretewall002a","overlays/detail001",1.9,0,1, 1.0)
	FixUpTexture("concrete/concretewall002a",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall002b",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall002c",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall004b",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall004c",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall008b",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall008c",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall011b",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall011c",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall013a",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall013b",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretewall015a",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretefloor002b",nil,"overlays/detail001",1.9,0,1, 0.5)
	FixUpTexture("concrete/concretefloor006a",nil,"overlays/detail001",1.9,0,1, 0.5)
	--Metal
	FixUpTexture("metal/metalgrate011a")
	FixUpTexture("metal/metalgrate011a_nopassbullets","metalgrate011a")
	FixUpTexture("metal/metalgrate011b")
	FixUpTexture("metal/metalgrate013a","metalgrate013a")
	FixUpTexture("metal/reck_metalgrate011a","metalgrate011a")
	FixUpTexture("metal/reck_metalgrate013a2","metalgrate013a")
	--Brick
	FixUpTexture("brick/brickwall003a",nil,"overlays/detail001",1.1,0,1, 0.5)
	FixUpTexture("brick/brickwall003d",nil,"overlays/detail001",1.1,0,1, 0.5)
	--Glass
	FixUpTexture("glass/glasswindow002a",nil,nil,nil,nil,nil,Vector(1,0.5,1),2097152)
	FixUpTexture("mall/glasswindow004a","glasswindow002a",nil,nil,nil,nil,Vector(1,0.5,1),2097152)	--Map specific fix, for ctf_turbine_winter
	FixUpTexture("glass/glasswindow005a",nil,nil,nil,nil,nil,Vector(1,0.5,1),2097152)
	FixUpTexture("glass/glasswindow006b","glasswindow006b",nil,nil,nil,nil,nil)
	--Overlays
	FixUpTexture("nature/dirtroad001a",nil,nil,nil,nil,nil,nil)
	--Detail Sprites
	FixUpTexture("detail/detailsprites",nil,nil,nil,nil,nil,nil)
	
	
	--Cubemap scan, a bit janky imo but I can't think of any other way to accomplish this
	local list_textures = {"glasswindow001b", "glasswindow001c", "glasswindow002a", "glasswindow002c", "glasswindow004a", "metalduct001a"}
	for _,entity in pairs(ents.GetAll()) do
		if (string.gmatch(tostring(entity), "func_.*") or string.gmatch(tostring(entity), "worldspawn")) then
			for _,material in pairs(entity:GetMaterials()) do
				if (string.match(material, ".*_.[0-9]*_.[0-9]*_.[0-9]*")) then
					local mat_full = string.Replace(material, "maps/"..game.GetMap().."/", "")
					local mat_cubemap = string.gsub(mat_full, ".*/", "")
					local mat_stripped = string.gsub(mat_cubemap, "_.[0-9]*_.[0-9]*_.[0-9]*", "")
					if (table.HasValue(list_textures, mat_stripped)) then
						local matscale
						local flags
						if (string.match(mat_stripped, "metalduct001a")) then
							matscale = Vector(0.5, 0.25, 0.25)
						elseif (string.match(mat_stripped, "glasswindow001b")) then
							matscale = 5
						elseif (string.match(mat_stripped, "glasswindow002a")) then
							flags = 2097152
						elseif (string.match(mat_stripped, "glasswindow004a")) then	--Map specific fix for ctf_turbine_winter
							mat_stripped = "glasswindow002a"
							flags = 2097152
						else
							matscale = nil
							flags = nil
						end
						FixUpTexture(material, mat_stripped,nil,nil,nil,nil,matscale,flags)
						if GetConVar("developer"):GetString() == "1" then
							print("[TF2 Multi-Fix] Fixing up cubemap:",tostring(mat_full),tostring(mat_cubemap),tostring(mat_stripped),"\n---------------")
						end
					end
				end
			end
		end
	end
end

hook.Add("Initialize", "TF2TextureFixup", function() timer.Simple(5.0, function() for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do MsgN("[TF2 Multi-Fix] Applying texture fixups, this might chug a bit!") TF2TextureFix() game.CleanUpMap(true) break end end) end)
concommand.Add("tf_applyfixup", function() MsgN("[TF2 Multi-Fix] Manually applying TF2 fixups") TF2TextureFix() end)
