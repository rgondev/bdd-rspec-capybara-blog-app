require 'rails_helper'

RSpec.feature "Creating articles" do
  before do
    @john = User.create!(email: "john@example.com", password: "password")
    login_as(@john)
  end

  scenario "User creates a new article" do
    visit '/'
    click_link "New article"
    fill_in "Title", with: "Creating first article"
    fill_in "Body", with: "Lorem ipsum"
    click_button "Create Article"
    expect(page).to have_content("Article has been created")
    expect(page.current_path).to eq(articles_path)
    expect(page).to have_content("Created by: #{@john.email}")
  end

  scenario "User fails to create a new article" do
    visit '/'
    click_link "New article"
    fill_in "Title", with: ""
    fill_in "Body", with: ""
    click_button "Create Article"
    expect(page).to have_content("Article has not been created")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Body can't be blank")
  end
end