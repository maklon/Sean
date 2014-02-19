function setProgressValue(who,val){
	$("#"+who).css("width",val+"%");	
}

function ShowDialog(dialog,text){
	$("#"+dialog).text(text);
	$("#"+dialog).dialog("open");	
}