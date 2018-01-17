require 'test_helper'
require 'sidekiq/testing'
require 'base64'

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    Sidekiq::Testing.fake!
    @log = logs(:valid)
  end

  teardown do
    Sidekiq::Worker.drain_all
  end

  test '#new renders the form and queues the ConstructTreeWorker' do
    assert_equal 0, ConstructTreeWorker.jobs.size
    get new_profile_path
    assert_select 'form'
    assert_equal 1, ConstructTreeWorker.jobs.size
  end

  test '#delete removes a record and redirects to the index page' do
    assert_difference 'Log.count', -1 do
      post delete_profiles_path, params: { id: @log.id }
    end

    assert_redirected_to profiles_path
  end

  test '#print renders without layout and has a button' do
    get print_profiles_path, params: { id: @log.id }

    assert_template layout: false
    assert_select 'button#printpagebutton', 1
  end

  test '#analysis renders the correct prediction for a log' do
    get analysis_profiles_path, params: {
      log_id: encoder(@log.id),
      confidence: encoder(1)
    }

    assert_select 'input#confidence' do
      a = css_select 'input#confidence'
      assert_equal a.first.to_a.last.second, '1'
    end

    assert_select 'input#verdict' do
      a = css_select 'input#verdict'
      assert_equal a.first.to_a.last.second, 'approved'
    end

    assert_select 'div#ring', 1
  end

  test '#save properly updates a log and redirects to index' do
    @log.status = 0
    @log.save!

    post save_profiles_path, params: { id: @log.id }
    @log.reload

    assert_equal 'saved', @log.status
    assert_redirected_to profiles_path
  end

  test '#index displays the table and removes generated logs' do
    @log.status = 0
    @log.save!

    get profiles_path

    assert_nil Log.find_by_id(@log.id)
    assert_select 'table', 1
  end

  test '#create returns to new if the profile is invalid' do
    post profiles_path, params: bad_profile_params

    assert_template 'new'
  end

  test '#create redirects to the analysis with params and creates a log' do
    assert_difference 'Log.count', 1 do
      post profiles_path, params: profile_params
    end

    log = Log.order('created_at').last

    assert_equal 'generated', log.status
    assert_redirected_to analysis_profiles_path(
      confidence: encoder(1),
      log_id: encoder(log.id)
    )
  end

  private

  def profile_params
    {
      profile: {
        name: 'Kirill',
        age: 20,
        telephone: '(647) 888 - 9797',
        relationship_and_sex: 1,
        property_status: 1,
        housing_status: 1,
        foreign_worker: 1,
        job_status: 1,
        employment_length: 12,
        loan_duration_months: 2,
        loan_purpose: 1,
        currency: 'CAD',
        chequing_balance: 500,
        loan_amount: 100,
        other_debtors_guarantors: 1,
        credit_history: 2,
        other_loans: 1,
        value_of_savings: 1000
      }
    }
  end

  def bad_profile_params
    {
      profile: {
        name: 'Kirill',
        age: 20,
        telephone: '123',
        relationship_and_sex: nil,
        property_status: 1,
        housing_status: 1,
        foreign_worker: 1,
        job_status: 1,
        employment_length: 12,
        loan_duration_months: 2,
        loan_purpose: 1,
        currency: 'CAD',
        chequing_balance: 500,
        loan_amount: 100,
        other_debtors_guarantors: 1,
        credit_history: 2,
        other_loans: 1,
        value_of_savings: 1000
      }
    }
  end

  def encoder(val)
    Base64.urlsafe_encode64(val.to_s || '')
  end
end
