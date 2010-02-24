package application.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;

	import mx.controls.TextArea;

	public class CustomTextArea extends TextArea
	{
		public function CustomTextArea()
		{
			super();
		}

		override protected function createChildren():void
		{
			super.createChildren();
			//Prevent the text area from intercepting mouse scroll events
			removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			//Prevent the underlying text field from scrolling
			textField.mouseWheelEnabled = false;
		}
	}
}