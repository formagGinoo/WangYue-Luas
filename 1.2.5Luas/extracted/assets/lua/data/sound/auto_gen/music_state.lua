Config = Config or {}
Config.MusicState = Config.MusicState or { }
local empty = { }
Config.MusicState = 
{
  stateGroupList = {
    "ActiveBGM",
    "BgmType",
    "MidArea",
    "SmallArea",
    "PlayerLife",
    "GamePlayType"
  },
  audioEntryList = {
    {
      state = "TRUE.GamePlay.MidArea2.default.Alive.Explore",
      audioList = {
        "Bgm_Dijiang_Explore"
      },
    },
    {
      state = "TRUE.GamePlay.MidArea2.default.Alive.Combat",
      audioList = {
        "Bgm_Dijiang_Combat"
      },
    },
    {
      state = "TRUE.GamePlay.MidArea2.SmallArea2001.Alive.Combat",
      audioList = {
        "Bgm_Mountain_Combat"
      },
    },
    {
      state = "TRUE.GamePlay.MidArea2.SmallArea2001.Alive.Explore",
      audioList = {
        "Bgm_Mountain_Explore"
      },
    },
    {
      state = "TRUE.GamePlay.MidArea2.SmallArea2002.Alive.Explore",
      audioList = {
        "Bgm_Xilai"
      },
    },
    {
      state = "TRUE.Story.default.default.Alive.Explore",
      audioList = {
        "Bgm_TL_Jadei"
      },
    }
  },
}
