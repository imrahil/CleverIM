/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.model.vo
{
    import mx.collections.ArrayCollection;
    
    import org.igniterealtime.xiff.core.UnescapedJID;

    public class ChatRoomVO
    {
        public function ChatRoomVO()
        {
        }
        
        private var _displayName:String;
        private var _recipient:UnescapedJID;
        private var _messages:ArrayCollection = new ArrayCollection();
        
        public function get displayName():String
        {
            return _displayName;
        }

        public function set displayName(value:String):void
        {
            _displayName = value;
        }
        
        public function get label():String
        {
            return _displayName;
        }

        public function get recipient():UnescapedJID
        {
            return _recipient;
        }

        public function set recipient(value:UnescapedJID):void
        {
            _recipient = value;
        }

        public function get messages():ArrayCollection
        {
            return _messages;
        }

        public function set messages(value:ArrayCollection):void
        {
            _messages = value;
        }
    }
}