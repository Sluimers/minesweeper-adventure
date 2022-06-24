package nl.obg.junk {
	/**
	 * ...
	 * @author ...
	 */
	public class Camera
	{
		public var x:int;
		public var y:int;
		public var target:Entity;
		
		public function Camera(x:int = 0, y:int = 0) {
			
		}
		
		public function setTarget(nwTarget:Entity):void {
			target = nwTarget;
		}
		
		
	}
}