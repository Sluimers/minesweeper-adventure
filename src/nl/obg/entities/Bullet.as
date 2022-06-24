package nl.obg.entities {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.geom.Point;
	
	import nl.obg.engine.*;
	import nl.obg.controllers.*;
	
	public class Bullet extends Entity
	{
		private var hostId:int; // friendly id
		private var lethal:Boolean = false;
		
		public function Bullet(nwX:int, nwY:int, z:int) {
			name = "Bullet";
			
			hotx 		= 0;
			hoty 		= 0;
			hotwidth	= 5;
			hotheight	= 5;
			
			x = nwX - hotwidth / 2;
			y = nwY - hotheight / 2;
			
			super(x, y, z, name + ".png");
			
			// This draws the Bullet one layer higher
			for (var i:int = vp.length; i--; ) vp[i] = vp[i] + mapSize;
			
			speed = 1;
			moving = true;
			active = true;
			
			obstructive = false;
			obstructable = false;
		}
		
		public function setVelocities(nwVx:Number, nwVy:Number):void {
			vx = nwVx;
			vy = nwVy;
			speed = vx + vy;
		}
		
		public function setHostId(id:int):void {
			hostId = id;
		}
		
		public override function direct():void {
			const c:Array = coll;
			if (active) {
				if (c.length) {
					if (lethal == false) {
						if(c.indexOf(hostId) == -1) lethal = true;
					}
					else {
						if (c.indexOf(Engine.getPlayer().ent.id) != -1) GameControl.gameOver();
						else removeFromGame();
					}
				}
				if (moving) {
					speedControl();
				}
				super.direct();
			}
		}
	}
}