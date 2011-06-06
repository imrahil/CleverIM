/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.view
{
    import com.imrahil.bbapps.cleverinstant.constants.ApplicationConstants;
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    import com.imrahil.bbapps.cleverinstant.view.components.LoginFormItem;
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    
    import mx.logging.ILogger;
    
    import org.osflash.signals.Signal;
    
    import qnx.ui.buttons.CheckBox;
    import qnx.ui.buttons.LabelButton;
    import qnx.ui.buttons.LabelPlacement;
    import qnx.ui.text.KeyboardType;
    import qnx.ui.text.Label;
    import qnx.ui.text.ReturnKeyType;
    
    public class LoginView extends Sprite
    {
        public var loginClicked:Signal = new Signal(LoginCredentialsVO);
        
        private var logger:ILogger;
        
        private var _usernameItem:LoginFormItem;
        private var _passwordItem:LoginFormItem;
        private var _serverItem:LoginFormItem;
        private var _serverPortItem:LoginFormItem;
        private var _rememberMe:CheckBox;

        public function LoginView()
        {
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
            
            this.addEventListener(Event.ADDED_TO_STAGE, view_addedToStage);
        }
        
        protected function view_addedToStage(event:Event):void
        {
            this.removeEventListener(Event.ADDED_TO_STAGE, view_addedToStage);

            initUI();
        }
        
        protected function initUI():void
        {
            logger.debug(": init");
            
            var posY:int = this.stage.stageHeight * 0.1;
            
            var loginTitleTextFormat:TextFormat = new TextFormat();
            loginTitleTextFormat.size = 25;
            
            var loginViewTitleLbl:Label = new Label();
            loginViewTitleLbl.format = loginTitleTextFormat;
            loginViewTitleLbl.text = "Login:";
            loginViewTitleLbl.x = (this.stage.stageWidth - loginViewTitleLbl.width) / 2; 
            loginViewTitleLbl.y = posY;
            loginViewTitleLbl.autoSize = TextFieldAutoSize.CENTER;
            addChild(loginViewTitleLbl);
        
            posY += 50;

            _usernameItem = new LoginFormItem("Username:", ApplicationConstants.TEST_USERNAME, false, KeyboardType.EMAIL);
            _usernameItem.enterKeySignal.add(jumpToPassword);
            _usernameItem.y = posY
            addChild(_usernameItem);
            
            posY += 50;

            _passwordItem = new LoginFormItem("Password:", ApplicationConstants.TEST_PASSWORD, true);
            _passwordItem.enterKeySignal.add(jumpToServer);
            _passwordItem.y = posY
            addChild(_passwordItem);
            
            posY += 50;

            _serverItem = new LoginFormItem("Server:", ApplicationConstants.TEST_SERVER, false, KeyboardType.URL);
            _serverItem.enterKeySignal.add(jumpToServerPort);
            _serverItem.y = posY
            addChild(_serverItem);
            
            posY += 50;

            _serverPortItem = new LoginFormItem("Server port:", ApplicationConstants.TEST_SERVER_PORT, false, KeyboardType.PIN, ReturnKeyType.CONNECT);
            _serverPortItem.enterKeySignal.add(connect);
            _serverPortItem.y = posY
            addChild(_serverPortItem);
            
            posY += 60;
            
            _rememberMe = new CheckBox();
            _rememberMe.width = 170;
            _rememberMe.label = "Remember me";
            _rememberMe.labelPlacement = LabelPlacement.RIGHT;
            _rememberMe.labelPadding = 5;
            _rememberMe.x = (this.stage.stageWidth - _rememberMe.width) / 2;
            _rememberMe.y = posY;
            addChild(_rememberMe);
            
            posY += 50;
            
            var loginBtn:LabelButton = new LabelButton();
            loginBtn.label = "Connect";
            loginBtn.x = (this.stage.stageWidth - loginBtn.width) / 2; 
            loginBtn.y = posY;
            loginBtn.addEventListener(MouseEvent.CLICK, onLoginClick);
            addChild(loginBtn);
        }
        
        protected function onLoginClick(event:MouseEvent):void
        {
            if (_usernameItem.value != "" && _passwordItem.value != "" &&
                _serverItem.value != "" && _serverPortItem.value != "")
            {
                var loginCredentials:LoginCredentialsVO = new LoginCredentialsVO();
                loginCredentials.username = _usernameItem.value;
                loginCredentials.password = _passwordItem.value; 
                loginCredentials.server = _serverItem.value; 
                loginCredentials.serverPort = parseInt(_serverPortItem.value);
                loginCredentials.rememberMe = _rememberMe.selected;
                
                loginClicked.dispatch(loginCredentials);
            }
        }
        
        private function jumpToPassword():void
        {
            _passwordItem.setFocus();
        }
        
        private function jumpToServer():void
        {
            _serverItem.setFocus();
        }

        private function jumpToServerPort():void
        {
            _serverPortItem.setFocus();
        }

        private function connect():void
        {
            onLoginClick(null);
        }
    }
}
