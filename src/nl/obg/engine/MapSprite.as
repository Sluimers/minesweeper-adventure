package nl.obg.engine { 
	import flash.geom.Rectangle;
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import nl.obg.locals.PObjectList;
	
	public class MapSprite {
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
		
		// Array of solid positions in tiles
		public var onp:Array = [];
		
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
		public var id:uint;
		
		// * MAPSRITE MAP VARIABES * //
		
		public var tileWidth:uint;
		public var tileHeight:uint;
		public var mapWidth:uint;
		public var mapHeight:uint;
		public var mapSize:uint;
		
		// id * mapSize
		protected var idtms:uint;
		
		// * END MAP VARIABES * //
		
		// * MAPSRITE MISCELLANEOUS VARIABES * //
		
		// onscreen
		public var visible:Boolean = true;
		protected var animation:Boolean = false;
		protected var useful:Boolean = true;
		protected var type:int;
		
		protected static const MAPSPRITE:int = 			0;
		protected static const SOLIDMAPSPRITE:int = 	1;
		protected static const ENTITY:int = 			2;
		
		// * END MISCELLANEOUS VARIABES * //
		
		public function MapSprite(x:int, y:int, z:uint, nwSpriteName:String) {
			
			// Why not? You're going to use them a zillion times anyway.
			tileWidth = 	Map.tileWidth;
			tileHeight = 	Map.tileHeight;
			mapWidth = 		Map.mapWidth;
			mapHeight = 	Map.mapHeight;
			mapSize = 		Map.mapSize;
			
			Engine.addMapSprite(this);
			
			if (!spriteName) spriteName = "mapsprites/" + nwSpriteName;
			loadSprite(PObjectList.getBitmapData(spriteName));
			
			idtms =	mapSize * id;
			
			move(x, y, z);
		}
		
		public function loadSprite(sprite:BitmapData):void {
			if (sprite == null) trace("error: no bitmapdata from " + spriteName);
			
			const spriteWidth:uint = sprite.width, spriteHeight:uint = sprite.height;
			const w:uint = !width?width = spriteWidth:width, h:uint = !height?height = spriteHeight:height;
			const p:Point = new Point();
			var b:BitmapData, r:Rectangle;
			
			spriteRect = new Rectangle(0, 0, w, h);
			
			r = spriteRect.clone();
			spriteFrame = [];
			
			for (var j:int = 0; j < spriteHeight / h; j++) {
				for (var i:int = 0; i < spriteWidth / w; i++) {
					b = new BitmapData(w, h);
					r.x = i * w;
					r.y = j * h;
					b.copyPixels(sprite, r, p);
					spriteFrame.push(b);
				}
			}
			
			/* 
			* 	You have more than one frame?
			*  	You must be in constant need of animation then.
			*/
			if (spriteFrame.length > 1) animate();
		}
		
		public function move(nwX:int, nwY:int, nwZ:int = 0):void {
			x = nwX - hotx;
			y = nwY - hoty;
			
			tx = nwX / tileWidth;
			ty = nwY / tileHeight;
			
			ox = nwX % tileWidth;
			oy = nwY % tileHeight;
			
			const xyz:int = tx + ty * mapWidth + nwZ * mapSize;
			
			z =  nwZ;
			
			detile();
			
			if(xyz > -1) {
				vp = [xyz];
				tile();
			}
		}
		
		public function moveT(nwTX:int, nwTY:int, nwZ:int = 0):void {
			const xyz:int = nwTX + nwTY * mapWidth + nwZ * mapSize;
			
			ox = 0;
			oy = 0;
			
			tx = nwTX;
			ty = nwTY;
			
			x = tileWidth * nwTX - hotx;
			y = tileHeight * nwTY - hoty;
			
			z =  nwZ;
			
			detile();
			
			if(xyz > -1) {
				vp = [xyz];
				tile();
			}
		}
		
		public function animate():void {
			if (!animation) {
				Engine.addAnimSprite(this);
				animation = true;
			}
		}
		
		public function inAnimate():void {
			if (animation) {
				Engine.removeAnimSprite(id);
				animation = false;
			}
		}
		
		public function updateAnimation():void {
			var command:String, script:String = newScript;
			
			// You have served your purpose well, goodbye young mapSprite.
			if (!useful) {
				switch(type) {
					case ENTITY: 			Engine.removeEntity(id); 
					case SOLIDMAPSPRITE: 	Engine.removeSolidMapSprite(id); 
					default: 				Engine.removeMapSprite(id);
											Engine.removeAnimSprite(id);
				}
			}
			
			// No script? No animation for you then.
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
		
		// Get all tiles(points) where the sprite is visible.
		public function getVp():Array {
			return vp;
		}
		
		/*  
		 * Please note that if you want use to this piece of code DO give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * Part of Sluimers' Mega Awesome Super Hack Collision Detection System.
		 */
		public function tile():void {
			const vp:Array = vp;
			var xyz:int, idlxyz:int;
			
			for (var i:uint = vp.length; i--; ) {
				xyz = vp[i];
				
				idlxyz = idtms + xyz;
					
				if (Map.hasSpriteIDLs[idlxyz] == undefined) {
					Map.hasSpriteIDLs[idlxyz] = Map.hasSprite[xyz].push(id) - 1;
				}
			}
		}
		
		/*  
		 * Please note that if you want use to this piece of code DO give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * Part of Sluimers' Mega Awesome Super Hack Collision Detection System.
		 */
		public function detile():void {
			const v:Array = vp;
			var lastId:uint, idLoc:uint, idlxyz:int, xyz:int;
			
			for (var i:int = v.length; i--; ) {
				xyz = v[i];
				
				idlxyz = xyz + idtms;
				
				lastId = Map.hasSprite[xyz].pop();
				idLoc = Map.hasSpriteIDLs[idlxyz];
				Map.hasSpriteIDLs[idlxyz] = undefined;
				
				if(id != lastId) {
					Map.hasSprite[xyz][idLoc] = lastId;
					Map.hasSpriteIDLs[lastId * mapSize + xyz] = idLoc;
				}
				
			}
			
			if (type != MAPSPRITE) {
				const o:Array = onp;
				
				for (i = o.length; i--; ) {
					xyz = o[i];
					
					lastId = Map.hasSolid[xyz].pop();
					idLoc = Map.hasSolidIDLs[xyz + idtms];
					Map.hasSolidIDLs[xyz + idtms] = undefined;
					
					if(id != lastId) {
						Map.hasSolid[xyz][idLoc] = lastId;
						Map.hasSolidIDLs[lastId * mapSize + xyz] = idLoc;
					}
				}
			}
		}
		
		public function removeFromGame():void {
			if (!animation) animate();
			useful = false;
		}
		
		public function onNewMap():void {
			tileWidth = Map.tileWidth;
			tileHeight = Map.tileHeight;
			mapWidth = Map.mapWidth;
			mapHeight = Map.mapHeight;
			mapSize = Map.mapSize;
		}
		
		public function get xyz():int 		{ return tx + ty * mapWidth + z * mapSize; }
	}
}