class BookLoansController < ApplicationController
  before_action :set_book_loan, only: %i[cancel]
  before_action :prepare_book_loan, only: %i[create]

  def create
    respond_to do |format|
      if @book_loan.save
        format.html { redirect_to book_url(book), notice: flash_notice }
        format.json { render :show, status: :created, location: @book_loan }
        notice_calendar
      else
        format.html { redirect_to book_url(book), alert: @book_loan.errors.full_messages.join(', ') }
        format.json { render json: @book_loan.errors, status: :unprocessable_entity }
      end
    end
  end

  def cancel
    respond_to do |format|
      if @book_loan.cancelled!
        format.html { redirect_to book_requests_path, notice: flash_notice }
        format.json { render :show, status: :ok, location: book }
        delete_event if @book_loan.event_id.present?
      end
    end
  end

  private

  delegate :book, to: :@book_loan

  def prepare_book_loan
    @book_loan = current_user.book_loans.new(book_id: book_loan_params, due_date: Time.zone.today + 14.days)
  end

  def set_book_loan
    @book_loan = current_user.book_loans.find(params[:id])
  end

  def book_loan_params
    params.require(:book_id)
  end

  def notice_calendar
    user_calendar_notifier = UserCalendarNotifier.new(current_user, book)
    event = user_calendar_notifier.insert_event

    return unless event.present?

    @book_loan.update(event_id: event.id)
  end

  def delete_event
    user_calendar_notifier = UserCalendarNotifier.new(current_user, book)
    user_calendar_notifier.delete_event(@book_loan.event_id)
    @book_loan.update(event_id: nil)
  end
end
