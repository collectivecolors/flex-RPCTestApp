package application
{
	import com.collectivecolors.rpc.AMFAgent;
	
	import flash.events.Event;
	
	import mx.controls.Button;
	import mx.controls.List;
	import mx.core.Application;
	import mx.events.FlexEvent;


	public class ApplicationClass extends Application
	{


		/**
		 * MXML Components
		 **/
		 
		 public var btnRequest:Button;
		 public var lstBlogs:List;
		 

		/**
		 * Variables
		 **/


		/**
		 * Constructor And Creation Complete Handler
		 **/

		public function ApplicationClass()
		{
			addEventListener(FlexEvent.CREATION_COMPLETE, creationCompleteHandler);
		}


		public function creationCompleteHandler(value:Event):void
		{
			var test:AMFAgent = new AMFAgent( "http://services6.collectivecolors.com/services/amfphp", faultHandler );
		}


		/**
		 * Event Handlers
		 **/


		/**
		 * Methods
		 **/
		 
		 public function faultHandler( fault:Error ):void{
		 	
		 }
		 
	}
}