/**
* @author Pieter Michels
*/

package be.wellconsidered.net 
{
	import be.wellconsidered.logging.Logger;
	
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	
	public class CookieManager 
	{
		private static var instance:CookieManager;
		
		private var _sName:String = "";
		private var _soCookie:SharedObject;
		private var _isVerbose:Boolean = false;
		
		public static function getInstance():CookieManager
		{
			if (instance == null){ instance = new CookieManager(new SingletonBlocker()); }

			return instance;
		}

		public function CookieManager(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use CookieManager.getInstance() instead of new."); }
		}
		
		/**
		 * Create Cookie
		 */
		public function getCookie(cookieName:String):void
		{
			if(_isVerbose)
				Logger.log("Get cookie (" + cookieName + ")");
			
			_sName = cookieName;
			
			_soCookie = SharedObject.getLocal(_sName, "/");
			_soCookie.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
		}		
		
		/**
		 * Read Cookie
		 */
		public function read(propertyName:String):String
		{
			if(_isVerbose)
				Logger.log("Read cookie (" + propertyName + ")");
			
			return _soCookie.data[propertyName];
		}		
		
		/**
		 * Write to cookie
		 */
		public function write(propertyName:String, propertyData:String):void
		{
			if(_isVerbose)
				Logger.log("Write to cookie (" + propertyName + "->" + propertyData + ")");
			
			if(_soCookie == null)
				getCookie(_sName);
			
			_soCookie.data[propertyName] = propertyData;
			_soCookie.flush();
			
			if(_soCookie.data[propertyName] == propertyData)
				Logger.log("Writing to cookie was successful");
		}
		
		/**
		 * Exists Var
		 */
		public function exists(propertyName:String):Boolean
		{
			if(_isVerbose)
				Logger.log("Exists cookie (" + propertyName + ")");
			
			return _soCookie.data ? (_soCookie.data[propertyName] != undefined) : false;
		}		
		
		/**
		 * Clear Cookie
		 */
		public function clear():void
		{
			Logger.log("Clear cookie");
			
			_soCookie.clear();
			
			_soCookie = undefined;
			_soCookie = null;
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
            switch (e.info.code) 
			{
                case "SharedObject.Flush.Success":
				
                    Logger.log("User granted permission -- value saved.");
					
                    break;
					
                case "SharedObject.Flush.Failed":
				
                    Logger.log("User denied permission -- value not saved.");
					
                    break;
            }
        }
        
        public function set isVerbose(value:Boolean):void{ _isVerbose = value; }
	}
}

internal class SingletonBlocker { }
