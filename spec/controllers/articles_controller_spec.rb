require 'rails_helper'  
require 'support/controller_macros'
RSpec.describe ArticlesController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    before do
      @john = User.create!(email: "john@example.com", password: "password")
      @fred = User.create!(email: "fred@example.com", password: "password")    
    end
    context "Owner is allowed to edit his articles" do
      it "renders edit template" do
        login_user @john
        article = Article.create(title: "First article", body: "Body of first article", user: @john)

        get :edit, params: {id: article.id}
        expect(response).to render_template(:edit)
      end
    end

    context "Non-Owner is not allowed to edit other users articles" do
      it "redirects to root path" do
        article = Article.create(title: "First article", body: "Body of first article", user: @john)
        login_user @fred
        get :edit, params: {id: article.id}
        expect(response).to redirect_to(root_path)
        message = "You can only edit your own article"
        expect(flash[:danger]).to eq message
      end
    end
  end

end
