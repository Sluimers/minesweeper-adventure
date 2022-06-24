package nl.obg.mapsprites {
	import nl.obg.engine.*;
	import nl.obg.mine.*;
	
	public class Mine extends MapSprite {
		
		public function Mine(x:int, y:int, z:int) {
			name = "mine";
			super(x, y, z, "Mine.png");
			
			const xyz:int = tx + ty * mapWidth + z * mapSize;
			
			MineMap.hasMine[xyz] 	= true;
			Map.canMine[xyz]	= false; // can't mine twice
			Map.obs[xyz] 		= 0;
			Map.isEmpty[xyz] 	= false;
			
			visible = false;
		}
	}
}