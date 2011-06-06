/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.services
{
    import com.hurlant.crypto.tls.TLSConfig;
    import com.hurlant.crypto.tls.TLSEngine;
    import com.imrahil.bbapps.cleverinstant.model.vo.LoginCredentialsVO;
    import com.imrahil.bbapps.cleverinstant.signals.ChatMessageReceivedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.ChatUserRosterLoadedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.SaveLoginDetailsSignal;
    import com.imrahil.bbapps.cleverinstant.signals.UserLoggedSignal;
    import com.imrahil.bbapps.cleverinstant.utils.CustomRoster;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import flash.events.TimerEvent;
    import flash.system.Security;
    import flash.utils.Timer;
    
    import mx.events.CollectionEvent;
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.core.XMPPConnection;
    import org.igniterealtime.xiff.core.XMPPTLSConnection;
    import org.igniterealtime.xiff.data.Message;
    import org.igniterealtime.xiff.data.Presence;
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.igniterealtime.xiff.events.*;
    import org.robotlegs.mvcs.Actor;

    public class JabberService extends Actor implements IJabberService
    {
        /** NOTIFICATION SIGNALS */
        [Inject]
        public var chatUserRosterLoadedSignal:ChatUserRosterLoadedSignal;

        [Inject]
        public var chatMessageReceivedSignal:ChatMessageReceivedSignal;

        [Inject]
        public var userLoggedSignal:UserLoggedSignal;

        [Inject]
        public var saveLoginDetailsSignal:SaveLoginDetailsSignal;

        
        protected var streamType:uint = XMPPConnection.STREAM_TYPE_STANDARD;
        private const KEEP_ALIVE_TIME:int = 30000;

        protected var _keepAliveTimer:Timer;

        protected var _connection:XMPPTLSConnection;
        protected var _roster:CustomRoster;
        
        private var logger:ILogger;
        
        private var rosterLoaded:Boolean = false;
        private var credentials:LoginCredentialsVO;
        

        /** Constructor */
        public function JabberService()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
            
            setupConnection();
            setupRoster();
            setupTimer();
        }
        
        /**
         * PUBLIC METHODS 
         */
        
        public function connect(credentials:LoginCredentialsVO):void
        {
            logger.debug(": connect");
            
            this.credentials = credentials;
            
            var domainIndex:int = credentials.username.lastIndexOf("@");
            var username:String = domainIndex > -1 ? credentials.username.substring(0, domainIndex) : credentials.username;
            var domain:String = domainIndex > -1 ? credentials.username.substring(domainIndex + 1) : null;
            
            Security.loadPolicyFile("xmlsocket://" + credentials.server + ":" + credentials.serverPort);
            _connection.username = username;
            _connection.password = credentials.password;
            _connection.domain = domain;
            _connection.server = credentials.server;
            _connection.port = credentials.serverPort;
            _connection.connect(streamType);
        }
        
        public function disconnect():void
        {
            logger.debug(": disconnect");
            
            _connection.disconnect();
            
            _roster.removeAll();
        }
        
        public function updatePresence(show:String, status:String):void
        {
            logger.debug(": updatePresence");
            
            _roster.setPresence(show, status, 0);
        }
        
        public function send(message:Message):void
        {
            logger.debug(": send");

            _connection.send(message);
        }
        

        /**
         * PRIVATE METHODS 
         */
        protected function setupConnection():void
        {
            logger.debug(": setupConnection");
            
            var config:TLSConfig = new TLSConfig(TLSEngine.CLIENT);
            config.ignoreCommonNameMismatch = true;
            
            _connection = new XMPPTLSConnection();
            _connection.config = config;
            
            _connection.addEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectSuccess);
            _connection.addEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
            _connection.addEventListener(LoginEvent.LOGIN, onLogin);
            _connection.addEventListener(XIFFErrorEvent.XIFF_ERROR, onXIFFError);
            _connection.addEventListener(OutgoingDataEvent.OUTGOING_DATA, onOutgoingData)
            _connection.addEventListener(IncomingDataEvent.INCOMING_DATA, onIncomingData);
            _connection.addEventListener(PresenceEvent.PRESENCE, onPresence);
            _connection.addEventListener(MessageEvent.MESSAGE, onMessage);
        }

        protected function removeConnectionListeners():void
        {
            logger.debug(": removeConnectionListeners");
            
            _connection.removeEventListener(ConnectionSuccessEvent.CONNECT_SUCCESS, onConnectSuccess);
            _connection.removeEventListener(DisconnectionEvent.DISCONNECT, onDisconnect);
            _connection.removeEventListener(LoginEvent.LOGIN, onLogin);
            _connection.removeEventListener(XIFFErrorEvent.XIFF_ERROR, onXIFFError);
            _connection.removeEventListener(OutgoingDataEvent.OUTGOING_DATA, onOutgoingData)
            _connection.removeEventListener(IncomingDataEvent.INCOMING_DATA, onIncomingData);
            _connection.removeEventListener(PresenceEvent.PRESENCE, onPresence);
            _connection.removeEventListener(MessageEvent.MESSAGE, onMessage);
        }
        
        protected function setupRoster():void
        {
            logger.debug(": setupRoster");
            
            _roster = new CustomRoster();
            _roster.addEventListener(RosterEvent.ROSTER_LOADED, onRosterLoaded);
            _roster.addEventListener(RosterEvent.SUBSCRIPTION_DENIAL, onSubscriptionDenial);
            _roster.addEventListener(RosterEvent.SUBSCRIPTION_REQUEST, onSubscriptionRequest);
            _roster.addEventListener(RosterEvent.SUBSCRIPTION_REVOCATION, onSubscriptionRevocation);
            _roster.addEventListener(RosterEvent.USER_ADDED, onUserAdded);
            _roster.addEventListener(RosterEvent.USER_AVAILABLE, onUserAvailable);
            _roster.addEventListener(RosterEvent.USER_PRESENCE_UPDATED, onUserPresenceUpdated);
            _roster.addEventListener(RosterEvent.USER_REMOVED, onUserRemoved);
            _roster.addEventListener(RosterEvent.USER_SUBSCRIPTION_UPDATED, onUserSubscriptionUpdated);
            _roster.addEventListener(RosterEvent.USER_UNAVAILABLE, onUserUnavailable);
            _roster.addEventListener(CollectionEvent.COLLECTION_CHANGE, onRosterChange);
            _roster.connection = _connection;
        }

        /**
         * Remove connection listeners. Setup current user. Clean up roster and timer 
         */
        protected function cleanup():void
        {
            logger.debug(": cleanup");
            
            removeConnectionListeners();
            
            _keepAliveTimer.stop();
        }
        
        protected function setupTimer():void
        {
            logger.debug(": setupTimer");
            
            _keepAliveTimer = new Timer(KEEP_ALIVE_TIME);
            _keepAliveTimer.addEventListener(TimerEvent.TIMER, onKeepAliveTimer);
        }
     
        protected function updateChatUserRoster():void
        {
            logger.debug(": updateChatUserRoster - " + _roster.source.length);

            chatUserRosterLoadedSignal.dispatch(_roster);
        }
        
        private function myBooleanCompare(a:Object, b:Object, fields:Array = null):int
        {
            var aOnline:Boolean = (a as RosterItemVO).online;
            var bOnline:Boolean = (b as RosterItemVO).online;
            
            if(aOnline && !bOnline) 
            {
                return -1;
            } 
            else if(!aOnline && bOnline) 
            {
                return 1;
            } 
            else  
            {
                return 0;
            } 
        }
        
        /**
         * CONNECTION LISTENER HANDLERS  
         */

        protected function onConnectSuccess(event:ConnectionSuccessEvent):void
        {
            logger.debug(": onConnectSuccess");
            
//            dispatchEvent(event);
        }
        
        protected function onDisconnect(event:DisconnectionEvent):void
        {
            logger.debug(": onDisconnect");
            
            cleanup();
            
            setupConnection();
            _roster.connection = _connection;
            
//            dispatchEvent(event);
        }
        
        protected function onLogin(event:LoginEvent):void
        {
            logger.debug(": onLogin");
            
            var currentUser:RosterItemVO = new RosterItemVO(_connection.jid);
//            currentUser.loadVCard(_connection);
            
            _keepAliveTimer.start();
            
            userLoggedSignal.dispatch(currentUser);
            
            if (credentials.rememberMe)
            {
                saveLoginDetailsSignal.dispatch(credentials);
            }
        }
        
        protected function onXIFFError(event:XIFFErrorEvent):void
        {
            logger.debug(": onXIFFError");
            
//            dispatchEvent(event);
        }
        
        protected function onOutgoingData(event:OutgoingDataEvent):void
        {
            logger.debug(": onOutgoingData -> " + event.data.toString());
            
//            dispatchEvent(event);
        }
        
        protected function onIncomingData(event:IncomingDataEvent):void
        {
            logger.debug(": onIncomingData -> " + event.data.toString());
            
//            dispatchEvent(event);
        }
        
        protected function onPresence(event:PresenceEvent):void
        {
            logger.debug(": onPresence");
            
            var presence:Presence = event.data[0] as Presence;
            
            if(presence.type == Presence.TYPE_ERROR)
            {
                var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
                xiffErrorEvent.errorCode = presence.errorCode;
                xiffErrorEvent.errorCondition = presence.errorCondition;
                xiffErrorEvent.errorMessage = presence.errorMessage;
                xiffErrorEvent.errorType = presence.errorType;
                
                onXIFFError(xiffErrorEvent);
            }
            else
            {
//                dispatchEvent(event);
            }
        }
        
        protected function onMessage(event:MessageEvent):void
        {
            logger.debug(": onMessage");
            
            var message:Message = event.data as Message;

            if(message.type == Message.TYPE_ERROR)
            {
                var xiffErrorEvent:XIFFErrorEvent = new XIFFErrorEvent();
                xiffErrorEvent.errorCode = message.errorCode;
                xiffErrorEvent.errorCondition = message.errorCondition;
                xiffErrorEvent.errorMessage = message.errorMessage;
                xiffErrorEvent.errorType = message.errorType;
                
                onXIFFError(xiffErrorEvent);
            }
            else if (message.type == Message.TYPE_CHAT && message.body != null)
            {
                logger.debug(": body - " + message.body);
                logger.debug(": state - " + message.state);

                chatMessageReceivedSignal.dispatch(message.from, message.body);
            }
        }

        /**
         * ROSTER LISTENER HANDLERS  
         */
        
        protected function onRosterLoaded(event:RosterEvent):void
        {
            logger.debug(": onRosterLoaded");
            
            updateChatUserRoster();
            
            rosterLoaded = true;
        }
        
        protected function onSubscriptionDenial(event:RosterEvent):void
        {
            logger.debug(": onSubscriptionRequest");
            
//            dispatchEvent(event);
        }
        
        protected function onSubscriptionRequest(event:RosterEvent):void
        {
            logger.debug(": onSubscriptionRequest");
            
//            if(_roster.contains(RosterItemVO.get(event.jid, false)))
//            {
//                _roster.grantSubscription(event.jid, true);
//            }
//            
//            dispatchEvent(event);
        }
        
        protected function onSubscriptionRevocation(event:RosterEvent):void
        {
            logger.debug(": onSubscriptionRevocation");
            
//            dispatchEvent(event);
        }
        
        protected function onUserAdded(event:RosterEvent):void
        {
            logger.debug(": onUserAdded");
            
//            dispatchEvent(event);
        }
        
        protected function onUserAvailable(event:RosterEvent):void
        {
            logger.debug(": onUserAvailable");
            
//            dispatchEvent(event);
        }
        
        protected function onUserPresenceUpdated(event:RosterEvent):void
        {
            logger.debug(": onUserPresenceUpdated");
            
//            dispatchEvent(event);
        }
        
        protected function onUserRemoved(event:RosterEvent):void
        {
            logger.debug(": onUserRemoved");
            
//            dispatchEvent(event);
        }
        
        protected function onUserSubscriptionUpdated(event:RosterEvent):void
        {
            logger.debug(": onUserSubscriptionUpdated");
            
//            dispatchEvent(event);
        }
        
        protected function onUserUnavailable(event:RosterEvent):void
        {
            logger.debug(": onUserUnavailable");
            
//            dispatchEvent(event);
        }
        
        protected function onRosterChange(event:CollectionEvent):void
        {
            logger.debug(": onRosterChange");
            
            if (rosterLoaded)
            {
//                rosterLoaded = false;
                updateChatUserRoster();
            }
        }
        
        protected function onKeepAliveTimer(event:TimerEvent):void
        {
            if(_connection.isLoggedIn())
            {
                _connection.sendKeepAlive();
            }
        }
    }
}
