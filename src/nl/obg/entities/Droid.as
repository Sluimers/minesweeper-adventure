package nl.obg.entities {
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	import nl.obg.engine.*;
	import nl.obg.mine.*;
	import nl.obg.controllers.GameControl;
	import nl.obg.standards.Point3D;
	
	public class Droid extends Entity {
		
		protected static const NOWHERE:uint = 4;
		protected static const DEF_REACTIONTIME:uint = 256;
		
		protected static const DEF_IDLETIME:uint = 256;
		
		protected var idleTime:uint = DEF_IDLETIME;
		protected var reactionTime:uint = DEF_REACTIONTIME;
		
		protected var friendlyIds:Array; // friendly ids
		
		// target is in sight
		protected var tis:Boolean = false;
		
		// static
		/*
		{
            (function():void {
				
                
            }());
        }*/
		
		public function Droid(x:int, y:int, z:int, image:String) {
			const mw:uint = Map.mapWidth, ms:uint = Map.mapSize;
			var xyz:uint;
			var inFreeArea:Boolean = true;
			
			if(!hotx) 		hotx 		= 0;
			if(!hoty) 		hoty 		= 0;
			if(!hotwidth) 	hotwidth	= 50;
			if(!hotheight) 	hotheight	= 50;
			
			super(x, y, z, image);
			
			active = false;
			
			for (var i:int = onp.length; i--; ) {
				xyz = onp[i];
				
				if (Map.isCovered[xyz]) inFreeArea = false;
				Map.canMine[xyz] = false;
			}
			
			dir = Math.random() * 4;
			
			GameModel.addDroid(this);
			
			friendlyIds = [];
			friendlyIds[id] = true; 
			
			if (inFreeArea) activate();
			else visible = false;
		}
		
		private function addFriendlyIds(mfids:Array):void {
			friendlyIds = friendlyIds.concat(mfids);
		}
		
		
		public override function processHearing():void {
			const onp:Array = onp, fids:Array = friendlyIds;
			var dirs:Array = [], p:Point3D;
			
			for (var i:int = onp.length; i--; ) {
				dirs = dirs.concat(Map.hasSound[onp[i]]);
			}
			
			for (i = dirs.length; i--; ) {
				p = dirs[i];
				if (p.z - sts > -1 && !fids[p.x]) {
					moveScript = [p.y]; break;
				}
			}
		}
		
		public override function processVision():void {
			const onp:Array = onp, fids:Array = friendlyIds;
			var dirs:Array = [], p:Point3D;
			
			for (var i:int = onp.length; i--; ) {
				dirs = dirs.concat(Map.hasLight[onp[i]]);
			}
			
			for (i = dirs.length; i--; ) {
				p = dirs[i];
				if (p.z - stl > -1 && !fids[p.x]) {
					moveScript = [p.y]; break;
				}
			}
		}
		
		// prevent entity overlap 
		public override function collides():Boolean {
			const c:Array = coll;
			for (var i:int = c.length; i--; ) {
				if (c[i] == Engine.getPlayer().ent.id) {
					if (mood != IDLE) {
						GameControl.gameOver();
					}
					break;
				}
			}
			return super.collides();
		}
	}
}