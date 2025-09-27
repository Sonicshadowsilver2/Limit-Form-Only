local GameVersion = 0
local canExecute = false

function _OnInit()
  GameVersion = 0
end

function GetVersion() --Define anchor addresses
  if GAME_ID == 0x431219CC and ENGINE_TYPE == 'BACKEND' then --PC
    if ReadString(0x09A92F0,4) == 'KH2J' then --EGS v1.0.0.9
			GameVersion = 2
			print('EGS v1.0.0.9 Detected - LimitFormOnly')
			Now  = 0x0716DF8
			Save = 0x09A92F0
			Drive = 0x2A23188
			UCM = 0x2A71998
			Obj0 = 0x2A24A70
			canExecute = true
		elseif ReadString(0x09A9330,4) == 'KH2J' then --EGS v1.0.0.10
			GameVersion = 3
			print('EGS v1.0.0.10 Detected - LimitFormOnly')
			Now  = 0x0716DF8
			Save = 0x09A9330
			Drive = 0x2A231C8
			UCM = 0x2A719D8
			Obj0 = 0x2A24AB0
			canExecute = true
		elseif ReadString(0x09A9830,4) == 'KH2J' then --Steam Global v1.0.0.1
			GameVersion = 4
			print('Steam GL v1.0.0.1 Detected - LimitFormOnly')
			Now  = 0x0717008
			Save = 0x09A9830
			Drive = 0x2A236C8
			UCM = 0x2A71ED8
			Obj0 = 0x2A24FB0
			canExecute = true
		elseif ReadString(0x09A8830,4) == 'KH2J' then --Steam JP v1.0.0.1
			GameVersion = 5
			print('Steam JP v1.0.0.1 Detected - LimitFormOnly')
			Now  = 0x0716008
			Save = 0x09A8830
			Drive = 0x2A226C8
			UCM = 0x2A70ED8
			Obj0 = 0x2A23FB0
			canExecute = true
		elseif ReadString(0x09A98B0,4) == 'KH2J' then --Steam v1.0.0.2
			GameVersion = 6
			print('Steam v1.0.0.2 Detected - LimitFormOnly')
			Now  = 0x0717008
			Save = 0x09A98B0
			Drive = 0x2A23748
			UCM = 0x2A71F58
			Obj0 = 0x2A25030
			canExecute = true
		end
	end
end

function _OnFrame()
	if GameVersion == 0 then --Get anchor addresses
		GetVersion()
		return
	end
	
	if canExecute == true then
		if ReadShort(Now+0x00) == 0x0102 and ReadByte(Now+0x08) == 0x34 then --New Game
			WriteByte(Save+0x1CD9, 0x02) --Enable Square Button actions
			WriteByte(Save+0x1CE5, 0x04) --Show Form Gauge
		end
		if ReadByte(Now+0x00) == 0x02 then --Twilight Town
			if ReadByte(Now+0x08) == 0x9D or ReadByte(Now+0x08) == 0x78 or ReadByte(Now+0x08) == 0x7D then
				WriteShort(UCM+0x009C, 0x005A) --Roxas -> Roxas
			else
				WriteShort(UCM+0x009C, 0x095D) --Roxas -> Limit Form
			end
			if ReadByte(Now+0x01) == 0x1C and ReadByte(Now+0x08) == 0x01 and ReadByte(Save+0x1CE5) == 0x05 then
				WriteByte(Save+0x1CE5, 0x01)
			end
		end
		if ReadByte(Now+0x00) == 0x0A then --Pride Lands
			if ReadByte(Now+0x01) == 0x0F then --Groundshaker
				WriteShort(UCM+0x06E8, 0x028A) --Limit Form -> Lion Sora
			else
				WriteShort(UCM+0x06E8, 0x095D) --Lion Sora -> Limit Form
			end
		end
		if ReadShort(Now+0x00) == 0x0E12 then --Luxord
			if ReadByte(Now+0x08) == 0x3A or ReadByte(Now+0x08) == 0x65 then
				if ReadByte(Save+0x3524) == 0x00 then
					WriteByte(Save+0x3524, 0x03) --Remain in Limit Form
				end
				if ReadInt(Drive+0x04) < 0x44160002 and ReadInt(Drive+0x08) > 0x44960000 then
					WriteInt(Drive+0x04, 0x45160000)
				end
			end
		end
		if ReadByte(UCM+0x00) == 0x54 then
			WriteShort(UCM+0x0000, 0x095D) --Sora (Normal) -> Limit Form
			WriteShort(UCM+0x00D0, 0x095D) --Roxas (Dual-Wielded) -> Limit Form
			WriteShort(UCM+0x0104, 0x095D) --Sora (KH1 Costume) -> Limit Form
			WriteShort(UCM+0x0444, 0x095E) --Sora (Halloween Town) -> Limit Form (Halloween Town)
			WriteShort(UCM+0x0478, 0x095F) --Sora (Christmas Town) -> Limit Form (Christmas Town)
			WriteShort(UCM+0x0680, 0x0960) --Sora (Space Paranoids) -> Limit Form (Space Paranoids)
			WriteShort(UCM+0x06B4, 0x0961) --Sora (Timeless River) -> Limit Form (Timeless River)
			WriteString(Obj0+0x0C870,'P_EX100_KH1F\0') --Sora (Blustery Rescue) Model -> Limit Form Model
			WriteString(Obj0+0x0C890,'P_EX100_KH1F.mset\0') --Sora (Blustery Rescue) MSET -> Limit Form MSET
			WriteString(Obj0+0x0C8D0,'P_EX100_KH1F\0') --Sora (Hunny Slider) Model -> Limit Form Model
			WriteString(Obj0+0x0C8F0,'P_EX100_KH1F.mset\0') --Sora (Hunny Slider) MSET -> Limit Form MSET
			WriteString(Obj0+0x12690,'P_EX100_KH1F\0\0\0\0\0') --Sora (On Carpet) Model -> Limit Form Model
			WriteString(Obj0+0x154D0,'F_TT010_SORA.mset\0') --Skateboard (Roxas) MSET -> Skateboard (Sora) MSET
		end
	end
end