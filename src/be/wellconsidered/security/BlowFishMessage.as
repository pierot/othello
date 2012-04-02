/**
* @author Pieter Michels
* http://crypto.hurlant.com/
*/

package be.wellconsidered.security 
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.IPad;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.crypto.symmetric.NullPad;
	import com.hurlant.crypto.symmetric.ICipher;
	import com.hurlant.crypto.symmetric.IVMode;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	
	import flash.utils.ByteArray;
	
	import be.wellconsidered.logging.Logger;
	
	public class BlowFishMessage 
	{
		private var _aes:ICipher;
		private var _pad:IPad;
		private var _baKey:ByteArray;
		private var _sIVKey:String;
		
		private var _sCurrMode:String;
		
		public static const MODE_ECB:String = "ModeECB";
		public static const MODE_CFB:String = "ModeCFB";
		
		public function BlowFishMessage(key:String, mode:String = BlowFishMessage.MODE_ECB) 
		{
			_sCurrMode = mode;
			_baKey = Hex.toArray(key);
			
			switch(_sCurrMode)
			{
				case BlowFishMessage.MODE_CFB:
				
					_pad = new PKCS5();
					_aes = Crypto.getCipher("blowfish-cfb", _baKey, _pad);
					
					break;
					
				case BlowFishMessage.MODE_ECB:
				
					_pad = new NullPad();
					_aes = Crypto.getCipher("blowfish-ecb", _baKey, _pad);
					
					break;
			}
			
			_pad.setBlockSize(_aes.getBlockSize());
		}
		
		public function encrypt(clear:String):String
		{
			var baData:ByteArray = Hex.toArray(Hex.fromString(clear));
			var sRes:String;
			
			_aes.encrypt(baData);
			
			// INITIALISATION VECTOR
			if (_aes is IVMode && _sCurrMode == BlowFishMessage.MODE_CFB) 
			{
				var ivmMode:IVMode = _aes as IVMode;
			
				_sIVKey = Hex.fromArray(ivmMode.IV);
			}
			
			sRes = Hex.fromArray(baData);
			
			Logger.log("Encrypted : " + sRes);
			
			return sRes;
		}
		
		public function decrypt(cipher:String):String
		{
			var baData:ByteArray = Hex.toArray(cipher);
			var sRes:String;
			
			// INITIALISATION VECTOR
			if (_aes is IVMode && _sCurrMode == BlowFishMessage.MODE_CFB)
			{
				var ivmMode:IVMode = _aes as IVMode;
				
				ivmMode.IV = Hex.toArray(_sIVKey);
			}
			
			_aes.decrypt(baData);
			
			sRes = Hex.fromArray(baData);
			
			Logger.log("Decrypted : " + sRes + " (" + Hex.toString(sRes) + ")");
			
			return Hex.toString(sRes);
		}
		
		/**
		* Getters / Setters
		*/
		public function get iv():String { return _sIVKey; }
		
		public function set iv(value:String):void {
			_sIVKey = value;
		}
	}
}
