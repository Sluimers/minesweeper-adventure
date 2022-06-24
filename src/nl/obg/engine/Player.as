package nl.obg.engine {
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.geom.Rectangle;
	
	import nl.obg.mapsprites.*;
	import nl.obg.standards.*;
	import nl.obg.controllers.*;
	import nl.obg.mine.*;
	
	public class Player {
		private static const RADAR_RANGE:uint		= 4;
		
		public var ent:Entity;
		protected var flagging:Boolean 			= false;
		protected var hasRadar:Boolean;
		protected var isStealthy:Boolean		= false;
		protected var hasStealth:Boolean		= false;
		protected var newMoveScript:Boolean     = false
		protected var items:Array = [];
		private var keyPressTimer:Timer;
		
		public function Player() {}
		
		public function useItem():void {
			const itemScript:String = items.pop();
			const f:Function = Map.mapScript[itemScript];
			if (f != null) f.call();
		}
		
		public function moveControls():void {
			const e:Entity = ent;
			
			if (e.moveScript.length) {
				e.dir = e.moveScript.pop();
				e.moving = true;
				newMoveScript = false;
			}
			else {
				const kpq:Array = KeyControl.keyDownQueue, kpql:int = kpq.length - 1;
				if (kpql == -1) return;
				var key:uint = kpq[kpql];
				for (;;) {
					if (key > Key.DOWN || key < Key.LEFT) {
						if (!kpql) return;
						kpql--;
						key = kpq[kpql];
					}
					else break;
				}
				
				switch (key) {
					case Key.DOWN: 	e.moving = true; e.dir = Dir.DOWN; 	break;
					case Key.UP: 	e.moving = true; e.dir = Dir.UP; 	break;
					case Key.RIGHT: e.moving = true; e.dir = Dir.RIGHT; break;
					case Key.LEFT:	e.moving = true; e.dir = Dir.LEFT; 	break;
				}
			}
				
			if (e.moving) initVelocity();
		}
		
		public function moveBackControls():void {
			const e:Entity = ent;
			
			if (newMoveScript && e.moveScript.length) {
				e.dir = e.moveScript.pop();
				e.moving = true;
			}
			else {
				const kpq:Array = KeyControl.keyDownQueue, kpql:int = kpq.length - 1;
				if (kpql == -1) return;
				var key:uint = kpq[kpql];
				
				switch(e.dir) {
					case Dir.DOWN: 	if (key == Key.UP) 		{e.dir = Dir.UP; 		e.moving = true;} break;
					case Dir.UP: 	if (key == Key.DOWN) 	{e.dir = Dir.DOWN; 		e.moving = true;}	break;
					case Dir.RIGHT: if (key == Key.LEFT) 	{e.dir = Dir.LEFT; 		e.moving = true;}	break;
					case Dir.LEFT: 	if (key == Key.RIGHT) 	{e.dir = Dir.RIGHT; 	e.moving = true;}	break;
				}
			}
			
			if (e.moving) initVelocity();
		}
		
		public function initVelocity():void {
			const e:Entity = ent;
			
			switch(e.dir) {
				case Dir.DOWN: 	e.vx = 0; 			e.vy = e.speed;		break;
				case Dir.UP:	e.vx = 0; 			e.vy = 0 - e.speed; break;
				case Dir.RIGHT:	e.vx = e.speed; 	e.vy = 0;			break;
				case Dir.LEFT:	e.vx = 0 - e.speed; e.vy = 0;			break;
			}
		}
		
		public function radar():void {
			const e:Entity = ent;
			// pp = path points
			// pd = path dirs
			// np = next points
			// nd = next dirs
			var pp:Array, pd:Array = [], np:Array = [], nd:Array = [];
			pp = e.onp.slice();
			
			const mw:int = e.mapWidth, ms:int = e.mapSize;
			var obs:Array = Map.obs;
			
			// the number of steps LEFT
			var range:int = RADAR_RANGE;
			
			var xyz:int;	// xyz of point
			var txyz:int; 	// xyz of next point (more temporary)
			
			var d:int = 0;	// direction
			var nextDir:int, oppDir:int;
			var n:int = pp.length;
			
			//  let's go in all directions
			for (var i:int = pp.length; i--; ) {
				pd[i] = Dir.D4;
			}
			
			//if (pp.length == 1 || pp[0] != 421) return;
			
			for (;; ) {
				if (!n && !d) {
					n = np.length;
					
					range--;
					if (range == -1) break;
					
					pp = np.concat();
					pd = nd.concat();
				}
				
				if (!d) {
					if (!n) break;
					n--;
					xyz = pp[n];
					d = pd[n];
				}
				
				/*
				* directions are in bits
				* for example 1101 means the pathpoint in question
				* wants to expand LEFT RIGHT (not up) and DOWN.
				* at the end of the switch the most right bit turns 0
				* and the loop repeats again until no direction are LEFT.
				*/
				switch(1) {
					case d >> Dir.DOWN & 1: 
						d = d ^ Dir.DOWN_BIT; 
						nextDir = Dir.D4_NO_UP;
						oppDir = Dir.UP;
						if (mw + xyz % ms - ms > -1) continue; 
						txyz = xyz + mw; 
						break;
					case d >> Dir.UP & 1: 
						d = d ^ Dir.UP_BIT;
						nextDir = Dir.D4_NO_DOWN;
						oppDir = Dir.DOWN;
						if (mw - xyz % ms > -1) continue;
						txyz = xyz - mw; break;
					case d >> Dir.RIGHT & 1:
						d = d ^ Dir.RIGHT_BIT;
						nextDir = Dir.D4_NO_LEFT;
						oppDir = Dir.LEFT;
						if (!((xyz + 1) % mw)) continue;
						txyz = xyz + 1; break;
					case d >> Dir.LEFT & 1:
						d = d ^ Dir.LEFT_BIT;
						nextDir = Dir.D4_NO_RIGHT;
						oppDir = Dir.RIGHT;
						if (!(xyz % mw)) continue;
						txyz = xyz - 1; break;
				}
				
				// if we're boldly going to somewhere we've gone before 
				if (np.indexOf(txyz) != -1 || pp.indexOf(txyz) != -1) continue;
				
				np.push(txyz);
				nd.push(nextDir);
				
				var nl:NumberLight  = MineMap.numberLights[txyz];
				
				if(nl) {
					if (nl.number) {
						if (range && !Map.isCovered[txyz]) {
							nl.visible = true;
						}
						else nl.visible = false;
					}
				}
			}
		}
		
		public function getFlagging():Boolean {
			return flagging;
		}
		
		public function toggleStealth():void {
			const e:Entity = ent;
			if (hasStealth) e.setStealth(!isStealthy);
		}
		
		public function reset():void {
			const e:Entity = ent;
			
			e.noiseRange = e.baseNoiseRange;
			e.visibility = e.baseVisibility;
			e.vp = [];
			e.onp = [];
		}
			
		public function teleport(x:int, y:int, z:int):void {
			MineMap.uncoverTilesR(x, y, z);
			ent.move(x, y, z);
		}
		
		public function setMoveScript(nwNewMoveScript:Boolean):void {
			newMoveScript = nwNewMoveScript;
		}
	}
}