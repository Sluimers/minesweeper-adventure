package nl.obg.entities {
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	
	public class MineLayer extends Droid
	{
		private var wallhugging:Boolean = false;
		
		public function MineLayer(x:int, y:int, z:int) {
			name = "MineLayer";
			
			hoty = 30;
			hotx = 10;
			
			super(x, y, z, name + ".png");
			speed = 2;
		}
		
		public override function direct():void {
			
			if (active) {
				
				for (var i:String in coll) {
					if (coll[i] < 0) changeDirOnWall();
					if (coll[i] > 0) {
						//var edir:uint = (m.getEnt(coll[i])).dir;
						//var emove:Boolean = (m.getEnt(coll[i])).isMoving();
						var temp:uint = dir + 1 - dir % 2 * 2;
						dir = temp; 
						
						//if (edir == temp || !emove) dir = temp;
					}
				}
				
				switch(mood) {
					case Mood.IDLE:
						if(idleTime) idleTime--;
						else mood = Mood.NORMAL;
						break;
					case Mood.NORMAL:
						moving = true;
						
						if (centering) {
							if (wallhugging) wallhugging = false;
							else dir = Math.random() * 4;
						}
						switch (dir) {
						case DOWN: 	
							vx = 0; 		
							vy = speed;
						break;
						case UP:    
							vx = 0; 		
							vy = 0-speed; 
						break;
						case RIGHT: 
							vx = speed; 	
							vy = 0; 
						break;
						case LEFT:  
							vx = 0-speed; 	
							vy = 0; 
						break;
					}	
				break;
				}
				if (moving) {
					stepDir = 0;
					speedControl();
				}
			}
			
			super.direct();
		}
		
		public function changeDirOnWall():void {
			dir = Math.random() * 4;
			var temp:uint = dir;
			while (!isOpen(temp)) {
				temp++;
				if (temp == 4) temp = 0;
				// just in case
				if (temp == dir) { 
					moving = false;
					break;
				}
			}
			dir = temp; 
			wallhugging = true;
		}
		
		public function isOpen(dir:uint):Boolean {
			var obs:Array = Map.obs;
			var isCovered:Array = Map.isCovered;
			var tx:int = tx; 
			var ty:int = ty; 
			var tz:int = 0;
			
			switch(dir) {
				case DOWN:  	ty++; break;
				case UP:		ty--; break;
				case RIGHT:		tx++; break;
				case LEFT:		tx--; break;
			}
			
			const xyz: int = tx + ty * mapWidth + z * mapSize;
			
			if(!isCovered[xyz]) {
				if (!obs[xyz]) {
					return true;
				}
			}
			return false;
		}
	}
}