package nl.obg.mine {
	
	import flash.filters.DisplacementMapFilter;
	import nl.obg.engine.*;
	import nl.obg.entities.*;
	import nl.obg.mapsprites.*;
	import nl.obg.mine.*;
	import nl.obg.controllers.*;
	import nl.obg.www.*;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class MineMap extends Map {
		public static var numberLights:Array = [];
		
		private static  var flags:Array;
		
		private static  var mines:Array;
		
		public static var hasMine:Array;
		public static var hasFlag:Array;
		
		
		
		public static function resetMap():void {
			GameModel.droidIDLs = [];
			GameModel.itemIDLs = [];
			
			hasMine = [];
			hasFlag = [];
			
			Map.resetMap();
		}
		
		public static function Switch(mapName:String):void {
			const m:MineMapData = loadMapData(mapName);
			
			Map.Switch(mapName);
			
			// placing the mines 
			placeMines(m.mines, m.nMines);
			
			// placing the covers
			placeCovers(m.covers); 
			
			// finally the numbers and entities, they go after the "placing" of the covers, 
			// because we need to know if they are being covered or not, so that they can be made invisible. 
			placeNumbers();
		}
		
		private static function loadMapData(mapName:String):MineMapData {
			var md:MineMapData = savedMapData[mapName];
			if (md) return md;
			return null;
			//return Map.loadXMLMap(mapName);
		}
		
		/*
		private static function loadXMLMap(mapName:String):MapData {
			Map.loadXMLMap(mapName);
		}
		*/
		
		public static function uncoverTilesR(x:int, y:int, z:int, r:uint = 2):void {
			var o:uint = r - 1, d:uint = r * 2 - 1;
			uncoverTiles(x - o, y - o, z, d, d);
		}
		
		public static function uncoverTiles(x:int, y:int, z:int, width:uint, height:uint):void {
			var j:int, k:int = height;
			
			for (var i:uint = width * height; i--; ) {
				if (!j) {
					j = width;
					k--;
				}
				j--;
				uncoverTile(x + j, y + k, z);
			}
		}
		
		public static function uncoverTile(x:int, y:int, z:int):void {
			const i:uint = x + y * mapWidth + z * mapSize;
			isCovered[i] = false;
			if (!hasObs[i]) obs[i] = 0;
		}
		
		public static function placeFlags(flags:Array):void {
			const mw:uint = mapWidth, mh:uint = mapHeight, nl:uint = numLayers;
			var x:uint = --mw, y:uint = --mh, z:uint = --nl;
			
			hasFlag = flags;
			
			for (var i:uint = flags.length; i--;) {
				if (flags[i]) newFlag(x, y, z);
				
				if (!x--) {
					x = mw;
					if (!y--) {
						y = mh;
						z++;
					}
				}
			}
		}
		
		public static function newMine(x:int, y:int, z:int = 0):void {
			var mine:Mine = new Mine(x * tileWidth, y * tileHeight, z);
			mines.push(mine);
		}
		
		public static function newFlag(x:int, y:int, z:int = 0):void {
			var flag:Flag = new Flag(x * tileWidth, y * tileHeight, z);
			flags.push(flag);
		}
		
		public static function newGuard(x:int, y:int, z:int):void {
			new Guard(x, y, z);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
		}
		
		public static function newMineLayer(x:int, y:int, z:int):void {
			new MineLayer(x, y, z);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
		}
		
		public static function newProxyDroid(x:int, y:int, z:int):void {
			new ProxyDroid(x, y, z);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
		}
		
		public static function newWallHugger(x:int, y:int, z:int):void {
			new WallHugger(x, y, z);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
		}
		
		public static function newLoSDroid(x:int, y:int, z:int):void {
			new LoSDroid(x, y, z);
		}
		
		public static function newTestDroid(x:int, y:int, z:int):void {
			new TestDroid(x, y, z);
		}
		
		public static function placeCovers(covers:Array):void {
			
			for (var i:uint = covers.length; i--; ) {
				if (hasMine[i]) {
					isCovered[i] = true;
					obs[i] = 1;
					continue;
				}
				
				switch (covers[i]) {
					case 0: { isCovered[i] = false; if(!hasObs[i]) 		obs[i] = 0;	break; }
					case 1: { isCovered[i] = true;  					obs[i] = 1; break; }
					case 2: { isCovered[i] = true;	canMine[i] = false; obs[i] = 1; break; }
				}
			}
		}
		
				// TODO.. for every mine placed and obstruction, square off X number of canMine places,
		// where X is the number of places where a new placed mine would close off an area.
		public static function placeMines(mineMap:Array, randomMines:Array):void {
			const mw:uint = mapWidth, mmw:uint = mw - 1, mmh:uint = mapHeight - 1, ms:uint = mapSize, nl:uint = numLayers - 1;
			var i:uint, x:int = mmw, y:int = mmh, z:uint = nl;
			var m:uint = 0;				// number of places where mines can be put
			var r:int;
			var minePlaces:Array = [], openPlaces:Array = [];
			var xyz:int;
			var n:uint; 
			
			// splicing the nonrandom Mines
			for (i = mineMap.length; i--; ) {
				m = mineMap[i]
				
				switch(m) {
					case 0: break;
					case 1: { if (canMine[i]) newMine(x, y, z); break;}
					default: 
						if (canMine[i]) {
							if (minePlaces[m - 2] == undefined) minePlaces[m - 2] = [];
							minePlaces[m - 2].push(x + y * mw + z * ms); 
						}
					break;
				}
				
				if (!x--) {
					x = mmw;
					if (!y--) {
						y = mmh;
						z--;
					}
				}
			}
			
			// * END DETERMINING POSSIBLE SPOTS FOR RANDOM MINES ALGORITHM * //
			for (i = randomMines.length; i--; ) {
				n = randomMines[i];
				
				if (minePlaces[i] == undefined) minePlaces[i] = [];
				openPlaces = minePlaces[i].slice();
				
				for (; n--; ) {
					
					m = openPlaces.length;
					r = Math.random() * m;
					xyz = openPlaces[r];
					
					if (canPlaceMine(xyz)) {
						openPlaces.splice(r, 1);
						m--;
						n++;
						if (!m) break;
						continue;
					}
					else {
						openPlaces = minePlaces[i].slice();
					}
					
					m = xyz % ms;
					z = xyz / ms;
					y = m / mw;
					x = m % mw;
					
					newMine(x, y , z);
					minePlaces[i].splice(r, 1);
				}
			}
		}
		
		public static function joinClusters(toCluster:int, ... nwClusters:Array):void {
			const superCluster:Array = superCluster.concat(nwClusters);
			for (var i:int = 0; i < superCluster.length; i++) {
				hasCluster[superCluster[i]] = toCluster;
			}
			if (toCluster != 1) clusters[toCluster].concat(superCluster);
		}
		
		// TODO.. makes this work and work on mines, obstructions and solidsprites
		public static function canPlaceMine(xyz:int):Boolean {
			const mw:uint = mapWidth, ms:uint = mapSize; 
			const xyzd:int = xyz + mw, xyzu:int = xyz - mw, xyzr:int = xyz + 1, xyzl:int = xyz + 1;
			const xyzdr:int = xyzd + 1, xyzdl:int = xyzd - 1, xyzur:int = xyzu + 1, xyzul:int = xyzu - 1;
			const xy:int = xyz % ms;
			const x:int = xy % mw; 
			const side:int = (((int(!x) << 1 | int(x + 1 == mw)) << 1 | int(xy < mw)) << 1 | int(mw + xy >= ms));
			const m1:int = side & 0x0001 ? 1 : hasCluster[xyzd], m2:int = side & 0x0010 ? 1 : hasCluster[xyzu];
			const m3:int = side & 0x0100 ? 1 : hasCluster[xyzr], m4:int = side & 0x1000 ? 1 : hasCluster[xyzl];
			var d:int = (((int(! !m4) << 1 | int(! !m3)) << 1 | int(! !m2)) << 1 | int(! !m1));
			
			/*
				0011
				1100
				0000iiii i > 1
				0ii01xxx i
				i00ix1xx i
				i0i0xx1x i
				0i0ixxx1 i
			*/
			if(d == 3) { 
				if(m1 == m2) {
					return false;
				}
				else {
					d = Math.min(clusters[m1].length, clusters[m2].length);
					const e:int = Math.max(clusters[m1].length, clusters[m2].length);
					clusters.push(xyz);
					hasCluster[xyz] = d;
					joinClusters(d, e);
					if(d != 1) return false;
					return true;
				}
			}
			else if(d == 12) {
				return m3 == m4 ? true : m3 == 1; 
			}
			else {
				const m5:int = side & 0x0101 ? 1 : hasCluster[xyzdr],	m6:int = side & 0x1010 ? 1 : hasCluster[xyzul];
				const m7:int = side & 0x0110 ? 1 : hasCluster[xyzur],	m8:int = side & 0x1001 ? 1 : hasCluster[xyzdl];

				if(!d){
					// TODO: This is complex stuff, 4 possible clusters, *sigh*
					const a:Array = [0];
					a[m5] = 1;
					a[m6] = a[m6] 
					a[m7] = 1;
					a[m8] = 1;
					return m5 == m6? m5 : false;  
				}	

				d = d | (((int(! !m8) << 1 | int(! !m7)) << 1 | int(! !m6)) << 1 | int(! !m5));
				
				if(d & 0x10011000 == 8 ? d & 0x01100000 : false) {
					return m8 == m1 ? true : m8 == m4 ? true : m8 == 1;  	
				}
				if(d & 0x01100100 == 4 ? d & 0x10010000 : false) {
					return m7 == m2 ? true : m7 == m3 ? true : m7 == 1; 
				}
				if(d & 0x10100010 == 2 ? d & 0x01010000 : false) {
					return m6 == m2 ? true : m6 == m4 ? true : m6 == 1; 
				}
				if(d & 0x01010001 == 1 ? d & 0x10100000 : false) {
					return m5 == m1 ? true : m5 == m3 ? true : m5 == 1; 
				}

				if(d) {
					// find which cluster the mine belongs to
				}
				return false;
			}
		}
		
		public static function placeNumbers():void {
			const mw:int = mapWidth, mh:int = mapHeight, ms:int = mapSize, tw:int = tileWidth, th:int = tileHeight, mw2:int = mw;
			const layers:Array = layers;
			var number:int, k:int, l:int;
			var x:int = --mw, y:int = --mh, z:int = numLayers - 1;
			var nonumber:int;
			
			for (var i:int = mapVolume; i--; ) {
				
				number = 0;
				l = i + (mw2 << 1) - 1;
				
				for (var j:int = 9; j--; ) {
					if (!k) {
						k = 3;
						l = l - mw2 + k;
					}
					k--;
					l--; 
					if (!x && !k) continue;   
					if (x == mw && k == 2) continue; 
					if (hasMine[l]) number++;
				}
				
				if (number) {
					new NumberLight(x * tileWidth, y * tileHeight, 0, number);
					isEmpty[i] = false;
				}
				else isEmpty[i] = true;
				
				if (!x--) {
					x = mw;
					if (!y--) {
						y = mh;
						z--;
					}
				}
			}
		}
		
		public static function uncover(x:int, y:int, z:int):void {
			const mw:uint = mapWidth, ms:uint = mapSize;
			uncoverXYZ(x + y * mw + z * ms);
		}
		
		public static function uncoverXYZ(xyz:int):void {
			const mw:uint = mapWidth, ms:uint = mapSize; 
			var i:uint, j:uint, k:uint;
			
			if(isCovered[xyz]) {
				
				if(hasFlag[xyz]) return;
				else if(hasMine[xyz]) { 
					GameControl.gameOver();
				}
				else {
					const sprites:Array = Engine.sprites, spriteIDLs:Array = Engine.spriteIDLs;
					var p:int, pts:Array = [];
					var spriteIds:Array = [], spriteIDCs:Array = [];
					var solidIds:Array = [], solidIDCs:Array = [];
					var mapSprite:MapSprite;
					const isObs:Boolean = hasObs[xyz];
					
					p = xyz;
					pts.push(p);
					
					for (i = 1; i--; ) {
						p = pts[0];
						
						isCovered[p] = false;
						if (!hasObs[p]) obs[p] = 0;
						
						spriteIds = hasSprite[p];
						solidIds = hasSolid[p];
						
						for (j = spriteIds.length; j--; ) {
							k = spriteIds[j];
							if (spriteIDCs[k]) continue;
							// using !(mapSprite is Entity) doesn't seem to work :/
							if (Engine.entIDLs[k] == undefined) {
								mapSprite = sprites[spriteIDLs[k]];
								if (!Settings.hasRadar() || !(mapSprite is NumberLight)) {
									mapSprite.visible = true;
								}
							}
							spriteIDCs[k] = true;
						}
						
						for (j = solidIds.length; j--; ) {
							k = solidIds[j];
							if (solidIDCs[k]) continue;
							mapSprite = sprites[spriteIDLs[k]];
							
							mapSprite.visible = true;
							// TODO.. check if  if(droidIDLs[k] == undefined) is faster than this
							if (mapSprite is Droid) { 
								(mapSprite as Droid).activate();
							}
							solidIDCs[j] = true;
						}
						
						
						pts.shift();
						
						if (isEmpty[p]) {
							var pd:int;
							for (var d:int = 4; d--; ) {
								switch(d) {
									case 0: 
										if (mw + p % ms >= ms) continue;
										pd = p + mw; 	
									break;
									case 1: 
										if (p % ms < mw) continue;
										pd = p - mw; 	
									break;
									case 2: 
										if (!((p + 1) % mw)) continue;
										pd = p + 1; 	
									break;
									case 3: 
										if (!(p % mw)) continue;
										pd = p - 1; 	
									break;
								}
								
								if (isCovered[pd]) {
									if (!hasFlag[pd] && hasObs[pd] == isObs) {
										if (pts.indexOf(pd) == -1) {
											i++;
											pts.push(pd);
										}
									}
								} 	
							}
						}
					}
					Engine.player.ent.bcLoS();
				}
			}
		}
		
		public static function uncoverMines():void {
			const lflags:Array = flags.slice(), lmines:Array = mines.slice(), mw:int = mapWidth, ms:int = mapSize; 
			var xyz:int, flag:Flag, mine:Mine;
			
			for (var i:int = flags.length; i--; ) {
				flag = lflags[i];
				xyz = flag.tx + flag.ty * mw + flag.z * ms;
				if (!hasMine[xyz]) {
					flags[i].visible = false;
				}
			}
			
			for (i = lmines.length; i--; ) {
				mine = lmines[i];
				xyz = mine.tx + mine.ty * mw + mine.z * ms;
				if (!hasFlag[xyz]) {
					isCovered[xyz] = false;
					MineMap.numberLights[xyz].visible = false;
					mines[i].visible = true;
				}
			}
		}
		
		
		public static function coverMines():void {
			var xyz:int;
			for (var i:int = mines.length; i--; ) {
				var mine:Mine = mines[i]; 
				xyz = mine.tx + mine.ty * mapWidth + mine.z * mapSize;
				mines[i].visible = false;
				isCovered[xyz] = true;
			}
		}
		
		public static function removeRandomMine():void {
			const mw:uint = mapWidth, ms:uint = mapSize;
			var xyz:int;
			
			if(mines.length) {
				var x:int;
				var y:int;
				var z:int;
				
				var m:uint = Math.random() * mines.length;
				
				var mine:Mine = mines[m]; 
				xyz = mine.tx + mine.ty * mw + mine.z * ms;
				
				hasMine[xyz] = false;
				if (hasFlag[xyz]) toggleFlag(xyz);
				isCovered[xyz] = false;
				obs[xyz] = 0;
				
				var lx:int = 0;
				var ly:int = 0;
				
				var j:int;
				
				var number:uint;
				var color:uint = 0;
				
				xyz = xyz + (mw << 1) - 1;
				
				for (var i:int = 9; i--; ) {
					
					if (!j) {
						j = 3;
						xyz = xyz - mw + j;
					}
					j--;
					xyz--;
					
					number = MineMap.numberLights[xyz].number;
					if (number) {
						MineMap.numberLights[xyz].number--;
					}
					else isEmpty[xyz] = true;
				}
				mines.splice(m, 1);
			}
		}
		
		public static function toggleFlag(xyz:int):void {
			const mw:uint = mapWidth, ms:uint = mapSize;
			const xy:uint = xyz % ms, x:uint = xy % mw;
			const y:uint = xy / mw, z:uint = xyz / ms;
			
			if(isCovered[xyz] || hasObs[xyz]) {
				if(hasFlag[xyz]) {
					for (var i:uint = flags.length; i--;) {
						const flag:Flag = flags[i]; 
						if (flag.xyz == xyz) {
							flags.splice(i, 1);
							flag.removeFromGame();
							hasFlag[xyz] = false;
							break;
						}
					}
				}
				else newFlag(x, y, z);
			}
		}
		
		public static function coverCleared():Boolean {
			for (var i:uint = isCovered.length; i--; ) {
				if (isCovered[i]) {
					if (!hasMine[i]) return false;
				}
			}
			
			return true;
		}
	}
}