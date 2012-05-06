require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signup page" do
    before {visit signup_path}

    it {should have_selector('h1',     text: 'Sign up')}
    it {should have_selector('title',  text: full_title('Sign up'))}
  end

  describe "signup" do

    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "error messages" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should have_content("Name can't be blank") }
        it { should have_content("Password can't be blank") }
        it { should have_content("Email can't be blank") }
        it { should have_content('Email is invalid') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
        it { should have_content("Password confirmation can't be blank") }
      end

      describe "just user name" do
        before do
          fill_in "Name", with: "Example User"
          click_button submit
        end

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content("Name can't be blank") }
        it { should have_content("Password can't be blank") }
        it { should have_content("Email can't be blank") }
        it { should have_content('Email is invalid') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
        it { should have_content("Password confirmation can't be blank") }
      end

      describe "invalid email" do
        before do
          fill_in "Name", with: "Example User"
          fill_in "Email", with: "user@example"
          click_button submit
        end

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content("Name can't be blank") }
        it { should have_content("Password can't be blank") }
        it { should_not have_content("Email can't be blank") }
        it { should have_content('Email is invalid') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
        it { should have_content("Password confirmation can't be blank") }
      end

      describe "invalid password" do
        before do
          fill_in "Name", with: "Example User"
          fill_in "Email", with: "user@example.com"
          fill_in "Password", with: "fooba"
          click_button submit
        end

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content("Name can't be blank") }
        it { should_not have_content("Password can't be blank") }
        it { should_not have_content("Email can't be blank") }
        it { should_not have_content('Email is invalid') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
        it { should have_content("Password confirmation can't be blank") }
      end

      describe "with non-matching confirmation" do
        before do
          fill_in "Name", with: "Example User"
          fill_in "Email", with: "user@example.com"
          fill_in "Password", with: "foobar"
          fill_in "Confirmation", with: "foobarr"
          click_button submit
        end

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
        it { should_not have_content("Name can't be blank") }
        it { should_not have_content("Password can't be blank") }
        it { should_not have_content("Email can't be blank") }
        it { should_not have_content('Email is invalid') }
        it { should_not have_content('Password is too short (minimum is 6 characters)') }
        it { should_not have_content("Password confirmation can't be blank") }
        it { should have_content("Password doesn't match confirmation") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Example User"
        fill_in "Email", with: "user@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end