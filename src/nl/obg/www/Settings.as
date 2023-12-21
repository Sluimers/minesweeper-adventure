package nl.obg.www {
	import flash.net.SharedObject;
	import flash.display.StageDisplayState;
	import flash.display.Stage;
	
	import nl.obg.standards.Key;
	/**
	 * ...
	 * @author Rogier Sluimers
	 */
	public class Settings
	{
		private static var _sharedObj:SharedObject;
		
		//static
        {
            (function():void {
                try {
					_sharedObj = SharedObject.getLocal("savedData");
				}
				catch (error:Error) {
					trace("SharedObject Error:"+error.toString());
					return false;
				}
            }());
        }
		
		public static function checkForDefaultData():void {
			var defaultSettings:Object = {
											hasRadar: 		false, 
											hasSolidCovers: false, 
											actionKey: 		Key.X, 
											flagKey: 		Key.Z, 
											fullScreen: 	false
										};
			
			for (var prop:String in _sharedObj.data) {
				if(defaultSettings[prop] == undefined) delete _sharedObj.data[prop];
			}
			
			for (prop in defaultSettings) {
				if (_sharedObj.data[prop] == undefined) {
					_sharedObj.data[prop] = defaultSettings[prop];
				}
			}
		}
		
		public static function saveData(data:Array):void {
			var n:int = 0;
			
			_sharedObj.data.hasSolidCovers = 	data[n++];
			_sharedObj.data.hasRadar = 			data[n++];
			_sharedObj.data.actionKey = 		data[n++];
			_sharedObj.data.flagKey = 			data[n++];
			_sharedObj.data.fullScreen = 		data[n++];
			
			_sharedObj.flush();
			_sharedObj.close();
		}
		
		public static function fullScreen():Boolean {
			return _sharedObj.data.fullScreen;
		}
		
		public static function hasSolidCovers():Boolean {
			return _sharedObj.data.hasSolidCovers;
		}
		
		public static function hasRadar():Boolean {
			return _sharedObj.data.hasRadar;
		}
		
		public static function actionKey():uint {
			return _sharedObj.data.actionKey;
		}
		
		public static function flagKey():uint {
			return _sharedObj.data.flagKey;
		}
		
		public static function checkForFullScreen(stage:Stage):void {
			var hasFullscreen:Boolean = (stage.hasOwnProperty("displayState"));
			if(fullScreen()) {
				if (hasFullscreen) {
					try {
						stage.scaleMode = "noScale";
						stage.displayState = StageDisplayState.FULL_SCREEN;
					} catch ( error:SecurityError ) {
						// your hide button code                        
					}
				}
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
	}
}

