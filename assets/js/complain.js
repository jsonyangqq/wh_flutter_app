function quit() {
//    $(".contains").hide()
      window.history.go(-1);
}

function complain(){
    if($("#textarea").val() == ""){
        console.log("请填写申诉内容");
    }else{
        console.log($("#textarea").val());
        $(".contains").hide()
    }
}