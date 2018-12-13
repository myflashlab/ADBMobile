package com.myflashlab.air.extensions.adobeMobile
{
	import flash.events.Event;
	
	/**
	 * 
	 * @author Hadi Tavakoli - 10/5/2018 3:35 PM
	 */
	public class ADBMobileEvents extends Event
	{
		public static const TIMED_ACTION_ENDED:String = "onTimedActionEnded";
		
		private var _contextDataRaw:String;
		private var _inAppDuration:Number;
		private var _totalDuration:Number;
		
		public function ADBMobileEvents($type:String,
										$contextDataRaw:String=null,
										$inAppDuration:Number=0,
										$totalDuration:Number=0
		):void
		{
			_contextDataRaw = $contextDataRaw;
			_inAppDuration = $inAppDuration;
			_totalDuration = $totalDuration;
			
			super($type, false, false);
		}
		
		public function get totalDuration():Number
		{
			return _totalDuration;
		}
		
		public function get inAppDuration():Number
		{
			return _inAppDuration;
		}
		
		public function get contextDataRaw():String
		{
			return _contextDataRaw;
		}
	}
	
}