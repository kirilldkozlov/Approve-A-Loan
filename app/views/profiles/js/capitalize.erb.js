function toTitleCase(str) {
    return str.replace(/\w\S*/g, function(txt) {
      return txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase();
    });
}

document.getElementById("capitalizeText").addEventListener('keyup',function(e){
        capitalizeText.value = toTitleCase(capitalizeText.value);
});
