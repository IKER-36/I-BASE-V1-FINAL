
$( document ).ready(function() {
    $("#page").hide();
});

window.addEventListener('message', function (event) {


    var edata = event.data;

   if(edata.type == "toggle") {

    if (edata.value) {
        $("#page").show();
    } else {
         $("#page").hide();
    }

       
        
   }


   if(edata.type == "update") {

         $("#page").show();
        $("#u720-4").text(edata.online);
        $("#u753-4").text(edata.id);
         $("#u762-4").text(edata.money);
          $("#u771-4").text(edata.bank);
           $("#u780-4").text(edata.job);
        
   }


});