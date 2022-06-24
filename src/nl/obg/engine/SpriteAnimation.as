package nl.obg.engine { 
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	/*
	 *  This was meant as a solution to improve performance by cutting out unanimated sprites, 
	 *  but now nothing is done with it.
	 */
	public class SpriteAnimation {
		public var name:String;
		public var spriteName:String;
		
		// * MAPSRITE POSITION VARIABES * //
		
		public var x:int = 0;
		public var y:int = 0;	
		public var z:int = 0;	
		
		// x,y position in tiles
		public var tx:int = 0;
		public var ty:int = 0;
		
		public var hotx:uint = 0;
		public var hoty:uint = 0;
		
		// offset position
		protected var ox:int;
		protected var oy:int;
		
		public var width:uint = 0;
		public var height:uint = 0;
		
		// Array of sprite positions in tiles
		public var vp:Array = [];
		
		// Array of sprite positions in tiles
		public var nwVp:Array = [];
		
		// * END POSITION VARIABES * //
		
		// * MAPSRITE ANIMATION VARIABES * //
		
		public var spriteFrame:Array;
		public var curFrame:uint;
		protected var animScript:Array;
		protected var newScript:String;
		protected var curScript:String;
		protected var animCommand:uint = 0;
		protected var animDelay:uint = 0;
		protected var animCommands:Array;
		public var spriteRect:Rectangle;
		
		// * END ANIMATION VARIABES * //
		
		protected var engine:Engine;
		public var id:uint;
		
		// * MAPSRITE MAP VARIABES * //
		
		protected var tileWidth:uint;
		protected var tileHeight:uint;
		protected var mapWidth:uint;
		protected var mapHeight:uint;
		protected var mapSize:uint;
		
		// id * mapSize
		protected var idtms:uint;
		
		// * END MAP VARIABES * //
		
		// * MAPSRITE MISCELLANEOUS VARIABES * //
		
		// onscreen
		public var visible:Boolean = true;
		
		// * END MISCELLANEOUS VARIABES * //
		
		public function SpriteAnimation( x:int, y:int, z:uint, nwSpriteName:String) {
			const m:Map = e.map;
			
			engine = e;
			
			// why not? You're going to use them a zillion times anyway.
			tileWidth = 	m.tileWidth;
			tileHeight = 	m.tileHeight;
			mapWidth = 		m.mapWidth;
			mapHeight = 	m.mapHeight;
			mapSize = 		m.mapSize;
			
			if (!spriteName) spriteName = "mapsprites/" + nwSpriteName;
			loadSprite(e.getBitmapData(spriteName));
			
			e.addMapSprite(this);
			idtms =	mapSize * id;
			
			move(x, y, z);
		}
		
		public static function updateAnimation():void {
			var command:String, script:String = newScript;
			
			// no script? no animation then
			if (!script) return;
			
			if (script == curScript) {
				if (animDelay) {
					animDelay--;
				}
				else {
					animCommand++;
					if (animCommand == animCommands[script].length) animCommand = 0;
					command = animCommands[script][animCommand];
				}
				if (command == "W") {
					animDelay = animScript[script][animCommand];
				}
			}
			else {
				curScript = script;
				animCommand = 0;
				animDelay = 0;
				command = animCommands[script][0];
			}
			if (command == "F") {
				curFrame = animScript[script][animCommand];
			}
		}
		
	}
}