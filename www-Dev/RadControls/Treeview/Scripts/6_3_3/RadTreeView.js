var RadTreeView_KeyboardHooked=false;
var RadTreeView_Active=null;
var RadTreeView_DragActive=null;
var RadTreeView_MouseMoveHooked=false;
var RadTreeView_MouseUpHooked=false;
var RadTreeView_MouseY=0;
var RadTreeViewGlobalFirstParam=null;
var RadTreeViewGlobalSecondParam=null;
var RadTreeViewGlobalThirdParam=null;
var RadTreeViewGlobalFourthParam=null;
var contextMenuToBeHidden=null;
var safariKeyDownFlag=true;
if(typeof (window.RadControlsNamespace)=="undefined"){
window.RadControlsNamespace=new Object();
}
RadControlsNamespace.AppendStyleSheet=function(_1,_2,_3){
if(!_3){
return;
}
if(!_1){
document.write("<"+"link"+" rel='stylesheet' type='text/css' href='"+_3+"' />");
}else{
var _4=document.createElement("LINK");
_4.rel="stylesheet";
_4.type="text/css";
_4.href=_3;
document.getElementById(_2+"StyleSheetHolder").appendChild(_4);
}
};
function RadTreeNode(){
this.Parent=null;
this.TreeView=null;
this.Nodes=new Array();
this.ID=null;
this.ClientID=null;
this.SignImage=null;
this.SignImageExpanded=null;
this.Image=0;
this.ImageExpanded=0;
this.Action=null;
this.Index=0;
this.Level=0;
this.Text=null;
this.Value=null;
this.Category=null;
this.NodeCss=null;
this.NodeCssOver=null;
this.NodeCssSelect=null;
this.ContextMenuName=null;
this.Enabled=true;
this.Expanded=false;
this.Checked=false;
this.Selected=false;
this.DragEnabled=1;
this.DropEnabled=1;
this.EditEnabled=1;
this.ExpandOnServer=0;
this.IsClientNode=0;
this.Attributes=new Array();
this.IsFetchingData=false;
this.CachedText="";
}
RadTreeNode.prototype.ScrollIntoView=function(){
var _5=this.TextElement();
var _6=document.getElementById(this.TreeView.Container);
_6.scrollTop=_5.offsetTop;
};
RadTreeNode.prototype.Next=function(){
var _7=(this.Parent!=null)?this.Parent.Nodes:this.TreeView.Nodes;
return (this.Index>=_7.length)?null:_7[this.Index+1];
};
RadTreeNode.prototype.Prev=function(){
var _8=(this.Parent!=null)?this.Parent.Nodes:this.TreeView.Nodes;
return (this.Index<=0)?null:_8[this.Index-1];
};
RadTreeNode.prototype.NextVisible=function(){
if(this.Expanded&&this.Nodes.length>0){
return this.Nodes[0];
}
if(this.Next()!=null){
return this.Next();
}
var _9=this;
while(_9.Parent!=null){
if(_9.Parent.Next()!=null){
return _9.Parent.Next();
}
_9=_9.Parent;
}
return null;
};
RadTreeNode.prototype.LastVisibleChild=function(_a){
var _b=_a.Nodes;
var _c=_b.length;
var _d=_b[_c-1];
var _e=_d;
if(_d.Expanded&&_d.Nodes.length>0){
_e=this.LastVisibleChild(_d);
}
return _e;
};
RadTreeNode.prototype.PrevVisible=function(){
var _f=this.Prev();
if(_f!=null){
if(_f.Expanded&&_f.Nodes.length>0){
return this.LastVisibleChild(_f);
}
return this.Prev();
}
if(this.Parent!=null){
return this.Parent;
}
return null;
};
RadTreeNode.prototype.Toggle=function(){
if(this.Enabled){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientToggle,this)==false){
return;
}
(this.Expanded)?this.Collapse():this.Expand();
if(this.ExpandOnServer!=2){
this.TreeView.FireEvent(this.TreeView.AfterClientToggle,this);
}
}
};
RadTreeNode.prototype.CollapseNonParentNodes=function(){
for(var i=0;i<this.TreeView.AllNodes.length;i++){
if(this.TreeView.AllNodes[i].Expanded&&!this.IsParent(this.TreeView.AllNodes[i])){
this.TreeView.AllNodes[i].CollapseNoEffect();
}
}
};
RadTreeNode.prototype.EncodeURI=function(s){
try{
return encodeURIComponent(s);
}
catch(e){
return escape(s);
}
};
RadTreeNode.prototype.RaiseNoTreeViewOnServer=function(){
throw new Error("No RadTreeView instance has been created on the server.\n"+"Make sure that you have the control instance created.\n"+"Please review this article for additional information.");
};
RadTreeNode.prototype.GetTheElement=function(){
var _12=this.TextElement();
while(_12&&_12.tagName.toLowerCase()!="div"){
_12=_12.parentNode;
}
return _12;
};
RadTreeNode.prototype.FetchDataOnDemand=function(){
if(this.Checked==1){
this.Checked=true;
}
var url=this.TreeView.LoadOnDemandUrl+"&rtnClientID="+this.ClientID+"&rtnLevel="+this.Level+"&rtnID="+this.ID+"&rtnParentPosition="+this.GetParentPositions()+"&rtnText="+this.EncodeURI(this.Text)+"&rtnValue="+this.EncodeURI(this.Value)+"&rtnCategory="+this.EncodeURI(this.Category)+"&rtnChecked="+this.Checked;
var _14;
if(typeof (XMLHttpRequest)!="undefined"){
_14=new XMLHttpRequest();
}else{
_14=new ActiveXObject("Microsoft.XMLHTTP");
}
url=url+"&timeStamp="+encodeURIComponent((new Date()).getTime());
_14.open("GET",url,true);
_14.setRequestHeader("Content-Type","application/json; charset=utf-8");
var _15=this;
_14.onreadystatechange=function(){
if(_14.readyState!=4){
return;
}
var _16=_14.responseText;
if(_14.status==500){
alert("RadTreeView: Server error in the NodeExpand event handler, press ok to view the result.");
document.body.innerHTML=_16;
return;
}
var _17=_16.indexOf(",");
var _18=parseInt(_16.substring(0,_17));
var _19=_16.substring(_17+1,_18+_17+1);
var _1a=_16.substring(_18+_17+1);
_15.LoadNodesOnDemand(_19,_14.status,url);
_15.ImageOn();
_15.SignOn();
_15.Expanded=true;
_15.ExpandOnServer=0;
var _1b=_15.GetTheElement();
var _1c=_1b.parentNode;
switch(_15.TreeView.LoadingMessagePosition){
case 0:
case 1:
if(_15.TextElement().parentNode.tagName=="A"){
_15.TextElement().parentNode.firstChild.innerHTML=_15.CachedText;
_1c=_1b;
}else{
_1c=_15.TextElement().parentNode;
if(_15.TextElement().innerText){
_15.TextElement().innerHTML=_15.CachedText;
}else{
_15.TextElement().innerHTML=_15.CachedText;
}
}
break;
case 2:
_1b.removeChild(document.getElementById(_15.ClientID+"Loading"));
_1c=_1b;
break;
case 3:
_1c=_1b;
}
if(_15.Nodes.length>0){
rtvInsertHTML(_1c,_1a);
var _1d=_1c.getElementsByTagName("IMG");
for(var i=0;i<_1d.length;i++){
RadTreeView.AlignImage(_1d[i]);
}
var _1f=_1c.getElementsByTagName("INPUT");
for(var i=0;i<_1f.length;i++){
RadTreeView.AlignImage(_1f[i]);
}
}
_15.IsFetchingData=false;
_15.TreeView.FireEvent(_15.TreeView.AfterClientToggle,_15);
};
_14.send(null);
};
RadTreeNode.prototype.Expand=function(){
if(this.ExpandOnServer){
if(!this.TreeView.FireEvent(this.TreeView.BeforeClientToggle,this)){
return;
}
if(this.ExpandOnServer==1){
this.TreeView.PostBack("NodeExpand",this.ClientID);
return;
}
if(this.ExpandOnServer==2){
if(!this.IsFetchingData){
this.IsFetchingData=true;
this.CachedText=this.TextElement().innerHTML;
switch(this.TreeView.LoadingMessagePosition){
case 0:
this.TextElement().innerHTML="<span class="+this.TreeView.LoadingMessageCssClass+">"+this.TreeView.LoadingMessage+"</span> "+this.TextElement().innerHTML;
break;
case 1:
this.TextElement().innerHTML=this.TextElement().innerHTML+" "+"<span class="+this.TreeView.LoadingMessageCssClass+">"+this.TreeView.LoadingMessage+"</span> ";
break;
case 2:
rtvInsertHTML(this.TextElement().parentNode,"<div id="+this.ClientID+"Loading "+" class="+this.TreeView.LoadingMessageCssClass+">"+this.TreeView.LoadingMessage+"</div>");
break;
}
var _20=this;
window.setTimeout(function(){
_20.FetchDataOnDemand();
},20);
return;
}
}
}
if(!this.Nodes.length){
return;
}
if(this.TreeView.SingleExpandPath){
this.CollapseNonParentNodes();
}
var _21=document.getElementById("G"+this.ClientID);
if(this.TreeView.ExpandDelay>0){
_21.style.overflow="hidden";
_21.style.height="1px";
_21.style.display="block";
window.setTimeout("rtvNodeExpand(1,'"+_21.id+"',"+this.TreeView.ExpandDelay+");",20);
}else{
_21.style.display="block";
}
this.ImageOn();
this.SignOn();
this.Expanded=true;
if(!this.IsClientNode){
this.TreeView.UpdateExpandedState();
}
};
RadTreeNode.prototype.GetParentPositions=function(){
var _22=this;
var _23="";
while(_22!=null){
if(_22.Next()!=null){
_23=_23+"1";
}else{
_23=_23+"0";
}
_22=_22.Parent;
}
return _23;
};
RadTreeNode.prototype.Collapse=function(){
if(this.Nodes.length>0){
if(this.ExpandOnServer==1&&this.TreeView.NodeCollapseWired){
this.TreeView.PostBack("NodeCollapse",this.ClientID);
return;
}
if(this.TreeView.ExpandDelay>0){
var _24=document.getElementById("G"+this.ClientID);
if(_24.scrollHeight!="undefined"){
_24.style.overflow="hidden";
_24.style.display="block";
window.setTimeout("rtvNodeCollapse("+_24.scrollHeight+",'"+_24.id+"',"+this.TreeView.ExpandDelay+" );",20);
}else{
this.CollapseNoEffect();
}
}else{
this.CollapseNoEffect();
}
this.ImageOff();
this.SignOff();
this.Expanded=false;
this.TreeView.UpdateExpandedState();
}
};
RadTreeNode.prototype.CollapseNoEffect=function(){
if(this.Nodes.length>0){
var _25=document.getElementById("G"+this.ClientID);
_25.style.display="none";
this.ImageOff();
this.SignOff();
this.Expanded=false;
this.TreeView.UpdateExpandedState();
}
};
RadTreeNode.prototype.Highlight=function(e){
if(!this.Enabled){
return;
}
if(e){
if(this.TreeView.MultipleSelect&&(e.ctrlKey||e.shiftKey)){
if(this.Selected){
this.TextElement().className=this.NodeCss;
this.Selected=false;
if(this.TreeView.SelectedNode==this){
this.TreeView.SelectedNode=null;
}
this.TreeView.UpdateSelectedState();
return;
}
}else{
this.TreeView.UnSelectAllNodes();
}
}
this.TextElement().className=this.NodeCssSelect;
this.TreeView.SelectNode(this);
this.TreeView.FireEvent(this.TreeView.AfterClientHighlight,this);
};
RadTreeNode.prototype.ExecuteAction=function(e){
if(this.IsClientNode){
return;
}
if(this.TextElement().tagName=="A"){
this.TextElement().click();
}else{
if(this.Action){
this.TreeView.PostBack("NodeClick",this.ClientID);
}
}
if(e){
(document.all)?e.returnValue=false:e.preventDefault();
}
};
RadTreeNode.prototype.Select=function(e){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientClick,this,e)==false){
e.returnValue=false;
if(e.preventDefault){
e.preventDefault();
}
return;
}
if(this.Enabled){
this.Highlight(e);
this.TreeView.LastHighlighted=this;
this.ExecuteAction();
}else{
(document.all)?e.returnValue=false:e.preventDefault();
}
this.TreeView.FireEvent(this.TreeView.AfterClientClick,this,e);
};
RadTreeNode.prototype.UnSelect=function(){
if(this.TextElement().parentNode&&this.TextElement().parentNode.tagName=="A"){
this.TextElement().parentNode.className=this.NodeCss;
}
this.TextElement().className=this.NodeCss;
this.Selected=false;
};
RadTreeNode.prototype.Disable=function(){
this.TextElement().className=this.TreeView.NodeCssDisable;
this.Enabled=false;
this.Selected=false;
if(this.CheckElement()!=null){
this.CheckElement().disabled=true;
}
};
RadTreeNode.prototype.Enable=function(){
this.TextElement().className=this.NodeCss;
this.Enabled=true;
if(this.CheckElement()!=null){
this.CheckElement().disabled=false;
}
};
RadTreeNode.prototype.Hover=function(e){
var _2a=(e.srcElement)?e.srcElement:e.target;
if(this.TreeView.IsRootNodeTag(_2a)){
this.TreeView.SetBorderOnDrag(this,_2a,e);
return;
}
if(this.Enabled){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientHighlight,this)==false){
return;
}
this.TreeView.LastHighlighted=this;
if(RadTreeView_DragActive!=null&&RadTreeView_DragActive.DragClone!=null&&(!this.Expanded)&&this.ExpandOnServer!=1){
var _2b=this;
window.setTimeout(function(){
_2b.ExpandOnDrag();
},1000);
}
if(!this.Selected){
this.TextElement().className=this.NodeCssOver;
if(this.Image){
this.ImageElement().style.cursor="hand";
}
}
this.TreeView.FireEvent(this.TreeView.AfterClientHighlight,this);
}
};
RadTreeNode.prototype.UnHover=function(e){
var _2d=(e.srcElement)?e.srcElement:e.target;
if(this.TreeView.IsRootNodeTag(_2d)){
this.TreeView.ClearBorderOnDrag(_2d);
return;
}
if(this.Enabled){
this.TreeView.LastHighlighted=null;
if(!this.Selected){
this.TextElement().className=this.NodeCss;
if(this.Image){
this.ImageElement().style.cursor="default";
}
}
this.TreeView.FireEvent(this.TreeView.AfterClientMouseOut,this);
}
};
RadTreeNode.prototype.ExpandOnDrag=function(){
if(RadTreeView_DragActive!=null&&RadTreeView_DragActive.DragClone!=null&&(!this.Expanded)){
if(RadTreeView_Active.LastHighlighted==this){
this.Expand();
}
}
};
RadTreeNode.prototype.CheckBoxClick=function(e){
if(this.Enabled){
if(this.TreeView.FireEvent(this.TreeView.BeforeClientCheck,this,e)==false){
(this.Checked)?this.Check():this.UnCheck();
return;
}
(this.Checked)?this.UnCheck():this.Check();
if(this.TreeView.AutoPostBackOnCheck){
this.TreeView.PostBack("NodeCheck",this.ClientID);
this.TreeView.FireEvent(this.TreeView.AfterClientCheck,this);
return;
}
this.TreeView.FireEvent(this.TreeView.AfterClientCheck,this);
}
};
RadTreeNode.prototype.Check=function(){
if(this.CheckElement()!=null){
this.CheckElement().checked=true;
this.Checked=true;
this.TreeView.UpdateCheckedState();
}
};
RadTreeNode.prototype.UnCheck=function(){
if(this.CheckElement()!=null){
this.CheckElement().checked=false;
this.Checked=false;
this.TreeView.UpdateCheckedState();
}
};
RadTreeNode.prototype.IsSet=function(a){
return (a!=null&&a!="");
};
RadTreeNode.prototype.ImageOn=function(){
var _30=document.getElementById(this.ClientID+"i");
if(this.ImageExpanded!=0){
_30.src=this.ImageExpanded;
}
};
RadTreeNode.prototype.ImageOff=function(){
var _31=document.getElementById(this.ClientID+"i");
if(this.Image!=0){
_31.src=this.Image;
}
};
RadTreeNode.prototype.SignOn=function(){
var _32=document.getElementById(this.ClientID+"c");
if(this.IsSet(this.SignImageExpanded)){
_32.src=this.SignImageExpanded;
}
};
RadTreeNode.prototype.SignOff=function(){
var _33=document.getElementById(this.ClientID+"c");
if(this.IsSet(this.SignImage)){
_33.src=this.SignImage;
}
};
RadTreeNode.prototype.TextElement=function(){
var _34=document.getElementById(this.ClientID);
var _35=_34.getElementsByTagName("span")[0];
if(_35==null){
_35=_34.getElementsByTagName("a")[0];
}
return _35;
};
RadTreeNode.prototype.ImageElement=function(){
return document.getElementById(this.ClientID+"i");
};
RadTreeNode.prototype.CheckElement=function(){
return document.getElementById(this.ClientID).getElementsByTagName("input")[0];
};
RadTreeNode.prototype.IsParent=function(_36){
var _37=this.Parent;
while(_37!=null){
if(_36==_37){
return true;
}
_37=_37.Parent;
}
return false;
};
RadTreeNode.prototype.StartEdit=function(){
if(this.EditEnabled){
var _38=this.Text;
this.TreeView.EditMode=true;
var _39=this.TextElement().parentNode;
this.TreeView.EditTextElement=this.TextElement().cloneNode(true);
this.TextElement().parentNode.removeChild(this.TextElement());
var _3a=this;
var _3b=document.createElement("input");
_3b.setAttribute("type","text");
_3b.setAttribute("size",this.Text.length+3);
_3b.setAttribute("value",_38);
_3b.className=this.TreeView.NodeCssEdit;
var _3c=this;
_3b.onblur=function(){
_3c.EndEdit();
};
_3b.onchange=function(){
_3c.EndEdit();
};
_3b.onkeypress=function(e){
_3c.AnalyzeEditKeypress(e);
};
_3b.onsubmit=function(){
return false;
};
_39.appendChild(_3b);
this.TreeView.EditInputElement=_3b;
_3b.focus();
_3b.onselectstart=function(e){
if(!e){
e=window.event;
}
if(e.stopPropagation){
e.stopPropagation();
}else{
e.cancelBubble=true;
}
};
var _3f=0;
var _40=this.Text.length;
if(_3b.createTextRange){
var _41=_3b.createTextRange();
_41.moveStart("character",_3f);
_41.moveEnd("character",_40);
_41.select();
}else{
_3b.setSelectionRange(_3f,_40);
}
}
};
RadTreeNode.prototype.EndEdit=function(){
this.TreeView.EditInputElement.onblur=null;
this.TreeView.EditInputElement.onchange=null;
var _42=this.TreeView.EditInputElement.parentNode;
this.TreeView.EditInputElement.parentNode.removeChild(this.TreeView.EditInputElement);
_42.appendChild(this.TreeView.EditTextElement);
if(this.TreeView.FireEvent(this.TreeView.AfterClientEdit,this,this.Text,this.TreeView.EditInputElement.value)!=false){
if(this.Text!=this.TreeView.EditInputElement.value){
var _43=this.ClientID+":"+this.TreeView.EscapeParameter(this.TreeView.EditInputElement.value);
this.TreeView.PostBack("NodeEdit",_43);
return;
}
}
this.TreeView.EditMode=false;
this.TreeView.EditInputElement=null;
this.TreeView.EditTextElement=null;
};
RadTreeNode.prototype.AnalyzeEditKeypress=function(e){
if(document.all){
e=event;
}
if(e.keyCode==13){
(document.all)?e.returnValue=false:e.preventDefault();
if(typeof (e.cancelBubble)!="undefined"){
e.cancelBubble=true;
}
this.EndEdit();
return false;
}
if(e.keyCode==27){
this.TreeView.EditInputElement.value=this.TreeView.EditTextElement.innerHTML;
this.EndEdit();
}
return true;
};
RadTreeNode.prototype.LoadNodesOnDemand=function(s,_46,url){
if(_46==404){
var _48="CallBack URL not found: \n\r\n\r"+url+"\n\r\n\rAre you using URL Rewriter? Please, try setting the AjaxUrl property to match the correct URL you need";
alert(_48);
this.TreeView.FireEvent(this.TreeView.AfterClientCallBackError,this.TreeView);
}else{
try{
eval(s);
var _49=window[this.ClientID+"ClientData"];
for(var i=0;i<_49.length;i++){
var _4b=_49[i][0];
var _4c=_4b.substring(0,_4b.lastIndexOf("_t"));
var _4d=this.TreeView.FindNode(_4c);
if(_4d){
this.TreeView.LoadNode(_49[i],null,_4d);
}else{
_49[i][17]=0;
this.TreeView.LoadNode(_49[i],null,this);
}
}
}
catch(e){
this.TreeView.FireEvent(this.TreeView.AfterClientCallBackError,this.TreeView);
}
}
};
function RadTreeView(_4e){
if(window.tlrkTreeViews==null){
window.tlrkTreeViews=new Array();
}
if(window.tlrkTreeViews[_4e]!=null){
var _4f=window.tlrkTreeViews[_4e];
_4f.Dispose();
}
tlrkTreeViews[_4e]=this;
this.Nodes=new Array();
this.AllNodes=new Array();
this.ClientID=null;
this.SelectedNode=null;
this.DragMode=false;
this.DragSource=null;
this.DragClone=null;
this.LastHighlighted=null;
this.MouseInside=false;
this.HtmlElementID="";
this.EditMode=false;
this.EditTextElement=null;
this.EditInputElement=null;
this.BeforeClientClick=null;
this.BeforeClientHighlight=null;
this.AfterClientHighlight=null;
this.AfterClientMouseOut=null;
this.BeforeClientDrop=null;
this.AfterClientDrop=null;
this.BeforeClientToggle=null;
this.AfterClientToggle=null;
this.BeforeClientContextClick=null;
this.BeforeClientContextMenu=null;
this.AfterClientContextClick=null;
this.BeforeClientCheck=null;
this.AfterClientCheck=null;
this.AfterClientMove=null;
this.AfterClientFocus=null;
this.BeforeClientDrag=null;
this.AfterClientEdit=null;
this.AfterClientClick=null;
this.BeforeClientDoubleClick=null;
this.AfterClientCallBackError=null;
this.DragAndDropBetweenNodes=false;
this.AutoPostBackOnCheck=false;
this.CausesValidation=true;
this.ContextMenuVisible=false;
this.ContextMenuName=null;
this.ContextMenuNode=null;
this.SingleExpandPath=false;
this.ExpandDelay=2;
this.TabIndex=0;
this.AllowNodeEditing=false;
this.LoadOnDemandUrl=null;
this.LoadingMessage="(loading ...)";
this.LoadingMessagePosition=0;
this.LoadingMessageCssClass="LoadingMessage";
this.NodeCollapseWired=false;
this.RightToLeft=false;
this.LastBorderElementSet=null;
this.LastDragPosition="on";
this.LastDragNode=null;
this.IsBuilt=false;
}
RadTreeView.AlignImage=function(_50){
_50.align="absmiddle";
_50.style.display="inline";
if(!document.all||window.opera){
if(_50.nextSibling&&_50.nextSibling.tagName=="SPAN"){
_50.nextSibling.style.verticalAlign="middle";
}
if(_50.nextSibling&&_50.nextSibling.tagName=="INPUT"){
_50.nextSibling.style.verticalAlign="middle";
}
}
};
RadTreeView.prototype.OnInit=function(){
var _51=new Array();
this.PreloadImages(_51);
GlobalTreeViewImageList=_51;
var _52=document.getElementById(this.Container).getElementsByTagName("IMG");
for(var i=0;i<_52.length;i++){
var _54=_52[i].className;
if(_51[_54]&&_54!=null&&_54!=""){
_52[i].src=_51[_54];
RadTreeView.AlignImage(_52[i]);
}
}
this.LoadTree(_51);
var _55=document.getElementById(this.Container).getElementsByTagName("INPUT");
for(var i=0;i<_55.length;i++){
RadTreeView.AlignImage(_55[i]);
}
var _56=this;
this.OnKeyDownMozilla=function(e){
_56.KeyDownMozilla(e);
};
if(document.addEventListener&&(!RadTreeView_KeyboardHooked)){
RadTreeView_KeyboardHooked=true;
this.AttachEvent(document,"keydown",this.OnKeyDownMozilla);
}
if((!RadTreeView_MouseMoveHooked)&&(this.DragAndDrop)){
RadTreeView_MouseMoveHooked=true;
this.AttachEvent(document,"mousemove",rtvMouseMove);
}
if(!RadTreeView_MouseUpHooked){
RadTreeView_MouseUpHooked=true;
this.AttachEvent(document,"mouseup",rtvMouseUp);
}
this.AttachAllEvents();
this.IsBuilt=true;
};
RadTreeView.prototype.AttachAllEvents=function(){
var _58=this;
var _59=document.getElementById(this.Container);
this.OnFocus=function(e){
rtvDispatcher(_58.ClientID,"focus",e);
};
this.OnMouseOver=function(e){
rtvDispatcher(_58.ClientID,"mover",e);
};
this.OnMouseOut=function(e){
rtvDispatcher(_58.ClientID,"mout",e);
};
this.OnContextMenu=function(e){
rtvDispatcher(_58.ClientID,"context",e);
};
this.OnScroll=function(e){
_58.Scroll();
};
this.OnClick=function(e){
rtvDispatcher(_58.ClientID,"mclick",e);
};
this.OnDblClick=function(e){
rtvDispatcher(_58.ClientID,"mdclick",e);
};
this.OnKeyDown=function(e){
rtvDispatcher(_58.ClientID,"keydown",e);
};
this.OnSelectStart=function(e){
return false;
};
this.OnDragStart=function(e){
return false;
};
this.OnMouseDown=function(e){
rtvDispatcher(_58.ClientID,"mdown",e);
};
this.OnUnload=function(e){
_58.Dispose();
};
this.AttachEvent(_59,"focus",this.OnFocus);
this.AttachEvent(_59,"mouseover",this.OnMouseOver);
this.AttachEvent(_59,"mouseout",this.OnMouseOut);
this.AttachEvent(_59,"contextmenu",this.OnContextMenu);
this.AttachEvent(_59,"scroll",this.OnScroll);
this.AttachEvent(_59,"click",this.OnClick);
this.AttachEvent(_59,"dblclick",this.OnDblClick);
this.AttachEvent(_59,"keydown",this.OnKeyDown);
this.AttachEvent(_59,"selectstart",this.OnSelectStart);
this.AttachEvent(_59,"dragstart",this.OnDragStart);
if(this.DragAndDrop){
this.AttachEvent(_59,"mousedown",this.OnMouseDown);
}
this.AttachEvent(window,"unload",this.OnUnload);
this.RootElement=_59;
};
RadTreeView.prototype.Dispose=function(){
if(this.disposed){
return;
}
this.disposed=true;
this.DetachEvent(this.RootElement,"focus",this.OnFocus);
this.DetachEvent(this.RootElement,"mouseover",this.OnMouseOver);
this.DetachEvent(this.RootElement,"mouseout",this.OnMouseOut);
this.DetachEvent(this.RootElement,"contextmenu",this.OnContextMenu);
this.DetachEvent(this.RootElement,"scroll",this.OnScroll);
this.DetachEvent(this.RootElement,"click",this.OnClick);
this.DetachEvent(this.RootElement,"dblclick",this.OnDblClick);
this.DetachEvent(this.RootElement,"keydown",this.OnKeyDown);
this.DetachEvent(this.RootElement,"selectstart",this.OnSelectStart);
this.DetachEvent(this.RootElement,"dragstart",this.OnDragStart);
if(this.DragAndDrop){
this.DetachEvent(this.RootElement,"mousedown",this.OnMouseDown);
}
this.DetachEvent(window,"unload",this.OnUnload);
this.RootElement=null;
};
RadTreeView.prototype.PreloadImages=function(_66){
var _67=window[this.ClientID+"ImageData"];
for(var i=0;i<_67.length;i++){
_66[i]=_67[i];
}
};
RadTreeView.prototype.FindNode=function(_69){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].ClientID==_69){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.FindNodeByText=function(_6b){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Text==_6b){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.FindNodeByValue=function(_6d){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Value==_6d){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.FindNodeByAttribute=function(_6f,_70){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Attributes[_6f]==_70){
return this.AllNodes[i];
}
}
return null;
};
RadTreeView.prototype.IsChildOf=function(_72,_73){
if(_73==_72){
return false;
}
while(_73&&(_73!=document.body)){
if(_73==_72){
return true;
}
try{
_73=_73.parentNode;
}
catch(e){
return false;
}
}
return false;
};
RadTreeView.prototype.GetOffsetTop=function(){
var _74=document.getElementById(this.Container);
var _75=_74.offsetTop;
var _76=_74.offsetParent;
while(_76){
_75+=_76.offsetTop;
_76=_76.offsetParent;
}
return _75;
};
RadTreeView.prototype.GetTarget=function(e){
if(!e){
return null;
}
return e.target||e.srcElement;
};
RadTreeView.prototype.LoadTree=function(_78){
var cd=window[this.ClientID+"ClientData"];
for(var i=0;i<cd.length;i++){
this.LoadNode(cd[i],_78);
}
};
RadTreeView.prototype.LoadNode=function(cd,_7c,_7d){
var _7e=new RadTreeNode();
_7e.ClientID=cd[0];
_7e.TreeView=this;
var _7f=cd[17];
if(_7f>0){
_7e.Parent=this.AllNodes[_7f-1];
}
if(_7d!=null){
_7e.Parent=_7d;
}
_7e.NodeCss=this.NodeCss;
_7e.NodeCssOver=this.NodeCssOver;
_7e.NodeCssSelect=this.NodeCssSelect;
_7e.Text=cd[1];
_7e.Value=cd[2];
_7e.Category=cd[3];
if(_7c!=null){
_7e.SignImage=_7c[cd[4]];
_7e.SignImageExpanded=_7c[cd[5]];
}else{
_7e.SignImage=GlobalTreeViewImageList[cd[4]];
_7e.SignImageExpanded=GlobalTreeViewImageList[cd[5]];
}
if(cd[6]>0){
_7e.Image=_7c[cd[6]];
}
if(cd[7]>0){
_7e.ImageExpanded=_7c[cd[7]];
}
_7e.Selected=cd[8];
if(_7e.Selected){
this.SelectedNode=_7e;
}
_7e.Checked=cd[9];
_7e.Enabled=cd[10];
_7e.Expanded=cd[11];
_7e.Action=cd[12];
if(this.IsSet(cd[13])){
_7e.NodeCss=cd[13];
}
if(this.IsSet(cd[14])){
_7e.ContextMenuName=cd[14];
}
this.AllNodes[this.AllNodes.length]=_7e;
if(_7e.Parent!=null){
_7e.Parent.Nodes[_7e.Parent.Nodes.length]=_7e;
}else{
this.Nodes[this.Nodes.length]=_7e;
}
_7e.Index=cd[16];
_7e.DragEnabled=cd[18];
_7e.DropEnabled=cd[19];
_7e.ExpandOnServer=cd[20];
if(this.IsSet(cd[21])){
_7e.NodeCssOver=cd[21];
}
if(this.IsSet(cd[22])){
_7e.NodeCssSelect=cd[22];
}
_7e.Level=cd[23];
_7e.ID=cd[24];
_7e.IsClientNode=cd[25];
_7e.EditEnabled=cd[26];
_7e.Attributes=cd[27];
};
RadTreeView.prototype.Toggle=function(_80){
this.FindNode(_80).Toggle();
};
RadTreeView.prototype.Select=function(_81,e){
this.FindNode(_81).Select(e);
};
RadTreeView.prototype.Hover=function(_83,e){
var _83=this.FindNode(_83);
if(_83){
_83.Hover(e);
}
};
RadTreeView.prototype.UnHover=function(_85,e){
var _85=this.FindNode(_85);
if(_85){
_85.UnHover(e);
}
};
RadTreeView.prototype.CheckBoxClick=function(_87,e){
this.FindNode(_87).CheckBoxClick(e);
};
RadTreeView.prototype.Highlight=function(_89,e){
this.FindNode(_89).Highlight(e);
};
RadTreeView.prototype.SelectNode=function(_8b){
this.SelectedNode=_8b;
_8b.Selected=true;
this.UpdateSelectedState();
};
RadTreeView.prototype.GetSelectedNodes=function(){
var _8c=new Array();
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected){
_8c[_8c.length]=this.AllNodes[i];
}
}
return _8c;
};
RadTreeView.prototype.UnSelectAllNodes=function(_8e){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected&&this.AllNodes[i].Enabled){
this.AllNodes[i].UnSelect();
}
}
};
RadTreeView.prototype.KeyDownMozilla=function(e){
var _91=RadTreeView_Active;
if(_91){
var _92=_91.GetTarget(e);
if(_92.tagName.toUpperCase()=="BODY"||_92.tagName.toUpperCase()=="HTML"||_91.IsChildOf(_92,_91.RootElement)||_92==_91.RootElement){
if(!_91.IsBuilt){
return;
}
var _93=_91.SelectedNode;
if(_93!=null){
if(_91.EditMode){
return;
}
if(e.keyCode==107||e.keyCode==109||e.keyCode==37||e.keyCode==39){
_93.Toggle();
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==40&&_93.NextVisible()!=null){
_93.NextVisible().KeepInView();
_93.NextVisible().Highlight(e);
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==38&&_93.PrevVisible()!=null){
_93.PrevVisible().KeepInView();
_93.PrevVisible().Highlight(e);
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==13){
if(_91.FireEvent(_91.BeforeClientClick,_93,e)==false){
return;
}
_93.ExecuteAction();
_91.FireEvent(_91.AfterClientClick,_93,e);
}
if(e.keyCode==32){
_93.CheckBoxClick();
}
if(e.keyCode==113&&_91.AllowNodeEditing){
_93.StartEdit();
}
}else{
if(e.keyCode==38||e.keyCode==40||e.keyCode==13||e.keyCode==32){
_91.Nodes[0].Highlight();
_91.Nodes[0].KeepInView();
(document.all)?e.returnValue=false:e.preventDefault();
}
}
}
}
};
RadTreeNode.prototype.GetOffsetTop=function(){
var _94=this.TextElement().parentNode.offsetTop;
var _95=this.TextElement().parentNode.offsetParent;
while(_95){
_94+=_95.offsetTop;
_95=_95.offsetParent;
}
return _94;
};
RadTreeNode.prototype.KeepInView=function(){
var _96=this.TextElement();
var _97=document.getElementById(this.TreeView.Container);
var _98=this.GetOffsetTop();
var _99=this.TreeView.GetOffsetTop();
var _9a=_98-_99;
if(_9a<_97.scrollTop){
_97.scrollTop=_9a;
}
var _9b=this.TextElement().parentNode.offsetHeight;
if(_9a+_9b>(_97.clientHeight+_97.scrollTop)){
_97.scrollTop+=((_9a+_9b)-(_97.clientHeight+_97.scrollTop));
}
};
RadTreeView.prototype.KeyDown=function(e){
if(this.EditMode){
return;
}
var _9d=this.SelectedNode;
if(_9d!=null){
if(e.keyCode==107||e.keyCode==109||e.keyCode==37||e.keyCode==39){
_9d.Toggle();
}
if(e.keyCode==40&&_9d.NextVisible()!=null){
(document.all)?e.returnValue=false:e.preventDefault();
_9d.NextVisible().Highlight(e);
_9d.NextVisible().KeepInView();
}
if(e.keyCode==38&&_9d.PrevVisible()!=null){
(document.all)?e.returnValue=false:e.preventDefault();
_9d.PrevVisible().Highlight(e);
_9d.PrevVisible().KeepInView();
}
if(e.keyCode==13){
if(this.FireEvent(this.BeforeClientClick,this.SelectedNode,e)==false){
return;
}
_9d.ExecuteAction(e);
this.FireEvent(this.AfterClientClick,this.SelectedNode,e);
}
if(e.keyCode==32){
_9d.CheckBoxClick();
(document.all)?e.returnValue=false:e.preventDefault();
}
if(e.keyCode==113&&this.AllowNodeEditing){
_9d.StartEdit();
}
}else{
if(e.keyCode==38||e.keyCode==40||e.keyCode==13||e.keyCode==32){
this.Nodes[0].Highlight();
this.Nodes[0].KeepInView();
(document.all)?e.returnValue=false:e.preventDefault();
}
}
};
RadTreeView.prototype.UpdateState=function(){
this.UpdateExpandedState();
this.UpdateCheckedState();
this.UpdateSelectedState();
};
RadTreeView.prototype.UpdateExpandedState=function(){
var _9e="";
for(var i=0;i<this.AllNodes.length;i++){
var _a0=(this.AllNodes[i].Expanded)?"1":"0";
_9e+=_a0;
}
document.getElementById(this.ClientID+"_expanded").value=_9e;
};
RadTreeView.prototype.UpdateCheckedState=function(){
var _a1="";
for(var i=0;i<this.AllNodes.length;i++){
var _a3=(this.AllNodes[i].Checked)?"1":"0";
_a1+=_a3;
}
document.getElementById(this.ClientID+"_checked").value=_a1;
};
RadTreeView.prototype.UpdateSelectedState=function(){
var _a4="";
for(var i=0;i<this.AllNodes.length;i++){
var _a6=(this.AllNodes[i].Selected)?"1":"0";
_a4+=_a6;
}
document.getElementById(this.ClientID+"_selected").value=_a4;
};
RadTreeView.prototype.Scroll=function(){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].ContextMenuVisible){
contextMenuToBeHidden=tlrkTreeViews[key];
window.setTimeout(function(){
if(contextMenuToBeHidden){
contextMenuToBeHidden.HideContextMenu();
}
},10);
}
}
document.getElementById(this.ClientID+"_scroll").value=document.getElementById(this.Container).scrollTop;
};
RadTreeView.prototype.ContextMenuClick=function(e,p1,p2,p3){
instance=this;
window.setTimeout(function(){
instance.HideContextMenu();
},10);
if(this.FireEvent(this.BeforeClientContextClick,this.ContextMenuNode,p1,p3)==false){
return;
}
if(p2){
var _ac=this.ContextMenuNode.ClientID+":"+this.EscapeParameter(p1)+":"+this.EscapeParameter(p3);
this.PostBack("ContextMenuClick",_ac);
}
};
RadTreeView.prototype.ContextMenu=function(e,_ae){
var src=(e.srcElement)?e.srcElement:e.target;
var _b0=this.FindNode(_ae);
if(_b0!=null&&this.BeforeClientContextMenu!=null){
var _b1=this.SelectedNode;
if(this.FireEvent(this.BeforeClientContextMenu,_b0,e,_b1)==false){
return;
}
this.Highlight(_ae,e,_b1);
}
if(_b0!=null&&_b0.ContextMenuName!=null&&_b0.Enabled){
if(!this.ContextMenuVisible){
this.ContextMenuNode=_b0;
if(!_b0.Selected){
this.Highlight(_ae,e);
}
this.ShowContextMenu(_b0.ContextMenuName,e);
document.all?e.returnValue=false:e.preventDefault();
}
}
};
RadTreeView.prototype.ShowContextMenu=function(_b2,e){
if(!document.readyState||document.readyState=="complete"){
var _b4="rtvcm"+this.ClientID+_b2;
var _b5=document.getElementById(_b4);
if(_b5){
var _b6=_b5.cloneNode(true);
_b6.id=_b4+"_clone";
document.body.appendChild(_b6);
_b6=document.getElementById(_b4+"_clone");
_b6.style.left=this.CalculateXPos(e)+"px";
_b6.style.top=this.CalculateYPos(e)+"px";
_b6.style.position="absolute";
_b6.style.display="block";
this.ContextMenuVisible=true;
this.ContextMenuName=_b2;
document.all?e.returnValue=false:e.preventDefault();
}
}
};
RadTreeView.prototype.CalculateYPos=function(e){
if(document.compatMode&&document.compatMode=="CSS1Compat"){
return (e.clientY+document.documentElement.scrollTop);
}
return (e.clientY+document.body.scrollTop);
};
RadTreeView.prototype.CalculateXPos=function(e){
if(navigator.appName=="Microsoft Internet Explorer"&&this.RightToLeft){
return (e.clientX-(document.documentElement.scrollWidth-document.documentElement.clientWidth-document.documentElement.scrollLeft));
}
if(document.compatMode&&document.compatMode=="CSS1Compat"){
return (e.clientX+document.documentElement.scrollLeft);
}
return (e.clientX+document.body.scrollLeft);
};
RadTreeView.prototype.HideContextMenu=function(){
if(!document.readyState||document.readyState=="complete"){
var _b9=document.getElementById("rtvcm"+this.ClientID+this.ContextMenuName+"_clone");
if(_b9){
document.body.removeChild(_b9);
}
this.ContextMenuVisible=false;
}
};
RadTreeView.prototype.MouseClickDispatcher=function(e){
var src=(e.srcElement)?e.srcElement:e.target;
var _bc=rtvGetNodeID(e);
if(_bc!=null&&src.tagName!="DIV"){
var _bd=this.FindNode(_bc);
if(_bd.Selected){
if(this.AllowNodeEditing){
_bd.StartEdit();
return;
}else{
this.Select(_bc,e);
}
}else{
this.Select(_bc,e);
}
}
if(src.tagName=="IMG"){
var _be=src.className;
if(this.IsSet(_be)&&this.IsToggleImage(_be)){
this.Toggle(src.parentNode.id);
}
}
if(src.tagName=="INPUT"&&rtvInsideNode(src)){
this.CheckBoxClick(src.parentNode.id,e);
}
};
RadTreeView.prototype.IsToggleImage=function(n){
return (n==1||n==2||n==5||n==6||n==7||n==8||n==10||n==11);
};
RadTreeView.prototype.DoubleClickDispatcher=function(e,_c1){
var _c2=this.FindNode(_c1);
if(this.FireEvent(this.BeforeClientDoubleClick,_c2)==false){
return;
}
this.Toggle(_c1);
};
RadTreeView.prototype.MouseOverDispatcher=function(e,_c4){
this.Hover(_c4,e);
};
RadTreeView.prototype.MouseOutDispatcher=function(e,_c6){
this.UnHover(_c6,e);
this.LastDragNode=null;
this.LastHighlighted=null;
};
RadTreeView.prototype.DetermineDirection=function(){
var _c7=document.getElementById(this.Container);
while(_c7){
if(_c7.dir){
this.RightToLeft=(_c7.dir.toLowerCase()=="rtl");
return;
}
_c7=_c7.parentNode;
}
this.RightToLeft=false;
};
RadTreeView.prototype.MouseDown=function(e){
if(this.LastHighlighted!=null&&this.DragAndDrop){
if(this.FireEvent(this.BeforeClientDrag,this.LastHighlighted)==false){
return;
}
if(!this.LastHighlighted.DragEnabled){
return;
}
if(e.button==2){
return;
}
this.DragSource=this.LastHighlighted;
this.DragClone=document.createElement("div");
document.body.appendChild(this.DragClone);
RadTreeView_DragActive=this;
var res="";
if(this.MultipleSelect&&(this.SelectedNodesCount()>1)){
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected){
if(this.AllNodes[i].Image){
var img=this.AllNodes[i].ImageElement();
var _cc=img.cloneNode(true);
this.DragClone.appendChild(_cc);
}
var _cd=this.AllNodes[i].TextElement().cloneNode(true);
_cd.className=this.AllNodes[i].NodeCss;
_cd.style.color="gray";
this.DragClone.appendChild(_cd);
this.DragClone.appendChild(document.createElement("BR"));
}
res=res+"text";
}
}
if(res==""){
if(this.LastHighlighted.Image){
var img=this.LastHighlighted.ImageElement();
var _cc=img.cloneNode(true);
this.DragClone.appendChild(_cc);
}
var _cd=this.LastHighlighted.TextElement().cloneNode(true);
_cd.className=this.LastHighlighted.NodeCss;
_cd.style.color="gray";
this.DragClone.appendChild(_cd);
}
this.DragClone.style.position="absolute";
this.DragClone.style.display="none";
if(e.preventDefault){
e.preventDefault();
}
}
};
RadTreeView.prototype.SelectedNodesCount=function(){
var _ce=0;
for(var i=0;i<this.AllNodes.length;i++){
if(this.AllNodes[i].Selected){
_ce++;
}
}
return _ce;
};
RadTreeView.prototype.FireEvent=function(_d0,a,b,c,d){
if(!_d0){
return true;
}
RadTreeViewGlobalFirstParam=a;
RadTreeViewGlobalSecondParam=b;
RadTreeViewGlobalThirdParam=c;
RadTreeViewGlobalFourthParam=d;
var s=_d0+"(RadTreeViewGlobalFirstParam, RadTreeViewGlobalSecondParam, RadTreeViewGlobalThirdParam, RadTreeViewGlobalFourthParam);";
return eval(s);
};
RadTreeView.prototype.Focus=function(e){
this.FireEvent(this.AfterClientFocus,this);
};
RadTreeView.prototype.IsSet=function(a){
return (a!=null&&a!="");
};
RadTreeView.prototype.GetX=function(obj){
var pos=this.GetElementPosition(obj);
return pos.x;
};
RadTreeView.prototype.GetY=function(obj){
var pos=this.GetElementPosition(obj);
return pos.y;
};
RadTreeView.prototype.GetElementPosition=function(el){
var _dd=null;
var pos={x:0,y:0};
var box;
if(el.getBoundingClientRect){
box=el.getBoundingClientRect();
var _e0=document.documentElement.scrollTop||document.body.scrollTop;
var _e1=document.documentElement.scrollLeft||document.body.scrollLeft;
pos.x=box.left+_e1-2;
pos.y=box.top+_e0-2;
return pos;
}else{
if(document.getBoxObjectFor){
try{
box=document.getBoxObjectFor(el);
pos.x=box.x-2;
pos.y=box.y-2;
}
catch(e){
}
}else{
pos.x=el.offsetLeft;
pos.y=el.offsetTop;
_dd=el.offsetParent;
if(_dd!=el){
while(_dd){
pos.x+=_dd.offsetLeft;
pos.y+=_dd.offsetTop;
_dd=_dd.offsetParent;
}
}
}
}
if(window.opera){
_dd=el.offsetParent;
while(_dd&&_dd.tagName.toLowerCase()!="body"&&_dd.tagName.toLowerCase()!="html"){
pos.x-=_dd.scrollLeft;
pos.y-=_dd.scrollTop;
_dd=_dd.offsetParent;
}
}else{
_dd=el.parentNode;
while(_dd&&_dd.tagName.toLowerCase()!="body"&&_dd.tagName.toLowerCase()!="html"){
pos.x-=_dd.scrollLeft;
pos.y-=_dd.scrollTop;
_dd=_dd.parentNode;
}
}
return pos;
};
RadTreeView.prototype.PostBack=function(_e2,_e3){
var _e4=_e2+"#"+_e3;
if(this.PostBackOptionsClientString){
var _e5=this.PostBackOptionsClientString.replace(/@@arguments@@/g,_e4);
if(typeof (WebForm_PostBackOptions)!="undefined"||_e5.indexOf("_doPostBack")>-1||_e5.indexOf("AsyncRequest")>-1||_e5.indexOf("AsyncRequest")>-1||_e5.indexOf("AjaxNS")>-1){
eval(_e5);
}
}else{
if(this.CausesValidation){
if(!(typeof (Page_ClientValidate)!="function"||Page_ClientValidate())){
return;
}
}
var _e6=this.PostBackFunction.replace(/@@arguments@@/g,_e4);
eval(_e6);
}
};
RadTreeView.prototype.EscapeParameter=function(_e7){
var _e8=_e7.replace(/'/g,"&squote");
_e8=_e8.replace(/#/g,"&ssharp");
_e8=_e8.replace(/:/g,"&scolon");
_e8=_e8.replace(/\\/g,"\\\\");
return _e8;
};
RadTreeView.prototype.IsRootNodeTag=function(_e9){
if(_e9&&_e9.tagName=="DIV"&&_e9.id.indexOf(this.ID)>-1){
return true;
}
return false;
};
RadTreeView.prototype.SetBorderOnDrag=function(_ea,_eb,e){
if(this.DragAndDropBetweenNodes&&this.IsDragActive()){
this.LastDragNode=_ea;
var _ed=this.CalculateYPos(e);
var _ee=this.GetY(_eb);
if(_ed<_ee+_ea.TextElement().offsetHeight){
_eb.style.borderTop="1px dotted black";
this.LastDragPosition="above";
}else{
_eb.style.borderBottom="1px dotted black";
this.LastDragPosition="below";
}
this.LastBorderElementSet=_eb;
}
};
RadTreeView.prototype.ClearBorderOnDrag=function(_ef){
if(_ef&&this.DragAndDropBetweenNodes&&this.IsDragActive()){
_ef.style.borderTop="0px none black";
_ef.style.borderBottom="0px none black";
this.LastDragPosition="over";
}
};
RadTreeView.prototype.AttachEvent=function(_f0,_f1,_f2){
if(_f0.attachEvent){
_f0.attachEvent("on"+_f1,_f2);
}else{
if(_f0.addEventListener){
_f0.addEventListener(_f1,_f2,false);
}
}
};
RadTreeView.prototype.DetachEvent=function(_f3,_f4,_f5){
if(_f3.detachEvent){
_f3.detachEvent("on"+_f4,_f5);
}else{
if(_f3.removeEventListener){
_f3.removeEventListener(_f4,_f5,false);
}
}
};
RadTreeView.prototype.IsDragActive=function(){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].DragClone!=null){
return true;
}
}
return false;
};
RadTreeView.prototype.GetScrollBarWidth=function(){
try{
if(typeof (this.scrollbarWidth)=="undefined"){
var _f7,_f8=0;
var _f9=document.createElement("div");
_f9.style.position="absolute";
_f9.style.top="-1000px";
_f9.style.left="-1000px";
_f9.style.width="100px";
_f9.style.overflow="auto";
var _fa=document.createElement("div");
_fa.style.width="1000px";
_f9.appendChild(_fa);
document.body.appendChild(_f9);
_f7=_f9.offsetWidth;
_f8=_f9.clientWidth;
document.body.removeChild(document.body.lastChild);
this.scrollbarWidth=_f7-_f8;
if(this.scrollbarWidth<=0||_f8==0){
this.scrollbarWidth=16;
}
}
return this.scrollbarWidth;
}
catch(error){
return false;
}
};
function rtvIsAnyContextMenuVisible(){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].ContextMenuVisible){
return true;
}
}
return false;
}
function rtvAdjustScroll(){
if(RadTreeView_DragActive==null||RadTreeView_DragActive.DragClone==null||RadTreeView_Active==null){
return;
}
var _fc=RadTreeView_Active;
var _fd=document.getElementById(RadTreeView_Active.Container);
if(_fd){
var _fe,_ff;
_fe=_fc.GetY(_fd);
_ff=_fe+_fd.offsetHeight;
if((RadTreeView_MouseY-_fe)<50&&_fd.scrollTop>0){
_fd.scrollTop=_fd.scrollTop-10;
_fc.Scroll();
RadTreeView_ScrollTimeout=window.setTimeout(function(){
rtvAdjustScroll();
},100);
}else{
if((_ff-RadTreeView_MouseY)<50&&_fd.scrollTop<(_fd.scrollHeight-_fd.offsetHeight+16)){
_fd.scrollTop=_fd.scrollTop+10;
_fc.Scroll();
RadTreeView_ScrollTimeout=window.setTimeout(function(){
rtvAdjustScroll();
},100);
}
}
}
}
function rtvMouseUp(e){
if(RadTreeView_Active==null){
return;
}
if(e&&!e.ctrlKey){
for(var key in tlrkTreeViews){
if((typeof (tlrkTreeViews[key])!="function")&&tlrkTreeViews[key].ContextMenuVisible){
contextMenuToBeHidden=tlrkTreeViews[key];
window.setTimeout(function(){
if(contextMenuToBeHidden){
contextMenuToBeHidden.HideContextMenu();
}
},10);
return;
}
}
}
if(RadTreeView_DragActive==null||RadTreeView_DragActive.DragClone==null){
return;
}
(document.all)?e.returnValue=false:e.preventDefault();
var _102=RadTreeView_DragActive.DragSource;
var _103=RadTreeView_Active.LastHighlighted;
var _104=RadTreeView_Active;
var _105="over";
var _106;
if(_104.LastBorderElementSet){
_105=_104.LastDragPosition;
_106=_104.LastDragNode;
_104.ClearBorderOnDrag(_104.LastBorderElementSet);
}
if(_106){
_103=_106;
}
document.body.removeChild(RadTreeView_DragActive.DragClone);
RadTreeView_DragActive.DragClone=null;
if(_103!=null&&_103.DropEnabled==false){
return;
}
if(_102==_103){
return;
}
if(RadTreeView_DragActive.FireEvent(RadTreeView_DragActive.BeforeClientDrop,_102,_103,e,_105)==false){
return;
}
if(_102.IsClientNode||((_103!=null)&&_103.IsClientNode)){
return;
}
var _107=RadTreeView_DragActive.ClientID+"#"+_102.ClientID+"#";
var _108="";
if(_103==null){
_108="null"+"#"+RadTreeView_DragActive.HtmlElementID;
}else{
_108=_104.ClientID+"#"+_103.ClientID+"#"+_105;
}
if(_103==null&&RadTreeView_DragActive.HtmlElementID==""){
return;
}
var _109=_107+_108;
RadTreeView_DragActive.PostBack("NodeDrop",_109);
RadTreeView_DragActive.FireEvent(RadTreeView_DragActive.AfterClientDrop,_102,_103,e);
RadTreeView_DragActive=null;
}
function rtvMouseMove(e){
if(rtvIsAnyContextMenuVisible()){
return;
}
if(RadTreeView_DragActive!=null&&RadTreeView_DragActive.DragClone!=null){
var newX,newY;
RadTreeView_DragActive.DetermineDirection();
if(!RadTreeView_DragActive.RightToLeft){
newX=RadTreeView_DragActive.CalculateXPos(e)+8;
newY=RadTreeView_DragActive.CalculateYPos(e)+4;
}else{
newX=RadTreeView_DragActive.CalculateXPos(e)-RadTreeView_DragActive.DragClone.clientWidth-8;
if((document.body.dir.toLowerCase()=="rtl"||document.dir.toLowerCase()=="rtl")&&document.all&&!window.opera){
newX-=RadTreeView_DragActive.GetScrollBarWidth();
}
newY=RadTreeView_DragActive.CalculateYPos(e)+4;
}
RadTreeView_MouseY=newY;
rtvAdjustScroll();
RadTreeView_DragActive.DragClone.style.zIndex=999;
RadTreeView_DragActive.DragClone.style.top=newY+"px";
RadTreeView_DragActive.DragClone.style.left=newX+"px";
RadTreeView_DragActive.DragClone.style.display="block";
RadTreeView_DragActive.FireEvent(RadTreeView_DragActive.AfterClientMove,e);
}
}
function rtvNodeExpand(a,id,_10f){
var _110=document.getElementById(id);
var _111=_110.scrollHeight;
var step=(_111-a)/_10f;
var _113=a+step;
if(_113>_111-1){
_110.style.height="";
}else{
_110.style.height=_113+"px";
window.setTimeout("rtvNodeExpand("+_113+","+"'"+id+"',"+_10f+");",5);
}
}
function rtvNodeCollapse(a,id,_116){
var _117=document.getElementById(id);
var _118=_117.scrollHeight;
var step=(_118-Math.abs(_118-a))/_116;
var _11a=a-step;
if(_11a<=3){
_117.style.height="";
_117.style.display="none";
}else{
_117.style.height=_11a+"px";
window.setTimeout("rtvNodeCollapse("+_11a+","+"'"+id+"',"+_116+" );",5);
}
}
function rtvGetNodeID(e){
if(RadTreeView_Active==null){
return;
}
var _11c=(e.srcElement)?e.srcElement:e.target;
if(_11c.nodeType==3){
_11c=_11c.parentNode;
}
if(_11c.tagName=="IMG"&&_11c.nextSibling){
var _11d=_11c.className;
if(_11d){
_11d=parseInt(_11d);
if(_11d>12){
_11c=_11c.nextSibling;
}
}
}
if(_11c.id==RadTreeView_Active.ID){
return null;
}
if(_11c.id.indexOf(RadTreeView_Active.ID)>-1&&_11c.tagName=="DIV"){
return _11c.id;
}
while(_11c!=null){
if((_11c.tagName=="SPAN"||_11c.tagName=="A")&&rtvInsideNode(_11c)){
return _11c.parentNode.id;
}
_11c=_11c.parentNode;
}
return null;
}
function rtvInsideNode(_11e){
if(_11e.parentNode&&_11e.parentNode.tagName=="DIV"&&_11e.parentNode.id.indexOf(RadTreeView_Active.ID)>-1){
return _11e.parentNode.id;
}
}
function rtvDispatcher(t,w,e,p1,p2,p3){
if(!e){
e=window.event;
}
if(tlrkTreeViews){
var _125=rtvGetNodeID(e);
var _126=tlrkTreeViews[t];
if(!_126.IsBuilt){
return;
}
if(rtvIsAnyContextMenuVisible()&&w!="mclick"&&w!="cclick"){
return;
}
if(_126.EditMode){
return;
}
RadTreeView_Active=_126;
var _127=window.netscape&&!window.opera;
var _128=(navigator.userAgent.toLowerCase().indexOf("safari")!=-1);
switch(w){
case "mover":
if(_125!=null){
_126.MouseOverDispatcher(e,_125);
}
break;
case "mout":
if(_125!=null){
_126.MouseOutDispatcher(e,_125);
}
break;
case "mclick":
_126.MouseClickDispatcher(e);
break;
case "mdclick":
if(_125!=null){
_126.DoubleClickDispatcher(e,_125);
}
break;
case "mdown":
_126.MouseDown(e);
break;
case "mup":
_126.MouseUp(e);
break;
case "context":
if(_125!=null){
_126.ContextMenu(e,_125);
return false;
}
break;
case "cclick":
_126.ContextMenuClick(e,p1,p2,p3);
break;
case "focus":
_126.Focus(e);
case "keydown":
if(!_127&&!_128){
_126.KeyDown(e);
}
}
}
}
function rtvAppendStyleSheet(_129,_12a){
var _12b=(navigator.appName=="Microsoft Internet Explorer")&&((navigator.userAgent.toLowerCase().indexOf("mac")!=-1)||(navigator.appVersion.toLowerCase().indexOf("mac")!=-1));
var _12c=(navigator.userAgent.toLowerCase().indexOf("safari")!=-1);
if(_12b||_12c){
document.write("<"+"link"+" rel='stylesheet' type='text/css' href='"+_12a+"'>");
}else{
var _12d=document.createElement("LINK");
_12d.rel="stylesheet";
_12d.type="text/css";
_12d.href=_12a;
document.getElementById(_129+"StyleSheetHolder").appendChild(_12d);
}
}
function rtvInsertHTML(_12e,html){
if(_12e.tagName=="A"){
_12e=_12e.parentNode;
}
if(document.all){
_12e.insertAdjacentHTML("beforeEnd",html);
}else{
var r=_12e.ownerDocument.createRange();
r.setStartBefore(_12e);
var _131=r.createContextualFragment(html);
_12e.appendChild(_131);
}
}

//BEGIN_ATLAS_NOTIFY
if (typeof(Sys) != "undefined"){if (Sys.Application != null && Sys.Application.notifyScriptLoaded != null){Sys.Application.notifyScriptLoaded();}}
//END_ATLAS_NOTIFY
