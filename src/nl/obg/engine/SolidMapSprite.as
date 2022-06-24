package nl.obg.engine { 
	
	public class SolidMapSprite extends MapSprite{
		
		// can block
		public var obstructive:Boolean = true;
		
		public var hotwidth:uint = 0;
		public var hotheight:uint = 0;
		
		// Array of solid positions in tiles
		public var nwOnp:Array = [];
		
		public var stepDir:int = 0;
		
		protected var adjEventLabel:String;
		protected var eventTriggered:Boolean;
		
		public function SolidMapSprite(x:int, y:int, z:uint, imageName:String) {
			if(!type) type = SOLIDMAPSPRITE;
			super(x, y, z, imageName);
			Engine.addSolidMapSprite(this);
		}
		
		public override function move(nwX:int, nwY:int, nwZ:int = 0):void {
			
			x = nwX - hotx;
			y = nwY - hoty;
			
			tx = nwX / tileWidth;
			ty = nwY / tileHeight;
			
			ox = nwX % tileWidth;
			oy = nwY % tileHeight;
			
			const xyz:int = tx + ty * mapWidth + nwZ * mapSize;
			
			z =  nwZ;
			
			detile();
			
			onp = [xyz];
			vp = [xyz];
			
			tile();
			
		}
		
		public override function moveT(nwTX:int, nwTY:int, nwZ:int = 0):void {
			const xyz:int = nwTX + nwTY * mapWidth + nwZ * mapSize;
			
			x = nwTX * tileWidth - hotx;
			y = nwTY * tileHeight - hoty;
			
			tx = nwTX;
			ty = nwTY;
			
			ox = 0;
			oy = 0;
			
			z =  nwZ;
			
			detile();
			
			onp = [xyz];
			vp = [xyz];
			
			tile();
		}
		
		public override function tile():void {
			const o:Array = onp;
			var xyz:int, idlxyz:int;
			
			super.tile();
			
			for (var i:uint = o.length; i--; ) {
				xyz = o[i];
				idlxyz = idtms + xyz;
				
				if (Map.hasSolidIDLs[idlxyz] == undefined) {
					Map.hasSolidIDLs[idlxyz] = Map.hasSolid[xyz].push(id) - 1;
				}
			}
		}
		
		public function triggerEvent():void {
			if (adjEventLabel) { 
				trace(adjEventLabel);
				const f:Function = Map.mapScript[adjEventLabel];
				if(f != null) f.call();
			}
		}
	}
}