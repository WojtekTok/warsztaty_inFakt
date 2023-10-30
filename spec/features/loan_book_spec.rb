require 'rails_helper'

RSpec.describe 'Loan Book', type: :feature do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  before do
    login_as(user, scope: :user)
    visit books_path
  end

  context 'when a user loans a book' do
    it 'displays a success message' do
      click_button 'Loan'
      expect(page).to have_content('Book Loan was successfully created.')
    end

    it 'updates the book status to "Loaned"' do
      click_button 'Loan'
      book.reload
      expect(book_loan.status).to eq('Loaned')
    end
  end

  context 'when a user attempts to loan an already loaned book' do
    before { book.update(status: 'Loaned') }

    it 'displays an error message' do
      click_button 'Loan Book'
      expect(page).to have_content('This book is already loaned.')
    end

    it "does not change the book's status" do
      click_button 'Loan Book'
      book.reload
      expect(book.status).to eq('Loaned')
    end
  end

  context 'when a user loans a book that is out of stock' do
    before { book.update(stock: 0) }

    it 'displays an error message' do
      click_button 'Loan Book'
      expect(page).to have_content('This book is out of stock.')
    end

    it "does not change the book's status" do
      click_button 'Loan Book'
      book.reload
      expect(book.status).to eq('Available')
    end
  end
end
