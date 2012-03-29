class Admin::AccountsController < Admin::AdminController

  def index
    @accounts = Account.all
  end

  def new
    @account = Account.new
  end

  def edit
    @account = Account.find params[:id]
  end

  def update
    @account = Account.find params[:id]
    @account.update_attributes(params[:account])
    redirect_to admin_accounts_path, notice: 'Account successfully updated!'
  end

  def create
    @account = Account.new params[:account]
    @account.save
    redirect_to admin_accounts_path, notice: 'Account successfully created!'
  end

end
