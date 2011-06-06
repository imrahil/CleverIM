/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package 
{
    import com.imrahil.bbapps.cleverinstant.CleverIMContext;
    import com.imrahil.bbapps.cleverinstant.view.MainAppNavigator;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    
    import mx.logging.Log;
    import mx.logging.LogEventLevel;
    import mx.logging.targets.TraceTarget;
    
    [SWF(width="1024", height="600", frameRate="30", backgroundColor="#FFFFFF")] 
    public class CleverIM extends Sprite 
    {
        /**
         * CONTEXT
         */
        private var _context:CleverIMContext = new CleverIMContext(this as DisplayObjectContainer);
        public function get context():CleverIMContext { return _context; }
        
        public function CleverIM():void 
        {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void 
        {
            var logTarget:TraceTarget = new TraceTarget();
            logTarget.level = LogEventLevel.DEBUG;
            logTarget.includeDate = true;
            logTarget.includeTime = true;
            logTarget.includeCategory = true;
            logTarget.includeLevel = true;
            Log.addTarget(logTarget);
            
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            // MAIN APP NAVIGATOR
            var mainAppNavigator:MainAppNavigator = new MainAppNavigator();
            addChild(mainAppNavigator);
        }
    }
}
