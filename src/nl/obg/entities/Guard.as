package nl.obg.entities {
	import flash.geom.Point;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.controllers.*;
	
	public class Guard extends Droid
	{
		private static const DEF_RCD:uint = 50;
		private var ReloadChamberDelay:uint = DEF_RCD;
		private var rct:uint = 0;
		private var bulletSpeed:uint = 0;
		
		public function Guard(x:int, y:int, z:int) {
			name = "Guard";
			super(x, y, z, name+".png");
			
			speed = 0;
			bulletSpeed = 4;
			
			ReloadChamberDelay = 3000;
			sts = 1;
		}
		
		public override function direct():void {
				
			if (active) {
				
				processHearing();
				
				switch(mood) {
					case Mood.IDLE:
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
						
						if (!rct) {
							//if (int(Math.random() * 100) == 0) {
								if (GameControl.inGame) {
									shoot();
									Engine.breakLine = true;
								}
							//}
						}
						else rct--;
						
						if (centering) {
							if (moveScript.length) {
								dir = moveScript[moveScript.length -1];
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
							moveScript.pop();
						}
						break;
				break;
				}
				if (moving) {
					stepDir = 0;
					speedControl();
				}
				super.direct();
			}
		}
		
		public function shoot():void {
			var p:Entity = Map.getPlayer().ent;
			var px:int = p.x + p.hotx + p.hotwidth / 2;
			var py:int = p.y + p.hoty + p.hotheight / 2;
			
			var bx:int = x + hotx + hotwidth / 2;
			var by:int = y + hoty + hotheight / 2;
			
			var bvx:int = 0;
			var bvy:int = 0;
			
			if (px < bx) bvx = 0-bulletSpeed;
			if (px > bx) bvx = bulletSpeed;
			if (py < by) bvy = 0-bulletSpeed;
			if (py > by) bvy = bulletSpeed;
			
			if (bvy) if (bvx) {
				bvx = bvx / 2;
				bvy = bvy / 2;
			}
			
			var bullet:Bullet = new Bullet(bx, by, z);
			bullet.setHostId(id);
			bullet.setVelocities(bvx, bvy);
			rct = ReloadChamberDelay;
		}
	}
}