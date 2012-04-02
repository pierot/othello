/**
* @author Pieter Michels
*/

package be.wellconsidered.utils.validation 
{
	public class EmailValidator
	{
		private static var instance:EmailValidator;
		
		private const EMAIL_REGEX : RegExp = /^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$/i;
		
		public static function getInstance():EmailValidator
		{
			if (instance == null){ instance = new EmailValidator(new SingletonBlocker()); }
			
			return instance;
		}
		
		public function EmailValidator(param:SingletonBlocker):void
		{
			if (param == null){ throw new Error("Error: Instantiation failed: Use EmailValidator.getInstance() instead of new."); }
		}	
		
		public function validate(email:String):Boolean
		{
			 return Boolean(email.match(EMAIL_REGEX));
		}
	}
}

internal class SingletonBlocker {}
