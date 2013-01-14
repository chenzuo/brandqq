// functions.js
/**
	BMCE部分的客户端功能函数
*/

//删除未发布的新问卷
//id:问卷记录号
function deleteNewPaper(id,objBtn)
{
	if(confirm("删除（未发布的）问卷的同时将删除其包含的结论记录！\n确定删除吗？"))
	{
		if(objBtn)
		{
			objBtn.value="稍候...";
		}
		var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=deleteNewPaper&param="+id,function(requestObj){
			if(requestObj.status==200)
			{
				var ajaxResponse=new AjaxResponse(requestObj.responseText);
				if(ajaxResponse.Status=="OK")
				{
					if(objBtn)
					{
						location="newPapers.aspx";
					}
					else
					{
						var oParent=document.getElementById("PAPER_"+id);
						oParent.parentNode.removeChild(oParent);
					}
				}
			}
		});
		ajaxRequest.Get();
	}
}

function updatePaperFileCalcMethod(obj)
{
    obj.disabled=true;
    var sn=document.getElementById("PaperSN").innerHTML;
    var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=updatePaperFileCalcMethod&sn="+sn+"&param="+obj.options[obj.selectedIndex].value,function(requestObj){
	    if(requestObj.status==200)
	    {
	        obj.disabled=false;
	    }
    });
    ajaxRequest.Get();
}

///发布问卷
function publishPaperFile(psn,obj)
{
    obj.disabled=true;
    obj.value="稍候...";
    var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=publishPaperFile&sn="+psn,function(requestObj){
	    if(requestObj.status==200)
	    {
	        location='publishedPapers.aspx';
	    }
    });
    ajaxRequest.Get();
}

function deleteEditingPaperFile(psn)
{
    if(confirm("这并不会删除数据库中的问卷，确定删除该问卷吗？"))
    {        
        var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=removeEditingPaperFile&param="+psn,function(requestObj){
		    if(requestObj.status==200)
		    {
			    var oParent=document.getElementById("PAPER_"+psn);
				oParent.parentNode.removeChild(oParent);
		    }
	    });
	    ajaxRequest.Get();
    }
}

function deleteConsulsion(id,objBtn)
{
	if(confirm("确定删除该结论吗？"))
	{
		if(objBtn)
		{
			objBtn.value="稍候...";
		}
		var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=deleteConsulsion&param="+id,function(requestObj){
			if(requestObj.status==200)
			{
				var ajaxResponse=new AjaxResponse(requestObj.responseText);
				if(ajaxResponse.Status=="OK")
				{
					if(objBtn)
					{
						location="consulsions.aspx";
					}
					else
					{
						var oParent=document.getElementById("CONSULSION_"+id);
						oParent.parentNode.removeChild(oParent);
					}
				}
			}
		});
		ajaxRequest.Get();
	}
}

function deleteModule(id,objBtn)
{
	if(confirm("删除模块的同时将删除其包含的问题，以及问题的答案项！\n确定删除该问题吗？"))
	{
		if(objBtn)
		{
			objBtn.value="稍候...";
		}
		var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=deleteModule&param="+id,function(requestObj){
			if(requestObj.status==200)
			{
				var ajaxResponse=new AjaxResponse(requestObj.responseText);
				if(ajaxResponse.Status=="OK")
				{
					if(objBtn)
					{
						location="modules.aspx";
					}
					else
					{
						var oParent=document.getElementById("MODULE_"+id);
						oParent.parentNode.removeChild(oParent);
					}
				}
			}
		});
		ajaxRequest.Get();
	}
}

function deleteQuestion(id,objBtn)
{
	if(confirm("删除问题的同时将删除其包含的答案项！\n确定删除该问题吗？"))
	{
		if(objBtn)
		{
			objBtn.value="稍候...";
		}
		var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=deleteQuestion&param="+id,function(requestObj){
			if(requestObj.status==200)
			{
				var ajaxResponse=new AjaxResponse(requestObj.responseText);
				if(ajaxResponse.Status=="OK")
				{
					if(objBtn)
					{
						location="questions.aspx";
					}
					else
					{
						var oParent=document.getElementById("QUESTION_"+id);
						oParent.parentNode.removeChild(oParent);
					}
				}
			}
		});
		ajaxRequest.Get();
	}
}

function deleteAnswer(id)
{
	if(confirm("确定删除该答案吗？"))
	{
		var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=deleteAnswer&param="+id,function(requestObj){
			if(requestObj.status==200)
			{
				var ajaxResponse=new AjaxResponse(requestObj.responseText);
				if(ajaxResponse.Status=="OK")
				{
					var oParent=document.getElementById("ANSWER_"+id);
					oParent.parentNode.removeChild(oParent);
				}
			}
		});
		ajaxRequest.Get();
	}
}

//删除附加结论
function deleteAdditiveConclusion(sn,conid,id)
{
    if(confirm("确定删除该附加结论吗？"))
	{
		var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=deleteAdditiveConclusion&sn="+sn+"&conid="+conid+"&addconid="+id,function(requestObj){
			if(requestObj.status==200)
			{
				var oParent=document.getElementById("ADDITIVECONCLUSION_"+id);
				oParent.parentNode.removeChild(oParent);
			}
		});
		ajaxRequest.Get();
	}
}

/*
发布问卷的功能函数
*/

var selectedModules=new Array();

function showModuleSelection(bln)
{
    var oSel=document.getElementById("ModuleSelection");
    var oConfirm=document.getElementById("cmdAddModule");
    var oCancle=document.getElementById("cmdAddModuleCancle");
    
    if(bln)
    {
        oSel.style.display="";
        oCancle.style.display="";
        
        oConfirm.value="确定添加";
        oConfirm.onclick=function()
        {
            this.value="稍候...";
            this.disabled=true;
            //alert(document.getElementById("PaperSN").innerHTML);
            var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=addModuleToPaperFile&sn="+document.getElementById("PaperSN").innerHTML+"&param="+selectedModules.toString(),function(requestObj){
		        if(requestObj.status==200)
		        {
			        var ajaxResponse=new AjaxResponse(requestObj.responseText);
			        if(ajaxResponse.Status=="OK")
			        {
				        location.reload();
			        }
		        }
	        });
	        ajaxRequest.Get();
        };
        
        ajaxQueryModules(1);
    }
    else
    {
        oSel.style.display="none";
        oCancle.style.display="none";
        oConfirm.value="添加模块";
        oConfirm.onclick=function()
        {
            showModuleSelection(true);
        };
    }
}

function switchShow(part,id,obj)
{
    var oPart1=document.getElementById("MODULE_"+id);//整体
    var oPart2=document.getElementById("MODULE_SETPANNEL_"+id);//模块设置部分
    var oPart3=document.getElementById("MODULE_QUESTIONS_"+id);//模块问题部分
    var oPart4=document.getElementById("MODULE_CONCLUSIONS_"+id);//模块结论部分
    var oPart5=document.getElementById("PAPER_CONCLUSIONS");//问卷结论部分
    switch(part)
    {
        case 1:
            oPart1.style.display=oPart1.style.display=="none"?"":"none";
            break;
        case 2:
            oPart2.style.display=oPart4.style.display=="none"?"":"none";
            break;
        case 3:
            oPart3.style.display=oPart3.style.display=="none"?"":"none";
            break;
        case 4:
            oPart4.style.display=oPart4.style.display=="none"?"":"none";
            break;
        case 5:
            oPart5.style.display=oPart5.style.display=="none"?"":"none";
            break;
    }
    if(obj)
    {
        if(obj.src.indexOf("-.gif")!=-1)
        {
            obj.src=obj.src.replace("-","+");
        }
        else
        {
            obj.src=obj.src.replace("+","-");
        }
    }
}

function ajaxQueryModules(page)
{
    var oSelBody=document.getElementById("ModuleSelectionBody");
    var indusSelect=document.getElementById("IndustrySelect");
    var indus=indusSelect.options[indusSelect.selectedIndex].value;
    
    var ajaxRequest=new AjaxRequest("clip_modules.aspx?page="+page+"&indus="+indus+"&rnd="+Math.random(),function(requestObj){
	    if(requestObj.status==200)
	    {
		    oSelBody.innerHTML=requestObj.responseText;
	    }
    });
    ajaxRequest.Get();
}

function addItem(oCheck)
{
    if(oCheck.checked)
    {
        var exists=false;
        for(var i=0;i<selectedModules.length;i++)
        {
            if(selectedModules[i]==oCheck.value)
            {
                exists=true;
                break;
            }
        }
        if(!exists)
        {
            selectedModules.push(oCheck.value);
        }
    }
    else
    {
        for(var i=0;i<selectedModules.length;i++)
        {
            if(selectedModules[i]==oCheck.value)
            {
                selectedModules.splice(i);
                break;
            }
        }
    }
}

function removeModule(psn,id)
{
    if(confirm("这并不会删除数据库中的模块\n但会清除模块的权重，得分等级，以及包含问题的选项数规定和答案项的忽略属性\n确定从问卷中移除该模块吗？"))
    {        
        var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=removeModuleFromPaperFile&sn="+psn+"&mid="+id,function(requestObj){
		    if(requestObj.status==200)
		    {
			    var op=document.getElementById("MODULE_"+id).parentNode;
                op.parentNode.removeChild(op);
		    }
	    });
	    ajaxRequest.Get();
    }
}

//更新模块权重，得分等级设置以及问题和答案项
function updateModule(psn,id,oBtn)
{
    var weight=document.getElementById("module"+id+"_weight").value;
    var l1=document.getElementById("module"+id+"_level1").value;
    var l2=document.getElementById("module"+id+"_level2").value;
    var l3=document.getElementById("module"+id+"_level3").value;
    var l4=document.getElementById("module"+id+"_level4").value;
    
    oBtn.disabled=true;
    oBtn.value="稍候...";
    var params=weight+","+l1+","+l2+","+l3+","+l4;
     var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=updatePaperFileModule&sn="+psn+"&mid="+id+"&param="+params,function(requestObj){
	    if(requestObj.status==200)
	    {
		    oBtn.disabled=false;
		    oBtn.value="更新";
	    }
    });
    ajaxRequest.Get();
}

function updateQuestionItemRange(psn,qid,oBtn)
{
    oBtn.disabled=true;
    oBtn.value="稍候...";
    var item1=document.getElementById("question"+qid+"_itemsLower");
    var item2=document.getElementById("question"+qid+"_itemsUpper");
    var params=item1.options[item1.selectedIndex].value+","+item2.options[item2.selectedIndex].value;
    var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=updateQuestionItemRange&sn="+psn+"&qid="+qid+"&param="+params,function(requestObj){
	    if(requestObj.status==200)
	    {
		    oBtn.disabled=false;
            oBtn.value="确定";
	    }
    });
    ajaxRequest.Get();
    
}

//设置答案的忽略规则
function changeAnswerIgnoreType(psn,mid,qid,aid,typeVal)
{
    var oSaveBtn=document.getElementById("cmdAnswer"+aid+"_ignoreSave");
    var oSelBody=document.getElementById("answer"+aid+"_ignorecontainor");
    
    if(typeVal=="0")
    {
        oSelBody.innerHTML="";
        return;
    }
    
    var ajaxRequest=new AjaxRequest("clip_answerIgnoreSelection.aspx?sn="+psn+"&mid="+mid+"&qid="+qid+"&aid="+aid+"&igtype="+typeVal+"&rnd="+Math.random(),function(requestObj){
        if(requestObj.status==200)
        {
            oSelBody.innerHTML=requestObj.responseText;
        }
    });
    ajaxRequest.Get();
}

//更新答案项的忽略规则
function updateAnswerIgnore(psn,mid,qid,aid,oBtn)
{
    if(!confirm("确定更改答案的忽略规则吗？"))
    {
        return;
    }
    
    var oContainor=document.getElementById("answer" + aid + "_ignorecontainor"); 
    var oIgnoreType=document.getElementById("answer" + aid + "_ignoreType"); 
    var oIgnores=oContainor.getElementsByTagName("INPUT");
    var arrayIgnor=new Array();
    
    if(oIgnoreType.selectedIndex>0)
    {
        for(var i=0;i<oIgnores.length;i++)
        {
            if(oIgnores[i].checked)
            {
                arrayIgnor.push(oIgnores[i].value);
            }
        }
    }
    
    var url="AjaxResponse.aspx?rnd="+Math.random()+"&action=updateAnswerIgnore&sn="+psn+"&mid="+mid+"&qid="+qid+"&aid="+aid+"&igtype="+oIgnoreType.options[oIgnoreType.selectedIndex].value+"&param="+arrayIgnor.toString();
    
    oBtn.value="稍候...";
    oBtn.disabled=true;
    var ajaxRequest=new AjaxRequest(url,function(requestObj){
        if(requestObj.status==200)
        {
            oBtn.value="确定";
            oBtn.disabled=false;
        }
    });
    ajaxRequest.Get();
}

//更新问卷文件的结论
function updatePaperConclusions(sn,obj)
{
    obj.innerHTML="更新中...";
    var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=updatePaperConclusions&sn="+sn,function(requestObj){
        if(requestObj.status==200)
        {
            obj.innerHTML="[更新结论]";
        }
    });
    ajaxRequest.Get();
}

//发布问卷时，更新模块结论
function updateModuleConclusions(sn,mid,obj)
{
    obj.innerHTML="更新中...";
    var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=updateModuleConclusions&sn="+sn+"&mid="+mid,function(requestObj){
        if(requestObj.status==200)
        {
            obj.innerHTML="[更新结论]";
        }
    });
    ajaxRequest.Get();
}

//查看临时样本记录时，选择完成的或者未完成的记录,同步定义按钮动作
function selectResults(finished)
{
    var oTable=document.getElementById('ResultListTable');
    var oForm=document.getElementById('ResultListForm');
    
    
    if(oTable.rows.length<2)
    {
        return;
    }
    
    if(finished==1)
    {
        oForm.currentSelected.value="1";
        oForm.cmdDeleteResult.disabled=true;
        oForm.cmdImportResult.disabled=false;
        
        for(var i=1;i<oTable.rows.length;i++)
        {
            var oRow=oTable.rows[i];
            var oChkBox=(document.all?oRow.cells[0].childNodes[0]:oRow.cells[0].childNodes[1]);
            oRow.style.backgroundColor="";
            oChkBox.checked=false;
            if(oRow.cells[4].childNodes[0].className=="resultSta_Finished")
            {
                oChkBox.checked=true;
                oRow.style.backgroundColor="#F3F3F3";
            }
        }
        
        oForm.cmdImportResult.onclick=function()
        {            
            var strIds="";
            
            if(oForm.staId.length)
            {
                for(var i=0;i<oForm.staId.length;i++)
                {
                    strIds+=(oForm.staId[i].checked==true?oForm.staId[i].value+",":"");
                }
            }
            else
            {
                strIds=oForm.staId.value;
            }
            
            if(strIds=="")
            {
                return;
            }
            
            this.value="稍候...";
            this.disabled=true;
            var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=importResultData&staId="+strIds,function(requestObj){
                
                if(requestObj.status==200)
                {
                    for(var i=0;i<oTable.rows.length;i++)
                    {
                       var oChkBox=(document.all?oTable.rows[i].cells[0].childNodes[0]:oTable.rows[i].cells[0].childNodes[1]);
                       if(oChkBox.checked)
                       {
                           oTable.rows[i].parentNode.removeChild(oTable.rows[i]);
                       }
                    }
                    oForm.cmdDeleteResult.value="导入样本";
                }
            });
            ajaxRequest.Get();
        };
    }
    else if(finished==0)
    {
        oForm.currentSelected.value="0";
        oForm.cmdDeleteResult.disabled=false;
        oForm.cmdImportResult.disabled=true;
        for(var i=1;i<oTable.rows.length;i++)
        {
            var oRow=oTable.rows[i];
            var oChkBox=(document.all?oRow.cells[0].childNodes[0]:oRow.cells[0].childNodes[1]);
            oRow.style.backgroundColor="";
            oChkBox.checked=false;
            if(oRow.cells[4].childNodes[0].className!="resultSta_Finished")
            {
                oChkBox.checked=true;
                oRow.style.backgroundColor="#F3F3F3";
            }
        }
        oForm.cmdDeleteResult.onclick=function()
        {
            if(!confirm("这将删除临时样本文件，确认删除吗？"))
            {
                return;
            }
            
            
            var strIds="";
            
            if(oForm.staId.length)
            {
                for(var i=0;i<oForm.staId.length;i++)
                {
                    strIds+=(oForm.staId[i].checked==true?oForm.staId[i].value+",":"");
                }
            }
            else
            {
                strIds=oForm.staId.value;
            }
            
            if(strIds=="")
            {
                return;
            }
            
            this.value="稍候...";
            this.disabled=true;
            var ajaxRequest=new AjaxRequest("AjaxResponse.aspx?action=deleteTempResult&staId="+strIds,function(requestObj){
                
                if(requestObj.status==200)
                {
                    for(var i=0;i<oTable.rows.length;i++)
                    {
                       var oChkBox=(document.all?oTable.rows[i].cells[0].childNodes[0]:oTable.rows[i].cells[0].childNodes[1]);
                       if(oChkBox.checked)
                       {
                           oTable.rows[i].parentNode.removeChild(oTable.rows[i]);
                       }
                    }
                    oForm.cmdDeleteResult.value="删除样本";
                }
            });
            ajaxRequest.Get();
        };
    }
    else//反选功能
    {
        if(oForm.staId.length)
        {
            for(var i=0;i<oForm.staId.length;i++)
            {
                oForm.staId[i].checked=!oForm.staId[i].checked;
                oTable.rows[i+1].style.backgroundColor=oForm.staId[i].checked?"#F3F3F3":"";
            }
        }
        else
        {
            oForm.staId.checked=!oForm.staId.checked;
            oTable.rows[1].style.backgroundColor=oForm.staId.checked?"#F3F3F3":"";
        }
    }
}

//选择有效样本
function selectSpeciments(tag)
{
    
}