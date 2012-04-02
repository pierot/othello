/**
* @author Pieter Michels
* http://www.pacem.it/CMerighi/Posts/42,en-US/AES-Rijndael_with_ActionScript_and_ASP.Net.aspx
*/

package be.wellconsidered.security 
{
	import it.pacem.cryptography.Rijndael;

	import be.wellconsidered.logging.Logger;
	
	public class RijndaelMessage 
	{
		private var _aes:Rijndael;
		private var _sKey:String;
		
		private const MODE:String = "ECB";
		
		public function RijndaelMessage(key:String) 
		{
			_sKey = key;
			_aes = new Rijndael(192, 128);
		}
		
		public function encrypt(clear:String):String
		{
			var sRes:String = _aes.encrypt(clear, _sKey, MODE);

			Logger.log("Encrypted : " + sRes);
			
			return sRes;
		}
	}
}
