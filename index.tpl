<html>
<head>
  <title>Homebank - déclaration de dépense</title>
  <meta http-equiv="content-type" content="text/html; charset=utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">

  <script type="text/javascript" src="js/jquery-2.2.3.js"></script>
  <script type="text/javascript" src="js/moment-with-locales.js"></script>
  <script type="text/javascript" src="js/transition.js"></script>
  <script type="text/javascript" src="js/collapse.js"></script>
  <script type="text/javascript" src="js/bootstrap.min.js"></script>
  <script type="text/javascript" src="js/bootstrap-datetimepicker.min.js"></script>

  <link rel="stylesheet" href="css/bootstrap.min.css" />
  <link rel="stylesheet" href="css/bootstrap-theme.min.css" />
  <link rel="stylesheet" href="css/bootstrap-datetimepicker.css" />
  <link rel="stylesheet" href="css/custom.css" />
</head>


<body style="overflow-x: hidden;">


<script type="text/javascript">
  $(function () {
    $('#dbdate').datetimepicker({
      format: 'DD/MM/YYYY',
      locale: 'fr'
    });
  });
</script>





<form class="form-horizontal" method="post">
<fieldset>

<!-- Alert bar -->
<TMPL_IF NAME="ALERT">
<div class="form-group">
  <label class="col-md-4 control-label" for="alertbar"></label>
  <div class="col-md-4 alert <TMPL_VAR ALERT_STYLE>">
    <strong><TMPL_VAR ALERT_RES></strong> <TMPL_VAR ALERT_MSG>
  </div>
</div>
</TMPL_IF>

<!-- Form Name -->
<div class="form-group">
  <label class="col-md-4 control-label" for="titleinput"></label>  
  <div class='col-md-4'>
    <label>Homebank - déclaration de dépense</label>
  </div>
</div>

<!-- Date input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="textinput">Date</label>  
  <div class='col-md-2'>
    <div class='input-group date' id='dbdate'>
      <input id="dateinput" name="dateinput" placeholder="placeholder" class="form-control input-md" type='text' />
      <span class="input-group-addon">
        <span class="glyphicon glyphicon-calendar"></span>
      </span>
    </div>
    <span class="help-block">Saisir la date de la dépense</span>
  </div>
</div>

<!-- Text input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="textinput">Montant</label>  
  <div class="col-md-4">
    <input id="textinput" name="textinput" placeholder="placeholder" class="form-control input-md" type="text">
    <span class="help-block">Saisir le montant (symbole + : vous gagnez de l'argent, symbole - : vous perdez de l'argent</span>  
  </div>
</div>

<!-- Select Basic -->
<div class="form-group">
  <label class="col-md-4 control-label" for="selectbasic">Catégorie</label>
  <div class="col-md-4">
    <select id="selectbasic" name="selectbasic" class="form-control">
<TMPL_VAR NAME=CATEGORIES>
    </select>
    <span class="help-block">Sélectionner la catégorie de la dépense</span>  
  </div>
</div>

<!-- Text input-->
<div class="form-group">
  <label class="col-md-4 control-label" for="textinputdesc">Description</label>  
  <div class="col-md-4">
    <input id="textinputdesc" name="textinputdesc" placeholder="placeholder" class="form-control input-md" type="text">
    <span class="help-block">Saisir la description de la dépense</span>  
  </div>
</div>

<!-- Button (Double) -->
<div class="form-group">
  <label class="col-md-4 control-label" for="button1id"></label>
  <div class="col-md-4 controlbuttons">
    <button id="button1id" name="button1id" class="btn btn-success">Valider</button>
    <button id="button2id" name="button2id" class="btn btn-danger">Annuler</button>
  </div>
</div>

</fieldset>
</form>


</body>

</html>
