$(document).ready(function() {    

  $(document).ajaxStart(function(){
      showPreLoader();
   });


  /*** DEPENDENTES COCOON ***/
  $("#dependents a.add_fields").
  data("association-insertion-position", 'before').
  data("association-insertion-node", 'this');
});

$("#dependents a.add_fields").
on('cocoon:after-insert', function(e, insertedItem) {
 $('.date-picker').datetimepicker({ format:"DD/MM/YYYY", locale: 'pt-BR' });
});
/*** FIM DEPENDENTES ***/


jQuery(function($){
  //add odd even em tr para impressão
  $("#filterrific_results > table > tbody > tr:odd").addClass("odd");
  $("#filterrific_results > table > tbody > tr:not(.odd)").addClass("even");  
  
 

  $(".best_in_place").best_in_place();
  $('.best_in_place').bind("ajax:success", function () { window.location.reload(); }); 



  if ($("#my_camera").length) {
    Webcam.set({
      width: 200,
      height: 150,
      image_format: 'jpeg',
      jpeg_quality: 90,
      force_flash: false,
        // flip horizontal (mirror mode)
        flip_horiz: true
      });

    Webcam.attach( '#my_camera' );
  }

  //busca de cidade e estado pelo CEP
  buscaCEP()

  //mascaras
  mascaras();


  //Date
  loadDateField();

   if ($('.html-editor')[0]) {
     $('.html-editor').summernote({
            height: 150
        });
    }

  //Quando o campo cep perde o foco.
  object = $('[id*="_zipcode"]');
  object_zipcode = "#"+object.attr('id');
  $(object_zipcode).blur(function() {
    //busca de cidade e estado pelo CEP
    buscaCEP()
  });



  
});

function mascaras(){
  $(".mask-phone").mask("(99) 9 9999-9999");
  $(".mask-phone-fixo").mask("(99) 9999-9999");
  $(".mask-date").mask("99/99/9999");
  $(".mask-rg").mask("9.999.999");
  $(".mask-cpf").mask("999.999.999-99");
  $(".mask-cnpj").mask("99.999.999/9999-99");
  $(".mask-cep").mask("99999-999");

    $(".money").maskMoney({
         decimal: ".",
         thousands: ""
     });
}

function loadDateField() {
  if ($('.date-picker')[0]) {
    $('.date-picker').datetimepicker({
        format: 'DD/MM/YYYY'
    });

    $('.clear_field').on('click', function() {
      var datePicker = $(this).closest('.input-group').find('.date-picker')

      if (datePicker[0]) {
        datePicker.val("");
      }
    });
  }  
}


function take_snapshot(){
  $("#my_camera").removeClass('hide')
  Webcam.snap(function(data_uri) {
    id = $('[id*="_photo"]');

    if (id.length) {
      id.val(data_uri);
    }

    Webcam.freeze();
    document.getElementById('pre_take_buttons').style.display = 'none';
    document.getElementById('post_take_buttons').style.display = '';
  });
}

function cancel_preview() {
  $("#my_camera").removeClass('hide')
  id = $('[id*="_photo"]');

  if (id.length) {
    id.val(null);
  }

  // cancel preview freeze and return to live camera feed
  Webcam.unfreeze();
  
  // swap buttons back
  document.getElementById('pre_take_buttons').style.display = '';
  document.getElementById('post_take_buttons').style.display = 'none';
  document.getElementById('preview_photo').style.display = 'none';
}


function validarCpf(cpf_field) {
  jQuery(cpf_field).blur(function(){
        var cpf = jQuery(cpf_field).val().replace(/[^0-9]/g, '').toString();
        if(cpf.length == 11){
            var v = [];
            //Calcula o primeiro dígito de verificação.
            v[0] = 1 * cpf[0] + 2 * cpf[1] + 3 * cpf[2];
            v[0] += 4 * cpf[3] + 5 * cpf[4] + 6 * cpf[5];
            v[0] += 7 * cpf[6] + 8 * cpf[7] + 9 * cpf[8];
            v[0] = v[0] % 11;
            v[0] = v[0] % 10;
            //Calcula o segundo dígito de verificação.
            v[1] = 1 * cpf[1] + 2 * cpf[2] + 3 * cpf[3];
            v[1] += 4 * cpf[4] + 5 * cpf[5] + 6 * cpf[6];
            v[1] += 7 * cpf[7] + 8 * cpf[8] + 9 * v[0];
            v[1] = v[1] % 11;
            v[1] = v[1] % 10;

             var _error = jQuery(cpf_field).closest('div').find('.error')

            //Retorna Verdadeiro se os dígitos de verificação são os esperados.
            if ((v[0] != cpf[9]) || (v[1] != cpf[10])){               
                if (_error.length == 0) {
                  jQuery(cpf_field).closest('div').addClass('field_with_errors');
                  jQuery(cpf_field).closest('div').append('<span class="error">inválido</span>');
                } else {
                  _error.addClass("highlight");
                    setTimeout(function () {
                          _error.removeClass('highlight');
                    }, 2000);
                  }
                
                jQuery(cpf_field).val("");
                jQuery(cpf_field).focus();
            }else{
                _error.remove()
            }
        }else{
            // jQuery(cpf_field).css("border","2px solid red");
             var _error = jQuery(cpf_field).closest('div').find('.error')
                if (_error.length == 0) {
                  jQuery(cpf_field).closest('div').addClass('field_with_errors');
                  jQuery(cpf_field).closest('div').append('<span class="error">inválido</span>');
                } else {
                  _error.addClass("highlight");
                    setTimeout(function () {
                          _error.removeClass('highlight');
                    }, 2000);
                  }
                
                jQuery(cpf_field).val("");
                jQuery(cpf_field).focus();
        }
    });
}


function dateRangePicker(elementId) {
  $(elementId).daterangepicker({
    "showDropdowns": false,
    "minYear": 2010,
    "opens": "center",
    ranges: {
        'Hoje': [moment(), moment()],
        'Ontem': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
        'Últimos 7 dias': [moment().subtract(6, 'days'), moment()],
        'Últimos 30 dias': [moment().subtract(29, 'days'), moment()],
        'Este mês': [moment().startOf('month'), moment().endOf('month')],
        'Mês passado': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
    },
    "locale": {
        "format": "DD/MM/YYYY",
        "separator": " - ",
        "applyLabel": "Aplicar",
        "cancelLabel": "Cancelar",
        "fromLabel": "De",
        "toLabel": "Até",
        "customRangeLabel": "Customizado",
        "weekLabel": "W",
        // "daysOfWeek": [
        //     "Dom",
        //     "Seg",
        //     "Ter",
        //     "Qua",
        //     "Qui",
        //     "Sex",
        //     "Sab"
        // ],
        // "monthNames": [
        //     "Janeiro",
        //     "Fevereiro",
        //     "Março",
        //     "Abril",
        //     "Maio",
        //     "Junho",
        //     "Julho",
        //     "Agosto",
        //     "Setembro",
        //     "Outubro",
        //     "Novembro",
        //     "Dezembro"
        // ],
        "firstDay": 0
    },
    "alwaysShowCalendars": true,    
  });
}


//busca de cidade e estado pelo CEP
function buscaCEP() {

  object = $('[id*="_zipcode"]');
  object_zipcode = "#"+object.attr('id');

  if (object.length) {
    object_city = "#"+$('[id*="_city"]').attr('id');
    object_state = "#"+$('[id*="_state"]').attr('id');
    object_burgh = "#"+$('[id*="_burgh"]').attr('id');
    object_address = "#"+$('[id*="_address"]').attr('id');

    //Nova variável "cep" somente com dígitos.
    var cep = $(object_zipcode).val().replace(/\D/g, '');

    //Verifica se campo cep possui valor informado.
    if (cep != "") {
      //Expressão regular para validar o CEP.
      var validacep = /^[0-9]{8}$/;

      //Valida o formato do CEP.
      if(validacep.test(cep)) {

        //Preenche os campos com "..." enquanto consulta webservice.
        //$("#people_associated_burgh").val("...")
        $(object_city).val("...")
        $(object_state).val("...")
        $(object_burgh).val("...")
        $(object_address).val("...")


        //Consulta o webservice viacep.com.br/
        $.getJSON("//viacep.com.br/ws/"+ cep +"/json/?callback=?", function(dados) {
          console.log(dados)
          if (!("erro" in dados)) {
            //Atualiza os campos com os valores da consulta.
            $(object_address).val(dados.logradouro).closest('.fg-line')//.addClass('fg-toggled');
            $(object_burgh).val(dados.bairro).closest('.fg-line')//.addClass('fg-toggled');
            $(object_city).val(dados.localidade).closest('.fg-line')//.addClass('fg-toggled');
            $(object_state).val(dados.uf).closest('.fg-line')//.addClass('fg-toggled');
            $(object_burgh).val(dados.bairro).closest('.fg-line')//.addClass('fg-toggled');
            $(object_address).val(dados.logradouro).closest('.fg-line')//.addClass('fg-toggled');
          } //end if.
          else {
            //CEP pesquisado não foi encontrado.
            limpaFormCEP();
            notificationCEP("CEP não encontrado.");
            $(object_city+", "+object_state).closest('.fg-line')//.removeClass('fg-toggled');
          }
        });
      } //end if.
      else {
        //cep é inválido.
        limpaFormCEP();
        notificationCEP("Formato de CEP inválido.");
        $(object_city+", "+object_state).closest('.fg-line')//.removeClass('fg-toggled');
      }
    } //end if.
    else {
      //cep sem valor, limpa formulário.
      limpaFormCEP();
    }
  }
}

function limpaFormCEP() {
  object_city = "#"+$('[id*="_city"]').attr('id');
  object_state = "#"+$('[id*="_state"]').attr('id');

  // Limpa valores do formulário de cep.
  //$("#people_associated_burgh").val("");
  $(object_city).val("");
  $(object_state).val("");
}

function notificationCEP(text) {
  object = $('[id*="_zipcode"]');
  object_zipcode = "#"+object.attr('id');

  swal("OPSSS!", text, "warning")
  $(object_zipcode).val("").focus();
}


function showPreLoader(target) {
  $(".preloader").fadeIn();
  $(".content-preloader").hide();
}

function hiddenPreLoader(target) {
  $(".preloader").fadeOut();
  $(".content-preloader").fadeIn();
}


function showFullLoader(target) {
  $(".page-loader").fadeIn();
}

function hiddenFullLoader(target) {
  $(".page-loader").fadeOut();  
}

function loadSelectPicker() {
    $(".mask-date").mask("99/99/9999");
    
  $('.selectpicker').each(function () {
    $(this).selectpicker();      
  });
}



function notify(msg, type){
  $.growl({
    title: '',
    message: msg,
    url: ''
  },{
    element: 'body',
    type: type,
    allow_dismiss: true,
    placement: {
      from: "top",
      align: "center"
    },
    offset: {
      x: 20,
      y: 85
    },
    spacing: 10,
    z_index: 99999,
    delay: 5000,
    timer: 1000,
    url_target: '_blank',
    mouse_over: false,                        
    icon_type: 'class',
    template: '<div data-growl="container" class="alert" role="alert">' +
    '<button type="button" class="close" data-growl="dismiss">' +
    '<span aria-hidden="true">&times;</span>' +
    '<span class="sr-only">Close</span>' +
    '</button>' +
    '<span data-growl="icon"></span>' +
    '<span data-growl="title"></span>' +
    '<span data-growl="message"></span>' +
    '<a href="#" data-growl="url"></a>' +
    '</div>'
  });
};