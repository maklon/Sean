(function($){
	$.SetProgressValue=function(val,who){
		if (typeof who==undefined){
			$("#ProgressValue").css("width",val+"%");
		}else{
			$("#"+who).css("width",val+"%");
		}
	};
	$.ShowDialog=function(text,dialog){
		if (typeof dialog==undefined){
			$("#DialogInterfact_Info").text(text);
			$("#DialogInterfact_Info").dialog("open");
		}else{
			$("#"+dialog).text(text);
			$("#"+dialog).dialog("open");
		}
	};
	$.fn.AddOption=function(name,val){
		$(this).append("<option value=\""+val+"\">"+name+"</option>");	
	}
})(jQuery);