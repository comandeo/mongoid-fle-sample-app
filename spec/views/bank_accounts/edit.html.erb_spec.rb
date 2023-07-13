require 'rails_helper'

RSpec.describe "bank_accounts/edit", type: :view do
  let(:bank_account) {
    BankAccount.create!(
      name: "MyString",
      account_number: "MyString",
      account_type: "MyString",
      bank_name: "MyString",
      user: nil
    )
  }

  before(:each) do
    assign(:bank_account, bank_account)
  end

  it "renders the edit bank_account form" do
    render

    assert_select "form[action=?][method=?]", bank_account_path(bank_account), "post" do

      assert_select "input[name=?]", "bank_account[name]"

      assert_select "input[name=?]", "bank_account[account_number]"

      assert_select "input[name=?]", "bank_account[account_type]"

      assert_select "input[name=?]", "bank_account[bank_name]"

      assert_select "input[name=?]", "bank_account[user_id]"
    end
  end
end
