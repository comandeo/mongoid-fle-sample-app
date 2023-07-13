require 'rails_helper'

RSpec.describe "bank_accounts/new", type: :view do
  before(:each) do
    assign(:bank_account, BankAccount.new(
      name: "MyString",
      account_number: "MyString",
      account_type: "MyString",
      bank_name: "MyString",
      user: nil
    ))
  end

  it "renders new bank_account form" do
    render

    assert_select "form[action=?][method=?]", bank_accounts_path, "post" do

      assert_select "input[name=?]", "bank_account[name]"

      assert_select "input[name=?]", "bank_account[account_number]"

      assert_select "input[name=?]", "bank_account[account_type]"

      assert_select "input[name=?]", "bank_account[bank_name]"

      assert_select "input[name=?]", "bank_account[user_id]"
    end
  end
end
