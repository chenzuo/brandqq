<%@ Page Language="c#" %>

<%@ Import Namespace="Swf" %>

<script runat="server">

    protected void Page_Load(object sender, EventArgs e)
    {
        /*StreamReader reader = new StreamReader(@"F:\mails\ALL080311.txt");
        string mail;

        StringBuilder mails = new StringBuilder();

        ArrayList mailList = new ArrayList();
        
        while (!String.IsNullOrEmpty(mail=reader.ReadLine()))
        {
            string email = mail.Trim().ToLower();
            if (Utility.IsEmail(email) && email.IndexOf("@foresight.net.cn") == -1 && !mailList.Contains(email))
            {
                mailList.Add(email);
            }
        }
        reader.Close();

        mailList.Sort();

        foreach (string s in mailList)
        {
            mails.AppendLine(s);
        }

        File.WriteAllText(@"F:\mails\ALL_Filter.txt", mails.ToString());
        long days = Utility.DateDiff(DateTimeInterval.Month, DateTime.Now, new DateTime(2008,5,20));
        Response.Write(days);*/

/*
        GraphicsPath path = new GraphicsPath();
        StringFormat sf = StringFormat.GenericDefault;
        sf.Alignment = StringAlignment.Near;
        sf.FormatFlags = StringFormatFlags.NoWrap | StringFormatFlags.LineLimit;
        sf.LineAlignment = StringAlignment.Near;
        sf.Trimming = StringTrimming.None;

        FontFamily ff = new FontFamily("方正平和简体");
        path.AddString("永渊", ff, (int)FontStyle.Regular, 50, new Point(0, 0), sf);

        System.Drawing.Image img = Bitmap.FromFile(@"F:\BrandQQ\www\test\1.png");
        Graphics g = Graphics.FromImage(img);

        g.FillPath(Brushes.Blue,path);

        img.Save(@"F:\BrandQQ\www\test\2.png");

        for (int i = 0; i < path.PointCount; i++)
        {
            Response.Write(((int)path.PathTypes[i]).ToString() + "," + ((PathPointType)path.PathTypes[i]).ToString() +" ("+path.PathPoints[i].ToString()+")<br/>");
        }*/

        //GraphicsPathIterator pi = new GraphicsPathIterator(path);
        //Response.Write(pi.SubpathCount);

        SWFFont f = new SWFFont("test/arial.fdb");
        SWFText t = new SWFText();
        t.setFont(f);
        t.setColor(0xff, 0xff, 0);
        t.setHeight(60);
        t.addString("MonoHispano!");

        SWFMovie m = new SWFMovie();
        m.setDimension(320, 240);

        SWFDisplayItem i = m.add(t);
        i.moveTo(160 - t.getWidth("MonoHispano!") / 2, 120 + f.getAscent() / 2);

        //header('Content-type: application/x-shockwave-flash');
        //m.output();  */
        m.save(@"F:\BrandQQ\www\test\text.swf");
        
    }
</script>

