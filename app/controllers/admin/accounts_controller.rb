class Admin::AccountsController < Admin::AdminController

  def index
    @accounts = current_user.organization.accounts
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find params[:id]
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
    @account.organization = current_user.organization
    @account.save
    redirect_to admin_accounts_path, notice: 'Account successfully created!'
  end

end
