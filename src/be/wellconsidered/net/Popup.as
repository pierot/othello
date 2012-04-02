/**
* @author Pieter Michels
*/

package be.wellconsidered.net
{
	import flash.external.ExternalInterface;

	public class Popup
	{
		private static var instance:Popup;

		public static function getInstance():Popup
		{
			if (instance == null){ instance = new Popup(new SingletonBlocker()); }

			return instance;
		}

		public function Popup(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use Popup.getInstance() instead of new."); }
		}

		public function open(url:String, name:String = "popup", width:int = 500, height:int = 500):void
		{
			ExternalInterface.call("window.open", url, name, "width=" + width + ",height=" + height + ",left=0,top=0,toolbar=No,location=No,scrollbars=No,status=No,resizable=No,fullscreen=No");
		}

		public function openWindow(url:String, window:String = "_blank", features:String = "") : void
		{
			ExternalInterface.call("window.open", url, window);
        }
	}
}

internal class SingletonBlocker {}
