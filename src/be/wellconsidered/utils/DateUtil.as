package be.wellconsidered.utils
{
	import com.adobe.utils.ArrayUtil;

	/**
	* 	Class that contains static utility methods for manipulating and working
	*	with Dates.
	*/	
	public class DateUtil
	{
		/**
		*	Returns a two digit representation of the year represented by the 
		*	specified date.
		* 
		* 	@param d The Date instance whose year will be used to generate a two
		*	digit string representation of the year.
		* 
		* 	@return A string that contains a 2 digit representation of the year.
		*	Single digits will be padded with 0.
		*/	
		public static function getShortYear(d:Date):String
		{
			var dStr:String = String(d.getFullYear());
			
			if(dStr.length < 3)
			{
				return dStr;
			}

			return (dStr.substr(dStr.length - 2));
		}

		/**
		*	Compares two dates and returns an integer depending on their relationship.
		*
		*	Returns -1 if d1 is greater than d2.
		*	Returns 1 if d2 is greater than d1.
		*	Returns 0 if both dates are equal.
		* 
		* 	@param d1 The date that will be compared to the second date.
		*	@param d2 The date that will be compared to the first date.
		* 
		* 	@return An int indicating how the two dates compare.
		*/	
		public static function compareDates(d1:Date, d2:Date):int
		{
			var d1ms:Number = d1.getTime();
			var d2ms:Number = d2.getTime();
			
			if(d1ms > d2ms)
			{
				return -1;
			}
			else if(d1ms < d2ms)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}

		/**
		*	Returns a short hour (0 - 12) represented by the specified date.
		*
		*	If the hour is less than 12 (0 - 11 AM) then the hour will be returned.
		*
		*	If the hour is greater than 12 (12 - 23 PM) then the hour minus 12
		*	will be returned.
		* 
		* 	@param d1 The Date from which to generate the short hour
		* 
		* 	@return An int between 0 and 13 ( 1 - 12 ) representing the short hour.
		*/	
		public static function getShortHour(d:Date):int
		{
			var h:int = d.hours;
			
			if(h == 0 || h == 12)
			{
				return 12;
			}
			else if(h > 12)
			{
				return h - 12;
			}
			else
			{
				return h;
			}
		}
		
		/**
		*	Returns a string indicating whether the date represents a time in the
		*	ante meridiem (AM) or post meridiem (PM).
		*
		*	If the hour is less than 12 then "AM" will be returned.
		*
		*	If the hour is greater than 12 then "PM" will be returned.
		* 
		* 	@param d1 The Date from which to generate the 12 hour clock indicator.
		* 
		* 	@return A String ("AM" or "PM") indicating which half of the day the 
		*	hour represents.
		*/	
		public static function getAMPM(d:Date):String
		{
			return (d.hours > 11)? "PM" : "AM";
		}
	    
		/**
		* Parses dates that conform to the W3C Date-time Format into Date objects.
		*
		* This function is useful for parsing RSS 1.0 and Atom 1.0 dates.
		*/		     
		public static function parseW3CDTF(str:String):Date
		{
            var finalDate:Date;
			try
			{
				var dateStr:String = str.substring(0, str.indexOf("T"));
				var timeStr:String = str.substring(str.indexOf("T")+1, str.length);
				var dateArr:Array = dateStr.split("-");
				var year:Number = Number(dateArr.shift());
				var month:Number = Number(dateArr.shift());
				var date:Number = Number(dateArr.shift());
				
				var multiplier:Number;
				var offsetHours:Number;
				var offsetMinutes:Number;
				var offsetStr:String;
				
				if (timeStr.indexOf("Z") != -1)
				{
					multiplier = 1;
					offsetHours = 0;
					offsetMinutes = 0;
					timeStr = timeStr.replace("Z", "");
				}
				else if (timeStr.indexOf("+") != -1)
				{
					multiplier = 1;
					offsetStr = timeStr.substring(timeStr.indexOf("+")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("+"));
				}
				else // offset is -
				{
					multiplier = -1;
					offsetStr = timeStr.substring(timeStr.indexOf("-")+1, timeStr.length);
					offsetHours = Number(offsetStr.substring(0, offsetStr.indexOf(":")));
					offsetMinutes = Number(offsetStr.substring(offsetStr.indexOf(":")+1, offsetStr.length));
					timeStr = timeStr.substring(0, timeStr.indexOf("-"));
				}
				var timeArr:Array = timeStr.split(":");
				var hour:Number = Number(timeArr.shift());
				var minutes:Number = Number(timeArr.shift());
				var secondsArr:Array = (timeArr.length > 0) ? String(timeArr.shift()).split(".") : null;
				var seconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var milliseconds:Number = (secondsArr != null && secondsArr.length > 0) ? Number(secondsArr.shift()) : 0;
				var utc:Number = Date.UTC(year, month-1, date, hour, minutes, seconds, milliseconds);
				var offset:Number = (((offsetHours * 3600000) + (offsetMinutes * 60000)) * multiplier);
				finalDate = new Date(utc - offset);
	
				if (finalDate.toString() == "Invalid Date")
				{
					throw new Error("This date does not conform to W3CDTF.");
				}
			}
			catch (e:Error)
			{
				var eStr:String = "Unable to parse the string [" +str+ "] into a date. ";
				eStr += "The internal error was: " + e.toString();
				throw new Error(eStr);
			}
            return finalDate;
		}
	     
		/**
		* Returns a date string formatted according to W3CDTF.
		*
		* @param d
		* @param includeMilliseconds Determines whether to include the
		* milliseconds value (if any) in the formatted string.
		*/		     
		public static function toW3CDTF(d:Date,includeMilliseconds:Boolean=false):String
		{
			var date:Number = d.getUTCDate();
			var month:Number = d.getUTCMonth();
			var hours:Number = d.getUTCHours();
			var minutes:Number = d.getUTCMinutes();
			var seconds:Number = d.getUTCSeconds();
			var milliseconds:Number = d.getUTCMilliseconds();
			var sb:String = new String();
			
			sb += d.getUTCFullYear();
			sb += "-";
			
			//thanks to "dom" who sent in a fix for the line below
			if (month + 1 < 10)
			{
				sb += "0";
			}
			sb += month + 1;
			sb += "-";
			if (date < 10)
			{
				sb += "0";
			}
			sb += date;
			sb += "T";
			if (hours < 10)
			{
				sb += "0";
			}
			sb += hours;
			sb += ":";
			if (minutes < 10)
			{
				sb += "0";
			}
			sb += minutes;
			sb += ":";
			if (seconds < 10)
			{
				sb += "0";
			}
			sb += seconds;
			if (includeMilliseconds && milliseconds > 0)
			{
				sb += ".";
				sb += milliseconds;
			}
			sb += "-00:00";
			return sb;
		}
	}
}
