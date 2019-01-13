require 'rails_helper'

RSpec.feature "Showing article" do
  before do
    @john = User.create!(email: "john@example.com", password: "password")
    @fred = User.create!(email: "fred@example.com", password: "password")
    @article = Article.create(title: "First article", body: "Body of first article", user: @john)
  end

  scenario "A non-signed user does not see edit or delete links" do
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to have_content(article_path(@article))
    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "A non-owner user cannot see both links" do
    login_as(@fred)
    visit "/"
    click_link @article.title

    expect(page).not_to have_link("Edit Article")
    expect(page).not_to have_link("Delete Article")
  end

  scenario "A signed id owner can see both links" do
    login_as(@john)
    visit "/"
    click_link @article.title
    
    expect(page).to have_link("Edit Article")
    expect(page).to have_link("Delete Article")
  end

  scenario "Display individual article" do
    visit "/"

    login_as(@john)
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to have_content(article_path(@article))
  end
end