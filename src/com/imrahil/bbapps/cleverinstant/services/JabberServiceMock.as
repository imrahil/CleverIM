/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.services
{
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    import com.imrahil.bbapps.cleverinstant.signals.ChatMessageReceivedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.ChatUserRosterLoadedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.UserLoggedSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    
    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.core.UnescapedJID;
    import org.igniterealtime.xiff.data.Message;
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    
    import qnx.ui.data.SectionDataProvider;

    public class JabberServiceMock implements IJabberService
    {
        /** NOTIFICATION SIGNALS */
        [Inject]
        public var chatUserRosterLoadedSignal:ChatUserRosterLoadedSignal;
        
        [Inject]
        public var chatMessageReceivedSignal:ChatMessageReceivedSignal;
        
        [Inject]
        public var userLoggedSignal:UserLoggedSignal;
        
        protected var _chatUserRoster:SectionDataProvider = new SectionDataProvider();
        
        private var logger:ILogger;
        
        /** Constructor */
        public function JabberServiceMock()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        
        public function connect(credentials:LoginCredentialsVO):void
        {
            logger.debug(": connect");
            
            var loginTimer:Timer = new Timer(1000, 1);
            loginTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLogin);
            loginTimer.start();

            var rosterTimer:Timer = new Timer(1000, 1);
            rosterTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onRosterLoaded);
            rosterTimer.start();
        }
        
        public function disconnect():void
        {
            logger.debug(": disconnect");
        }
        
        public function updatePresence(show:String, status:String):void
        {
            logger.debug(": updatePresence");
            
//            _roster.setPresence(show, status, 0);
        }
        
        public function send(message:Message):void
        {
            logger.debug(": send");

        }

        protected function onLogin(event:TimerEvent):void
        {
            logger.debug(": onLogin");
            
            var currentUser:RosterItemVO = new RosterItemVO(new UnescapedJID("testUser"));
            currentUser.displayName = "testUser";
            
            userLoggedSignal.dispatch(currentUser);
        }
        
        protected function onRosterLoaded(event:TimerEvent):void
        {
            logger.debug(": onRosterLoaded - mock");

            var s1:Object = new Object();
            s1.label = "General";
            _chatUserRoster.addItem(s1);

            for (var x:int = 0; x < 10; x++)
            {
                var chatUser:RosterItemVO = new RosterItemVO(new UnescapedJID("testUser" + x));
                chatUser.displayName = "testUser" + x;
                
                _chatUserRoster.addChildToItem(chatUser, s1);
            }

            chatUserRosterLoadedSignal.dispatch(_chatUserRoster);
        }
    }
}