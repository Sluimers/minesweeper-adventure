package nl.obg.entities {
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.net.URLRequest;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	
	public class TestDroid extends Droid
	{
		public function TestDroid(x:int, y:int, z:int) {
			name = "testDroid";
			super(x, y, z, name+".png");
			
			hotx 		=  0;
			hoty 		=  0;
			hotwidth	= 50;
			hotheight	= 50;
			
			speed = 2;
			mood = Mood.ASLEEP;
			idleTime = 16;
		}
		
		public override function direct():void {
			if (active) {
				
				// first, collision redirecting
				if (coll.length) {
					dir ^= Dir.OPPOSITE_DIRECTION;
				}
				
				// second, mood redirecting
				switch(mood) {
					case Mood.ASLEEP:
						moving = false;
						vx = 0;
						vy = 0;
						break;
					case Mood.IDLE:
						moving = false;
						vx = 0;
						vy = 0;
						if(idleTime) idleTime--;
						else mood = Mood.NORMAL;
						break;
					case Mood.NORMAL:
						moving = true;
						switch (dir) {
							case DOWN: 	
								vx = 0; 		
								vy = speed;
							break;
							case UP:   
								vx = 0; 		
								vy = 0 - speed; 
							break;
							case RIGHT: 
								vx = speed; 	
								vy = 0; 
							break;
							case LEFT:  
								vx = 0 - speed;
								vy = 0; 
							break;
						}
				}	
				
				// third, adding onTiles and distance from tile calculation
				if (moving) {
					//resetValues();
					speedControl();
				}
			}
		}
	}
}