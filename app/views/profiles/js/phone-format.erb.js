function phoneFormat(input){
        // Variables
        input = input.replace(/\D/g,'');
        input = input.substring(0,10);
        var size = input.length;

        if(size == 0){
                input = input;
        }else if(size < 4){
                input = '('+input;
        }else if(size < 7){
                input = '('+input.substring(0,3)+') '+input.substring(3,6);
        }else{
                input = '('+input.substring(0,3)+') '+input.substring(3,6)+' - '+input.substring(6,10);
        }
        return input;
}

document.getElementById("phoneNumber").addEventListener('keyup',function(e){
        phoneNumber.value = phoneFormat(phoneNumber.value);
});
