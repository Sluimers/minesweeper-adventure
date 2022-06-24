package nl.obg.mapsprites {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
		import nl.obg.engine.*;
		import nl.obg.mine.*;
	 
	public class Powerup extends SolidMapSprite
	{
		public function Powerup(x:int, y:int, z:int, nwName:String) {
			name = nwName;
			
			hotwidth = 50;
			hotheight = 50;
			
			super(x, y, z, nwName + ".png");
			
			GameModel.addItem(this);
			
			obstructive = false;
		}
	}
}