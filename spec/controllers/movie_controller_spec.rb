require 'spec_helper'

describe MoviesController do
    describe 'add_director' do
        
        before :each do 
            @movie= double(Movie, :title => "Star Wars", :director => "director", :id => '1')
            Movie.stub(:find).with('1').and_return(@movies)
        end
        
        it 'should update attribute and redirect' do
            @movie.stub!(:update_attributes!).and_return(true)
            put :update, {:id =>"1",:movie => @movie}
            response.should redirect_to(movies_path(@movie))
        end
        
    end
    
    describe 'Create and Destroy' do
        it 'should create a new movie' do
          MoviesController.stub!(:create).and_return(mock('Movie'))
          post :create, {:id => "1"}
        end
        it 'should destroy a movie' do
          m = mock(Movie, :id => "1", :title => "blah", :director => nil)
          Movie.stub!(:find).with("1").and_return(m)
          m.should_receive(:destroy)
          delete :destroy, {:id => "1"}
        end
    end
    
    describe 'GET # similar_movies' do
         before :each do 
            @movie= double(Movie, :title => "Star Wars", :director => "director", :id => '1')
            Movie.stub(:find).with('1').and_return(@movies)
        end
        it "should access the database to get similar_movies" do
            fake_results = [mock(Movie, :title => "Star Wars", :director => "director", :id => "1")]
            Movie.stub!(:similar_directors).with("director").and_return(fake_results)
            {:get => movie_similar_movies_path(@movie.id)}
        end
        it "renders the #similar_movies view" do
            {:get => movie_similar_movies_path(@movie.id)}.
            should route_to(:controller => "movies", :action => "similar_movies", :movie_id=>'1')
        end
    end
    
end