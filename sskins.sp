#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Tetragromaton"
#define PLUGIN_VERSION "1.1"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <smlib>
//#pragma newdecls required
#include <clientprefs>
EngineVersion g_Game;

public Plugin myinfo = 
{
	name = "Special Skins",
	author = PLUGIN_AUTHOR,
	description = "Dress the Skins of the Broken Net Update",
	version = PLUGIN_VERSION,
	url = "tetradev.org"
};
Handle g_sDataSkin;//Terrorist
Handle g_sDataSKIN_CT;//CTF
public void OnPluginStart()
{
	g_Game = GetEngineVersion();
	if(g_Game != Engine_CSGO && g_Game != Engine_CSS)
	{
		SetFailState("This plugin is for CSGO/CSS only.");	
	}
	RegConsoleCmd("skins", SpecialSkin3);
	HookEvent("player_spawn", OnPlayerSpawn);
	g_sDataSkin = RegClientCookie("ss_skin_t", "", CookieAccess_Private);
	g_sDataSKIN_CT = RegClientCookie("ss_skin_ct", "", CookieAccess_Private);
}
public IsValidClient(client)
{
	if (!(1 <= client <= MaxClients) || !IsClientInGame(client))
		return false;
	
	return true;
}
public Action OnPlayerSpawn(Event eEvent, const char[] sName, bool bDontBroadcast)
{
	new client = GetClientOfUserId(eEvent.GetInt("userid"));
	if (client)
	{
		if(IsValidClient(client))
		{
			CreateTimer(1.3, ApplySkin, client);
		}
	}
}
public Action ApplySkin(Handle timer, any:client)
{
	char SkinNISMO[255];
	GetClientCookie(client, g_sDataSkin, SkinNISMO, sizeof(SkinNISMO));
	char SkinNISMOXTUNE[255];
	GetClientCookie(client, g_sDataSKIN_CT, SkinNISMOXTUNE, sizeof(SkinNISMOXTUNE));	
	if(GetClientTeam(client) == CS_TEAM_CT && !StrEqual(SkinNISMO, ""))
	{
		if (!IsModelPrecached(SkinNISMO))PrecacheModel(SkinNISMO);
		Entity_SetModel(client, SkinNISMO);
	}else if (GetClientTeam(client) == CS_TEAM_T && !StrEqual(SkinNISMOXTUNE, ""))
	{
		if (!IsModelPrecached(SkinNISMOXTUNE))PrecacheModel(SkinNISMOXTUNE);
		Entity_SetModel(client, SkinNISMOXTUNE);	
	}
}
public Action SpecialSkin3(client,args)
{
	new Handle:menu = CreateMenu(AgencySELECTOR, MenuAction_Select  | MenuAction_End);
	SetMenuTitle(menu, "选择下次重生探员");
	AddMenuItem(menu, "Reset", "重设");
	AddMenuItem(menu, "DeservedAGENCY", "高级 探员");
	AddMenuItem(menu, "NomineeSDX", "卓越级探员");
	AddMenuItem(menu, "PerfectAGNT", "非凡级探员");
	AddMenuItem(menu, "MasterAGENT", "大师级探员");
	DisplayMenu(menu, client, MENU_TIME_FOREVER);	
}
public AgencySELECTOR(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			
			if (StrEqual(item, "DeservedAGENCY"))
			{
				SelectorMENUGEN(param1, 1);
			}
			else if (StrEqual(item, "NomineeSDX"))
			{
				SelectorMENUGEN(param1, 2);
			}
			else if (StrEqual(item, "PerfectAGNT"))
			{
				SelectorMENUGEN(param1, 3);
			}
			else if (StrEqual(item, "MasterAGENT"))
			{
				SelectorMENUGEN(param1, 4);
			}else if(StrEqual(item, "Reset"))
			{
				SetClientCookie(param1, g_sDataSkin, "");
				SetClientCookie(param1, g_sDataSKIN_CT, "");
				PrintToChat(param1, "Параметры скинов были сброшены.");
			}
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}
SelectorMENUGEN(client, int type)
{
	new Handle:menu = CreateMenu(XCGSelector, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "Choose an agent");
	switch(type)
	{
		case 4://Master Agent
		{     
			AddMenuItem(menu, "19", "CT 陆军少尉长官Ricksaw ");
			AddMenuItem(menu, "20", "CT Ava特工 | 联邦调查局");
			AddMenuItem(menu, "21", "T 医生”Romanov | Sabre");
			AddMenuItem(menu, "22", "T 精英Muhlik先生 | 精锐分子");
		}
		case 3://Superior Agent
		{
			AddMenuItem(menu, "14", "T Blackwolf | Sabre");
			AddMenuItem(menu, "15", "CT Michael Syfers | 联邦调查局（FBI）狙击手");
			AddMenuItem(menu, "16", "CT “两次”McCoy | 美国空军战术空中管制部队");
			AddMenuItem(menu, "17", "T Shahmat教授 | 精锐分子");
			AddMenuItem(menu, "18", "T 准备就绪的Rezan | Sabre");
		}
		case 2://Exceptional Agent
		{
			AddMenuItem(menu, "8", "CT Markus Delrow | 联邦调查局（FBI）人质营救队");
			AddMenuItem(menu, "9", "T Maximus | Sabre");
			AddMenuItem(menu, "10", "CT 铅弹 | 海军水面战中心海豹部队");
			AddMenuItem(menu, "11", "T Osiris | 精锐分子");
			AddMenuItem(menu, "12", "T 弹弓 | 凤凰战士");
			AddMenuItem(menu, "13", "T Dragomir | Sabre");
		}
		case 1://Distinguished Agent
		{
			AddMenuItem(menu, "1", "CT 海豹部队第六分队士兵 | 海军水面战中心海豹部队");
			AddMenuItem(menu, "2", "CT 第三特种兵连 | 德国特种部队突击队");
			AddMenuItem(menu, "3", "CT 特种兵 | 联邦调查局（FBI）特警");
			AddMenuItem(menu, "4", "T 地面叛军 | 精锐分子");
			AddMenuItem(menu, "5", "T 执行者 | 凤凰战士");
			AddMenuItem(menu, "6", "T 枪手 | 凤凰战士");
			AddMenuItem(menu, "7", "CT B Squadron指挥官 | 英国空军特别部队");
		}
		default:
		{
			//PrintToChat(client, "Not found.");
			CloseHandle(menu);
		}
	}
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}
public XCGSelector(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			int SPICK = StringToInt(item);
			char ModelName[255];
			if(SPICK > 0)
			{
				int team = 0;
				switch(SPICK)
				{
					case 6:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_phoenix_varianth.mdl";
					}
					case 12:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_phoenix_variantg.mdl";
					}
					case 5:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_phoenix_variantf.mdl";
					}
					case 17:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_leet_varianti.mdl";
					}
					case 4:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_leet_variantg.mdl";
					}
					case 11:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_leet_varianth.mdl";
					}
					case 14:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantj.mdl";
					}
					case 9:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_varianti.mdl";
					}
					case 21:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_varianth.mdl";
					}					
					case 18:
					{
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantg.mdl";
					}
					case 13:
					{ 
						team = 2;
						ModelName = "models/player/custom_player/legacy/tm_balkan_variantf.mdl";
					}
					case 16:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantm.mdl";
					}
					case 19:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_varianti.mdl";
					}
					case 10:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantg.mdl";
					}
					case 7:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_sas_variantf.mdl";
					}
					case 15:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_varianth.mdl";
					}
					case 8:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantg.mdl";
					}
					case 20:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantb.mdl";
					}
					case 22:
					{
						team = 2;//T
						ModelName = "models/player/custom_player/legacy/tm_leet_variantf.mdl";
					}
					case 3:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_fbi_variantf.mdl";
					}
					case 1:
					{
						team = 1;//CT
						ModelName = "models/player/custom_player/legacy/ctm_st6_variante.mdl";
					}
					case 2:
					{
						team = 1;
						ModelName = "models/player/custom_player/legacy/ctm_st6_variantk.mdl";
					}
				}
				//PrintToChatAll("%s", ModelName);
				
				if(team == 1)
				{
					SetClientCookie(param1, g_sDataSkin, ModelName);
					PrintToChat(param1, "CT Agent model will be chosen  next round.");
				}else if(team == 2)
				{
					PrintToChat(param1, "T Agent model will be chosen next  round.");
					SetClientCookie(param1, g_sDataSKIN_CT, ModelName);
				}
			}
		}


		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}