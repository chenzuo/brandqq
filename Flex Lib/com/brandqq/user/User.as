package com.brandqq.user
{
	/**
	 * 表示一个用户
	 * @author mickeydream@hotmail.com
	 * 
	 */	
	public class User
	{
		/**
		 * 从XML数据初始化一个用户实例
		 * @param _data
		 * 
		 */		
		public static function initCurrent(_data:XMLList):void
		{
			__currentUser=new User();
			__currentUser.__uid=uint(_data.Id);
			__currentUser.__guid=String(_data.Guid);
			__currentUser.__name=String(_data.Name);
			__currentUser.__email=String(_data.Email);
			__currentUser.__comName=String(_data.ComName);
			__currentUser.__comIndus=String(_data.ComIndus);
			__currentUser.__currentLogoGuid=String(_data.LogoGuid);
			__currentUser.__currentCardGuid=String(_data.CardGuid);
			__currentUser.__currentCardTempGuid=String(_data.CardTempGuid);
		}
		
		/**
		 * 获取用户的登录状态
		 * @return 
		 * 
		 */		
		public static function get loginStatus():Boolean
		{
			if(User.current==null)
			{
				return false;
			}
			
			if(User.current.uid>0)
			{
				return true;
			}
			
			return false;
		}
		
		/**
		 * 获取当前用户
		 * @return 
		 * 
		 */		
		public static function get current():User
		{
			return __currentUser;
		}
		public static function set current(value:User):void
		{
			__currentUser=value;
		}
		
		/**
		 * 获取当前用户的名称
		 * @return 
		 * 
		 */
		public static function get nameLabel():String
		{
			if(User.current==null)
			{
				return "";
			}
			
			if(User.current.comName!="")
			{
				return User.current.comName;
			}
			
			if(User.current.name!="")
			{
				return User.current.name;
			}
			return User.current.email;
		}
		
		
		/**
		 * 获取用户ID
		 * @return 
		 * 
		 */
		public function get uid():uint
		{
			return this.__uid;
		}
		public function set uid(value:uint):void
		{
			this.__uid=value;
		}
		
		/**
		 * 获取用户名字
		 * @return 
		 * 
		 */		
		public function get guid():String
		{
			return this.__guid;
		}
		public function set guid(value:String):void
		{
			this.__guid=value;
		}
		
		/**
		 * 获取用户名字
		 * @return 
		 * 
		 */		
		public function get name():String
		{
			return this.__name;
		}
		public function set name(value:String):void
		{
			this.__name=value;
		}
		
		/**
		 * 获取用户Email
		 * @return 
		 * 
		 */		
		public function get email():String
		{
			return this.__email;
		}
		public function set email(value:String):void
		{
			this.__email=value;
		}
		
		/**
		 * 获取用户企业名
		 * @return 
		 * 
		 */		
		public function get comName():String
		{
			return this.__comName;
		}
		public function set comName(value:String):void
		{
			this.__comName=value;
		}
		
		/**
		 * 获取用户企业所属行业代码
		 * @return 
		 * 
		 */		
		public function get comIndus():String
		{
			return this.__comIndus;
		}
		public function set comIndus(value:String):void
		{
			this.__comIndus=value;
		}
		
		/**
		 * 获取当前用户的当前Logo guid
		 * @return 
		 * 
		 */		
		public function get currentLogoGuid():String
		{
			return this.__currentLogoGuid;
		}
		/**
		 * 设置当前用户的当前Logo guid
		 * @param value
		 * 
		 */		
		public function set currentLogoGuid(value:String):void
		{
			this.__currentLogoGuid=value;
		}
		
		/**
		 * 获取当前用户的当前Card guid
		 * @return 
		 * 
		 */		
		public function get currentCardGuid():String
		{
			return this.__currentCardGuid;
		}
		/**
		 * 设置当前用户的当前Card guid
		 * @param value
		 * 
		 */		
		public function set currentCardGuid(value:String):void
		{
			this.__currentCardGuid=value;
		}


		/**
		 * 获取当前用户的当前CardTemp guid
		 * @return 
		 * 
		 */		
		public function get currentCardTempGuid():String
		{
			return this.__currentCardTempGuid;
		}
		/**
		 * 设置当前用户的当前CardTemp guid
		 * @param value
		 * 
		 */		
		public function set currentCardTempGuid(value:String):void
		{
			this.__currentCardTempGuid=value;
		}

		
		
		public function toString():String
		{
			var ret:String="";
			ret+="Id="+__uid;
			ret+="&Guid="+__guid;
			ret+="&Name="+__name;
			ret+="&Email="+__email;
			ret+="&ComName="+__comName;
			ret+="&ComIndus="+__comIndus;
			ret+="&LogoGuid="+__currentLogoGuid;
			ret+="&CardGuid="+__currentCardGuid;
			ret+="&CardTempGuid="+__currentCardTempGuid;
			return ret;
		}
		
		private var __uid:uint=0x0;
		private var __guid:String="";
		private var __name:String="";
		private var __email:String="";
		
		private var __comName:String="";
		private var __comIndus:String="";
		
		private var __currentLogoGuid:String="";
		private var __currentCardGuid:String="";
		private var __currentCardTempGuid:String="";
		
		private static var __currentUser:User;
		
	}
}