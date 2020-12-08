class Admin::MailTemplatesController < AdminController
  layout 'admin_application'
  before_filter :find_mail_template, except: [:index, :new, :create]

  def index
    @mail_templates = MailTemplate.all
    @mail_template = MailTemplate.find(params[:mail_template_id]) if params[:mail_template_id]
  end

  def show
  end

  def new
    @mail_template = MailTemplate.new
  end

  def edit
    render :new
  end

  def create
    @mail_template = MailTemplate.new(params[:mail_template])
    if @mail_template.save 
      redirect_to admin_mail_templates_path(mail_template_id: @mail_template.id), notice: 'Шаблон успешно создан'
    else
      redirect_to admin_mail_templates_path, notice: 'Неверно заполены форма создания шаблона'
    end
  end

  def update
    if @mail_template.update_attributes(params[:mail_template])
      redirect_to admin_mail_templates_path(mail_template_id: @mail_template.id), notice: 'Шаблон успешно обновлён'
    else
      redirect_to admin_mail_templates_path, notice: 'Неверно заполены форма создания шаблона'
    end
  end

  def destroy
    @mail_template.destroy
    redirect_to admin_mail_templates_path, notice: 'Шаблон успешно удалён'
  end

  def send_mails
    emails = []
    emails += Client.get_emails(params[:gender]) if params[:gender].present?
    emails += Firm.get_emails if params[:firm].present?      
    notice = if emails.present?
      @mail_template.update_attribute(:send_date, Date.today) 
      @mail_template.send_to(emails)
      'Рассылка письма пользователем произошла успешно'
    else
      'Рассылку некому раcсылать'
    end
    redirect_to admin_mail_templates_path, notice: notice 
  end

  private 
  def find_mail_template
    @mail_template = MailTemplate.find(params[:id])
  end
end
