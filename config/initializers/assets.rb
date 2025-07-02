# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( template/vendors/fullcalendar/dist/fullcalendar.min.css template/vendors/animate.css/animate.min.css 
template/vendors/sweetalert/dist/sweetalert.css template/vendors/material-design-iconic-font/dist/css/material-design-iconic-font.min.css template/jstree/treeview.css 
 template/jstree/style.min.css template/vendors/malihu-custom-scrollbar-plugin/jquery.mCustomScrollbar.min.css template/vendors/chosen/chosen.css template/vendors/eonasdan-bootstrap-datetimepicker/bootstrap-datetimepicker.min.css 
template/vendors/bootstrap-select/dist/bootstrap-select.css template/vendors/select2.css template/vendors/select2-bootstrap.css template/vendors/modal-fullscreen.css template/app_1.min.css template/app_2.min.css font-awesome.min.css filterrific/filterrific-spinner.gif
custom.css print.css easy-autocomplete.min.css easy-autocomplete.themes.min.css template/vendors/summernote/dist/summernote.css template/daterangepicker.css template/comboTreePlugin.css)

Rails.application.config.assets.precompile += %w( template/jquery.min.js template/jquery_ujs.js template/turbolinks.js template/bootstrap.min.js template/jquery.flot.js template/jquery.flot.resize.js 
template/curvedLines.js template/jquery.sparkline.min.js template/jquery.easypiechart.min.js template/moment.min.js template/fullcalendar.min.js template/fullcalendar_pt-br.js 
template/jquery.simpleWeather.min.js template template/jstree.min.js template/waves.min.js template/bootstrap-growl.min.js template/sweetalert.min.js template/jquery.mCustomScrollbar.concat.min.js 
template/jquery.placeholder.min.js template/chosen.jquery.js template/bootstrap-select.js template/app.min.js template/mediaelement-and-player.min.js template/jquery.bootgrid.updated.min.js 
template/bootstrap-select-pt_BR.js template/bootstrap-datetimepicker.min.js template/datepicker-pt-BR.js template/cocoon.js filterrific/filterrific-jquery.js template/select2.js template/select2_locale_pt-BR.js template/app.min.js jquery.maskedinput.min.js webcam.js sinsems.js highcharts.js chartkick.js
jquery.bootstrap.wizard.min.js jquery.easy-autocomplete.min.js mask.js  template/fileinput.min.js best_in_place.js jquery.maskMoney.min.js summernote-updated.min.js template/daterangepicker.min.js template/comboTreePlugin.js)

# Be sure to restart your server when you modify this file.