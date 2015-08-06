$( document ).ready(function(){
	$(".button-collapse").sideNav();

	$(".datepicker").pickadate({
    selectMonths: true,
    selectYears: 20,
    max: true
  })

  $('select').material_select();
})