/**
* @author Pieter Michels
*/

package be.wellconsidered.net 
{
	import flash.utils.Dictionary;
	import flash.display.LoaderInfo;
	
	import be.wellconsidered.logging.Logger;
	
	public class FlashVars 
	{
		private static var instance:FlashVars;
		
		private var _vars:Dictionary;
		
		public static function getInstance():FlashVars
		{
			if (instance == null){ instance = new FlashVars(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function FlashVars(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use FlashVars.getInstance() instead of new."); }
		}
		
		public function loadFlashVars(loaderInfo:LoaderInfo):void
		{
			_vars = new Dictionary(true);
			
			try 
			{
				var variable:Object = LoaderInfo(loaderInfo).parameters;
				
				for (var key:String in variable) 
				{
					_vars[key] = variable[key] as String;
					
					if(variable[key].length > 0)
					{
						Logger.log(key + " : \t" + variable[key]);
					}
				}
			} 
			catch (err:Error) 
			{
				Logger.log("Config: FlashVars: " + err.message);
			}			
		}
		
		public function getVar(param_key:String):String
		{
			return _vars[param_key] != null ? _vars[param_key] : "";
		}
		
		public function existsVar(param_key:String):Boolean
		{
			return getVar(param_key).length > 0;
		}
	}
}

internal class SingletonBlocker {}
