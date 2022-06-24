package nl.obg.standards {
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class Point3D {
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public function Point3D(nwX:Number = 0, nwY:Number = 0, nwZ:Number = 0) {
			x = nwX;
			y = nwY;
			z = nwZ;
		}
		
		public function equals(p:Point3D):Boolean {
			if (x == p.x) if (y == p.y) if (z == p.z) return true;
			return false;
		}
	}
}