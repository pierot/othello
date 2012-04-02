package be.wellconsidered.net
{
	import flash.external.ExternalInterface;
	import flash.utils.*;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	
	import be.wellconsidered.logging.Logger;
	
	public class HostURL
	{
		private var _all:String;
		private var _base:String = "../../";
		private var _query_string:String;
		private var _params:URLVariables;
		
		private var _swfadd_active:Boolean = false;
		
		private const _LOCAL:String = "local";
		
		public function HostURL(param_swfaddress:Boolean)
		{
			_swfadd_active = param_swfaddress;
			
			if(Capabilities.manufacturer == "Macintosh")
			{
				_base = "..\\..\\";
			}
			
			extractURL();
		}
		
		private function extractURL():void
		{
			try 
			{
				_all =  ExternalInterface.call("window.location.href.toString");
				_query_string = ExternalInterface.call("window.location.search.substring", 1);
				
				if(_swfadd_active)
				{
					_base = _all.split("#")[0].substring(0, _all.split("#")[0].lastIndexOf("/")) + "/";	
				}
				else
				{
					_base = _all.split("?")[0].substring(0, _all.split("?")[0].lastIndexOf("/")) + "/";				
				}
			}
			catch(e:Error)
			{
				_all = _LOCAL;
				
				Logger.log("Some error occured. ExternalInterface doesn't work in Standalone player. (" + e.message + ")");
			}  	
			
			try 
			{
				_params = new URLVariables(_query_string);
			}
			catch(e:Error)
			{
				Logger.log(e.message);
			} 			
		}
		
		/**
		* Getters / Setters
		*/
		public function get parameters():URLVariables
		{
			return _params;
		}		
		
		public function get longURL():String
		{
			return _all;
		}
		
		public function get baseURL():String
		{
			return _base;
		}	
		
		public function set baseURL(value:String):void
		{
			_base = value;
		}
		
		public function isLocal():Boolean
		{
			return _all == _LOCAL;
		}
		
		public function toString():String
		{
			return "longURL ( " + longURL + " ) \t baseURL ( " + baseURL + " )  \t isLocal ( " + isLocal() + " )";
		} 
	}
}
