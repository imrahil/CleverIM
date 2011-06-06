/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.model
{
    import com.imrahil.bbapps.cleverinstant.model.vo.ChatRoomVO;
    import com.imrahil.bbapps.cleverinstant.model.vo.MessageItemVO;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.ChatRoomChangedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.ChatUserRosterChangedSignal;
    import com.imrahil.bbapps.cleverinstant.signals.signaltons.DisplayMessagesSignal;
    import com.imrahil.bbapps.cleverinstant.utils.LogUtil;
    
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    import mx.logging.ILogger;
    
    import org.igniterealtime.xiff.data.im.RosterItemVO;
    import org.robotlegs.mvcs.*;
    
    import qnx.ui.data.SectionDataProvider;

    public class CleverModel extends Actor 
    {
        /**
         * INJECT
         */
        [Inject]
        public var chatUserRosterChanged:ChatUserRosterChangedSignal;
        
        [Inject]
        public var chatRoomChanged:ChatRoomChangedSignal;
        
        [Inject]
        public var displayMessages:DisplayMessagesSignal;
        
        /** variables **/
        
        private var _chatUserRoster:SectionDataProvider;
        private var _fullChatUserRoster:SectionDataProvider;
        private var _currentUser:RosterItemVO;
        private var _currentChat:ChatRoomVO;
        private var _chatRoomList:ArrayCollection = new ArrayCollection();
        private var _chatRooms:Dictionary = new Dictionary();
        
        private var _displayOnlineOnly:Boolean = false;
        
        private var logger:ILogger;
        
        /** 
         * CONSTRUCTOR 
         */		
        public function CleverModel()
        {
            super();
            
            logger = LogUtil.getLogger(this);
            logger.debug(": constructor");
        }
        
        /**
         * Roster list
         */
        public function get chatUserRoster():SectionDataProvider 
        {
            return _chatUserRoster;
        }
        
        public function set chatUserRoster(value:SectionDataProvider):void 
        {
            logger.debug(": set chatUserRoster");
            
            _chatUserRoster = value;
            
            if(value)
            {
                chatUserRosterChanged.dispatch(_chatUserRoster);
            }
        }

        /**
         * Full, non-filtered roster list
         */
        public function get fullChatUserRoster():SectionDataProvider
        {
            return _fullChatUserRoster;
        }
        
        public function set fullChatUserRoster(value:SectionDataProvider):void
        {
            _fullChatUserRoster = value;
        }
        
        /**
         * Current user 
         */
        public function get currentUser():RosterItemVO
        {
            return _currentUser;
        }

        public function set currentUser(value:RosterItemVO):void
        {
            logger.debug(": set currentUser");

            _currentUser = value;
        }

        /**
         * Current ChatRoom 
         * @return 
         * 
         */
        public function get currentChat():ChatRoomVO
        {
            return _currentChat;
        }

        public function set currentChat(value:ChatRoomVO):void
        {
            _currentChat = value;

            chatRoomChanged.dispatch(_currentChat);
        }

        /**
         * Chat room list for dropdown 
         */
        public function get chatRoomList():ArrayCollection
        {
            return _chatRoomList;
        }
        
        public function set chatRoomList(value:ArrayCollection):void
        {
            _chatRoomList = value;
        }
        
        /**
         * Chat rooms - dictionary with ChatRooms 
         * @return 
         * 
         */
        public function get chatRooms():Dictionary
        {
            return _chatRooms;
        }
        
        public function set chatRooms(value:Dictionary):void
        {
            _chatRooms = value;
        }
        
        public function addMessageToCurrentChatRoom(message:MessageItemVO):void
        {
            currentChat.messages.addItem(message);
            displayMessages.dispatch(currentChat.messages);
        }

        /**
         * Boolean flag to filter roster list 
         */
        public function get displayOnlineOnly():Boolean
        {
            return _displayOnlineOnly;
        }

        public function set displayOnlineOnly(value:Boolean):void
        {
            _displayOnlineOnly = value;
        }
    }
}
