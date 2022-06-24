package nl.obg.locals {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	
	import nl.obg.www.*;
	import nl.obg.engine.*;
	
	public class StartPosition
	{
		public static var positions:Object = { player: Engine.player, position:new SaveState(0, 19*50, 0, "level1") }
		
		public static function getPosition(p:Player):SaveState {
			return positions[p];
		}
	}

}