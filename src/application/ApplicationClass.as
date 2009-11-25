package application
{	
	import com.collectivecolors.rpc.AMFAgent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.controls.List;
	import mx.core.Application;
	import mx.events.FlexEvent;
	import mx.events.ListEvent;


	public class ApplicationClass extends Application
	{


		/**
		 * MXML Components
		 **/
		 
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
			//Add Event Listeners
			lstBlogs.addEventListener(ListEvent.ITEM_CLICK, lstBlogsClickHandler);
			systemManager.addEventListener(MouseEvent.MOUSE_WHEEL, lstBlogsWheelHandler, true);
								
			var amfAgent:AMFAgent = new AMFAgent("views", null);
			amfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			
			var system:RemoteServices = new RemoteServices(amfAgent, null);
			system.viewGetHandlers(connectHandler, faultHandler);
			
			system.viewGet("recent_blog_entries");
		}


		/**
		 * Event Handlers
		 **/
		 public function lstBlogsClickHandler( event:ListEvent ):void{
		 	var url:String = "http://services6.collectivecolors.com/" + lstBlogs.selectedItem.path;
		 	navigateToURL(new URLRequest(url));
		 }
		 
		 public function lstBlogsWheelHandler( event:MouseEvent ):void{
		 	if(event.delta > 0){
		 		lstBlogs.validateNow();
		 		if(lstBlogs.verticalScrollPosition == 0){return;}
		 		lstBlogs.verticalScrollPosition = lstBlogs.verticalScrollPosition - 1;
		 	}
		 	else if(event.delta < 0){
		 		lstBlogs.validateNow();
		 		if(lstBlogs.verticalScrollPosition == lstBlogs.maxVerticalScrollPosition){return;}
		 		lstBlogs.verticalScrollPosition = lstBlogs.verticalScrollPosition + 1;
		 	}
		 }
		 
		public function connectHandler( result:Array ):void{
			lstBlogs.dataProvider = result;
		 }
		 
		 public function faultHandler( fault:Object ):void{
		 	Alert.show(String(fault));
		 }

		/**
		 * Methods
		 **/
	}
}