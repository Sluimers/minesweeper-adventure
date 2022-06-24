package nl.obg.engine {
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import nl.obg.mapscripts.*;
	import nl.obg.controllers.*;
	import nl.obg.debug.*;
	import nl.obg.locals.*;
	
	level1;
	level2;
	
	public class Engine {
		
		public static var stage:Stage;
		public static var graphics:Graphics;
		
		/* Generic entity Arrays */
		
		// Entity arrays
		public static var ents:Array = [];
		public static var entIDs:Array = [];
		public static var entIDLs:Array = [];
		
		// Solid sprite Arrays
		public static var sSprites:Array = [];
		public static var sSpriteIDs:Array = [];
		public static var sSpriteIDLs:Array = [];
		
		// Animated sprite Arrays
		public static var animSprites:Array = [];
		public static var animSpriteIDs:Array = [];
		public static var animSpriteIDLs:Array = [];
		
		// Mapsprite Arrays
		public static var sprites:Array = [];
		public static var spriteIDs:Array = [];
		public static var spriteIDLs:Array = [];
		
		// free IDs of sprites
		public static var freeSpriteIDs:Array = [];
		
		/* End entity Arrays */
		
		public static var player:Player;
		
		private static const POINT_ZERO:Point = new Point(0, 0);
		
		private static var systemClock:Date;
		private static var delayTime:uint;
		
		public static var freeze:Boolean = false;
		
		public static var isMapLoaded:Boolean = false;
		
		// for performance
		private static var now:int = 		getTimer();
		private static var oldTime:int =	getTimer(); 
		
		// for camera position
		public static var xwin:int = 0;
		public static var ywin:int = 0;
		
		// tiledrawing variables
		private static var vtw:uint = 0;
		private static var vth:uint = 0;
		private static var tilesToDraw:uint = 0;
		
		private static var hookretrace:Array = [];
		private static var hooktimer:Array = [];
		
		// for drawing
		public static var canvas:BitmapData;
		
		// for debugging purposes
		public static var breakLine:Boolean = false;
		public static var counting:Boolean = false;
		public static var counter:int = 0;
		
		public static var gameTickTime:int = 0;
		public static var renderTime:int = 0;
		public static var processEntitiesTime:int = 0;
		public static var hookNDebugTime:int = 0;
		public static var renderLayersTime:int = 0;
		public static var renderEntsTime:int = 0;
		public static var renderNumbersTime:int = 0;
		public static var renderTilesTime:int = 0;
		public static var renderCoversTime:int = 0;
		public static var loadBMDTime:int = 0;
		public static var slowMotion:Boolean = false;
		
		public static var cameraTarget:Entity;
		
		private static var frameSkip:uint = 10;
		
		private static const ZERO_POINT:Point = new Point(0, 0);
		
		private static var cover:BitmapData;
		
		public static var tileRect:Rectangle;
		public static var rectBMD:BitmapData;
		
		private static var numberFieldsBMD:Array = [];
		
		public static var main:Main;
		
		public static function init():void {
			player = new Player();
			main.init();
			Debug.addDebugger(main);
			MenuControl.init(main);
			GameControl.init(main);
			
			//Benchmark.init();
			MenuControl.addMenu("StartMenu");
		}
		
		public static function addMain(nwMain:Main):void {
			main = nwMain;
		}
			
		public static function windowNotActive(e:Event):void {
			freeze = true;
		}
		
		public static function windowActive(e:Event):void {
			freeze = false;
		}
		
		// the engine function, where all game events and enemy movements are calculated.
		public static function run(event:Event):void {
			const tnow:int = now;
			var skipCountDown:uint = frameSkip, startTime3:int, startTime2:int, startTime4:int;
			
			const startTime:int = getTimer();
			for (var i:int = tnow - oldTime; i--; ) {
				Debug.debugString = "";
				
				// if(breakLine) for (var j:int =  10000000; j--; ) {}
				
				// control methods go here
				KeyControl.listenToInput(); 
				
				if (!freeze) {	// apparently it should be possible to freeze the entities without resorting to this
					startTime3 = getTimer();
					processEntities();
					processEntitiesTime = processEntitiesTime + getTimer() - startTime3;
				}
				
				if (hooktimer) doHook(hooktimer);
				
				if (!skipCountDown) break; 
				skipCountDown--;
			}
			gameTickTime = gameTickTime + getTimer() - startTime;
			
			oldTime = tnow;
			now = getTimer();
			
			startTime2 = getTimer();
			render();
			renderTime = renderTime + getTimer() - startTime2;
			
			startTime4 = getTimer();
			if(hookretrace) doHook(hookretrace);
			if(Debug.showDebug) Debug.debug();			// should this be in showpage??
			hookNDebugTime = hookNDebugTime + getTimer() - startTime4;
			
			if (counter == 1000) {
				trace("renderTime:" + renderTime);
				trace("renderLayersTime:" + renderLayersTime);
				trace("renderEntsTime:" + renderEntsTime);
				trace("renderTilesTime:" + renderTilesTime);
				trace("renderCoversTime:" + renderCoversTime);
				trace("gameTickTime:" + gameTickTime);
				trace("processEntitiesTime:" + processEntitiesTime);
				trace("hookNDebugTime:" + hookNDebugTime);
				counting = false;
				counter = 0;
			}
			else if(counting) counter++;
		}
		
		private static function render():void {
			/*
			 *	FIXME: There are thrree things wrong here:
			 * 			1) NO WRAP! This causes map to crash as soon as the viewport can be naturally divided by the height of tiles.
			 * 			2) The renderlayers function constantly asks for all the tiles in the viewport, instead of calculating change.
			 * 			3) Empty layers and empty entity layers are still being asked for. Useless.
			 */
			
			if (!isMapLoaded) return;
			
			const s:Stage = main.stage;
			const w:uint = s.stageWidth, h:uint = s.stageHeight;
			const tw:uint = Map.tileWidth, th:uint = Map.tileHeight;
			const mw:uint = Map.mapWidth, ms:uint = Map.mapSize, ic:Array = Map.isCovered;
			const vtw:uint = vtw, vth:uint = vth;
			const ts:Array = Map.tileSheet;
			const ld:Array = Map.getLayerData();
			const c:Entity = cameraTarget;
			const canvas:BitmapData = canvas;
			
			if (c) setCamera(c.x + c.hotwidth / 2 + c.hotx - w / 2, c.y + c.hotheight / 2 + c.hoty - h / 2);
			
			const xwin:int = xwin, ywin:int = ywin;
			const xyz:int = int(xwin / tw) + vtw - 1 + int(ywin / th) * mw + vth * mw - mw;  
			
			
			const dx:uint = w - w % tw - xwin % tw;
			const dy:uint = h - h % th - ywin % th;
			
			// tile animation?
			//tiles->UpdateAnimation(GetTime());
			
			// Note that we do not clear the screen here.  This is intentional.
			const startTime:int = getTimer();
			renderLayers(xyz, xwin, ywin, mw, ms, tw, th, vtw, vth, dx, dy, ts, ld, ic, canvas);
			renderLayersTime = renderLayersTime + getTimer() - startTime;
		}
		
		private static function renderLayers(xyz:int, xwin:int, ywin:int, mw:uint, ms:uint, tw:uint, th:uint, vtw:uint, vth:uint, dx:uint, dy:uint, ts:Array, ld:Array, ic:Array, canvas:BitmapData):void {
			const rect:Rectangle = tileRect;
			var j:int, x:int, y:int, n:int, num:int;
			var p:Point = new Point(dx, dy);
			var numBMD:BitmapData, startTime0:int, startTime3:int, startTime4:int;
			
			y = vth - 1;
			x = vtw - 1;
			n = j = xyz;
			
			for (var i:int = tilesToDraw; i--; ) {
				startTime3 = getTimer();
				
				canvas.copyPixels(ts[ld[n]], rect, p, null, null, true);
				renderTilesTime = renderTilesTime + getTimer() - startTime3;
				
				startTime0 = getTimer();
				if (ic[n]) canvas.copyPixels(cover, rect, p, null, null, true);
				renderCoversTime = renderCoversTime + getTimer() - startTime0;
				
				startTime4 = getTimer();
				if (!x) {
					p.x = dx;
					x = vtw - 1;
					if (!y) {
						// render enities after the images have been drawn
						p.y = dy;
						renderSprites(j, xwin, ywin, vtw, vth, mw); 
						
						y = vth - 1;
						n = j = j + ms;
					}
					else {
						y--;
						p.y = p.y - th;
						n = n - mw + x;
					}
				}
				else {
					x--;
					n--;
					p.x = p.x - tw;
				}
				renderEntsTime = renderEntsTime + getTimer() - startTime4;
			}
		}
		
		private static function renderSprites(xyz:int, xwin:int, ywin:int, vtw:uint, vth:uint, mw:uint):void {
			const spriteIDxYs:Array = [], spriteIDCs:Array = [];
			var x:int = vtw, n:int = xyz, id:int, smx:int, smy:int, sprite:MapSprite;
			var ids:Array; 
			var spriteIDxY:Object;
			
			/*
			 * This can be optimized by figuring out which sprites come in at the corners (or through teleportation).
			 * Otherwise, your rendering is too slow if an entity moves a tile at every render, isn't it?
			 */
			for (var i:int = vth * vtw; i--; ) {
				x--;
				
				ids = Map.hasSprite[n];
				
				// Yes Virginia, using an if statement for null's IS faster!
				if (ids) {
					for (var j:int = ids.length; j--; ) {
						id = ids[j];
						if (!spriteIDCs[id]) {
							spriteIDCs[id] = true;
							
							sprite = sprites[spriteIDLs[id]];
							
							if (sprite.visible) {
								spriteIDxY = { id:id, y:sprite.y + sprite.height };
								spriteIDxYs.push(spriteIDxY);
							}
						}
					}
				}
				
				if (!x) {
					x = vtw;
					n = n - mw + vtw;
				}
				n--;
			}
			
			// This could be manually 
			spriteIDxYs.sortOn("y", Array.NUMERIC | Array.DESCENDING);
			
			for (j = spriteIDxYs.length; j-- ; ) {
				sprite = sprites[spriteIDLs[spriteIDxYs[j].id]];
				smx = sprite.x - xwin;
				smy = sprite.y - ywin;
				canvas.copyPixels(sprite.spriteFrame[sprite.curFrame], sprite.spriteRect, new Point(smx, smy) , null, null, true);
			}
		}
		
		// make sure the amount of loops stay at a minimum
		private static function processEntities():void {
			const e:Array = ents, len:int = e.length;
			var ent:Entity;
			
			// direction phase
			for (var i:int = len; i--; ) {
				ent = e[i];
				if (ent.alive) {
					ent.direct();
					if (ent.stepping) ent.tile();
				}
			}
			
			// collision phase 
			for (i = len; i--; ) {
				ent = e[i];
				if (ent.stepping) {
					// the thing here is that at first you check if you hit an object
					// and then you check if that results in you being stopped or not
					if (ent.hitsObject()) {
						if (ent.collides()) {
							ent.oldtile();
							continue;
						}
					}
					ent.newtile();
					ent.step();
				}
			}
			
			// animation phase
			for (i = animSprites.length; i--; ) {
				animSprites[i].updateAnimation();
			}
		}
		
		private static  function setCamera(x:int, y:int):void {
			const s:Stage = main.stage, maxywin:int = Map.height - s.stageHeight, maxxwin:int = Map.width - s.stageWidth, maxx:int = x - maxxwin, maxy:int = y - maxywin;
			
			if (x < 0) 				xwin = 0;
			else if (maxx > 0) 		xwin = maxxwin;
			else 					xwin = x;
			if (y < 0) 				ywin = 0;
			else if (maxy > 0) 		ywin = maxywin;
			else					ywin = y;
		}
		
		private static function removeFromHookTimer(f:Function):void {
			const i:int = hooktimer.indexOf(f);
			if(i!=-1) hooktimer.splice(i);
		}
		
		public static function loadNumberFields(tw:int, th:int):void {
			cover = new BitmapData(tw, th, true, 0x33000000);
			for (var i:int = 8; i; i--) {
				numberFieldsBMD[i] = PObjectList.getBitmapData("numbers/" + (i) + ".png");
			}
		}
		
		public static function addAnimSprite(sprite:MapSprite):void {
			const id:uint = sprite.id;
			animSprites.push(sprite);
			animSpriteIDs.push(id);
			animSpriteIDLs[id] = animSpriteIDs.length - 1;
		}
		
		public static function addEnt(ent:Entity):void {
			const id:uint = ent.id;
			ents.push(ent);
			entIDs.push(id);
			entIDLs[id] = entIDs.length - 1;
		}
		
		public static function addSolidMapSprite(sprite:SolidMapSprite):void {
			var id:uint = spriteIDs[spriteIDs.length - 1];
			sSprites.push(sprite);
			
			sSpriteIDs.push(id);
			sSpriteIDLs[id] = sSpriteIDs.length - 1;
		}
		
		public static function addMapSprite(sprite:MapSprite):void {
			const freeIDs:Array = freeSpriteIDs, id:uint = freeIDs.pop();
			if (!freeIDs.length) {
				freeIDs.push(id + 1);
				spriteIDLs.push(id);
			}
			else {
				//trace("spriteIDLs 3:" + spriteIDLs);
				spriteIDLs[id] = spriteIDs.length;
			}
			
			sprite.id = id;
			sprites.push(sprite);
			spriteIDs.push(id);
			
			
			/*
			trace("Adding MapSprite...");
			trace("sprite name:" + sprite.name);
			trace("sprite id:" + id);
			trace("freeSpriteIDs: " + freeSpriteIDs);
			trace("spriteIDLs: " + spriteIDLs);
			trace("spriteIDs: " + spriteIDs);
			trace("sSpriteIDs: " + sSpriteIDs);
			trace("sSpriteIDLs: " + sSpriteIDLs);
			trace("entIDs: " + entIDs);
			trace("entIDLs: " + entIDLs);
			trace();
			*/
			
		}
		
		public static function removeEntity(id:uint):void {
			const lastId:uint = entIDs.pop();
			const idLoc:uint = entIDLs[id];
			
			//trace("Removing Entity...");
			//trace("sprite name:" + ents[idLoc].name);
			
			if(id != lastId) {
				ents[idLoc] = ents.pop();
				entIDs[idLoc] = lastId;
				entIDLs[lastId] = idLoc;
			}
			else ents.pop();
			
			/*
			trace("sprite id:" + id);
			trace("freeSpriteIDs: " + freeSpriteIDs);
			trace("spriteIDLs: " + spriteIDLs);
			trace("spriteIDs: " + spriteIDs);
			trace("sSpriteIDs: " + sSpriteIDs);
			trace("sSpriteIDLs: " + sSpriteIDLs);
			trace("entIDs: " + entIDs);
			trace("entIDLs: " + entIDLs);
			trace("\n");
			*/
		}
		
		public static function removeSolidMapSprite(id:uint):void {
			const lastId:uint = sSpriteIDs.pop();
			const idLoc:uint = sSpriteIDLs[id];
			
			if(id != lastId) {
				sSprites[idLoc] = sSprites.pop();
				sSpriteIDs[idLoc] = lastId;
				sSpriteIDLs[lastId] = idLoc;
			}
		}
		
		public static function removeMapSprite(id:uint):void {
			const lastId:uint = spriteIDs.pop();
			const idLoc:uint = spriteIDLs[id];
			
			if (id != lastId) {
				sprites[idLoc].detile();
				sprites[idLoc] = sprites.pop();
				spriteIDs[idLoc] = lastId;
				spriteIDLs[lastId] = idLoc;
			}
			else sprites.pop().detile();
			freeSpriteIDs.push(id);
		}
		
		public static function removeAnimSprite(id:int):void {
			const lastId:uint = animSpriteIDs.pop();
			const idLoc:uint = animSpriteIDLs[id];
			
			if(id != lastId) {
				animSprites[idLoc] = animSprites.pop();
				animSpriteIDs[idLoc] = lastId;
				animSpriteIDLs[lastId] = idLoc;
			}
			else animSprites.pop();
		}
		
		// for now just renders other stuff
		private static  function doHook(hooklist:Array):void {
			for (var i:int = hooklist.length; i--; ) {
				hooklist[i].call();
			}
		}
		
		// Unused at the moment. Question is if listeners doesn't make this function obsolete.
		public static  function addHookTimer(f:Function):void {
			hooktimer.push(f);
		}
		
		// Unused at the moment. Question is if all the flash stuff doesn't make this function obsolete.
		public static  function addHookRetrace(f:Function, hook:String = ""):void {
			hookretrace.push(f);
		}
		
		public static  function removeHookTimer(f:Function):void {
			for (var i:int = hooktimer.length; i--; ) {
				if (hooktimer[i] == f) {
					hooktimer.splice(i, 1); 
					break;
				}
			}
		}
		
		public static  function removeHooks():void {
			hookretrace = [];
			hooktimer = [];
		}
		
		public static function getTileWidth():uint {
			return Map.tileWidth;
		}
		
		public static function getTileHeight():uint {
			return Map.tileHeight;
		}
		
		public static function getPlayer():Player {
			return player;
		}
		
		public static function getEnt(id:uint):Entity {
			return ents[entIDLs[id]];
		}
		
		public static function setSizes(tw:int, th:int, mw:int, mh:int):void {
			setVTW(tw, mw);
			setVTH(th, mh);
			setTileRect(tw, th);
			tilesToDraw = vtw * vth * Map.numLayers;
		}
		
		public static  function setVTW(tileWidth:uint, mapWidth:uint):void {
			vtw = main.stage.stageWidth / tileWidth + 1;
			if (vtw > mapWidth) vtw = mapWidth;
		}
		
		public static  function setVTH(tileHeight:uint, mapHeight:uint):void {
			vth = main.stage.stageHeight / tileHeight + 1;
			if (vtw > mapHeight) vtw = mapHeight;
		}
		
		public static  function setTileRect(tw:int,th:int):void {
			tileRect = new Rectangle(0, 0, tw, th);
			rectBMD = new BitmapData(tw, th, true, 0);
		}
		
		public static  function setCameraTarget(target:Entity):void {
			cameraTarget = target;
		}
		
		public static  function getCameraTarget():Entity {
			return cameraTarget;
		}
		
		public static function setPlayer(nwPlayer:Player):void {
			player = nwPlayer;
			cameraTarget = nwPlayer.ent;
		}
		
		public static function setEntities(nwEnts:Array):void {
			ents = nwEnts;
		}
		
		public static function getMapViewWidth():uint {
			return vtw * Map.tileWidth;
		}
		
		public static function getMapViewHeight():uint {
			return vth * Map.tileHeight;
		}
		
		public static function getXYZ(sprite:MapSprite):String {
			return sprite.name + ": (" + sprite.tx + "," + sprite.ty + "," + sprite.z + ")";
		}
	}
}