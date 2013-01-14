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
using System;
using System.IO;
using System.Xml;
using System.Text;
using System.Collections;

using SwfDotNet.IO.Utils;
using SwfDotNet.IO.Tags;

namespace SwfDotNet.IO.Tags 
{	
	/// <summary>
	/// EnableDebugger2Tag enables a movie to be debugged when played 
	/// using the Flash authoring tool, allowing the variables defined 
	/// in the arrays of actions specified in object to be inspected.
	/// </summary>
	/// <remarks>
	/// <p>
	/// In order to use the debugger a password must be supplied. 
	/// When encrypted using the MD5 algorithm it must match the value 
	/// stored in the password property.
	/// </p>
	/// <p>
	/// To encode a string with the MD5 encryption algorithm, you can use
	/// the EncryptPasswordToMD5 method of the EnableDebugger2Tag class.
	/// </p>
	/// <p>
	/// This tag was introduced in Flash 6. It replaced EnableDebuggerTag 
	/// in Flash 5 with a different format to support internal
	/// changes in the Flash Player. The functionality was not changed.
	/// </p>
	/// </remarks>
	public class EnableDebugger2Tag : BaseTag 
	{	
        #region Members

		private string password;
		
        #endregion

        #region Ctor

        /// <summary>
        /// Creates a new <see cref="EnableDebugger2Tag"/> instance.
        /// </summary>
        public EnableDebugger2Tag()
        {
            this._tagCode = (int)TagCodeEnum.EnableDebugger2;
        }

		/// <summary>
		/// Creates a new <see cref="EnableDebugger2Tag"/> instance.
		/// </summary>
		/// <param name="password">md5 encrypted password</param>
		public EnableDebugger2Tag(string password)
		{
			this.password = password;
			this._tagCode = (int)TagCodeEnum.EnableDebugger2;
		}

        #endregion

        #region Properties

        /// <summary>
        /// Gets or sets the password as string.
        /// This password is MD-5 encrypted.
        /// To set a password non-encrypted, use
        /// the <see cref="EncryptPasswordToMD5">EncryptPasswordToMD5</see>
        /// method.
        /// </summary>
        public string Password
        {
            get { return this.password;  }
            set { this.password = value; }
        }

        #endregion

        #region Methods

		/// <summary>
		/// Encrypts the password with MD5 algorithm.
		/// </summary>
		/// <param name="originalPassword">Original password.</param>
		public void EncryptPasswordToMD5(string originalPassword)
		{
			this.password = SimpleHash.ComputeHash(originalPassword, "MD5", null);
		}

        /// <summary>
        /// see <see cref="SwfDotNet.IO.Tags.BaseTag">base class</see>
        /// </summary>
        public override void ReadData(byte version, BufferedBinaryReader binaryReader)
        {
            RecordHeader rh = new RecordHeader();
            rh.ReadData(binaryReader);

            binaryReader.ReadByte();
            int lenght = System.Convert.ToInt32(rh.TagLength - 1);
            password = binaryReader.ReadString();
            //char[] password = br.ReadChars(lenght);
        }

		/// <summary>
		/// Gets the size of.
		/// </summary>
		/// <returns></returns>
		public int GetSizeOf()
		{
			int res = 2;
			if (password != null)
				res += this.Password.Length;
			return res;
		}
		
		/// <summary>
		/// see <see cref="SwfDotNet.IO.Tags.BaseTag">base class</see>
		/// </summary>
		public override void UpdateData(byte version) 
		{			
			if (version < 6)
				return;

			MemoryStream m = new MemoryStream();
			BufferedBinaryWriter w = new BufferedBinaryWriter(m);
			
			RecordHeader rh = new RecordHeader(TagCode, GetSizeOf());
			rh.WriteTo(w);
			
			w.Write((ushort)0);
			if (password != null)
				w.Write(this.Password);
			
            w.Flush();
			// write to data array
			_data = m.ToArray();
		}			

		/// <summary>
		/// Serializes the specified writer.
		/// </summary>
		/// <param name="writer">Writer.</param>
		public override void Serialize(XmlWriter writer)
		{
			writer.WriteStartElement("EnableDebugger2Tag");
			if (password != null)
				writer.WriteElementString("Password", password);
			writer.WriteEndElement();
		}

        #endregion
	}
}
