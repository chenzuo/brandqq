var sourcePath="file:///F|/BrandQQ/www/App_Data/logoData/categoryIcons/";
var destPath="file:///F|/BrandQQ/www/flexLib/Thumbnails/LogoCategories/";

var files=FLfile.listFolder(sourcePath,"files");

for(var i=0;i<files.length;i++)
{
	var expFile=files[i].replace(".swf",".png");
	
	var doc=fl.createDocument();
	doc.importSWF(sourcePath+files[i]);
	doc.selectAll();
	
	var oldWidth=doc.selection[0].width;
	var oldHeight=doc.selection[0].height;
	
	var scale=1;
	if(oldWidth>=110)
	{
		if(oldWidth>oldHeight)
		{
			scale=110/oldWidth;
		}
		else
		{
			scale=80/oldHeight;
		}		
	}
	else
	{
		if(oldWidth>oldHeight)
		{
			scale+=oldWidth/110;
		}
		else
		{
			scale+=oldHeight/80;
		}
	}

	doc.scaleSelection(scale,scale,"top left");
	doc.width=120;
	doc.height=90;
	doc.align("vertical center",true);
	doc.align("horizontal center",true);
	doc.exportPNG(destPath+expFile,true,true);
	doc.close(false);
}