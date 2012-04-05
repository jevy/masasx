class Admin::AccountsController < Admin::AdminController

  before_filter :authenticate_organization_admin!

  def index
    @accounts = current_organization_admin.organization.accounts
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find params[:id]
  end

  def destroy
    @account = Account.find params[:id]
    @account.destroy
    redirect_to admin_accounts_path, notice: 'Account successfully removed!'
  end

  def permissions
    @account = Account.find params[:id]
  end

  def update_permissions
    @account = Account.find params[:id]
    @account.permissions_attributes = params[:account][:permissions_attributes]
    @account.save
    redirect_to admin_accounts_path, notice: 'Permissions successfully updated!'
  end

  def update
    @account = Account.find params[:id]
    @account.update_attributes(params[:account])
    redirect_to admin_accounts_path, notice: 'Account successfully updated!'
  end

  def create
    @account              = Account.new params[:account]
    @account.organization = current_organization_admin.organization
    @account.save
    redirect_to admin_accounts_path, notice: 'Account successfully created!'
  end

  def toggle_enabled
    @account = Account.find params[:id]
    @account.toggle! :enabled
    redirect_to admin_accounts_path, notice: "Account successfully #{@account.enabled? ? 'enabled' : 'disabled'}!"
  end

end
