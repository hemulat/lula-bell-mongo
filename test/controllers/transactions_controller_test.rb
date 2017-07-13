require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get display" do
    get transactions_display_url
    assert_response :success
  end

  test "should get notice" do
    get transactions_notice_url
    assert_response :success
  end

  test "should get check_in" do
    get transactions_check_in_url
    assert_response :success
  end

  test "should get check_out" do
    get transactions_check_out_url
    assert_response :success
  end

end
