package nl.obg.mapsprites {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	import nl.obg.engine.*;
	 
	public class Sign extends SolidMapSprite {
		public function Sign(x:int, y:int, z:int, nwAvatar:String, event:String) {
			adjEventLabel = event;
			
			hotwidth = 50;
			hotheight = 50;
			
			super(x, y, z, "Sign.png");
		}
	}
}