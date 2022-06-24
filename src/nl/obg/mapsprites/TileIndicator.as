package nl.obg.mapsprites {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	import nl.obg.engine.*;
	import nl.obg.mine.*;
	 
	public class TileIndicator extends MapSprite
	{
		public function TileIndicator(nwName:String) {
			name = nwName;
			
			width		= 50;
			height		= 50;
			
			GameModel.setTileIndicator(this);
			
			super(-width, -height, 0, nwName + ".png");
			
			visible = false;
		}
	}
}