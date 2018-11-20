require 'rails_helper'

RSpec.feature "Showing article" do
  before do
    @article = Article.create(title: "First article", body: "Body of first article")
  end

  scenario "Display individual article" do
    visit "/"
    click_link @article.title
    expect(page).to have_content(@article.title)
    expect(page).to have_content(@article.body)
    expect(current_path).to have_content(article_path(@article))
  end
end