(function($){
	$.fn.SetProgressValue=function(val){
		$(this).css("width",val+"%");	
	};
	$.ShowDialog=function(text,dialog){
		if (typeof dialog==undefined){
			$("#Dialog_Info").text(text);
			$("#Dialog_Info").dialog("open");
		}else{
			$("#"+dialog).text(text);
			$("#"+dialog).dialog("open");
		}
	};
	$.fn.ShowDialog=function(text){
		$(this).text(text);
		$(this).dialog("open");	
	}
	$.fn.AddOption=function(name,val){
		$(this).append("<option value=\""+val+"\">"+name+"</option>");	
	}
	$.fn.CheckIsEmpty=function(group){
		if ($(this).val()==""){
			$("#"+group).attr("class","form-group has-error");	
		}else{
			$("#"+group).attr("class","form-group has-success");	
		}
	}
})(jQuery);