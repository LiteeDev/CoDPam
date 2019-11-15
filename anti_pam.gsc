// PAM Mode for CoD v1.1
// Originally Created By LiteDev & Reny
// Discord: LiteDev#3711
// Discord: Reny#5365

// Updated by Huefper :)

// Setup Guide 
//Main: dedicated.cfg 
//serverstate ready_up
// If you need to reset to ready up mode, you need to run the command /rcon <pass> serverstate ready_up in rcon and restart the map.

// Coming Features Planned for Summers :D
// Implement scoreboard (i.e. in video sent on Discord or bring the code from 1.5 version)
// Implement pause command (if needed, not sure)
// Modify and try to implement COD2/4 like hitmarker
// Implement TAB scoreboard to show after 13-13 or 14 round one side
// Implement scores to show in ready up mode
// Implement ready up mode with actual sessionstates and stuff, so re-modding codam or overlay codes (something) - Done
// Make echo to tell who's ready up and who's not - Done (probably add red/green dots in a big TAB scoreboard in the future)

main( phase, register )
{
    codam\utils::debug( 0, "======== _anti_pam/main:: |", phase, "|", register, "|" );
    switch ( phase )
    {
      case "load":      _load();        break;
      case "init":      _init( register );  break;
      case "start":     _start();       break;
    }
    return;
}

_init( register )
{
    codam\utils::debug( 0, "======== _anti_pam/_init:: |", register, "|" );
    [[ register ]](    "spawnPlayer", ::onSpawnPlayer, "thread" );
    [[ register ]](    "PlayerConnect", ::ReadyButton, "thread" );
	[[ register ]](    "spawnSpectator", ::speactator, "thread" );
    [[ register ]](      "PlayerDisconnect", ::RemoveReady, "thread" );
    //setcvar("serverstate", "");
    return;
}

RemoveReady(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9,
                b0, b1, b2, b2, b4, b5, b6, b7, b8, b9)
{
    setcvar("store_ready", RemoveString(getcvar("store_Ready"), self.name));
    return;
}


_load()
{
    codam\utils::debug( 0, "======== _anti_pam/_load" );
    return;
}

_start()
{

    ShowCopyRight();
    if(getCvar("serverstate") == "" || !isDefined(getCvar("serverstate")))
    {
        setCvar("serverstate", "ready_up");
    }
	if(getCvar("pam_prematch") == "" || !isDefined(getCvar("pam_prematch")))
    {
        setCvar("pam_prematch", "1");
    }
    if(getCvar("pam_halftime") == "" || !isDefined(getCvar("pam_halftime")))
    {
        setCvar("pam_halftime", "0");
    }

    if(getCvar("pam_strattime") == "" || !isDefined(getCvar("pam_starttime")))
    {
        setCvar("pam_strattime", "1");
    }

	level.breakstop = 0;
	if(getcvar("pam_start_break") == "")
		setcvar("pam_start_break", "0");

	precacheString(&"^1Not ready");
	precacheString(&"^2Ready");
	precacheStatusIcon( "gfx/hud/hud@objective_bel.tga" );
	precacheStatusIcon( "gfx/hud/headicon@re_objcarrier.dds" );

    serverCvar = getCvar("serverstate");
    level.ServerState = RemoveString(serverCvar, "^7");
    switch(level.ServerState)
    {
        case "ready_up":
			setCvar("pam_prematch", 1);
			setCvar("scr_sd_roundlength", "2.5");
			setcvar("store_ready", "");
			thread Prematch_Alive();
			thread StaticPrematchHud();
			ShowScores();
			SetScores();
			thread ReadyMonitor();
			[[ level.gtd_call ]]( "roundClock", 0);
			break;

        case "playing":
			setCvar("pam_prematch", 0);
           
            ShowScores();
            StartingLife();
			break;
    }
    return;
}
speactator()
{
	self.rdy destroy();
}
onSpawnPlayer(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9,
                b0, b1, b2, b2, b4, b5, b6, b7, b8, b9) 
{
	if(getCvar("pam_prematch") == "1")
	{
	
		self.rdy destroy();	
		wait 0.05;
		self.rdy = newClientHudElem(self);
		self.rdy.archived = false;
		self.rdy.x = 565;
		self.rdy.y = 410;
		self.rdy.alignX = "left";
		self.rdy.alignY = "top";
		self.rdy.sort = 1;
		self.rdy.fontScale = 1;
		
	
	
		if(self.ready == true)
		{		
			self.statusicon = "gfx/hud/headicon@re_objcarrier.dds";
			self.rdy.label = &"^2Ready";
		}
		else
		{
			self.statusicon = "gfx/hud/hud@objective_bel.tga";
			self.rdy.label = &"^1Not ready";
			self.ready = false;
		}
	
	}
}

ReadyMonitor()
{
    for(;;)
    {
        wait .5;
        AlliedPlayers = [];
        AxisPlayers = [];
        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            if (!isdefined (players[i].pers["teamTime"]))
                players[i].pers["teamTime"] = 0;
            if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "allies"))
                AlliedPlayers[AlliedPlayers.size] = players[i];
            else if((isdefined(players[i].pers["team"])) && (players[i].pers["team"] == "axis"))
                AxisPlayers[AxisPlayers.size] = players[i];
        }

        level.axisready = 0;
        level.alliesready = 0;
        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            if((isdefined(players[i].pers["team"])) && players[i].pers["team"] == "axis" && (isdefined(players[i].ready)) && players[i].ready == true)
                level.axisready++;
            if((isdefined(players[i].pers["team"])) && players[i].pers["team"] == "allies" && (isdefined(players[i].ready)) && players[i].ready == true)
                level.alliesready++;
        }

        if(AxisPlayers.size !=0 && AlliedPlayers.size !=0 && AxisPlayers.size == level.axisready && AlliedPlayers.size == level.alliesready)
        {
            iprintlnbold("^3All Players Ready");
            iprintlnbold("^3Starting Match Countdown");
			level.match_hud_instructions destroy();
			level.match_hud_axisreadyplayers destroy();
			level.match_hud_alliesreadyplayers destroy();
            wait 7;
            setCvar("serverstate", "playing");
            setCvar("scr_sd_roundlength", 2.5);
			setCvar("pam_prematch", 0);
			if(getCvar("pam_halftime") == "0")
			{
				game["axisscore"] = 0;
				game["alliedscore"] = 0;
			}
			
			level.allplayers = getentarray("player", "classname");
			for(i = 0; i < level.allplayers.size; i++)
			{
				if( level.allplayers[i].pers["team"] == "allies" || level.allplayers[i].pers["team"] == "axis" )
				{				
					level.allplayers[i].statusicon = "";
					level.allplayers[i].rdy destroy();
				}
			}
            map_restart(true);
            level notify("matchstart");
            return;
        }
        if (isdefined (level.match_hud_axisreadyplayers))
            level.match_hud_axisreadyplayers setValue(level.axisready);
        if (isdefined (level.match_hud_alliesreadyplayers))
            level.match_hud_alliesreadyplayers setValue(level.alliesready);
    }
    return;
}

// Changes players' ready status
ReadyButton(a0, a1, a2, a3, a4, a5, a6, a7, a8, a9,
                b0, b1, b2, b2, b4, b5, b6, b7, b8, b9)
{
	self.ready = false;
    level endon("start_map");
    serverCvar = getCvar("serverstate");
    level.ServerState = RemoveString(serverCvar, "^7");
    if(level.ServerState != "ready_up")
        return;
    while(!isdefined(self.pers["team"]))
        wait 1;
    while(self.pers["team"] == "spectator")
        wait 1;

  

    while (level.ServerState == "ready_up")
    {
        wait .01;
        if(self useButtonPressed() == true && self.pers["team"] != "spectator")
        {
          
            if(self.ready == false)
            {
                self.ready = true;
                str = getcvar("store_ready") + self.name;
                iprintln(self.name + " ^3is ready");
				self.statusicon = "gfx/hud/headicon@re_objcarrier.dds";
				self.rdy.label = &"^2Ready";
		
                setcvar("store_ready", str);
            }
            else
            {
                self.ready = false;
                setcvar("store_ready", RemoveString(getcvar("store_Ready"), self.name));
                                  iprintln(self.name + " ^3is not ready");
					self.statusicon = "gfx/hud/hud@objective_bel.tga";
					self.rdy.label = &"^1Not ready";

            }

            self playLocalSound("hq_score");        }
        while(self useButtonPressed() == true)
            wait.001;
    }
    return;
}


//Keep the players alive during prematch, so captains can talk.
Prematch_Alive()
{
    for(;;)
    {
        wait .01;
        players = getentarray("player", "classname");
        for(i = 0; i < players.size; i++)
        {
            if(players[i].sessionstate == "playing")
                players[i].health = 5000;
        }
    }
    return;
}

StaticPrematchHud()
{
	level.match_hud_instructions = newHudElem();
	level.match_hud_instructions.archived = false;
	level.match_hud_instructions.x = 537;
	level.match_hud_instructions.y = 190;
	level.match_hud_instructions.sort = 9998;
	level.match_hud_instructions.fontscale = .8;
	level.match_hud_instructions.label =&"Press ^2USE ^7to toggle\nyour ready status.";

	level.match_hud_axisreadyplayers = newHudElem();
	level.match_hud_axisreadyplayers.archived = false;
	level.match_hud_axisreadyplayers.alignX = "left";
	level.match_hud_axisreadyplayers.x = 537;
	level.match_hud_axisreadyplayers.y = 220;
	level.match_hud_axisreadyplayers.sort = 9998;
	level.match_hud_axisreadyplayers.fontscale = .9;
	level.match_hud_axisreadyplayers.label =&"Axis Ready: ";

	level.match_hud_alliesreadyplayers = newHudElem();
	level.match_hud_alliesreadyplayers.archived = false;
	level.match_hud_alliesreadyplayers.alignX = "left";
	level.match_hud_alliesreadyplayers.x = 537;
	level.match_hud_alliesreadyplayers.y = 235;
	level.match_hud_alliesreadyplayers.sort = 9998;
	level.match_hud_alliesreadyplayers.fontscale = .9;
	level.match_hud_alliesreadyplayers.label =&"Allies Ready: ";

    return;
}


// WHEN SERVERSTATE = PLAYING

ShowCopyRight()
{
    level.match_hud_title = newHudElem();
    level.match_hud_title.archived = false;
    level.match_hud_title.alignX = "left";
    level.match_hud_title.x = 505;
    level.match_hud_title.y = 472;
    level.match_hud_title.sort = 9998;
    level.match_hud_title.fontscale = .6;
    level.match_hud_title.label =&"^7PAM Mode for 1.1 by LiteDev & Reny";
}


ShowScores()
{
    level.match_hud_axisready = newHudElem();
    level.match_hud_axisready.archived = false;
    level.match_hud_axisready.alignX = "left";
    level.match_hud_axisready.x = 400;
    level.match_hud_axisready.y = 470;
    level.match_hud_axisready.sort = 9998;
    level.match_hud_axisready.fontscale = .7;
    level.match_hud_axisready.label =&"^7AXIS SCORE: ";

    level.match_hud_alliesready = newHudElem();
    level.match_hud_alliesready.archived = false;
    level.match_hud_alliesready.alignX = "left";
    level.match_hud_alliesready.x = 390;
    level.match_hud_alliesready.y = 460;
    level.match_hud_alliesready.sort = 9998;
    level.match_hud_alliesready.fontscale = .7;
    level.match_hud_alliesready.label =&"^7ALLIES SCORE: ";
}

SetScores()
{
    if (isdefined (level.match_hud_axisready))
            level.match_hud_axisready setValue(game["axisscore"]);
    if (isdefined (level.match_hud_alliesready))
            level.match_hud_alliesready setValue(game["alliedscore"]);
}


StartingLife()
{
    
    switch(level.ham_g_gametype) {
        case "sd":
            SetScores();
            // Check each side rounds if == 7 rotate teams
			
			if( ( game["axisscore"] == 6 && game["alliedscore"] == 6 ) && getCvar("pam_halftime") == "0")
            {
                level.match_readyup = newHudElem();
                level.match_readyup.alignX = "center";
                level.match_readyup.alignY = "middle";
                level.match_readyup.x = 320;
                level.match_readyup.y = 150;
                level.match_readyup.archived = false;
                level.match_readyup.sort = 9998;
                level.match_readyup.fontscale = 1.2;
                level.match_readyup.label = &"^3Its a drawn... \nTeams will auto switch sides in 5 seconds...";
				halfalliedscore = game["alliedscore"];		
				halfaxisscore = game["axisscore"];				
                wait 5;
                SwitchTeam();
				setCvar("pam_halftime", 1);
				setCvar("pam_prematch", 1);
                setCvar("serverstate", "ready_up");				
                map_restart(true);
                game["axisscore"] = halfalliedscore;
                game["alliedscore"] = halfaxisscore;
              return;
            }
            if(game["alliedscore"] == 12 &&  getCvar("pam_halftime") == "0" || ( (game["alliedscore"] + game["axisscore"] == 12) && game["alliedscore"] > game["axisscore"]) &&  getCvar("pam_halftime") == "0")
            {
                level.match_readyup = newHudElem();
                level.match_readyup.alignX = "center";
                level.match_readyup.alignY = "middle";
                level.match_readyup.x = 320;
                level.match_readyup.y = 150;
                level.match_readyup.archived = false;
                level.match_readyup.sort = 9998;
                level.match_readyup.fontscale = 1.2;
                level.match_readyup.label = &"^3Allies have won this half... \nTeams will auto switch sides in 5 seconds...";
				halfalliedscore = game["alliedscore"];		
				halfaxisscore = game["axisscore"];				
                wait 5;
                SwitchTeam();
				setCvar("pam_halftime", 1);
				setCvar("pam_prematch", 1);
                setCvar("serverstate", "ready_up");				
                map_restart(true);
                game["axisscore"] = halfalliedscore;
                game["alliedscore"] = halfaxisscore;
                return;
            } 
			else if(game["axisscore"] == 12 &&  getCvar("pam_halftime") == "0" || ( (game["alliedscore"] + game["axisscore"] == 12) && game["axisscore"] > game["alliedscore"]) &&  getCvar("pam_halftime") == "0")
            {
                level.match_readyup = newHudElem();
                level.match_readyup.alignX = "center";
                level.match_readyup.alignY = "middle";
                level.match_readyup.x = 320;
                level.match_readyup.y = 150;
                level.match_readyup.archived = false;
                level.match_readyup.sort = 9998;
                level.match_readyup.fontscale = 1.2;
                level.match_readyup.label = &"^3Axis have won this half... \nTeams will auto switch sides in 5 seconds...";
				halfalliedscore = game["alliedscore"];		
				halfaxisscore = game["axisscore"];				
                wait 5;
                SwitchTeam();
				setCvar("pam_halftime", 1);
				setCvar("pam_prematch", 1);
                setCvar("serverstate", "ready_up");				
                map_restart(true);
                game["axisscore"] = halfalliedscore;
                game["alliedscore"] = halfaxisscore;
              return;
            }
        break;

        case "dm":
        setCvar("g_gametype", "sd");
        map_restart(true);
        break;

        case "tdm":
        setCvar("g_gametype", "sd");
        map_restart(true);
        break;
    }
}

SwitchTeam()
{
    players = getentarray("player", "classname");
    for(i = 0; i < players.size; i++)
    {
        _team = players[i].pers["team"];
        victims = [];
        switch (_team)
        {
        case "axis":
            players[i].forceteamed = true;
            victims[0]= players[i];
            [[ level.gtd_call ]]( "switchTeam", victims, "allies", true );
            break;
        case "allies":
            players[i].forceteamed = true;
            victims[0]= players[i];
            [[ level.gtd_call ]]( "switchTeam", victims, "axis", true );
            break;
        }

    }
    return;
}

RemoveString(source, remove)
{
    if(!isdefined(source) || !isdefined(remove))
        return undefined;

    start = codam\utils::findStr(remove, source, "0");
    while(start != -1)
    {
        str1 = "";
        str2 = "";
        stop = start + remove.size;
        for(i=0;i<start;i++)
            str1 = str1 + source[i];
        for(i=stop;i<source.size;i++)
            str2 = str2 + source[i];
        source = str1 + str2;
        start = codam\utils::findStr(remove, source, "0");
    }
    return source;
}
