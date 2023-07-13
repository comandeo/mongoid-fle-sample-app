require 'rails_helper'

RSpec.describe "bank_accounts/show", type: :view do
  before(:each) do
    assign(:bank_account, BankAccount.create!(
      name: "Name",
      account_number: "Account Number",
      account_type: "Account Type",
      bank_name: "Bank Name",
      user: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Account Number/)
    expect(rendered).to match(/Account Type/)
    expect(rendered).to match(/Bank Name/)
    expect(rendered).to match(//)
  end
end
