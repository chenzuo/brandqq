//AjaxResponse.js

var AjaxResponse=function(respText)
{
    this.Text=respText||"";
    this.Status="";
    this.Code="";
    this.Message="";
    this.Error=false;
    
    this.initialize();
};

AjaxResponse.prototype.initialize=function()
{
    var reg=/([a-z]*),(.*)/i;
    if(reg.test(this.Text))
    {
        this.Status=reg.exec(this.Text)[1].toUpperCase();
        this.Code=reg.exec(this.Text)[2];
        this.Message=reg.exec(this.Text)[3];
    }
    else
    {
        this.Error=true;
    }
    //alert(this.Text);
};