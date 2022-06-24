package nl.obg.gtk {
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class GtkVBox extends MovieClip
	{
		public function GtkVBox(xmlList:XMLList) {
			const GtkVBoxList:XMLList = xmlList.child;
			const attributes:XMLList = GtkVBoxList.attribute("class");
			var currentObject:XMLList;
			var attribute:String;
			
			trace("gtkvboxlist 1:" + xmlList.children().length());
			trace("gtkvboxlist 1:" + xmlList.child.length());
			trace("gtkvboxlist 1:" + xmlList);
			trace("gtkvboxlist 1:" + GtkVBoxList.length());
			
			for (var i:uint = attributes.length(); i--; ) {
				
				currentObject = new XMLList(GtkVBoxList.child("object")[i]);
				attribute = attributes[i];
				
				trace("currentObject:"+currentObject);
				
				switch(attribute) {
					case "GtkTextView": 
						addChild(new GtkTextView(currentObject));
						break;
					case "GtkVButtonBox": 
						addChild(new GtkVButtonBox(currentObject));
						break;
				}
			}
		}
	}
}