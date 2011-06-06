/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view.components
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.text.TextFieldAutoSize;
    import flash.ui.Keyboard;
    
    import org.osflash.signals.Signal;
    
    import qnx.ui.text.KeyboardType;
    import qnx.ui.text.Label;
    import qnx.ui.text.ReturnKeyType;
    import qnx.ui.text.TextInput;
    
    public class LoginFormItem extends Sprite
    {
        public var enterKeySignal:Signal = new Signal();
        
        private var formItemLbl:Label;
        private var formItemTxt:TextInput;
        
        protected var _label:String;
        protected var _value:String;
        protected var _password:Boolean = false;
        protected var _keyboardType:String = KeyboardType.DEFAULT;
        protected var _returnKeyType:String = ReturnKeyType.NEXT;
        
        public function LoginFormItem(label:String, value:String, password:Boolean = false, 
                                      keyboardType:String = KeyboardType.DEFAULT, returnKeyType:String = ReturnKeyType.NEXT)
        {
            super();
            
            _label = label;
            _value = value;
            _password = password;
            _keyboardType = keyboardType;
            _returnKeyType = returnKeyType;
            
            addEventListener(Event.ADDED_TO_STAGE, view_addedToStage);
        }
        
        public function setFocus():void
        {
            if (stage)
            {
                stage.focus = formItemTxt;
            }
        }
            
        public function get value():String
        {
            return _value;
        }
        
        protected function view_addedToStage(event:Event):void
        {
            formItemLbl = new Label();
            formItemLbl.text = _label;
//            formItemLbl.autoSize = TextFieldAutoSize.NONE;
            formItemLbl.width = 105;
            
            formItemTxt = new TextInput();
            formItemTxt.text = _value;
            formItemTxt.width = 400;
            
            if (_password)
            {
                formItemTxt.displayAsPassword = true;
            }
            
            if (_keyboardType == KeyboardType.PIN)
            {
                formItemTxt.restrict = "0-9";
            }
            
            formItemTxt.keyboardType = _keyboardType;
            formItemTxt.returnKeyType = _returnKeyType;
            
            formItemTxt.addEventListener(Event.CHANGE, onValueChange);
            formItemTxt.addEventListener(KeyboardEvent.KEY_DOWN, onKeyBoardEvent);

            var padding:int = (this.stage.stageWidth - formItemTxt.width - formItemLbl.width - 20) / 2; 
            formItemLbl.x = padding;
            formItemTxt.x = formItemLbl.x + formItemLbl.width + 20;

            this.addChild(formItemLbl);
            this.addChild(formItemTxt);
        }
        
        protected function onValueChange(event:Event):void
        {
            _value = (event.currentTarget as TextInput).text;
        }
        
        protected function onKeyBoardEvent(event:KeyboardEvent):void
        {
            if (event.keyCode == Keyboard.ENTER)
            {
                enterKeySignal.dispatch();    
            }
        }
    }
}