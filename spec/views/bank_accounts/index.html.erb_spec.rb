require 'rails_helper'

RSpec.describe "bank_accounts/index", type: :view do
  before(:each) do
    assign(:bank_accounts, [
      BankAccount.create!(
        name: "Name",
        account_number: "Account Number",
        account_type: "Account Type",
        bank_name: "Bank Name",
        user: nil
      ),
      BankAccount.create!(
        name: "Name",
        account_number: "Account Number",
        account_type: "Account Type",
        bank_name: "Bank Name",
        user: nil
      )
    ])
  end

  it "renders a list of bank_accounts" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Account Number".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Account Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Bank Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
