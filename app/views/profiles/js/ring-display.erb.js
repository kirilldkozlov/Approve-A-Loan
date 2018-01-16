// Fetch values from index.html.erb
var verdict = document.getElementById('verdict').value;
var percentage = document.getElementById('confidence').value;

// Set condition variables
var type_condition = (verdict == "1.0");
var text = type_condition ? "Approved" : "Denied";
var class_name = type_condition ? "approved" : "denied";
var color_ring = type_condition ? '#144900' : '#b02f26';

// Set the circle
var bar = new ProgressBar.Circle(ring, {
  strokeWidth: 6,
  easing: 'easeOutBounce',
  duration: 3250,
  color: color_ring,
  trailColor: '#d9d9d9',
  text: {
      value: text,
      className: 'progressbar__label ${class_name}',
      autoStyle: false
  },
  trailWidth: 0.75,
  svgStyle: null
});

// Function to delay the animation
function execute() {
  bar.animate(parseFloat(percentage));
}

// Delay and execution
setTimeout(execute, 1700);
