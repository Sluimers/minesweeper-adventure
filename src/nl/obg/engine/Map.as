package nl.obg.engine {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BevelFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.ID3Info;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	
	import nl.obg.locals.*;
	
	import nl.obg.mapsprites.*;
	
	import nl.obg.mine.MineMap;
	
	public class Map {
		
		public static var buggyCode:Boolean = false;
		
		public static var xwin:int, ywin:int;
		
		// the map
		private static var mapData:MapData;
		
		// background, foreground and grid
		private static var cdi:Shape;
		
		// Array of mines
		private static var mines:Array;
		
		// tile containing neither numbers nor mines
		public static var isEmpty:Array;
		
		public static var hasLight:Array;
		public static var hasSound:Array;
		
		public static var layerData:Array;
		
		public static var tileSheet:Array;
		
		// Grid of sets of ent id's 
		public static var hasSolid:Array;
		public static var hasSolidIDLs:Array;
		
		// same as hasSolid, but for mapsprites id's that are not ents
		public static var hasSprite:Array;
		public static var hasSpriteIDLs:Array;
		
		public static var hasCluster:Array;
		public static var clusters:Array;
		
		private static  var flags:Array;
		
		// Vector of booleans saying whether the tile is covered
		public static var isCovered:Array;
		
		// Vector of unsigened integers saying what kind of obstruction the tile is
		public static var obs:Array;
		
		// Vector of booleans saying  whether the tile is an obstruction (as opposed to a cover, outer wall)
		public static var hasObs:Array;
		
		// Vector of integers
		public static var zone:Array;
		
		// Array of covers
		private static var covers:Array;
		
		// no Mines can be placed here
		public static var canMine:Array;
		
		public static var savedMapData:Array = [];
		public static var spritesOnumLayers:Array;
		
		// timers that clear on a mapSwitch
		private static var timers:Array;
		
		public static var currentMapName:String = "";
		public static var mapScript:*;
		
		// Map Dimensions //
		private static var _tileWidth:uint;
		private static var _tileHeight:uint;
		private static var _mapWidth:uint;
		private static var _mapHeight:uint;
		private static var _mapSize:uint;			// mapWidth * mapHeight
		private static var _mapVolume:uint;			// mapSize * numLayers 
		private static var _width:uint;
		private static var _height:uint;
		private static var _numLayers:uint;
		
		public static var x:uint;
		public static var y:uint;
		
		public function Map() {
		}
		
		public static function resetMap():void {
			const mw:uint = mapWidth, mh:uint = mapHeight, ms:uint = mapSize;
			const numLayers:uint = numLayers, mapVolume:uint = ms * numLayers; 
			var i:int, j:uint = 0, k:uint = 0;
			
			Engine.ents = [];
			Engine.sprites = [];
			Engine.spriteIDs = [];
			Engine.spriteIDLs = [];
			Engine.sSpriteIDs = [];
			Engine.sSpriteIDLs = [];
			Engine.entIDs = [];
			Engine.entIDLs = [];
			Engine.freeSpriteIDs = [];
			
			mines = [];
			flags = [];
			
			isEmpty = [];
			
			// I know, bad names 
			hasLight = [];
			hasSound = [];
			
			canMine = [];
			isCovered = [];
			hasSolid = [];
			hasSolidIDLs = [];
			hasSprite = [];
			hasSpriteIDLs = [];
			hasLight = [];
			hasSound = [];
			obs = [];
			hasObs = [];
			zone = [];
			
			// TODO.. WRAP THE MAP!! So this next stuff isn't needed
			// A camera of 5 tiles wide will always draw 6 tiles as to not disturb it's performance
			// Thus we need a last sprite info. 
			hasSolid[mapVolume] = [];
			hasSprite[mapVolume] = [];
			
			for (i = mapVolume; i--; ) { 
				obs[i] = 0;
				hasObs[i] = 0;
				hasSolid[i] = [];
				hasSprite[i] = [];
				hasLight[i] = [];
				hasSound[i] = [];
				canMine[i] = true;
			}
		}
		
		// FIXME: Entities shuold be placed BEFORE the mines!
		// Otherwise the mines think they can be placed next to or even on entities.
		
		public static function Switch(mapName:String):void {
			const m:MapData = loadMapData(mapName);
			const tw:int = m.tileWidth, th:int = m.tileHeight;
			
			mapData = m;
			currentMapName = mapName;
			
			layerData = m.layers;
			
			// TODO.. wrap the map in order to prevent this
			layerData.push(0);
			
			setMapSize(m.mapWidth, m.mapHeight, m.numLayers, tw, th);
			Engine.loadNumberFields(tw, th);
			resetMap();
			
			// then load the tiles
			loadTileSet(m.tsp, tw, th);
			
			// then obs zones and areas and entities
			placeObs(m.obs);
			placeZones(m.zones);
			placeEnts(m.entities);
			
			loadMapScript(mapName);
			autoExec(mapScript);
		}
		
		public static function loadMapScript(nwScript:String):void {
			mapScript = getDefinitionByName("nl.obg.www.mapscripts." + nwScript);
		}
		
		public static function loadXMLMap(mapName:String):MapData {
			const m:MapData = new MapData();
			
			try {
				const xmlMap:XML = PObjectList.getXMLData(PathName.mapsDir + mapName + ".xml");
			}
			catch(error:Error) {
				trace("Error catch: " + error);
			}
			const layers:XMLList = xmlMap.layers;
			
			m.layers = loadLayeredArray(layers.layer.data);
			m.obs = loadLayeredArray(layers.layer.obstructions);
			//m.mines = loadLayeredArray(layers.layer.mines);
			m.zones = loadLayeredArray(layers.layer.zones);
			m.entities = loadLayeredArray(layers.layer.entities);
			//m.covers = loadLayeredArray(layers.layer.covers);
			//m.nMines = loadLayeredArray(xmlMap.mineFields.mineField);
			
			m.scripts = xmlListToArray(xmlMap.zones.zone.script.text());
			// m.minefield
			
			// m.ids = xmlMap.zones.zone.label.@id
			
			m.tileWidth = xmlMap.tilewidth.text();
			m.tileHeight = xmlMap.tileheight.text();
			m.mapWidth = xmlMap.mapwidth.text();
			m.mapHeight = xmlMap.mapheight.text();
			m.numLayers = layers.layer.length();
			m.tsp = xmlMap.tileset.text();
			
			return m;
		}
		
		private static function xmlListToArray(xmlList:XMLList):Array {
			var t:int = xmlList.length();
            var a:Array = new Array(t);
            for (var i:int = t; i--; ) a[i] = xmlList[i];
            return a;
		}
		
		private static function loadLayeredArray(layerData:XMLList):Array {
			var layerArray:Array = [], s:String;
			
			for (var i:uint = 0; i < layerData.length(); i++) {
				s = layerData[i].toString();
				s = s.split('\n').join('');
				s = s.split('\r').join('');
				s = s.split('\t').join('');
				layerArray = layerArray.concat(s.split(','));
			}
			for (i = 0; i < layerArray.length; i++) {
				layerArray[i] = int(layerArray[i]);
			}
			
			return layerArray;
		}
		
		private static function loadMapData(mapName:String):MapData {
			var md:MapData = savedMapData[mapName];
			if (md) return md;
			return loadXMLMap(mapName);
		}
		
		private static function autoExec(mapScript:*):void {
			mapScript.autoExec();
		}
		
		private static  function loadTileSet(tsp:String, tw:uint, th: uint):void {	
			const tilesBitmapData:BitmapData = PObjectList.getBitmapData(PathName.tilesetsDir + tsp);
			const r:Rectangle = new Rectangle(0, 0, tw, th);
			const p:Point = new Point();
			var b:BitmapData;
			
			tileSheet = [];
			
			for (var j:int = tilesBitmapData.height / th; j--; ) {
				for (var i:int = tilesBitmapData.width / tw; i--; ) {
					b = new BitmapData(tw, th);
					r.x = i * tw;
					r.y = j * th;
					b.copyPixels(tilesBitmapData, r, p);
					tileSheet.unshift(b);
				}
			}
		}
		
		public static function toggleObs(x:int, y:int, z:int = 0):void {
			const i:uint = x + y * mapWidth + z * mapSize;
			if(!obs[i]) obs[i] = 1;
			else obs[i] = 0;
		}
		
		public static function placeObs(o:Array):void {
			
			obs = o.slice();
			hasObs = o.slice();
			
			for (var i:uint = o.length; i--; ) {
				if (o[i]) canMine[i] = false;
			}
		}
		
		public static function setObs(x:int, y:int, z:int):void {
			const xyz:int = x + y * mapWidth + z * mapSize;
			
			canMine[xyz] = false;					// uncomment if you don't want mines on objects
			hasObs[xyz] = 1;
			obs[xyz] = 1;
		}
		
		public static function placeZones(zones:Array):void {
			zone = zones;
		}
		
		// FIXME: This function should generate generic entities.
		public static function placeEnts(entities:Array):void {
			const mw:int = mapWidth, mh:int = mapHeight;
			var tx:int = --mw, ty:int = --mh, z:int = numLayers - 1, en:int;
			var x:int, y:int;
			
			for (var i:int = entities.length; i--; ) {
				en = entities[i];
				
				if (en) {
					
					x = tx * tileWidth;
					y = ty * tileHeight;
					
					canMine[i] = false;
					
					switch(en) {
						case -2: MineMap.newTestDroid(x, y, z); break;
						//case -1: newPlayer(x, y, z); break;
						case 1: MineMap.newLoSDroid(x, y, z); break;
						case 2: MineMap.newWallHugger(x, y, z); break;
						case 3: MineMap.newMineLayer(x, y, z); break;
						case 4: MineMap.newProxyDroid(x, y, z); break;
						case 5: MineMap.newGuard(x, y, z); break;
						case 6: new Sign(x, y, z, "Avatar", "sign1"); break;
						case 7: new Sign(x, y, z, "Avatar", "sign2"); break;
						case 8: new Sign(x, y, z, "Avatar", "sign3"); break;
						case 9: new Sign(x, y, z, "Avatar", "sign4"); break;
						case 10: new Sign(x, y, z, "Avatar", "sign5"); break;
						case 11: new Sign(x, y, z, "Avatar", "sign6"); break;
						case 12: new Sign(x, y, z, "Avatar", "sign7"); break;
						case 13: new Sign(x, y, z, "Avatar", "sign8"); break;
						case 14: new Powerup(x, y, z, "Stealth"); break;
						case 15: new Powerup(x, y, z, "Bomb"); break;
						case 16: new Powerup(x, y, z, "Powerdown"); break;
						case 17: new Powerup(x, y, z, "HighlightMines"); break;
					}
				}
				
				if (!tx--) {
					tx = mw;
					if (!ty--) {
						ty = mh;
						z--;
					}
				}
			}
		}
		
		public static function setZone(x:int, y:int, z:int, zn:int):void {
			const i:uint = x + y * mapWidth + z * mapSize;
			canMine[i] = false;
			zone[i] = zn;		
		}
		
		public static function clearLevel():void {
			savedMapData = [];
			removeTimers();
		}
		
		// TODO: oughtta be replaced by labels
		public static function callScriptById(zoneId:int):void {
			const f:Function = mapScript[mapData.scripts[--zoneId]];
			if (f != null) f.call();
		}
		
		public static function startTimer(delay:Number, repeat:int, listener:Function):void {
			var b:Boolean = false, o:Object, s:String, t:Timer;
			
			if (timers != null) {
				for (var i:int = timers.length; i--; ) {
					o = timers[i];
					t = o.timer;
					if (listener == o.listener) {
						b = true;
						t.reset();
						t.start();
						break;
					}
				}
			}
			
			if(!b) {
				t = new Timer(delay, repeat);
				var type:String = TimerEvent.TIMER_COMPLETE;
				t.addEventListener(type, listener);
				t.start();
				if (timers == null) timers = [];
				timers.push( { listener:listener, type:type, timer:t } );
			}
		}
		
		public static function removeTimer(listener:Function):void {
			var o:Object, t:Timer;
			
			if (timers != null) {
				for (var i:uint = timers.length; i--;) {
					o = timers[i];
					t = o.timer;
					if(listener == o.listener) {
						t.removeEventListener(o.type, listener);
						timers.splice(i, 1);
						break;
					}
				}
			}
		}
		
		public static function removeTimers():void {
			var o:Object;
			
			if (timers != null) {
				for (var i:uint = timers.length; i--;) {
					o = timers[i];
					o.timer.removeEventListener(o.type, o.listener);
				}
				timers = null;
			}
		}
		
		public static function setTile(xyz:int, t:uint):void {
			layerData[xyz] = t;
		}
		
		public static function setMapSize(mw:uint, mh:uint, nlayers:uint, tw:uint, th:uint):void {
			const ms:uint = mw * mh;
			_tileWidth = tw;
			_tileHeight = th;
			_mapWidth = mw;
			_mapHeight = mh;
			_numLayers = nlayers;
			_width = mw * tw;
			_height = mh * th;
			_mapSize = ms;
			_mapVolume = ms * nlayers;
			
			Engine.setSizes(tw, th, mw, mh);
		}
		
		public static function setPlayer(nwPlayer:Player):void {
			Engine.setPlayer(nwPlayer);
		}
		
		public static function getPlayer():Player {
			return Engine.player;
		}
		
		public static function getEntIDs():Array {
			return Engine.entIDs;
		}
		
		public static function getTileWidth():uint{
			return tileWidth;
		}
		
		public static function getTileHeight():uint {
			return tileHeight;
		}
		
		public static function getXYZ(x:int, y:int, z:int):int {
			return x + y * mapWidth + z * mapSize;
		}
		
		public static function getMapdata():MapData {
			return mapData;
		}
		
		public static function getLayerData():Array {
			return layerData;
		}
		
		public static function get width():uint 		{ return _width; }
		public static function get height():uint 		{ return _height; }
		public static function get mapWidth():uint 		{ return _mapWidth; }
		public static function get mapHeight():uint 	{ return _mapHeight; }
		public static function get numLayers():uint 	{ return _numLayers; }
		public static function get mapSize():uint 		{ return _mapSize; }
		public static function get mapVolume():uint		{ return _mapVolume; }
		public static function get tileWidth():uint 	{ return _tileWidth; }
		public static function get tileHeight():uint	{ return _tileHeight; }
	}
}