﻿/*
	SwfDotNet is an open source library for writing and reading 
	Macromedia Flash (SWF) bytecode.
	Copyright (C) 2005 Olivier Carpentier - Adelina foundation
	see Licence.cs for GPL full text!
		
	SwfDotNet.IO uses a part of the open source library SwfOp actionscript 
	byte code management, writted by Florian Krüsch, Copyright (C) 2004 .
	
	This library is free software; you can redistribute it and/or
	modify it under the terms of the GNU General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.
	
	This library is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.
	
	You should have received a copy of the GNU General Public
	License along with this library; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*/

using System.IO;
using System;

namespace SwfDotNet.IO.ByteCode.Actions
{		
	/// <summary>
	/// pseudo/helper action for aggregating a whole list of actions into one action.
	/// </summary>
	public class ActionContainer : BaseAction {

		private BaseAction[] actionList;
		private int byteCount;
		private int popCount;
		private int pushCount;

		/// <summary>constructor</summary> 
		public ActionContainer(BaseAction[] aList) : base(ActionCode.Container) {
			actionList = aList;
			byteCount = 0;
			pushCount = 0;
			popCount = 0;
			foreach (BaseAction a in aList) {
				byteCount+=a.ByteCount;
				pushCount+=a.PushCount;
				popCount+=a.PopCount;
			}
		}
		
		/// <summary>list of contained actions</summary>
		public BaseAction[] ActionList {
			get {
				return actionList;
			}
		}

		/// <see cref="SwfDotNet.IO.ByteCode.Actions.BaseAction.ByteCount"/>
		public override int ByteCount {
			get {
				return byteCount;
			}
		}

		/// <see cref="SwfDotNet.IO.ByteCode.Actions.BaseAction.PushCount"/>
		public override int PushCount {
			get {
				return pushCount;
			}
			set {

			}
		}
		
		/// <see cref="SwfDotNet.IO.ByteCode.Actions.BaseAction.PopCount"/>
		public override int PopCount {
			get {
				return popCount;
			}
			set {

			}
		}
		
		/// <see cref="SwfDotNet.IO.ByteCode.Actions.BaseAction.Compile"/>
		public override void Compile(BinaryWriter w) {
			for (int i=0; i<actionList.Length; i++) {
				BaseAction action = (BaseAction)actionList[i];
				action.Compile(w);
			}
		}
	}
}
