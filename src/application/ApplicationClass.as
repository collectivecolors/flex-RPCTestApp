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
		 public var lstTerms:List;

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
			
			retrieveBlogTerms();
			
			/**
			 * INERT CODE
			 * 
			 * One day, this code may do something. Quite possibly something of vital importance. 
			 * But that day is not today, and until that day, when this code is finally allowed 
			 * to fulfill its purpose it will remain unused and unnoticed, but never forgotten.
			
			//Create instance of AMFAgent with the "user" source
			var userAmfAgent:AMFAgent = new AMFAgent("user", null);
			//Set the URL to the Drupal Services Module we mean to connect with
			userAmfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			//Create instance of UserServices, and give it a reference to the above AMFAgent
			var user:UserServices = new UserServices(userAmfAgent, null);
			//Set the event handlers for the ViewsServices class
			user.userGetHandlers(userConnectHandler, faultHandler);			
			*/
		}


		/**
		 * Event Handlers
		 **/
		 
		 //If the user clicks on a blog take them to that blog
		 public function lstBlogsClickHandler( event:ListEvent ):void{
		 	var url:String = "http://services6.collectivecolors.com/" + lstBlogs.selectedItem.path;
		 	navigateToURL(new URLRequest(url));
		 }
		 
		 //Allows mouse wheel scrolling as long as the user is focused anywhere in the application
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
		
		public function viewsTermConnectHandler( result:Array ):void{
			//Set the list's data provider to the latest results
			lstTerms.dataProvider = result;
		 }
		
		public function viewsBlogConnectHandler( result:Array ):void{
			//Set the list's data provider to the latest results
			lstBlogs.dataProvider = result;
		 }
		 
		 public function userConnectHandler( result:String ):void{
		 	Alert.show(result);
		 }
		 
		 public function faultHandler( fault:Object ):void{
		 	Alert.show(String(fault));
		 }
		 
		 /**
		 * Methods
		 **/
		 
		 public function retrieveBlogTerms():void{
		 	//Create instance of AMFAgent with the "views" source
			var viewsAmfAgent:AMFAgent = new AMFAgent("views", null);
			//Set the URL to the Drupal Services Module we mean to connect with
			viewsAmfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			//Create instance of ViewsServices, and give it a reference to the above AMFAgent
			var views:ViewsServices = new ViewsServices(viewsAmfAgent, null);
			//Set the event handlers for the ViewsServices class
			views.viewGetHandlers(viewsTermConnectHandler, faultHandler);
			//Retrieve blog entries
			views.viewGet("popular_blog_terms");
		 }
		 
		 public function retrieveBlogs(term:String = null):void{
		 	//Create instance of AMFAgent with the "views" source
			var viewsAmfAgent:AMFAgent = new AMFAgent("views", null);
			//Set the URL to the Drupal Services Module we mean to connect with
			viewsAmfAgent.addChannel("http://services6.collectivecolors.com/services/amfphp");
			//Create instance of ViewsServices, and give it a reference to the above AMFAgent
			var views:ViewsServices = new ViewsServices(viewsAmfAgent, null);
			//Set the event handlers for the ViewsServices class
			views.viewGetHandlers(viewsBlogConnectHandler, faultHandler);
			//Retrieve blog entries
			views.viewGet("recent_blog_entries");
		 }
	}
}