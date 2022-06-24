package nl.obg.controllers { 
	import flash.events.MouseEvent;
	
	import nl.obg.engine.*;
	import nl.obg.controllers.*;
	import nl.obg.standards.*;
	 
	public class MouseControl
	{
		public static function onMouseClick(event:MouseEvent):void {
			if (GameControl.inGame) movePlayer(event);
		}
		
		// Here we will use a different pathfinding method.
		// Since it'll be even better than A-star, I'll call it S-star pathfinding. 
		// SS-star pathfinding (Bidirectional S-star) could possibly be even better, but too difficult for now.
		// TODO: implement
		public static function movePlayer(event:MouseEvent):void {
			const tx:int = (event.localX + Engine.xwin) / Map.tileHeight, ty:int = (event.localY + Engine.ywin) / Map.tileHeight;
			const player:Player = Engine.player, p:Entity = player.ent;
			var dx:int = tx - p.tx, dy:int = ty - p.ty;
			var dir:int;
			
			player.setMoveScript(true);
			
			dir = Dir.DOWN;
			if (dy < 0) {
				dir = Dir.UP;
				dy = 0 - dy;
			}
			for (; dy--; ) {
				p.moveScript.push(dir);
			}
			dir = Dir.RIGHT;
			if (dx < 0) {
				dir = Dir.LEFT;
				dx = 0 - dx;
			}
			for (; dx--; ) {
				p.moveScript.push(dir);
			}
		}
	}
}