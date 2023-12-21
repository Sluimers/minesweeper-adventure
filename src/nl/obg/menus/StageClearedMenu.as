package nl.obg.menus {
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	
	import nl.obg.engine.*;
	import nl.obg.standards.*;
	import nl.obg.controllers.*;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class StageClearedMenu extends MapMenu
	{
		
		public function StageClearedMenu() {
			super();
		}
		
		public override function init():void {
			const e:Engine = (parent as Engine);
			
			super.init();
			
			setSize(mapWidth, mapHeight);
			
			addCenterText("Title", "STAGE CLEARED!", Menu.TITLESIZE);
			addCenterText("Play again button", "Play again?", TEXTSIZE, Color.SILVER);
			addItemEventListener("Play again button", MouseEvent.CLICK, GameControl.nextLevelM);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, GameControl.nextLevelMenuKeys);
		}
		
	}

}