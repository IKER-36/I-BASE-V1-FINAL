this.console.log('streetandcompas JS loaded');
$(function(){
    window.addEventListener("message", function(event){   
        if(event.data.action == 'setStreetName'){
            $('.streetname').text(event.data.streetname);
        };
    });
});