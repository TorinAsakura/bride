class Admin::Bonus::CertificatesController < AdminController
  layout 'admin_application'
  respond_to :html

  before_filter :set_certificate, only: [:edit, :update, :destroy]

  def index
    @certificates = ::Bonus::Certificate.all
    respond_with @certificates
  end

  def new
    @certificate = ::Bonus::Certificate.new
    respond_with @certificate
  end

  def create
    @certificate = ::Bonus::Certificate.new(params[:bonus_certificate])
    respond_with @certificate do |format|
      if @certificate.save
        format.html{ redirect_to admin_bonus_certificates_path}
      else
        format.html { render action: 'new' }
      end
    end
  end

  def edit
    respond_with @certificate
  end

  def update
    respond_with @certificate do |format|
      if @certificate.update_attributes(params[:bonus_certificate])
        format.html{ redirect_to admin_bonus_certificates_path}
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def destroy
    @certificate.cancel!
    @certificate.destroy
    respond_with @certificate do |format|
      format.html{ redirect_to admin_bonus_certificates_path}
    end
  end

  protected
  def set_certificate
    @certificate = ::Bonus::Certificate.find params[:id]
  end
end