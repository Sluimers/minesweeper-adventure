package nl.obg.controllers {
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.events.KeyboardEvent;
	
	import nl.obg.www.*;
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.mapsprites.*;
	import nl.obg.mine.*;
	/**
	 * ...
	 * @author ...
	 */
	public class KeyControl
	{
		public static var keyDownQueue:Array = [];
		public static var isKeyInDownQueue:Array = [];
		public static var keyPressed:int = -1;
		public static var lastKeyPressed:int = -1;
		public static var keyDown:Array = [];
		public static var lastKeyDown:int = -1;
		
		private static var diagonalPressed:Boolean 		= false;
		private static var shiftPressed:Boolean 		= false;
		private static var cx:int, cy:int, cz:int;
		private static var tileIndicator:BitmapData; 
		private static var tilewidth:uint, tileheight:uint, tileRect:Rectangle; 
		public static var tileChosen:Boolean 			= false;
		public static var flagKeyPressed:Boolean 		= false;
		public static var dirKeyPressed:Boolean 		= false;
		public static var actionKeyPressed:Boolean 		= false;
		public static var breakLine:Boolean				= false
		
		
		// Is this still useful?
		public static function listenToInput():void {
			var j:int, keys:Array = keyDown;
			
			for (var i:int = keys.length; i--; ) {
				if (keys[i]) {
					if (!isKeyInDownQueue[i]) {
						isKeyInDownQueue[i] = true;
						keyDownQueue.push(i);
					}
				} else {
					isKeyInDownQueue[i] = false; 
					j = keyDownQueue.indexOf(i);
					if (j != -1) keyDownQueue.splice(j, 1);
				}
			}
			
			// Here we recycle our local variables 
			keys = keyDownQueue;
			j = keys.length;
			if (j) {
				lastKeyDown = keys[j -1];
				if (keyPressed == lastKeyDown) {
					lastKeyPressed = keyPressed;
					keyPressed = -1;
				}
				else if(lastKeyDown != lastKeyPressed) {
					keyPressed = lastKeyDown;
				}
			}
			else {
				lastKeyDown = -1;
				lastKeyPressed = -1;
				keyPressed = -1;
			}
			
			//addDebugLine("entIDs: " + entIDs);
			
			/*
			if(inGame) {
				if (player) addDebugLine(getXYZ(player));
				addDebugLine("player active: " + player.isActive());
				addDebugLine("player onp: " + player.onp);
				addDebugLine("player vp: " + player.vp);
				addDebugLine("tileChosen: " + KeyControl.tileChosen);
				addDebugLine("lastKeyDown: " + lastKeyDown);
				addDebugLine("keys: " + keyDownQueue);
			}
			*/
		}
		
		// Handles KeyUp events
		public static function onKeyUp(event:KeyboardEvent = null):void {
			var key:uint = event.keyCode;
			keyDown[key] = false;
			
			if (GameControl.inGame) {
				up(key);
			}
		}
		
		// Handles KeyDown events
		public static function onKeyDown(event:KeyboardEvent = null):void {
			var key:uint = event.keyCode;
			keyDown[key] = true;
			
			if (GameControl.inGame) {
				if (Settings.hasSolidCovers()) {
					solidCovers(key);
				} else looseCovers(key);
			}
		}
		
		public static function up(key:uint):void {
			const p:Entity = Engine.player.ent, tileIndicator:TileIndicator = GameModel.tileIndicator;
			
			switch(key) {
				case Settings.flagKey(): {
					trace("??");
					p.activate();
					if (tileChosen) {
						const xyz:int = tileIndicator.xyz;
						if (!MineMap.hasFlag[xyz]) { 
							trace("xyz:" + xyz);
							MineMap.toggleFlag(xyz);
							tileIndicator.visible = false;
							tileIndicator.detile();
							tileChosen = false;
							flagKeyPressed = false;
						}	
					}
				}
				case Settings.actionKey(): {
					// leave this for now
					actionKeyPressed = false;
				}
			}
		}
		
		
		
		public static function looseCovers(pkey:uint):void {
			const keyDown:Array = keyDown;
			const th:uint = Map.tileHeight, tw:uint = Map.tileWidth;
			const mw:uint = Map.mapWidth, ms:uint = Map.mapSize;
			const player:Player = Engine.player;
			const p:Entity = player.ent, tileIndicator:TileIndicator = GameModel.tileIndicator; 
			const hasFlag:Array = MineMap.hasFlag;
			const kpq:Array = keyDownQueue, kpql:uint = kpq.length;
			const xyz:int = p.onp[0];
			const coll:Array = p.getColl();
			var x:int, y:int, z:int, kp:int, eid:int;
			
			if (!kpql) {
				tileChosen = false; 
				return;
			}
			
			if (keyDown[Key.SHIFT] && keyDown[Key.N]) GameControl.winGame(); 
			if (keyDown[Key.C]) player.useItem();
			if (keyDown[Key.S]) player.toggleStealth();
			
			const keydir:int = keysWithArrows(kpq), key:int = kpq[kpql - 1];
			
			if (key == Settings.flagKey()) {
				if (!flagKeyPressed && !p.isMoving()) {
					p.deactivate();
					tileIndicator.tile();
					trace("move tileindicator:" + tileIndicator.vp);
					flagKeyPressed = true;
				}
			}
			
			if (keydir != -1) {
				if (flagKeyPressed) {
					if (!dirKeyPressed) {
						tileIndicator.visible = true;
						dirKeyPressed = true;
					}
					
					switch(keydir) {
						case Dir.DOWN: 		handleTileIndicator(Dir.DOWN); 			break;
						case Dir.UP:		handleTileIndicator(Dir.UP); 			break;
						case Dir.LEFT:		handleTileIndicator(Dir.LEFT); 			break;
						case Dir.RIGHT:		handleTileIndicator(Dir.RIGHT); 		break;
						case Dir.DOWNLEFT: 	handleTileIndicator(Dir.DOWNLEFT);		break;
						case Dir.UPLEFT: 	handleTileIndicator(Dir.UPLEFT);		break;
						case Dir.DOWNRIGHT: handleTileIndicator(Dir.DOWNRIGHT);		break;
						case Dir.UPRIGHT: 	handleTileIndicator(Dir.UPRIGHT); 		break;
					}
				}
				else {
					switch(keydir) {
						case Dir.DOWN: 		handleTileIndicator2(Dir.DOWN); 		break;
						case Dir.UP:		handleTileIndicator2(Dir.UP); 			break;
						case Dir.LEFT:		handleTileIndicator2(Dir.LEFT); 		break;
						case Dir.RIGHT:		handleTileIndicator2(Dir.RIGHT); 		break;
						case Dir.DOWNLEFT: 	handleTileIndicator2(Dir.DOWNLEFT);		break;
						case Dir.UPLEFT: 	handleTileIndicator2(Dir.UPLEFT);		break;
						case Dir.DOWNRIGHT: handleTileIndicator2(Dir.DOWNRIGHT);	break;
						case Dir.UPRIGHT: 	handleTileIndicator2(Dir.UPRIGHT); 		break;
					}
					
					if (keyPressed == Settings.actionKey()) {
						for (var i:uint = coll.length; i--; ) {
							eid = coll[i];
							if (eid > -1) {
								Engine.sSprites[Engine.sSpriteIDLs[eid]].triggerEvent(); 
								break;
							}
						}
					}
					
				}
			}
			else {
				dirKeyPressed = false;
			}
		}
			
		public static function solidCovers(pkey:uint):void {
			const keyDown:Array = keyDown;
			const th:uint = Map.tileHeight, tw:uint = Map.tileWidth;
			const mw:uint = Map.mapWidth, ms:uint = Map.mapSize;
			const hasFlag:Array = MineMap.hasFlag;
			const kpq:Array = keyDownQueue, kpql:uint = kpq.length;
			const player:Player = Engine.player;
			const p:Entity = player.ent;
			const xyz:int = p.onp[0];
			const coll:Array = p.getColl();
			var x:int, y:int, z:int, kp:int, eid:int;
			
			if (!kpql) {
				tileChosen = false; 
				return;
			}
			const keydir:int = keysWithArrows(kpq), key:int = kpq[kpql - 1];
			
			if (keydir != -1) {
				
				switch(keydir) {
					case Dir.DOWN: 		handleTileIndicator(Dir.DOWN); 		break;
					case Dir.UP:		handleTileIndicator(Dir.UP); 		break;
					case Dir.LEFT:		handleTileIndicator(Dir.LEFT); 		break;
					case Dir.RIGHT:		handleTileIndicator(Dir.RIGHT); 	break;
					case Dir.DOWNLEFT: 	handleTileIndicator(Dir.DOWNLEFT);	break;
					case Dir.UPLEFT: 	handleTileIndicator(Dir.UPLEFT);	break;
					case Dir.DOWNRIGHT: handleTileIndicator(Dir.DOWNRIGHT);	break;
					case Dir.UPRIGHT: 	handleTileIndicator(Dir.UPRIGHT); 	break;
					break;
				}
				
				if (tileChosen) { 
					x = cx, y = cy, z = cz;
					if(!keyDown[Settings.flagKey()]) flagKeyPressed = false;
					
					switch(key) {
						case Settings.actionKey():
						if (!hasFlag[x + y * mw + z * ms]) {
							MineMap.uncover(x, y, z);
							tileChosen = false;
						}
						break;
						case Settings.flagKey():
							if (!flagKeyPressed) {
								MineMap.toggleFlag(xyz);
								flagKeyPressed = true;
								tileChosen = false;
							}
						break;
					}
				}
				else if (p.interactingWith.length) {
					if (key == Settings.actionKey()) {
						for (var i:uint = coll.length; i--; ) {
							eid = coll[i];
							if (eid > -1) {
								Engine.sSprites[Engine.sSpriteIDLs[eid]].triggerEvent(); 
								p.interActWith(eid);
								break;
							}
						}
					}
				}
			}
			else tileChosen = false;
		}
		
		private static function keysWithArrows(kpq:Array):int {
			var k:int = 0, n:int = -1, j:int;
			
			for (var i:uint = kpq.length; i--; ) {
				j = kpq[i];
				if (n == -1) {
					switch(j) {
						case Key.DOWN: 	n = Dir.DOWN; 	break;
						case Key.UP: 	n = Dir.UP; 	break;
						case Key.RIGHT:	n = Dir.RIGHT; 	break;
						case Key.LEFT: 	n = Dir.LEFT; 	break;
					}
				}
				else {
					switch(n) {
						case Dir.DOWN:
							if (j == Key.RIGHT) return Dir.DOWNRIGHT;
							if (j == Key.LEFT) 	return Dir.DOWNLEFT;
						case Dir.UP:
							if (j == Key.RIGHT) return Dir.UPRIGHT;
							if (j == Key.LEFT) 	return Dir.UPLEFT;
						case Dir.RIGHT:
							if (j == Key.DOWN) 	return Dir.DOWNRIGHT;
							if (j == Key.UP) 	return Dir.UPRIGHT;
						case Dir.LEFT:
							if (j == Key.DOWN) 	return Dir.DOWNLEFT;
							if (j == Key.UP) 	return Dir.UPLEFT;
					}
				}
			}
			return n;
		}
		
		private static function handleTileIndicator(dir:uint):void {
			const isCovered:Array = Map.isCovered, hasObs:Array = Map.hasObs;
			const th:uint = Map.tileHeight, tw:uint = Map.tileWidth, mw:uint = Map.mapWidth, ms:uint = Map.mapSize;
			var tile:int, tx:int, ty:int, tz:int;
			
			const p:Entity = Engine.player.ent;
			const x:int = p.x + p.hotx, y:int = p.y + p.hoty, hw:uint = p.hotwidth, hh:uint = p.hotheight;
			const mx:int = x + hh / 2, rx:int = x + hh, my:int = y + hh / 2, dy:int = y + hh;
			
			switch(dir) {
				case Dir.DOWN:		{ tx = mx / hw; ty = (dy + 1) / hh;			break; }
				case Dir.UP: 		{ tx = mx / hw; ty = (y - 1) / hh;			break; }
				case Dir.RIGHT: 	{ tx = (rx + 1) / hw; ty = my / hh;			break; }  
				case Dir.LEFT: 		{ tx = (x - 1) / hw; ty = my / hh;			break; }
				case Dir.DOWNRIGHT: { tx = (rx + 1) / hw; ty = (dy + 1) / hh; 	break; }
				case Dir.DOWNLEFT:	{ tx = (x - 1) / hw; ty = (dy + 1) / hh; 	break; }
				case Dir.UPRIGHT: 	{ tx = (rx + 1) / hw; ty = (y - 1) / hh; 	break; } 
				case Dir.UPLEFT: 	{ tx = (x - 1) / hw; ty = (y - 1) / hh; 	break; }
			}
			
			tile = tx + ty * mw + tz * ms;
			
			if (isCovered[tile]) {
				tileChosen = true;
				cx = tx;
				cy = ty;
				cz = tz;
				GameModel.tileIndicator.moveT(tx, ty, tz);
			}
			else {
				tileChosen = false; 
			}
		}
		
		private static function handleTileIndicator2(dir:uint):void {
			const isCovered:Array = Map.isCovered, hasObs:Array = Map.hasObs;
			const th:uint = Map.tileHeight, tw:uint = Map.tileWidth, mw:uint = Map.mapWidth, ms:uint = Map.mapSize;
			var tile:int, tx:int, ty:int, tz:int;
			
			const p:Entity = Engine.player.ent;
			const x:int = p.x + p.hotx, y:int = p.y + p.hoty, hw:uint = p.hotwidth, hh:uint = p.hotheight;
			const mx:int = x + hh / 2, rx:int = x + hh, my:int = y + hh / 2, dy:int = y + hh;
			
			switch(dir) {
				case Dir.DOWN:		{ tx = mx / hw; ty = (dy + 1) / hh;			break; }
				case Dir.UP: 		{ tx = mx / hw; ty = (y - 1) / hh;			break; }
				case Dir.RIGHT: 	{ tx = (rx + 1) / hw; ty = my / hh;			break; }  
				case Dir.LEFT: 		{ tx = (x - 1) / hw; ty = my / hh;			break; }
				case Dir.DOWNRIGHT: { tx = (rx + 1) / hw; ty = (dy + 1) / hh; 	break; }
				case Dir.DOWNLEFT:	{ tx = (x - 1) / hw; ty = (dy + 1) / hh; 	break; }
				case Dir.UPRIGHT: 	{ tx = (rx + 1) / hw; ty = (y - 1) / hh; 	break; } 
				case Dir.UPLEFT: 	{ tx = (x - 1) / hw; ty = (y - 1) / hh; 	break; }
			}
			
			tile = tx + ty * mw + tz * ms;
			
			if (isCovered[tile]) {
				tileChosen = true;
				cx = tx;
				cy = ty;
				cz = tz;
			}
		}
	}
}