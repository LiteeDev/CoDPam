# CoDPam
This is the original Call of Duty Pam Mod for Call of Duty v1.1. It was developed by LiteDev and Reny in the summer of 2019 to allow Call of Duty 1 Teams to play against each other competitively without having to intervene during the game messing around with commands/rcon.

Supported By CryptXGaming.org (https://www.cryptxgaming.org)

# Current Implemented: 
* Auto Switch Rounds after the team first with the score of 7.
* Auto Switch Team after the round switch.
* Game Statistics such as Round Scoreboard Supporting the full amount of rounds played.
* Ready Up System allowing users to press the <USE> button to confirm they're ready to play.

# PAM Mod Commands

```
pam_prematch //dont touch
pam_halftime //dont touch
pam_strattime //enable or disable strat time(3seconds) 1=enable 0=disable
pam_mapobjects //enable or disable map objects like mg42 or mp44 1=enable 0=disable
pam_mg42 //enable or disable only mg42 1=enable 0=disable
pam_nade //start training mode 1=enable 0=disable
pam_mod //switching between score system 1=nightcup 0=funwar
pam_start_break //start break next round 1=start break 0=end break
serverstate // "ready_up" for prematch "playing" for skip ready check
```


# Setup Guide (with Release Version)

Download the latest release from latest release and read the readme.txt in the CoD 1.1 mod.

# Setup Guide

First, start by uploading the codam_pam.gsc to main/codam.

Then proceed, to codam/modlist.gsc and insert the plugin to initialize on the start of the server.

```
[[ register ]]( "AntiPam", codam\anti_pam::main, "antipam" );
```

And then, open the dedicated.cfg or server.cfg. The main server configuration and insert this variable at the bottom of the config and also make sure the game type is set to SD before starting.

```
serverstate ready_up
```

If you're stuck in playing mode, you can restore the ready_up mode by entering this via console or rcon:

```
/rcon <pass> serverstate ready_up
serverstate ready_up
```

# Authors
* LiteDev (Discord: LiteDev#3711 | Email: office@litespeed.me | Telegram: @LiteSpeedDev)
* Reny (Discord: Reny#5365)
* Huepfer (Discord: huepfer92#2936)

# Update Log

Huepfer 
```bash
> No bomb planting in prematch
> Removed timer in prematch
> If all of a team dies in prematch new round will not start (using /kill or changing team or going spectator)
> Pam ScoreBoard is updating also during prematch
> You cannot move during team switch
> Team Score will swap too after half of the map
> Map ends after second half (you can take ONE screenshot and have the totall score of the map of both sides)
```

LiteDev & Reny 
```bash
> Coming Features Planned for Summers :D
> Implement scoreboard (i.e. in video sent on Discord or bring the code from 1.5 version)
> Implement pause command (if needed, not sure)
> Modify and try to implement COD2/4 like hitmarker
> Implement TAB scoreboard to show after 13-13 or 14 round one side
> Implement scores to show in ready up mode
> Implement ready up mode with actual sessionstates and stuff, so re-modding codam or overlay codes (something) - Done
> Make echo to tell who's ready up and who's not - Done (probably add red/green dots in a big TAB scoreboard in the future)
```

Demsix 

```

> pam_mod 1 = MR12 (First to 13, half time at 12 rounds)
> > Still needs below bind at the end of each MR12
> > bind f9 rcon pam_halftime 0; rcon serverstate ready_up; rcon map_restart;
> pam_mod 0 = First to 7 over and over
> Stop movement in halftime and temporarily increases round time to 30 mins
> Added info on current ruleset while in ready up state
```