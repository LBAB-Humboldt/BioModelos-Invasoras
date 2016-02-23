class ApplicationMailer < ActionMailer::Base
  default from: "noreply@biomodelos.humboldt.org.co"
  layout 'mailer'
#****************** FRANK CODE *************************
   # Función para el envío de Errores notificados en puntos geográficos
  def error_point_email(email_from, email_to, name, user, point_error, species)
    @email_from = email_from
    @email = email_to
    @point_error = point_error
    @name = name
    @user=user
    @datetime = DateTime.now
    @species = species
    subject = "Has Recibido un error en un punto desde Biomodelos"
    mail to: email_to,  subject: subject
  end
#****************** END FRANK CODE *************************
 
end
