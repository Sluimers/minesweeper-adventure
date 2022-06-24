package nl.obg.entities {
	import flash.geom.Point;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.debug.Debug;
	
	public class ProxyDroid extends Droid
	{
		
		public function ProxyDroid(x:int, y:int, z:int){
			name = "ProximityDroid";
			super(x, y, z, name+".png");
			
			speed = 1;
			sts = 1;
		}
		
		public override function direct():void {
				
			if (active) {
				
				processHearing();
				
				switch(mood) {
					case IDLE:
						if(idleTime) idleTime--;
						else mood = Mood.NORMAL;
						break;
					case Mood.NORMAL:
						if(tis) {
							if(idleTime) idleTime--;
							else {
								moving = true;
								switch(dir) {
									case DOWN: 	vx = 0; 		vy = speed;		break;
									case UP: 	vx = 0; 		vy = 0-speed; 	break;
									case RIGHT: vx = speed; 	vy = 0;			break;
									case LEFT: 	vx = 0-speed;	vy = 0; 		break;
								}
								mood = Mood.ATTACK; 
							}
						}
						else if (moveScript.length) {
							dir = moveScript[0]; tis = true; idleTime = reactionTime; break;
						}
					break;
					case Mood.ATTACK:
						moving = true;
						if (centering) {
							if (moveScript.length) {
								dir = moveScript[0];
							}
							else {
								moving = false;
								tis = false;
								mood = Mood.NORMAL; 
							}
							switch(dir) {
								case DOWN: 		vx = 0; 		vy = speed;		break;
								case UP: 		vx = 0; 		vy = 0-speed; 	break;
								case RIGHT: 	vx = speed; 	vy = 0;			break;
								case LEFT: 		vx = 0 - speed;	vy = 0; 		break;
							}
						}
						if (moveScript.length) {
							moveScript.shift();
						}
						break;
				break;
				}
				if (moving) {
					stepDir = 0;
					speedControl();
				}
				super.direct();
				
				Debug.addDebugLine("vx:" + vx);
				Debug.addDebugLine("vy:" + vy);
				Debug.addDebugLine("speed:" + speed);
				Debug.addDebugLine("moving:" + moving);
				Debug.addDebugLine("coll:" + coll);
				Debug.addDebugLine("stepping:" + stepping);
				Debug.addDebugLine("hotwidth:" + hotwidth);
				Debug.addDebugLine("hotheight:" + hotheight);
			}
		}
	}
}