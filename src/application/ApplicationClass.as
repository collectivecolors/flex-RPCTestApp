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
							
			//Create instance of AMFAgent	
			var amfAgent:AMFAgent = new AMFAgent("views", null);
			//Set the URL to the Drupal Services Module we mean to connect with
			amfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			//Create instance of ViewsServices, and give it a reference to the above AMFAgent
			var system:ViewsServices = new ViewsServices(amfAgent, null);
			//Set the event handlers for the ViewsServices class
			system.viewGetHandlers(connectHandler, faultHandler);
			//Retrieve blog entries
			system.viewGet("recent_blog_entries");
		}


		/**
		 * Event Handlers
		 **/
		 
		 //If the user clicks on a blog take them to that blog
		 public function lstBlogsClickHandler( event:ListEvent ):void{
		 	var url:String = "http://services6.collectivecolors.com/" + lstBlogs.selectedItem.path;
		 	navigateToURL(new URLRequest(url));
		 }
		 
		 //Allows mouse wheel scrolling
		 public function lstBlogsWheelHandler( event:MouseEvent ):void{
		 	if(event.delta > 0){
		 		lstBlogs.validateNow();
		 		//If the scroll position is already at the minimum, do nothing
		 		if(lstBlogs.verticalScrollPosition == 0){return;}
		 		//Move the scroll position down
		 		lstBlogs.verticalScrollPosition = lstBlogs.verticalScrollPosition - 1;
		 	}
		 	else if(event.delta < 0){
		 		lstBlogs.validateNow();
		 		//If the scroll position is already at the maximum, do nothing
		 		if(lstBlogs.verticalScrollPosition == lstBlogs.maxVerticalScrollPosition){return;}
		 		//Move the scroll position up
		 		lstBlogs.verticalScrollPosition = lstBlogs.verticalScrollPosition + 1;
		 	}
		 }
		
		public function connectHandler( result:Array ):void{
			//Set the list's data provider to the latest results
			lstBlogs.dataProvider = result;
		 }
		 
		 public function faultHandler( fault:Object ):void{
		 	Alert.show(String(fault));
		 }
	}
}