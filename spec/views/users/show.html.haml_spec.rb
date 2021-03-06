require 'spec_helper'

describe "users/show.html.haml" do

  let(:user) do
    Factory(:user)
  end
  before(:each) do
    user.confirm!
    sign_in user
    @registration = Registration.new
  end

  it "renders the team managers details" do
    render
    rendered.should match(/Suthen Thomas/)
    rendered.should match(/suthen.thomas@gmail.com/)
    rendered.should match(/123123123123/)
    rendered.should match(/Multimedia University/)
  end

  describe "registration section" do

    it "is closed by default" do
      render
      rendered.should have_content('Registration is currently closed')
    end

    context('when when the system setting "enable_pre_registration" is enabled') do
      before(:each) do
        Setting.stub!(:key).and_return('True')
        render
      end
      context('before the team manager has submitted his registration') do
        it "will tell the team manager that the registration is open" do
          rendered.should_not have_content('Registration is currently closed')
          rendered.should have_content('Registration is open')
        end
        it "will provide 3 text boxes to fill in the team managers  requests" do
          rendered.should have_css('input#registration_debate_teams_requested')
          rendered.should have_css('input#registration_adjudicators_requested')
          rendered.should have_css('input#registration_observers_requested')
        end
      end

      context('after the team manager has submitted his registration') do
        let(:user) do
          user = Factory(:user)
          user.confirm!
          registration = Factory(:registration, user: user)
          user.registration = registration
          user
        end

        it 'will not provide the registration form' do
          rendered.should_not have_css('form#new_registration')
        end

        it 'will display the datetime that the registration was requested' do
          rendered.should have_content('You completed pre-registration at 2011-01-01 01:01:01 UTC and requested the following slots')
        end

        it 'will display the registration details' do
          rendered.should have_content('3 debate teams')
          rendered.should have_content('1 adjudicator')
          rendered.should have_content('1 observer')
        end
      end
    end

  end


end
