require "spec_helper"

describe MoviesController do
  describe :index do
    let!(:movie)  { Movie.create(:title => "blah") }

    before :each do
      get :index
    end

    it "loads all movies" do
      assigns(:movies).should_not be_nil
      assigns(:movies).should include(movie)
    end

    it "returns a webpage" do
      response.should be_success
    end
  end

  describe :new do
    context "when not logged in" do
      it "should redirect you to the home page" do
        get :new
        response.should redirect_to(movies_path)
      end
    end

    context "when logged in" do
      it "should render the web page" do
        get :new, {}, user_id: '1'
        response.should be_success
        assigns(:movie).should be_new_record
      end
    end
  end
  
  describe :create do
    context "when not logged in" do
      it "should redirect you to the home page" do
        post(:create, { :movie => { :title => "blah" } })
        response.should redirect_to(movies_path)
        Movie.count.should == 0
      end
    end
    context "when logged in" do
      it "should create a new movie" do
        get :create, { :movie => { :title => "even blaher" }}, user_id: '1'
        Movie.count.should == 1
        response.should redirect_to(movies_path)
        flash[:notice].should == "Yay!"
      end 
    end
  end
  
end
