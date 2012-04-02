/**
* @author Pieter Michels
*/

package be.wellconsidered.utils 
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	public class Clone
	{
		private static var instance:Clone;
		
		public static function getInstance():Clone
		{
			if (instance == null){ instance = new Clone(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function Clone(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use Clone.getInstance() instead of new."); }
		}	
		
		public function clone(param_o:*, param_c_name:String, param_c:Class):*
		{
			registerClassAlias(param_c_name, param_c);
			
			var buffer:ByteArray = new ByteArray();
			
			buffer.writeObject(param_o);
			buffer.position = 0;
			
			return buffer.readObject() as Object;
		}
	}
}

internal class SingletonBlocker {}