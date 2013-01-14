var doc=fl.getDocumentDOM();
doc.selectAll();
var oldWidth=doc.selection[0].width;
	var oldHeight=doc.selection[0].height;
	if(oldWidth>=oldHeight)
	{
		doc.selection[0].width=110;
		doc.selection[0].height=oldHeight*110/oldWidth;
	}
	else
	{
		doc.selection[0].height=80;
		doc.selection[0].width=oldWidth*80/oldHeight;
	}
doc.width=120;
doc.height=90;
doc.align("vertical center",true);
doc.align("horizontal center",true);
