require 'spec_helper'

RSpec.describe 'actions', type: :feature do

  describe 'user actions' do

    before :each do
      visit '/'
      click_button('login-button')
      within '.login-form' do
        fill_in 'email', with: 'test@abv.bg'
        fill_in 'password', with: '123456'
      end

      click_button('logBtn')
    end


    it 'go to orders page' do
      visit '/'
      click_link('order-link')

      expect(page).to have_content('Orders History')
    end

  	it 'go to cart page' do
  		click_link('bag-link')

      expect(page).to have_content('Your Cart')
		end


    it 'go to checkout page without products' do
      visit '/checkout'

      expect(page).to have_content("Sorry, but you don't have any items in the basket!")
    end

    # it 'go to checkout page with products', :js => true do
    #   visit '/'

    #   click_link('product-modal')
    #   click_button('add-product-button')

    #   expect(page).to have_content('Your product was added successfully!')

    #   visit '/checkout'

    #   expect(page).to have_content('You are almost there! Keep going!')

    # end

    # it 'checkout', :js => true do
    #   visit '/'

    #   click_link('product-modal')
    #   click_button('add-product-button')

    #   expect(page).to have_content('Your product was added successfully!')

    #   visit '/checkout'

    #   within '.checkoutForm' do
    #     fill_in 'city', with: 'Test City'
    #     fill_in 'address', with: 'Test Address'
    #   end

    #   click_button('buy-button')

    #   expect(page).to have_content('Checkout is successful!')
    #   expect(page).to have_content('Address: Test Address')
    #   expect(page).to have_content('City: Test City')

    # end

  end
end
