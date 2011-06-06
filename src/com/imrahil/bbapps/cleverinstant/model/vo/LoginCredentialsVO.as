/*
Copyright (c) 2011 Imrahil Corporation, All Rights Reserved 
@author   Jarek Szczepanski
@contact  imrahil@imrahil.com
@project  CleverIM
@internal 
*/
package com.imrahil.bbapps.cleverinstant.model.vo
{
	public class LoginCredentialsVO
	{
		public var username:String;
		public var password:String;
        public var server:String;
        public var serverPort:int;
        public var rememberMe:Boolean;
		
		public function LoginCredentialsVO()
		{
		}
	}
}
