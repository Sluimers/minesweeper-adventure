package nl.obg.entities {  
	import nl.obg.engine.*;
	
	/**
	 * The slow divorce of the Player and the Minesweeper Entity has begun
	 * @author Rogier Sluimers
	 */
	public class MineSweeper extends Entity
	{
		
		public function MineSweeper(x:int, y:int, z:int) 
		{
			name = "Player";
			
            hotx 		= 52;
			hoty 		= 25;
			hotwidth	= 50;
			hotheight	= 50;
			width		= 102;
			height		= 80;
			
			animScript = [];
			animCommands = [];
			animCommands["RANDOM"] = ["F", "W", "e"];
			animScript["RANDOM"] =  [16, 220];
			
			animCommands["IDLE"] =	["F", "W"];
			animScript["IDLE"] = 	[0, 1600];
			
			/*
			animCommands["IDLE"] =	["F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W"];
			animScript["IDLE"] = 	[0, 1600, 1, 100, 2, 100, 1, 100];
			
			animCommands["DOWN"] =	["F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W"]
			animScript["DOWN"] = 	[8, 20, 9, 20, 10, 20, 11, 20, 12, 20, 13, 20, 14, 20, 15, 20];
			
			animCommands["UP"] = 	["F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W"]
			animScript["UP"] = 		[8, 20, 9, 20, 10, 20, 11, 20, 12, 20, 13, 20, 14, 20, 15, 20];
			
			animCommands["LEFT"] =	["F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W"] 
			animScript["LEFT"] = 	[8, 20, 9, 20, 10, 20, 11, 20, 12, 20, 13, 20, 14, 20, 15, 20];
			
			animCommands["RIGHT"] = ["F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W", "F", "W"]
			animScript["RIGHT"] = 	[8, 20, 9, 20, 10, 20, 11, 20, 12, 20, 13, 20, 14, 20, 15, 20];
			*/
			
			Engine.setPlayer(this);
			Engine.setCameraTarget(this);
			
			baseNoiseRange = 3;
			baseVisibility = 30;
			
			super(x, y, z, name + ".png");
			
			keyPressTimer = new Timer(100, 1);
			
			hasRadar = Settings.hasRadar();
			
			onNewMap();
			alive = true;
			active = true;
			speed = 4;
		}
		
		public override function direct():void {
			if (active) {
				
				for (var i:int = overlaps.length; i--; ) {
					const sid:uint = overlaps[i];
					
					if (GameModel.itemIDLs[sid] != undefined) {
						const s:MapSprite = Engine.sprites[sid];
						if (s.name == "Stealth") hasStealth = true;
						else items.push(s.name);
						s.removeFromGame();
					}
				}
				
				// super.direct, after collision handling functions
				// before the rest
				super.direct();
				
				if (!moving) {
					moveControls();
				}
				else moveBackControls();
				
				if (moving) {
					speedControl();
				}
			}
			
			Debug.addDebugLine("moveScript:" + Debug.dirArray(moveScript));
			Debug.addDebugLine("dir:" + dir);
			Debug.addDebugLine("v:" + vx, vy);
		}
		
		public override function collides():Boolean {
			const c:Array = coll; 
			var uncovered:Boolean = false;		// so we don't have to uncover twice in a row
			var hitSolid:Boolean = false;		// checks if player is hitting covers or not
			
			for (var i:int = c.length; i--; ) {
				if (c[i] < -1) {
					if(!uncovered) {
						uncovered = true;
						for (var j:int = nwOnp.length; j--; ) {
							const xyz:int = nwOnp[j];
							if (Map.hasObs[xyz]) hitSolid = true;
							Map.uncoverXYZ(xyz);
						}
					}
				}
				else {
					hitSolid = true;
				}
			}
			if (hitSolid) return super.collides();
			return false;
		}
		
		protected override function onHotTileChange():void {
			onp = nwOnp.concat();
			if (visibility) bcLoS();
			if (noiseRange) bcWoS();
			if (hasRadar) radar();
		}
		
		public override function updateAnimation():void {
			const stepDirection:int = stepDir, key:uint = KeyControl.keyPressed;
			
			switch(1) {
				case key == Key.R:
					newScript = "RANDOM";
					break;
				case stepDirection >> RIGHT & 1:
					//newScript = "RIGHT";
					break;
				case stepDirection >> LEFT & 1:
					//newScript = "LEFT";
					break;
				case stepDirection >> DOWN & 1:
					//newScript = "DOWN";
					break;
				case stepDirection >> UP & 1:
					//newScript = "UP";
					break;
				default:
					newScript = "IDLE";
					break
			}	
			
			super.updateAnimation();
		}
		
		public override function step():void {
			var o:Array, zone:int;
			
			super.step();
			
			if (centering && alive && moving) { 
				o = onp.slice();
				
				for (var i:int = o.length; i--; ) {
					zone = Map.zone[o[i]];
					if (zone) Map.callScriptById(zone);
					break; // let's not call them five times
				}
				
				moving = false;
				stepping = false;
			}
		}
	}

}