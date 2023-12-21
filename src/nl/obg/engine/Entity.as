package nl.obg.engine {
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	
	import nl.obg.standards.*;

	public class Entity extends SolidMapSprite {
		
		// * ENTITY DIRECTION AND MOVEMENT CONSTANTS  * //
		
		protected static const DOWN:int = 0;
		protected static const UP:int = 1;
		protected static const RIGHT:int = 2;
		protected static const LEFT:int = 3;
		
		protected static const DOWNRIGHT:int = 4;
		protected static const UPLEFT:int = 5;
		protected static const UPRIGHT:int = 6;
		protected static const DOWNLEFT:int = 7;
		
		protected static const DOWN_BIT:int = 0x01;
		protected static const UP_BIT:int = 0x02;
		protected static const RIGHT_BIT:int = 0x04;
		protected static const LEFT_BIT:int = 0x08;
		
		protected static const UP_DOWN:int = 		0x03;
		protected static const LEFT_RIGHT:int = 	0x0C;
		
		protected static const ALL_DIRS:int = 		0x0F;
		protected static const ALL_BUT_DOWN:int = 	0x0E;
		protected static const ALL_BUT_UP:int = 	0x0D;
		protected static const ALL_BUT_LEFT:int = 	0x07;
		protected static const ALL_BUT_RIGHT:int =	0x0B;
		
		protected static const MAX_SPEED:int = 8;					// please keep this a bitnumber 
		
		// * END MOVEMENT AND DIRECTION CONSTANTS * //
		
		// * ENTITY DIRECTION AND MOVEMENT VARIABLES  * //
		
		public var dir:uint;
		public var moving:Boolean = false;
		public var stepping:Boolean = false;
		
		protected var baseSpeed:int;
		public var speed:int;
		
		public var ntx:int = 0;
		public var nty:int = 0;
		
		public var vx:int = 0;
		public var vy:int = 0;	
		
		public var dx:int = 0;
		public var dy:int = 0;	
		
		public var odx:int = 0;
		public var ody:int = 0;	
		
		// * END DIRECTION AND MOVEMENT VARIABLES  * //
		
		public var moveScript:Array = [];
		
		// * ENTITY COLLISION VARIABLES * //
		
		// Offset from Tile, counting how many pixels the Entity is from it's main tile
		protected var nox:int;
		protected var noy:int;
		
		// it's basic collision structure
		// this is still unused as we're still dealing with AABB's
		protected var cVertex:Array = []; 	// not sure if needed
		protected var cVectors:Array = [];	//
		
		// All obstructive MapObjects entity has collided with
		public var coll:Array = [];
		// All MapObjects entity shares the same space with
		public var overlaps:Array = [];
		// Id Truth Array of All entities that no longer need to be checked for collision
		public var collCheck:Array = [];
		
		// * END COLLISION VARIABLES * //
		
		// * ENTITY DIRECTION AND MOVEMENT VARIABLES  * //
		
		protected static const IDLE:uint = 0;
		public var mood:uint = IDLE;
		public var moodMemory:Array = [];
		
		public var alive:Boolean;
		
		protected var centering:Boolean = false;
		protected var fromSide:Boolean = false;
		
		// used for pathfinding
		// Line of Sight -> stl + lightDirs 
		// Proximity -> sts + soundDirs
		protected var visionDirs:Array = new Array(); 
		protected var soundDirs:Array = new Array();
		
		protected var visibilityTiles:Array = []; 
		protected var hearabilityTiles:Array = [];
		
		// hearing sensitivity
		protected var sts:int = 0;
		
		public var baseNoiseRange:int = 0;
		public var baseVisibility:int = 0;
		
		// how much noise it is making to other entities (to their pathfinding skills)
		public var noiseRange:int;
		
		// how visible it is to other entities (to their line of sight)
		public var visibility:int;
		
		// sensitivity to light
		// 0	= not
		// 1	= incredibly
		// 256	= extremely poor
		protected var stl:int = 0;
		
		// sees if any hottiles have been changed lately (as in after a step)
		protected var hotTileChange:Boolean = false;
		
		protected var tileChange:Boolean = false;
		
		// can be blocked
		public var obstructable:Boolean = true;
		
		// debug boolean
		public var breakLine:Boolean = false;
		
		protected var active:Boolean = false;
		
		public var interactingWith:Array = [];
		
		public function Entity(x:int, y:int, z:uint, nwSpriteName:String) {
			if (!type) type = ENTITY; 
			if (!spriteName) spriteName = "ents/" + nwSpriteName;
			super(x, y, z, spriteName);
			
			alive = true;
			
			noiseRange = baseNoiseRange;
			visibility = baseVisibility;
			
			Engine.addEnt(this);
		}
		
		/*  
		 * Please note that if you want use to this piece of code give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * Part of Sluimers' Mega Awesome Super Hack Collision Detection System.
		 */
		public override function tile():void {
			const tw:int = tileWidth, th:int = tileHeight, mw:int = mapWidth, stepDir:int = stepDir, id:int = id;
			const tx:int = tx, ty:int = ty;
			var tox:int = ox, toy:int = oy, idlxyz:int;
			
			if (stepDir & RIGHT_BIT) 		tox++; 
			else if (stepDir & LEFT_BIT) 	tox--; 
			if (stepDir & DOWN_BIT) 		toy++; 
			else if (stepDir & UP_BIT) 		toy--; 
			
			if (tox == tw) { tox = 0; tx++; }
			if (toy == th) { toy = 0; ty++; }
			if (tox == -1) { tox = tw - 1; tx--; }
			if (toy == -1) { toy = th - 1; ty--; }
			nox = tox;
			noy = toy;
			ntx = tx;
			nty = ty;
			
			var xyz:int = tx + ty * mw + z * mapSize;
			const o:Array = [xyz], v:Array = [xyz];
			const xr:int = int(int(hotwidth - 1 + tox) / tw);
			const yd:int = int(int(hotheight - 1 + toy) / th);
			
			// top edge
			for (var i:int = xr; i--; ) {
				xyz++;
				o.push(xyz);
			}
			
			// right edge
			for (i = yd; i--; ) {
				xyz = xyz + mw;
				o.push(xyz);
			}
			
			// bottom edge
			for (i = xr; i--; ) {
				xyz = xyz--;
				if (o.indexOf(xyz) == -1) {
					o.push(xyz);
				}
			}
			
			// left edge
			for (i = yd; i--; ) {
				xyz = xyz - mw;
				if (o.indexOf(xyz) == -1) {
					o.push(xyz);
				}
			}
			
			o.sort();
			
			for (i = o.length; i--; ) {
				xyz = o[i];
				if (xyz < 0) continue;
				idlxyz = idtms + xyz;
				
				if (Map.hasSolidIDLs[idlxyz] == undefined) {
					Map.hasSolidIDLs[idlxyz] = Map.hasSolid[xyz].push(id) - 1;
					hotTileChange = true;
				}
			}
			
			nwOnp = o.concat();
			
			const vxr:int = int(int(width - 1 + tox) / tw);
			const vyd:int = int(int(height - 1 + toy) / th);
			xyz = tx + ty * mw + z * mapSize;
			
			// top edge
			for (i = vxr; i--; ) {
				xyz++;
				v.push(xyz);
			}
			
			// right edge
			for (i = vyd; i--; ) {
				xyz = xyz + mw;
				v.push(xyz);
			}
			
			// bottom edge
			for (i = vxr; i--; ) {
				xyz = xyz--;
				if (v.indexOf(xyz) == -1) {
					v.push(xyz);
				}
			}
			
			// left edge
			for (i = vyd; i--; ) {
				xyz = xyz - mw;
				if (v.indexOf(xyz) == -1) {
					v.push(xyz);
				}
			}
			
			for (i = v.length; i--; ) {
				xyz = v[i];
				if (xyz < 0) continue;
				idlxyz = idtms + xyz;
				
				if (Map.hasSpriteIDLs[idlxyz] == undefined) {
					// FIXME: out of bounds error? put the ent on the last tile, last layer
					Map.hasSpriteIDLs[idlxyz] = Map.hasSprite[xyz].push(id) - 1;
					tileChange = true;
				}
			}
			
			nwVp = v.concat();
		}
		
		/*  
		 * Please note that if you want use to this piece of code DO give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * Part of Sluimers' Mega Awesome Super Hack Collision Detection System.
		 */
		// Collision has occured, so let's remove future (new - current) hottiles.
		public function oldtile():void {
			const hasSolid:Array = Map.hasSolid, hasSolidIDLs:Array = Map.hasSolidIDLs;
			var xyz:int, idlxyz:int, lastId:int, idLoc:Number;
			
			for (var i:int = nwOnp.length; i-- ; ) {
				xyz = nwOnp[i];
				
				if (onp.indexOf(xyz) == -1) {
					
					idlxyz = idtms + xyz;
					
					if (Map.hasSolidIDLs[idlxyz] != undefined) {
						
						idLoc = Map.hasSolidIDLs[idlxyz];
						Map.hasSolidIDLs[idlxyz] = undefined;
						lastId = Map.hasSolid[xyz].pop();
						
						if(id != lastId) {
							Map.hasSolid[xyz][idLoc] = lastId;
							Map.hasSolidIDLs[lastId * mapSize + xyz] = idLoc;
						}
					}
					hotTileChange = true;
				}
			}
		}
		
		/*  
		 * Please note that if you want use to this piece of code DO give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * Part of Sluimers' Mega Awesome Super Hack Collision Detection System.
		 */
		// No collision has occurred, so let's remove old (current - new) hottiles.
		public function newtile():void {
			const hasSolid:Array = Map.hasSolid, hasSolidIDLs:Array = Map.hasSolidIDLs;
			const hasSprite:Array = Map.hasSprite, hasSpriteIDLs:Array = Map.hasSpriteIDLs;
			var xyz:int, idlxyz:int, lastId:int, idLoc:Number;
			
			for (var i:int = onp.length; i-- ; ) {
				xyz = onp[i];
				
				if (nwOnp.indexOf(xyz) == -1) {
					
					idlxyz = idtms + xyz;
					
					if (hasSolidIDLs[idlxyz] != undefined) {
						
						idLoc = hasSolidIDLs[idlxyz];
						Map.hasSolidIDLs[idlxyz] = undefined;
						lastId = Map.hasSolid[xyz].pop();
						
						if(id != lastId) {
							Map.hasSolid[xyz][idLoc] = lastId;
							Map.hasSolidIDLs[lastId * mapSize + xyz] = idLoc;
						}
					}
					hotTileChange = true;
				}
			}
			
			for (i = vp.length; i-- ; ) {
				xyz = vp[i];
				
				if (nwVp.indexOf(xyz) == -1) {
					
					idlxyz = idtms + xyz;
					
					if (Map.hasSpriteIDLs[idlxyz] != undefined) {
						
						idLoc = Map.hasSpriteIDLs[idlxyz];
						Map.hasSpriteIDLs[idlxyz] = undefined;
						lastId = Map.hasSprite[xyz].pop();
						
						if(id != lastId) {
							Map.hasSprite[xyz][idLoc] = lastId;
							Map.hasSpriteIDLs[lastId * mapSize + xyz] = idLoc;
						}
					}
					tileChange = true;
				}
			}
			
			if (hotTileChange) onHotTileChange();
			if (tileChange) vp = nwVp.concat();
		}
		
		protected function onHotTileChange():void {
			onp = nwOnp.concat();
			if (visibility) bcLoS();
			if (noiseRange) bcWoS();
		}
		
		public function face(nwDir:uint):void {
			dir = nwDir;
		}
		
		public function hitsObject():Boolean {
			//  regarding obstructable, you just want to know who it is you're colliding with.
			if (cd()) return obstructable;
			return false;
		}
		
		/*  
		 * Please note that if you want use to this piece of code give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * Part of Sluimers' Mega Awesome Super Hack Collision Detection System.
		 * 
		 * TODO.. so far dynamic collision detection works by future-future collision.
		 * What still irks me is that any two object with a width or height of 1
		 * can go straight through each other.
		 * Thus future-present scenario's have to be implemented if one wants to correct this.
		 * There are in total 2x2 different future-present scenario's in 2 dimensions.
		 * So likely it's 3x3 different scenario's in 3 dimensions.
		 * 
		 * TODO.. also, it might be handy to first collect all the id's to avoid a nested for loop
		 */
		public function cd():Boolean {
			const mw:uint = mapWidth, mh:uint = mapHeight, ms:uint = mapSize, stepDir:int = stepDir; 
			const nx:int = x + hotx + ((stepDir & RIGHT_BIT) >> RIGHT) - ((stepDir & LEFT_BIT) >> LEFT), ny:int = y + hoty + ((stepDir & DOWN_BIT) >> DOWN) - ((stepDir & UP_BIT) >> UP);
			const obs:Array = Map.obs, hasSolid:Array = Map.hasSolid, coll:Array = coll, collCheck:Array = collCheck;
			var sids:Array, oid:uint, sid:uint, j:uint, n:uint, xyz:uint;
			
			/*
			* - Collision types -
			* 
			* 0 .. n 		= Entities
			* -1			= Borders
			* -2 .. -n-2 	= Obstruction types
			*/
					
			/*
			* Map Borders. You can try making this obsolete by setting all the outer obs to 1, 
			* but you do need to realize that it requires a border of invisible tiles
			* and it's debatable whether you would really want that. 
			*/
			if (nx < 0 || ny < 0 || Map.width - nx - hotwidth < 0 || Map.height - ny - hotheight < 0) {
				coll.push( -1);
				return true; 
			}
			
			// There is of course the nagging question whether only nwOnp should 
			// or whether you would also want to add unique onp numbers as well.
			const o:Array = nwOnp;
				
			for (var i:uint = o.length; i--; ) {
				xyz = o[i];
				
				oid = obs[xyz]; 
				
				if (oid) {
					coll.push( -1 - oid);
					if (oid == 1) continue;	// full tiles generally do not occupy obstructive unobstructable entities, moving on.. 
				}
				sids = hasSolid[xyz];
				j = sids.length;
				if (j < 2) continue;
				for (; j--; ) {
					sid = sids[j];
					if (sid == id) continue;
					if (!collCheck[sid] && cdEnt(Engine.sSprites[Engine.sSpriteIDLs[sid]], nx, ny)) {
						coll.push(sid);
						collCheck[sid] = true;
					}
				}
			}
			
			return coll.length != 0;
		}
		
		/*  
		 * Please note that if you want use to this piece of code give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * This part needs to improve of course, since it only works for AABB as of yet.
		 * Part of Sluimers' Mega Awesome Super Hack Collision Detection System.
		 */
		public function cdEnt(sSprite:SolidMapSprite, nx:int, ny:int):Boolean {
			const EntstepDir:int = sSprite.stepDir;
			const rnx:int = nx + hotwidth - 1;
			const dny:int = ny + hotheight - 1;
			const enx:int = sSprite.x + sSprite.hotx - ((EntstepDir & RIGHT_BIT) >> RIGHT) - ((EntstepDir & LEFT_BIT) >> LEFT); // 1 if ent moves to the left, -1 if the ent moves to the right
			const eny:int = sSprite.y + sSprite.hoty - ((EntstepDir & DOWN_BIT) >> DOWN) - ((EntstepDir & UP_BIT) >> UP);		// idem for up and down
			const enxr:int = enx + sSprite.hotwidth - 1;
			const enyd:int = eny + sSprite.hotheight - 1;
			
			if (eny > dny) return false;	// DOWN
			if (enyd < ny) return false;	// UP
			if (enx > rnx) return false;	// RIGHT
			if (enxr < nx) return false;	// LEFT
			
			if (!sSprite.obstructive) {
				const sid:uint = sSprite.id;
				overlaps.push(sid);
				collCheck[sid] = true;
				return false;
			}
			
			//TODO.. check whether (sSprite is Entity) should not be replaced by entIDLs (maybe it's faster?).
			if (obstructive && sSprite is Entity && !(sSprite as Entity).collCheck[id]) {
				(sSprite as Entity).coll.push(id);
				(sSprite as Entity).collCheck[id] = true;
			}
			
			return true;
		}
		
		// prevent entity overlap 
		public function collides():Boolean {
			stepping = moving = false;
			dx = odx;
			dy = ody;
			
			// step is done at end of collision
			stepDir = 0;
			
			return true;
		}
		
		public function stop():void {
			stepping = moving = false;
			vx = vy = stepDir = 0;
		}
		
		public function speedControl():void {
			odx = dx; 
			ody = dy;
			var ndx:int = dx + vx, ndy:int = dy + vy;
			stepping = false;
			
			// BEGIN speedControl
			if (ndx & MAX_SPEED) {
				stepping = true;
				if (ndx > 0) 	stepDir = stepDir | RIGHT_BIT;
				else 			stepDir = stepDir | LEFT_BIT;
				ndx = ndx & (MAX_SPEED - 1);
			}
			if (ndy & MAX_SPEED) {
				stepping = true;
				if (ndy > 0) 	stepDir = stepDir | DOWN_BIT;
				else 			stepDir = stepDir | UP_BIT;
				ndy = ndy & (MAX_SPEED - 1);
			}
			dx = ndx;
			dy = ndy;
			
			// END speedcontrol
		}
			
		public function step():void {
			const tw:uint = tileWidth, th:uint = tileHeight, stepDirection:int = stepDir;
			
			if (stepDirection & RIGHT_BIT) 		{ x++; ox = nox; tx = ntx; }  
			else if (stepDirection & LEFT_BIT) 	{ x--; ox = nox; tx = ntx; }
			if (stepDirection & DOWN_BIT) 		{ y++; oy = noy; ty = nty; }	
			else if (stepDirection & UP_BIT) 	{ y--; oy = noy; ty = nty; }	
			
			const xCen:int = (tw >> 1) - (ox + (hotwidth  >> 1) ) % tw; 
			const yCen:int = (th >> 1) - (oy + (hotheight >> 1) ) % th; 
			
			switch(1) {
				case stepDirection >> RIGHT & 1:
				case stepDirection >> LEFT & 1: 
					if (!xCen) centering = true;
					break;
				case stepDirection >> DOWN & 1:
				case stepDirection >> UP & 1: 
					if (!yCen) centering = true; 
					break;
			}
			
			// step is done at end of step
			stepDir = 0;
		}
		
		public function direct():void {
			centering = false;
			coll = []; 
			collCheck = [];
			overlaps = [];
			hotTileChange = false;
			if (!moving) {
				vx = 0;
				vy = 0;
				stepDir = 0;
			}
		}
		
		
		/*  
		 * Please note that if you want use to this piece of code give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * This is a 4 directional web Pathfinding algorithm.
		 */
		// broadcasting web of sound
		public function bcWoS():void { 
			// the number of steps left
			var noiseRange:int = noiseRange;
			if (!noiseRange) return;
			
			// pp = path points
			// pd = path dirs
			// np = next points
			// nd = next dirs
			var pp:Array, pd:Array = [], np:Array = [], nd:Array = [];
			pp = onp.concat();
			
			const mw:int = mapWidth, ms:int = mapSize;
			const newHearabilityTiles:Array = [];
			var obs:Array = Map.obs, hearabilityTile:int;
			
			const id:int = id;
			
			var xyz:int;	// xyz of point
			var txyz:int; 	// xyz of next point (more temporary)
			
			var d:int = 0;	// direction
			var nextDir:int, oppDir:int;
			var n:int = pp.length;
			
			//  let's go in all directions
			for (var i:int = pp.length; i--; ) {
				pd[i] = ALL_DIRS;
			}
			
			for (;; ) {
				if (!n && !d) {
					n = np.length;
					noiseRange--;
					if (!noiseRange) break;
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
				* and the loop repeats again until no direction are left.
				*/
				switch(1) {
					case d >> DOWN & 1: 
						d = d ^ DOWN_BIT; 
						nextDir = ALL_BUT_UP;
						oppDir = UP;
						if (mw + xyz % ms >= ms) continue; 
						txyz = xyz + mw; 
						break;
					case d >> UP & 1: 
						d = d ^ UP_BIT;
						nextDir = ALL_BUT_DOWN;
						oppDir = DOWN;
						if (xyz % ms < mw) continue;
						txyz = xyz - mw; break;
					case d >> RIGHT & 1:
						d = d ^ RIGHT_BIT;
						nextDir = ALL_BUT_LEFT;
						oppDir = LEFT;
						if (!((xyz + 1) % mw)) continue;
						txyz = xyz + 1; break;
					case d >> LEFT & 1:
						d = d ^ LEFT_BIT;
						nextDir = ALL_BUT_RIGHT;
						oppDir = RIGHT;
						if (!(xyz % mw)) continue;
						txyz = xyz - 1; break;
				}
				
				// if we see an obstruction
				if (obs[txyz]) continue;
				// if we're boldly going to somewhere we've gone before 
				if (np.indexOf(txyz) != -1 || pp.indexOf(txyz) != -1) continue;
				
				np.push(txyz);
				nd.push(nextDir);
				sendHearability(txyz, id, oppDir, noiseRange);
				newHearabilityTiles.push(txyz);
			}
			
			// removing old tiles
			for (i = hearabilityTiles.length; i-- ; ) {
				hearabilityTile = hearabilityTiles[i];
				if (newHearabilityTiles.indexOf(hearabilityTile) == -1) {
					removeNoise(hearabilityTile, id);
				}
			}
			hearabilityTiles = newHearabilityTiles;
		}
		
		
		/*  
		 * Please note that if you want use to this piece of code give credit to me, 
		 * Rogier Sluimers. That's all I ask for.
		 * This is a 4 directional line Pathfinding algorithm.
		 */
		// broadcasting line of Sight
		public function bcLoS():void {
			// the number of steps left
			var visibility:int = visibility;
			if (!visibility) return;
			
			// pp = path points
			// pd = path dirs
			// np = next points
			// nd = next dirs
			var pp:Array, pd:Array = [], np:Array = [], nd:Array = [];
			pp = onp.concat();
			
			
			const mw:int = mapWidth, ms:int = mapSize;
			const newVisibilityTiles:Array = [];
			var obs:Array = Map.obs, visibilityTile:int;
			
			const id:int = id;
			
			var xyz:int;	// xyz of point
			var txyz:int; 	// xyz of next point (more temporary)
			
			var d:int = 0;
			var nextDir:int, oppDir:int;
			var n:int = pp.length;
			
			//  let's go in all directions
			for (var i:int = pp.length; i--; ) {
				pd[i] = ALL_DIRS;
			}
			
			for (;; ) {
				if (!n && !d) {
					n = np.length;
					visibility--;
					if (!visibility) break;
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
				* and the loop repeats again until no direction are left.
				*/
				switch(1) {
					case d >> DOWN & 1: 
						d = d ^ DOWN_BIT; 
						nextDir = DOWN_BIT;
						oppDir = UP;
						if (mw + xyz % ms >= ms) continue; 
						txyz = xyz + mw; 
						break;
					case d >> UP & 1: 
						d = d ^ UP_BIT;
						nextDir = UP_BIT;
						oppDir = DOWN;
						if (xyz % ms < mw) continue;
						txyz = xyz - mw; break;
					case d >> RIGHT & 1:
						d = d ^ RIGHT_BIT;
						nextDir = RIGHT_BIT;
						oppDir = LEFT;
						if (!((xyz + 1) % mw)) continue;
						txyz = xyz + 1; break;
					case d >> LEFT & 1:
						d = d ^ LEFT_BIT;
						nextDir = LEFT_BIT;
						oppDir = RIGHT;
						if (!(xyz % mw)) continue;
						txyz = xyz - 1; break;
				}
				
				// if we see an obstruction
				if (obs[txyz]) continue;
				// if we're boldly going to somewhere we've gone before 
				if (np.indexOf(txyz) != -1 || pp.indexOf(txyz) != -1) continue;
				
				np.push(txyz);
				nd.push(nextDir);
				sendVisibility(txyz, id, oppDir, visibility);
				newVisibilityTiles.push(txyz);
			}
			
			// FIXME: maybe the "old" tiles should be removed before the loop instead comparing them to the new.
			for (i = visibilityTiles.length; i-- ; ) {
				visibilityTile = visibilityTiles[i];
				if (newVisibilityTiles.indexOf(visibilityTile) == -1) {
					removeVisibility(visibilityTile, id);
				}
			}
			visibilityTiles = newVisibilityTiles;
		}
		
		// give entity(id) on tile x,y in "hearing range" it's direction 
		public function sendNoise(xyz:int, id:int, dir:int, loudness:uint):void {
			
			var hasSound:Array = Map.hasSound[xyz];
			var hasSolid:Array = Map.hasSolid[xyz];
			var p:Point3D; 
			var b:Boolean = false; 
			
			for (var i:int = hasSound.length; i--; ) {
				p = hasSound[i];
				if (p.x == id) {
					p.y = dir;
					p.z = visibility;
					b = true;
					break;
				}
			}
			if (!b) {
				hasSound[hasSound.length] = new Point3D(id, dir, loudness);
			}
		}
		
		// give entity(id) on tile x,y in "visual range" it's direction 
		public function sendVisibility(xyz:int, id:int, dir:int, visibility:int):void {
			
			var hasLight:Array = Map.hasLight[xyz];
			var hasSolid:Array = Map.hasSolid[xyz];
			var p:Point3D; 
			var b:Boolean = false; 
			
			for (var i:int = hasLight.length; i--; ) {
				p = hasLight[i];
				if (p.x == id) {
					p.y = dir;
					p.z = visibility;
					b = true;
					break;
				}
			}
			if (!b) {
				hasLight[hasLight.length] = new Point3D(id, dir, visibility);
				//Map.setTile(xyz, 50);
			}
		}
		
		public function sendHearability(xyz:int, id:int, dir:int, noiseRange:int):void {
			
			var hasSound:Array = Map.hasSound[xyz];
			var hasSolid:Array = Map.hasSolid[xyz];
			var p:Point3D; 
			var b:Boolean = false; 
			
			for (var i:int = hasSound.length; i--; ) {
				p = hasSound[i];
				if (p.x == id) {
					p.y = dir;
					p.z = noiseRange;
					b = true;
					break;
				}
			}
			if (!b) {
				hasSound[hasSound.length] = new Point3D(id, dir, noiseRange);
				//Map.setTile(xyz, 50);
			}
		}
		
		public function removeVisibility(xyz:int,id:uint):void {
			Map.hasLight[xyz] = [];
		}
		
		public function removeNoise(xyz:int, id:uint):void {
			Map.hasSound[xyz] = [];
		}
		
		public function interActWith(eid:uint):void {
			interactingWith.push(eid);
		}
		
		public function processVision():void {}
		public function processHearing():void {}
		public function processTouch():void {}	
		
		public function setStealth(b:Boolean):void {
			setHearability(b);
			setVisibility(b);
		}
		
		public function setHearability(b:Boolean):void {
			if (b) {
				noiseRange = 0;
				for (var i:int = hearabilityTiles.length; i-- ; ) {
						removeNoise(hearabilityTiles[i], id);
				}
			}
			else noiseRange = baseNoiseRange;
		}
		
		public function setVisibility(b:Boolean):void {
			if (b) {
				visibility = 0;
				for (var i:int = visibilityTiles.length; i-- ; ) {
						removeVisibility(visibilityTiles[i], id);
				}
			}
			else visibility = baseVisibility;
		}
		
		public function setLife(nwLife:Boolean):void {
			vx = 0;
			vy = 0;
			alive = nwLife; 
		}
		
		public function getsts():uint {
			return sts;
		}
		
		public function getwTL():uint {
			return stl;
		}
		
		public function isMoving():Boolean {
			return moving;
		}
		
		public function getNoiseRange():uint {
			return noiseRange;
		}
		
		public function getVisibility():uint {
			return visibility;
		}
		
		public function isAlive():Boolean {
			return alive;
		}
		
		public function activate():void {
			active = true;
		}
		
		public function deactivate():void {
			active = false;
			stop();
		}
		
		public function setActive(b:Boolean):void {
			active = b;
			if (!b) stop();
		}
		
		public function isActive():Boolean {
			return active;
		}
		
		public function getColl():Array {
			return coll;
		}
		
		public function getName():String {
			return name;
		}
	}
}