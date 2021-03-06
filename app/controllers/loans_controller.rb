class LoansController < ApplicationController
  before_filter :require_user
  
  # GET /loans/new
  def new
    @loan = Loan.new
    @loan.book = current_user.books.find(params[:book_id])
  
    if params[:borrower_login]
      @borrower_login = params[:borrower_login]
    else
      @borrower_login = ''
    end
  end
  
  # POST /loans
  def create
    @loan = Loan.new(params[:loan])
    @loan.book = current_user.books.find(params[:book_id])
    @loan.borrower = User.find_by_login(params[:borrower_login])
    @loan.lender = current_user
    
    if @loan.save
      @loan.book.update_attribute :status, StaticData::BOOK_STATUS['ONLOAN']
#       current_user.update_attribute :default_loan_period_weeks, params[:loan_period_qty].to_i
      redirect_to :lent, :notice => "Book lent OK"
    else
      redirect_to :books, :alert => "That didn't work"
    end
  end
  
  # PUT /loans/1
  # PUT /loans/1.xml
  def update
    @loan = current_user.active_loans.find(params[:id])
    @loan.returned = Time.now

    respond_to do |format|
      if @loan.save
        @loan.book.update_attribute :status, StaticData::BOOK_STATUS['AVAILABLE']

        format.html { redirect_to(:lent, :notice => 'Book checked in OK') }
#         format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
#         format.xml  { render :xml => @loan.errors, :status => :unprocessable_entity }
      end
    end
  end
end
