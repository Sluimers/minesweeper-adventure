package nl.obg.gtk {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class GtkVButtonBox extends MovieClip
	{
		public var label:String;
		
		public function GtkVButtonBox(xmlList:XMLList) {
			var propertyList:XMLList = xmlList.property;
			var name:String;
			
			for (var i:uint = propertyList.length(); i--; ) {
				name = propertyList[i].@name;
				switch(name) {
					case "label": label = propertyList[i];
					case "visible": visible = true;
				}
			}
			
			trace("label: "+label);
		}
	}
}