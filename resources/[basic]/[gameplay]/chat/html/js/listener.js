var area = document.getElementById('textarea');
if (area.addEventListener) {
  area.addEventListener('input', (res) => {
    console.log(area.value)
  },false)
} else if (area.attachEvent) {
  area.attachEvent('onpropertychange', (res) => {
    console.log(res)
  });
}

console.log('Hola')