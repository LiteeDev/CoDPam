# CoDPam
This is the original Call of Duty Pam Mod for Call of Duty v1.1. It was developed by LiteDev and Reny in the summer of 2019 to allow Call of Duty 1 Teams to play against each other competitively without having to intervene during the game messing around with commands/rcon.

Supported By CryptXGaming.org (https://www.cryptxgaming.org)

# Current Implemented: 
* Auto Switch Rounds after the team first with the score of 7.
* Auto Switch Team after the round switch.
* Game Statistics such as Round Scoreboard Supporting the full amount of rounds played.
* Ready Up System allowing users to press the <USE> button to confirm they're ready to play.

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
