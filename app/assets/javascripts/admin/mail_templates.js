$().ready(function() {
mailTemplateId = getURLParameter('mail_template_id');
if (mailTemplateId != null )
  $('a.sv-mail-template-' + mailTemplateId).click();
});

function getURLParameter(name) {
    return decodeURI(
        (RegExp(name + '=' + '(.+?)(&|$)').exec(location.search)||[,null])[1]
    );
}
