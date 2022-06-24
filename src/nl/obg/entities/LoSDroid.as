package nl.obg.entities {
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.debug.*;
	
	public class LoSDroid extends Droid
	{
		// home coordinates in tiles
		private var htx:int;
		private var hty:int;
		
		
		public function LoSDroid(x:int, y:int, z:int) {
			name = "LoSDroid";
			super(x, y, z, name + ".png");
			
			htx = tx;
			hty = ty;
			
			baseSpeed = 3;
			stl = 1; // extremely good
		}
		
		
		public override function direct():void {
			var i:int, cid:int, eid:*, ent:Entity;
			
			if (active) {
				
				processVision();
				
				moodswitch : switch(mood) {
					case Mood.IDLE:
						if(idleTime) idleTime--;
						else mood = Mood.NORMAL;
						break;
					case Mood.NORMAL:
						if (tis) {
							if(idleTime) idleTime--;
							else {
								moving = true;
								speed = baseSpeed;
								switch(dir) {
									case DOWN: 	vx = 0; 		vy = speed;		break;
									case UP: 	vx = 0; 		vy = 0-speed; 	break;
									case RIGHT: vx = speed; 	vy = 0;			break;
									case LEFT: 	vx = 0-speed;	vy = 0; 		break;
								}
								mood = Mood.ATTACK; 
							}
						}
						else {
							const len:int = moveScript.length;
							if (len){
								tis = true; 
								idleTime = reactionTime;
								switch(moveScript[len-1]) {
									case DOWN: 	dir = DOWN;	 break;
									case UP: 	dir = UP; 	 break;
									case RIGHT: dir = RIGHT; break;
									case LEFT: 	dir = LEFT;	 break;
								}
							}
						}
						
						/* TODO: make's way for other LoS droids
						/*
						if (coll.length) {
							for (i = coll.length; i--; ) {
								cid = coll[i];
								eid = Engine.entIDLs[cid];
								
								if (eid != undefined) {
									moving = true;
									speed = baseSpeed;
									switch(dir) {
										case DOWN: 	vx = 0; 		vy = speed;		break;
										case UP: 	vx = 0; 		vy = 0-speed; 	break;
										case RIGHT: vx = speed; 	vy = 0;			break;
										case LEFT: 	vx = 0-speed;	vy = 0; 		break;
									}
									mood = Mood.MAKEWAY; 
								}
							}
						}
						*/
						
						break;
					case Mood.ATTACK:
						moving = true;
						switch(dir) {
							case DOWN: 	vx = 0; 		vy = speed;		break;
							case UP: 	vx = 0; 		vy = 0-speed; 	break;
							case RIGHT: vx = speed; 	vy = 0;			break;
							case LEFT: 	vx = 0-speed;	vy = 0; 		break;
						}
						if (coll.length) {
							stop();
							regress();
						}
						
						break;
					case Mood.REGRESS:
						moving = true;
						switch(dir) {
							case DOWN: 	vx = 0; 		vy = speed;		break;
							case UP: 	vx = 0; 		vy = 0-speed; 	break;
							case RIGHT: vx = speed; 	vy = 0;			break;
							case LEFT: 	vx = 0-speed;	vy = 0; 		break;
						}
						
						if (home()) {
							moveScript = [];
							speed = baseSpeed;
							mood = Mood.NORMAL;
							stop();
						}
						
						/* START YIELD CHECK */
						if(coll.length) {
							stepDir = 1 << dir; // assume we make a step..
							
							for (i = coll.length; i--; ) {
								cid = coll[i];
								eid = Engine.entIDLs[cid];
								if (eid != undefined) {
									ent = Engine.ents[eid];
									
									if (!ent.isMoving() && ent.mood == Mood.NORMAL) {
										stop();
										newHome();	
										break;
									}
									
									// would we then get blocked by an entity?
									breakLine = true;
									const nx:int = x + hotx + ((stepDir & RIGHT_BIT) >> RIGHT) - ((stepDir & LEFT_BIT) >> LEFT), ny:int = y + hoty + ((stepDir & DOWN_BIT) >> DOWN) - ((stepDir & UP_BIT) >> UP);
									
									if (cdEnt(ent, nx, ny)) {
										// if so, we wait
										stop();
										break;
									}
								}
								else {
									// if for some odd reason a non-ent blocks you
									// on your way home, make this spot your new home.
									stop();
									newHome();	
									break;
								}
							}
							stepDir = 0;
						}
						break;
					case Mood.MAKEWAY:
						
						break;
				}
				
				Debug.addDebugLine(name + id);
				Debug.addDebugLine("dir: " + dir);
				Debug.addDebugLine("stepDir: " + stepDir);
				Debug.addDebugLine("mood: " + Debug.mood(mood) + "\n");
				
				// super.direct.. BEFORE Speedcontrol, AFTER collision handling.
				super.direct();
				
				if (moving) {
					speedControl();
				}
			}
		}
		
		public function regress():void {
			mood = Mood.REGRESS;
			dir = dir ^ Dir.OPPOSITE_DIRECTION;
			speed = baseSpeed - 1;
			tis = false;
		}
		
		public function home():Boolean {
			if (tx != htx) return false;
			if (ty != hty) return false;
			if (!centering) return false;
			return true;
		}
		
		public function newHome():void {
			trace("LoSDroid hits a brick while regressing");
			mood = Mood.NORMAL;
			htx = tx;
			hty = ty;
		}
	}
}