package nl.obg.entities {
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	
	public class WallHugger extends Droid
	{
		private var wall:uint;
		private var random:int;
		
		public function WallHugger(x:int, y:int, z:int) {
			name = "Wallhugger";
			
			hoty = 40;
			
			super(x, y, z, name+".png");
			
			wall = dir;	
			speed = 2;
		}
		
		public override function direct():void {
			if (active) {
				var i:int;
				
				switch(mood) {
					case IDLE:
						if(idleTime) idleTime--;
						else mood = Mood.NORMAL;
						break;
					case Mood.NORMAL:
						moving = true;
						
						if (dir == wall) {
							for (i = coll.length; i--; ) {
								if (coll[i] < 0) {
									// it changes from DOWN or UP to LEFT or RIGHT or vice versa.
									dir = dir & 0x02 ^ 0x02 + (++Random.one & 1); break;
								}
							}
						}
						else {
							switch(dir) {
								case DOWN: 	
									switch(wall) {
										case LEFT:
											if (isOpen(LEFT)) {
												if(isOpen(UPLEFT)) wall = LEFT;
												else wall = UP;
												dir = LEFT; 
											}
											else {
												for (i = coll.length; i--; ) {
													if(coll[i] < 0) {
														dir = RIGHT; 
														wall = DOWN;
													}
												}
											}
											break;
										case RIGHT:
											if(isOpen(RIGHT)) {
												if(isOpen(UPRIGHT)) wall = RIGHT;
												else wall = UP; 
												dir = RIGHT; 
											}
											else {
												for (i = coll.length; i--; ) {
													if (coll[i] < 0) {
														dir = LEFT; 
														wall = DOWN;
													}
												}
											}
										break;
									}
									break;	
								case UP: 	
									if (wall == LEFT) {
										if(isOpen(LEFT)) {
											if(isOpen(DOWNLEFT)) wall = LEFT;
											else wall = DOWN;
											dir = LEFT; 
										}
										else {
											for (i = coll.length; i--; ) {
												if(coll[i] < 0) {
													dir = RIGHT; 
													wall = UP;
												}
											}
										}
									}
									else if(wall==RIGHT) {
										if(isOpen(RIGHT)) {
											if(isOpen(DOWNRIGHT)) wall = RIGHT;
											else wall = DOWN;
											dir = RIGHT; 
										}
										else {
											for (i = coll.length; i--; ) {
												if (coll[i] < 0) {
													dir = LEFT; 
													wall = UP;
												}
											}
										}
									}
									break;	
								case RIGHT: 
									if(wall==DOWN) {
										if(isOpen(DOWN)) {
											if(isOpen(DOWNLEFT)) wall = DOWN;
											else wall = LEFT;
											dir = DOWN; 
										}
										else {
											for (i = coll.length; i--; ) {
												if(coll[i] < 0) {
													dir = UP; 
													wall = RIGHT;
												}
											}
										}
									}
									else if(wall==UP) {
										if(isOpen(UP)) {	
											if(isOpen(UPLEFT)) wall = UP;
											else wall = LEFT;
											dir = UP; 
										}
										else { 
											for (i = coll.length; i--; ) {
												if (coll[i] < 0) {
													dir = DOWN; 
													wall = RIGHT;
												}
											}
										}
									}
									break;	
								case LEFT: 
									if(wall == DOWN) {
										if(isOpen(DOWN)) {
											if(isOpen(DOWNRIGHT)) wall = DOWN;
											else wall = RIGHT;
											dir = DOWN; 
										}
										else {
											for (i = coll.length; i--; ) {
												if(coll[i] < 0) {
													dir = UP; 
													wall = LEFT;
												}
											}
										}
									}
									else if(wall == UP) {
										if(isOpen(UP)) {
											if(isOpen(UPRIGHT)) wall = UP;
											else wall = RIGHT;
											dir = UP; 
										}
										else {
											for (i = coll.length; i--; ) {
												if(coll[i] < 0) {
													dir = DOWN; 
													wall = LEFT;
												}
											}
										}
									}
									break;	
							}
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
				super.direct();
			}
			
		}
		
		public override function collides():Boolean {
			// first, collision redirecting
			for (var i:uint = coll.length; i--; ) {
				if (coll[i] > 0) {
					if (!fromSide) {
						if (dir == wall) wall ^= Dir.OPPOSITE_DIRECTION;
						dir ^= Dir.OPPOSITE_DIRECTION;
					}
				}
			}
			return super.collides();
		}
		
		public function isOpen(dir:uint):Boolean {
			const mw:int = Map.mapWidth;
			var tx:int = tx, ty:int = ty, tz:int = z;
			
			if (!centering) return false; 
			
			switch(dir) {
				case DOWN:  	ty++; break;
				case UP:		ty--; break;
				case RIGHT:		tx++; break;
				case LEFT:		tx--; break;
				case DOWNRIGHT:	ty++; tx++; break;
				case DOWNLEFT:	ty++; tx--; break;
				case UPRIGHT:	ty--; tx++; break;
				case UPLEFT:	ty--; tx--; break;
			}
			if (tx >= mw || tx < 0 || ty < 0 || ty >= Map.mapHeight) return false;
			
			const xyz:int = tx + ty * mw + z * mapSize;
		
			if(!Map.isCovered[xyz] && !Map.obs[xyz]) {
				return true;
			}
			return false;
		}
		
		public override function face(nwDir:uint):void {
			dir = nwDir;
			wall = dir;
		}
	}
}