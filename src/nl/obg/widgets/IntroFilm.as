package nl.obg.widgets {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import nl.obg.locals.*;
	import nl.obg.www.*;
	import nl.obg.engine.*;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class IntroFilm extends Widget
	{
		private const movie:* = PObjectList.getMovie(LocalPathName.movies + PathName.introMovie);
		
		
		public function IntroFilm() {
			
			
		}
		
		public override function init():void {
			super.init();
			movie.gotoAndPlay(0,movie.scenes[0].name);
			addChild(movie);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public  function onKeyDown(event:KeyboardEvent = null):void {
			if (event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.SPACE) {
				Settings.checkForDefaultData();
				stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
				removeChild(movie);
				stage.removeChild(this);
				Engine.init();
			}
		}	
	}
}