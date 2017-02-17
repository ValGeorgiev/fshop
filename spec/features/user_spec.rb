require 'spec_helper'

RSpec.describe 'user', type: :feature do

  describe 'the signin process' do

  	it 'log me' do
  		visit '/'
  		click_button('login-button')
  		within '.login-form' do
        fill_in 'email', with: 'test@abv.bg'
        fill_in 'password', with: '123456'
      end

      click_button('logBtn')
      expect(page).to have_selector('.order-history')
		end

		it 'log me with wrong email' do
  		visit '/'
  		click_button('login-button')
  		within '.login-form' do
        fill_in 'email', with: 'no_valid@test.com'
        fill_in 'password', with: '123456'
      end

      click_button('logBtn')
      expect(page).to have_selector('.error-msg')
		end

		it 'log me with wrong password' do
  		visit '/'
  		click_button('login-button')
  		within '.login-form' do
        fill_in 'email', with: 'test@abv.bg'
        fill_in 'password', with: 'no_valid'
      end

      click_button('logBtn')
      expect(page).to have_selector('.error-msg')
		end

		it 'log out' do
  		visit '/'
  		click_button('login-button')
  		within '.login-form' do
        fill_in 'email', with: 'test@abv.bg'
        fill_in 'password', with: '123456'
      end

      click_button('logBtn')
      click_link('logout')
      expect(page).to have_selector('#login-button')
		end


  end
end
